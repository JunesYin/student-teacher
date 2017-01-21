//
//  LyConsultManager.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/15.
//  Copyright © 2016年 Junes. All rights reserved.
//


#import "LyConsultManager.h"
#import "LyUtil.h"


@interface LyConsultManager ()
{
    NSMutableDictionary                         *containerForConsult;
}
@end


@implementation LyConsultManager

lySingle_implementation(LyConsultManager)


- (instancetype)init
{
    if ( self = [super init])
    {
        containerForConsult = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    return self;
}

- (void)addConsult:(LyConsult *)consult
{
    if ( !containerForConsult)
    {
        containerForConsult = [[NSMutableDictionary alloc] initWithCapacity:1];
    }

    [containerForConsult setObject:consult forKey:[consult oId]];
}




//- (NSArray *)getAllConsult
//{
//    return nil;
//}




- (NSArray *)getConsultWithObjectId:(NSString *)objectId
{
    if ( !containerForConsult || ![containerForConsult count])
    {
        return nil;
    }
    
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [containerForConsult keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject]) {
        LyConsult *con = [containerForConsult objectForKey:itemKey];
        if ( [[con objectId] isEqualToString:objectId])
        {
            [arrResult addObject:[containerForConsult objectForKey:itemKey]];
        }
    }
    
    
    [arrResult sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
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
    
    
    return [arrResult copy];
    
}



- (nullable LyConsult *)getConsultWithConId:(NSString *)conId
{
    if ( !containerForConsult || ![containerForConsult count])
    {
        return nil;
    }
    
    return containerForConsult[conId];
}



@end
