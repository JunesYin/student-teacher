//
//  LyUserManager.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/30.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LyUser.h"
#import "LyCoach.h"
#import "LyDriveSchool.h"
#import "LyGuider.h"
#import "LySingleInstance.h"


/**
 *  所有用户均存于LyUserManager，其他manager只存用户ID
 */


@interface LyUserManager : NSObject


@property ( assign, nonatomic, readonly)        NSInteger           allCount;

@property ( assign, nonatomic, readonly)        NSInteger           countOfCoach;

@property ( assign, nonatomic, readonly)        NSInteger           countOfDriveSchool;

@property ( assign, nonatomic, readonly)        NSInteger           countOfGuider;


lySingle_interface


- (void)addUser:(LyUser *)user;

- (void)addUserWithUserId:(NSString *)userId;

- (void)addUserWithUserId:(NSString *)userId andUserName:(NSString *)userName;

- (void)removeUser:(LyUser *)user;

- (void)removeUserWithUserId:(NSString *)strUserId;

- (NSArray *)getAllUser;

- (LyUser *)getUserWithUserId:(NSString *)userId;

- (NSArray *)getUserWithUserName:(NSString *)userName;

- (LyCoach *)getCoachWithCoachId:(NSString *)coachId;

- (LyDriveSchool *)getDriveSchoolWithDriveSchoolId:(NSString *)driveShcoolId;

- (LyGuider *)getGuiderWithGuiderId:(NSString *)guiderId;

- (NSArray *)getAllCoach;

- (NSArray *)getAllDriveSchool;

- (NSArray *)getAllGuider;

- (NSArray *)getCoachWithDriveSchoolId:(NSString *)driveSchoolId;

- (NSString *)getUserNameWithId:(NSString *)userId;


@end
