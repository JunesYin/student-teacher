//
//  LyOrderManager.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/30.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyOrderManager.h"


@interface LyOrderManager ()
{
    NSMutableDictionary                         *containerOrder;
}
@end


@implementation LyOrderManager

lySingle_implementation(LyOrderManager)



- (instancetype)init
{
    if ( self = [super init])
    {
        containerOrder = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    
    return self;
}

- (void)removeAllOrder
{
    [containerOrder removeAllObjects];
}


- (void)addOrder:(LyOrder *)order
{
    if ( !containerOrder)
    {
        containerOrder = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    if ( 1 == [order orderFlag])
    {
        [containerOrder setObject:order forKey:[order orderId]];
    }
}



- (void)removeOrder:(LyOrder *)order
{
    [containerOrder removeObjectForKey:[order orderId]];
}

- (void)removeOrderWithOrderId:(NSString *)orderId
{
    [containerOrder removeObjectForKey:orderId];
}


- (LyOrder *)getOrderWidthOrderId:(NSString *)orderId
{
    if ( !containerOrder)
    {
        containerOrder = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        
        return nil;
    }
    
    
    return [containerOrder objectForKey:orderId];
}



- (NSArray *)getAllOrder
{
    if ( !containerOrder)
    {
        containerOrder = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        return nil;
    }
    
    if ( ![containerOrder count])
    {
        return nil;
    }
    
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [containerOrder keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject])
    {
        [arrResult addObject:[containerOrder objectForKey:itemKey]];
    }
    

    return [arrResult copy];
    
}




- (NSArray *)getOrderWithOrderStatus:(LyOrderState)orderState
{
    if ( !containerOrder)
    {
        containerOrder = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        return nil;
    }
    
    if ( ![containerOrder count])
    {
        return nil;
    }
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [containerOrder keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject])
    {
        if ( orderState > LyOrderState_cancel)
        {
            [arrResult addObject:[containerOrder objectForKey:itemKey]];
        }
        else if ( orderState == [[containerOrder objectForKey:itemKey] orderState])
        {
            [arrResult addObject:[containerOrder objectForKey:itemKey]];
        }
        
    }
    
    
    return [arrResult copy];
}




- (NSArray *)getOrderWithOrderStatus:(LyOrderState)orderState andOrderMode:(LyOrderMode)orderMode
{
    if ( !containerOrder)
    {
        containerOrder = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        return nil;
    }
    
    if ( ![containerOrder count])
    {
        return nil;
    }
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [containerOrder keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject])
    {
        LyOrder *order = [containerOrder objectForKey:itemKey];
        if ( [order orderMode] == orderMode)
        {
            if ( LyOrderState_completed < orderState)
            {
                [arrResult addObject:order];
            }
            else if ( [order orderState] == orderState)
            {
                [arrResult addObject:order];
            }
        }
    }
    
    [arrResult sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        NSDate *timeObj1 = [[LyUtil dateFormatterForAll] dateFromString:[obj1 orderTime]];
//        NSDate *timeObj2 = [[LyUtil dateFormatterForAll] dateFromString:[obj2 orderTime]];
        NSDate *date1 = [[LyUtil dateFormatterForAll] dateFromString:( [obj1 orderTime].length<25) ? [[obj1 orderTime] stringByAppendingString:@" +0800"] : [obj1 orderTime]];
        NSDate *date2 = [[LyUtil dateFormatterForAll] dateFromString:( [obj2 orderTime].length<25) ? [[obj2 orderTime] stringByAppendingString:@" +0800"] : [obj2 orderTime]];
        
        if ( [date1 timeIntervalSinceDate:date2] > 0)
        {
            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedDescending;
        }
    }];
    
    
    return [arrResult copy];
}



- (NSArray *)getOrderWaitPay
{
    if ( !containerOrder)
    {
        containerOrder = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        return nil;
    }
    
    if ( ![containerOrder count])
    {
        return nil;
    }
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [containerOrder keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject])
    {
        if ( LyOrderState_waitPay == [[containerOrder objectForKey:itemKey] orderState])
        {
            [arrResult addObject:[containerOrder objectForKey:itemKey]];
        }
    }
    
    [arrResult sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        //        NSDate *timeObj1 = [[LyUtil dateFormatterForAll] dateFromString:[obj1 orderTime]];
        //        NSDate *timeObj2 = [[LyUtil dateFormatterForAll] dateFromString:[obj2 orderTime]];
        NSDate *date1 = [[LyUtil dateFormatterForAll] dateFromString:( [obj1 orderTime].length<25) ? [[obj1 orderTime] stringByAppendingString:@" +0800"] : [obj1 orderTime]];
        NSDate *date2 = [[LyUtil dateFormatterForAll] dateFromString:( [obj2 orderTime].length<25) ? [[obj2 orderTime] stringByAppendingString:@" +0800"] : [obj2 orderTime]];
        
        if ( [date1 timeIntervalSinceDate:date2] > 0)
        {
            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedDescending;
        }
    }];
    
    
    return [arrResult copy];
}




- (NSArray *)getOrderWaitConfirm
{
    if ( !containerOrder)
    {
        containerOrder = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        return nil;
    }
    
    if ( ![containerOrder count])
    {
        return nil;
    }
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [containerOrder keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject])
    {
        if ( LyOrderState_waitConfirm == [[containerOrder objectForKey:itemKey] orderState])
        {
            [arrResult addObject:[containerOrder objectForKey:itemKey]];
        }
    }
    
    [arrResult sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        //        NSDate *timeObj1 = [[LyUtil dateFormatterForAll] dateFromString:[obj1 orderTime]];
        //        NSDate *timeObj2 = [[LyUtil dateFormatterForAll] dateFromString:[obj2 orderTime]];
        NSDate *date1 = [[LyUtil dateFormatterForAll] dateFromString:( [obj1 orderTime].length<25) ? [[obj1 orderTime] stringByAppendingString:@" +0800"] : [obj1 orderTime]];
        NSDate *date2 = [[LyUtil dateFormatterForAll] dateFromString:( [obj2 orderTime].length<25) ? [[obj2 orderTime] stringByAppendingString:@" +0800"] : [obj2 orderTime]];
        
        if ( [date1 timeIntervalSinceDate:date2] > 0)
        {
            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedDescending;
        }
    }];
    
    return [arrResult copy];
}




- (NSArray *)getOrderWaitEvalute
{
    if ( !containerOrder)
    {
        containerOrder = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        return nil;
    }
    
    if ( ![containerOrder count])
    {
        return nil;
    }
    
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [containerOrder keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject])
    {
        if ( LyOrderState_waitEvalute == [[containerOrder objectForKey:itemKey] orderState])
        {
            [arrResult addObject:[containerOrder objectForKey:itemKey]];
        }
    }
    
    [arrResult sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        //        NSDate *timeObj1 = [[LyUtil dateFormatterForAll] dateFromString:[obj1 orderTime]];
        //        NSDate *timeObj2 = [[LyUtil dateFormatterForAll] dateFromString:[obj2 orderTime]];
        NSDate *date1 = [[LyUtil dateFormatterForAll] dateFromString:( [obj1 orderTime].length<25) ? [[obj1 orderTime] stringByAppendingString:@" +0800"] : [obj1 orderTime]];
        NSDate *date2 = [[LyUtil dateFormatterForAll] dateFromString:( [obj2 orderTime].length<25) ? [[obj2 orderTime] stringByAppendingString:@" +0800"] : [obj2 orderTime]];
        
        if ( [date1 timeIntervalSinceDate:date2] > 0)
        {
            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedDescending;
        }
    }];
    
    return [arrResult copy];
}



- (NSArray *)getOrderCompleted
{
    if ( !containerOrder)
    {
        containerOrder = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        return nil;
    }
    
    if ( ![containerOrder count])
    {
        return nil;
    }
    
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [containerOrder keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject])
    {
        if ( LyOrderState_completed == [[containerOrder objectForKey:itemKey] orderState])
        {
            [arrResult addObject:[containerOrder objectForKey:itemKey]];
        }
    }
    
    [arrResult sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        //        NSDate *timeObj1 = [[LyUtil dateFormatterForAll] dateFromString:[obj1 orderTime]];
        //        NSDate *timeObj2 = [[LyUtil dateFormatterForAll] dateFromString:[obj2 orderTime]];
        NSDate *date1 = [[LyUtil dateFormatterForAll] dateFromString:( [obj1 orderTime].length<25) ? [[obj1 orderTime] stringByAppendingString:@" +0800"] : [obj1 orderTime]];
        NSDate *date2 = [[LyUtil dateFormatterForAll] dateFromString:( [obj2 orderTime].length<25) ? [[obj2 orderTime] stringByAppendingString:@" +0800"] : [obj2 orderTime]];
        
        if ( [date1 timeIntervalSinceDate:date2] > 0)
        {
            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedDescending;
        }
    }];
    
    return [arrResult copy];
}








@end
