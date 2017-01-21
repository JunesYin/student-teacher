//
//  LyTrainClass.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/13.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LyUtil.h"






@interface LyTrainClass : NSObject


@property ( strong, nonatomic)                  NSString                *tcId;
@property ( strong, nonatomic)                  NSString                *tcName;
@property ( strong, nonatomic)                  NSString                *tcMasterId;
@property ( strong, nonatomic)                  NSString                *tcTrainTime;
@property ( strong, nonatomic)                  NSString                *tcCarName;
@property ( strong, nonatomic)                  NSString                *tcInclude;
@property ( assign, nonatomic)                  LyTrainClassMode        tcMode;
@property ( assign, nonatomic)                  LyLicenseType           tcLicenseType;
@property ( assign, nonatomic)                  LyTrainClassPickType    tcPickType;
@property ( assign, nonatomic)                  LyTrainClassTrainMode   tcTrainMode;
@property ( assign, nonatomic)                  float                   tcOfficialPrice;
@property ( assign, nonatomic)                  float                   tc517WholePrice;
@property ( assign, nonatomic)                  float                   tc517PrePayPrice;
@property ( assign, nonatomic)                  float                   tc517PrePayDeposit;
@property ( assign, nonatomic)                  int                     tcWaitDays;
@property ( assign, nonatomic)                  int                     tcFinishDays;

@property ( assign, nonatomic)                  LyTrainClassObjectPeriod    tcObjectPeriod;
@property ( assign, nonatomic)                  LyTimeBucket tcTrainTimeBucket;



+ (instancetype)trainClassWithTrainClassId:(NSString *)tcId
                                    tcName:(NSString *)tcName;


- (instancetype)initWithTrainClassId:(NSString *)tcId
                              tcName:(NSString *)tcName;


+ (instancetype)trainClassWithTrainClassId:(NSString *)tcId
                                    tcName:(NSString *)tcName
                                tcMasterId:(NSString *)tcMasterId
                                tcTrainTime:(NSString *)tcTrainTime
                                  tcCarName:(NSString *)tcCarName
                                 tcInclude:(NSString *)tcInclude
                                     tcMode:(LyTrainClassMode)tcMode
                              tcLicenseType:(LyLicenseType)tcLicenseType
                            tcOfficialPrice:(float)tcOfficialPrice
                            tc517WholePrice:(float)tc517WholePrice
                           tc517PrepayPrice:(float)tc517PrepayPrice
                        tc517PrePayDeposit:(float)tc517PrePayDeposit;


- (instancetype)initWithTrainClassId:(NSString *)tcId
                               tcName:(NSString *)tcName
                           tcMasterId:(NSString *)tcMasterId
                          tcTrainTime:(NSString *)tcTrainTime
                            tcCarName:(NSString *)tcCarName
                           tcInclude:(NSString *)tcInclude
                               tcMode:(LyTrainClassMode)tcMode
                        tcLicenseType:(LyLicenseType)tcLicenseType
                      tcOfficialPrice:(float)tcOfficialPrice
                      tc517WholePrice:(float)tc517WholePrice
                     tc517PrepayPrice:(float)tc517PrepayPrice
                  tc517PrePayDeposit:(float)tc517PrePayDeposit;



- (NSString *)getPickType;

- (NSString *)getTrainType;


@end
