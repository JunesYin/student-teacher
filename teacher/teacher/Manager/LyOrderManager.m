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



- (instancetype)init {
    if ( self = [super init]) {
        containerOrder = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    
    return self;
}

- (void)removeAllOrder {
    [containerOrder removeAllObjects];
}


- (void)addOrder:(LyOrder *)order {
    if ( !containerOrder) {
        containerOrder = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    if ( 1 == [order orderFlag]) {
        [containerOrder setObject:order forKey:[order orderId]];
    }
}



- (void)removeOrder:(LyOrder *)order {
    [containerOrder removeObjectForKey:[order orderId]];
}

- (void)removeOrderWithOrderId:(NSString *)orderId {
    [containerOrder removeObjectForKey:orderId];
}


- (LyOrder *)getOrderWithOrderId:(NSString *)orderId {
    if ( !containerOrder) {
        containerOrder = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        return nil;
    }
    
    
    return [containerOrder objectForKey:orderId];
}



- (NSArray *)getOrderWithOrderStatus:(LyOrderPayStatus)payStatus dtaStart:(NSDate *)dateStart dataEnd:(NSDate *)dateEnd userId:(NSString *)userId {
    
    if (!containerOrder || containerOrder.count < 1) {
        return nil;
    }
    
    NSMutableArray *arrResult = [NSMutableArray array];
    
    BOOL flag;
    
    dateEnd = [dateEnd dateByAddingTimeInterval:3600 * 24];
    
    NSEnumerator *enumerator = [containerOrder keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject]) {
        flag = NO;
        LyOrder *order = [containerOrder objectForKey:itemKey];
        if ([userId isEqualToString:order.orderObjectId] || [userId isEqualToString:order.recipient]) {
//            if (LyOrderPayStatus_close < payStatus) {
//                flag = YES;
//            } else if (payStatus == order.orderPayStatus) {
//                flag = YES;
//            }
            if (payStatus == order.orderPayStatus) {
                flag = YES;
            }
        }
        if (flag) {
            if (dateStart && dateEnd) {
                NSDate *date = [[LyUtil dateFormatterForAll] dateFromString:order.orderTime];
                if ([date timeIntervalSinceDate:dateStart] > 0 && [dateEnd timeIntervalSinceDate:date] > 0) {
                    [arrResult addObject:order];
                }
            } else {
                [arrResult addObject:order];
            }
        }
    }
    
    
    [arrResult sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = [[LyUtil dateFormatterForAll] dateFromString:( [obj1 orderTime].length<25) ? [[obj1 orderTime] stringByAppendingString:@" +0800"] : [obj1 orderTime]];
        NSDate *date2 = [[LyUtil dateFormatterForAll] dateFromString:( [obj2 orderTime].length<25) ? [[obj2 orderTime] stringByAppendingString:@" +0800"] : [obj2 orderTime]];
        
        if ( [date1 timeIntervalSinceDate:date2] > 0) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    
    
    return arrResult;
}



@end
