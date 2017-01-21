//
//  LyReservation.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/30.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyReservation.h"

@implementation LyReservation


+ (instancetype)reservationWithResId:(NSString *)resId
                         resMasterId:(NSString *)resMasterId
                         resObjectId:(NSString *)resObjectId
                         resDuration:(NSString *)resDuration
                          resOrderId:(NSString *)resOrderId
{
    LyReservation *tmpReservation = [[LyReservation alloc] initWithResId:resId
                                                             resMasterId:resMasterId
                                                             resObjectId:resObjectId
                                                             resDuration:resDuration
                                                              resOrderId:resOrderId];
    
    return tmpReservation;
}

- (instancetype)initWithResId:(NSString *)resId
                  resMasterId:(NSString *)resMasterId
                  resObjectId:(NSString *)resObjectId
                  resDuration:(NSString *)resDuration
                   resOrderId:(NSString *)resOrderId
{
    if ( self = [super init])
    {
        _resId = resId;
        _resMasterId = resMasterId;
        _resObjectId = resObjectId;
        _resDuration = resDuration;
        _resOrderId = resOrderId;
    }
    
    
    return self;
}


@end
