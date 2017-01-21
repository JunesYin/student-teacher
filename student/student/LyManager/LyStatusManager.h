//
//  LyStatusManager.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/30.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LyStatus.h"
#import "LySingleInstance.h"



@interface LyStatusManager : NSObject

lySingle_interface


- (void)addStatus:(LyStatus *)status;

- (void)removeStatus:(LyStatus *)status;

- (void)removeStatusWithStatusId:(NSString *)statusId;

- (NSInteger)getStatusCount;

- (NSArray *)getAllStatus;

- (LyStatus *)getStatusWithStatusId:(NSString *)statusId;

- (NSArray *)getStatusWithUserId:(NSString *)userId;

@end
