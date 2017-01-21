//
//  LyAttentionManager.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/18.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LySingleInstance.h"
#import "LyUserManager.h"


/**
 *  所有用户均存于LyUserManager，其他manager只存用户ID
 */


@interface LyAttentionManager : NSObject

lySingle_interface



- (void)addAttentionWithUserId:(NSString *)userId;

- (void)addAttentionWithUser:(LyUser *)user;

- (NSArray *)getAllAttention;

- (void)removeAttentionWithUser:(LyUser *)user;

- (void)removeAttentionWithUserId:(NSString *)userId;

- (void)removeAllAttention;
@end
