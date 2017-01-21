//
//  LyGuider.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/29.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyGuider.h"
#import "LyCurrentUser.h"

#import "LyUtil.h"

@implementation LyGuider

@synthesize userId           = _userId;
@synthesize userName         = _userName;
@synthesize userBirthday     = _userBirthday;
@synthesize userPhoneNum     = _userPhoneNum;
@synthesize userAvatar       = _userAvatar;
@synthesize userAddress      = _userAddress;
@synthesize userSex          = _userSex;
@synthesize userAge          = _userAge;
@synthesize userSignature    = _userSignature;
@synthesize userType         = _userType;
@synthesize arrLandMark   = _arrLandMark;
@synthesize searching     = _searching;
@synthesize distance = _distance;
@synthesize precedence = _precedence;
@synthesize deposit = _deposit;
@synthesize userLicenseType = _userLicenseType;

@synthesize score = _score;
@synthesize price = _price;
@synthesize stuAllCount = _stuAllCount;


+ (instancetype)guiderWithIdNoAvatar:(NSString *)userId
                            userName:(NSString *)userName
{
    LyGuider *guider = [[LyGuider alloc] initWithIdNoAvatar:userId
                                                   userName:userName];
    
    return guider;
}

- (instancetype)initWithIdNoAvatar:(NSString *)userId
                          userName:(NSString *)userName
{
    if (self = [super init]) {
        _userId = userId;
        _userName = userName;
    }
    
    _userType = LyUserType_guider;
    
    return self;
}


+ (instancetype)guiderWithGuiderId:(NSString *)guiId
                           guiName:(NSString *)guiName
{
    LyGuider *tmpGuider = [[LyGuider alloc] initWithGuiderId:guiId
                                                     guiName:guiName];
    
    return tmpGuider;
}

- (instancetype)initWithGuiderId:(NSString *)guiId
                         guiName:(NSString *)guiName
{
    if ( self = [super init])
    {
        _userId = guiId;
        _userName = guiName;
        
        [LyImageLoader loadAvatarWithUserId:_userId
                                   complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSString * _Nullable userId) {
                                       if (!image) {
                                           image = [LyUtil defaultAvatarForTeacher];
                                       }
                                       _userAvatar = image;
                                   }];
    }
    
    _userType = LyUserType_guider;
    _distance = MAXFLOAT;
    
    return self;
}



+ (instancetype)guiderWithId:(NSString *)guiId
                     guiName:(NSString *)guiName
                       score:(float)score
                      guiSex:(LySex)guiSex
                 guiBirthday:(NSString *)guiBirthday
            guiTeachBirthday:(NSString *)guiTeachBirthday
            guiDriveBirthday:(NSString *)guiDriveBirthday
                 stuAllCount:(int)stuAllCount
       coaTeachedPassedCount:(int)guiTeachedPassedCount
           guiEvaluationCount:(int)guiEvaluationCount
              guiPraiseCount:(int)guiPraiseCount
                       price:(float)price
{
    LyGuider *tmpGuider = [[LyGuider alloc] initWithId:guiId
                                               guiName:guiName
                                                 score:score
                                                guiSex:guiSex
                                           guiBirthday:guiBirthday
                                      guiTeachBirthday:guiTeachBirthday
                                      guiDriveBirthday:guiDriveBirthday
                                           stuAllCount:stuAllCount
                                 coaTeachedPassedCount:guiTeachedPassedCount
                                     guiEvaluationCount:guiEvaluationCount
                                        guiPraiseCount:guiPraiseCount
                                                 price:price];
    
    return tmpGuider;
}



- (instancetype)initWithId:(NSString *)guiId
                   guiName:(NSString *)guiName
                     score:(float)score
                    guiSex:(LySex)guiSex
               guiBirthday:(NSString *)guiBirthday
          guiTeachBirthday:(NSString *)guiTeachBirthday
          guiDriveBirthday:(NSString *)guiDriveBirthday
               stuAllCount:(int)stuAllCount
     coaTeachedPassedCount:(int)guiTeachedPassedCount
         guiEvaluationCount:(int)guiEvaluationCount
            guiPraiseCount:(int)guiPraiseCount
                     price:(float)price
{
    if ( self = [super init])
    {
        _userId = guiId;
        _userName = guiName;
//        _guiScore = guiScore;
        _userSex = guiSex;
        _userBirthday = guiBirthday;
        _guiTeachBirthday = guiTeachBirthday;
        _guiDriveBirthday = guiDriveBirthday;
//        _guiTeachAllCount = guiTeachAllCount;
        _guiTeachedPassedCount = guiTeachedPassedCount;
        _guiEvaluationCount = guiEvaluationCount;
        _guiPraiseCount = guiPraiseCount;
//        _guiPrice = guiPrice;
        
        _score = score;
        _price = price;
        _stuAllCount = stuAllCount;
        
        
        _userAge = [LyUtil calculdateAgeWithStr:_userBirthday];
        _guiTeachedAge = [LyUtil calculdateAgeWithStr:_guiTeachBirthday];
        _guiDrivedAge = [LyUtil calculdateAgeWithStr:_guiDriveBirthday];
        
        [LyImageLoader loadAvatarWithUserId:_userId
                                   complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSString * _Nullable userId) {
                                       if (!image) {
                                           image = [LyUtil defaultAvatarForTeacher];
                                       }
                                       _userAvatar = image;
                                   }];
    }
    _userType = LyUserType_guider;
    _distance = MAXFLOAT;
    
    return self;
}



- (NSString *)userTypeByString {
    return userTypeGuiderKey;
}


- (void)setUserBirthday:(NSString *)userBirthday {
    
    _userBirthday = userBirthday;
    
    if (!_userBirthday || [_userBirthday isKindOfClass:[NSNull class]]) {
        _userBirthday = @"";
    }
    
    _userAge = [LyUtil calculdateAgeWithStr:_userBirthday];
}



- (void)setGuiTeachBirthday:(NSString *)guiTeachBirthday {

    _guiTeachBirthday = guiTeachBirthday;
    
    if (!_guiTeachBirthday || [_guiTeachBirthday isKindOfClass:[NSNull class]]) {
        _guiTeachBirthday = @"";
    }
    
    _guiTeachedAge = [LyUtil calculdateAgeWithStr:_guiTeachBirthday];
}


- (void)setGuiDriveBirthday:(NSString *)guiDriveBirthday {
    _guiDriveBirthday = guiDriveBirthday;
    
    if (!_guiDriveBirthday || [_guiDriveBirthday isKindOfClass:[NSNull class]]) {
        _guiDriveBirthday = @"";
    }
    
    
    _guiDrivedAge = [LyUtil calculdateAgeWithStr:_guiDriveBirthday];
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
        int iPerNum = 100 * _guiTeachedPassedCount / _stuAllCount;
        iPerNum = (iPerNum > 100) ? 100 : iPerNum;
        
        return [[NSString alloc] initWithFormat:@"%d%%", iPerNum];
    }
}

- (NSString *)perPraise {
    if (_guiPraiseCount < 1) {
        return @"0%";
    }
    else {
        int iPerNum = 100 * _guiPraiseCount / _guiEvaluationCount;
        iPerNum = (iPerNum > 100) ? 100 : iPerNum;
        
        return [[NSString alloc] initWithFormat:@"%d%%", iPerNum];
    }
}



- (NSString *)guiPickRange {
    if (!_guiPickRange || [_guiPickRange isKindOfClass:[NSNull class]] || ![_guiPickRange isKindOfClass:[NSString class]] || _guiPickRange.length < 1 || [_guiPickRange rangeOfString:@"null"].length > 0) {
        return @"";
    }
    
    return _guiPickRange;
}


- (void)addPicUrl:(NSString *)picUrl {
#ifdef __Ly__HTTPS__FLAG__
    picUrl = [picUrl stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
#endif
    
    if (!_guiArrPicUrl) {
        _guiArrPicUrl = [[NSMutableArray alloc] initWithCapacity:1];
    }
    
    if (/*0 > [_guiArrPicUrl indexOfObject:picUrl] ||*/ [_guiArrPicUrl indexOfObject:picUrl] > _guiArrPicUrl.count) {
        [_guiArrPicUrl addObject:picUrl];
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



