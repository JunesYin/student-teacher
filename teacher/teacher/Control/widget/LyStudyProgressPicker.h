//
//  LyStudyProgressPicker.h
//  teacher
//
//  Created by Junes on 16/8/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LyUtil.h"

@protocol LyStudyProgressPickerDelegate;

@interface LyStudyProgressPicker : UIView

@property (weak, nonatomic)         id<LyStudyProgressPickerDelegate>       delegate;

@property (assign, nonatomic)       NSInteger                               curIndex;

- (void)show;

- (void)hide;

@end


@protocol LyStudyProgressPickerDelegate <NSObject>

@optional
- (void)onCancelByStudyProgressPicker:(LyStudyProgressPicker *)aStudyProgressPicker;

- (void)onDoneByStudyProgressPicker:(LyStudyProgressPicker *)aStudyProgressPicker studyProgress:(LySubjectMode)aStudyProgress;

@end
