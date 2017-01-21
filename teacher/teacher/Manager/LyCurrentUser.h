//
//  LyCurrentUser.h
//  teacher
//
//  Created by Junes on 16/7/22.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyUser.h"


typedef NS_ENUM(NSInteger, LyTeacherVerifyState)
{
    LyTeacherVerifyState_null = 0,
    LyTeacherVerifyState_rejected,
    LyTeacherVerifyState_verifying,
    LyTeacherVerifyState_access
};


NS_ASSUME_NONNULL_BEGIN



@interface LyCurrentUser : LyUser

@property (strong, nonatomic, nonnull) NSString            *userId;
@property (strong, nonatomic, nullable) NSString            *userName;
@property (strong, nonatomic, nullable) NSString            *userBirthday;
@property (strong, nonatomic, nullable) NSString            *userPhoneNum;
@property (strong, nonatomic, nullable) UIImage             *userAvatar;
@property ( strong, nonatomic, nullable) NSString      *userAddress;
@property (assign, nonatomic          ) LySex               userSex;
@property (assign, nonatomic, readonly) int                 userAge;
@property (assign, nonatomic          ) float               userBalance;
@property (assign, nonatomic          ) float               user5Coin;
@property (assign, nonatomic          ) LyUserType          userType;
@property (assign, nonatomic          ) LyUserLevel         userLevel;

@property (assign, nonatomic)           LyLicenseType       userLicense;

@property (assign, nonatomic          ) BOOL                userHavePayPwd;

@property ( assign, nonatomic)          LyTeacherVerifyState    verifyState;
@property (assign, nonatomic)           BOOL                timeFlag;

@property (assign, nonatomic)           LyCoachMode         coachMode;
@property (assign, nonatomic, readonly) BOOL                isMaster;
@property (assign, nonatomic, readonly) BOOL                isBoss;
@property (strong, nonatomic, nullable) NSString            *userDriveBirthday;
@property (strong, nonatomic, nullable) NSString            *userTeachBirthday;
@property (assign, nonatomic)           int                 userDrivedAge;
@property (assign, nonatomic)           int                 userTeachedAge;
@property (strong, nonatomic, nullable) NSString            *masterId;
@property (strong, nonatomic, nullable) NSString            *masterName;
@property (strong, nonatomic, nullable) NSString            *trainBaseId;
@property (strong, nonatomic, nullable) NSString            *trainBaseName;


@property (strong, nonatomic, nullable) NSString            *schoolTrueName;
@property (strong, nonatomic, nullable) LyLocation         *location;


@property (assign, nonatomic)           BOOL                isLogined;





+ (instancetype)curUser;

- (void)setUserTypeWithString:(NSString *)strUserType;

- (NSString *)userTypeByString;

- (void)logout;

- (void)setLocationWithLatitude:(CLLocationDegrees)lititude andLongitude:(CLLocationDegrees)longitude;

- (void)setLocationWithLocation:(CLLocation *)location;


- (NSString *)teachingCountByString;
- (NSString *)monthOrderCountByString;
- (NSString *)allOrderCountByString;
- (NSString *)teachAllCountByString;



@end


NS_ASSUME_NONNULL_END

