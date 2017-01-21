//
//  LyTrainClass.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/13.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyTrainClass.h"

@implementation LyTrainClass



+ (instancetype)trainClassWithTrainClassId:(NSString *)tcId
                                    tcName:(NSString *)tcName
{
    LyTrainClass *tc = [[LyTrainClass alloc] initWithTrainClassId:tcId
                                                           tcName:tcName];
    
    return tc;
}


- (instancetype)initWithTrainClassId:(NSString *)tcId
                              tcName:(NSString *)tcName
{
    if ( self = [super init])
    {
        _tcId = tcId;
        _tcName = tcName;
    }
    
    return self;
}


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
                        tc517PrePayDeposit:(float)tc517PrePayDeposit
{
    LyTrainClass *tmpTrainClass = [[LyTrainClass alloc] initWithTrainClassId:tcId
                                                                       tcName:tcName
                                                                   tcMasterId:tcMasterId
                                                                  tcTrainTime:tcTrainTime
                                                                    tcCarName:tcCarName
                                                                   tcInclude:tcInclude
                                                                       tcMode:tcMode
                                                                tcLicenseType:tcLicenseType
                                                              tcOfficialPrice:tcOfficialPrice
                                                              tc517WholePrice:tc517WholePrice
                                                             tc517PrepayPrice:tc517PrepayPrice
                                                          tc517PrePayDeposit:tc517PrePayDeposit];
    
    
    return tmpTrainClass;
}


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
                  tc517PrePayDeposit:(float)tc517PrePayDeposit
{
    if ( self = [super init])
    {
        _tcId             = tcId;
        _tcName           = tcName;
        _tcMasterId       = tcMasterId;
        _tcTrainTime      = tcTrainTime;
        _tcCarName        = tcCarName;
        _tcInclude        = tcInclude;
        _tcMode           = tcMode;
        _tcLicenseType    = tcLicenseType;
        _tcOfficialPrice  = tcOfficialPrice;
        _tc517WholePrice  = tc517WholePrice;
        _tc517PrePayDeposit = tc517PrePayDeposit;
        
        [self setTc517PrePayPrice:tc517PrepayPrice];
        
        
//        _tcInclude = @"教材费、办证费、IC卡费、理科术科培训费 \
//        燃油费、车辆及人员使用费、经营管理等费     \
//        用，以及科目一、科目二、科目三考试费、 \
//        一次补考费";
    }
    
    
    
    return self;
}



- (void)setTc517PrePayPrice:(float)tc517PrePayPrice {
    _tc517PrePayPrice = (tc517PrePayPrice < _tc517WholePrice) ? _tc517WholePrice : tc517PrePayPrice;
}



- (NSString *)getPickType
{
    switch ( _tcPickType) {
        case LyTrainClassPickType_none: {
            return @"不接送";
            break;
        }
        case LyTrainClassPickType_bus: {
            return @"班车接送";
            break;
        }
//        case LyTrainClassPickType_car: {
//            return @"专车接送";
//            break;
//        }
    }
}



- (NSString *)getTrainType
{
    switch ( _tcTrainMode) {
        case LyTrainClassTrainMode_one: {
            return @"一人一车";
            break;
        }
//        case LyTrainClassTrainMode_four: {
//            return @"四车多人";
//            break;
//        }
        case LyTrainClassTrainMode_multi: {
            return @"一车多人";
            break;
        }
    }
}



@end
