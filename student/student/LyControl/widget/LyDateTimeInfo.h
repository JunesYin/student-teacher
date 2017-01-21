//
//  LyDateTimeInfo.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/20.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM( NSInteger, LyDateTimeInfoState)
{
    LyDateTimeInfoState_useable,
    LyDateTimeInfoState_used,
    LyDateTimeInfoState_disable,
};


@interface LyDateTimeInfo : NSObject

@property ( assign, nonatomic)      NSInteger                   mode;
@property ( strong, nonatomic)      NSDate                      *date;
@property ( assign, nonatomic)      LyDateTimeInfoState         state;

@property ( strong, nonatomic)      NSString                    *objectId;
@property ( strong, nonatomic)      NSString                    *masterId;
@property ( strong, nonatomic)      NSString                    *masterName;

+ (instancetype)dateTimeInfoWithMode:(NSInteger)mode
                                date:(NSDate *)date
                               state:(LyDateTimeInfoState)state
                            objectId:(NSString *)objectId
                            masterId:(NSString *)masterId
                          masterName:(NSString *)masterName;


- (instancetype)initWithMode:(NSInteger)mode
                        date:(NSDate *)date
                       state:(LyDateTimeInfoState)state
                    objectId:(NSString *)objectId
                    masterId:(NSString *)masterId
                  masterName:(NSString *)masterName;

@end
