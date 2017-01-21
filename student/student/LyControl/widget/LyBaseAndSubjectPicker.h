//
//  LyBaseAndSubjectPicker.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/17.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyUtil.h"


@class LyTrainBase;
@class LyBaseAndSubjectPicker;

@protocol LyBaseAndSubjectPickerDelegate <NSObject>

- (void)onCancelByBaseAndSubjectPicker:(LyBaseAndSubjectPicker *)aPicker;

- (void)onDoneByBaseAndSubjectPicker:(LyBaseAndSubjectPicker *)aPicker andSubject:(LySubjectModeprac)subject andTrainBase:(LyTrainBase *)trainBaseId;

@end


@interface LyBaseAndSubjectPicker : UIView


@property ( assign, nonatomic)      LySubjectModeprac          subject;
@property ( retain, nonatomic)      LyTrainBase                 *trainBase;


@property ( weak, nonatomic)        id<LyBaseAndSubjectPickerDelegate>  delegate;

@property ( strong, nonatomic)      NSArray         *arrTrainBase;


- (instancetype)initWithTrainBase:(NSArray *)arrTrainBase;

- (void)setSubject:(LySubjectModeprac)subject andTrainBase:(LyTrainBase *)trainBase;

- (void)showWithSubject:(LySubjectModeprac)subject andTrainBase:(LyTrainBase *)trainBase;

- (void)showWithInfoString:(NSString *)infoString;

- (void)show;

- (void)hide;

@end
