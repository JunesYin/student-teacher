//
//  LyModifyPhoneNumerView.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/4.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LyModifyPhoneNumerView;

@protocol LyModifyPhoneNumberViewDelegate <NSObject>

@optional
- (void)onClickButtonClose:(LyModifyPhoneNumerView *)view;

- (void)onModifyFinished:(LyModifyPhoneNumerView *)view newPhoneNumber:(NSString *)newPhoneNumber;


@end


@interface LyModifyPhoneNumerView : UIView


@property (weak, nonatomic)        id<LyModifyPhoneNumberViewDelegate>         delegate;

- (void)show;

- (void)hide;

@end
