//
//  LySubjectPracPicker.h
//  teacher
//
//  Created by Junes on 2016/9/24.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LyUtil.h"


@protocol LySubjectPracPickerDelegate;

@interface LySubjectPracPicker : UIView

@property (weak, nonatomic)     id<LySubjectPracPickerDelegate>     delegate;

@property (assign, nonatomic)   LySubjectModeprac       subject;

- (void)show;

- (void)hide;

@end


@protocol LySubjectPracPickerDelegate <NSObject>

@required
- (void)onCancelBySubjectPracPicker:(LySubjectPracPicker *)aPicker;

- (void)onDoneBySubjectPracPicker:(LySubjectPracPicker *)aPicker subject:(LySubjectModeprac)subject;

@end
