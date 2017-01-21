//
//  LyEvaluation.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/7.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM( NSInteger, LyEvaluationLevel)
{
    LyEvaluationLevel_good = 1,
    LyEvaluationLevel_middle,
    LyEvaluationLevel_bad
};



@interface LyEvaluation : NSObject

@property ( strong, nonatomic)                  NSString                            *oId;
@property ( strong, nonatomic)                  NSString                            *content;
@property ( strong, nonatomic)                  NSString                            *time;
@property ( strong, nonatomic)                  NSString                            *masterId;
@property ( strong, nonatomic)                  NSString                            *objectId;   //评价的人

@property ( strong, nonatomic)                  NSString                            *objectingId;    //评价的事物

@property ( strong, nonatomic)                  NSString                            *evaObjectEvaId;

@property (assign, nonatomic)       NSInteger       replyCount;

@property (assign, nonatomic)       CGFloat     height;


+ (instancetype)evaluationWithId:(NSString *)oId
                        content:(NSString *)content
                           time:(NSString *)time
                       masterId:(NSString *)masterId
                       objectId:(NSString *)objectId;


- (instancetype)initWithId:(NSString *)oId
                   content:(NSString *)content
                      time:(NSString *)time
                  masterId:(NSString *)masterId
                  objectId:(NSString *)objectId;


@end
