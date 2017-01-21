//
//  LyForgotPasswordViewController.h
//  teacher
//
//  Created by Junes on 16/9/18.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyUtil.h"


@protocol LyForgotPasswordViewControllerDelegate;

@interface LyForgotPasswordViewController : UIViewController

@property (weak, nonatomic)     id<LyForgotPasswordViewControllerDelegate>      delegate;

@property (assign, nonatomic)   LyUserType      userType;

@end


@protocol LyForgotPasswordViewControllerDelegate <NSObject>

@required
- (LyUserType)obtainUserTypeByForgotPasswordVC:(LyForgotPasswordViewController *)forgotPasswordVC;

- (void)resetPasswordSuccessByForgotPasswordVC:(LyForgotPasswordViewController *)forgotPasswordVC newPwd:(NSString *)newPwd;

@end
