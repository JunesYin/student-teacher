//
//  LyCurrentUser.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/19.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LyUser.h"
#import "LyUtil.h"



typedef NS_ENUM(NSInteger, LyVerifyState)
{
    LyVerifyState_null = 0,
    LyVerifyState_rejected,
    LyVerifyState_verifying,
    LyVerifyState_access
};

NS_ASSUME_NONNULL_BEGIN

@interface LyCurrentUser : LyUser

@property ( strong, nonatomic, nonnull) NSString            *userId;
@property ( strong, nonatomic, nullable) NSString            *userName;
@property ( strong ,nonatomic, nullable) NSString            *userAvatarName;
@property ( strong, nonatomic, nullable) NSString            *userBirthday;
@property ( strong, nonatomic, nullable) NSString            *userPhoneNum;
@property ( strong, nonatomic, nullable) UIImage             *userAvatar;
@property ( assign, nonatomic          ) LySex               userSex;
@property ( assign, nonatomic, readonly) int                 userAge;
@property ( assign, nonatomic          ) float               userBalance;
@property ( assign, nonatomic          ) float               user5Coin;
@property ( assign, nonatomic          ) LyUserType          userType;
@property ( assign, nonatomic          ) LyUserLevel         userLevel;

@property ( assign, nonatomic          ) BOOL                userHavePayPwd;


@property ( assign, nonatomic          ) LyLicenseType       userLicenseType;
@property ( assign, nonatomic          ) LySubjectMode       userSubjectMode;


@property ( copy, nonatomic, nullable  ) NSString            *userDriveSchoolId;
@property ( copy, nonatomic, nullable  ) NSString            *userCoachId;
@property ( copy, nonatomic, nullable  ) NSString            *userGuiderId;
@property ( copy, nonatomic, nullable)   NSString           *userTrainClassId;
@property ( copy, nonatomic, nullable  ) NSString            *userDriveSchoolName;
@property ( copy, nonatomic, nullable  ) NSString            *userCoachName;
@property ( copy, nonatomic, nullable  ) NSString            *userGuiderName;


@property ( copy, nonatomic, nullable  ) NSString            *userExamAddress;

@property ( strong, nonatomic, nullable) LyLocation         *location;


@property ( assign, nonatomic)          BOOL                isLogined;




+ (instancetype)curUser;

- (nonnull NSString *)userTypeByString;

- (void)logout;

- (void)setLocationWithLatitude:(CLLocationDegrees)lititude andLongitude:(CLLocationDegrees)longitude;

- (void)setLocationWithLocation:(CLLocation *)location;

- (NSString *)userLicenseTypeByString;

- (NSInteger)cartype;

- (NSString *)userIdForTheory;


@end

NS_ASSUME_NONNULL_END
