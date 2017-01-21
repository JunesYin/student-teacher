//
//  LyCurrentUser.m
//  teacher
//
//  Created by Junes on 16/7/22.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyCurrentUser.h"
#import "LyUserManager.h"

#import "LyStudentManager.h"
#import "LyOrderManager.h"
#import "LyTrainClassManager.h"

#import "LyPushManager.h"



@interface LyCurrentUser ()
{
    BOOL        bFlagSetPush;
}
@end


@implementation LyCurrentUser

@synthesize userId           = _userId;
@synthesize userName         = _userName;
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
    }
    
    return self;
}


- (void)setUserId:(NSString *)userId
{
    _userId = userId;
    
    if ([LyPushManager sharedInstance].isJPushActive) {
        bFlagSetPush = YES;
        [LyPushManager setJPushTags:[NSSet setWithObjects:@"jld", [self userTypeByString], nil] alias:_userId];
    }
}

- (void)setUserName:(NSString *)userName {
    _userName = userName;
    
    LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:_userId];
    if ( !user) {
        switch (_userType) {
            case LyUserType_normal: {
                user = [LyUser userWithId:_userId
                                 userNmae:_userName];
                break;
            }
            case LyUserType_coach: {
                user = [LyCoach coachWithId:_userId
                                       name:_userName];
                break;
            }
            case LyUserType_school: {
                user = [LyDriveSchool driveSchoolWithId:_userId
                                               dschName:_userName];
                break;
            }
            case LyUserType_guider: {
                user = [LyGuider guiderWithGuiderId:_userId
                                            guiName:_userName];
                break;
            }
        }
        
        [[LyUserManager sharedInstance] addUser:user];
    }
    
    [user setUserName:_userName];
}



- (void)setUserAvatar:(UIImage *)userAvatar {
    _userAvatar = userAvatar;
    
    LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:_userId];
    if ( !user || user.userType != _userType) {
        switch (_userType) {
            case LyUserType_normal: {
                user = [LyUser userWithId:_userId
                                 userNmae:_userName];
                break;
            }
            case LyUserType_coach: {
                user = [LyCoach coachWithId:_userId
                                       name:_userName];
                break;
            }
            case LyUserType_school: {
                user = [LyDriveSchool driveSchoolWithId:_userId
                                               dschName:_userName];
                break;
            }
            case LyUserType_guider: {
                user = [LyGuider guiderWithGuiderId:_userId
                                            guiName:_userName];
                break;
            }
        }
        
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


- (void)setUserDriveBirthday:(NSString *)userDriveBirthday {
    
    _userDriveBirthday = userDriveBirthday;
    if (!_userDriveBirthday || [_userDriveBirthday isKindOfClass:[NSNull class]]) {
        _userDriveBirthday = @"";
    }
    
    _userDrivedAge = [LyUtil calculdateAgeWithStr:_userDriveBirthday];
}


- (void)setUserTeachBirthday:(NSString *)userTeachBirthday {
    
    _userTeachBirthday = userTeachBirthday;
    if (!_userTeachBirthday || [_userTeachBirthday isKindOfClass:[NSNull class]]) {
        _userTeachBirthday = @"";
    }
    
    _userTeachedAge = [LyUtil calculdateAgeWithStr:_userTeachBirthday];
}



- (NSString *)userSignature {
    return _userSignature;
}


- (NSString *)schoolTrueName {
    if (!_schoolTrueName || [_schoolTrueName isKindOfClass:[NSNull class]] || _schoolTrueName.length < 1 || [_schoolTrueName rangeOfString:@"null"].length > 0) {
        return _userName;
    }
    
    return _schoolTrueName;
}


- (void)setLocationWithLatitude:(CLLocationDegrees)lititude andLongitude:(CLLocationDegrees)longitude
{
    if ( !_location || ![_location isValid])
    {
        _location = [LyLocation locationWithLatitude:lititude andLongitude:longitude];
    }
}


- (void)setLocationWithLocation:(CLLocation *)location
{
    if ( !_location || ![_location isValid])
    {
        _location = [LyLocation locationWithLocatoin:location];
    }
}




- (void)setUserTypeWithString:(NSString *)strUserType
{
    if ([strUserType isEqualToString:@"jl"])
    {
        _userType = LyUserType_coach;
    }
    else if ([strUserType isEqualToString:@"jx"])
    {
        _userType = LyUserType_school;
    }
    else if ([strUserType isEqualToString:@"zdy"])
    {
        _userType = LyUserType_guider;
    }
}


- (NSString *)userTypeByString
{
    switch (_userType) {
        case LyUserType_normal: {
            return @"";
            break;
        }
        case LyUserType_coach: {
            return @"jl";
            break;
        }
        case LyUserType_school: {
            return @"jx";
            break;
        }
        case LyUserType_guider: {
            return @"zdy";
            break;
        }
        default: {
            return @"";
            break;
        }
    }
}


- (BOOL)isMaster {
    if (LyUserType_coach == _userType) {
        if (LyCoachMode_normal == _coachMode || LyCoachMode_staff == _coachMode) {
            return NO;
        }
    }
    
    return YES;
}


- (BOOL)isBoss {
    if (LyUserType_school == _userType) {
        return YES;
    }
    
    if (LyUserType_coach == _userType && LyCoachMode_boss == _coachMode) {
        return YES;
    }
    
    return NO;
}

- (BOOL)timeFlag {
    if (LyUserType_guider == _userType) {
        return YES;
    }
    
    return _timeFlag;
}

- (BOOL)isLogined
{
    if ( !_userId || [NSNull null] == (NSNull *)_userId || [_userId isKindOfClass:[NSNull class]] || [_userId rangeOfString:@"(null)"].length > 0 || [_userId length] < 36 || [_userId isEqualToString:@""])
    {
        _isLogined = NO;
    }
    
    if ( _userId && ![_userId isEqualToString:@""] && 36 == [_userId length] && LyTeacherVerifyState_access == _verifyState)
    {
        _isLogined = YES;
    }
    
    return _isLogined;
}



- (NSString *)teachingCountByString
{
//    return [[NSString alloc] initWithFormat:@"当前在教学员：%d人", _teachingCount];
    return @"当前在教学员：0人";
}

- (NSString *)monthOrderCountByString
{
//    return [[NSString alloc] initWithFormat:@"当月累计订单：%d单", _monthOrderCount];
    return @"当月累计订单：0单";
}

- (NSString *)allOrderCountByString
{
//    return [[NSString alloc] initWithFormat:@"累计订单：%d单", _allOrderCount];
    return @"累计订单：0单";
}

- (NSString *)teachAllCountByString
{
//    return [[NSString alloc] initWithFormat:@"已教学员：%d人", _stuAllCount];
    return @"已教学员：0人";
}


- (void)logout
{
    _isLogined = NO;
    
    _userId = nil;
    _userName = nil;
    _userBirthday = nil;
    _userPhoneNum = nil;
    _userAvatar = nil;
    _userDriveBirthday = nil;
    _userDriveBirthday = nil;
    _userSex = 0;
    _userAge = 0;
    _userBalance = 0;
    _user5Coin = 0;
    _userLevel = 0;
    _userLicenseType = 0;
    _userDrivedAge = 0;
    _userTeachedAge = 0;
    
    
    [[LyStudentManager sharedInstance] removeAllSutdent];
    [[LyOrderManager sharedInstance] removeAllOrder];
    [[LyTrainClassManager sharedInstance] removeAllTrainClass];
    
    [LyUtil ready:NO target:nil];
    
    if ([LyPushManager sharedInstance].isJPushActive) {
        [LyPushManager resetJPushTagsAndAlias];
    }
}


#pragma mark -kJPFNetworkDidLoginNotification        // 登录成功
- (void)target_kJPFNetworkDidLoginNotification:(NSNotification *)notification
{
    if (self.isLogined && !bFlagSetPush) {
        bFlagSetPush = YES;
        [LyPushManager setJPushTags:[NSSet setWithObjects:@"jld", [self userTypeByString], nil] alias:_userId];
    }
}



@end
