//
//  LyCarPicker.h
//  teacher
//
//  Created by Junes on 16/8/5.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>



@class LyCarPicker;


@protocol LyCarPickerDelegate <NSObject>

@optional
- (void)onCancelByCarPicker:(LyCarPicker *)aCarPicker;

- (void)onDoneByCarPicker:(LyCarPicker *)aCarPicker car:(NSString *)aCar;

@end



@interface LyCarPicker : UIView

@property (retain, nonatomic)           NSString                        *car;

@property (weak, nonatomic)             id<LyCarPickerDelegate>         delegate;

- (void)setCar:(NSString *)car;

- (void)show;

- (void)hide;

@end
