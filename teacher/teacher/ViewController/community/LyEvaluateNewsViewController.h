//
//  LyEvaluateNewsViewController.h
//  teacher
//
//  Created by Junes on 2016/10/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LyNews;

@protocol LyEvaluateNewsViewControllerDelegate;

@interface LyEvaluateNewsViewController : UIViewController

@property ( assign, nonatomic)  id<LyEvaluateNewsViewControllerDelegate>    delegate;

@property ( retain, nonatomic)  LyNews      *news;

@property ( strong, nonatomic)  NSString    *content;

@end


@protocol LyEvaluateNewsViewControllerDelegate <NSObject>

- (LyNews *)obtainNewsByEvaluateNewsVC:(LyEvaluateNewsViewController *)aEvaluateNewsVC;

- (void)onDoneByEvaluateNewsVC:(LyEvaluateNewsViewController *)aEvaluateNewsVC;

@end
