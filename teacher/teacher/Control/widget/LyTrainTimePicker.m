//
//  LyTrainTimePicker.m
//  teacher
//
//  Created by Junes on 16/8/8.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyTrainTimePicker.h"

#import "LyUtil.h"

#import "UIPickerView+clearSpearator.h"

@interface LyTrainTimePicker () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIButton                    *btnMask;
    
    UIView                      *viewUseful;
    UIToolbar                   *toolBar;
    
    
    UILabel                     *lbTitle_begin;
    UILabel                     *lbTitle_end;
    UIPickerView                *picker;
    
    CGPoint                     centerViewUseful;
}
@end


@implementation LyTrainTimePicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)init
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        [self initAndLayoutSubviews];
    }
    
    return self;
}



- (void)initAndLayoutSubviews
{
    btnMask = [[UIButton alloc] initWithFrame:self.bounds];
    [btnMask setBackgroundColor:LyMaskColor];
    [btnMask addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnMask];
    
    
    viewUseful = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-controlViewUsefulHeight, SCREEN_HEIGHT, controlViewUsefulHeight)];
    [viewUseful setBackgroundColor:LyWhiteLightgrayColor];
    centerViewUseful = viewUseful.center;
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(horizontalSpace, 0, SCREEN_WIDTH-horizontalSpace*2, controlToolBarHeight)];
    [toolBar setTintColor:Ly517ThemeColor];
    UIBarButtonItem *bbiCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(targetForBarButtonItem:)];
    [bbiCancel setTag:LyControlBarButtonItemMode_cancel];
    UIBarButtonItem *bbiSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bbiDone = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(targetForBarButtonItem:)];
    [bbiDone setTag:LyControlBarButtonItemMode_done];
    [toolBar setItems:@[bbiCancel,bbiSpace,bbiDone]];
    
    
    lbTitle_begin = [[UILabel alloc] initWithFrame:CGRectMake(0, controlToolBarHeight, SCREEN_WIDTH/2.0f, 30.0f)];
    [lbTitle_begin setFont:LyFont(14)];
    [lbTitle_begin setTextColor:[UIColor darkGrayColor]];
    [lbTitle_begin setText:@"开始时间"];
    [lbTitle_begin setTextAlignment:NSTextAlignmentCenter];
    
    lbTitle_end = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f, controlToolBarHeight, SCREEN_WIDTH/2.0f, 30.0f)];
    [lbTitle_end setFont:LyFont(14)];
    [lbTitle_end setTextColor:[UIColor darkGrayColor]];
    [lbTitle_end setText:@"结束时间"];
    [lbTitle_end setTextAlignment:NSTextAlignmentCenter];
    
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, controlToolBarHeight+30, SCREEN_WIDTH, controlPickerHeight-30.0f)];
    [picker setDelegate:self];
    [picker setDataSource:self];
//    [picker setShowsSelectionIndicator:YES];
    
    [viewUseful addSubview:toolBar];
    [viewUseful addSubview:lbTitle_begin];
    [viewUseful addSubview:lbTitle_end];
    [viewUseful addSubview:picker];
    
    [self addSubview:viewUseful];
    
}


//- (void)setTrainTimeInfo:(NSInteger)trainTimeBegin trainTimeEnd:(NSInteger)trainTimeEnd
//{
//    if (trainTimeBegin >= 0 && trainTimeBegin < 24 )
//    {
//        [picker selectRow:trainTimeBegin inComponent:0 animated:NO];
//    }
//    
//    if (trainTimeEnd >= 0 && trainTimeEnd < 24 && trainTimeEnd > trainTimeBegin)
//    {
//        [picker selectRow:trainTimeEnd inComponent:1 animated:NO];
//    }
//}

- (void)setTrainTimeBucket:(LyTimeBucket)trainTimeBucket
{
    if (trainTimeBucket.begin >= 0 && trainTimeBucket.begin < 24 )
    {
        [picker selectRow:trainTimeBucket.begin inComponent:0 animated:NO];
    }
    
    if (trainTimeBucket.end >= 0 && trainTimeBucket.end < 24 && trainTimeBucket.end > trainTimeBucket.begin)
    {
        [picker selectRow:trainTimeBucket.end inComponent:1 animated:NO];
    }
}



- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [LyUtil startAnimationWithView:viewUseful
                                  animationDuration:0.3f
                                       initialPoint:CGPointMake( centerViewUseful.x, centerViewUseful.y+CGRectGetHeight(viewUseful.frame))
                                   destinationPoint:centerViewUseful
                                         completion:^(BOOL finished) {
                                             ;
                                         }];
    
    [LyUtil startAnimationWithView:btnMask
                                  animationDuration:0.3
                                          initAlpha:0.0f
                                  destinationAplhas:1.0f
                                          comletion:^(BOOL finished) {
                                          }];
}



- (void)hide
{
    [LyUtil startAnimationWithView:viewUseful
                                  animationDuration:0.3f
                                       initialPoint:centerViewUseful
                                   destinationPoint:CGPointMake( centerViewUseful.x, centerViewUseful.y+CGRectGetHeight(viewUseful.frame))
                                         completion:^(BOOL finished) {
                                             ;
                                         }];
    
    
    [LyUtil startAnimationWithView:btnMask
                                  animationDuration:0.3
                                          initAlpha:1.0f
                                  destinationAplhas:0.0f
                                          comletion:^(BOOL finished) {
                                              [self removeFromSuperview];
                                              
                                              [viewUseful setCenter:centerViewUseful];
                                              [btnMask setAlpha:1.0f];
                                          }];
}



- (void)targetForButton:(UIButton *)button
{
    if (button == btnMask)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(onCancelByTrainTimePicker:)])
        {
            [_delegate onCancelByTrainTimePicker:self];
        }
        else
        {
            [self hide];
        }
    }
}

- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi
{
    if (LyControlBarButtonItemMode_cancel == bbi.tag)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(onCancelByTrainTimePicker:)])
        {
            [_delegate onCancelByTrainTimePicker:self];
        }
        else
        {
            [self hide];
        }
    }
    else if (LyControlBarButtonItemMode_done == bbi.tag)
    {
        _trainTimeBucket.begin = [picker selectedRowInComponent:0];
        _trainTimeBucket.end = _trainTimeBucket.begin + [picker selectedRowInComponent:1]+1;
        
        [_delegate onDoneByTrainTimePicker:self trainTimeBucket:_trainTimeBucket];
    }
}



#pragma mark -UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lbRow;
    if ([view isKindOfClass:[UILabel class]])
    {
        lbRow = (UILabel *)lbRow;
    }
    else
    {
        lbRow = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / [picker numberOfComponents], controlPickerRowHeight)];
        [lbRow setFont:controlPickerRowTitleFont];
        [lbRow setTextAlignment:NSTextAlignmentCenter];
    }
    
    if (0 == component)
    {
        [lbRow setText:[[NSString alloc] initWithFormat:@"%ld:00", row]];
    }
    else if (1 == component)
    {
        [lbRow setText:[[NSString alloc] initWithFormat:@"%ld:00", row+[picker selectedRowInComponent:0]+1]];
    }
    [picker clearSpearator];
    
    return lbRow;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return controlPickerRowHeight;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (0 == component)
    {
        [picker reloadComponent:1];
    }
}


#pragma mark -UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (0 == component)
    {
        return 24;
    }
    else if (1 == component)
    {
        return 24-[picker selectedRowInComponent:0];
    }
    
    return 0;
}



@end
