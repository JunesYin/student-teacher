//
//  LyDateTimeInfoManager.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/20.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyDateTimeInfoManager.h"


@interface LyDateTimeInfoManager ()
{
    NSMutableDictionary         *container;
}
@end

@implementation LyDateTimeInfoManager

lySingle_implementation(LyDateTimeInfoManager)

- (instancetype)init
{
    if ( self = [super init])
    {
        container = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    return self;
}


- (void)addDateTimeInfo:(LyDateTimeInfo *)dateTimeInfo
{
    if ( !container)
    {
        container = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    NSMutableDictionary *dicObject = [container objectForKey:[dateTimeInfo date]];
    
    if ( !dicObject)
    {
        dicObject = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        [container setObject:dicObject forKey:[dateTimeInfo objectId]];
    }
    
    [dicObject setObject:dateTimeInfo forKey:[[NSString alloc] initWithFormat:@"%d", (int)[dateTimeInfo mode]]];
    
}


- (NSDictionary *)getDateTimeInfoWithObjectId:(NSString *)objectId
{
    if ( !container || ![container count])
    {
        return nil;
    }
    
    
    NSMutableDictionary *dicObject = [container objectForKey:objectId];
    
    return [dicObject copy];
}


- (LyDateTimeInfo *)getDateTimeInfoWithId:(NSString *)dateTimeInfoId
{
    if ( !container || ![container count])
    {
        return nil;
    }

    
    NSEnumerator *enumerator = [container keyEnumerator];
    NSString *itemKey;
    
    while ( itemKey = [enumerator nextObject]) {
        NSMutableDictionary *dicObject = [container objectForKey:itemKey];
        
        if ( !dicObject || [dicObject count])
        {
            continue;
        }
        
        LyDateTimeInfo *dateTimeInfo = [dicObject objectForKey:dateTimeInfoId];
        
        if ( !dateTimeInfo)
        {
            return dateTimeInfo;
        }
    }
    
    
    return nil;
}


@end
