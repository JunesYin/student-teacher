//
//  LyPushManager.m
//  student
//
//  Created by MacMini on 2016/12/21.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyPushManager.h"
#import "LyUtil.h"




NSString *const JPushRequestIdentifier_threeDays = @"JPushRequestIdentifier_threeDays";
NSString *const JPushRequestIdentifier_week = @"JPushRequestIdentifier_week";
NSString *const JPushRequestIdentifier_halfMonth = @"JPushRequestIdentifier_halfMonth";
NSString *const JPushRequestIdentifier_month = @"JPushRequestIdentifier_month";
NSString *const JPushRequestIdentifier_twoMonths = @"JPushRequestIdentifier_twoMonths";
NSString *const JPushRequestIdentifier_threeMonths = @"JPushRequestIdentifier_threeMonths";
NSString *const JPushRequestIdentifier_fourMonths = @"JPushRequestIdentifier_fourMonths";
NSString *const JPushRequestIdentifier_fiveMonths = @"JPushRequestIdentifier_fiveMonths";
NSString *const JPushRequestIdentifier_halfYear = @"JPushRequestIdentifier_halfYear";
NSString *const JPushRequestIdentifier_year = @"JPushRequestIdentifier_year";


NSString *const JPushReuqestTitle_threeDays = @"学车如逆水行舟，不进则退，你已经三天没有学车了";
NSString *const JPushReuqestTitle_week = @"学车如逆水行舟，不进则退，你已经一周没有学车了";
NSString *const JPushReuqestTitle_halfMonth = @"学车如逆水行舟，不进则退，你已经半个月没有学车了";
NSString *const JPushReuqestTitle_month = @"学车如逆水行舟，不进则退，你已经一个月没有学车了";
NSString *const JPushReuqestTitle_twoMonths = @"学车如逆水行舟，不进则退，你已经两个月没有学车了";
NSString *const JPushReuqestTitle_threeMonths = @"学车如逆水行舟，不进则退，你已经三个月没有学车了";
NSString *const JPushReuqestTitle_fourMonths = @"学车如逆水行舟，不进则退，你已经四个月没有学车了";
NSString *const JPushReuqestTitle_fiveMonths = @"学车如逆水行舟，不进则退，你已经五个月没有学车了";
NSString *const JPushReuqestTitle_hlafYear = @"学车如逆水行舟，不进则退，你已经半年没有学车了";
NSString *const JPushReuqestTitle_year = @"学车如逆水行舟，不进则退，你已经一年没有学车了";


@implementation LyPushManager

static NSArray *arrJPushRequestionIdentifier = nil;
static NSArray *arrJPushRequestionSubtitle = nil;
static int arrJPushRequestionTimeInterval[] = {3, 7, 15, 30, 60, 90, 120, 150, 182, 365};

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
                                         JPushRequestIdentifier_year
                                         ];
        
        arrJPushRequestionSubtitle = @[
                                       JPushReuqestTitle_threeDays,
                                       JPushReuqestTitle_week,
                                       JPushReuqestTitle_halfMonth,
                                       JPushReuqestTitle_month,
                                       JPushReuqestTitle_twoMonths,
                                       JPushReuqestTitle_threeMonths,
                                       JPushReuqestTitle_fourMonths,
                                       JPushReuqestTitle_fiveMonths,
                                       JPushReuqestTitle_hlafYear,
                                       JPushReuqestTitle_year
                                       ];
        
//        arrJPushRequestionTimeInterval = new int[9];
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
    
    NSDate *now = [NSDate date];
#if DEBUG
    
#else
    NSString *sNow = [LyUtil stringOnlyYMDFromDate:now];
    sNow = [sNow stringByAppendingString:@" 18:00:00 +0800"];
    now = [[LyUtil dateFormatterForAll] dateFromString:sNow];
#endif
    
    for (NSInteger i = 0; i < arrJPushRequestionIdentifier.count; ++i) {
        
        JPushNotificationContent *content = [[JPushNotificationContent alloc] init];
        content.title = @"我要去学车";
//        content.subtitle = arrJPushRequestionSubtitle[i];
        content.body = arrJPushRequestionSubtitle[i];
        content.badge = @1;
        content.userInfo = @{
                             @"code": @(LyPushMode_local_theory)
                             };
        
        JPushNotificationTrigger *trigger = [[JPushNotificationTrigger alloc] init];
        
        if ([LyUtil osVersion] >= 10.0) {
#if DEBUG
            trigger.dateComponents = [[LyUtil calendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond
                                                          fromDate:[now dateByAddingTimeInterval:5 * arrJPushRequestionTimeInterval[i]]];
#else
            trigger.dateComponents = [[LyUtil calendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                          fromDate:[now dateByAddingTimeInterval:86400 * arrJPushRequestionTimeInterval[i]]];
#endif
        } else {
#if DEBUG
            trigger.fireDate = [now dateByAddingTimeInterval:5 * arrJPushRequestionTimeInterval[i]];
#else
            trigger.fireDate = [now dateByAddingTimeInterval:86400 * arrJPushRequestionTimeInterval[i]];
#endif
            
        }

        
        JPushNotificationRequest *req = [[JPushNotificationRequest alloc] init];
        req.requestIdentifier = arrJPushRequestionIdentifier[i];
        req.content = content;
        req.trigger = trigger;
        req.completionHandler = ^(id result) {
            NSLog(@"local notification completionHandler：%@", result);
        };
        
        [JPUSHService addNotification:req];
    }
    
}



+ (void)removeLocalNotification
{
    JPushNotificationIdentifier *identifier = [[JPushNotificationIdentifier alloc] init];
    identifier.identifiers = nil;
    identifier.delivered = NO;
    [JPUSHService removeNotification:identifier];
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
    
    [LyPushManager removeLocalNotification];
    
    [LyPushManager addLocalNotification];
}





@end
