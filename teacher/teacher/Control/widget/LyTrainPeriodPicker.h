//
//  LyTrainPeriodPicker.h
//  teacher
//
//  Created by Junes on 16/8/8.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyUtil.h"


@class LyTrainPeriodPicker;

@protocol LyTrainPeriodPickerDelegate <NSObject>

@optional
- (void)onCancenByTrainPeriodPicker:(LyTrainPeriodPicker *)aTrainPeriodPicker;

- (void)onDoneByTrainPeriodPicker:(LyTrainPeriodPicker *)aTrainPeriodPicker trainPeriod:(LyTrainClassObjectPeriod)aTrainPeriod;

@end


@interface LyTrainPeriodPicker : UIView

@property (weak, nonatomic)         id<LyTrainPeriodPickerDelegate>         delegate;

@property (assign, nonatomic)       LyTrainClassObjectPeriod         trainPeriod;



- (void)setTrainPeriod:(LyTrainClassObjectPeriod)trainPeriod;

- (void)show;

- (void)hide;


@end
