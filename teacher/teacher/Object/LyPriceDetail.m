//
//  LyPriceDetail.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyPriceDetail.h"
#import "LyUtil.h"


@implementation LyPriceDetail


+ (instancetype)priceDetailWithPdId:(NSString *)pdId
                      pdLicenseType:(LyLicenseType)pdLicenseType
                       pdSubjectMode:(LySubjectModeprac)pdSubjectMode
                         pdMasterId:(NSString *)pdMasterId
                          pdWeekday:(NSString *)pdWeekday
                             pdTime:(NSString *)pdTime
                            pdPrice:(float)pdPrice
{
    LyPriceDetail *priceDetail = [[LyPriceDetail alloc] initWithPdId:pdId
                                                       pdLicenseType:pdLicenseType
                                                        pdSubjectMode:pdSubjectMode
                                                          pdMasterId:pdMasterId
                                                           pdWeekday:pdWeekday
                                                              pdTime:pdTime
                                                             pdPrice:pdPrice];
    
    return priceDetail;
}

- (instancetype)initWithPdId:(NSString *)pdId
               pdLicenseType:(LyLicenseType)pdLicenseType
                pdSubjectMode:(LySubjectModeprac)pdSubjectMode
                  pdMasterId:(NSString *)pdMasterId
                   pdWeekday:(NSString *)pdWeekday
                      pdTime:(NSString *)pdTime
                     pdPrice:(float)pdPrice
{
    if ( self = [super init])
    {
        _pdId = pdId;
        _pdLicenseType = pdLicenseType;
        _pdSubjectMode = pdSubjectMode;
        _pdMasterId = pdMasterId;
        _pdWeekday = pdWeekday;
        _pdTime = pdTime;
        _pdPrice = pdPrice;
        
        _pdWeekdaySpan = [LyUtil weekdaySpanFromString:_pdWeekday];
        _pdTimeBucket = [LyUtil timeBucketFromString:_pdTime];
        
    }
    
    return self;
}


+ (instancetype)priceDetailWithPdId:(NSString *)pdId
                      pdLicenseType:(LyLicenseType)pdLicenseType
                       pdSubjectMode:(LySubjectModeprac)pdSubjectMode
                         pdMasterId:(NSString *)pdMasterId
                      pdWeekdaySpan:(LyWeekdaySpan)pdWeekdaySpan
                       pdTimeBucket:(LyTimeBucket)pdTimeBucket
                            pdPrice:(float)pdPrice
{
    LyPriceDetail *priceDetail = [[LyPriceDetail alloc] initWithPdId:pdId
                                                       pdLicenseType:pdLicenseType
                                                        pdSubjectMode:pdSubjectMode
                                                          pdMasterId:pdMasterId
                                                       pdWeekdaySpan:pdWeekdaySpan
                                                        pdTimeBucket:pdTimeBucket
                                                             pdPrice:pdPrice];
    
    return priceDetail;
}

- (instancetype)initWithPdId:(NSString *)pdId
               pdLicenseType:(LyLicenseType)pdLicenseType
               pdSubjectMode:(LySubjectModeprac)pdSubjectMode
                  pdMasterId:(NSString *)pdMasterId
               pdWeekdaySpan:(LyWeekdaySpan)pdWeekdaySpan
                pdTimeBucket:(LyTimeBucket)pdTimeBucket
                     pdPrice:(float)pdPrice
{
    if ( self = [super init])
    {
        _pdId = pdId;
        _pdLicenseType = pdLicenseType;
        _pdSubjectMode = pdSubjectMode;
        _pdMasterId = pdMasterId;
        _pdWeekdaySpan = pdWeekdaySpan;
        _pdTimeBucket = pdTimeBucket;
        _pdPrice = pdPrice;
        
        _pdWeekday = [LyUtil weekdaySpanStringFrom:_pdWeekdaySpan];
        _pdTime = [LyUtil timeBucketStringFrom:_pdTimeBucket];
    }
    
    return self;
}



- (NSString *)description {
    return [[NSString alloc] initWithFormat:@"%@/%@/%@/%@",
            [LyUtil driveLicenseStringFrom:_pdLicenseType],
            [LyUtil subjectModePracStringForm:_pdSubjectMode],
            [LyUtil weekdaySpanChineseStringFrom:_pdWeekdaySpan],
            [LyUtil timeBucketChineseStringFrom:_pdTimeBucket] ];
}




@end
