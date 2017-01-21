//
//  LyEvaluationForTeacherManager.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/7.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyEvaluationForTeacherManager.h"
#import "LyEvaluationForTeacher.h"
#import "LyUtil.h"


@interface LyEvaluationForTeacherManager ()
{
    NSMutableDictionary                         *emContainerForEva;
}
@end


@implementation LyEvaluationForTeacherManager

lySingle_implementation(LyEvaluationForTeacherManager)


- (instancetype)init
{
    if ( self = [super init])
    {
        if ( !emContainerForEva)
        {
            emContainerForEva = [[NSMutableDictionary alloc] initWithCapacity:1];
        }
    }
    
    return self;
}



- (void)addEvalution:(LyEvaluationForTeacher *)eva
{
    [emContainerForEva setObject:eva forKey:eva.oId];
}



- (NSArray *)getEvalutionWithChDsId:(NSString *)chdsId
{
    if (!emContainerForEva || emContainerForEva.count < 1)
    {
        return nil;
    }
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [emContainerForEva keyEnumerator];
    
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject])
    {
        LyEvaluationForTeacher *eva = [emContainerForEva objectForKey:itemKey];
        if ([chdsId isEqualToString:eva.objectId])
        {
            [arrResult addObject:eva];
        }
    }
    
    
    [arrResult sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        NSDate *timeObj1 = [[LyUtil dateFormatterForAll] dateFromString:[obj1 evaTime]];
//        NSDate *timeObj2 = [[LyUtil dateFormatterForAll] dateFromString:[obj2 evaTime]];
        NSDate *date1 = [[LyUtil dateFormatterForAll] dateFromString:( [obj1 time].length<25) ? [[obj1 time] stringByAppendingString:@" +0800"] : [obj1 time]];
        NSDate *date2 = [[LyUtil dateFormatterForAll] dateFromString:( [obj2 time].length<25) ? [[obj2 time] stringByAppendingString:@" +0800"] : [obj2 time]];
        
        if ( [date1 timeIntervalSinceDate:date2] > 0) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    
    return [arrResult copy];
}


- (LyEvaluationForTeacher *)getEvaluatoinWithEvaId:(NSString *)evaId
{
    if (!emContainerForEva || emContainerForEva.count < 1)
    {
        return nil;
    }
    
    return emContainerForEva[evaId];
}



@end
