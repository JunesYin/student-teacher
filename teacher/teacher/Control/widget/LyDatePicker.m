//
//  LyDatePicker.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/1.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyDatePicker.h"

#import "UIDatePicker+clearSpearator.h"
#import "LyUtil.h"




//#define btnBigWidth                                 SCREEN_WIDTH
//#define btnBigHeight                                (SCREEN_HEIGHT-viewUsefulHeight)

//#define viewUsefulWidth                             SCREEN_WIDTH
//CGFloat const viewUsefulHeight = 200.0f;


@interface LyDatePicker ()
{
    
    UIButton            *btnBig;
    
    UIView              *viewUseful;
    UIToolbar           *toolBar;
    
    UIDatePicker        *datePicker;
    
    CGPoint             viewUsefulCenter;
}
@end


@implementation LyDatePicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        [self initAndLayoutSubview];
    }
    
    return self;
}



- (instancetype)init
{
    if ( self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        [self initAndLayoutSubview];
    }
    
    return self;
}



- (void)initAndLayoutSubview
{
    btnBig = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [btnBig setBackgroundColor:LyMaskColor];
    [btnBig addTarget:self action:@selector(targetForBtnItemCancel) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    viewUseful = [[UIView alloc] initWithFrame:CGRectMake( 0, SCREEN_HEIGHT-controlViewUsefulHeight, SCREEN_WIDTH, controlViewUsefulHeight)];
    [viewUseful setBackgroundColor:LyWhiteLightgrayColor];
    viewUsefulCenter = viewUseful.center;
    
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake( verticalSpace, 0, SCREEN_WIDTH-verticalSpace*2, 40)];
    [toolBar setBackgroundColor:[UIColor clearColor]];
    [toolBar setTintColor:Ly517ThemeColor];
    UIBarButtonItem *btnItemCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(targetForBtnItemCancel)];
    UIBarButtonItem *btnItemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *btnItemDone = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(targetForBtnItemDone)];
    
    [toolBar setItems:@[btnItemCancel, btnItemSpace, btnItemDone]];
    
    
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake( 0, toolBar.ly_y+toolBar.frame.size.height+2, CGRectGetWidth(viewUseful.frame), CGRectGetHeight(viewUseful.frame)-CGRectGetHeight(toolBar.frame))];
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    NSDate *minDate = [[LyUtil dateFormatterForYMD] dateFromString:@"1949-10-01"];
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setLocale:LyChinaLocale];
    [datePicker setLocale:[NSLocale currentLocale]];
    [datePicker setMinimumDate:minDate];
    [datePicker setMaximumDate:[NSDate date]];
    [datePicker setDate:[NSDate date]];
    
    [datePicker clearSpearator];
    
    
    [viewUseful addSubview:toolBar];
    [viewUseful addSubview:datePicker];
    
    [self addSubview:btnBig];
    [self addSubview:viewUseful];
    
}



- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [LyUtil startAnimationWithView:viewUseful
                 animationDuration:LyAnimationDuration
                      initialPoint:CGPointMake( viewUsefulCenter.x, viewUsefulCenter.y+CGRectGetHeight(viewUseful.frame))
                  destinationPoint:viewUsefulCenter
                        completion:^(BOOL finished) {
                                         }];
    
    [LyUtil startAnimationWithView:btnBig
                 animationDuration:LyAnimationDuration
                         initAlpha:0.0f
                 destinationAplhas:1.0f
                         comletion:^(BOOL finished) {
                             ;
                         }];
}




- (void)hide
{
    
    [LyUtil startAnimationWithView:viewUseful
                                  animationDuration:LyAnimationDuration
                                       initialPoint:viewUsefulCenter
                                   destinationPoint:CGPointMake( viewUsefulCenter.x, viewUsefulCenter.y+CGRectGetHeight(viewUseful.frame))
                                         completion:^(BOOL finished) {
                                             [viewUseful setCenter:viewUsefulCenter];
                                         }];
    
    [LyUtil startAnimationWithView:btnBig
                                  animationDuration:LyAnimationDuration
                                          initAlpha:1.0f
                                  destinationAplhas:0.0f
                                          comletion:^(BOOL finished) {
                                              [self setHidden:YES];
                                              [btnBig setAlpha:1.0f];
                                              [self removeFromSuperview];
                                          }];
}



- (void)targetForBtnItemCancel
{
    [_delegate onBtnCancelClickBydatePicker:self];
}



- (void)targetForBtnItemDone
{
    [self setHidden:YES];
    [_delegate onBtnDoneClick:[datePicker date] datePicker:self];
}



- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
    [datePicker setDatePickerMode:datePickerMode];
}



- (void)setLocale:(NSLocale *)locale
{
    
    [datePicker setLocale:locale];
}



- (void)setMinimunDate:(NSDate *)minimunDate {
    if (!minimunDate) {
        return;
    }
    [datePicker setMinimumDate:minimunDate];
}


- (void)setMaximumDate:(NSDate *)maximumDate {
    if (!maximumDate) {
        return;
    }
    [datePicker setMaximumDate:maximumDate];
}


- (void)setDate:(NSDate *)date {
    if (!date) {
        return;
    }
    
    [datePicker setDate:date];
}


- (void)setDateWithString:(NSString *)strDate
{
    if ( !strDate)
    {
        return;
    }
    
    NSDate *date = [[LyUtil dateFormatterForYMD] dateFromString:strDate];
    
    if ( !date)
    {
        return;
    }
    [datePicker setDate:date];
}




@end
