//
//  LyStudentManager.m
//  teacher
//
//  Created by Junes on 16/8/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyStudentManager.h"


@implementation LyStudentManager

lySingle_implementation(LyStudentManager)

- (instancetype)init
{
    if (self = [super init])
    {
        container = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


- (void)addStudent:(LyStudent *)student
{
    [container setObject:student forKey:student.userId];
}

- (void)removeStudent:(LyStudent *)student
{
    [container removeObjectForKey:student.userId];
}

- (void)removeStudentByStuId:(NSString *)stuId
{
    [container removeObjectForKey:stuId];
}

- (void)removeAllSutdent
{
    [container removeAllObjects];
}

- (NSArray *)getAllStudent
{
    return [container allValues];
}

- (NSArray *)getStudentWithStudyProgress:(LySubjectMode)studyProgress teacherId:(NSString *)teacherId {
    if (!container || container.count < 1) {
        return nil;
    }
    
    NSMutableArray *arrResult = [NSMutableArray array];
    
    NSEnumerator *enumrator = [container keyEnumerator];
    NSString *key;
    while (key = [enumrator nextObject]) {
        LyStudent *student = [container objectForKey:key];
        if (studyProgress == student.stuStudyProgress && [teacherId isEqualToString:student.stuTeacherId]) {
            [arrResult addObject:student];
        }
    }
    
    return [arrResult copy];
}


- (nullable NSArray *)getStudentWithStudyProgress:(LySubjectMode)studyProgress {
    if (!container || container.count < 1) {
        return nil;
    }
    
    NSMutableArray *arrResult = [NSMutableArray array];
    
    NSEnumerator *enumrator = [container keyEnumerator];
    NSString *key;
    while (key = [enumrator nextObject]) {
        LyStudent *student = [container objectForKey:key];
        if (studyProgress == student.stuStudyProgress) {
            [arrResult addObject:student];
        }
    }
    
    return [arrResult copy];
}



- (LyStudent *)getStudentWithId:(NSString *)stuId
{
    return [container objectForKey:stuId];
}


@end
