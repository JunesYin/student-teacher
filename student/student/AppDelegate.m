//
//  AppDelegate.m
//  student
//
//  Created by Junes on 16/8/15.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "AppDelegate.h"

#import "UIViewController+Utils.h"
#import "LyCurrentUser.h"


#import "LyRootViewController.h"
#import "LyLoginViewController.h"

#import "LyPayManager.h"

#import "LyPushManager.h"
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

//


#import "JPUSHService.h"
//#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

//#import "student-Swift.h"
//#import "LyOrderCenterViewController.h"
//#import "LyBottomControl.h"

#import "AppDelegate+JPush.h"



//NSString *const callBackHost_Alipay = @"safepay";
//NSString *const callBackHost_ChinaUnion = @"uppayresult";




@interface AppDelegate () <JPUSHRegisterDelegate>
{
    NSDate              *enterBackDate;
    
    NSDictionary        *lastUserInfo;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /*
     add by junes 2016.11.3
     reson : cannot load pic from https server
     */
//    [[SDWebImageManager sharedManager].imageDownloader setValue: nil forHTTPHeaderField:@"Accept"];
    
    [[LyPushManager sharedInstance] addObserverForJPushNotification];
    
    
    [UINavigationBar appearance].tintColor = Ly517ThemeColor;
    
    
    _window = [[UIWindow alloc]initWithFrame:SCREEN_BOUNDS];
    [_window setBackgroundColor:[UIColor whiteColor]];
    [_window setRootViewController:[LyRootViewController sharedInstance]];
    
    
    [_window makeKeyAndVisible];
    
//    if ( UIUserNotificationTypeNone != [[application currentUserNotificationSettings] types]) {
//        [self addLocalNotification];
//    } else {
    if (UIUserNotificationTypeNone == application.currentUserNotificationSettings.types) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound  categories:nil]];
    }
    
    
    /* register remote notification */
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if (!application.isRegisteredForRemoteNotifications) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil];
            
            [application registerUserNotificationSettings:settings];
            [application registerForRemoteNotifications];
        }
        [application setApplicationIconBadgeNumber:0];
//    }
//    else
//#endif
//    {
//        if (![application enabledRemoteNotificationTypes]) {
//            [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeNewsstandContentAvailability | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//        }
//        [application setApplicationIconBadgeNumber:0];
//    }

    
    //ShardSDK分享
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。我们Demo提供的appKey为内部测试使用，可能会修改配置信息，请不要使用。
     *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:shareSDKAppKey
          activePlatforms:@[
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat)
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType) {
                         case SSDKPlatformTypeQQ: {
                             [ShareSDKConnector connectQQ:[QQApiInterface class]
                                        tencentOAuthClass:[TencentOAuth class]];
                             break;
                         }
                         case SSDKPlatformTypeSinaWeibo: {
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         }
                         case SSDKPlatformTypeWechat: {
//                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
                         }
                         default: {
                             //nothing
                             break;
                         }
                     }
                 } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                     switch (platformType) {
                         case SSDKPlatformTypeQQ: {
                             [appInfo SSDKSetupQQByAppId:qqAppId
                                                  appKey:qqAppKey
                                                authType:SSDKAuthTypeBoth];
                             break;
                         }
                         case SSDKPlatformTypeSinaWeibo: {
                             //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                             [appInfo SSDKSetupSinaWeiboByAppKey:sinaWeiBoAppKey
                                                       appSecret:sinaWeiBoAppSercet
                                                     redirectUri:sinaAuth_url
                                                        authType:SSDKAuthTypeBoth];
                             break;
                         }
                         case SSDKPlatformTypeWechat: {
                             [appInfo SSDKSetupWeChatByAppId:weChatAppId
                                                   appSecret:weChatAppSecret];
                             break;
                         }
                         default: {
                             //nothing
                             break;
                         }
                     }
                 }];
    
    
    //注意在分享SDK初始化之后，待别是友盟分享
    //微信支付
    [WXApi registerApp:weChatAppId withDescription:[LyUtil getAppUrlScheme]];
    
    
    // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    if ([LyUtil osVersion] > 10.0)
    {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else
#endif
    {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }
    

    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions
                           appKey:JPushAppKey
                          channel:JPushChannel
                 apsForProduction:JPushIsProduction];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:JPushRegistrationID];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    

    if (launchOptions) {
        NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        
        if (userInfo) {
            [self push_prepare:userInfo];
        }
        
        UILocalNotification *notifi = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
        userInfo = notifi.userInfo;
        if (userInfo) {
            [self push_prepare:userInfo];
        }
    }
    
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[LyPushManager sharedInstance] removeObserverForJPushNotification];
    
    [application setApplicationIconBadgeNumber:0];
    
    enterBackDate = [NSDate date];
    [[NSNotificationCenter defaultCenter] postNotificationName:LyAppDidEnterBackground object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
    
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LyAppDidBecomeActive object:nil];
    
    int seconds = [LyUtil calculSecondsWithDate:enterBackDate];
    
    if ( seconds > 7200) {
        [[LyCurrentUser curUser] logout];
        [LyUtil setHttpSessionId:@""];
        
        [LyUtil showLoginVc:[UIViewController currentViewController]];
    }
    
    NSLog(@"进入后台时间：%d---会话id：%@", seconds, [LyUtil httpSessionId]);
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //    [self saveContext];
    
    [[LyPushManager sharedInstance] removeObserverForJPushNotification];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
////    if ( [url.description rangeOfString:@"student517xueche"].length > 0)
////    {
////        
////    }
//    //    else
//    if ([url.host isEqualToString:callBackHost_Alipay])
//    {
//        [self payCallBack_AliPay:url];
//    }
//    else if ([url.host isEqualToString:callBackHost_ChinaUnion])
//    {
//        [self payCallBack_ChinaUnion:url];
//    }
//    else if ( [url.description rangeOfString:@"QQ41E2F407"].length > 0)
//    {
//        [self callBack_QQ:url];
//    }
//    else if ( [url.description rangeOfString:weChatAppId].length > 0)
//    {
//        [self callBack_WeChat:url];
//    }
//    else
//    {
//        [self callBack_WeiBo:url];
//    }
//    
//    
//    
//    return YES;
//}
//
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation
//{
////    if ( [url.description rangeOfString:@"student517xueche"].length > 0)
////    {
////        NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
////        NSLog(@"URL scheme:%@", [url scheme]);
////        NSLog(@"URL query: %@", [url query]);
////    }
//    //    else
//    if ([url.host isEqualToString:callBackHost_Alipay])
//    {
//        [self payCallBack_AliPay:url];
//    }
//    else if ([url.host isEqualToString:callBackHost_ChinaUnion])
//    {
//        [self payCallBack_ChinaUnion:url];
//    }
//    else if ( [url.description rangeOfString:@"QQ41E2F407"].length > 0)
//    {
//        [self callBack_QQ:url];
//    }
//    else if ( [url.description rangeOfString:weChatAppId].length > 0)
//    {
//        [self callBack_WeChat:url];
//    }
//    else
//    {
//        [self callBack_WeiBo:url];
//    }
//
//    
//    
//    return YES;
//}
//
//
//
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
//{
////    if ( [url.description rangeOfString:@"student517xueche"].length > 0)
////    {
////        
////    }
//    //    else
//    
//    if ([url.host isEqualToString:callBackHost_Alipay])
//    {
//        [self payCallBack_AliPay:url];
//    }
//    else if ([url.host isEqualToString:callBackHost_ChinaUnion])
//    {
//        [self payCallBack_ChinaUnion:url];
//    }
//    else if ( [url.description rangeOfString:@"QQ41E2F407"].length > 0)
//    {
//        [self callBack_QQ:url];
//    }
//    else if ( [url.description rangeOfString:weChatAppId].length > 0)
//    {
//        [self callBack_WeChat:url];
//    }
//    else
//    {
//        [self callBack_WeiBo:url];
//    }
//    
//    
//
//    return YES;
//}




//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//    NSString *strToken = [[NSString alloc] initWithFormat:@"%@",deviceToken];
//    strToken = [strToken stringByReplacingOccurrencesOfString:@" " withString:@""];
//    strToken = [strToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
//    strToken = [strToken stringByReplacingOccurrencesOfString:@">" withString:@""];
//    
//    
//    [JPUSHService registerDeviceToken:deviceToken];
//}
//
//
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
//}
//
//
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    // Required,For systems with less than or equal to iOS6
//    [JPUSHService handleRemoteNotification:userInfo];
//    
////    NSString *message = [[NSString alloc] initWithFormat:@"%@", userInfo];
////    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iOS6提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
////    [alert show];
//}
//
//
//// 这部分是官方demo里面给的, 也没实现什么功能, 放着以备不时之需
//#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
//// This callback will be made upon calling -[UIApplication registerUserNotificationSettings:]. The settings the user has granted to the application will be passed in as the second argument.
//- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
//{
//    
//}
//
//// Called when your app has been activated by the user selecting an action from
//// a local notification.
//// A nil action identifier indicates the default action.
//// You should call the completion handler as soon as you've finished handling
//// the action.
//- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
//{
//    
//}
//
//// Called when your app has been activated by the user selecting an action from
//// a remote notification.
//// A nil action identifier indicates the default action.
//// You should call the completion handler as soon as you've finished handling
//// the action.
//- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
//{
//    
//}
//#endif
//
//
//
//// local notification before iOS 10
//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
//{
////    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
//    
//    NSDictionary *userInfo = notification.userInfo;
//    
//    NSLog(@"本地通知，userInfo:%@", userInfo);
//}
//
//
//#pragma mark - iOS7: 收到推送消息调用
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    
//    // iOS7之后调用这个
//    // iOS 10 以下 Required
//    [JPUSHService handleRemoteNotification:userInfo];
//    NSLog(@"iOS7-8-9系统，在挂起状态或后台状态收到通知");
//    
//    if (UIApplicationStateInactive == application.applicationState ||
//        UIApplicationStateBackground == application.applicationState)
//    {
//        
//    }
//    else
//    {
//        
//    }
//    
//    [self push_prepare:userInfo];
//    
//    completionHandler(UIBackgroundFetchResultNewData);
//}
//
//
//#pragma mark -JPUSHRegisterDelegate
//#pragma mark -iOS10: 收到推送消息调用(iOS10是通过Delegate实现的回调)
//#ifdef NSFoundationVersionNumber_iOS_9_x_Max
//// 当程序在前台时, 收到推送弹出的通知
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
//    
//    NSLog(@"iOS 10收到通知");
//    
//    
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
//    {
//        // remote nitification
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    else
//    {
//        // local notification
//    }
//    
//    [self push_prepare:userInfo];
//    
//    
//    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
//}
//
//
//// 程序关闭后, 通过点击推送弹出的通知
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
//    
//    
//    
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
//    {
//        // remote nitification
//        [JPUSHService handleRemoteNotification:userInfo];
//        
//    }
//    else
//    {
//        // local notification
//    }
//    
//    [self push_prepare:userInfo];
//    
//    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
//}
//#endif




////支付宝支付回调
//- (void)payCallBack_AliPay:(NSURL *)url
//{
//    //跳转支付宝钱包进行支付，处理支付结果
//    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//        //            NSLog(@"result = %@",resultDic);
//        
//        [[LyPayManager sharedInstance] payFinished:LyPayMode_AliPay
//                                         andResult:resultDic];
//    }];
//}
//
//
//
//
//
////银联支付回调
//- (void)payCallBack_ChinaUnion:(NSURL *)url
//{
//    
//    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
//        
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        [dic setObject:code forKey:@"code"];
//        
//        if (data)
//        {
//            [dic setObject:data forKey:@"data"];
//        }
//        
//        [[LyPayManager sharedInstance] payFinished:LyPayMode_ChinaUnionPay
//                                         andResult:dic];
//    }];
//}
//
//
//
////QQ回调
//- (void)callBack_QQ:(NSURL *)url
//{
//    NSLog(@"callBack_QQ  url : %@", url);
//    [TencentOAuth HandleOpenURL:url];
//}
//
////微博回调
//- (void)callBack_WeiBo:(NSURL *)url
//{
//    NSLog(@"callBack_WeiBo  url : %@", url);
//    [WeiboSDK handleOpenURL:url delegate:self];
//}
//
////微信回调
//- (void)callBack_WeChat:(NSURL *)url
//{
//    NSLog(@"callBack_WeChat  url : %@", url);
//    
//    [WXApi handleOpenURL:url delegate:self];
//}
//
//
//
//#pragma mark -WeiboSDKDelegate
//- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
//{
//    NSLog(@"didReceiveWeiboRequest");
//}
//
//- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
//{
//    NSLog(@"didReceiveWeiboResponse");
//}
//
//
//
//#pragma mark WXApiDelegate
//-(void) onReq:(BaseReq*)req
//{
//    NSLog(@"onReq--req: type = %d-----openID = %@", req.type, req.openID);
//    
//    
//}
//
//-(void) onResp:(BaseResp*)resp
//{
//    NSLog(@"onResp--resp: errCode = %d-----errStr = %@----type = %d", resp.errCode, resp.errStr, resp.type);
//    
//    if ([resp isKindOfClass:[PayResp class]]) {
////        [[LyPayManager sharedInstance] payFinished:LyPayMode_WeChatPay andResult:resp];
//    }
//}



//#pragma mark - Push about
//- (void)targetForNotificationFrom_LyNotificationForJumpReady:(NSNotification *)notification {
//    UIViewController *target = notification.object;
//    
//    if (lastUserInfo) {
//        [self push:lastUserInfo target:target];
//    }
//}
//
//
//// prepare push --- judge
//- (void)push_prepare:(NSDictionary *)userInfo {
//    if (![LyUtil validateDictionary:userInfo]) {
//        return;
//    }
//    
//    if ([LyUtil isReady]) {
//        [self push:userInfo target:nil];
//    } else {
//        lastUserInfo = userInfo.copy;
//    }
//    
//}
//
//
//// push -- choose way for push
//- (void)push:(NSDictionary *)userInfo target:(__kindof UIViewController *)target {
//    if (![LyUtil validateDictionary:userInfo]) {
//        return;
//    }
//    
//    LyPushMode code = [[NSString alloc] initWithFormat:@"%@", userInfo[@"code"]].integerValue;
//    //    NSInteger count = [[NSString alloc] initWithFormat:@"%@", userInfo[@"count"]].integerValue;
//    NSString *msg = [[NSString alloc] initWithFormat:@"%@", userInfo[@"aps"][@"alert"]];
//    
//    if (target) {
//        [self push_genuine:code userInfo:userInfo target:target];
//        lastUserInfo = nil;
//    } else {
//        target = [UIViewController currentViewController];
//        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
//                                                                       message:msg
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
//                                                  style:UIAlertActionStyleCancel
//                                                handler:nil]];
//        [alert addAction:[UIAlertAction actionWithTitle:@"立即查看"
//                                                  style:UIAlertActionStyleDefault
//                                                handler:^(UIAlertAction * _Nonnull action) {
//                                                    [self push_genuine:code userInfo:userInfo target:target];
//                                                }]];
//        
//        [target presentViewController:alert animated:YES completion:nil];
//        
//    }
//}
//
//// push VC
//- (void)push_genuine:(LyPushMode)mode userInfo:(NSDictionary *)dictionary target:(__kindof UIViewController *)target {
//    switch (mode) {
//        case LyPushMode_reserNoFinish: {
//            LyOrderCenterViewController *orderCenter = [[LyOrderCenterViewController alloc] init];
//            orderCenter.orderMode = LyOrderMode_reservation;
//            orderCenter.orderState = LyOrderState_waitConfirm;
//            [target.navigationController pushViewController:orderCenter animated:YES];
//            break;
//        }
//        case LyPushMode_newReservation: {
//            //nothing to do
//            break;
//        }
//        case LyPushMode_newOrder: {
//            //nothing to do
//            break;
//        }
//        case LyPushMode_newEvaRep: {
//            LyEvaMsgTableViewController *evaMsg = [[LyEvaMsgTableViewController alloc] init];
//            evaMsg.hidesBottomBarWhenPushed = YES;
//            [target.navigationController pushViewController:evaMsg animated:YES];
//            break;
//        }
//        case LyPushMode_newConsult: {
//            //nothing to do
//            break;
//        }
//        case LyPushMode_newConRep: {
//            LyConMsgTableViewController *conMsg = [[LyConMsgTableViewController alloc] init];
//            conMsg.hidesBottomBarWhenPushed = YES;
//            [target.navigationController pushViewController:conMsg animated:YES];
//            break;
//        }
//        case LyPushMode_newEva: {
//            //nothing to do
//            break;
//        }
//            
//        case LyPushMode_local_theory: {
//            [[LyBottomControl sharedInstance] setBcCurrentFirstIndex:BcTheoryStudyCenter];
//            break;
//        }
//    }
//    
//}





@end

