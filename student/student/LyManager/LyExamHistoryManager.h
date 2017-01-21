//
//  LyExamHistoryManager.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/3.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LySingleInstance.h"

#import "LyExamHistory.h"


@interface LyExamHistoryManager : NSObject

lySingle_interface

- (void)addExamHistory:(LyExamHistory *)examHistory;

- (NSArray *)getAllExamHistory;

- (NSArray *)getExamHistoryWithUserId:(NSString *)userId;

- (NSInteger)averageScoreWithUserId:(NSString *)userId;

- (NSInteger)examCountWithUserId:(NSString *)userId;

- (LyExamHistory *)getExamHistoryWithId:(NSString *)ehId;



@end
