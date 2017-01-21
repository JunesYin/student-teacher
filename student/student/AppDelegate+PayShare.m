//
//  AppDelegate+PayShare.m
//  student
//
//  Created by MacMini on 2017/1/16.
//  Copyright © 2017年 517xueche. All rights reserved.
//

#import "AppDelegate+PayShare.h"

#import "LyPayManager.h"

#import "LyUtil.h"



//支付宝支付
#import <AlipaySDK/AlipaySDK.h>

//银联支付
#import "UPPaymentControl.h"

//sharedSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>


//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"



NSString *const callBackHost_Alipay = @"safepay";
NSString *const callBackHost_ChinaUnion = @"uppayresult";



@interface AppDelegate ()  <WeiboSDKDelegate, WXApiDelegate>

@end



@implementation AppDelegate (PayShare)



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //    if ( [url.description rangeOfString:@"student517xueche"].length > 0)
    //    {
    //
    //    }
    //    else
    if ([url.host isEqualToString:callBackHost_Alipay])
    {
        [self payCallBack_AliPay:url];
    }
    else if ([url.host isEqualToString:callBackHost_ChinaUnion])
    {
        [self payCallBack_ChinaUnion:url];
    }
    else if ( [url.description rangeOfString:@"QQ41E2F407"].length > 0)
    {
        [self callBack_QQ:url];
    }
    else if ( [url.description rangeOfString:weChatAppId].length > 0)
    {
        [self callBack_WeChat:url];
    }
    else
    {
        [self callBack_WeiBo:url];
    }
    
    
    
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation
{
    //    if ( [url.description rangeOfString:@"student517xueche"].length > 0)
    //    {
    //        NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
    //        NSLog(@"URL scheme:%@", [url scheme]);
    //        NSLog(@"URL query: %@", [url query]);
    //    }
    //    else
    if ([url.host isEqualToString:callBackHost_Alipay])
    {
        [self payCallBack_AliPay:url];
    }
    else if ([url.host isEqualToString:callBackHost_ChinaUnion])
    {
        [self payCallBack_ChinaUnion:url];
    }
    else if ( [url.description rangeOfString:@"QQ41E2F407"].length > 0)
    {
        [self callBack_QQ:url];
    }
    else if ( [url.description rangeOfString:weChatAppId].length > 0)
    {
        [self callBack_WeChat:url];
    }
    else
    {
        [self callBack_WeiBo:url];
    }
    
    
    
    return YES;
}



- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //    if ( [url.description rangeOfString:@"student517xueche"].length > 0)
    //    {
    //
    //    }
    //    else
    
    if ([url.host isEqualToString:callBackHost_Alipay])
    {
        [self payCallBack_AliPay:url];
    }
    else if ([url.host isEqualToString:callBackHost_ChinaUnion])
    {
        [self payCallBack_ChinaUnion:url];
    }
    else if ( [url.description rangeOfString:@"QQ41E2F407"].length > 0)
    {
        [self callBack_QQ:url];
    }
    else if ( [url.description rangeOfString:weChatAppId].length > 0)
    {
        [self callBack_WeChat:url];
    }
    else
    {
        [self callBack_WeiBo:url];
    }
    
    
    
    return YES;
}



//支付宝支付回调
- (void)payCallBack_AliPay:(NSURL *)url
{
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        //            NSLog(@"result = %@",resultDic);
        
        [[LyPayManager sharedInstance] payFinished:LyPayMode_AliPay
                                         andResult:resultDic];
    }];
}





//银联支付回调
- (void)payCallBack_ChinaUnion:(NSURL *)url
{
    
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:code forKey:@"code"];
        
        if (data)
        {
            [dic setObject:data forKey:@"data"];
        }
        
        [[LyPayManager sharedInstance] payFinished:LyPayMode_ChinaUnionPay
                                         andResult:dic];
    }];
}



//QQ回调
- (void)callBack_QQ:(NSURL *)url
{
    NSLog(@"callBack_QQ  url : %@", url);
    [TencentOAuth HandleOpenURL:url];
}

//微博回调
- (void)callBack_WeiBo:(NSURL *)url
{
    NSLog(@"callBack_WeiBo  url : %@", url);
    [WeiboSDK handleOpenURL:url delegate:self];
}

//微信回调
- (void)callBack_WeChat:(NSURL *)url
{
    NSLog(@"callBack_WeChat  url : %@", url);
    
    [WXApi handleOpenURL:url delegate:self];
}



#pragma mark -WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    NSLog(@"didReceiveWeiboRequest");
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    NSLog(@"didReceiveWeiboResponse");
}



#pragma mark WXApiDelegate
-(void) onReq:(BaseReq*)req
{
    NSLog(@"onReq--req: type = %d-----openID = %@", req.type, req.openID);
    
    
}

-(void) onResp:(BaseResp*)resp
{
    NSLog(@"onResp--resp: errCode = %d-----errStr = %@----type = %d", resp.errCode, resp.errStr, resp.type);
    
    if ([resp isKindOfClass:[PayResp class]]) {
        //        [[LyPayManager sharedInstance] payFinished:LyPayMode_WeChatPay andResult:resp];
    }
}

@end
