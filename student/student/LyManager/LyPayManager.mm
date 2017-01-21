//
//  LyPayManager.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/4.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyPayManager.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyUtil.h"

#import "LyCurrentUser.h"
#import "LyOrder.h"


//支付宝
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
//#import "APAuthV2Info.h"    //新版需要，支付宝sdk版本 15.2

//银联
#import "UPPaymentControl.h"
#import "RSA_ChinaUnion.h"
#import <CommonCrypto/CommonDigest.h>
//银联-Apple Pay
#import "UPAPayPlugin.h"

//Apple Pay
#import <PassKit/PassKit.h>                                 //用户绑定的银行卡信息
#import <PassKit/PKPaymentAuthorizationViewController.h>    //Apple pay的展示控件
#import <AddressBook/AddressBook.h>                         //用户联系信息相关

//微信支付
#import "WXApi.h"






#define kURL_TN_Normal                @"http://101.231.204.84:8091/sim/getacptn"





/*
 *共7位
 *第1位固定为1
 *第2-4代表支付方式
 *第5-7代表错误码
 */
int const LyPayErrorCode_orderAbsent = 1000001;
int const LyPayErrorCode_verifyFail = 1000002;
int const LyPayErrorCode_authFail = 1000003;

int const LyPayErrorCode_aliPaySignFail = 1001001;

int const LyPayErrorCode_weChatPayPayFial = 1002001;

int const LyPayErrorCode_chinaUnionTnAbsent = 1003001;
int const LyPayErrorCode_chinaUnionCallFail = 1003002;

int const LyPayErrorCode_applePayTnAbsent = 1004001;
int const LyPayErrorCode_applePayCallFail = 1004002;
int const LyPayErrorCode_applePayCannotPay = 1004003;
int const LyPayErrorCode_applePayPayFail = 1004004;


NSString *const LyPayErrorString = @"支付出错";
NSString *const LyPayFailString = @"支付失败";



typedef NS_ENUM( NSInteger, LyPayManagerHttpMethod) {
    pmHttpMethod_null = 0,
    pmHttpMethod_auth = 100,
};


@interface LyPayManager () <LyHttpRequestDelegate, UPAPayPluginDelegate/*, PKPaymentAuthorizationViewControllerDelegate*/>
{
    LyIndicator                 *indicator_auth;
    
    BOOL                        bHttpFlag;
    LyPayManagerHttpMethod      curHttpMethod;
    
    NSInteger                   iCount;
    
    
    __weak UIViewController     *vcDelegate;
}
@end



@implementation LyPayManager

lySingle_implementation(LyPayManager)


- (instancetype)init
{
    if ( self = [super init]) {
        
    }
    
    return self;
}


- (void)setDelegate:(id<LyPayManagerDelegate>)delegate {
    _delegate = delegate;
    
    vcDelegate = (UIViewController *)_delegate;
}


+ (void)payWithMode:(LyPayMode)payMode withOrder:(LyOrder *)lyOrder andDelegate:(id<LyPayManagerDelegate>)delegate {
    [[LyPayManager sharedInstance] payWithMode:payMode withOrder:lyOrder andDelegate:delegate];
}


- (void)payWithMode:(LyPayMode)payMode withOrder:(LyOrder *)lyOrder andDelegate:(id<LyPayManagerDelegate>)delegate {
    if ( !lyOrder)
    {
        [self payError:[self packageErrInfo:YES errCode:LyPayErrorCode_orderAbsent]];
        return;
    }
    
    _order = lyOrder;
    [self setDelegate:delegate];
    
    switch ( payMode) {
        case LyPayMode_517Pay: {
            [self payBy517PayWithOrder:_order];
            break;
        }
        case LyPayMode_AliPay: {
            [self payByAliPayWithOrder:_order];
            break;
        }
//        case LyPayMode_WeChatPay: {
//            [self payByWeChatPayWithOrder:_order];
//            break;
//        }
        case LyPayMode_ChinaUnionPay: {
            [self payByChinaUnionPayWithOrder:_order];
            break;
        }
        case LyPayMode_ApplePay: {
            [self payByApplePayWithOrder:_order];
            break;
        }
    }
}


#pragma mark 通过517支付
- (void)payBy517PayWithOrder:(LyOrder *)lyOrder
{
    
}


/*
 memo = "";
 result = "partner=\"2088111222703104\"&seller_id=\"xueche517@163.com\"&out_trade_no=\"2016062711040553981019\"&subject=\"\U5e7f\U6e90\U9a7e\U6821\"&body=\"\U79d1\U76ee\U4e8c\"&total_fee=\"0.01\"&notify_url=\"http://192.168.60.206/web/zfb/Pay/doalipay\"&service=\"mobile.securitypay.pay\"&payment_type=\"1\"&_input_charset=\"utf-8\"&it_b_pay=\"30m\"&show_url=\"m.alipay.com\"&success=\"true\"&sign_type=\"RSA\"&sign=\"TZ21GIjlOegYhDs7F6W+cCMqsIRjgbXQ7J2oMOp9mxwiyOEBvGmzjHwMks48p2yKWv414WloUsWGd+W6JcJU2vQhIuuPYTTvQLOb7UohK+zDVjEHexf0OWmUV4ykbFh0FTIO5+GA5CiCk3j+vTdSiPjwel8EwbaZLRZbIOleilE=\"";
 resultStatus = 9000;
 */
#pragma mark 通过支付宝支付
- (void)payByAliPayWithOrder:(LyOrder *)lyOrder {
    
/*
    //新版本sdk代码
 
    //生成订单信息及签名
 
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = alipayAppId;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: (非必填项)仅支持JSON
//    order.format = @"";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: 回调地址
    order.notify_url = AliPayCallback_url;
    
    // NOTE: (非必填项)商户授权令牌，通过该令牌来帮助商户发起请求，完成业务(如201510BBaabdb44d8fd04607abf8d5931ec75D84)
//    order.app_auth_token = @"";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = [lyOrder orderDetail]; // NOTE: (非必填项)商品描述
    order.biz_content.subject = [[NSString alloc] initWithFormat:@"%@-订单%@", lyOrder.orderName, lyOrder.orderId]; // NOTE: 商品的标题/交易标题/订单标题/订单关键字等。//此处用订单名+订单id组成（格式为“[订单名]-订单[订单id]”）
    order.biz_content.out_trade_no = lyOrder.orderId; // NOTE: 收款支付宝用户ID。 如果该值为空，则默认为商户签约账号对应的支付宝用户ID (如 2088102147948060)
    order.biz_content.timeout_express = @"30m"; // NOTE: 该笔订单允许的最晚付款时间，逾期将关闭交易。
#if DEBUG
    order.biz_content.total_amount = @"0.01";   // NOTE: 订单总金额，单位为元，精确到小数点后两位，取值范围[0.01,100000000]
#else
    order.biz_content.total_amount = [[NSString alloc] initWithFormat:@"%.2f", lyOrder.orderPrice - lyOrder.orderPreferentialPrice];    // NOTE: 订单总金额，单位为元，精确到小数点后两位，取值范围[0.01,100000000]
#endif
    order.biz_content.seller_id = alipaySeller;    // NOTE: 收款支付宝用户ID。 如果该值为空，则默认为商户签约账号对应的支付宝用户ID (如 2088102147948060)
//    order.biz_content.product_code = @"";   // NOTE: 销售产品码，商家和支付宝签约的产品码 (如 QUICK_MSECURITY_PAY)
    
    // NOTE: sign_type设置
    order.sign_type = @"RSA";
    

    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(alipayPrivateKey);
    NSString *signedString = [signer signString:orderInfo];
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@", orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString
                                  fromScheme:studentAppScheme
                                    callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);

            [self payFinishByAliPay:resultDic];
        }];
    }
*/
    
    
    //以下为旧版sdk代码
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = alipayPartner;
    order.sellerID = alipaySeller;
    order.outTradeNO = [lyOrder orderId]; //订单ID（由商家自行制定）
    order.subject = [[NSString alloc] initWithFormat:@"%@-订单%@", lyOrder.orderName, lyOrder.orderId]; //商品标题 //学
    order.body = [lyOrder orderDetail]; //商品描述 //
    
    float amount = lyOrder.orderPrice - lyOrder.orderPreferentialPrice;
#if DEBUG
    amount = 0.01;
#endif
    order.totalFee = [[NSString alloc] initWithFormat:@"%.2f", amount];
    
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
                                  fromScheme:appSchmeStudent
                                    callback:^(NSDictionary *resultDic) {
                                        NSLog(@"reslut = %@",resultDic);
                                        
                                        [self payFinishByAliPay:resultDic];
                                        
                                    }];
    }
    else
    {
        [self payError:[self packageErrInfo:YES errCode:LyPayErrorCode_aliPaySignFail]];
    }
    
   
}





#pragma mark 通过微信支付
- (void)payByWeChatPayWithOrder:(LyOrder *)lyOrder
{
    PayReq *request = [[PayReq alloc] init];
    
    NSMutableString *nonceStr = [[NSMutableString alloc] initWithCapacity:1];
    int x = 0;
    for (int i = 0; i < 32; ++i) {
        x = arc4random() % (10 + 26);
        if (x < 10) {
            x += 48;
        } else {
            x += (65 - 10);
        }
        
        [nonceStr appendFormat:@"%c", x];
    }
    
    
    NSString *appId = @"";
    NSString *mch_id = @"";
    //nonceStr;
    
    
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:appId forKey:@"appid"];
    [dic setObject:mch_id forKey:@"mch_id"];
    
    
    NSString *strSign = @"";
    
    
    request.partnerId = @"";    //微信支付分配的商户号
    request.prepayId = @"";     //微信返回的支付交易会话ID
    request.package = @"Sign=WXPay";    //暂填写固定值Sign=WXPay
    request.nonceStr = nonceStr.copy; //随机字符串，不长于32位。推荐随机数生成算法
    request.timeStamp = [[NSDate date] timeIntervalSince1970];    //时间戳，请见接口规则-参数规定
    request.sign = @""; //签名，详见签名生成算法
    
    [WXApi sendReq:request];
}



#pragma mark 通过银联支付
- (void)payByChinaUnionPayWithOrder:(LyOrder *)lyOrder
{
    NSString *strMode = @"00";
//#if DEBUG
//    strMode = @"01";
//#else
//    strMode = @"00";
//#endif
    
    LyIndicator *indicator_getTn = [LyIndicator indicatorWithTitle:nil];
    [indicator_getTn startAnimation];
    
    [NSThread sleepForTimeInterval:sleepTime];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:_order.orderId forKey:orderIdKey];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    int amount = (int)((_order.orderPrice - _order.orderPreferentialPrice) * 100);
#if DEBUG
    amount = 1;
#endif
    [dic setObject:@(amount) forKey:priceKey];
    
    //获取 银联tn流水号（订单号）
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:getTn_url
             body:dic
             type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
           
           [indicator_getTn stopAnimation];
           
           if (error)
           {
               NSLog(@"获取银联tn失败");
               [self payError:[self packageErrInfo:YES errCode:LyPayErrorCode_chinaUnionTnAbsent]];
           }
           else
           {
               [indicator_getTn stopAnimation];
               
               NSDictionary *dic = [self analysisHttpResult:resStr];
               if (!dic)
               {
                   NSLog(@"获取银联tn失败");
                   [self payError:[self packageErrInfo:YES errCode:LyPayErrorCode_chinaUnionTnAbsent]];
                   return;
               }
               
               NSString *tn = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:resultKey]];
               if (![LyUtil validateString:tn])
               {
                   NSLog(@"获取银联tn失败");
                   [self payError:[self packageErrInfo:YES errCode:LyPayErrorCode_chinaUnionTnAbsent]];
                   return;
               }
               
               
               _order.tradeNo = tn.copy;
               
               //调用银联支付
               BOOL callFlag = [[UPPaymentControl defaultControl] startPay:tn
                                                                fromScheme:appSchmeStudent
                                                                      mode:strMode
                                                            viewController:vcDelegate];
               
               if (callFlag)
               {
                   NSLog(@"调用银联成功");
               }
               else
               {
                   NSLog(@"调用银联失败 失败 失败");
                   [self payError:[self packageErrInfo:YES errCode:LyPayErrorCode_chinaUnionCallFail]];
               }
               
           }
           
       }];

    
    
    
    
}


#pragma mark 通过Apple Pay支付
- (void)payByApplePayWithOrder:(LyOrder *)lyOrder
{
    NSString *strMode = @"00";
//#if DEBUG
//    strMode = @"01";
//#else
//    strMode = @"00";
//#endif
    
    LyIndicator *indicator_getTn = [LyIndicator indicatorWithTitle:nil];
    [indicator_getTn startAnimation];
    
    [NSThread sleepForTimeInterval:sleepTime];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    NSString *strUrl = getApplePayTn_url;
    
    [dic setObject:_order.orderId forKey:orderIdKey];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];


    int amount = (int)((_order.orderPrice - _order.orderPreferentialPrice) * 100);
#if DEBUG
    amount = 1;
#endif
    [dic setObject:@(amount) forKey:priceKey];
    
    
    //获取 银联流水号（订单号）
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:strUrl
             body:dic
             type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
           
           [indicator_getTn stopAnimation];
           
           if (error)
           {
               NSLog(@"获取银联tn失败");
               [self payError:[self packageErrInfo:YES errCode:LyPayErrorCode_applePayTnAbsent]];
           }
           else
           {
               [indicator_getTn stopAnimation];
               
               NSDictionary *dic = [self analysisHttpResult:resStr];
               if (!dic)
               {
                   NSLog(@"获取银联tn失败");
                   [self payError:[self packageErrInfo:YES errCode:LyPayErrorCode_applePayTnAbsent]];
                   return;
               }
               
               NSString *tn = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:resultKey]];
               if (![LyUtil validateString:tn])
               {
                   NSLog(@"获取银联tn失败");
                   [self payError:[self packageErrInfo:YES errCode:LyPayErrorCode_applePayTnAbsent]];
                   return;
               }
               
               
               _order.tradeNo = tn.copy;
               
               //调用Apple Pay
               if([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkChinaUnionPay]] )
               {
                   BOOL callFlag =  [UPAPayPlugin startPay:tn
                                                      mode:strMode
                                            viewController:vcDelegate
                                                  delegate:self
                                            andAPMechantID:appMerchantIdentifier];
                   if (callFlag)
                   {
                       NSLog(@"通过银联调用Apple Pay成功");
                   }
                   else
                   {
                       NSLog(@"通过银联调用Apple Pay失败 失败 失败");
                       [self payError:[self packageErrInfo:YES errCode:LyPayErrorCode_applePayCallFail]];
                   }
               }
               else
               {
                   NSLog(@"通过银联调用Apple Pay失败--银联canMakePaymentsUsingNetworks失败");
                   [self payError:[self packageErrInfo:YES errCode:LyPayErrorCode_applePayCannotPay]];
               }
               
           }
           
       }];
    
    
    /*
    
    NSArray *supportNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa, PKPaymentNetworkChinaUnionPay];
//    if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:supportNetworks])
//    {
//        NSLog(@"没有绑定支付卡片");
//        
//        [LyUtil showAlert:LyAlertForAuthorityMode_ApplePay vc:(UIViewController *)_delegate];
//        return;
//    }
    
    // 1. 创建一个支付请求
    PKPaymentRequest *payRequest = [[PKPaymentRequest alloc] init];
    // 2. 参数配置
    // 2.1 商店标识
    payRequest.merchantIdentifier = appMerchantIdentifier;
    
    // 2.2 货币代码
    payRequest.currencyCode = @"CNY";   //RMB的币种代码
    
    // 2.2 货币代码
    payRequest.countryCode = @"CN";     //国家代码
    
    // 2.4 支持的支付网络（PKPaymentNetworkChinaUnionPay iOS9.2开始支持）
    payRequest.supportedNetworks = supportNetworks;
    
    
    // 2.5 支付请求包含一个支付摘要项目的列表
    // 2.5.1 总价
    NSDecimalNumber *totalPrice = [[NSDecimalNumber alloc] initWithFloat:lyOrder.orderPrice];
    PKPaymentSummaryItem *totalPriceSummary = [PKPaymentSummaryItem summaryItemWithLabel:@"总价" amount:totalPrice];
    
    float fPPrice = 0.0f;
#if DEBUG
    fPPrice = lyOrder.orderPrice = 0.01f;
#else
    fPPrice = lyOrder.orderPreferentialPrice;
#endif
    
    // 2.5.2 优惠
    NSDecimalNumber *preferentialPrice = [[NSDecimalNumber alloc] initWithFloat:fPPrice];
    PKPaymentSummaryItem *preferentialPriceSummary = [PKPaymentSummaryItem summaryItemWithLabel:@"优惠" amount:preferentialPrice];
    
    //2.5.3 最后价格
    NSDecimalNumber *ultimatePrice = [NSDecimalNumber zero];
    ultimatePrice = [ultimatePrice decimalNumberByAdding:totalPrice];
    ultimatePrice = [ultimatePrice decimalNumberByAdding:preferentialPrice];
    PKPaymentSummaryItem *ultimatePriceSummary = [PKPaymentSummaryItem summaryItemWithLabel:@"我要去学车" amount:ultimatePrice];
    NSArray *arrSummary = @[totalPriceSummary, preferentialPriceSummary, ultimatePriceSummary];
    payRequest.paymentSummaryItems = arrSummary;
    
    
    // 2.6 运输方式
    //无
    
     // 2.7 通过指定merchantCapabilities属性来指定你支持的支付处理标准，3DS支付方式是必须支持的，EMV方式是可选的，
    payRequest.merchantCapabilities = PKMerchantCapability3DS | PKMerchantCapabilityEMV | PKMerchantCapabilityCredit | PKMerchantCapabilityDebit;      //设置支持的交易处理协议，3DS必须支持，EMV为可选，目前国内的话还是使用两者吧
    
    // 2.8 需要的配送信息和账单信息//    payRequest.requiredShippingAddressFields = PKAddressFieldPostalAddress | PKAddressFieldPhone | PKAddressFieldName;
    payRequest.requiredShippingAddressFields = PKAddressFieldNone;
    //送货地址信息，这里设置需要地址和联系方式和姓名，如果需要进行设置，默认PKAddressFieldNone(没有送货地址)
    
    //    payRequest.requiredBillingAddressFields = PKAddressFieldEmail;
    payRequest.requiredBillingAddressFields = PKAddressFieldNone;
    //如果需要邮寄账单可以选择进行设置，默认PKAddressFieldNone(不邮寄账单)
    //楼主感觉账单邮寄地址可以事先让用户选择是否需要，否则会增加客户的输入麻烦度，体验不好，
    
    
    // 2.9 存储额外信息
    // 使用applicationData属性来存储一些在你的应用中关于这次支付请求的唯一标识信息，比如一个购物车的标识符。在用户授权支付之后，这个属性的哈希值会出现在这次支付的token中。
    payRequest.applicationData = [[[NSString alloc] initWithFormat:@"%@-订单%@", lyOrder.orderName, lyOrder.orderId] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    // 3. 开始支付
    //ApplePay控件
    PKPaymentAuthorizationViewController *payVC = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:payRequest];
    if (!payVC)
    {
        NSLog(@"PKPaymentAuthorizationViewController 创建失败");
        return;
    }
    payVC.delegate = self;
    [vcDelegate presentViewController:payVC animated:YES completion:nil];
     */
    
}










- (void)payFinished:(LyPayMode)aPayMode andResult:(id)result
{
    switch (aPayMode) {
        case LyPayMode_517Pay: {
            
            break;
        }
        case LyPayMode_AliPay: {
            [self payFinishByAliPay:result];
            break;
        }
//        case LyPayMode_WeChatPay: {
//            [self payFinishByWeChatPay:result];
//            break;
//        }
        case LyPayMode_ChinaUnionPay: {
            NSDictionary *dicResult = (NSDictionary *)result;
            [self payFinishByChinaUnoinPay:[dicResult objectForKey:@"code"]
                                      data:[dicResult objectForKey:@"data"]];
            break;
        }
        case LyPayMode_ApplePay: {
            //nothing
            break;
        }
    }
}



#pragma mark 517支付完成
- (void)payFinishBy517Pay:(NSString *)result
{
    
}

#pragma mark 支付宝支付完成
- (void)payFinishByAliPay:(NSDictionary *)resultDic
{
    if ( !resultDic || ![resultDic count])
    {
        [self payFailed:nil];
        return;
    }
    
    NSLog(@"AliPay--%@", resultDic);
    
    NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
    NSString *result = [resultDic objectForKey:@"result"];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    if (![LyUtil validateString:resultStatus] || ![LyUtil validateString:result]) {
        if ( [resultStatus isEqualToString:@"6001"]) {
            //取消
            [self payCancel];
        } else {
            //失败
            [self payFailed:nil];
        }
    } else {
        if ( [result rangeOfString:@"success=\"true\""].length > 0 && [resultStatus isEqualToString:@"9000"]) {
            //成功
//            NSDictionary *dicResult = [LyUtil dicFormAliPayString:result];
            
            [_order setOrderPaidNum:_order.orderPrice - _order.orderPreferentialPrice];
            [self authOrderStateWithOrderId:_order.orderId];
        }
        else {
            if ( [resultStatus isEqualToString:@"6001"]) {
                //取消
                [self payCancel];
            } else {
                //失败
                [self payFailed:nil];
            }
        }
    }

}

#pragma mark 微信支付完成
- (void)payFinishByWeChatPay:(BaseResp *)result
{
    if ([result isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)result;
        switch(response.errCode) {
            case WXSuccess: {
                //服务器端查询支付通知或查询API返回的结果再提示成功
//                NSLog(@"支付成功");
                
                [_order setOrderPaidNum:_order.orderPrice - _order.orderPreferentialPrice];
                [self authOrderStateWithOrderId:_order.orderId];

                break;
            }
            default: {
//                NSLog(@"支付失败，retcode=%d",result.errCode);
                [self payFailed:[self packageErrInfo:NO errCode:LyPayErrorCode_weChatPayPayFial]];
                break;
            }
        }
    }
}

#pragma mark 银联支付完成
- (void)payFinishByChinaUnoinPay:(NSString *)code data:(NSDictionary *)data
{
    /*
     NSDictionary *data结构如下：
     sign —— 签名后做Base64的数据
     data —— 用于签名的原始数据，结构如下：
     pay_result —— 支付结果success，fail，cancel
     tn          —— 订单号
     Data转换为String后的示例如下：
     "{"sign":"ZnZY4nqFGu/ugcXNIhniJh6UDVriWANlHtIDRzV9w120E6tUgpL9Z7jIFzWrSV73hmrkk8BZMXMc/9b8u3Ex1ugnZn0OZtWfMZk2I979dxp2MmOB+1N+Zxf8iHr7KNhf9xb+VZdEydn3Wc/xX/B4jncg0AwDJO/0pezhSZqdhSivTEoxq7KQTq2KaHJmNotPzBatWI5Ta7Ka2l/fKUv8zr6DGu3/5UaPqHhnUq1IwgxEWOYxGWQgtyTMo/tDIRx0OlXOm4iOEcnA9DWGT5hXTT3nONkRFuOSyqS5Rzc26gQE6boD+wkdUZTy55ns8cDCdaPajMrnuEByZCs70yvSgA==","data":"pay_result=success&tn=201512151321481233778"}"     
     */
    
    NSLog(@"银联支付完成：code=%@---data=%@", code, data);
    
    //结果code为成功时，先校验签名，校验成功后做后续处理
    if([code isEqualToString:@"success"])
    {
        NSLog(@"开始交易");
        //判断签名数据是否存在
        if(data == nil){
            //如果没有签名数据，建议商户app后台查询交易结果
            NSLog(@"缺少签名");
            return;
        }
        
        /*
        //数据从NSDictionary转换为NSString
        NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                           options:0
                                                             error:nil];
        NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
        
        if (!sign)
        {
            //如果没有签名数据，建议商户app后台查询交易结果
            return;
        }
        
        //验签证书同后台验签证书
        //此处的verify，商户需送去商户后台做验签
        if([self verify:sign])
        {
            //支付成功且验签成功，展示支付成功提示
        }
        else
        {
            //验签失败，交易结果数据被篡改，商户app后台查询交易结果
        }
         */
        
        [_order setOrderPaidNum:_order.orderPrice - _order.orderPreferentialPrice];
        //        _order.tradeNo = data[@"tn"];
        [self authOrderStateWithOrderId:_order.orderId];
        
    }
    else if([code isEqualToString:@"fail"])
    {
        //交易失败
        [self payFailed:nil];
    }
    else if([code isEqualToString:@"cancel"])
    {
        //交易取消
        [self payCancel];
    }
}



#pragma mark Apple Pay支付完成
- (void)payFinishedByApplyPay:(NSString *)result
{
    NSDictionary *dic = [LyUtil getDicFromHttpBodyStr:result];
    NSString *order_amt = [[NSString alloc] initWithFormat:@"%@", dic[@"order_amt"]];
    NSString *pay_amt = [[NSString alloc] initWithFormat:@"%@", dic[@"pay_amt"]];
    
    if ([LyUtil validateString:order_amt] && [LyUtil validateString:pay_amt]) {
        _discount = order_amt.floatValue - pay_amt.floatValue;
        
        [_order setOrderPaidNum:pay_amt.floatValue];
    }
    
    if (_discount < 0.0f) {
        _discount = 0.0f;
    }
    
    [self authOrderStateWithOrderId:_order.orderId];
}


#pragma mark 向服务器验证订单状态
- (void)authOrderStateWithOrderId:(NSString *)orderId {
    if ( !orderId) {
        return;
    }
    
    if ( !indicator_auth) {
        indicator_auth = [LyIndicator indicatorWithTitle:@"正在验证"];
    }
    [indicator_auth startAnimation];
    
    [self performSelector:@selector(delayAuthOrderStateWithOrderId:) withObject:orderId afterDelay:1.5f];
}

- (void)delayAuthOrderStateWithOrderId:(NSString *)orderId {
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:confirmPayState_url
                    body:@{
                           orderIdKey:orderId,
                           userIdKey:[LyCurrentUser curUser].userId,
                           sessionIdKey:[LyUtil httpSessionId]
                           }
                    type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
           if (error) {
               [self payFailed:[self packageErrInfo:NO errCode:LyPayErrorCode_verifyFail]];
               
           } else {
               NSDictionary *dic = [self analysisHttpResult:resStr];
               if (!dic) {
                   [self payFailed:[self packageErrInfo:NO errCode:LyPayErrorCode_verifyFail]];
                   return ;
               }
               
               NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
               switch (strCode.integerValue) {
                   case 0: {
                       NSDictionary *dicResult = [dic objectForKey:resultKey];
                       if (![LyUtil validateDictionary:dicResult]) {
                           [self payFailed:[self packageErrInfo:NO errCode:LyPayErrorCode_authFail]];
                           return ;
                       }
                       
                       NSString *state = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:orderStateKey]];
                       LyOrderState state__ = (LyOrderState)state.integerValue;
                       
                       if (state__ >= LyOrderState_waitConfirm) {
                           
                           NSString *payTime = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:@"gmt_payment"]];
                           NSString *paidNum = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:paidNumKey]];
                           
                           [_order setOrderState:state__];
                           [_order setOrderPayTime:payTime];
                           [_order setOrderPaidNum:paidNum.floatValue];
                           
                           [self paySuccess];
                       } else {
                           [self payFailed:[self packageErrInfo:NO errCode:LyPayErrorCode_authFail]];
                       }
                       
                       break;
                   }
                   default: {
                       [self payFailed:[self packageErrInfo:NO errCode:LyPayErrorCode_verifyFail]];
                       break;
                   }
               }
           }
       }];
}



- (NSDictionary *)analysisHttpResult:(NSString *)result {
    NSDictionary *dic = [LyUtil getObjFromJson:result];
    if (![LyUtil validateDictionary:dic]) {
        return nil;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (![LyUtil validateString:strCode]) {
        return nil;
    }
    
    if (codeTimeOut == strCode.integerValue) {
        [LyUtil sessionTimeOut:vcDelegate];
        return nil;
    }
    
    if (codeMaintaining == strCode.integerValue) {
        [LyUtil serverMaintaining];
        return nil;
    }
    
    return dic;
}


- (void)paySuccess {
    [indicator_auth stopAnimation];
    [_delegate onPaySuccessedByPayManager:self withOrder:_order discount:_discount];
}

- (void)payFailed:(NSString *)errInfo {
    [indicator_auth stopAnimation];
    [_delegate onPayFailedByPayManager:self withOrder:_order errInfo:errInfo];
}

- (void)payError:(NSString *)errInfo {
    [indicator_auth stopAnimation];
    [_delegate onPayErrorByPayManager:self withOrder:_order errInfo:errInfo];
}

- (void)payCancel {
    [indicator_auth stopAnimation];
    [_delegate onPayCanceledByPayManager:self withOrder:_order];
}


- (NSString *)packageErrInfo:(BOOL)isError errCode:(int)errCode
{
    return [[NSString alloc] initWithFormat:@"%@[%d]", isError ? @"支付出错" : @"支付失败", errCode];
}


#pragma mark -UPAPayPluginDelegate
/**
 *  支付结果回调函数
 *
 *  @param payResult   以UPPayResult结构向商户返回支付结果
 */

/*
 @interface UPPayResult:NSObject
 @property UPPaymentResultStatus paymentResultStatus; 
 UPPaymentResultStatus，表示四个支付状态返回值，结构如下:
 typedef NS_ENUM(NSInteger,UPPaymentResultStatus) {
 UPPaymentResultStatusSuccess,  //支付成功
 UPPaymentResultStatusFailure,  //支付失败
 UPPaymentResultStatusCancel,   //支付取消
 UPPaymentResultStatusUnknownCancel //支付取消，交易已发起，状态不确定，商户需查询商户后台确认
 支付状态
 };
 
 @property (nonatomic,strong) NSString* errorDescription;   //表示支付失败时候服务器返回的错误描述，包括文字信 息与应答码两部分。
 例如: errorDescription 字段内容为“可用余额不足[1000051]“，此信 息前半部分为文字错误信息，后 7 位为错误应答码。当支付成功或支付取消的时 候 errorDescription 取值为 nil。
 
 @property (nonatomic,strong) NSString* otherInfo;  //otherInfo，目前表示成功支付时包含的优惠信息。
 例如: otherInfo 为“currency=元&order_amt=20.00&pay_amt=15.00 “， 其中 currency 表示币种，order_amt 表示订单金额，pay_amt 表示实付 金额。
 @end
 */

- (void) UPAPayPluginResult:(UPPayResult *) payResult
{
    
    
    if(payResult.paymentResultStatus == UPPaymentResultStatusSuccess)
    {
        NSString *otherInfo = payResult.otherInfo ? payResult.otherInfo : @"";
        NSString *successInfo = [NSString stringWithFormat:@"支付成功\n%@",otherInfo];
        
        NSLog(@"UPAPayPluginResult---%@", successInfo);
        
        
        
        [self payFinishedByApplyPay:otherInfo];
    }
    else if(payResult.paymentResultStatus == UPPaymentResultStatusCancel)
    {
        NSLog(@"用户取消交易");
        
//        [_delegate onPayCanceledByPayManager:self withOrder:_order];
        [self payCancel];
        
    }
    else if (payResult.paymentResultStatus == UPPaymentResultStatusFailure)
    {
        NSString *errorInfo = [NSString stringWithFormat:@"%@",payResult.errorDescription];
        NSLog(@"UPAPayPluginResult--%@", errorInfo);
        
        [self payError:[self packageErrInfo:YES errCode:LyPayErrorCode_applePayPayFail]];
        
    }
    else if (UPPaymentResultStatusUnknownCancel == payResult.paymentResultStatus)
    {
//        //TODO UPPAymentResultStatusUnknownCancel表示发起支付以后用户取消，导致支付状态不确认，需 要查询商户后台确认真实的支付结果
        NSString *errorInfo = [NSString stringWithFormat:@"支付过程中用户取消了，请查询后台确认订单"];
        NSLog(@"%@", errorInfo);

        [self payCancel];
    }
}


/*
#pragma mark -PKPaymentAuthorizationViewControllerDelegate
// Sent to the delegate after the user has acted on the payment request.  The application
// should inspect the payment to determine whether the payment request was authorized.
//
// If the application requested a shipping address then the full addresses is now part of the payment.
//
// The delegate must call completion with an appropriate authorization status, as may be determined
// by submitting the payment credential to a processing gateway for payment authorization.
// 如果当用户授权成功, 就会调用这个方法
// 参数一: 授权控制器
// 参数二 : 支付对象
// 参数三: 系统给定的一个回调代码块, 我们需要执行这个代码块, 来告诉系统当前的支付状态是否成功.
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    NSLog(@"验证授权---%@", payment.token);
    NSLog(@"验证通过后, 需要开发者继续完成交易");
    // 它需要你连接服务器并上传支付令牌和 其他信息，以完成整个支付流程。
    BOOL isSuccess = YES;
    if (isSuccess)
    {
        completion(PKPaymentAuthorizationStatusSuccess);
    }
    else
    {
        completion(PKPaymentAuthorizationStatusFailure);
    }
}


// Sent to the delegate when payment authorization is finished.  This may occur when
// the user cancels the request, or after the PKPaymentAuthorizationStatus parameter of the
// paymentAuthorizationViewController:didAuthorizePayment:completion: has been shown to the user.
//
// The delegate is responsible for dismissing the view controller in this method.
// 当用户授权成功, 或者取消授权时调用
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    NSLog(@"取消或者交易完成");
    [controller dismissViewControllerAnimated:YES completion:nil];
}

*/






@end
