//
//  LyEvalutionManager.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/7.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyEvaluationManager.h"
#import "LyEvaluation.h"
#import "LyUtil.h"


@interface LyEvalutionManager ()
{
    NSMutableDictionary                         *emContainerForEva;
}
@end


@implementation LyEvalutionManager

lySingle_implementation(LyEvalutionManager)

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



- (void)addEvalutionWithEvaId:(LyEvaluation *)eva
{
    if ( !emContainerForEva)
    {
        emContainerForEva = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    [emContainerForEva setObject:eva forKey:[eva oId]];
}



- (NSArray *)getEvalutionForObjectId:(NSString *)objectId
{
    
    if ( !emContainerForEva || ![emContainerForEva count])
    {
        return nil;
    }
    
    
    NSMutableArray *arrResultTmp = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [emContainerForEva keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject])
    {
        LyEvaluation *eva = [emContainerForEva objectForKey:itemKey];
        if ( [[eva objectingId] isEqualToString:objectId])
        {
            [arrResultTmp addObject:[emContainerForEva objectForKey:itemKey]];
        }
    }
    
    [arrResultTmp sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = [[LyUtil dateFormatterForAll] dateFromString:( [obj1 time].length<25) ? [[obj1 time] stringByAppendingString:@" +0800"] : [obj1 time]];
        NSDate *date2 = [[LyUtil dateFormatterForAll] dateFromString:( [obj2 time].length<25) ? [[obj2 time] stringByAppendingString:@" +0800"] : [obj2 time]];
        
        if ( [date1 timeIntervalSinceDate:date2] > 0)
        {
            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedDescending;
        }
    }];
    
    return [arrResultTmp copy];
}


- (NSArray *)getEvalutionForObjectingId:(NSString *)objectId
{
    
    if ( !emContainerForEva || ![emContainerForEva count])
    {
        return nil;
    }
    
    
    NSMutableArray *arrResultTmp = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [emContainerForEva keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject])
    {
        LyEvaluation *eva = [emContainerForEva objectForKey:itemKey];
        if ( [[eva objectingId] isEqualToString:objectId])
        {
            [arrResultTmp addObject:[emContainerForEva objectForKey:itemKey]];
        }
    }
    
    [arrResultTmp sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = [[LyUtil dateFormatterForAll] dateFromString:( [obj1 time].length<25) ? [[obj1 time] stringByAppendingString:@" +0800"] : [obj1 time]];
        NSDate *date2 = [[LyUtil dateFormatterForAll] dateFromString:( [obj2 time].length<25) ? [[obj2 time] stringByAppendingString:@" +0800"] : [obj2 time]];
        
        if ( [date1 timeIntervalSinceDate:date2] > 0)
        {
            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedDescending;
        }
    }];
    
    return [arrResultTmp copy];
}



- (LyEvaluation *)getEvalutionWithId:(NSString *)evaId
{
    if ( !emContainerForEva || ![emContainerForEva count])
    {
        return nil;
    }
    
    return [emContainerForEva objectForKey:evaId];
}


@end



