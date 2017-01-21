//
//  LyForgotPasswordView.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/10.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>



@class LyForgotPasswordView;

@protocol LyForgotPasswordViewDelegate <NSObject>

@optional
- (void)onForgotPasswordCancel:(LyForgotPasswordView *)view;

- (void)onForgotPasswordFailed:(LyForgotPasswordView *)view;

- (void)onForgotPasswordDone:(LyForgotPasswordView *)view andNewPassword:(NSString *)newPassword andPhoneNum:(NSString *)phoneNum;


@end



@interface LyForgotPasswordView : UIView

@property ( assign, nonatomic)      id<LyForgotPasswordViewDelegate>            delegate;

- (void)setPhoneNum:(NSString *)phoneNum;

- (void)show;

- (void)showInView:(UIView *)view;

- (void)hide;


@end
