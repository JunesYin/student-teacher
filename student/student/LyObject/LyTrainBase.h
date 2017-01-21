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

@property ( assign, nonatomic)          NSInteger               tbCoachCount;
@property ( assign, nonatomic)          NSInteger               tbStudentCount;


+ (instancetype)trainBaseWithTbId:(NSString *)tbId
                           tbName:(NSString *)tbName
                        tbAddress:(NSString *)tbAddress
                     tbCoachCount:(NSInteger)tbCoachCount
                   tbStudentCount:(NSInteger)tbStudentCount;

- (instancetype)initWithTbId:(NSString *)tbId
                      tbName:(NSString *)tbName
                   tbAddress:(NSString *)tbAddress
                tbCoachCount:(NSInteger)tbCoachCount
              tbStudentCount:(NSInteger)tbStudentCount;

@end
