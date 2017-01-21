//
//  LyUser.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/19.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyUser.h"
#import "LyCurrentUser.h"


@implementation LyUser


- (instancetype)init
{
    if ( self = [super init])
    {
        
    }
    
    return self;
}


+ (instancetype)userWithId:(NSString *)userId
                  userNmae:(NSString *)userName
{
    LyUser *tmpUser = [[LyUser alloc] initWithId:userId
                                        userName:userName];
    
    return tmpUser;
}



- (instancetype)initWithId:(NSString *)userId
                  userName:(NSString *)userName
{
    if ( self = [super init])
    {
        _userId = userId;
        _userName = userName;
        
        if ([_userId isEqualToString:@"1"]) {
            _userName = @"匿名用户";
            _userAvatar = [LyUtil defaultAvatarForStudent];
        }
        else {
            
            if (![_userId isEqualToString:[LyCurrentUser curUser].userId]) {
                [LyImageLoader loadAvatarWithUserId:_userId
                                           complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSString * _Nullable userId) {
                                               if (!image) {
                                                   image = [LyUtil defaultAvatarForStudent];
                                               }
                                               _userAvatar = image;
                                           }];
            }
            
        }
    }
    
    _userType = LyUserType_normal;
    
    return self;
}



+ (instancetype)userWithId:(NSString *)userId
                  userName:(NSString *)userName
              userBirthday:(NSString *)birthday
              userPhoneNum:(NSString *)phoneNum
                useravatar:(NSString *)avatar
               userAddress:(NSString *)address
             userSignature:(NSString *)signature
                   userSex:(LySex)sex
               userBalance:(float)balance
                 userLevel:(LyUserLevel)userLevel
{
    LyUser *tmpUser = [[LyUser alloc] initWithId:userId
                                        userName:userName
                                    userBirthday:birthday
                                    userPhoneNum:phoneNum
                                      useravatar:avatar
                                     userAddress:address
                                   userSignature:signature
                                         userSex:sex
                                     userBalance:balance
                                       userLevel:userLevel];
    
    return tmpUser;
    
}




- (instancetype)initWithId:(NSString *)userId
                  userName:(NSString *)userName
              userBirthday:(NSString *)birthday
              userPhoneNum:(NSString *)phoneNum
                useravatar:(NSString *)avatar
               userAddress:(NSString *)address
             userSignature:(NSString *)signature
                   userSex:(LySex)sex
               userBalance:(float)balance
                 userLevel:(LyUserLevel)userLevel
{
    if ( self = [super init])
    {
        
        _userId        = userId;
        _userName      = userName;
        _userBirthday  = birthday;
        _userPhoneNum  = phoneNum;
//        _userAvatar    = avatar;
        _userAddress   = address;
        _userSignature = signature;
        _userSex       = sex;
        _userBalance   = balance;

        _userLevel     = userLevel;
        
        _userAge = [LyUtil calculdateAgeWithStr:birthday];
        
        [LyImageLoader loadAvatarWithUserId:_userId
                                   complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSString * _Nullable userId) {
                                       if (!image) {
                                           image = [LyUtil defaultAvatarForTeacher];
                                       }
                                       _userAvatar = image;
                                   }];
    }
    
    return self;
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



- (void)setUserBirthday:(NSString *)userBirthday {

    _userBirthday = userBirthday;
    
    if (!_userBirthday || [_userBirthday isKindOfClass:[NSNull class]]) {
        _userBirthday = @"";
    }
    
    _userAge = [LyUtil calculdateAgeWithStr:_userBirthday];
}


- (NSString *)userName {
    if (!_userName || ![LyUtil validateString:_userName]) {
        return @"匿名用户";
    }
    
    return _userName;
}


- (NSString *)description
{
    if (!_userName || ![LyUtil validateString:_userName]) {
        return @"匿名用户";
    }
    
    return _userName;
}



- (void)addLandMark:(LyLandMark *)landMark
{
    
}




@end
