//
//  LyNewsDetailViewController.h
//  teacher
//
//  Created by Junes on 2016/10/18.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LyNews;

@protocol LyNewsDetailViewControllerDelegate;

@interface LyNewsDetailViewController : UIViewController

@property (nonatomic, weak)     id<LyNewsDetailViewControllerDelegate>  delegate;

@property (nonatomic, retain)   LyNews        *news;

@end

@protocol LyNewsDetailViewControllerDelegate <NSObject>

@required
- (LyNews *)obtainNewsByNewsDetailVC:(LyNewsDetailViewController *)aNewsDetailVC;

- (void)onDeleteByNewsDetailVC:(LyNewsDetailViewController *)aNewsDetailVC;


@end
