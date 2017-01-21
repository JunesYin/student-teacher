//
//  LyTrainBase.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyTrainBase.h"

@implementation LyTrainBase


+ (instancetype)trainBaseWithTbId:(NSString *)tbId
                           tbName:(NSString *)tbName
                        tbAddress:(NSString *)tbAddress
                     tbCoachCount:(int)tbCoachCount
                   tbStudentCount:(int)tbStudentCount
{
    LyTrainBase *trainBase = [[LyTrainBase alloc] initWithTbId:tbId
                                                        tbName:tbName
                                                     tbAddress:tbAddress
                                                  tbCoachCount:tbCoachCount
                                                tbStudentCount:tbStudentCount];
    
    return trainBase;
}

- (instancetype)initWithTbId:(NSString *)tbId
                      tbName:(NSString *)tbName
                   tbAddress:(NSString *)tbAddress
                tbCoachCount:(int)tbCoachCount
              tbStudentCount:(int)tbStudentCount
{
    if ( self = [super init])
    {
        _tbId           = tbId;
        _tbName         = tbName;
        _tbAddress      = tbAddress;
        _tbCoachCount   = tbCoachCount;
        _tbStudentCount = tbStudentCount;
    }
    
    
    return self;
}


- (NSString *)tbAddress {
    if (!_tbAddress || [_tbAddress isKindOfClass:[NSNull class]] || ![_tbAddress isKindOfClass:[NSString class]] || _tbAddress.length < 1 || [_tbAddress rangeOfString:@"null"].length > 0) {
        return @"暂无地址";
    }
    
    return _tbAddress;
}


- (NSString *)coachCountByString {
    return  [[NSString alloc] initWithFormat:@"教练人数：%d人", _tbCoachCount];
}

- (NSString *)studentCountByString {
    return [[NSString alloc] initWithFormat:@"学员人数：%d人", _tbCoachCount];
}


@end
