//
//  LyGuideViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/16.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LySingleInstance.h"



@class LyGuideViewController;

@protocol LyGuideViewControllerDelegate <NSObject>

@required
- (void)onClickButtonStartByGuideViewController:(LyGuideViewController *)aGuide;

@end


@interface LyGuideViewController : UIViewController

@property ( strong, nonatomic)              UIScrollView                        *geScrollView;
@property ( strong, nonatomic)              UIPageControl                       *gePageControl;

@property ( weak, nonatomic)                id<LyGuideViewControllerDelegate>   delegate;


@end
