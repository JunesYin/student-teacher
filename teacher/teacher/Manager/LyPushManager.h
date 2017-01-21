//
//  LyPushManager.h
//  student
//
//  Created by MacMini on 2016/12/21.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LySingleInstance.h"
#import "JPUSHService.h"



UIKIT_EXTERN NSString *const JPushRequestIdentifier_threeDays;
UIKIT_EXTERN NSString *const JPushRequestIdentifier_week;
UIKIT_EXTERN NSString *const JPushRequestIdentifier_halfMonth;
UIKIT_EXTERN NSString *const JPushRequestIdentifier_month;
UIKIT_EXTERN NSString *const JPushRequestIdentifier_twoMonths;
UIKIT_EXTERN NSString *const JPushRequestIdentifier_threeMonths;
UIKIT_EXTERN NSString *const JPushRequestIdentifier_fourMonths;
UIKIT_EXTERN NSString *const JPushRequestIdentifier_fiveMonths;
UIKIT_EXTERN NSString *const JPushRequestIdentifier_halfYear;



@interface LyPushManager : NSObject

@property (assign, nonatomic, readonly, getter=isJPushActive)     BOOL      JPushActive;


lySingle_interface

+ (void)setJPushAlias:(nullable NSString *)alias;
+ (void)setJPushTags:(nullable NSSet *)tags;

+ (void)resetJPushAlias;
+ (void)resetJPushTags;
+ (void)resetJPushTagsAndAlias;

+ (void)setJPushTags:(nullable NSSet *)tags alias:(nullable NSString *)alias;


+ (void)addLocalNotification;
+ (void)removeLocalNotification;

- (void)addObserverForJPushNotification;
- (void)removeObserverForJPushNotification;

@end
