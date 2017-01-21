//
//  LyAttentionManager.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/18.
//  Copyright © 2016年 Junes. All rights reserved.
//


#import "LyAttentionManager.h"
#import "LyUserManager.h"


@interface LyAttentionManager ()
{
    NSMutableDictionary                         *containerForAttention;
}
@end

@implementation LyAttentionManager


- (instancetype)init
{
    if ( self = [super init])
    {
        containerForAttention = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    
    return self;
}

lySingle_implementation(LyAttentionManager)


- (void)addAttentionWithUserId:(NSString *)userId
{
    LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:userId];
    
    
    [self addAttentionWithUser:user];
}

- (void)addAttentionWithUser:(LyUser *)user
{
    if ( !user)
    {
        return;
    }
    
    [[LyUserManager sharedInstance] addUser: user];
    
    if (!containerForAttention)
    {
        containerForAttention = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    [containerForAttention setObject:user forKey:[user userId]];
}

- (NSArray *)getAllAttention
{
    if ( !containerForAttention || ![containerForAttention count])
    {
        return nil;
    }
    
    return [containerForAttention allValues];
}

- (void)removeAttentionWithUser:(LyUser *)user
{
    [containerForAttention removeObjectForKey:[user userId]];
}

- (void)removeAttentionWithUserId:(NSString *)userId
{
    [containerForAttention removeObjectForKey:userId];
}


- (void)removeAllAttention
{
    [containerForAttention removeAllObjects];
}


@end




