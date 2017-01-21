//
//  LyCurrentUser.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/19.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyCurrentUser.h"
#import "LyUserManager.h"
#import "LyOrderManager.h"
#import "LyAttentionManager.h"

#import "LyCurrentNews.h"

#import "LyPushManager.h"

@interface LyCurrentUser ()
{
    BOOL        bFlagSetPush;
}
@end




@implementation LyCurrentUser


@synthesize userId           = _userId;
@synthesize userName         = _userName;
@synthesize userAvatarName   = _userAvatarName;
@synthesize userBirthday     = _userBirthday;
@synthesize userPhoneNum     = _userPhoneNum;
@synthesize userAvatar       = _userAvatar;
@synthesize userAddress      = _userAddress;
@synthesize userSignature    = _userSignature;
@synthesize userSex          = _userSex;
@synthesize userAge          = _userAge;
@synthesize userBalance      = _userBalance;
@synthesize userType         = _userType;
@synthesize userLevel        = _userLevel;
@synthesize userLicenseType  = _userLicenseType;
//@synthesize location         = _location;




+ (instancetype)curUser
{
    static LyCurrentUser *sI = nil;
    if ( !sI)
    {
        sI = [[LyCurrentUser alloc] init];
        
        if ([self respondsToSelector:@selector(target_kJPFNetworkDidLoginNotification:)]) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(target_kJPFNetworkDidLoginNotification:)
                                                         name:kJPFNetworkDidLoginNotification
                                                       object:nil];
        }
    }
    
    return sI;
}



- (instancetype)init
{
    if ( self = [super init])
    {
        _location = [LyLocation locationWithLatitude:0 andLongitude:0];
    }
    
    return self;
}

- (void)setUserId:(NSString *)userId
{
    _userId = userId;

    if ([LyPushManager sharedInstance].isJPushActive) {
        bFlagSetPush = YES;
        [LyPushManager setJPushTags:[NSSet setWithObjects:@"xy", nil] alias:_userId];
    }
    
    
//    [self createShortcutItem];
}

- (void)setUserName:(NSString *)userName {
    _userName = userName;
    
    LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:_userId];
    if (!user) {
        user = [LyUser userWithId:_userId
                         userNmae:_userName];
        
        [[LyUserManager sharedInstance] addUser:user];
    }
    
    user.userName = _userName;
}


- (void)setUserAvatar:(UIImage *)userAvatar
{
    _userAvatar = userAvatar;
    
    LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:_userId];
    if (!user) {
        user = [LyUser userWithId:_userId
                         userNmae:_userName];
        
        [[LyUserManager sharedInstance] addUser:user];
    }
    
    [user setUserAvatar:_userAvatar];
}


- (void)setUserBirthday:(NSString *)userBirthday {
    
    _userBirthday = userBirthday;
    
    if (!_userBirthday || [_userBirthday isKindOfClass:[NSNull class]]) {
        _userBirthday = @"";
    }
    
    _userAge = [LyUtil calculdateAgeWithStr:_userBirthday];
}



- (void)setLocationWithLatitude:(CLLocationDegrees)lititude andLongitude:(CLLocationDegrees)longitude
{
    if ( !_location)
    {
        _location = [LyLocation locationWithLatitude:lititude andLongitude:longitude];
    }
    else
    {
        [_location setLatitude:lititude andLongitude:longitude];
    }
    
}


- (void)setLocationWithLocation:(CLLocation *)location
{
    if ( !_location)
    {
        _location = [LyLocation locationWithLocatoin:location];
    }
    else
    {
        [_location setLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
    }
}


- (BOOL)isLogined
{
    if ( !_userId || [NSNull null] == (NSNull *)_userId || [_userId isKindOfClass:[NSNull class]] || [_userId rangeOfString:@"(null)"].length > 0 || [_userId length] < 36 || [_userId isEqualToString:@""])
    {
        _isLogined = NO;
    }
    
    if (36 == _userId.length)
    {
        _isLogined = YES;
    }
    
    return _isLogined;
}


- (NSString *)userExamAddress
{
    if ( !_userExamAddress || [NSNull null] == (NSNull *)_userExamAddress || [_userExamAddress isEqualToString:@""])
    {
        return [_location address];
    }
    
    return _userExamAddress;
}


- (NSString *)userTypeByString {
    switch (_userType) {
        case LyUserType_normal: {
            return userTypeStudentKey;
            break;
        }
        case LyUserType_school: {
            return userTypeSchoolKey;
            break;
        }
        case LyUserType_coach: {
            return userTypeCoachKey;
            break;
        }
        case LyUserType_guider: {
            return userTypeGuiderKey;
            break;
        }
    }
}

- (NSString *)userLicenseTypeByString {
    return [LyUtil driveLicenseStringFrom:_userLicenseType];
}


- (NSInteger)cartype
{
    NSInteger iCarType = 0;
    switch ([LyCurrentUser curUser].userLicenseType) {
        case LyLicenseType_A1: {
            //            break;
        }
        case LyLicenseType_A3: {
            //            break;
        }
        case LyLicenseType_B1: {
            iCarType = 1;
            break;
        }
        case LyLicenseType_A2: {
            //            break;
        }
        case LyLicenseType_B2: {
            iCarType = 2;
            break;
        }
        case LyLicenseType_M: {
            iCarType = 3;
            break;
        }
        default: {
            break;
        }
    }
    
    return iCarType;
}

- (NSString *)userIdForTheory
{
    return self.isLogined ? _userId : LyTheoryDefaultUserId;
}

- (void)logout
{
    
    [[LyOrderManager sharedInstance] removeAllOrder];
    [[LyAttentionManager sharedInstance] removeAllAttention];
    [[LyCurrentNews sharedInstance] clear];
    
    
    _isLogined = NO;
    
    self.userId = @"";
    _userName = nil;
    _userBirthday = nil;
    _userPhoneNum = nil;
    _userAvatar = nil;
    _userSex = LySexUnkown;
    _userAge = 0;
    _userBalance = 0;
    _user5Coin = 0;
    _userLevel = userLevel_newbird;
    _userLicenseType = LyLicenseType_C1;
    
    if ([LyPushManager sharedInstance].isJPushActive) {
        [LyPushManager resetJPushTagsAndAlias];
    }
    
//    [UIApplication sharedApplication].shortcutItems = nil;
}


- (void)createShortcutItem {
    UIApplicationShortcutItem *siSimulate = [[UIApplicationShortcutItem alloc] initWithType:@"10001"
                                                                             localizedTitle:@"全真模考"
                                                                          localizedSubtitle:nil
                                                                                       icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"/resource.bundle/images/3DTouch_simulate"]
                                                                                   userInfo:nil];
    
    UIApplicationShortcutItem *siSweep = [[UIApplicationShortcutItem alloc] initWithType:@"10002"
                                                                          localizedTitle:@"扫一扫"
                                                                       localizedSubtitle:nil
                                                                                    icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"/resource.bundle/images/3DTouch_sweep"]
                                                                                userInfo:nil];
    
    UIApplicationShortcutItem *siMyQRCode = [[UIApplicationShortcutItem alloc] initWithType:@"10002"
                                                                          localizedTitle:@"我的二维码"
                                                                       localizedSubtitle:nil
                                                                                    icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"/resource.bundle/images/3DTouch_myQRCode"]
                                                                                userInfo:nil];
    
    [UIApplication sharedApplication].shortcutItems = @[siSimulate, siSweep, siMyQRCode];
    
}


#pragma mark -kJPFNetworkDidLoginNotification        // 登录成功
- (void)target_kJPFNetworkDidLoginNotification:(NSNotification *)notification
{
    if (self.isLogined && !bFlagSetPush) {
        bFlagSetPush = YES;
        [LyPushManager setJPushTags:[NSSet setWithObjects:@"xy", nil] alias:_userId];
    }
}


@end
