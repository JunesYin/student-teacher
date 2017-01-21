//
//  LyPriceDetailManager.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/21.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LySingleInstance.h"
#import "LyPriceDetail.h"
#import "LyUtil.h"


typedef NS_ENUM(NSInteger, LySubjectModeSupportMode) {
    LySubjectModeSupportMode_none = 0,
    LySubjectModeSupportMode_second,
    LySubjectModeSupportMode_third,
    LySubjectModeSupportMode_both
};


@interface LyPriceDetailManager : NSObject

lySingle_interface


- (void)addPriceDetail:(LyPriceDetail *)priceDetail;

- (NSArray *)priceDetailWithUserId:(NSString *)userId;

- (NSArray *)priceDetailWithUserId:(NSString *)userId andDriveLicense:(LySubjectModeprac)license;

- (LySubjectModeSupportMode)getSubjectSupportModeWith:(LyWeekday)weekday andTimeStart:(NSInteger)timeStart userId:(NSString *)userId;

- (float)getPriceWithDate:(NSDate *)date andWeekday:(LyWeekday)weekday andTimeStart:(NSInteger)timeStart andLicense:(LySubjectModeprac)license userId:(NSString *)userId;

@end
