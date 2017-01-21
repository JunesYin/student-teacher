//
//  LyResetPhoneViewController.h
//  teacher
//
//  Created by Junes on 2016/9/29.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LyResetPhoneViewControllerDelegate;


@interface LyResetPhoneViewController : UIViewController

@property (weak, nonatomic)         id<LyResetPhoneViewControllerDelegate>      delegate;

@end


@protocol LyResetPhoneViewControllerDelegate <NSObject>

@optional
- (void)onDoneByResetPhoneVC:(LyResetPhoneViewController *)aResetPhoneVC;

@end
