//
//  LyExamHistory.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/3.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>



#define scoreCriticality_killer                 0
#define scoreCriticality_newbird                90
#define scoreCriticality_mass                   93
#define scoreCriticality_superior               98



typedef NS_ENUM( NSInteger, LyExamLevel)
{
    LyExamLevel_killer,
    LyExamLevel_newbird,
    LyExamLevel_mass,
    LyExamLevel_superior,
};


@interface LyExamHistory : NSObject

@property ( strong, nonatomic)              NSString                *ehId;

@property ( strong, nonatomic)              NSString                *userId;

@property ( assign, nonatomic)              NSInteger               score;

@property ( strong, nonatomic)              NSString                *time;

@property ( assign, nonatomic)              LyExamLevel             level;

@property ( strong, nonatomic)              NSString                *date;


+ (instancetype)examHistoryWithId:(NSString *)ehId
                           userId:(NSString *)userId
                            score:(NSInteger)score
                             time:(NSString *)time
                             date:(NSString *)date;

- (instancetype)initWithId:(NSString *)ehId
                    userId:(NSString *)userId
                     score:(NSInteger)score
                      time:(NSString *)time
                      date:(NSString *)date;

+ (LyExamLevel)cacluExamLevel:(NSInteger)score;

@end
