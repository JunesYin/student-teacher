//
//  LyEvaluationForTeacher.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/7.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyEvaluationForTeacher.h"

#import "LyReply.h"

#import "LyUtil.h"


@implementation LyEvaluationForTeacher

@synthesize oId = _oId;
@synthesize content = _content;
@synthesize time = _time;
@synthesize masterId = _masterId;
@synthesize objectId = _objectId;
@synthesize objectingId = _objectingId;


+ (instancetype)evaluationForTeacherWithId:(NSString *)oId
                                   content:(NSString *)content
                                      time:(NSString *)time
                                  masterId:(NSString *)masterId
                                  objectId:(NSString *)objectId
                                     score:(float)score
                                     level:(LyEvaluationLevel)level
{
    LyEvaluationForTeacher *eva = [[LyEvaluationForTeacher alloc] initWithId:oId
                                                                     content:content
                                                                        time:time
                                                                    masterId:masterId
                                                                    objectId:objectId
                                                                       score:score
                                                                       level:level];
    
    return eva;
}
    
- (instancetype)initWithId:(NSString *)oId
                   content:(NSString *)content
                      time:(NSString *)time
                  masterId:(NSString *)masterId
                  objectId:(NSString *)objectId
                     score:(float)score
                     level:(LyEvaluationLevel)level
{
    if (self = [super initWithId:oId
                         content:content
                            time:time
                        masterId:masterId
                        objectId:objectId])
    {
        _oId = oId;
        _content = content;
        _time = time;
        _masterId = masterId;
        _objectId = objectId;
        _score = score;
        _level = level;
    }
    
    return self;
}


- (void)addReply:(LyReply *)reply {
    if (!_arrReply) {
        _arrReply = [[NSMutableArray alloc] initWithCapacity:1];
    }
    
    [_arrReply addObject:reply];
    
    if ([reply.masterId isEqualToString:_masterId] && [LyUtil compareDateByString:reply.time with:_time]) {
        _time = reply.time;
    }
}


- (void)uniquifyAndSortReply {
    if (!_arrReply || _arrReply.count < 1) {
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    for (LyReply *reply in _arrReply) {
        [dic setObject:reply forKey:reply.oId];
    }
    
    _arrReply = [[NSMutableArray alloc] initWithArray:[dic allValues]];
    
    _arrReply = [LyUtil sortArrByDate:_arrReply andKey:@"time" asc:NO];
}


@end
