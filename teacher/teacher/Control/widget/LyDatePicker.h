//
//  LyDatePicker.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/1.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LyDatePickerDelegate;


@interface LyDatePicker : UIView


@property (weak, nonatomic)         id<LyDatePickerDelegate>            delegate;
@property (retain, nonatomic)       NSDate      *date;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode;

- (void)setLocale:(NSLocale *)locale;

- (void)setMinimunDate:(NSDate *)minimunDate;

- (void)setMaximumDate:(NSDate *)maximumDate;

- (void)setDate:(NSDate *)date;

- (void)setDateWithString:(NSString *)strDate;

- (void)show;

- (void)hide;



@end



@protocol LyDatePickerDelegate <NSObject>

@required
- (void)onBtnDoneClick:(NSDate *)date datePicker:(LyDatePicker *)aDatePicker;


@optional
- (void)onBtnCancelClickBydatePicker:(LyDatePicker *)aDatePicker;


@end
