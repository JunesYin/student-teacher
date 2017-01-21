//
//  LyTrainBaseManager.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LySingleInstance.h"

#import "LyTrainBase.h"

@interface LyTrainBaseManager : NSObject

lySingle_interface

+ (LyTrainBase *)getTrainBaseWithTbName:(NSString *)tbName withDataSouce:(NSArray *)arrSource;

- (void)addTrainBase:(LyTrainBase *)trainBase;

- (NSArray *)getAllTrainBase;

- (LyTrainBase *)getTrainBaseWithTbId:(NSString *)tbId;


@end
