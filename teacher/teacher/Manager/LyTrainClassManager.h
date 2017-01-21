//
//  LyTrainClassManager.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/13.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LyTrainClass.h"
#import "LySingleInstance.h"



@interface LyTrainClassManager : NSObject


lySingle_interface

- (void)addTrainClass:(LyTrainClass *)trainClass;

- (NSArray *)getAllTrainClass;

- (void)removeAllTrainClass;

- (void)removeTrainClassWithId:(NSString *)strId;

- (NSArray *)getTrainClassWithTeacherId:(NSString *)teacherId;

- (NSArray *)getTrainClassWithDriveSchoolId:(NSString *)driveSchoolId;

- (NSArray *)getTrainClassWithCoachId:(NSString *)coachId;

- (NSArray *)getTrainClassWithGuiderId:(NSString *)guiderId;

- (LyTrainClass *)getTrainClassWithTrainClassId:(NSString *)trainClassId;

- (LyTrainClass *)getTrainClassWithTrainClassId:(NSString *)trainClassId withDriveSchoolId:(NSString *)driveSchoolId;

- (LyTrainClass *)getTrainClassWithTrainClassId:(NSString *)trainClassId withCoachId:(NSString *)coachId;

- (LyTrainClass *)getTrainClassWithTrainClassId:(NSString *)trainClassId withGuiderId:(NSString *)guiderId;

@end
