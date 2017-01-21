//
//  AppDelegate+JPush.m
//  student
//
//  Created by MacMini on 2017/1/16.
//  Copyright © 2017年 517xueche. All rights reserved.
//

#import "AppDelegate+JPush.h"

#import "JPUSHService.h"
//#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "student-Swift.h"
#import "LyOrderCenterViewController.h"
#import "LyBottomControl.h"



@interface AppDelegate ()

@end



@implementation AppDelegate (JPush)


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *strToken = [[NSString alloc] initWithFormat:@"%@",deviceToken];
    strToken = [strToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    strToken = [strToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    strToken = [strToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    
    [JPUSHService registerDeviceToken:deviceToken];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    
    //    NSString *message = [[NSString alloc] initWithFormat:@"%@", userInfo];
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iOS6提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //    [alert show];
}


// 这部分是官方demo里面给的, 也没实现什么功能, 放着以备不时之需
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
// This callback will be made upon calling -[UIApplication registerUserNotificationSettings:]. The settings the user has granted to the application will be passed in as the second argument.
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    
}
#endif



// local notification before iOS 10
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
    
    NSDictionary *userInfo = notification.userInfo;
    
    NSLog(@"本地通知，userInfo:%@", userInfo);
}


#pragma mark - iOS7: 收到推送消息调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // iOS7之后调用这个
    // iOS 10 以下 Required
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7-8-9系统，在挂起状态或后台状态收到通知");
    
    if (UIApplicationStateInactive == application.applicationState ||
        UIApplicationStateBackground == application.applicationState)
    {
        
    }
    else
    {
        
    }
    
    [self push_prepare:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}


#pragma mark -JPUSHRegisterDelegate
#pragma mark -iOS10: 收到推送消息调用(iOS10是通过Delegate实现的回调)
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
// 当程序在前台时, 收到推送弹出的通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSLog(@"iOS 10收到通知");
    
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        // remote nitification
        [JPUSHService handleRemoteNotification:userInfo];
    }
    else
    {
        // local notification
    }
    
    [self push_prepare:userInfo];
    
    
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}


// 程序关闭后, 通过点击推送弹出的通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        // remote nitification
        [JPUSHService handleRemoteNotification:userInfo];
        
    }
    else
    {
        // local notification
    }
    
    [self push_prepare:userInfo];
    
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}
#endif


#pragma mark - Push about
- (void)actionForNotification_LyNotificationForJumpReady_JPush:(NSNotification *)notification {
    UIViewController *target = notification.object;
    
    if (self.lastUserInfo) {
        [self push:self.lastUserInfo target:target];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LyNotificationForJumpReady object:nil];
}


// prepare push --- judge
- (void)push_prepare:(NSDictionary *)userInfo {
    if (![LyUtil validateDictionary:userInfo]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionForNotification_LyNotificationForJumpReady_JPush:) name:LyNotificationForJumpReady object:nil];
    
    if ([LyUtil isReady]) {
        [self push:userInfo target:nil];
    } else {
        self.lastUserInfo = userInfo.copy;
    }
    
}


// push -- choose way for push
- (void)push:(NSDictionary *)userInfo target:(__kindof UIViewController *)target {
    if (![LyUtil validateDictionary:userInfo]) {
        return;
    }
    
    LyPushMode code = [[NSString alloc] initWithFormat:@"%@", userInfo[@"code"]].integerValue;
    //    NSInteger count = [[NSString alloc] initWithFormat:@"%@", userInfo[@"count"]].integerValue;
    NSString *msg = [[NSString alloc] initWithFormat:@"%@", userInfo[@"aps"][@"alert"]];
    
    if (target) {
        [self push_genuine:code userInfo:userInfo target:target];
        self.lastUserInfo = nil;
    } else {
        target = [UIViewController currentViewController];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"立即查看"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    [self push_genuine:code userInfo:userInfo target:target];
                                                }]];
        
        [target presentViewController:alert animated:YES completion:nil];
        
    }
}

// push VC
- (void)push_genuine:(LyPushMode)mode userInfo:(NSDictionary *)dictionary target:(__kindof UIViewController *)target {
    switch (mode) {
        case LyPushMode_reserNoFinish: {
            LyOrderCenterViewController *orderCenter = [[LyOrderCenterViewController alloc] init];
            orderCenter.orderMode = LyOrderMode_reservation;
            orderCenter.orderState = LyOrderState_waitConfirm;
            [target.navigationController pushViewController:orderCenter animated:YES];
            break;
        }
        case LyPushMode_newReservation: {
            //nothing to do
            break;
        }
        case LyPushMode_newOrder: {
            //nothing to do
            break;
        }
        case LyPushMode_newEvaRep: {
            LyEvaMsgTableViewController *evaMsg = [[LyEvaMsgTableViewController alloc] init];
            evaMsg.hidesBottomBarWhenPushed = YES;
            [target.navigationController pushViewController:evaMsg animated:YES];
            break;
        }
        case LyPushMode_newConsult: {
            //nothing to do
            break;
        }
        case LyPushMode_newConRep: {
            LyConMsgTableViewController *conMsg = [[LyConMsgTableViewController alloc] init];
            conMsg.hidesBottomBarWhenPushed = YES;
            [target.navigationController pushViewController:conMsg animated:YES];
            break;
        }
        case LyPushMode_newEva: {
            //nothing to do
            break;
        }
            
        case LyPushMode_local_theory: {
            [LyBottomControl sharedInstance].curIdx = BcTheoryStudyCenter;
            break;
        }
    }
    
}



@end
