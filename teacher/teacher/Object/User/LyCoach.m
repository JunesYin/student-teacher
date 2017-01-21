//
//  LyCoach.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/16.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyCoach.h"
#import "LyCurrentUser.h"

@implementation LyCoach


@synthesize userId        = _userId;
@synthesize userName      = _userName;
@synthesize userBirthday  = _userBirthday;
@synthesize userPhoneNum  = _userPhoneNum;
@synthesize userAvatar    = _userAvatar;
//@synthesize userAvatarName = _userAvatarName;
@synthesize userAddress   = _userAddress;
@synthesize userSex       = _userSex;
@synthesize userAge       = _userAge;
@synthesize userSignature = _userSignature;
@synthesize userType      = _userType;
//@synthesize arrLandMark = _arrLandMark;
@synthesize searching     = _searching;
@synthesize distance = _distance;
@synthesize deposit = _deposit;

@synthesize score = _score;
@synthesize price = _price;
@synthesize stuAllCount = _stuAllCount;


+ (instancetype)coachWithIdNoAvatar:(NSString *)userId
                               name:(NSString *)name
{
    LyCoach *coach = [[LyCoach alloc] initWithIdNoAvatar:userId
                                                    name:name];
    
    return coach;
}

- (instancetype)initWithIdNoAvatar:(NSString *)userId
                              name:(NSString *)name
{
    if (self = [super init]) {
        _userId = userId;
        _userName = name;
    }
    _userType = LyUserType_coach;
    
    
    return self;
}

+ (instancetype)coachWithId:(NSString *)userId
                       name:(NSString *)name {
    LyCoach *coach = [[LyCoach alloc] initWithId:userId
                                            name:name];
    
    return coach;
}

- (instancetype)initWithId:(NSString *)userId
                      name:(NSString *)name {
    if (self = [super init]) {
        
        
        _userId = userId;
        _userName = name;
        
        [LyImageLoader loadAvatarWithUserId:_userId
                                   complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSString * _Nullable userId) {
                                       if (!image) {
                                           image = [LyUtil defaultAvatarForTeacher];
                                       }
                                       _userAvatar = image;
                                   }];
    }
    
    _userType = LyUserType_coach;
    
    return self;
}


+ (instancetype)coachWithId:(NSString *)userId
                       name:(NSString *)name
                  signature:(NSString *)signature
                        sex:(LySex)sex {
    LyCoach *coach = [[LyCoach alloc] initWithId:userId
                                            name:name
                                       signature:signature
                                             sex:sex];
    
    return coach;
}

- (instancetype)initWithId:(NSString *)userId
                      name:(NSString *)name
                 signature:(NSString *)signature
                       sex:(LySex)sex
{
    if (self = [super init])
    {
        _userType = LyUserType_coach;
        
        _userId = userId;
        _userName = name;
        _userSignature = signature;
        
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


+ (instancetype)coachWithId:(NSString *)userId
                       name:(NSString *)name
                      score:(float)score
                        sex:(LySex)sex
                   birthday:(NSString *)birthday
              teachBirthday:(NSString *)teachBirthday
              driveBirthday:(NSString *)driveBirthday
              stuAllCount:(int)stuAllCount
         teachedPassedCount:(int)teachedPassedCount
            evaluationCount:(int)evaluationCount
                praiseCount:(int)praiseCount
               consultCount:(int)consultCount
                      price:(float)price
{
    LyCoach *coach = [LyCoach coachWithId:userId
                                     name:name
                                    score:score
                                      sex:sex
                                 birthday:birthday
                            teachBirthday:teachBirthday
                            driveBirthday:driveBirthday
                            stuAllCount:stuAllCount
                       teachedPassedCount:teachedPassedCount
                          evaluationCount:evaluationCount
                              praiseCount:praiseCount
                             consultCount:consultCount
                                    price:price];
    
    return coach;
}

- (instancetype)initWithId:(NSString *)userId
                      name:(NSString *)name
                     score:(float)score
                       sex:(LySex)sex
                  birthday:(NSString *)birthday
             teachBirthday:(NSString *)teachBirthday
             driveBirthday:(NSString *)driveBirthday
             stuAllCount:(int)stuAllCount
        teachedPassedCount:(int)teachedPassedCount
           evaluationCount:(int)evaluationCount
               praiseCount:(int)praiseCount
              consultCount:(int)consultCount
                     price:(float)price
{
    if (self = [super init])
    {
        _userType = LyUserType_coach;
        
        _userId = userId;
        _userName = name;
        _score = score;
        _userSex = sex;
        _userBirthday = birthday;
        _userTeachBirthday = teachBirthday;
        _userDriveBirthday = driveBirthday;
        _stuAllCount = stuAllCount;
        _teachedPassedCount = teachedPassedCount;
        _evaluationCount = evaluationCount;
        _praiseCount = praiseCount;
        _consultCount = consultCount;
        _price = price;
        
        _userTeachedAge = [LyUtil calculdateAgeWithStr:_userTeachBirthday];
        _userDrivedAge = [LyUtil calculdateAgeWithStr:_userDriveBirthday];

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

+ (instancetype)coachWithId:(NSString *)coaId
                    coaName:(NSString *)coaName {
    LyCoach *coach = [[LyCoach alloc] initWithId:coaId
                                         coaName:coaName];
    
    return coach;
}

- (instancetype)initWithId:(NSString *)coaId
                   coaName:(NSString *)coaName {
    if ( self = [super init]) {
        _userId = coaId;
        _userName = coaName;
        
        [LyImageLoader loadAvatarWithUserId:_userId
                                   complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSString * _Nullable userId) {
                                       if (!image) {
                                           image = [LyUtil defaultAvatarForTeacher];
                                       }
                                       _userAvatar = image;
                                   }];
    }
    
    _userType = LyUserType_coach;
    
    return self;
}


+ (instancetype)coachWithId:(NSString *)coaId
                    coaName:(NSString *)coaName
               coaSignature:(NSString *)coaSignature
                     coaSex:(LySex)coaSex {
    LyCoach *tmpCoach = [[LyCoach alloc] initWithId:coaId
                                            coaName:coaName
                                       coaSignature:coaSignature
                                             coaSex:coaSex];
    
    return tmpCoach;
}

- (instancetype)initWithId:(NSString *)coaId
                   coaName:(NSString *)coaName
              coaSignature:(NSString *)coaSignature
                    coaSex:(LySex)coaSex {
    if ( self = [super init]) {
        _userId = coaId;
        _userName = coaName;
        _userSignature = coaSignature;
        _userSex = coaSex;
        
        [LyImageLoader loadAvatarWithUserId:_userId
                                   complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSString * _Nullable userId) {
                                       if (!image) {
                                           image = [LyUtil defaultAvatarForTeacher];
                                       }
                                       _userAvatar = image;
                                   }];
    }
    _userType = LyUserType_coach;
    
    
    return self;
}



- (NSString *)userTypeByString {
    return userTypeCoachKey;
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


- (void)setTrainBaseName:(NSString *)trainBaseName
{
    if (trainBaseName && [LyUtil validateString:trainBaseName])
    {
        _trainBaseName = trainBaseName;
    }
    else
    {
        _trainBaseName = @"";
    }
}



- (NSString *)teachingCountByString
{
    return [[NSString alloc] initWithFormat:@"当前在教学员：%d人", _teachingCount];
}

- (NSString *)monthOrderCountByString
{
    return [[NSString alloc] initWithFormat:@"当月累计订单：%d单", _monthOrderCount];
}

- (NSString *)allOrderCountByString
{
    return [[NSString alloc] initWithFormat:@"累计订单：%d单", _allOrderCount];
}

- (NSString *)teachAllCountByString
{
    return [[NSString alloc] initWithFormat:@"已教学员：%d人", _stuAllCount];
}


@end
