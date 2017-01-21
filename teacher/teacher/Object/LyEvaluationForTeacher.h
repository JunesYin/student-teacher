//
//  LyEvaluationForTeacher.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/7.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyEvaluation.h"



@class LyReply;

@interface LyEvaluationForTeacher : LyEvaluation

@property ( strong, nonatomic)      NSString        *oId;
@property ( strong, nonatomic)      NSString        *content;
@property ( strong, nonatomic)      NSString        *time;
@property ( strong, nonatomic)      NSString        *masterId;
@property ( strong, nonatomic)      NSString        *objectId;
@property ( strong, nonatomic)      NSString        *objectingId;

@property ( assign, nonatomic)      float       score;
@property (assign, nonatomic)       LyEvaluationLevel       level;

@property (strong, nonatomic)       NSMutableArray<LyReply *>      *arrReply;



+ (instancetype)evaluationForTeacherWithId:(NSString *)oId
                                   content:(NSString *)content
                                      time:(NSString *)time
                                  masterId:(NSString *)masterId
                                  objectId:(NSString *)objectId
                                     score:(float)score
                                     level:(LyEvaluationLevel)level;

- (instancetype)initWithId:(NSString *)oId
                   content:(NSString *)content
                      time:(NSString *)time
                  masterId:(NSString *)masterId
                  objectId:(NSString *)objectId
                     score:(float)score
                     level:(LyEvaluationLevel)level;
    

- (void)addReply:(LyReply *)reply;

- (void)uniquifyAndSortReply;


@end
