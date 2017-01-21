//
//  LyTrainBaseManager.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyTrainBaseManager.h"


@interface LyTrainBaseManager ()
{
    NSMutableDictionary         *container;
}
@end


@implementation LyTrainBaseManager

lySingle_implementation(LyTrainBaseManager)


+ (LyTrainBase *)getTrainBaseWithTbName:(NSString *)tbName withDataSouce:(NSArray *)arrSource
{
    for ( LyTrainBase *item in arrSource)
    {
        if ( [[item tbName] isEqualToString:tbName])
        {
            return item;
        }
    }
    
    return nil;
}



- (instancetype)init
{
    if ( self = [super init])
    {
        container = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    return self;
}



- (void)addTrainBase:(LyTrainBase *)trainBase
{
    if ( !container)
    {
        container = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    [container setObject:trainBase forKey:[trainBase tbId]];
}



- (NSArray *)getAllTrainBase
{
    if ( !container || ![container count])
    {
        return nil;
    }
    
    
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [container keyEnumerator];
    NSString *itemKey;
    
    while ( itemKey = [enumerator nextObject]) {
        [result addObject:[container objectForKey:itemKey]];
    }
    
    return [result copy];
}


- (LyTrainBase *)getTrainBaseWithTbId:(NSString *)tbId
{
    return [container objectForKey:tbId];
}



@end
