//
//  LyMyQueAnalysisLocalViewController.h
//  student
//
//  Created by MacMini on 2016/12/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LyChapter;
@protocol LyMyQueAnalysisLocalViewControllerDelegate;

@interface LyMyQueAnalysisLocalViewController : UIViewController

@property (weak, nonatomic)     id<LyMyQueAnalysisLocalViewControllerDelegate>      delegate;

@property (retain, nonatomic)     LyChapter       *chapter;

@end


@protocol LyMyQueAnalysisLocalViewControllerDelegate <NSObject>

@required
- (LyChapter *)chapterByMyQueAnalysisViewController:(LyMyQueAnalysisLocalViewController *)aMyQueAnalysisVC;

@end
