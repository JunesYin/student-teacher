//
//  LyResetPasswordViewController.h
//  teacher
//
//  Created by Junes on 16/9/18.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyUtil.h"


@protocol LyResetPasswordViewControllerDelegate;


@interface LyResetPasswordViewController : UIViewController

@property (weak, nonatomic)     id<LyResetPasswordViewControllerDelegate>       delegate;

@property (strong, nonatomic)   NSString            *curAcc;
@property (assign, nonatomic)   LyUserType          userType;

@end


@protocol LyResetPasswordViewControllerDelegate <NSObject>

@required
- (NSDictionary *)obtainAccountInfoByResetPasswordVC:(LyResetPasswordViewController *)resetPasswordVC;

- (void)resetPasswordSuccessByResetPasswordVC:(LyResetPasswordViewController *)resetPasswordVC newPwd:(NSString *)newPwd;

@end
