//
//  LyChapterExeciseLocalViewController.h
//  student
//
//  Created by MacMini on 2016/12/9.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LyChapter;
@protocol LyChapterExeciseLocalViewControllerDelegate;

@interface LyChapterExeciseLocalViewController : UIViewController

@property (weak, nonatomic)     id<LyChapterExeciseLocalViewControllerDelegate>     delegate;

@property (retain, nonatomic)       LyChapter       *chapter;

@end

@protocol LyChapterExeciseLocalViewControllerDelegate <NSObject>

@required
- (LyChapter *)chapterOfChapterExeciseLocalViewController:(LyChapterExeciseLocalViewController *)aChapterExeciseLocalVC;

@end
