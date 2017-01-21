//
//  LyReplyManager.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/29.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyReplyManager.h"
#import "LyEvaluation.h"
#import "LyUtil.h"


@interface LyReplyManager ()
{
    NSMutableDictionary                     *container;
}
@end


@implementation LyReplyManager

lySingle_implementation(LyReplyManager)

- (instancetype)init
{
    if ( self = [super init])
    {
        container = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    return self;
}



- (void)addReply:(LyReply *)reply
{
    if ( !container)
    {
        container = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    if ( !reply || ![reply oId])
    {
        return;
    }
    
    [container setObject:reply forKey:[reply oId]];
}



- (LyReply *)getReplyWithId:(NSString *)oId
{
    if ( !oId || !container || ![container count])
    {
        return nil;
    }
    
    return [container objectForKey:oId];
}


- (NSArray *)addtionalReplyWithEvaluation:(LyEvaluation *)eva
{
    if ( !eva)
    {
        return nil;
    }
    
    if ( !container || ![container count])
    {
        return nil;
    }
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    
    
    NSEnumerator *enumerator = [container keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject]) {
        LyReply *itemReply = [container objectForKey:itemKey];
        
        if ( [[itemReply objectRpId] isEqualToString:[eva oId]])
        {
            [arrResult addObject:itemReply];
            [arrResult addObjectsFromArray:[self addtionalReplyWithReply:itemReply]];
        }
    }
    
    arrResult = [[NSMutableArray alloc] initWithArray:[[NSSet setWithArray:arrResult] allObjects]];
    
    [arrResult sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSDate *date1 = [[LyUtil dateFormatterForAll] dateFromString:( [obj1 time].length<25) ? [[obj1 time] stringByAppendingString:@" +0800"] : [obj1 time]];
        NSDate *date2 = [[LyUtil dateFormatterForAll] dateFromString:( [obj2 time].length<25) ? [[obj2 time] stringByAppendingString:@" +0800"] : [obj2 time]];
        
        if ( [date1 timeIntervalSinceDate:date2] > 0)
        {
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedAscending;
        }
    }];
    
    
    return [arrResult copy];
}


- (NSArray *)addtionalReplyWithReply:(LyReply *)reply
{
    if ( !reply)
    {
        return nil;
    }
    
    if ( !container || ![container count])
    {
        return nil;
    }
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [container keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject]) {
        LyReply *itemReply = [container objectForKey:itemKey];
        
        if ( [[itemReply objectRpId] isEqualToString:reply.oId])
        {
            [arrResult addObject:itemReply];
            [arrResult addObjectsFromArray:[self addtionalReplyWithReply:itemReply]];
        }
    }
    
    arrResult = [[NSMutableArray alloc] initWithArray:[[NSSet setWithArray:arrResult] allObjects]];
    
    [arrResult sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSDate *date1 = [[LyUtil dateFormatterForAll] dateFromString:( [obj1 time].length<25) ? [[obj1 time] stringByAppendingString:@" +0800"] : [obj1 time]];
        NSDate *date2 = [[LyUtil dateFormatterForAll] dateFromString:( [obj2 time].length<25) ? [[obj2 time] stringByAppendingString:@" +0800"] : [obj2 time]];
        
        if ( [date1 timeIntervalSinceDate:date2] > 0)
        {
            return NSOrderedDescending;
            //            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedAscending;
            //            return NSOrderedDescending;
        }
    }];

    
    return [arrResult copy];
}


@end
