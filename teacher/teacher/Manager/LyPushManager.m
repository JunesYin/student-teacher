//
//  LyPushManager.m
//  student
//
//  Created by MacMini on 2016/12/21.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyPushManager.h"



NSString *const JPushRequestIdentifier_threeDays = @"JPushRequestIdentifier_threeDays";
NSString *const JPushRequestIdentifier_week = @"JPushRequestIdentifier_week";
NSString *const JPushRequestIdentifier_halfMonth = @"JPushRequestIdentifier_halfMonth";
NSString *const JPushRequestIdentifier_month = @"JPushRequestIdentifier_month";
NSString *const JPushRequestIdentifier_twoMonths = @"JPushRequestIdentifier_twoMonths";
NSString *const JPushRequestIdentifier_threeMonths = @"JPushRequestIdentifier_threeMonths";
NSString *const JPushRequestIdentifier_fourMonths = @"JPushRequestIdentifier_fourMonths";
NSString *const JPushRequestIdentifier_fiveMonths = @"JPushRequestIdentifier_fiveMonths";
NSString *const JPushRequestIdentifier_halfYear = @"JPushRequestIdentifier_halfYear";



@implementation LyPushManager

static NSArray *arrJPushRequestionIdentifier = nil;

lySingle_implementation(LyPushManager)

- (instancetype)init {
    if (self = [super init]) {
        arrJPushRequestionIdentifier = @[
                                         JPushRequestIdentifier_threeDays,
                                         JPushRequestIdentifier_week,
                                         JPushRequestIdentifier_halfMonth,
                                         JPushRequestIdentifier_month,
                                         JPushRequestIdentifier_twoMonths,
                                         JPushRequestIdentifier_threeMonths,
                                         JPushRequestIdentifier_fourMonths,
                                         JPushRequestIdentifier_fiveMonths,
                                         JPushRequestIdentifier_halfYear,
                                         ];
    }
    
    return self;
}


+ (void)setJPushAlias:(NSString *)alias
{
    [[LyPushManager sharedInstance] setJPushTags:nil alias:alias];
}

+ (void)setJPushTags:(NSSet *)tags
{
    [[LyPushManager sharedInstance] setJPushTags:tags alias:nil];
}



+ (void)resetJPushAlias
{
    [[LyPushManager sharedInstance] setJPushTags:nil alias:@""];
}

+ (void)resetJPushTags
{
    [[LyPushManager sharedInstance] setJPushTags:[NSSet set] alias:nil];
}
+ (void)resetJPushTagsAndAlias
{
    [[LyPushManager sharedInstance] setJPushTags:[NSSet set] alias:@""];
}



+ (void)setJPushTags:(NSSet *)tags alias:(NSString *)alias
{
    [[LyPushManager sharedInstance] setJPushTags:tags alias:alias];
}
- (void)setJPushTags:(NSSet *)tags alias:(NSString *)alias
{
    [JPUSHService setTags:tags alias:alias callbackSelector:@selector(callbackSetTagAlias:tags:alias:) object:self];
}




+ (void)addLocalNotification {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    
#else
    
#endif
//    for (int i = 0; i < arrJPushRequestionIdentifier.count; ++i)
    {
//        NSString *identifier = arrJPushRequestionIdentifier[i];
        NSString *identifier = @"test";
        JPushNotificationRequest *request = [[JPushNotificationRequest alloc] init];
        request.requestIdentifier = identifier;
    
        JPushNotificationContent *content = [[JPushNotificationContent alloc] init];
        content.title = @"我要去学车--测试";
        content.subtitle = @"2016";
        content.body = @"学车如逆水行舟，不进则退。亲，你已经三天没有学车了！！！";
        content.badge = @1;
        content.categoryIdentifier = @"Custom Category Name";
        
        JPushNotificationTrigger *trigger = [[JPushNotificationTrigger alloc] init];
        trigger.repeat = YES;
        trigger.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
        trigger.timeInterval = 5;
    
        request.content = content;
        request.trigger = trigger;
        request.completionHandler = ^(id result){
            NSLog(@"request.completionHandler.result = %@", result);
        };
    
    [JPUSHService addNotification:request];

    }
}








- (void)callbackSetTagAlias:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias
{
    NSString *sResp = [[NSString alloc] initWithFormat:@"-----------------------------\niResCoe = %d\ntags = %@\nalias = %@\n-----------------------------",
                       iResCode,
                       tags,
                       alias
                       ];
    
    NSString *sPrefix;
    if (0 == iResCode)
    {
        sPrefix = @"成功---设置别名或标签---\n";
    }
    else
    {
        sPrefix = @"失败---设置别名或标签---\n";
    }
    
    NSLog(@"%@%@", sPrefix, sResp);
}








#pragma mark -JPush_notification
- (void)addObserverForJPushNotification
{
    if ([self respondsToSelector:@selector(target_kJPFNetworkIsConnectingNotification:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(target_kJPFNetworkIsConnectingNotification:)
                                                     name:kJPFNetworkIsConnectingNotification
                                                   object:nil];
    }
    
    if ([self respondsToSelector:@selector(target_kJPFNetworkDidSetupNotification:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(target_kJPFNetworkDidSetupNotification:)
                                                     name:kJPFNetworkDidSetupNotification
                                                   object:nil];
    }
    
    if ([self respondsToSelector:@selector(target_kJPFNetworkDidCloseNotification:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(target_kJPFNetworkDidCloseNotification:)
                                                     name:kJPFNetworkDidCloseNotification
                                                   object:nil];
    }
    
    if ([self respondsToSelector:@selector(target_kJPFNetworkDidRegisterNotification:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(target_kJPFNetworkDidRegisterNotification:)
                                                     name:kJPFNetworkDidRegisterNotification
                                                   object:nil];
    }
    
    if ([self respondsToSelector:@selector(target_kJPFNetworkFailedRegisterNotification:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(target_kJPFNetworkFailedRegisterNotification:)
                                                     name:kJPFNetworkFailedRegisterNotification
                                                   object:nil];
    }
    
    if ([self respondsToSelector:@selector(target_kJPFNetworkDidLoginNotification:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(target_kJPFNetworkDidLoginNotification:)
                                                     name:kJPFNetworkDidLoginNotification
                                                   object:nil];
    }
    
    
    
}

- (void)removeObserverForJPushNotification
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkIsConnectingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidSetupNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidCloseNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidRegisterNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkFailedRegisterNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidLoginNotification object:nil];
}

#pragma mark -kJPFNetworkIsConnectingNotification       // 正在连接中
- (void)target_kJPFNetworkIsConnectingNotification:(NSNotification *)notification
{
    
}

#pragma mark -kJPFNetworkDidSetupNotification       // 建立连接
- (void)target_kJPFNetworkDidSetupNotification:(NSNotification *)notification
{
    
}

#pragma mark -kJPFNetworkDidCloseNotification       // 关闭连接
- (void)target_kJPFNetworkDidCloseNotification:(NSNotification *)notification
{
    
}

#pragma mark -kJPFNetworkDidRegisterNotification        // 注册成功
- (void)target_kJPFNetworkDidRegisterNotification:(NSNotification *)notification
{
    
}

#pragma mark -kJPFNetworkFailedRegisterNotification      //注册失败
- (void)target_kJPFNetworkFailedRegisterNotification:(NSNotification *)notification
{
    
}

#pragma mark -kJPFNetworkDidLoginNotification        // 登录成功
- (void)target_kJPFNetworkDidLoginNotification:(NSNotification *)notification
{
    _JPushActive = YES;
}





@end
