//
//  LyDateView.m
//  teacher
//
//  Created by Junes on 16/8/15.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyDateView.h"

#import "LyDatePicker.h"

#import "LyUtil.h"



CGFloat const LyDateViewHeight = 50.0f;

CGFloat const dLbTitleWidth = 70.0f;

CGFloat const lbToWidth = 20.0f;

#define btnItemWidth                    ((SCREEN_WIDTH-horizontalSpace*2-verticalSpace*3-dLbTitleWidth-lbToWidth)/2)
CGFloat const dBtnItemHeight = 35.0f;


typedef NS_ENUM(NSInteger, LyDateViewButtonMode)
{
    dateViewButtonMode_start = 1,
    dateViewButtonMode_end
};

typedef NS_ENUM(NSInteger, LyDateViewDatePickerMode)
{
    dateViewDatePickerMode_start = 10,
    dateViewDatePickerMode_end
};

@interface LyDateView () <LyDatePickerDelegate>
{
    UILabel                 *lbTitle;
    
    UIButton                *btnTimeStart;
    
    UILabel                 *lbTo;
    
    UIButton                *btnTimeEnd;
    
}
@end


@implementation LyDateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//static NSDate *minDate = nil;
//static NSDate

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, SCREEN_WIDTH, LyDateViewHeight)])
    {
        [self initAndLayoutSubviews];
    }
    
    return self;
}


- (void)initAndLayoutSubviews
{
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, dLbTitleWidth, LyDateViewHeight)];
    [lbTitle setFont:LyFont(14)];
    [lbTitle setTextColor:LyBlackColor];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    [lbTitle setText:@"交易时间"];
    
    btnTimeStart = [[UIButton alloc] initWithFrame:CGRectMake(lbTitle.frame.origin.x+CGRectGetWidth(lbTitle.frame)+verticalSpace, LyDateViewHeight/2.0f-dBtnItemHeight/2.0f, btnItemWidth, dBtnItemHeight)];
    [btnTimeStart setTag:dateViewButtonMode_start];
    [btnTimeStart.titleLabel setFont:LyFont(14)];
    [btnTimeStart setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnTimeStart setTitle:@"起始时间" forState:UIControlStateNormal];
//    [btnTimeStart setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [btnTimeStart.layer setCornerRadius:5.0f];
    [btnTimeStart.layer setBorderWidth:1.0f];
    [btnTimeStart.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [btnTimeStart setClipsToBounds:YES];
    [btnTimeStart addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    lbTo = [[UILabel alloc] initWithFrame:CGRectMake(btnTimeStart.frame.origin.x+CGRectGetWidth(btnTimeStart.frame)+verticalSpace, 0, lbToWidth, LyDateViewHeight)];
    [lbTo setFont:LyFont(14)];
    [lbTo setTextColor:LyBlackColor];
    [lbTo setTextAlignment:NSTextAlignmentCenter];
    [lbTo setText:@"-"];
    
    btnTimeEnd = [[UIButton alloc] initWithFrame:CGRectMake(lbTo.frame.origin.x+CGRectGetWidth(lbTo.frame)+verticalSpace, LyDateViewHeight/2.0f-dBtnItemHeight/2.0f, btnItemWidth, dBtnItemHeight)];
    [btnTimeEnd setTag:dateViewButtonMode_end];
    [btnTimeEnd.titleLabel setFont:LyFont(14)];
    [btnTimeEnd setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnTimeEnd setTitle:@"结束时间" forState:UIControlStateNormal];
//    [btnTimeEnd setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [btnTimeEnd.layer setCornerRadius:5.0f];
    [btnTimeEnd.layer setBorderWidth:1.0f];
    [btnTimeEnd.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [btnTimeEnd setClipsToBounds:YES];
    [btnTimeEnd addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:lbTitle];
    [self addSubview:btnTimeStart];
    [self addSubview:lbTo];
    [self addSubview:btnTimeEnd];
}


- (void)targetForButton:(UIButton *)button {
    
    if (button.isSelected) {
        [button setSelected:YES];
    }
    
    if (dateViewButtonMode_start == button.tag) {
        LyDatePicker *datePicker = [[LyDatePicker alloc] init];
        [datePicker setDelegate:self];
        [datePicker setTag:dateViewDatePickerMode_start];
        [datePicker setDate:_dateStart];
        
        [datePicker setMaximumDate:[NSDate date]];
        
        [datePicker show];
    } else if (dateViewButtonMode_end == button.tag) {
        LyDatePicker *datePicker = [[LyDatePicker alloc] init];
        [datePicker setDelegate:self];
        [datePicker setTag:dateViewDatePickerMode_end];
        [datePicker setDate:_dateEnd];
        
        [datePicker setMinimunDate:_dateStart];
        [datePicker setMaximumDate:[NSDate date]];
        
        [datePicker show];
    }
}


- (void)setDateStart:(NSDate *)dateStart {
    if (!dateStart) {
        return;
    }
    
    _dateStart = dateStart;
    [btnTimeStart setTitle:[[[LyUtil dateFormatterForAll] stringFromDate:_dateStart] substringToIndex:10] forState:UIControlStateNormal];
}


- (void)setDateEnd:(NSDate *)dateEnd {
    if (!dateEnd) {
        return;
    }
    
    _dateEnd = dateEnd;
    [btnTimeEnd setTitle:[[[LyUtil dateFormatterForAll] stringFromDate:_dateEnd] substringToIndex:10] forState:UIControlStateNormal];
}


#pragma mark -LyDatePicker
- (void)onBtnCancelClickBydatePicker:(LyDatePicker *)aDatePicker
{
    [aDatePicker hide];
}

- (void)onBtnDoneClick:(NSDate *)date datePicker:(LyDatePicker *)aDatePicker
{
    [aDatePicker hide];

    NSString *strDate = [[NSString alloc] initWithFormat:@"%@ 00:00:00 +0800", [[[LyUtil dateFormatterForAll] stringFromDate:date] substringToIndex:dateStringLength]];
    date = [[LyUtil dateFormatterForAll] dateFromString:strDate];
    
    if (dateViewDatePickerMode_start == aDatePicker.tag) {
        
        if (![date isEqual:_dateStart]) {
            [self setDateStart:date];
            
            if (_dateEnd) {
            [_delegate dateView:self dateStart:_dateStart dateEnd:_dateEnd];
            }
        }
    }
    else if (dateViewDatePickerMode_end == aDatePicker.tag) {
        
        if (![date isEqual:_dateEnd]) {
            [self setDateEnd:date];
            
            if (_dateStart) {
                [_delegate dateView:self dateStart:_dateStart dateEnd:_dateEnd];
            }
        }
    }
    
}


@end
