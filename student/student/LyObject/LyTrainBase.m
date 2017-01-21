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
                     tbCoachCount:(NSInteger)tbCoachCount
                   tbStudentCount:(NSInteger)tbStudentCount
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
                tbCoachCount:(NSInteger)tbCoachCount
              tbStudentCount:(NSInteger)tbStudentCount
{
    if ( self = [super init])
    {
        _tbId = tbId;
        _tbName = tbName;
        _tbAddress = tbAddress;
        _tbCoachCount = tbCoachCount;
        _tbStudentCount = tbStudentCount;
    }
    
    
    return self;
}


@end
