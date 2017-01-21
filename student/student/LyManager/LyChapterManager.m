//
//  LyChapterManager.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/21.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyChapterManager.h"


@interface LyChapterManager ()
{
    NSMutableDictionary             *container;
}
@end




@implementation LyChapterManager

lySingle_implementation(LyChapterManager)

- (instancetype)init
{
    if ( self = [super init])
    {
        container = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    return self;
}

- (void)addChapter:(LyChapter *)chapter
{
    if ( !chapter || [NSNull null] == (NSNull *)chapter)
    {
        return;
    }
    
    [container setObject:chapter forKey:[[NSString alloc] initWithFormat:@"%d", (int)[chapter chapterMode]]];
    
}

- (NSArray *)getAllChapterWithUsedMode:(LyChapterUseMode)userMode subjectMode:(LySubjectMode)subjectMode
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSEnumerator *enumerator = [container keyEnumerator];
    NSString *itemKey;
    
    while ( itemKey = [enumerator nextObject]) {
        switch ( userMode) {
            case LyChapterUseMode_chapter: {
                if ( [itemKey integerValue] < 99)
                {
                    if ( subjectMode == LySubjectMode_first && [itemKey integerValue] < 50)
                    {
                        [arrResult addObject:[container objectForKey:itemKey]];
                    }
                    else if ( subjectMode == LySubjectMode_fourth && [itemKey integerValue] >= 50)
                    {
                        [arrResult addObject:[container objectForKey:itemKey]];
                    }
                }
                break;
            }
            case LyChapterUseMode_myLibrary: {
                if ( [itemKey integerValue] > 99)
                {
                    [arrResult addObject:[container objectForKey:itemKey]];
                }
                break;
            }
        }
        
    }
    
    [arrResult sortUsingComparator:^NSComparisonResult(LyChapter * _Nonnull obj1, LyChapter * _Nonnull obj2) {
        if ( [obj1 chapterMode] < [obj2 chapterMode])
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

- (LyChapter *)getChapterWithChapterId:(NSString *)chapterId
{
    return [container objectForKey:chapterId];
}


- (void)removeAllChapter:(LyChapterUseMode)chapterMode
{
    if ( 0 == chapterMode)
    {
        [container removeAllObjects];
    }
    else
    {
        NSEnumerator *enumerator = [container keyEnumerator];
        NSString *itemKey;
        
        while ( itemKey = [enumerator nextObject]) {
            LyChapter *chapter = [container objectForKey:itemKey];
            if ( chapterMode == LyChapterUseMode_chapter)
            {
                if ( [chapter chapterMode] < 99)
                {
                    [container objectForKey:itemKey];
                }
            }
            else if ( chapterMode == LyChapterUseMode_myLibrary)
            {
                if ( [chapter chapterMode] > 99)
                {
                    [container objectForKey:itemKey];
                }
            }
        }
    }
}


@end
