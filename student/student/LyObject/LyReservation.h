//
//  LyReservation.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/30.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LyOrder.h"


//typedef NS_ENUM( NSInteger, LyReservationState)
//{
//    reservationState_disable,
//    reservationState_waitCon
//    reservationState_completed
//};



@interface LyReservation : NSObject

@property ( strong, nonatomic)              NSString                *resId;
@property ( strong, nonatomic)              NSString                *resMasterId;
@property ( strong, nonatomic)              NSString                *resObjectId;
@property ( strong, nonatomic)              NSString                *resDuration;


@property ( strong, nonatomic)              NSString                *resOrderId;


+ (instancetype)reservationWithResId:(NSString *)resId
                         resMasterId:(NSString *)resMasterId
                         resObjectId:(NSString *)resObjectId
                         resDuration:(NSString *)resDuration
                          resOrderId:(NSString *)resOrderId;

- (instancetype)initWithResId:(NSString *)resId
                  resMasterId:(NSString *)resMasterId
                  resObjectId:(NSString *)resObjectId
                  resDuration:(NSString *)resDuration
                   resOrderId:(NSString *)resOrderId;



@end
