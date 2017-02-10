//
//  LyUser.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/19.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LyUtil.h"
#import "LyLocation.h"
#import "LyLandMark.h"



typedef NS_ENUM(NSInteger, LyTeacherVerifyState)
{
    LyTeacherVerifyState_null = 0,
    LyTeacherVerifyState_rejected,
    LyTeacherVerifyState_verifying,
    LyTeacherVerifyState_access
};



@interface LyUser : NSObject


@property ( strong, nonatomic, nonnull) NSString      *userId;
@property ( strong, nonatomic, nonnull) NSString      *userName;
@property ( strong, nonatomic, nullable) NSString      *userBirthday;
@property ( strong, nonatomic, nullable) NSString      *userPhoneNum;
@property ( strong, nonatomic, nullable) UIImage       *userAvatar;
//@property ( strong, nonatomic, nullable) NSString      *userAvatarName;
@property ( strong, nonatomic, nullable) NSString      *userAddress;
@property ( strong, nonatomic, nullable) NSString      *userSignature;
@property ( assign, nonatomic          ) LySex         userSex;
@property ( assign, nonatomic, readonly) int           userAge;
@property ( assign, nonatomic          ) float         userBalance;
@property ( assign, nonatomic          ) LyUserLevel   userLevel;
@property ( assign, nonatomic          ) LyLicenseType userLicenseType;


@property ( assign, nonatomic, readonly) LyUserType    userType;


@property ( strong, nonatomic, readonly)            NSMutableArray            *arrLandMark;

@property (assign, nonatomic, getter=isSearching)   BOOL  searching;

@property ( assign, nonatomic)           double         distance;
@property (assign, nonatomic)   int     precedence;

@property ( assign, nonatomic)           double          deposit;



@property (assign, nonatomic)       float   price;
@property (assign, nonatomic)       float   score;
@property (assign, nonatomic)       int     stuAllCount;




//+ (LyUserType)getUserType;
//
//- (LyUserType)getUserType;


+ (nullable instancetype)userWithId:(nullable NSString *)userId
                           userName:(nullable NSString *)userName;

- (nullable instancetype)initWithId:(nullable NSString *)userId
                           userName:(nullable NSString *)userName;



+ (nullable instancetype)userWithId:(nullable NSString *)userId
                  userName:(nullable NSString *)userName
              userBirthday:(nullable NSString *)birthday
              userPhoneNum:(nullable NSString *)phoneNum
                useravatar:(nullable NSString *)avatar
               userAddress:(nullable NSString *)address
             userSignature:(nullable NSString *)signature
                   userSex:(LySex)sex
               userBalance:(float)balance
                 userLevel:(LyUserLevel)userLevel;




- (nullable instancetype)initWithId:(nullable NSString *)userId
                  userName:(nullable NSString *)userName
              userBirthday:(nullable NSString *)birthday
              userPhoneNum:(nullable NSString *)phoneNum
                useravatar:(nullable NSString *)avatar
               userAddress:(nullable NSString *)address
             userSignature:(nullable NSString *)signature
                   userSex:(LySex)sex
               userBalance:(float)balance
                 userLevel:(LyUserLevel)userLevel;


- (NSString *)userTypeByString;

- (NSString *)userLicenseTypeByString;


- (void)addLandMark:(LyLandMark *)landMark;
//- (void)setLocationWithLatitude:(CLLocationDegrees)lititude andLongitude:(CLLocationDegrees)longitude;
//
//- (void)setLocationWithLocation:(CLLocation *)location;


@end
