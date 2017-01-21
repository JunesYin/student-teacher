//
//  LyTrainTimePicker.h
//  teacher
//
//  Created by Junes on 16/8/8.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyUtil.h"

@class LyTrainTimePicker;


@protocol LyTrainTimePickerDelegate <NSObject>

@optional
- (void)onCancelByTrainTimePicker:(LyTrainTimePicker *)aTrainTimePicker;

- (void)onDoneByTrainTimePicker:(LyTrainTimePicker *)aTrainTimePicker trainTimeBucket:(LyTimeBucket)aTrainTimeBucket;

@end

@interface LyTrainTimePicker : UIView


@property (weak, nonatomic)         id<LyTrainTimePickerDelegate>       delegate;

@property (assign, nonatomic)         LyTimeBucket         trainTimeBucket;


//- (void)setTrainTimeInfo:(NSInteger)trainTimeBegin trainTimeEnd:(NSInteger)trainTimeEnd;

- (void)show;

- (void)hide;


@end
