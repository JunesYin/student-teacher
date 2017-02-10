//
//  LyUserManager.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/30.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyUserManager.h"
#import "LyCurrentUser.h"

@interface LyUserManager ()
{
    NSMutableDictionary                         *containerUser;
}

@end


@implementation LyUserManager


lySingle_implementation(LyUserManager)


- (instancetype)init {
    if ( self = [super init]) {
        containerUser = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    return self;
}




- (void)addUser:(LyUser *)user {
    
    if (!user || !user.userId) {// || ![LyUtil validateUserId:user.userId]) {
        return;
    }
    
    if ( !containerUser) {
        containerUser = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    _allCount++;
    
    switch ( [user userType]) {
        case LyUserType_normal: {
            [containerUser setObject:user forKey:[user userId]];
            break;
        }
        case LyUserType_coach: {
            LyCoach *coach = (LyCoach *)user;
            [containerUser setObject:coach forKey:[coach userId]];
            _countOfCoach++;
            break;
        }
        case LyUserType_school: {
            LyDriveSchool *driveSchool = (LyDriveSchool *)user;
            [containerUser setObject:driveSchool forKey:[driveSchool userId]];
            _countOfDriveSchool++;
            break;
        }
        case LyUserType_guider: {
            LyGuider *guider = (LyGuider *)user;
            [containerUser setObject:guider forKey:[guider userId]];
            _countOfGuider++;
            break;
        }
            
        default: {
            [containerUser setObject:user forKey:[user userId]];
            break;
        }
    }
    
}


- (void)addUserWithUserId:(NSString *)userId {
    if (![containerUser objectForKey:userId]) {
        dispatch_queue_t globalQueue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async( globalQueue, ^{
            NSString *strUserName = [LyUtil getUserNameWithUserId:userId];
            
            LyUser *user = [LyUser userWithId:userId
                                     userName:strUserName];
            [self addUser:user];
        });
    }
}


- (void)addUserWithUserId:(NSString *)userId andUserName:(NSString *)userName {

    LyUser *user = [LyUser userWithId:userId
                             userName:userName];
    
    [self addUser:user];
}


- (void)removeUser:(LyUser *)user {
    if (!user || !user.userId) {
        return;
    }
    
    [containerUser removeObjectForKey:user.userId];
}

- (void)removeUserWithUserId:(NSString *)strUserId {
    if (![LyUtil validateString:strUserId]) {
        return;
    }
    
    [containerUser removeObjectForKey:strUserId];
}




- (NSArray *)getAllUser {
    if (!containerUser || containerUser.count < 1) {
        return nil;
    }
    
    return [containerUser allValues];
}



- (LyUser *)getUserWithUserId:(NSString *)userId {
    return [containerUser objectForKey:userId];
}



- (NSArray *)getUserWithUserName:(NSString *)userName {
    NSMutableArray *arrResultTmp = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [containerUser keyEnumerator];
    
    NSString *item;
    
    while ( item = [enumerator nextObject]) {
        if ( [userName isEqualToString:[[containerUser objectForKey:item] userName]]) {
            [arrResultTmp addObject:[containerUser objectForKey:item]];
        }
    }
    
    return [arrResultTmp copy];
}



- (LyCoach *)getCoachWithCoachId:(NSString *)coachId {
    if (![LyUtil validateString:coachId]) {
        return nil;
    }
    
    return [containerUser objectForKey:coachId];
}


- (LyDriveSchool *)getDriveSchoolWithDriveSchoolId:(NSString *)driveSchoolId {
    if (![LyUtil validateString:driveSchoolId]) {
        return nil;
    }
    
    return [containerUser objectForKey:driveSchoolId];
}


- (LyGuider *)getGuiderWithGuiderId:(NSString *)guiderId {
    if (![LyUtil validateString:guiderId]) {
        return nil;
    }
    
    return [containerUser objectForKey:guiderId];
}



- (NSArray *)getAllCoach
{
    NSMutableArray *arrResultTmp = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [containerUser keyEnumerator];
    
    NSString *itemKey;
    
    while ( itemKey = [enumerator nextObject]) {
        if ( LyUserType_coach ==  [[containerUser objectForKey:itemKey] userType]) {
            [arrResultTmp addObject:[containerUser objectForKey:itemKey]];
        }
    }
    
    [arrResultTmp sortUsingComparator:^NSComparisonResult(LyUser *  _Nonnull obj1, LyUser *  _Nonnull obj2) {
        if (obj1.distance > obj2.distance) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    return [arrResultTmp copy];
}

- (NSArray *)getAllDriveSchool
{
    NSMutableArray *arrResultTmp = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [containerUser keyEnumerator];
    
    NSString *itemKey;
    
    while ( itemKey = [enumerator nextObject]) {
        if ( LyUserType_school ==  [[containerUser objectForKey:itemKey] userType]) {
            [arrResultTmp addObject:[containerUser objectForKey:itemKey]];
        }
    }
    
    [arrResultTmp sortUsingComparator:^NSComparisonResult(LyUser *  _Nonnull obj1, LyUser *  _Nonnull obj2) {
        if (obj1.distance > obj2.distance) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    return [arrResultTmp copy];
}

- (NSArray *)getAllGuider
{
    NSMutableArray *arrResultTmp = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [containerUser keyEnumerator];
    
    NSString *itemKey;
    
    while ( itemKey = [enumerator nextObject]) {
        if ( LyUserType_guider ==  [[containerUser objectForKey:itemKey] userType]) {
            [arrResultTmp addObject:[containerUser objectForKey:itemKey]];
        }
    }
    
    [arrResultTmp sortUsingComparator:^NSComparisonResult(LyUser *  _Nonnull obj1, LyUser *  _Nonnull obj2) {
        if (obj1.distance > obj2.distance) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    return [arrResultTmp copy];
}





- (NSArray *)getCoachWithDriveSchoolId:(NSString *)driveSchoolId
{
    NSMutableArray *arrResultTmp = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [containerUser keyEnumerator];
    
    NSString *itemKey;
    
    while ( itemKey = [enumerator nextObject]) {
        if ( LyUserType_coach ==  [[containerUser objectForKey:itemKey] userType] && [[[containerUser objectForKey:itemKey] coaMasterId] isEqualToString:driveSchoolId]) {
            [arrResultTmp addObject:[containerUser objectForKey:itemKey]];
        }
    }
    
    [arrResultTmp sortUsingComparator:^NSComparisonResult(LyUser *  _Nonnull obj1, LyUser *  _Nonnull obj2) {
        if (obj1.distance > obj2.distance) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    return [arrResultTmp copy];
    
}



- (NSString *)getUserNameWithId:(NSString *)userId
{
    LyUser *user = [containerUser objectForKey:userId];
    
    return [user userName];
}



@end
