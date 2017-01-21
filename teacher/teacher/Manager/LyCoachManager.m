//
//  LyCoachManager.m
//  teacher
//
//  Created by Junes on 16/8/26.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyCoachManager.h"
#import "LyUserManager.h"

@implementation LyCoachManager

lySingle_implementation(LyCoachManager)

- (instancetype)init
{
    if (self = [super init])
    {
        container = [NSMutableDictionary dictionary];
    }
    
    return self;
}


- (void)addCoach:(nullable LyCoach *)coach
{
    [[LyUserManager sharedInstance] addUser:coach];
    
    [container setObject:coach forKey:coach.userId];
}


- (void)removeCoach:(nonnull LyCoach *)coach
{
    if (!coach || !coach.userId)
    {
        return;
    }
    
    [container removeObjectForKey:coach.userId];
}

- (void)removeCoachWithCoachId:(nonnull NSString *)coachId
{
    if (!coachId || coachId.length < 1)
    {
        return;
    }
    [container removeObjectForKey:coachId];
}


- (nullable NSArray *)getAllCoach
{
    
    return [container allValues];
}





@end
