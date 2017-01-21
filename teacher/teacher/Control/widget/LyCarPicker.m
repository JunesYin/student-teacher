//
//  LyCarPicker.m
//  teacher
//
//  Created by Junes on 16/8/5.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyCarPicker.h"

#import "LyUtil.h"

#import "UIPickerView+clearSpearator.h"


@interface LyCarPicker () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIButton                        *btnMask;
    
    UIView                          *viewUseful;
    CGPoint                         centerViewUseful;
    
    UIToolbar                       *toolBar;
    UIPickerView                    *picker;
    
    NSArray                         *arrCars;
}
@end

@implementation LyCarPicker

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
    
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, controlToolBarHeight, SCREEN_WIDTH, controlPickerHeight)];
    [picker setDelegate:self];
    [picker setDataSource:self];
//    [picker setShowsSelectionIndicator:YES];
    
    [viewUseful addSubview:toolBar];
    [viewUseful addSubview:picker];
    
    [self addSubview:viewUseful];
    
    
    arrCars = @[
                @"普桑",
                @"夏利",
                @"捷达",
                @"桑塔纳",
                @"奇瑞",
                @"富康",
                @"爱丽舍",
                @"比亚大",
                @"斯柯达",
                @"伊兰",
                @"旗云",
                @"宝来",
                @"双环",
                @"万丰",
                @"羚羊",
                @"东风",
                @"解放",
                @"江淮",
                @"江铃",
                @"庆岭",
                @"福田",
                @"时代",
                @"东风标致",
                @"雪铁龙",
                @"长城皮卡",
                @"中兴皮卡",
                @"货车",
                @"客车",
                @"公交车"
                ];
}



- (void)targetForButton:(UIButton *)button
{
    if (button == btnMask)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(onCancelByCarPicker:)])
        {
            [_delegate onCancelByCarPicker:self];
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
        if (_delegate && [_delegate respondsToSelector:@selector(onCancelByCarPicker:)])
        {
            [_delegate onCancelByCarPicker:self];
        }
        else
        {
            [self hide];
        }
    }
    else if (LyControlBarButtonItemMode_done == bbi.tag)
    {
        _car = [arrCars objectAtIndex:[picker selectedRowInComponent:0]];
        
        [_delegate onDoneByCarPicker:self car:_car];
    }
}


- (void)setCar:(NSString *)car
{
    if (!car)
    {
        return;
    }
    
    NSInteger index = [arrCars indexOfObject:car];
    if (index > -1 && index < arrCars.count)
    {
        [picker selectRow:index inComponent:0 animated:NO];
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
    [lbRow setText:[arrCars objectAtIndex:row]];
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
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arrCars.count;
}


@end


