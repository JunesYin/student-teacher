//
//  LyDateTimeInfo.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/20.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyDateTimeInfo.h"

@implementation LyDateTimeInfo


+ (NSString *)dateTimeInfoStudyStateStringFrom:(LyDateTimeInfoState)state {
    NSString *str;
    if (LyDateTimeInfoState_finish == state) {
        str = @"已学车";
    } else {
        str = @"未学车";
    }
    
    return str;
}


+ (instancetype)dateTimeInfoWithMode:(NSInteger)mode
                                date:(NSDate *)date
                               state:(LyDateTimeInfoState)state
                             license:(LyLicenseType)license
                             subject:(LySubjectModeprac)subject
                            objectId:(NSString *)objectId
                            masterId:(NSString *)masterId
                          masterName:(NSString *)masterName
                         masterPhone:(NSString *)masterPhone
{
    LyDateTimeInfo *dateTimeInfo = [[LyDateTimeInfo alloc] initWithMode:mode
                                                                   date:date
                                                                  state:state
                                                                license:license
                                                                subject:subject
                                                               objectId:objectId
                                                               masterId:masterId
                                                             masterName:masterName
                                                            masterPhone:masterPhone];
    
    return dateTimeInfo;
}

- (instancetype)initWithMode:(NSInteger)mode
                        date:(NSDate *)date
                       state:(LyDateTimeInfoState)state
                     license:(LyLicenseType)license
                     subject:(LySubjectModeprac)subject
                    objectId:(NSString *)objectId
                    masterId:(NSString *)masterId
                  masterName:(NSString *)masterName
                 masterPhone:(NSString *)masterPhone
{
    if ( self = [super init])
    {
        _mode = mode;
        _date = date;
        _state = state;
        _license = license;
        _subject = subject;
        _objectId = objectId;
        _masterId = masterId;
        _masterName = masterName;
        _masterPhone = masterPhone;
    }
    
    return self;
}


- (NSString *)stateStudy {
    if (LyDateTimeInfoState_finish == _state) {
        return @"已学车";
    } else {
        return @"未学车";
    }
}


- (NSString *)dateTimeInfo {
    return [[NSString alloc] initWithFormat:@"%@/%@/%ld:00-%ld:00",
            [LyUtil stringOnlyDateFromDate:_date],
            [LyUtil weekdayWithDate:_date],
            _mode,
            _mode+1];
}


- (NSString *)description {
    return [[NSString alloc] initWithFormat:@"%@/%@/%ld:00-%ld:00",
            [LyUtil stringOnlyDateFromDate:_date],
            [LyUtil weekdayWithDate:_date],
            _mode,
            _mode+1];
}







@end
