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


- (instancetype)init
{
    if ( self = [super init])
    {
        containerUser = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    return self;
}




- (void)addUser:(LyUser *)user
{
    
    if ( !user || ![user userId] || [[user userId] rangeOfString:@"null"].length > 0 || [user userId].length < 36)
    {
        return;
    }
    
    if ( !containerUser)
    {
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
            
        default:
        {
            [containerUser setObject:user forKey:[user userId]];
            break;
        }
    }
    
}


- (void)addUserWithUserId:(NSString *)userId
{
    if (![containerUser objectForKey:userId]) {
        dispatch_queue_t globalQueue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async( globalQueue, ^{
            NSString *strUserName = [LyUtil getUserNameWithUserId:userId];
            
            LyUser *user = [LyUser userWithId:userId
                                     userNmae:strUserName];
            [self addUser:user];
        });
    }
}


- (void)addUserWithUserId:(NSString *)userId andUserName:(NSString *)userName
{
    LyUser *user = [LyUser userWithId:userId
                             userNmae:userName];
    
    [self addUser:user];
}


- (NSArray *)getAllUser
{
    NSMutableArray *arrResultTmp = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [containerUser keyEnumerator];
    
    NSString *item;
    
    while ( item = [enumerator nextObject])
    {
        [arrResultTmp addObject:[containerUser objectForKey:item]];
    }
    
    return [arrResultTmp copy];
}



- (LyUser *)getUserWithUserId:(NSString *)userId
{
    return [containerUser objectForKey:userId];
}



- (NSArray *)getUserWithUserName:(NSString *)userName
{
    NSMutableArray *arrResultTmp = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [containerUser keyEnumerator];
    
    NSString *item;
    
    while ( item = [enumerator nextObject])
    {
        if ( [userName isEqualToString:[[containerUser objectForKey:item] userName]])
        {
            [arrResultTmp addObject:[containerUser objectForKey:item]];
        }
    }
    
    return [arrResultTmp copy];
}



- (LyCoach *)getCoachWithCoachId:(NSString *)coachId
{
    LyCoach *coach = [containerUser objectForKey:coachId];
    
    return coach;
}


- (LyDriveSchool *)getDriveSchoolWithDriveSchoolId:(NSString *)driveSchoolId
{
    LyDriveSchool *driveSchool = [containerUser objectForKey:driveSchoolId];
    
    return driveSchool;
}


- (LyGuider *)getGuiderWithGuiderId:(NSString *)guiderId
{
    LyGuider *guider = [containerUser objectForKey:guiderId];
    
    return guider;
}



- (NSArray *)getAllCoach
{
    NSMutableArray *arrResultTmp = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [containerUser keyEnumerator];
    
    NSString *itemKey;
    
    while ( itemKey = [enumerator nextObject])
    {
        if ( LyUserType_coach ==  [[containerUser objectForKey:itemKey] userType])
        {
            [arrResultTmp addObject:[containerUser objectForKey:itemKey]];
        }
    }
    
//    [arrResultTmp sortUsingComparator:^NSComparisonResult(LyUser *  _Nonnull obj1, LyUser *  _Nonnull obj2) {
//        if ( [[obj1 location] isValid])
//        {
//            if ( [[obj2 location] isValid])
//            {
//                if ( [obj1 distance] > [obj2 distance ])
//                {
//                    return NSOrderedDescending;
//                }
//                else
//                {
//                    return NSOrderedAscending;
//                }
//            }
//            else
//            {
//                return NSOrderedAscending;
//            }
//        }
//        else
//        {
//            return NSOrderedDescending;
//        }
//    }];
    
    return [arrResultTmp copy];
}

- (NSArray *)getAllDriveSchool
{
    NSMutableArray *arrResultTmp = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [containerUser keyEnumerator];
    
    NSString *itemKey;
    
    while ( itemKey = [enumerator nextObject])
    {
        if ( LyUserType_school ==  [[containerUser objectForKey:itemKey] userType])
        {
            [arrResultTmp addObject:[containerUser objectForKey:itemKey]];
        }
    }
    
    [arrResultTmp sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ( [obj1 stuAllCount] > [obj2 stuAllCount])
        {
            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedDescending;
        }
    }];
    
//    [arrResultTmp sortUsingComparator:^NSComparisonResult(LyUser *  _Nonnull obj1, LyUser *  _Nonnull obj2) {
//        if ( [[obj1 location] isValid])
//        {
//            if ( [[obj2 location] isValid])
//            {
//                if ( [obj1 distance] > [obj2 distance ])
//                {
//                    return NSOrderedDescending;
//                }
//                else
//                {
//                    return NSOrderedAscending;
//                }
//            }
//            else
//            {
//                return NSOrderedAscending;
//            }
//        }
//        else
//        {
//            return NSOrderedDescending;
//        }
//    }];
    
    return [arrResultTmp copy];
}

- (NSArray *)getAllGuider
{
    NSMutableArray *arrResultTmp = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [containerUser keyEnumerator];
    
    NSString *itemKey;
    
    while ( itemKey = [enumerator nextObject])
    {
        if ( LyUserType_guider ==  [[containerUser objectForKey:itemKey] userType])
        {
            [arrResultTmp addObject:[containerUser objectForKey:itemKey]];
        }
    }
    
//    [arrResultTmp sortUsingComparator:^NSComparisonResult(LyUser *  _Nonnull obj1, LyUser *  _Nonnull obj2) {
//        if ( [[obj1 location] isValid])
//        {
//            if ( [[obj2 location] isValid])
//            {
//                if ( [obj1 distance] > [obj2 distance ])
//                {
//                    return NSOrderedDescending;
//                }
//                else
//                {
//                    return NSOrderedAscending;
//                }
//            }
//            else
//            {
//                return NSOrderedAscending;
//            }
//        }
//        else
//        {
//            return NSOrderedDescending;
//        }
//    }];
    
    return [arrResultTmp copy];
}



//
//- (NSInteger)getCountOfCoach
//{
//    
//}
//
//- (NSInteger)getCountOfDriveSchool
//{
//    
//}
//
//- (NSInteger)getCountOfGuider
//{
//    
//}


- (NSArray *)getCoachWithSuperiorId:(NSString *)superiorId
{
    NSMutableArray *arrResultTmp = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [containerUser keyEnumerator];
    
    NSString *itemKey;
    
    while ( itemKey = [enumerator nextObject])
    {
        if ( LyUserType_coach ==  [[containerUser objectForKey:itemKey] userType])
        {
            LyCoach *coach = [containerUser objectForKey:itemKey];
            if ([coach.masterId isEqualToString:superiorId] || [coach.bossId isEqualToString:superiorId])
            {
                [arrResultTmp addObject:coach];
            }
        }
    }
    
    
    return [arrResultTmp copy];
}



- (NSArray *)getCoachWithDriveSchoolId:(NSString *)driveSchoolId
{
    NSMutableArray *arrResultTmp = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [containerUser keyEnumerator];
    
    NSString *itemKey;
    
    while ( itemKey = [enumerator nextObject])
    {
        if ( LyUserType_coach ==  [[containerUser objectForKey:itemKey] userType] && [[[containerUser objectForKey:itemKey] masterId] isEqualToString:driveSchoolId])
        {
            [arrResultTmp addObject:[containerUser objectForKey:itemKey]];
        }
    }
    
    
    return [arrResultTmp copy];
    
}


- (NSArray *)getCoachWithBossId:(NSString *)bossId
{
    NSMutableArray *arrResultTmp = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [containerUser keyEnumerator];
    NSString *itemKey;
    while (itemKey = [enumerator nextObject]) {
        if (LyUserType_coach == [[containerUser objectForKey:itemKey] userType])
        {
            LyCoach *coach = [containerUser objectForKey:itemKey];
            if ([coach.bossId isEqualToString:bossId])
            {
                [arrResultTmp addObject:coach];
            }
        }
    }
    
    return [arrResultTmp copy];
}


- (NSString *)getUserNameWithId:(NSString *)userId
{
    LyUser *user = [containerUser objectForKey:userId];
    
    return [user userName];
}


- (void)removeUser:(LyUser *)user {
    if (!user || !user.userId) {
        return;
    }
    [containerUser removeObjectForKey:user.userId];
}

- (void)removeUserByUserId:(NSString *)userId {
    if (!userId) {
        return;
    }
    
    [containerUser removeObjectForKey:userId];
}



@end
