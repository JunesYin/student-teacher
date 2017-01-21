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
//@property ( strong, nonatomic, nullable)            NSString                *userAvatarName;
@property ( strong, nonatomic)                      NSString                *userAddress;
@property ( strong, nonatomic)                      NSString                *userSignature;
@property ( assign, nonatomic)                      LySex                   userSex;
@property ( assign, nonatomic)                      int                     userAge;
@property ( assign, nonatomic, readonly)            LyUserType              userType;


@property (strong, nonatomic)                       NSString                *userDriveBirthday;
@property (strong, nonatomic)                       NSString                *userTeachBirthday;

@property (assign, nonatomic)                       int                     userDrivedAge;
@property (assign, nonatomic)                       int                     userTeachedAge;

@property (assign, nonatomic, getter=isSearching)   BOOL                    searching;

@property ( assign, nonatomic)                      double                  distance;



@property (assign, nonatomic)       float       score;
@property (assign, nonatomic)       int         stuAllCount;
@property (assign, nonatomic)       float       price;


@property (assign, nonatomic)                       int                     allOrderCount;
@property (assign, nonatomic)                       int                     monthOrderCount;

@property ( strong, nonatomic)                      NSString                *trainBaseId;
@property (retain, nonatomic)                       NSString                *trainBaseName;


@property ( assign, nonatomic)                      LyCoachMode             coachMode;
@property ( strong, nonatomic)                      NSString                *masterId;
@property (strong, nonatomic)                       NSString                *bossId;

@property ( strong, nonatomic)                      NSString                *description;
@property ( strong, nonatomic)                      NSString                *pickRange;
//@property ( assign, nonatomic)                      float                   score;               //星级
//@property ( assign, nonatomic)                      int                     teachAllCount;       //所有学生数
@property ( assign, nonatomic)                      int                     teachedPassedCount;  //已通过学生数
@property ( assign, nonatomic)                      int                     teachingCount;       //正在教学生数
//@property ( assign, nonatomic)                      float                   price;               //价格
@property ( assign, nonatomic)                      int                     praiseCount;         //好评数
@property ( assign, nonatomic)                      int                     evaluationCount;      //总评论数
@property ( assign, nonatomic)                      int                     consultCount;
@property ( assign, nonatomic)                      int                     teachAllPeriod;
@property ( assign, nonatomic)                      BOOL                    timeFlag;
@property ( assign, nonatomic)                      BOOL                    authFlag;

@property ( strong, nonatomic)                      NSMutableArray          *arrPicUrl;

@property ( assign, nonatomic)                      double          deposit;


+ (instancetype)coachWithIdNoAvatar:(NSString *)userId
                               name:(NSString *)name;

- (instancetype)initWithIdNoAvatar:(NSString *)userId
                              name:(NSString *)name;


+ (instancetype)coachWithId:(NSString *)userId
                       name:(NSString *)name;

- (instancetype)initWithId:(NSString *)userId
                      name:(NSString *)name;


+ (instancetype)coachWithId:(NSString *)userId
                       name:(NSString *)name
                  signature:(NSString *)signature
                        sex:(LySex)sex;

- (instancetype)initWithId:(NSString *)userId
                      name:(NSString *)name
                 signature:(NSString *)signature
                       sex:(LySex)sex;

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
                      price:(float)price;

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
                     price:(float)price;


- (NSString *)userTypeByString;

- (NSString *)teachingCountByString;
- (NSString *)monthOrderCountByString;
- (NSString *)allOrderCountByString;
- (NSString *)teachAllCountByString;


@end
