//
//  LyDateTimePicker.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/19.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyUtil.h"

#import "LyDateTimeInfo.h"


#define dtVerticalMargin                            7.0f


#define cvDateHeight                                50.0f

#define cvTimeItemHeight                            40.0f


#define dateTimePickerDefaultWidth                  SCREEN_WIDTH
#define dateTimePickerDefaultHeight                 (cvDateHeight+cvTimeItemHeight*8+dtVerticalMargin*10)


@class LyDateTimePicker;

@protocol LyDateTimePickerDelegate <NSObject>

@optional
- (void)onReloadDataFailed:(LyDateTimePicker *)aDateTimePicker strData:(NSString *)strData;

- (void)onReloadDataFinished:(LyDateTimePicker *)aDateTimePicker;

- (void)dateTimePicker:(LyDateTimePicker *)aDateTimePicker didSelectDateItemAtIndex:(NSInteger)index andDate:(NSDate *)date;

- (void)dateTimePicker:(LyDateTimePicker *)aDateTimePicker didSelectTimeItemAtIndex:(NSInteger)index andDate:(NSDate *)date andWeekday:(LyWeekday)weekday;
@end



@protocol LyDateTimePickerDataSource <NSObject>

- (NSDate *)dateInDateTimePicker:(LyDateTimePicker *)aDateTimePicker;

- (LyDateTimeInfo *)dateTimePicker:(LyDateTimePicker *)aDateTimePicker forItemIndex:(NSInteger)index;

@end








@interface LyDateTimePicker : UIView

@property ( strong, nonatomic)      NSDate                          *date;
//@property ( strong, nonatomic)      NSString                        *weekday;
@property ( assign, nonatomic)      LyWeekday                       weekday;

@property ( weak, nonatomic)        id<LyDateTimePickerDelegate>     delegate;
@property ( weak, nonatomic)        id<LyDateTimePickerDataSource>   dataSource;

- (void)setSelectIndex:(NSInteger)index;

- (void)reloadData;


- (void)reloadData:(NSString *)strData;

@end
