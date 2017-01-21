//
//  LyTrainModePicker.m
//  teacher
//
//  Created by Junes on 16/8/8.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyTrainModePicker.h"

#import "UIPickerView+clearSpearator.h"


@interface LyTrainModePicker () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIButton                    *btnMask;
    
    UIView                      *viewUseful;
    UIToolbar                   *toolBar;

    UIPickerView                *picker;
    
    CGPoint                     centerViewUseful;
    
    NSArray                     *arrTrainModes;
}
@end


@implementation LyTrainModePicker

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
    
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, controlToolBarHeight+30, SCREEN_WIDTH, controlPickerHeight-30.0f)];
    [picker setDelegate:self];
    [picker setDataSource:self];
//    [picker setShowsSelectionIndicator:YES];
    
    [viewUseful addSubview:toolBar];
    [viewUseful addSubview:picker];
    
    [self addSubview:viewUseful];
    
    
    arrTrainModes = [LyUtil arrTrainModes];
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


- (void)setTrainModeByString:(NSString *)trainMode
{
    _trainMode = [LyUtil trainModeFromString:trainMode];
    
    [self setTrainMode:_trainMode-1];
}


- (void)setTrainMode:(LyTrainClassTrainMode)trainMode
{
    if (trainMode > 0 && trainMode < arrTrainModes.count)
    {
        [picker selectRow:trainMode inComponent:0 animated:NO];
    }
}


- (void)targetForButton:(UIButton *)button
{
    if (button == btnMask)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(onCancelByTrainModePicker:)])
        {
            [_delegate onCancelByTrainModePicker:self];
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
        if (_delegate && [_delegate respondsToSelector:@selector(onCancelByTrainModePicker:)])
        {
            [_delegate onCancelByTrainModePicker:self];
        }
        else
        {
            [self hide];
        }
    }
    else if (LyControlBarButtonItemMode_done == bbi.tag)
    {
        _trainMode = [picker selectedRowInComponent:0] + 1;
        
        [_delegate onDoneByTrainModePicker:self trainMode:_trainMode];
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
    [lbRow setText:[arrTrainModes objectAtIndex:row]];
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
    return arrTrainModes.count;
}





@end
