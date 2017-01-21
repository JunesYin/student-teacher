//
//  LyModifyPhoneViewController.h
//  teacher
//
//  Created by Junes on 2016/9/29.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LyModifyPhoneViewControllerDelegate;

@interface LyModifyPhoneViewController : UIViewController

@property (weak, nonatomic)     id<LyModifyPhoneViewControllerDelegate>     delegate;

@end


@protocol LyModifyPhoneViewControllerDelegate <NSObject>

@optional
- (void)onDoneByModifyPhoneVC:(LyModifyPhoneViewController *)aModifyPhoneVC;

@end
