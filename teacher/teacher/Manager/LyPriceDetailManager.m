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
    if ( self = [super init]) {
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



- (void)removePriceDetail:(LyPriceDetail *)priceDetail {
    if (!priceDetail || !priceDetail.pdId) {
        return;
    }
    
    [self removePriceDetailById:priceDetail.pdId];
}

- (void)removePriceDetailById:(NSString *)pdId {
    if (!container || container.count < 1) {
        return;
    }
    
    if (!pdId) {
        return;
    }
    
    [container removeObjectForKey:pdId];
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



- (NSArray *)priceDetailWithUserId:(NSString *)userId license:(LyLicenseType)license
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
        if ( [priceDetail.pdMasterId isEqualToString:userId] && license == priceDetail.pdLicenseType) {
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


- (NSArray *)priceDetailWithUserId:(NSString *)userId license:(LyLicenseType)license subjectMode:(LySubjectModeprac)subjectMode
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
        if ( [[priceDetail pdMasterId] isEqualToString:userId] && license == priceDetail.pdLicenseType && subjectMode == [priceDetail pdSubjectMode]) {
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



- (LySubjectModeSupportMode)getSubjectSupportModeWith:(NSString *)weekday andTimeStart:(NSInteger)timeStart userId:(NSString *)userId license:(LyLicenseType)license {
    
    int iWeekday = (int)[LyUtil getWeekdayIndex:weekday];
    
    BOOL flagSecond = NO;
    BOOL flagThird = NO;
    
    NSEnumerator *enumerator = [container keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject]) {
        LyPriceDetail *priceDetail = [container objectForKey:itemKey];
        
        if ( [[priceDetail pdMasterId] isEqualToString:userId] && license == priceDetail.pdLicenseType)
        {
            if ( [priceDetail pdWeekdaySpan].begin <= iWeekday && iWeekday <= [priceDetail pdWeekdaySpan].end)
            {
                if ( [priceDetail pdTimeBucket].begin <= timeStart && timeStart < [priceDetail pdTimeBucket].end)
                {
                    if (LySubjectMode_second == priceDetail.pdSubjectMode) {
                        flagSecond = YES;
                    } else if (LySubjectMode_third == priceDetail.pdSubjectMode) {
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



- (float)getPriceWithDate:(NSDate *)date andWeekday:(NSString *)weekday andTimeStart:(NSInteger)timeStart andSubjectMode:(LySubjectModeprac)subjectMode userId:(NSString *)userId license:(LyLicenseType)license {
    int iWeekday = (int)[LyUtil getWeekdayIndex:weekday];
    
    NSEnumerator *enumerator = [container keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject]) {
        LyPriceDetail *priceDetail = [container objectForKey:itemKey];
        
        if ( [[priceDetail pdMasterId] isEqualToString:userId] && license == priceDetail.pdLicenseType && [priceDetail pdSubjectMode] == subjectMode)
        {
            if ( [priceDetail pdWeekdaySpan].begin <= iWeekday && iWeekday <= [priceDetail pdWeekdaySpan].end)
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




/*
 - (void)addPriceDetail:(LyPriceDetail *)priceDetail
 {
 if ( !container)
 {
 container = [[NSMutableDictionary alloc] initWithCapacity:1];
 }
 
 
 NSMutableDictionary *dicUserId = [container objectForKey:[priceDetail pdMasterId]];
 if ( !dicUserId)
 {
 dicUserId = [[NSMutableDictionary alloc] initWithCapacity:1];
 [container setObject:dicUserId forKey:[priceDetail pdMasterId]];
 }
 
 [dicUserId setObject:priceDetail forKey:[priceDetail pdId]];
 }
 
 
 - (NSDictionary *)priceDetailWithUserId:(NSString *)userId andDriveLicense:(LyLicenseType)license
 {
 if ( !container || ![container count])
 {
 return nil;
 }
 
 return [container objectForKey:userId];
 }
 */

@end
