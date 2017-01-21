//
//  LyRemindView.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/27.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN NSTimeInterval const LyRemindViewDelayTime;


typedef NS_ENUM( NSInteger, LyRemindViewMode)
{
    LyRemindViewMode_success,
    LyRemindViewMode_fail,
    LyRemindViewMode_warn
};


@class LyRemindView;


@protocol LyRemindViewDelegate <NSObject>

@optional
- (void)remindViewWillHide:(LyRemindView *)aRemind;
- (void)remindViewDidHide:(LyRemindView *)aRemind;

@end


@interface LyRemindView : UIView

@property ( strong, nonatomic, readonly)        NSString                        *title;
@property ( assign, nonatomic, readonly)        LyRemindViewMode                mode;

@property ( weak, nonatomic)                    id<LyRemindViewDelegate>         delegate;


+ (instancetype)remindWithMode:(LyRemindViewMode)mode withTitle:(NSString *)title;

- (void)show;

- (void)showRightNow;

- (void)showWithTime:(NSNumber *)duration;

- (void)showRightNowWithTime:(NSTimeInterval)duration;

@end
