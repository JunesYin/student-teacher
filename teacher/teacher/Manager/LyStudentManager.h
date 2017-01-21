//
//  LyStudentManager.h
//  teacher
//
//  Created by Junes on 16/8/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LySingleInstance.h"
#import "LyStudent.h"
#import "LyUtil.h"

@interface LyStudentManager : NSObject
{
    NSMutableDictionary         *container;
}


lySingle_interface


- (void)addStudent:(LyStudent *)student;

- (void)removeStudent:(LyStudent *)student;

- (void)removeStudentByStuId:(NSString *)stuId;

- (void)removeAllSutdent;

- (NSArray *)getAllStudent;

- (NSArray *)getStudentWithStudyProgress:(LySubjectMode)studyProgress teacherId:(NSString *)teacherId;

- (nullable NSArray *)getStudentWithStudyProgress:(LySubjectMode)studyProgress;

- (LyStudent *)getStudentWithId:(NSString *)stuId;

@end
