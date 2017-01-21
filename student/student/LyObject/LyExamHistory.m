//
//  LyExamHistory.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/3.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyExamHistory.h"

@implementation LyExamHistory


+ (instancetype)examHistoryWithId:(NSString *)ehId
                           userId:(NSString *)userId
                            score:(NSInteger)score
                             time:(NSString *)time
                             date:(NSString *)date
{
    LyExamHistory *examHistory = [[LyExamHistory alloc] initWithId:ehId
                                                            userId:userId
                                                             score:score
                                                              time:time
                                                              date:date];
    
    return examHistory;
}

- (instancetype)initWithId:(NSString *)ehId
                    userId:(NSString *)userId
                     score:(NSInteger)score
                      time:(NSString *)time
                      date:(NSString *)date
{
    if ( self = [super init])
    {
        _ehId = ehId;
        _userId = userId;
        _score = ( labs(score) > 100) ? 100 : labs(score);
        _time = time;
        _date = date;
        
        _level = [LyExamHistory cacluExamLevel:_score];
    }
    
    return self;
}



+ (LyExamLevel)cacluExamLevel:(NSInteger)score
{
    LyExamLevel level;
    
    if ( score >= scoreCriticality_superior)
    {
        level = LyExamLevel_superior;
    }
    else if ( score >= scoreCriticality_mass)
    {
        level = LyExamLevel_mass;
    }
    else if ( score >= scoreCriticality_newbird)
    {
        level = LyExamLevel_newbird;
    }
    else
    {
        level = LyExamLevel_killer;
    }
    
    return level;
}


@end
