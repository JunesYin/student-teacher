//
//  LyWeekdaySpanPicker.h
//  teacher
//
//  Created by Junes on 2016/9/24.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LyUtil.h"


@protocol LyWeekdaySpanPickerDelegate;

@interface LyWeekdaySpanPicker : UIView

@property (weak, nonatomic)     id<LyWeekdaySpanPickerDelegate>     delegate;

@property (assign, nonatomic)   LyWeekdaySpan       weekdaySpan;

- (void)show;

- (void)hide;

@end


@protocol LyWeekdaySpanPickerDelegate <NSObject>

@optional
- (void)onCancelByWeekdaySpanPicker:(LyWeekdaySpanPicker *)aPicker;

@required
- (void)onDoneByByWeekdaySpanPicker:(LyWeekdaySpanPicker *)aPicker weekdaySpan:(LyWeekdaySpan)weekdaySpan;

@end
