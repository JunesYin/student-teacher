//
//  LyStatusManager.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/30.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyStatusManager.h"
#import "LyStatus.h"
#import "LyUtil.h"


@interface LyStatusManager ()
{
    NSMutableDictionary                     *smContainerStatus;
}
@end


@implementation LyStatusManager

lySingle_implementation(LyStatusManager)


- (instancetype)init
{
    if ( self = [super init])
    {
        if ( !smContainerStatus)
        {
            smContainerStatus = [[NSMutableDictionary alloc] initWithCapacity:1];
        }
    }
    
    return self;
}



- (void)addStatus:(LyStatus *)status
{
    [smContainerStatus setObject:status forKey:[status staId]];
}



- (void)removeStatus:(LyStatus *)status
{
    if ( !smContainerStatus || ![smContainerStatus count])
    {
        return;
    }
    
    if ( [smContainerStatus objectForKey:[status staId]])
    {
        [smContainerStatus removeObjectForKey:[status staId]];
    }
}

- (void)removeStatusWithStatusId:(NSString *)statusId
{
    if ( !smContainerStatus || ![smContainerStatus count])
    {
        return;
    }
    
    if ( [smContainerStatus objectForKey:statusId])
    {
        [smContainerStatus removeObjectForKey:statusId];
    }
}




- (NSInteger)getStatusCount
{
    return [smContainerStatus count];
}



- (NSArray *)getAllStatus
{
    NSMutableArray *arrResultTmp = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [smContainerStatus keyEnumerator];
    
    NSString *item;
    
    while ( item = [enumerator nextObject])
    {
        [arrResultTmp addObject:[smContainerStatus objectForKey:item]];
    }
    
    
    [arrResultTmp sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        NSDate *timeObj1 = [[LyUtil dateFormatterForAll] dateFromString:[obj1 staTime]];
//        NSDate *timeObj2 = [[LyUtil dateFormatterForAll] dateFromString:[obj2 staTime]];
        NSDate *date1 = [[LyUtil dateFormatterForAll] dateFromString:( [obj1 staTime].length<25) ? [[obj1 staTime] stringByAppendingString:@" +0800"] : [obj1 staTime]];
        NSDate *date2 = [[LyUtil dateFormatterForAll] dateFromString:( [obj2 staTime].length<25) ? [[obj2 staTime] stringByAppendingString:@" +0800"] : [obj2 staTime]];
        
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




- (LyStatus *)getStatusWithStatusId:(NSString *)statusId
{
    return [smContainerStatus objectForKey:statusId];
}



- (NSArray *)getStatusWithUserId:(NSString *)userId
{
    NSMutableArray *arrResultTmp = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [smContainerStatus keyEnumerator];
    
    NSString *item;
    
    while ( item = [enumerator nextObject])
    {
        if ( [userId isEqualToString:[[smContainerStatus objectForKey:item] staMasterId]])
        {
            [arrResultTmp addObject:[smContainerStatus objectForKey:item]];
        }
    }
    
    [arrResultTmp sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        NSDate *timeObj1 = [[LyUtil dateFormatterForAll] dateFromString:[obj1 staTime]];
//        NSDate *timeObj2 = [[LyUtil dateFormatterForAll] dateFromString:[obj2 staTime]];
        NSDate *date1 = [[LyUtil dateFormatterForAll] dateFromString:( [obj1 staTime].length<25) ? [[obj1 staTime] stringByAppendingString:@" +0800"] : [obj1 staTime]];
        NSDate *date2 = [[LyUtil dateFormatterForAll] dateFromString:( [obj2 staTime].length<25) ? [[obj2 staTime] stringByAppendingString:@" +0800"] : [obj2 staTime]];
        
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



@end
