//
//  LyDriveSchool.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/5.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyDriveSchool.h"
#import "LyCurrentUser.h"


#import "LyUtil.h"

@implementation LyDriveSchool



@synthesize userId        = _userId;
@synthesize userName      = _userName;
@synthesize userBirthday  = _userBirthday;
@synthesize userPhoneNum  = _userPhoneNum;
@synthesize userAvatar    = _userAvatar;
//@synthesize userAvatarName = _userAvatarName;
@synthesize userAddress   = _userAddress;
@synthesize userAge       = _userAge;
@synthesize userSignature = _userSignature;
@synthesize userType      = _userType;
@synthesize arrLandMark   = _arrLandMark;
@synthesize searching     = _searching;
@synthesize distance = _distance;
@synthesize deposit = _deposit;

@synthesize score = _score;
@synthesize price = _price;
@synthesize stuAllCount = _stuAllCount;




+ (instancetype)driveSchoolWithIdNoAvatar:(NSString *)userId
                                 userName:(NSString *)userName
{
    LyDriveSchool *school = [[LyDriveSchool alloc] initWithIdNoAvatar:userId
                                                             userName:userName];
    
    return school;
}

- (instancetype)initWithIdNoAvatar:(NSString *)userId
                          userName:(NSString *)userName
{
    if (self = [super init]) {
        _userId = userId;
        _userName = userName;
    }
    
    _userType = LyUserType_school;
    
    return self;
}


+ (instancetype)driveSchoolWithId:(NSString *)dschId
                         dschName:(NSString *)dschName {
    LyDriveSchool *tmpDsch = [[LyDriveSchool alloc] initWithId:dschId
                                                      dschName:dschName];
    
    return tmpDsch;
}

- (instancetype)initWithId:(NSString *)dschId
                  dschName:(NSString *)dschName {
    if ( self = [super init]) {
        _userId = dschId;
        _userName = dschName;
        
        [LyImageLoader loadAvatarWithUserId:_userId
                                   complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSString * _Nullable userId) {
                                       if (!image) {
                                           image = [LyUtil defaultAvatarForTeacher];
                                       }
                                       _userAvatar = image;
                                   }];
    }
    
    
    _userType = LyUserType_school;
    
    return self;
}



+ (instancetype)driveShcoolWithDschId:(NSString *)dschId
                             dschName:(NSString *)dschName
                                score:(float)score
                          stuAllCount:(int)stuAllCount
                                price:(float)price
{
    LyDriveSchool *tmpDriveSchool = [[LyDriveSchool alloc] initWithDschId:dschId
                                                                 dschName:dschName
                                                                    score:score
                                                              stuAllCount:stuAllCount
                                                                    price:price];
    
    
    return tmpDriveSchool;
}

- (instancetype)initWithDschId:(NSString *)dschId
                      dschName:(NSString *)dschName
                         score:(float)score
                   stuAllCount:(int)stuAllCount
                         price:(float)price
{
    if ( self = [super init])
    {
        _userId = dschId;
        _userName = dschName;
        _score = score;
        _stuAllCount = stuAllCount;
        _price = price;
        
        [LyImageLoader loadAvatarWithUserId:_userId
                                   complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSString * _Nullable userId) {
                                       if (!image) {
                                           image = [LyUtil defaultAvatarForTeacher];
                                       }
                                       _userAvatar = image;
                                   }];
    }
    
    _userType = LyUserType_school;
    
    
    return self;
}


- (NSString *)userTypeByString {
    return userTypeSchoolKey;
}


- (void)setUserBirthday:(NSString *)userBirthday {
    
    _userBirthday = userBirthday;
    if (!_userBirthday || [_userBirthday isKindOfClass:[NSNull class]]) {
        _userBirthday = @"";
    }
    
    _userAge = [LyUtil calculdateAgeWithStr:_userBirthday];
}


- (NSString *)getDschTeachRange
{
    return @"";
}



- (void)setLastSignInfo:(NSString *)studentName andTime:(NSString *)signTime
{
    signTime = [signTime stringByAppendingString:@" +0800"];
    
    int seconds = [LyUtil calculSecondsWithString:signTime];
    NSString *strTime;
    
    int minutes = seconds / 60;
    minutes = (minutes < 1) ? 1 : minutes;
    
    if ( minutes < 60)
    {
        strTime = [[NSString alloc] initWithFormat:@"%d分钟", minutes];
    }
    else
    {
        int hours = minutes / 60;
        
        if ( hours < 24)
        {
            strTime = [[NSString alloc] initWithFormat:@"%d小时", hours];
        }
        else
        {
            int days = hours / 24;
            
            strTime = [[NSString alloc] initWithFormat:@"%d天", days];
        }
    }
    
    
    _lastSignInfo = [[NSString alloc] initWithFormat:@"%@在%@前报了%@", studentName, strTime, _userName];
}




- (NSString *)description
{
    return _userName;
}


@end
