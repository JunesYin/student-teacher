//
//  LyChapterManager.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/21.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LySingleInstance.h"
#import "LyUtil.h"

#import "LyChapter.h"

typedef NS_ENUM( NSInteger, LyChapterUseMode)
{
    LyChapterUseMode_chapter = 1,
    LyChapterUseMode_myLibrary
};


@interface LyChapterManager : NSObject

lySingle_interface

- (void)addChapter:(LyChapter *)chapter;

- (NSArray *)getAllChapterWithUsedMode:(LyChapterUseMode)userMode subjectMode:(LySubjectMode)subjectMode;

- (LyChapter *)getChapterWithChapterId:(NSString *)chapterId;

- (void)removeAllChapter:(LyChapterUseMode)chapterMode;


@end
