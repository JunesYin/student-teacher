//
//  LyTrainClassTimePicker.h
//  teacher
//
//  Created by Junes on 16/8/5.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LyTrainClassTimePicker;


@protocol LyTrainClassTimePickerDelegate <NSObject>

@optional
- (void)onCancelByTrainClassTimePicker:(LyTrainClassTimePicker *)aTrainClassPicker;

- (void)onDoneByTrainClassTimePicker:(LyTrainClassTimePicker *)aTrainClassPicker trainClassTime:(NSString *)aTranClassTime;

@end


@interface LyTrainClassTimePicker : UIView

@property (retain, nonatomic)       NSString                                *trainClassTime;

@property (weak, nonatomic)         id<LyTrainClassTimePickerDelegate>      delegate;

- (void)setTrainClassTime:(NSString *)trainClassTime;

- (void)show;

- (void)hide;


@end
