//
//  LyGuider.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/29.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyGuider.h"
#import "LyCurrentUser.h"

@implementation LyGuider

@synthesize userId           = _userId;
@synthesize userName         = _userName;
@synthesize userBirthday     = _userBirthday;
@synthesize userPhoneNum     = _userPhoneNum;
@synthesize userAvatar       = _userAvatar;
//@synthesize userAvatarName   = _userAvatarName;
@synthesize userAddress      = _userAddress;
@synthesize userSex          = _userSex;
@synthesize userAge          = _userAge;
@synthesize userSignature    = _userSignature;
@synthesize userType         = _userType;
//@synthesize arrLandMark   = _arrLandMark;
@synthesize searching     = _searching;
@synthesize distance = _distance;
@synthesize deposit = _deposit;


@synthesize score = _score;
@synthesize price = _price;
@synthesize stuAllCount = _stuAllCount;



+ (instancetype)guiderWithGuiderId:(NSString *)guiId
                           guiName:(NSString *)guiName {
    LyGuider *tmpGuider = [[LyGuider alloc] initWithGuiderId:guiId
                                                     guiName:guiName];
    
    return tmpGuider;
}

- (instancetype)initWithGuiderId:(NSString *)guiId
                         guiName:(NSString *)guiName {
    if ( self = [super init]) {
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
    return self;
}



+ (instancetype)guiderWithId:(NSString *)guiId
                     guiName:(NSString *)guiName
                       score:(float)score
                      guiSex:(LySex)guiSex
                 guiBirthday:(NSString *)guiBirthday
               guiTeachedAge:(int)guiTeachedAge
                 stuAllCount:(int)stuAllCount
       coaTeachedPassedCount:(int)guiTeachedPassedCount
           guiEvalutionCount:(int)guiEvalutionCount
              guiPraiseCount:(int)guiPraiseCount
                       price:(float)price
{
    LyGuider *tmpGuider = [[LyGuider alloc] initWithId:guiId
                                               guiName:guiName
                                                 score:score
                                                guiSex:guiSex
                                           guiBirthday:guiBirthday
                                         guiTeachedAge:guiTeachedAge
                                           stuAllCount:stuAllCount
                                 coaTeachedPassedCount:guiTeachedPassedCount
                                     guiEvalutionCount:guiEvalutionCount
                                        guiPraiseCount:guiPraiseCount
                                                 price:price];
    
    return tmpGuider;
}



- (instancetype)initWithId:(NSString *)guiId
                   guiName:(NSString *)guiName
                     score:(float)score
                    guiSex:(LySex)guiSex
               guiBirthday:(NSString *)guiBirthday
             guiTeachedAge:(int)guiTeachedAge
               stuAllCount:(int)stuAllCount
     coaTeachedPassedCount:(int)guiTeachedPassedCount
         guiEvalutionCount:(int)guiEvalutionCount
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
        _userAge = [LyUtil calculdateAgeWithStr:_userBirthday];
        
        _guiTeachedAge = guiTeachedAge;
//        _guiTeachAllCount = guiTeachAllCount;
        _guiTeachedPassedCount = guiTeachedPassedCount;
        _guiEvalutionCount = guiEvalutionCount;
        _guiPraiseCount = guiPraiseCount;
//        _guiPrice = guiPrice;
        
        _score = score;
        _stuAllCount = stuAllCount;
        _price = stuAllCount;
        
        [LyImageLoader loadAvatarWithUserId:_userId
                                   complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSString * _Nullable userId) {
                                       if (!image) {
                                           image = [LyUtil defaultAvatarForTeacher];
                                       }
                                       _userAvatar = image;
                                   }];
    }
    _userType = LyUserType_guider;
    
    
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



- (NSString *)getGuiPickRange
{
    if ( !_guiPickRange || ![_guiPickRange count])
    {
        return @"无";
    }
    
    NSMutableString *strResult = [[NSMutableString alloc] initWithString:[[NSString alloc] initWithFormat:@""]];
    
    NSEnumerator *enumerator = [_guiPickRange objectEnumerator];
    
    NSString *item;
    while ( item = [enumerator nextObject])
    {
        [strResult appendFormat:@"%@ ", item];
    }
    
    
    return [[strResult substringToIndex:[strResult length]-1] copy];
}





@end



