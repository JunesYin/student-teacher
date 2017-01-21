//
//  LySortModePicker.h
//  student
//
//  Created by Junes on 2016/11/8.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyUtil.h"


@protocol LySortModePickerDelegate;

@interface LySortModePicker : UIView

@property (weak, nonatomic)     id<LySortModePickerDelegate>    delegate;

@property (assign, nonatomic)   LySortMode                      sortMode;

- (void)show;

- (void)hide;

@end


@protocol LySortModePickerDelegate <NSObject>

@required
- (void)onDoneBySortModePicker:(LySortModePicker *)aPicker sortMode:(LySortMode)aSortMode;

@optional
- (void)onCancelBySortModePicker:(LySortModePicker *)aPicker;

@end
