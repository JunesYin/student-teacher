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
@synthesize userPhoneNum  = _userPhoneNum;
@synthesize userAvatar    = _userAvatar;
@synthesize userAddress   = _userAddress;
@synthesize userSignature = _userSignature;
@synthesize userType      = _userType;
@synthesize arrLandMark   = _arrLandMark;
@synthesize searching     = _searching;
@synthesize distance = _distance;
@synthesize deposit = _deposit;
@synthesize precedence = _precedence;

@synthesize score = _score;
@synthesize price = _price;
@synthesize stuAllCount = _stuAllCount;



+ (instancetype)userWithId:(NSString *)userId userName:(NSString *)userName
{
    LyDriveSchool *school = [[LyDriveSchool alloc] initWithId:userId userName:userName];
    
    return school;
}

- (instancetype)initWithId:(NSString *)userId userName:(NSString *)userName
{
    if (self = [super initWithId:userId userName:userName]) {
        _userId = userId;
        _userName = userName;
        _userType = LyUserType_school;
    }
    
    return self;
}


//+ (instancetype)driveSchoolWithIdNoAvatar:(NSString *)userId
//                                 userName:(NSString *)userName
//{
//    LyDriveSchool *school = [[LyDriveSchool alloc] initWithIdNoAvatar:userId
//                                                             userName:userName];
//    
//    return school;
//}
//
//- (instancetype)initWithIdNoAvatar:(NSString *)userId
//                          userName:(NSString *)userName
//{
//    if (self = [super init]) {
//        _userId = userId;
//        _userName = userName;
//    }
//    
//    _userType = LyUserType_school;
//    
//    return self;
//}
//
//
//
//
//
//+ (instancetype)driveSchoolWithId:(NSString *)dschId
//                         dschName:(NSString *)dschName
//{
//    LyDriveSchool *tmpDsch = [[LyDriveSchool alloc] initWithId:dschId
//                                                      dschName:dschName];
//    
//    return tmpDsch;
//}
//
//- (instancetype)initWithId:(NSString *)dschId
//                  dschName:(NSString *)dschName
//{
//    if ( self = [super init])
//    {
//        _userId = dschId;
//        _userName = dschName;
//        
//        [LyImageLoader loadAvatarWithUserId:_userId
//                                   complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSString * _Nullable userId) {
//                                       if (!image) {
//                                           image = [LyUtil defaultAvatarForTeacher];
//                                       }
//                                       _userAvatar = image;
//                                   }];
//    }
//    
//    
//    _userType = LyUserType_school;
//    _distance = MAXFLOAT;
//    
//    return self;
//}



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
//        _dschScore = dschScore;
//        _dschStudentAllCount = dschAllCount;
//        _dschPrice = dschPrice;
        
        _score = score;
        _price = price;
        _stuAllCount = stuAllCount;
        
        [LyImageLoader loadAvatarWithUserId:dschId
                                   complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSString * _Nullable userId) {
                                       if (!image) {
                                           image = [LyUtil defaultAvatarForTeacher];
                                       }
                                       _userAvatar = image;
                                   }];
    }
    
    _userType = LyUserType_school;
    _distance = MAXFLOAT;
    
    
    return self;
}


- (NSString *)userTypeByString {
    return userTypeSchoolKey;
}



- (NSString *)userName {
    if (!_userName || ![LyUtil validateString:_userName]) {
        return @"匿名用户";
    }
    
    return _userName;
}


- (void)setBannerUrl:(NSString *)bannerUrl {
#ifdef __Ly__HTTPS__FLAG__
    bannerUrl = [bannerUrl stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
#endif
    
    _bannerUrl = bannerUrl;
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
        int iPerNum = 100 * _dschStudentPassCount / _stuAllCount;
        iPerNum = (iPerNum > 100) ? 100 : iPerNum;
        
        return [[NSString alloc] initWithFormat:@"%d%%", iPerNum];
    }
}

- (NSString *)perPraise {
    if (_dschPraiseCount < 1) {
        return @"0%";
    }
    else {
        int iPerNum = 100 * _dschPraiseCount / _dschEvalutionCount;
        iPerNum = (iPerNum > 100) ? 100 : iPerNum;
        
        return [[NSString alloc] initWithFormat:@"%d%%", iPerNum];
    }
}



- (NSString *)dschPickRange {
    if (!_dschPickRange || [_dschPickRange isKindOfClass:[NSNull class]] || ![_dschPickRange isKindOfClass:[NSString class]] || _dschPickRange.length < 1 || [_dschPickRange rangeOfString:@"null"].length > 0) {
        return @"";
    }
    
    return _dschPickRange;
}


- (void)addPicUrl:(NSString *)picUrl {
#ifdef __Ly__HTTPS__FLAG__
    picUrl = [picUrl stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
#endif
    if (!_dschArrPicUrl) {
        _dschArrPicUrl = [[NSMutableArray alloc] initWithCapacity:1];
    }
    
    if (/*0 > [_dschArrPicUrl indexOfObject:picUrl] ||*/ [_dschArrPicUrl indexOfObject:picUrl] > _dschArrPicUrl.count) {
        [_dschArrPicUrl addObject:picUrl];
    }
}


- (void)setLastSignInfo:(NSString *)studentName andTime:(NSString *)signTime
{
    signTime = [LyUtil fixDateTimeString:signTime];
    
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




@end
