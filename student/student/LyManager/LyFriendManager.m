//
//  LyFriendManager.m
//  teacher
//
//  Created by Junes on 17/10/2016.
//  Copyright © 2016 517xueche. All rights reserved.
//

#import "LyFriendManager.h"
#import "LyUserManager.h"

@implementation LyFriendManager

lySingle_implementation(LyFriendManager)

- (instancetype)init {
    if (self = [super init]) {
        container = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    return self;
}

- (void)addFriend:(LyUser *)user {
    if (!container) {
        container = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    if (!user) {
        return;
    }
    
    [container setObject:user forKey:user.userId];
}

- (void)addFriendWithUserId:(NSString *)userId {
    if (!container) {
        container = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:userId];
    
    [self addFriend:user];
}

- (NSArray *)getAllFriends {
    return [container allKeys];
}

- (void)removeFriend:(LyUser *)user {
    if (!user) {
        return;
    }
    
    [self removeFriendWithUserId:user.userId];
}

- (void)removeFriendWithUserId:(NSString *)userId {
    if (!userId) {
        return;
    }
    
    [container removeObjectForKey:userId];
}

- (void)removeAllFriends {
    [container removeAllObjects];
}



@end
