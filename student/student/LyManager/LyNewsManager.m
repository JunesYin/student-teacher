//
//  LyNewsManager.m
//  teacher
//
//  Created by Junes on 2016/10/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyNewsManager.h"
#import "LyUtil.h"


@interface LyNewsManager ()
{
    NSMutableDictionary     *container;
}
@end

@implementation LyNewsManager

lySingle_implementation(LyNewsManager)

- (instancetype)init {
    if (self = [super init]) {
        container = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    return self;
}

- (void)addNews:(nonnull LyNews *)news {
    if (!news || ![LyUtil validateString:news.newsId]) {
        return;
    }
    
    [container setObject:news forKey:news.newsId];
}

- (void)deleteNews:(nonnull LyNews *)news {
    if (!news) {
        return;
    }
    
    [self deleteNewsWithNewsId:news.newsId];
}

- (void)deleteNewsWithNewsId:(nonnull NSString *)newsId {
    if (![LyUtil validateString:newsId]) {
        return;
    }
    
    [container removeObjectForKey:newsId];
}

- (nullable NSArray *)getAllNews {
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[container allValues]];
    
    [arr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = [[LyUtil dateFormatterForAll] dateFromString:( [obj1 newsTime].length<25) ? [[obj1 newsTime] stringByAppendingString:@" +0800"] : [obj1 newsTime]];
        NSDate *date2 = [[LyUtil dateFormatterForAll] dateFromString:( [obj2 newsTime].length<25) ? [[obj2 newsTime] stringByAppendingString:@" +0800"] : [obj2 newsTime]];
        
        if ( [date1 timeIntervalSinceDate:date2] > 0) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    return [arr copy];
}

- (nullable LyNews *)getNewsWithNewsId:(nonnull NSString *)newsId {
    if (![LyUtil validateString:newsId]) {
        return nil;
    }
    
    return [container objectForKey:newsId];
}

- (nullable NSArray *)getNewsWithUserId:(nonnull NSString *)userId {
    
    if (!container || container.count < 1) {
        return nil;
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (LyNews *news in [container allValues]) {
        if ([news.newsMasterId isEqualToString:userId]) {
            [arr addObject:news];
        }
    }
    
    [arr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = [[LyUtil dateFormatterForAll] dateFromString:( [obj1 newsTime].length<25) ? [[obj1 newsTime] stringByAppendingString:@" +0800"] : [obj1 newsTime]];
        NSDate *date2 = [[LyUtil dateFormatterForAll] dateFromString:( [obj2 newsTime].length<25) ? [[obj2 newsTime] stringByAppendingString:@" +0800"] : [obj2 newsTime]];
        
        if ( [date1 timeIntervalSinceDate:date2] > 0) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    return [arr copy];
}


@end



