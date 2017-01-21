//
//  LyStudyProgressPicker.m
//  teacher
//
//  Created by Junes on 16/8/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyStudyProgressPicker.h"

#import "UIPickerView+clearSpearator.h"


@interface LyStudyProgressPicker () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIButton                *btnMask;
    
    UIView                  *viewUseful;
    UIToolbar               *toolBar;
    
    UIPickerView            *picker;
    
    CGPoint                 centerViewUseful;
}
@end

@implementation LyStudyProgressPicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

static NSArray *arrStudyProgresses = nil;

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
    arrStudyProgresses = [LyUtil arrSubjectMode];
    
    
    btnMask = [[UIButton alloc] initWithFrame:self.bounds];
    [btnMask setBackgroundColor:LyMaskColor];
    [btnMask addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnMask];
    
    viewUseful = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-controlViewUsefulHeight, SCREEN_WIDTH, controlViewUsefulHeight)];
    [viewUseful setBackgroundColor:LyWhiteLightgrayColor];
    centerViewUseful = viewUseful.center;
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(verticalSpace, 0, CGRectGetWidth(viewUseful.frame)-verticalSpace*2, controlToolBarHeight)];
    [toolBar setTintColor:Ly517ThemeColor];
    [toolBar setBackgroundColor:LyWhiteLightgrayColor];
    UIBarButtonItem *bbiCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(targetForBarButtonItem:)];
    [bbiCancel setTag:LyControlBarButtonItemMode_cancel];
    UIBarButtonItem *bbiSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    UIBarButtonItem *bbiDone = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                style:UIBarButtonItemStyleDone
                                                               target:self action:@selector(targetForBarButtonItem:)];
    
    [bbiDone setTag:LyControlBarButtonItemMode_done];
    
    [toolBar setItems:@[bbiCancel, bbiSpace, bbiDone]];
    
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, toolBar.ly_y+CGRectGetHeight(toolBar.frame), CGRectGetWidth(viewUseful.frame), controlPickerHeight)];
    [picker setDelegate:self];
    [picker setDataSource:self];
//    [picker setShowsSelectionIndicator:YES];
    
    [viewUseful addSubview:toolBar];
    [viewUseful addSubview:picker];
    
    [self addSubview:viewUseful];
    
}


- (void)setCurIndex:(NSInteger)curIndex
{
    _curIndex = curIndex-1;
    
    
    if (_curIndex > -1 && _curIndex < arrStudyProgresses.count)
    {
        [picker selectRow:curIndex-1 inComponent:0 animated:NO];
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
                                         }];
    
    [LyUtil startAnimationWithView:btnMask
                                  animationDuration:0.3f
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
                                             
                                         }];
    [LyUtil startAnimationWithView:btnMask
                                  animationDuration:0.3f
                                          initAlpha:1.0f
                                  destinationAplhas:0.0f
                                          comletion:^(BOOL finished) {
                                              [btnMask setHidden:NO];
                                              [self removeFromSuperview];
                                          }];
}


- (void)targetForButton:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(onCancelByStudyProgressPicker:)])
    {
        [_delegate onCancelByStudyProgressPicker:self];
    }
    else
    {
        [self hide];
    }
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi
{
    if (LyControlBarButtonItemMode_cancel == bbi.tag)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(onCancelByStudyProgressPicker:)])
        {
            [_delegate onCancelByStudyProgressPicker:self];
        }
        else
        {
            [self hide];
        }
    }
    else if (LyControlBarButtonItemMode_done == bbi.tag)
    {
        _curIndex = [picker selectedRowInComponent:0];
        
        [_delegate onDoneByStudyProgressPicker:self studyProgress:_curIndex+1];
    }
}


#pragma mark -UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    UILabel *lbRow;
    if (view && [view isKindOfClass:[UILabel class]]) {
        lbRow = (UILabel *)view;
    } else {
        lbRow = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH / [picker numberOfComponents], controlPickerRowHeight)];
        [lbRow setFont:controlPickerRowTitleFont];
        [lbRow setTextAlignment:NSTextAlignmentCenter];
    }
    
    [lbRow setText:[arrStudyProgresses objectAtIndex:row]];
    [picker clearSpearator];
    
    return lbRow;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return controlPickerRowHeight;
}

#pragma mark UIPickerDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arrStudyProgresses.count;
}

@end
