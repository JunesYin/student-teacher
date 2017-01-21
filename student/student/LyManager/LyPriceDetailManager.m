//
//  LyPriceDetailManager.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/21.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyPriceDetailManager.h"


@interface LyPriceDetailManager ()
{
    NSMutableDictionary         *container;
}
@end


@implementation LyPriceDetailManager

lySingle_implementation(LyPriceDetailManager)


- (instancetype)init
{
    if ( self = [super init])
    {
        container = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    return self;
}



- (void)addPriceDetail:(LyPriceDetail *)priceDetail
{
    if ( !container)
    {
        container = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    [container setObject:priceDetail forKey:[priceDetail pdId]];
}


- (NSArray *)priceDetailWithUserId:(NSString *)userId
{
    if ( !container || ![container count])
    {
        return nil;
    }
    
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [container keyEnumerator];
    NSString *itemKey;
    
    while ( itemKey = [enumerator nextObject]) {
        LyPriceDetail *priceDetail = [container objectForKey:itemKey];
        if ( [[priceDetail pdMasterId] isEqualToString:userId])
        {
            [arrResult addObject:priceDetail];
        }
    }
    
    [arrResult sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        if ( [obj1 pdTimeBucket].begin > [obj2 pdTimeBucket].begin) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    return [arrResult copy];
}


- (NSArray *)priceDetailWithUserId:(NSString *)userId andDriveLicense:(LySubjectModeprac)license
{
    if ( !container || ![container count])
    {
        return nil;
    }
    
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [container keyEnumerator];
    NSString *itemKey;
    
    while ( itemKey = [enumerator nextObject]) {
        LyPriceDetail *priceDetail = [container objectForKey:itemKey];
        if ( [[priceDetail pdMasterId] isEqualToString:userId] && license == [priceDetail pdSubjectMode])
        {
            [arrResult addObject:priceDetail];
        }
    }
    
    
    [arrResult sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        if ( [obj1 pdTimeBucket].begin > [obj2 pdTimeBucket].begin)
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



//- (LySubjectModeSupportMode)getSubjectSupportModeWith:(NSString *)weekday andTimeStart:(NSInteger)timeStart userId:(NSString *)userId {
- (LySubjectModeSupportMode)getSubjectSupportModeWith:(LyWeekday)weekday andTimeStart:(NSInteger)timeStart userId:(NSString *)userId {
    
    BOOL flagSecond = NO;
    BOOL flagThird = NO;
    
    NSEnumerator *enumerator = [container keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject]) {
        LyPriceDetail *priceDetail = [container objectForKey:itemKey];
        
        if ( [[priceDetail pdMasterId] isEqualToString:userId])
        {
            if ( [priceDetail pdWeekdaySpan].begin <= weekday && weekday <= [priceDetail pdWeekdaySpan].end)
            {
                if ( [priceDetail pdTimeBucket].begin <= timeStart && timeStart < [priceDetail pdTimeBucket].end)
                {
                    if (LySubjectModeprac_second == priceDetail.pdSubjectMode) {
                        flagSecond = YES;
                    } else if (LySubjectModeprac_third == priceDetail.pdSubjectMode) {
                        flagThird = YES;
                    }
                }
            }
        }
    }
    
    if (flagSecond && flagThird) {
        return LySubjectModeSupportMode_both;
    } else if (flagSecond) {
        return LySubjectModeSupportMode_second;
    } else if (flagThird) {
        return LySubjectModeSupportMode_third;
    } else {
        return LySubjectModeSupportMode_none;
    }
}



- (float)getPriceWithDate:(NSDate *)date andWeekday:(LyWeekday)weekday andTimeStart:(NSInteger)timeStart andLicense:(LySubjectModeprac)license userId:(NSString *)userId
{
    
    NSEnumerator *enumerator = [container keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject]) {
        LyPriceDetail *priceDetail = [container objectForKey:itemKey];
        
        if ( [[priceDetail pdMasterId] isEqualToString:userId] && [priceDetail pdSubjectMode] == license)
        {
            if ( [priceDetail pdWeekdaySpan].begin <= weekday && weekday <= [priceDetail pdWeekdaySpan].end)
            {
                if ( [priceDetail pdTimeBucket].begin <= timeStart && timeStart < [priceDetail pdTimeBucket].end)
                {
                    return [priceDetail pdPrice];
                }
            }
        }
    }
    
    return 0;
}




@end
