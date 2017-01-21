//
//  LyIndicator.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/27.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LyIndicator;


NS_ASSUME_NONNULL_BEGIN


@protocol LyIndicatorDelegate <NSObject>

@optional
- (void)onDidStartIndicator:(LyIndicator *)indicator;

- (void)onDidStopIndicator:(LyIndicator *)indicator;

@end



@interface LyIndicator : UIView

@property ( strong, nonatomic, readonly)    UIActivityIndicatorView     *indicator;
@property ( strong, nonatomic)              NSString                    *title;
@property ( assign, nonatomic)        id<LyIndicatorDelegate>             delegate;

@property ( assign, nonatomic, getter=isAllowCancel)      BOOL          allowCancel;

+ (instancetype)indicatorWithTitle:(nullable NSString *)title;

+ (instancetype)indicatorWithTitle:(NSString *)title allowCancel:(BOOL)forbidCancel;

- (instancetype)initWithTitle:(NSString *)title;

- (instancetype)initWithTitle:(NSString *)title allowCancel:(BOOL)forbidCancel;

- (BOOL)isAnimating;

- (void)startAnimationInView:(UIView *)view;

- (void)startAnimation;

- (void)stopAnimation;


@end



NS_ASSUME_NONNULL_END
