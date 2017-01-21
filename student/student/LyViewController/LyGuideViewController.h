//
//  LyGuideViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/16.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LyGuideViewControllerDelegate;

@interface LyGuideViewController : UIViewController

@property ( weak, nonatomic)                id<LyGuideViewControllerDelegate>   delegate;

@end



@protocol LyGuideViewControllerDelegate <NSObject>

@required
- (void)onClickButtonStart:(LyGuideViewController *)aGuideVC;

@end
