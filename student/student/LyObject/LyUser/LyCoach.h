//
//  LyCoach.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/16.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LyUser.h"
#import "LyUtil.h"



@interface LyCoach : LyUser

@property ( strong, nonatomic)                      NSString                *userId;
@property ( strong, nonatomic)                      NSString                *userName;
@property ( strong, nonatomic)                      NSString                *userBirthday;
@property ( strong, nonatomic)                      NSString                *userPhoneNum;
@property ( strong, nonatomic)                      UIImage                 *userAvatar;
@property ( strong, nonatomic)                      NSString                *userAddress;
@property ( strong, nonatomic)                      NSString                *userSignature;
@property ( assign, nonatomic)                      LySex                   userSex;
@property ( assign, nonatomic)                      int                     userAge;
@property ( assign, nonatomic, readonly)            LyUserType              userType;

@property ( assign, nonatomic          ) LyLicenseType userLicenseType;

@property ( strong, nonatomic, readonly)            NSMutableArray          *arrLandMark;
@property (assign, nonatomic, getter=isSearching)   BOOL                    searching;

@property ( assign, nonatomic)                      double                  distance;
@property (assign, nonatomic)   int     precedence;


@property (assign, nonatomic)       float   price;
@property (assign, nonatomic)       float   score;
@property (assign, nonatomic)       int     stuAllCount;


@property (strong, nonatomic)       NSString        *bossId;

@property ( assign, nonatomic)                      LyCoachMode             coaMode;
@property ( strong, nonatomic)                      NSString                *coaMasterId;
@property ( strong, nonatomic)                      NSString                *coaTrainBaseId;
@property ( strong, nonatomic)                      NSString                *coaDescription;
@property ( strong, nonatomic)                      NSString                *coaPickRange;
//@property ( assign, nonatomic)                      float                   coaScore;               //星级
@property ( strong, nonatomic)                      NSString                *coaTeachBirthday;
@property ( assign, nonatomic, readonly)            int                     coaTeachedAge;          //教车年龄
@property ( strong, nonatomic)                      NSString                *coaDriveBirthday;
@property ( assign, nonatomic, readonly)            int                     coaDrivedAge;           //驾车年龄
//@property ( assign, nonatomic)                      int                     coaTeachAllCount;       //所有学生数
@property ( assign, nonatomic)                      int                     coaTeachedPassedCount;  //已通过学生数
@property ( assign, nonatomic)                      int                     coaTeachableCount;      //可教学生数
@property ( assign, nonatomic)                      int                     coaTeachingCount;       //正在教学生数
//@property ( assign, nonatomic)                      float                   coaPrice;               //价格
@property ( assign, nonatomic)                      int                     coaPraiseCount;         //好评数
@property ( assign, nonatomic)                      int                     coaEvaluationCount;      //总评论数
@property ( assign, nonatomic)                      int                     coaConsultCount;
@property ( assign, nonatomic)                      BOOL                    timeFlag;
@property ( assign, nonatomic)                      LyTeacherVerifyState    coaVerifyState;
@property ( assign, nonatomic)                      int                     coaTeachAllPeriod;

@property ( strong, nonatomic, readonly)                      NSMutableArray          *coaArrPicUrl;

@property ( assign, nonatomic)           double          deposit;







+ (instancetype)coachWithIdNoAvatar:(NSString *)userId
                               name:(NSString *)name;

- (instancetype)initWithIdNoAvatar:(NSString *)userId
                              name:(NSString *)name;


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
                      price:(float)price;


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
                     price:(float)price;


+ (instancetype)coachWithId:(NSString *)coaId
                    coaName:(NSString *)coaName;

- (instancetype)initWithId:(NSString *)coaId
                   coaName:(NSString *)coaName;


+ (instancetype)coachWithId:(NSString *)coaId
                    coaName:(NSString *)coaName
               coaSignature:(NSString *)coaSignature
                     coaSex:(LySex)coaSex;

- (instancetype)initWithId:(NSString *)coaId
                   coaName:(NSString *)coaName
              coaSignature:(NSString *)coaSignature
                    coaSex:(LySex)coaSex;


- (NSString *)userTypeByString;

- (NSString *)perPass;

- (NSString *)perPraise;

- (void)addPicUrl:(NSString *)picUrl;

- (NSString *)userLicenseTypeByString;



@end
