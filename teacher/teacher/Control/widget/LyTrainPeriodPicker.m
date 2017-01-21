//
//  LyTrainPeriodPicker.m
//  teacher
//
//  Created by Junes on 16/8/8.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyTrainPeriodPicker.h"

#import "LyUtil.h"

#import "UIPickerView+clearSpearator.h"



@interface LyTrainPeriodPicker () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIButton                    *btnMask;
    
    UIView                      *viewUseful;
    UIToolbar                   *toolBar;
    
    
    UILabel                     *lbTitle_second;
    UILabel                     *lbTitle_third;
    UIPickerView                *picker;
    
    CGPoint                     centerViewUseful;
}
@end


@implementation LyTrainPeriodPicker

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
    
    
    lbTitle_second = [[UILabel alloc] initWithFrame:CGRectMake(0, controlToolBarHeight, SCREEN_WIDTH/2.0f, 30.0f)];
    [lbTitle_second setFont:LyFont(14)];
    [lbTitle_second setTextColor:[UIColor darkGrayColor]];
    [lbTitle_second setText:@"科目二"];
    [lbTitle_second setTextAlignment:NSTextAlignmentCenter];
    
    lbTitle_third = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f, controlToolBarHeight, SCREEN_WIDTH/2.0f, 30.0f)];
    [lbTitle_third setFont:LyFont(14)];
    [lbTitle_third setTextColor:[UIColor darkGrayColor]];
    [lbTitle_third setText:@"科目三"];
    [lbTitle_third setTextAlignment:NSTextAlignmentCenter];
    
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, controlToolBarHeight+30, SCREEN_WIDTH, controlPickerHeight-30.0f)];
    [picker setDelegate:self];
    [picker setDataSource:self];
//    [picker setShowsSelectionIndicator:YES];
    
    [viewUseful addSubview:toolBar];
    [viewUseful addSubview:lbTitle_second];
    [viewUseful addSubview:lbTitle_third];
    [viewUseful addSubview:picker];
    
    [self addSubview:viewUseful];
    
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




- (void)setTrainPeriod:(LyTrainClassObjectPeriod)trainPeriod
{
    if (trainPeriod.secondPeriod >= 1 & trainPeriod.secondPeriod < 50)
    {
        [picker selectRow:trainPeriod.secondPeriod-1 inComponent:0 animated:NO];
    }
    
    if (trainPeriod.thirdPeriod >= 1 && trainPeriod.thirdPeriod < 50)
    {
        [picker selectRow:trainPeriod.thirdPeriod-1 inComponent:1 animated:NO];
    }
}


- (void)targetForButton:(UIButton *)button
{
    if (button == btnMask)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(onCancenByTrainPeriodPicker:)])
        {
            [_delegate onCancenByTrainPeriodPicker:self];
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
        if (_delegate && [_delegate respondsToSelector:@selector(onCancenByTrainPeriodPicker:)])
        {
            [_delegate onCancenByTrainPeriodPicker:self];
        }
        else
        {
            [self hide];
        }
    }
    else if (LyControlBarButtonItemMode_done == bbi.tag)
    {
        _trainPeriod.secondPeriod = [picker selectedRowInComponent:0]+1;
        _trainPeriod.thirdPeriod = [picker selectedRowInComponent:1]+1;
        
        [_delegate onDoneByTrainPeriodPicker:self trainPeriod:_trainPeriod];
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
    [lbRow setText:[[NSString alloc] initWithFormat:@"%ld", row+1]];
    [picker clearSpearator];
    
    return lbRow;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return controlPickerRowHeight;
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
        return 50;
    }
    else if (1 == component)
    {
        return 50;
    }
    
    return 0;
}



@end
