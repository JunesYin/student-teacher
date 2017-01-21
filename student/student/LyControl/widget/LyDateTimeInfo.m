//
//  LyDateTimeInfo.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/20.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyDateTimeInfo.h"

@implementation LyDateTimeInfo


+ (instancetype)dateTimeInfoWithMode:(NSInteger)mode
                                date:(NSDate *)date
                               state:(LyDateTimeInfoState)state
                            objectId:(NSString *)objectId
                            masterId:(NSString *)masterId
                          masterName:(NSString *)masterName
{
    LyDateTimeInfo *dateTimeInfo = [[LyDateTimeInfo alloc] initWithMode:mode
                                                                   date:date
                                                                  state:state
                                                               objectId:objectId
                                                               masterId:masterId
                                                             masterName:masterName];
    
    return dateTimeInfo;
}

- (instancetype)initWithMode:(NSInteger)mode
                        date:(NSDate *)date
                       state:(LyDateTimeInfoState)state
                    objectId:(NSString *)objectId
                    masterId:(NSString *)masterId
                  masterName:(NSString *)masterName
{
    if ( self = [super init])
    {
        _mode = mode;
        _date = date;
        _state = state;
        _objectId = objectId;
        _masterId = masterId;
        _masterName = masterName;
    }
    
    return self;
}


- (NSString *)description
{
    return [[NSString alloc] initWithFormat:@"%d", (int)_state];
}



@end
