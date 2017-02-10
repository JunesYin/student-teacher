//
//  LyDriveSchool.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/5.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LyLandMark.h"
#import "LyUser.h"
#import "LyUtil.h"


@class LyLandMark;

@interface LyDriveSchool : LyUser


@property ( strong, nonatomic)                      NSString                *userId;
@property ( strong, nonatomic)                      NSString                *userName;
@property ( strong, nonatomic)                      NSString                *userPhoneNum;
@property ( strong, nonatomic)                      UIImage                 *userAvatar;
@property ( strong, nonatomic)                      NSString                *userAddress;
@property ( strong, nonatomic)                      NSString                *userSignature;
@property ( assign, nonatomic, readonly)            LyUserType              userType;


@property ( strong, nonatomic, readonly)            NSMutableArray          *arrLandMark;

@property (assign, nonatomic, getter=isSearching)   BOOL                    searching;

@property ( assign, nonatomic)                      double                  distance;
@property (assign, nonatomic)   int     precedence;



@property (assign, nonatomic)       float   price;
@property (assign, nonatomic)       float   score;
@property (assign, nonatomic)       int     stuAllCount;



@property ( strong, nonatomic)                          NSString                                *dschDescription;
@property ( strong, nonatomic)                          NSString                                *dschTrainAddress;
@property ( strong, nonatomic)                          NSString                                *dschPickRange;
//@property ( assign, nonatomic)                          int                                     dschStudentAllCount;
@property ( assign, nonatomic)                          int                                     dschStudentPassCount;
@property ( assign, nonatomic)                          int                                     dschEvalutionCount;
@property ( assign, nonatomic)                          int                                     dschPraiseCount;
@property ( assign, nonatomic)                          int                                     dschConsultCount;
@property ( assign, nonatomic)                          BOOL                                    dschHotFlag;
@property ( assign, nonatomic)                          BOOL                                    dschRecommendFlag;
@property (assign, nonatomic)                             LyTeacherVerifyState                    dschVerifyState;
@property ( assign, nonatomic)                          BOOL                                    dschPickupFlag;
@property ( assign, nonatomic)                          BOOL                                    timeFlag;

@property ( strong, nonatomic, readonly)                NSMutableArray                          *dschArrPicUrl;


@property ( strong, nonatomic, readonly)                NSString                                *lastSignInfo;

@property ( strong, nonatomic)                          NSString                                *bannerUrl;

@property ( assign, nonatomic)           double          deposit;


+ (nullable instancetype)userWithId:(nullable NSString *)userId
                           userName:(nullable NSString *)userName;

- (nullable instancetype)initWithId:(nullable NSString *)userId
                           userName:(nullable NSString *)userName;



//+ (instancetype)driveSchoolWithIdNoAvatar:(NSString *)userId
//                                 userName:(NSString *)userName;
//
//- (instancetype)initWithIdNoAvatar:(NSString *)userId
//                          userName:(NSString *)userName;
//
//
//+ (instancetype)driveSchoolWithId:(NSString *)dschId
//                         dschName:(NSString *)dschName;
//
//- (instancetype)initWithId:(NSString *)dschId
//                  dschName:(NSString *)dschName;


+ (instancetype)driveShcoolWithDschId:(NSString *)dschId
                             dschName:(NSString *)dschName
                                score:(float)score
                          stuAllCount:(int)stuAllCount
                                price:(float)price;

- (instancetype)initWithDschId:(NSString *)dschId
                      dschName:(NSString *)dschName
                         score:(float)score
                   stuAllCount:(int)stuAllCount
                         price:(float)price;

- (NSString *)userTypeByString;

- (NSString *)perPass;

- (NSString *)perPraise;

- (void)addPicUrl:(NSString *)picUrl;

- (void)setLastSignInfo:(NSString *)studentName andTime:(NSString *)signTime;



@end
