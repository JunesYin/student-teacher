//
//  LyPayInfoPicker.h
//  teacher
//
//  Created by Junes on 16/8/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LyUtil.h"


@protocol LyPayInfoPickerDelegate;

@interface LyPayInfoPicker : UIView

@property (weak, nonatomic)     id<LyPayInfoPickerDelegate>         delegate;

@property (assign, nonatomic)   LyPayInfo                           payInfo;

- (void)show;

- (void)hide;

@end



@protocol LyPayInfoPickerDelegate <NSObject>

@optional
- (void)onCancenByPayInfoPicker:(LyPayInfoPicker *)aPayInfoPicker;

- (void)onDoneByPayInfoPicker:(LyPayInfoPicker *)aPayInfoPicker payInfo:(LyPayInfo)aPayInfo;

@end
