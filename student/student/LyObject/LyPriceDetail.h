//
//  LyPriceDetail.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LyUtil.h"



@interface LyPriceDetail : NSObject


@property (strong, nonatomic)       NSString            *pdId;
@property (assign, nonatomic)       LyLicenseType       pdLicenseType;
@property (assign, nonatomic)       LySubjectModeprac       pdSubjectMode;
@property (strong, nonatomic)       NSString            *pdMasterId;

@property (strong, nonatomic)       NSString            *pdWeekday;
@property (assign, nonatomic)       LyWeekdaySpan       pdWeekdaySpan;

@property (strong, nonatomic)       NSString            *pdTime;
@property (assign, nonatomic)       LyTimeBucket        pdTimeBucket;

@property (assign, nonatomic)       float               pdPrice;


+ (instancetype)priceDetailWithPdId:(NSString *)pdId
                      pdLicenseType:(LyLicenseType)pdLicenseType
                      pdSubjectMode:(LySubjectModeprac)pdSubjectMode
                         pdMasterId:(NSString *)pdMasterId
                          pdWeekday:(NSString *)pdWeekday
                             pdTime:(NSString *)pdTime
                            pdPrice:(float)pdPrice;

- (instancetype)initWithPdId:(NSString *)pdId
               pdLicenseType:(LyLicenseType)pdLicenseType
                pdSubjectMode:(LySubjectModeprac)pdSubjectMode
                  pdMasterId:(NSString *)pdMasterId
                   pdWeekday:(NSString *)pdWeekday
                      pdTime:(NSString *)pdTime
                     pdPrice:(float)pdPrice;


+ (instancetype)priceDetailWithPdId:(NSString *)pdId
                      pdLicenseType:(LyLicenseType)pdLicenseType
                       pdSubjectMode:(LySubjectModeprac)pdSubjectMode
                         pdMasterId:(NSString *)pdMasterId
                      pdWeekdaySpan:(LyWeekdaySpan)pdWeekdaySpan
                       pdTimeBucket:(LyTimeBucket)pdTimeBucket
                            pdPrice:(float)pdPrice;

- (instancetype)initWithPdId:(NSString *)pdId
               pdLicenseType:(LyLicenseType)pdLicenseType
                pdSubjectMode:(LySubjectModeprac)pdSubjectMode
                  pdMasterId:(NSString *)pdMasterId
               pdWeekdaySpan:(LyWeekdaySpan)pdWeekdaySpan
                pdTimeBucket:(LyTimeBucket)pdTimeBucket
                     pdPrice:(float)pdPrice;


@end
