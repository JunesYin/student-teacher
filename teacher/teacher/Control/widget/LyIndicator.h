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

+ (instancetype)indicatorWithTitle:(nullable NSString *)title allowCancel:(BOOL)forbidCancel;

- (instancetype)initWithTitle:(nullable NSString *)title;

- (instancetype)initWithTitle:(nullable NSString *)title allowCancel:(BOOL)forbidCancel;

- (BOOL)isAnimating;

- (void)startInView:(UIView *)view NS_DEPRECATED_IOS(2_0, 8_0, "Please use startAnimating") NS_EXTENSION_UNAVAILABLE_IOS("startAnimating");

- (void)startAnimation;

- (void)stopAnimation;

- (void)start NS_DEPRECATED_IOS(2_0, 8_0, "Please use startAnimating") NS_EXTENSION_UNAVAILABLE_IOS("startAnimating");

- (void)stop NS_DEPRECATED_IOS(2_0, 8_0, "Please use stopAnimating") NS_EXTENSION_UNAVAILABLE_IOS("stopAnimating");

@end


NS_ASSUME_NONNULL_END
