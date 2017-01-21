//
//  LyTrainModePicker.h
//  teacher
//
//  Created by Junes on 16/8/8.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyUtil.h"

@class LyTrainModePicker;


@protocol LyTrainModePickerDelegate <NSObject>

@optional
- (void)onCancelByTrainModePicker:(LyTrainModePicker *)aTrainModePicker;

- (void)onDoneByTrainModePicker:(LyTrainModePicker *)aTrainModePicker trainMode:(LyTrainClassTrainMode)aTrainMode;

@end


@interface LyTrainModePicker : UIView

@property (weak, nonatomic)         id<LyTrainModePickerDelegate>       delegate;

@property (assign, nonatomic)       LyTrainClassTrainMode               trainMode;

- (void)setTrainModeByString:(NSString *)trainMode;

- (void)setTrainMode:(LyTrainClassTrainMode)trainMode;

- (void)show;

- (void)hide;


@end
