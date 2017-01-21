//
//  LyPayManager.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/4.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyPayManager.h"

#import "LyIndicator.h"

#import "LyUtil.h"

#import "LyCurrentUser.h"
#import "LyOrder.h"


#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>



typedef NS_ENUM( NSInteger, LyPayManagerHttpMethod)
{
    pmHttpMethod_pay = 1,
};


@interface LyPayManager () <LyHttpRequestDelegate>
{
    LyIndicator                 *indicator_auth;
    
    BOOL                        bHttpFlag;
    LyPayManagerHttpMethod      curHttpMethod;
    
    NSInteger                   iCount;
}
@end



@implementation LyPayManager

lySingle_implementation(LyPayManager)

static NSString *aliPay_privateKey = @"";


- (instancetype)init
{
    if ( self = [super init])
    {
        
    }
    
    return self;
}

+ (void)payWithMode:(LyPayMode)payMode withOrder:(LyOrder *)lyOrder andDelegate:(id<LyPayManagerDelegate>)delegate
{
    [[LyPayManager sharedInstance] payWithMode:payMode withOrder:lyOrder andDelegate:delegate];
}


- (void)payWithMode:(LyPayMode)payMode withOrder:(LyOrder *)lyOrder andDelegate:(id<LyPayManagerDelegate>)delegate
{
    if ( !lyOrder)
    {
        [_delegate onPayErrorByPayManager:self withOrder:lyOrder];
        return;
    }
    
    _order = lyOrder;
    _delegate = delegate;
    
    switch ( payMode) {
        case LyPayMode_517Pay: {
            [self payBy517PayWithOrder:lyOrder];
            break;
        }
        case LyPayMode_AliPay: {
            [self payByAliPayWithOrder:lyOrder];
            break;
        }
        case LyPayMode_ChinaUnionPay: {
            [self payByChinaUnionPayWithOrder:lyOrder];
            break;
        }
        case LyPayMode_WeChatPay: {
            [self payByWeChatPayWithOrder:lyOrder];
            break;
        }
    }
}


- (void)payBy517PayWithOrder:(LyOrder *)lyOrder
{
    
}


/*
 memo = "";
 result = "partner=\"2088111222703104\"&seller_id=\"xueche517@163.com\"&out_trade_no=\"2016062711040553981019\"&subject=\"\U5e7f\U6e90\U9a7e\U6821\"&body=\"\U79d1\U76ee\U4e8c\"&total_fee=\"0.01\"&notify_url=\"http://192.168.60.206/web/zfb/Pay/doalipay\"&service=\"mobile.securitypay.pay\"&payment_type=\"1\"&_input_charset=\"utf-8\"&it_b_pay=\"30m\"&show_url=\"m.alipay.com\"&success=\"true\"&sign_type=\"RSA\"&sign=\"TZ21GIjlOegYhDs7F6W+cCMqsIRjgbXQ7J2oMOp9mxwiyOEBvGmzjHwMks48p2yKWv414WloUsWGd+W6JcJU2vQhIuuPYTTvQLOb7UohK+zDVjEHexf0OWmUV4ykbFh0FTIO5+GA5CiCk3j+vTdSiPjwel8EwbaZLRZbIOleilE=\"";
 resultStatus = 9000;
 */
- (void)payByAliPayWithOrder:(LyOrder *)lyOrder
{
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = alipayPartner;
    order.sellerID = alipaySeller;
    order.outTradeNO = [lyOrder orderId]; //订单ID（由商家自行制定）
    order.subject = [[NSString alloc] initWithFormat:@"%@-订单%@", [lyOrder orderName], [lyOrder orderId]]; //商品标题 //学
    order.body = [lyOrder orderDetail]; //商品描述 //
    
#if DEBUG
    order.totalFee = @"0.01";
#else
    order.totalFee = [[NSString alloc] initWithFormat:@"%.2f", [lyOrder orderPrice]-[lyOrder orderPreferentialPrice]];
#endif
    order.notifyURL =  AliPayCallback_url; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(alipayPrivateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    NSString *orderString = nil;
    if (signedString != nil)
    {
        orderString = [[NSString alloc] initWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        NSLog(@"orderString = %@", orderString);
        
        [[AlipaySDK defaultService] payOrder:orderString
                                  fromScheme:@"student517xueche"
                                    callback:^(NSDictionary *resultDic) {
                                        NSLog(@"reslut = %@",resultDic);
                                        
                                        [self payFinishByAliPay:resultDic];
                                        
                                    }];
    }
    
    
   
}




- (void)payByChinaUnionPayWithOrder:(LyOrder *)lyOrder
{
    
}




- (void)payByWeChatPayWithOrder:(LyOrder *)lyOrder
{
    
}








- (void)payFinished:(LyPayMode)aPayMode andResult:(id)result
{
    switch ( aPayMode) {
        case LyPayMode_517Pay: {
            
            break;
        }
        case LyPayMode_AliPay: {
            [self payFinishByAliPay:result];
            break;
        }
        case LyPayMode_ChinaUnionPay: {
            
            break;
        }
        case LyPayMode_WeChatPay: {
            
            break;
        }
    }
}



- (void)payFinishByAliPay:(NSDictionary *)resultDic
{
    if ( !resultDic || ![resultDic count])
    {
        [_delegate onPayFailedByPayManager:self withOrder:_order];
        return;
    }
    
    NSLog(@"AliPay--%@", resultDic);
    
    NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
    NSString *result = [resultDic objectForKey:@"result"];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
//    if ( !resultStatus || !result || [resultStatus isKindOfClass:[NSNull class]] || [result isKindOfClass:[NSNull class]] || [resultStatus isEqualToString:@""] || [result isEqualToString:@""])
    if (![LyUtil validateString:resultStatus] || ![LyUtil validateString:result]) {
        if ( [resultStatus isEqualToString:@"6001"]) {
            //取消
            [_delegate onPayCanceledByPayManager:self withOrder:_order];
        } else {
            //失败
            [_delegate onPayFailedByPayManager:self withOrder:_order];
        }
    } else {
        if ( [result rangeOfString:@"success=\"true\""].length > 0 && [resultStatus isEqualToString:@"9000"]) {
            //成功
            NSDictionary *dicResult = [LyUtil dicFormAliPayString:result];
            [self authOrderStateWithOrderId:[dicResult objectForKey:@"out_trade_no"]];
        }
        else {
            if ( [resultStatus isEqualToString:@"6001"]) {
                //取消
                [_delegate onPayCanceledByPayManager:self withOrder:_order];
            } else {
                //失败
                [_delegate onPayFailedByPayManager:self withOrder:_order];
            }
        }
    }

}

- (void)payFinishBy517Pay:(NSString *)result
{
    
}

- (void)payFinishByChinaUnoinPay:(NSString *)result
{
    
}


- (void)payFinishByWeChatPay:(NSString *)result
{
    
}



- (BOOL)authOrderStateWithOrderId:(NSString *)orderId
{
    if ( !orderId)
    {
        return NO;
    }
    
    if ( !indicator_auth)
    {
        indicator_auth = [LyIndicator indicatorWithTitle:@"正在验证"];
    }
    [indicator_auth start];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:pmHttpMethod_pay];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:confirmPayState_url
                                                requestBody:@{
                                                              orderIdKey:[_order orderId],
                                                              userIdKey:[[LyCurrentUser currentUser] userId],
                                                              sessionIdKey:[LyUtil httpSessionId]
                                                              }
                                                requestType:AsynchronousPost
                                                    timeOut:0] boolValue];

    
    return YES;
}




- (void)analysisHttpResult:(NSString *)result
{
    NSDictionary *dic = [LyUtil getObjFromJson:result];
    if ( !dic || [dic isKindOfClass:[NSNull class]] || ![dic count])
    {
        curHttpMethod = 0;
        
        return;
    }
    
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if ( !strCode || [strCode isKindOfClass:[NSNull class]] || [strCode isEqualToString:@""])
    {
        curHttpMethod = 0;
        
        return;
    }
    
    
    switch ( curHttpMethod) {
        case pmHttpMethod_pay: {
            curHttpMethod = 0;
            
            switch ( [strCode integerValue]) {
                case 0: {
                    NSString *strResult = [dic objectForKey:resultKey];
                    
                    if ( !strResult || [strResult isKindOfClass:[NSNull class]] || [NSNull null] == (NSNull *)strResult || [strResult rangeOfString:@"null"].length > 0 || [strResult length] < 1 || [strResult isEqualToString:@""] )
                    {
                        [_delegate onPayFailedByPayManager:self withOrder:_order];
                    }
                    else if ( [strResult isEqualToString:@"1"])
                    {
                        [_delegate onPaySuccessedByPayManager:self withOrder:_order];
                    }
                    else
                    {
                        [_delegate onPayFailedByPayManager:self withOrder:_order];
                    }
                    
                    [indicator_auth stop];
                    iCount = 0;
                    
                    break;
                }
                case 1 : {
                    if ( iCount++ < 2)
                    {
                        [self authOrderStateWithOrderId:[_order orderId]];
                    }
                    else
                    {
                        [_delegate onPayFailedByPayManager:self withOrder:_order];
                        [indicator_auth stop];
                        iCount = 0;
                    }
                    break;
                }
                default: {
                    if ( iCount++ < 2)
                    {
                        [self authOrderStateWithOrderId:[_order orderId]];
                    }
                    else
                    {
                        [_delegate onPayFailedByPayManager:self withOrder:_order];
                        [indicator_auth stop];
                        iCount = 0;
                    }
                    break;
                }
            }
            break;
        }
        default: {
            
            break;
        }
    }
    
    
}




#pragma mark -LyHttpRequestDelegate
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result
{
    if ( bHttpFlag)
    {
        bHttpFlag = NO;
        curHttpMethod = 0;
        [indicator_auth stop];
        [self authOrderStateWithOrderId:[_order orderId]];
    }
}

- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result
{
    if ( bHttpFlag)
    {
        bHttpFlag = NO;
        curHttpMethod = ahttpRequest.mode;
        [self analysisHttpResult:result];
    }
}





@end
