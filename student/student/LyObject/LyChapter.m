//
//  LyChapter.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/21.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyChapter.h"

#pragma mark -LyChapter



@implementation LyChapter

+ (instancetype)chapterWithMode:(NSInteger)mode
                    chapterName:(NSString *)name
                     chapterNum:(NSInteger)num
                            tid:(NSInteger)tid
                          index:(NSInteger)index
{
    LyChapter *tmpChapter = [[LyChapter alloc] initWithMode:mode
                                                chapterName:name
                                                 chapterNum:num
                                                        tid:tid
                                                      index:index];
    return tmpChapter;
}

- (instancetype)initWithMode:(NSInteger)mode
                 chapterName:(NSString *)name
                  chapterNum:(NSInteger)num
                         tid:(NSInteger)tid
                       index:(NSInteger)index
{
    if ( self = [super init])
    {
        _chapterMode = mode;
        _chapterName = name;
        _chapterNum = num;
        _tid = tid;
        _index = index;
    }
    
    return self;
}

@end
