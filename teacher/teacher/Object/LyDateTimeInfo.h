//
//  LyDateTimeInfo.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/20.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LyUtil.h"

typedef NS_ENUM( NSInteger, LyDateTimeInfoState)
{
    LyDateTimeInfoState_useable,
    LyDateTimeInfoState_used,
    LyDateTimeInfoState_disable,
    LyDateTimeInfoState_finish,
};


@interface LyDateTimeInfo : NSObject

@property (assign, nonatomic)       NSInteger                   mode;
@property (strong, nonatomic)       NSDate                      *date;
@property (assign, nonatomic)       LyDateTimeInfoState         state;

@property (assign, nonatomic)       LyLicenseType               license;
@property (assign, nonatomic)       LySubjectModeprac           subject;
@property (strong, nonatomic)       NSString                    *objectId;
@property (strong, nonatomic)       NSString                    *masterId;
@property (strong, nonatomic)       NSString                    *masterPhone;
@property (strong, nonatomic)       NSString                    *masterName;


+ (NSString *)dateTimeInfoStudyStateStringFrom:(LyDateTimeInfoState)state;


+ (instancetype)dateTimeInfoWithMode:(NSInteger)mode
                                date:(NSDate *)date
                               state:(LyDateTimeInfoState)state
                             license:(LyLicenseType)license
                             subject:(LySubjectModeprac)subject
                            objectId:(NSString *)objectId
                            masterId:(NSString *)masterId
                          masterName:(NSString *)masterName
                         masterPhone:(NSString *)masterPhone;


- (instancetype)initWithMode:(NSInteger)mode
                        date:(NSDate *)date
                       state:(LyDateTimeInfoState)state
                     license:(LyLicenseType)license
                     subject:(LySubjectModeprac)subject
                    objectId:(NSString *)objectId
                    masterId:(NSString *)masterId
                  masterName:(NSString *)masterName
                 masterPhone:(NSString *)masterPhone;

- (NSString *)stateStudy;

- (NSString *)dateTimeInfo;


@end
