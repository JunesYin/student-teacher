//
//  LyTrainBase.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyTrainBase : NSObject


@property ( strong, nonatomic)          NSString                *tbId;
@property ( strong, nonatomic)          NSString                *tbName;
@property ( strong, nonatomic)          NSString                *tbAddress;

@property ( assign, nonatomic)          int               tbCoachCount;
@property ( assign, nonatomic)          int               tbStudentCount;


+ (instancetype)trainBaseWithTbId:(NSString *)tbId
                           tbName:(NSString *)tbName
                        tbAddress:(NSString *)tbAddress
                     tbCoachCount:(int)tbCoachCount
                   tbStudentCount:(int)tbStudentCount;

- (instancetype)initWithTbId:(NSString *)tbId
                      tbName:(NSString *)tbName
                   tbAddress:(NSString *)tbAddress
                tbCoachCount:(int)tbCoachCount
              tbStudentCount:(int)tbStudentCount;


- (NSString *)coachCountByString;

- (NSString *)studentCountByString;

@end
