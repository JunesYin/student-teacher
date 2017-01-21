//
//  LyTrainBasePicker.h
//  student
//
//  Created by Junes on 16/9/13.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LyTrainBase;
@protocol LyTrainBasePickerDelegate;


@interface LyTrainBasePicker : UIView

@property (weak, nonatomic)         id<LyTrainBasePickerDelegate>       delegate;
@property ( strong, nonatomic)      NSArray         *arrTrainBase;


@property ( retain, nonatomic)      LyTrainBase                 *trainBase;


- (instancetype)initWithTrainBase:(NSArray *)arrTrainBase;

- (void)setTrainBase:(LyTrainBase *)trainBase;

- (void)showWithTrainBase:(LyTrainBase *)trainBase;

- (void)showWithInfoString:(NSString *)infoString;

- (void)show;

- (void)hide;

@end



@protocol LyTrainBasePickerDelegate <NSObject>

- (void)onCancelByTrainBasePicker:(LyTrainBasePicker *)aTrainBasePicker;

- (void)onDoneByaTrainBasePicker:(LyTrainBasePicker *)aTrainBasePicker trainBase:(LyTrainBase *)trainBase;

@end
