//
//  LyFriendManager.h
//  teacher
//
//  Created by Junes on 17/10/2016.
//  Copyright © 2016 517xueche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LySingleInstance.h"


@class LyUser;

@interface LyFriendManager : NSObject
{
    NSMutableDictionary         *container;
}

lySingle_interface

- (void)addFriend:(LyUser *)user;

- (void)addFriendWithUserId:(NSString *)userId;

- (NSArray *)getAllFriends;

- (void)removeFriend:(LyUser *)user;

- (void)removeFriendWithUserId:(NSString *)userId;

- (void)removeAllFriends;

@end
