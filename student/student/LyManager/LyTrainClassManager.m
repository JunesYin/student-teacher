//
//  LyTrainClassManager.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/13.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyTrainClassManager.h"
#import "LyUtil.h"


@interface LyTrainClassManager ()
{
    NSMutableDictionary *tcContainer;
}
@end


@implementation LyTrainClassManager


lySingle_implementation(LyTrainClassManager)


- (instancetype)init
{
    if ( self = [super init])
    {
        tcContainer = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    return self;
}


- (void)addTrainClass:(LyTrainClass *)trainClass
{
    if ( !tcContainer)
    {
        tcContainer = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    [tcContainer setObject:trainClass forKey:[trainClass tcId]];
    
}


- (NSArray *)getTrainClassWithTeacherId:(NSString *)teacherId
{
    if ( !tcContainer || ![tcContainer count])
    {
        return nil;
    }
    
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [tcContainer keyEnumerator];
    NSString *itemKey;
    
    while ( itemKey = [enumerator nextObject])
    {
        LyTrainClass *trainClass = [tcContainer objectForKey:itemKey];
        if ( [[trainClass tcMasterId] isEqualToString:teacherId])
        {
            [arrResult addObject:trainClass];
        }
    }
    
    return [arrResult copy];
}


- (NSArray *)getTrainClassWithDriveSchoolId:(NSString *)driveSchoolId
{
    if ( !tcContainer || ![tcContainer count])
    {
        return nil;
    }
    
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [tcContainer keyEnumerator];
    NSString *itemKey;
    
    while ( itemKey = [enumerator nextObject])
    {
        LyTrainClass *trainClass = [tcContainer objectForKey:itemKey];
        if ( [[trainClass tcMasterId] isEqualToString:driveSchoolId])
        {
            [arrResult addObject:trainClass];
        }
    }
    
    return [arrResult copy];
}



- (NSArray *)getTrainClassWithCoachId:(NSString *)coachId
{
    if ( !tcContainer || ![tcContainer count])
    {
        return nil;
    }
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [tcContainer keyEnumerator];
    NSString *itemKey;
    
    while ( itemKey = [enumerator nextObject])
    {
        LyTrainClass *trainClass = [tcContainer objectForKey:itemKey];
        if ( [[trainClass tcMasterId] isEqualToString:coachId])
        {
            [arrResult addObject:trainClass];
        }
    }
    
    return [arrResult copy];
}




- (NSArray *)getTrainClassWithGuiderId:(NSString *)guiderId
{
    if ( !tcContainer || ![tcContainer count])
    {
        return nil;
    }
    
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [tcContainer keyEnumerator];
    NSString *itemKey;
    
    while ( itemKey = [enumerator nextObject])
    {
        LyTrainClass *trainClass = [tcContainer objectForKey:itemKey];
        if ( [[trainClass tcMasterId] isEqualToString:guiderId])
        {
            [arrResult addObject:trainClass];
        }
    }
    
    return [arrResult copy];
}




- (LyTrainClass *)getTrainClassWithTrainClassId:(NSString *)trainClassId
{
    NSEnumerator *enumerator = [tcContainer keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject])
    {
        LyTrainClass *trainClass = [tcContainer objectForKey:itemKey];
        if ( [[trainClass tcId] isEqualToString:trainClassId])
        {
            return trainClass;
        }
    }
    
    return nil;
}



- (LyTrainClass *)getTrainClassWithTrainClassId:(NSString *)trainClassId withDriveSchoolId:(NSString *)driveSchoolId
{
    if ( !tcContainer || ![tcContainer count])
    {
        return nil;
    }
    
    return [tcContainer objectForKey:trainClassId];
}



- (LyTrainClass *)getTrainClassWithTrainClassId:(NSString *)trainClassId withCoachId:(NSString *)coachId
{
    if ( !tcContainer || ![tcContainer count])
    {
        return nil;
    }
    
    return [tcContainer objectForKey:trainClassId];
}



- (LyTrainClass *)getTrainClassWithTrainClassId:(NSString *)trainClassId withGuiderId:(NSString *)guiderId
{
    if ( !tcContainer || ![tcContainer count])
    {
        return nil;
    }
    
    return [tcContainer objectForKey:trainClassId];
}



@end
