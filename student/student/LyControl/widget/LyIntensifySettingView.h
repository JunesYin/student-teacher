//
//  LyIntensifySettingView.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/16.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM( NSInteger, LyIntensifySettingViewMode)
{
    LyIntensifySettingViewMode_intensify,
    LyIntensifySettingViewMode_myMistake
};


@class LyIntensifySettingView;

@protocol LyIntensifySettingViewDelegate <NSObject>

@required
- (void)onDoneIntensifySettingView:(LyIntensifySettingView *)settingview andFlagAuto:(BOOL)flagAuto;

@end


@interface LyIntensifySettingView : UIView


@property ( assign, nonatomic, readonly)    LyIntensifySettingViewMode      mode;
@property ( assign, nonatomic, readonly)    BOOL                            flagAuto;

@property ( assign, nonatomic)      id<LyIntensifySettingViewDelegate>      delegate;

+ (instancetype)settingViewWithMode:(LyIntensifySettingViewMode)mode;

- (instancetype)initWithMode:(LyIntensifySettingViewMode)mode;

- (void)show;

- (void)hide;

@end
