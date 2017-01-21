//
//  LyExamHistoryManager.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/3.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyExamHistoryManager.h"


@interface LyExamHistoryManager ()
{
    NSMutableDictionary             *container;
}
@end

@implementation LyExamHistoryManager

lySingle_implementation(LyExamHistoryManager)

- (instancetype)init
{
    if ( self = [super init])
    {
        container = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    return self;
}


- (void)addExamHistory:(LyExamHistory *)examHistory
{
    if ( !container)
    {
        container = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    [container setObject:examHistory forKey:[examHistory ehId]];
}




- (NSArray *)getAllExamHistory
{
    if ( !container || ![container count])
    {
        return nil;
    }
    
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    NSEnumerator *enumrator = [container keyEnumerator];
    NSString *itemIdKey;
    while ( itemIdKey = [enumrator nextObject]) {
        [arrResult addObject:[container objectForKey:itemIdKey]];
    }
    
    
    [arrResult sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = [obj1 date];
        NSDate *date2 = [obj2 date];
        
        return [date1 compare:date2];
    }];
    
    
    return  [arrResult copy];
}



- (NSArray *)getExamHistoryWithUserId:(NSString *)userId
{
    if ( !container || ![container count])
    {
        return nil;
    }
    
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    NSEnumerator *enumrator = [container keyEnumerator];
    NSString *itemIdKey;
    while ( itemIdKey = [enumrator nextObject]) {
        LyExamHistory *examHistory = [container objectForKey:itemIdKey];
        if ( [[examHistory userId] isEqualToString:userId])
        {
            [arrResult addObject:examHistory];
        }
    }
    
    [arrResult sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = [obj1 date];
        NSDate *date2 = [obj2 date];
        
        return [date2 compare:date1];
    }];
    
    
    return  [arrResult copy];
}




- (NSInteger)averageScoreWithUserId:(NSString *)userId
{
    if ( !container || ![container count])
    {
        return 0;
    }
    
    NSInteger totalScore = 0;
    NSInteger iCount = 0;
    
    NSEnumerator *enumrator = [container keyEnumerator];
    NSString *itemIdKey;
    while ( itemIdKey = [enumrator nextObject]) {
        LyExamHistory *examHistory = [container objectForKey:itemIdKey];
        if ( [[examHistory userId] isEqualToString:userId])
        {
            iCount++;
            totalScore += [examHistory score];
        }
    }
    
    if ( 0 == iCount)
    {
        return 0;
    }
    
    return totalScore / iCount;
}



- (NSInteger)examCountWithUserId:(NSString *)userId
{
    if ( !container || ![container count])
    {
        return 0;
    }
    
    NSInteger iCount = 0;
    
    NSEnumerator *enumrator = [container keyEnumerator];
    NSString *itemIdKey;
    while ( itemIdKey = [enumrator nextObject]) {
        LyExamHistory *examHistory = [container objectForKey:itemIdKey];
        if ( [[examHistory userId] isEqualToString:userId])
        {
            iCount++;
        }
    }
    
    return iCount;
}



- (LyExamHistory *)getExamHistoryWithId:(NSString *)ehId
{
    if ( !container || ![container count])
    {
        return nil;
    }
    
    
    return [container objectForKey:ehId];
}


@end
