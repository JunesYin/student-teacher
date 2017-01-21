//
//  LyChapterTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/11.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>



UIKIT_EXTERN CGFloat const chaptcHeight;


@class LyChapter;



typedef NS_ENUM( NSInteger, LyChapterTableViewCellMode)
{
    LyChapterTableViewCellMode_chapter,
    LyChapterTableViewCellMode_myMistake,
    LyChapterTableViewCellMode_myLibrary
};


@interface LyChapterTableViewCell : UITableViewCell


@property ( retain, nonatomic)          LyChapter           *chapter;

@property ( assign, nonatomic)          LyChapterTableViewCellMode mode;


//章节练习用
- (void)setCellInfoWithMode:(LyChapterTableViewCellMode)mode chapter:(LyChapter *)chapter;


//我的题库和我的错题用
- (void)setCellTitleWithMode:(LyChapterTableViewCellMode)mode title:(NSString *)title allCount:(NSInteger)allCount andIndex:(NSInteger)index;


@end
