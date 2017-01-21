//
//  LyLoginViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/16.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LyLoginViewControllerDelegate;

@interface LyLoginViewController : UIViewController

@property (weak, nonatomic)     id<LyLoginViewControllerDelegate>       delegate;

@end


@protocol LyLoginViewControllerDelegate <NSObject>

@optional
- (void)loginDoneByLoginViewController:(LyLoginViewController *)aLoginVC;

@end


