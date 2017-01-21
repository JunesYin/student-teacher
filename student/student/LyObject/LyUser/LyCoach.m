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
@synthesize userAddress   = _userAddress;
@synthesize userSex       = _userSex;
@synthesize userAge       = _userAge;
@synthesize userSignature = _userSignature;
@synthesize userType      = _userType;
@synthesize arrLandMark = _arrLandMark;
@synthesize searching     = _searching;
@synthesize distance = _distance;
@synthesize precedence = _precedence;
@synthesize deposit = _deposit;
@synthesize userLicenseType = _userLicenseType;


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



+ (instancetype)coachWithId:(NSString *)coaId
                    coaName:(NSString *)coaName
                      score:(float)score 
                     coaSex:(LySex)coaSex
                coaBirthday:(NSString *)coaBirthday
           coaTeachBirthday:(NSString *)coaTeachBirthday
           coaDriveBirthday:(NSString *)coaDriveBirthday
                stuAllCount:(int)stuAllCount
      coaTeachedPassedCount:(int)coaTeachedPassedCount
          coaEvaluationCount:(int)coaEvaluationCount
             coaPraiseCount:(int)coaPraiseCount
                      price:(float)price
{
    LyCoach *tmpCoach = [[LyCoach alloc] initWithId:coaId
                                            coaName:coaName
                                              score:score
                                             coaSex:coaSex
                                        coaBirthday:coaBirthday
                                   coaTeachBirthday:coaTeachBirthday
                                   coaDriveBirthday:coaDriveBirthday
                                        stuAllCount:stuAllCount
                              coaTeachedPassedCount:coaTeachedPassedCount
                                  coaEvaluationCount:coaEvaluationCount
                                     coaPraiseCount:coaPraiseCount
                                              price:price];
    
    
    return tmpCoach;
}


- (instancetype)initWithId:(NSString *)coaId
                   coaName:(NSString *)coaName
                  score:(float)score
                    coaSex:(LySex)coaSex
               coaBirthday:(NSString *)coaBirthday
          coaTeachBirthday:(NSString *)coaTeachBirthday
          coaDriveBirthday:(NSString *)coaDriveBirthday
               stuAllCount:(int)stuAllCount
     coaTeachedPassedCount:(int)coaTeachedPassedCount
         coaEvaluationCount:(int)coaEvaluationCount
            coaPraiseCount:(int)coaPraiseCount
                     price:(float)price
{
    if ( self = [super init])
    {
        _userId = coaId;
        _userName = coaName;
//        _coaScore = coaScore;
        _userSex = coaSex;
        _userBirthday = coaBirthday;
        
        _coaTeachBirthday = coaTeachBirthday;
        _coaDriveBirthday = coaDriveBirthday;
//        _coaTeachAllCount = coaTeachAllCount;
        _coaTeachedPassedCount = coaTeachedPassedCount;
        _coaEvaluationCount = coaEvaluationCount;
        _coaPraiseCount = coaPraiseCount;
//        _coaPrice = coaPrice;
        
        _score = score;
        _price = price;
        _stuAllCount = stuAllCount;
        
        _userAge = [LyUtil calculdateAgeWithStr:_userBirthday];
        _coaTeachedAge = [LyUtil calculdateAgeWithStr:_coaTeachBirthday];
        _coaDrivedAge = [LyUtil calculdateAgeWithStr:_coaDriveBirthday];
        
        [LyImageLoader loadAvatarWithUserId:_userId
                                   complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSString * _Nullable userId) {
                                       if (!image) {
                                           image = [LyUtil defaultAvatarForTeacher];
                                       }
                                       _userAvatar = image;
                                   }];
    }
    
    
    _userType = LyUserType_coach;
    _distance = MAXFLOAT;
    
    return self;
}


+ (instancetype)coachWithId:(NSString *)coaId
                    coaName:(NSString *)coaName
{
    LyCoach *coach = [[LyCoach alloc] initWithId:coaId
                                         coaName:coaName];
    
    return coach;
}

- (instancetype)initWithId:(NSString *)coaId
                   coaName:(NSString *)coaName
{
    if ( self = [super init])
    {
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
    _distance = MAXFLOAT;
    
    return self;
}


+ (instancetype)coachWithId:(NSString *)coaId
                    coaName:(NSString *)coaName
               coaSignature:(NSString *)coaSignature
                     coaSex:(LySex)coaSex

{
    LyCoach *tmpCoach = [[LyCoach alloc] initWithId:coaId
                                            coaName:coaName
                                       coaSignature:coaSignature
                                             coaSex:coaSex];
    
    return tmpCoach;
}

- (instancetype)initWithId:(NSString *)coaId
                   coaName:(NSString *)coaName
              coaSignature:(NSString *)coaSignature
                    coaSex:(LySex)coaSex
{
    if ( self = [super init])
    {
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
    _distance = MAXFLOAT;
    
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


- (void)setCoaTeachBirthday:(NSString *)coaTeachBirthday {
    
    _coaTeachBirthday = coaTeachBirthday;
    
    if (!_coaTeachBirthday || [_coaTeachBirthday isKindOfClass:[NSNull class]]) {
        _coaTeachBirthday = @"";
    }
    
    _coaTeachedAge = [LyUtil calculdateAgeWithStr:_coaTeachBirthday];
}


- (void)setCoaDriveBirthday:(NSString *)coaDriveBirthday
{
    _coaDriveBirthday = coaDriveBirthday;
    
    if (!_coaDriveBirthday || [_coaDriveBirthday isKindOfClass:[NSNull class]]) {
        _coaDriveBirthday = @"";
    }
    
    _coaDrivedAge = [LyUtil calculdateAgeWithStr:_coaDriveBirthday];
}


- (NSString *)coaPickRange {
    if (!_coaPickRange || [_coaPickRange isKindOfClass:[NSNull class]] || ![_coaPickRange isKindOfClass:[NSString class]] || _coaPickRange.length < 1 || [_coaPickRange rangeOfString:@"null"].length > 0) {
        return @"";
    }
    
    return _coaPickRange;
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


- (NSString *)perPass {
    if (_stuAllCount < 1) {
        return @"0%";
    }
    else {
        int iPerNum = 100 *_coaTeachedPassedCount / _stuAllCount;
        iPerNum = (iPerNum > 100) ? 100 : iPerNum;
        
        return [[NSString alloc] initWithFormat:@"%d%%", iPerNum];
    }
}

- (NSString *)perPraise {
    if (_coaEvaluationCount < 1) {
        return @"0%";
    }
    else {
        int iPerNum = 100 * _coaPraiseCount / _coaEvaluationCount;
        iPerNum = (iPerNum > 100) ? 100 : iPerNum;
        
        return [[NSString alloc] initWithFormat:@"%d%%", iPerNum];
    }
}


- (void)addPicUrl:(NSString *)picUrl {
#ifdef __Ly__HTTPS__FLAG__
    picUrl = [picUrl stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
#endif
    
    if (!_coaArrPicUrl) {
        _coaArrPicUrl = [[NSMutableArray alloc] initWithCapacity:1];
    }
    
    if (/*0 > [_coaArrPicUrl indexOfObject:picUrl] ||*/ [_coaArrPicUrl indexOfObject:picUrl] > _coaArrPicUrl.count) {
        [_coaArrPicUrl addObject:picUrl];
    }
}


- (void)addLandMark:(LyLandMark *)landMark
{
    if ( !_arrLandMark)
    {
        _arrLandMark = [[NSMutableArray alloc] init];
    }
    
    if (_searching)
    {
        [_arrLandMark addObject:landMark];
    }
    else
    {
        if (_arrLandMark.count < teacherLandMarkMaxCount)
        {
            [_arrLandMark addObject:landMark];
        }
        else
        {
            for (int i = 0; i < _arrLandMark.count; ++i)
            {
                LyLandMark *item = [_arrLandMark objectAtIndex:i];
                if (item.distance > landMark.distance)
                {
                    _arrLandMark[i] = landMark;
                    break;
                }
            }
            
            [_arrLandMark sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                if ([obj1 distance] > [obj2 distance])
                {
                    return NSOrderedAscending;
                }
                else
                {
                    return NSOrderedDescending;
                }
            }];
        }
        
    }
    
    if ( 0 == _distance || (_distance > 0 && landMark.distance > 0 && landMark.distance < _distance))
    {
        _distance = landMark.distance;
    }
}


- (NSString *)userLicenseTypeByString {
    return [LyUtil driveLicenseStringFrom:_userLicenseType];
}



@end
