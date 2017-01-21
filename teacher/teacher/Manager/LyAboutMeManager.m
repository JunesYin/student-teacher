//
//  LyAboutMeManager.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyAboutMeManager.h"
#import "LyUtil.h"



@interface LyAboutMeManager ()
{
    NSMutableDictionary                 *container;
}
@end


@implementation LyAboutMeManager

lySingle_implementation(LyAboutMeManager)

- (instancetype)init
{
    if ( self = [super init])
    {
        container = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    return self;
}


- (void)addAboutMe:(LyAboutMe *)aboutMe
{
    if ( !container)
    {
        container = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    [container setObject:aboutMe forKey:[aboutMe amId]];
}



- (LyAboutMe *)getAboutMeWithId:(NSString *)amId
{
    if ( !container || ![container count])
    {
        return nil;
    }
    
    return [container objectForKey:amId];
}


- (NSArray *)aboutMeWithUserId:(NSString *)userId
{
    if ( !container || ![container count])
    {
        return nil;
    }
    
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumrator = [container keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumrator nextObject]) {
        LyAboutMe *aboutMe = [container objectForKey:itemKey];
        if ( [[aboutMe amObjectId] isEqualToString:userId])
        {
            [arrResult addObject:aboutMe];
        }
    }
    
    [arrResult sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = [[LyUtil dateFormatterForAll] dateFromString:( [obj1 amTime].length<25) ? [[obj1 amTime] stringByAppendingString:@" +0800"] : [obj1 amTime]];
        NSDate *date2 = [[LyUtil dateFormatterForAll] dateFromString:( [obj2 amTime].length<25) ? [[obj2 amTime] stringByAppendingString:@" +0800"] : [obj2 amTime]];
        
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



- (NSArray *)additionalAboutMeWithAboutMe:(LyAboutMe *)aboutMe
{
    if ( !container || ![container count])
    {
        return nil;
    }
    
    
    NSDate *date;
    if ( [aboutMe amTime].length < 25)
    {
        date = [[LyUtil dateFormatterForAll] dateFromString:[[aboutMe amTime] stringByAppendingString:@" +0800"]];
    }
    else
    {
        date = [[LyUtil dateFormatterForAll] dateFromString:[aboutMe amTime]];
    }
    
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    [arrResult addObject:aboutMe];
    
    if ( LyAboutMeMode_evaluate == [aboutMe amMode])
    {
        NSEnumerator *enumrator = [container keyEnumerator];
        NSString *itemKey;
        while ( itemKey = [enumrator nextObject]) {
            LyAboutMe *item = [container objectForKey:itemKey];

            if ( [item amobjectAmId] && ![[item amobjectAmId] isKindOfClass:[NSNull class]] && [[item amobjectAmId] isKindOfClass:[NSString class]] && [[item amobjectAmId] rangeOfString:@"(null)"].length < 1 && [[item amobjectAmId] length] > 0)
            {
                if ( [[item amobjectAmId] isEqualToString:[aboutMe amId]])
                {
//                    NSDate *itemDate;
//                    if ( [item amTime].length < 25)
//                    {
//                        itemDate = [[LyUtil dateFormatterForAll] dateFromString:[[item amTime] stringByAppendingString:@" +0800"]];
//                    }
//                    else
//                    {
//                        itemDate = [[LyUtil dateFormatterForAll] dateFromString:[item amTime]];
//                    }
//                    if ( [date timeIntervalSinceDate:itemDate] > 0)
//                    {
                        [arrResult addObject:item];
//                    }
                }
            }
        }
    }
    else if ( LyAboutMeMode_reply == [aboutMe amMode])
    {
        NSEnumerator *enumrator = [container keyEnumerator];
        NSString *itemKey;
        while ( itemKey = [enumrator nextObject]) {
            LyAboutMe *item = [container objectForKey:itemKey];
            
            if ( [item amobjectAmId] && ![[item amobjectAmId] isKindOfClass:[NSNull class]] && [[item amobjectAmId] isKindOfClass:[NSString class]] && [[item amobjectAmId] rangeOfString:@"(null)"].length < 1 && [[item amobjectAmId] length] > 0)
            {
                if ( [[item amobjectAmId] isEqualToString:[aboutMe amId]])
                {
//                    NSDate *itemDate;
//                    if ( [item amTime].length < 25)
//                    {
//                        itemDate = [[LyUtil dateFormatterForAll] dateFromString:[[item amTime] stringByAppendingString:@" +0800"]];
//                    }
//                    else
//                    {
//                        itemDate = [[LyUtil dateFormatterForAll] dateFromString:[item amTime]];
//                    }
//                    if ( [date timeIntervalSinceDate:itemDate] > 0)
//                    {
                        [arrResult addObject:item];
//                    }
                }
            }
        }
        
        LyAboutMe *objectAm = [self getAboutMeWithId:[aboutMe amobjectAmId]];
        [arrResult addObjectsFromArray:[self additionalAboutMeWithAboutMe:objectAm]];
    }
    
//        else if ( LyAboutMeMode_reply == [aboutMe amMode])
//        {
        
            
//            NSDate *itemDate;
//            if ( [item amTime].length < 25)
//            {
//                itemDate = [[LyUtil dateFormatterForAll] dateFromString:[[item amTime] stringByAppendingString:@" +0800"]];
//            }
//            else
//            {
//                itemDate = [[LyUtil dateFormatterForAll] dateFromString:[item amTime]];
//            }
//            
//            if ( [date timeIntervalSinceDate:itemDate] > 0)
//            {
//                if ( [[item amNewsId] isEqualToString:[aboutMe amNewsId]] && [item amMode] >= LyAboutMeMode_evaluate)
//                {
//                    if ( ( [[item amMasterId] isEqualToString:[aboutMe amMasterId]] && [[item amObjectId] isEqualToString:[aboutMe amObjectId]])
//                        || ( [[item amMasterId] isEqualToString:[aboutMe amObjectId]] && [[item amObjectId] isEqualToString:[aboutMe amMasterId]]) )
//                    {
//                        [arrResult addObject:item];
//                    }
//                }
//            }

    arrResult = [[NSMutableArray alloc] initWithArray:[[NSSet setWithArray:arrResult] allObjects]];
    
    [arrResult sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSDate *date1 = [[LyUtil dateFormatterForAll] dateFromString:( [obj1 amTime].length<25) ? [[obj1 amTime] stringByAppendingString:@" +0800"] : [obj1 amTime]];
        NSDate *date2 = [[LyUtil dateFormatterForAll] dateFromString:( [obj2 amTime].length<25) ? [[obj2 amTime] stringByAppendingString:@" +0800"] : [obj2 amTime]];
        
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



