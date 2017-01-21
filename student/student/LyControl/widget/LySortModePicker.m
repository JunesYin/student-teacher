//
//  LySortModePicker.m
//  student
//
//  Created by Junes on 2016/11/8.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LySortModePicker.h"

#import "UIPickerView+clearSpearator.h"



@interface LySortModePicker () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIButton            *btnMask;
    UIView              *viewUseful;
    UIToolbar           *toolBar;
    UIPickerView        *picker;
    
    CGPoint             centerViewUseful;
    
    NSArray             *arrItems;
}
@end


@implementation LySortModePicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [self initSubviews];
        
        
        arrItems = [LyUtil arrSortMode];
    }
    
    return self;
}

- (void)initSubviews {
    
    btnMask = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [btnMask setBackgroundColor:LyMaskColor];
    [btnMask addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    viewUseful = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - controlViewUsefulHeight, SCREEN_HEIGHT, controlViewUsefulHeight)];
    [viewUseful setBackgroundColor:LyWhiteLightgrayColor];
    centerViewUseful = viewUseful.center;
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(verticalSpace, 0, SCREEN_WIDTH - verticalSpace * 2, controlToolBarHeight)];
    [toolBar setBackgroundColor:LyWhiteLightgrayColor];
    [toolBar setTintColor:Ly517ThemeColor];
    
    UIBarButtonItem *bbiCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(targetForBarButtonItem:)];
    [bbiCancel setTag:LyControlBarButtonItemMode_cancel];
    
    UIBarButtonItem *bbiSapce = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bbiDone = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                style:UIBarButtonItemStyleDone
                                                               target:self
                                                               action:@selector(targetForBarButtonItem:)];
    [bbiDone setTag:LyControlBarButtonItemMode_done];
    
    [toolBar setItems:@[bbiCancel, bbiSapce, bbiDone]];
    
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, controlToolBarHeight, SCREEN_WIDTH, controlPickerHeight)];
    [picker setDelegate:self];
    [picker setDataSource:self];
//    [picker setShowsSelectionIndicator:YES];
    
    [viewUseful addSubview:toolBar];
    [viewUseful addSubview:picker];
    
    
    [self addSubview:btnMask];
    [self addSubview:viewUseful];
    
}





- (void)show {
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [picker selectRow:_sortMode inComponent:0 animated:NO];
    
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
                         completion:^(BOOL finished) {
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
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                             
                             [viewUseful setCenter:centerViewUseful];
                             [btnMask setAlpha:1.0f];
                         }];
}


- (void)setSortMode:(LySortMode)sortMode {
    _sortMode = sortMode;
}


- (void)targetForButton:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(onCancelBySortModePicker:)])
    {
        [_delegate onCancelBySortModePicker:self];
    }
    else
    {
        [self hide];
    }
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    
    LyControlBarButtonItemMode mode = bbi.tag;
    switch (mode) {
        case LyControlBarButtonItemMode_cancel: {
            if (_delegate && [_delegate respondsToSelector:@selector(onCancelBySortModePicker:)])
            {
                [_delegate onCancelBySortModePicker:self];
            }
            else
            {
                [self hide];
            }
            break;
        }
        case LyControlBarButtonItemMode_done: {
            _sortMode = [picker selectedRowInComponent:0];
            [_delegate onDoneBySortModePicker:self sortMode:_sortMode];
            break;
        }
        default: {
            break;
        }
    }
}




#pragma mark -UIPickerViewDelegate
//该方法返回的NSString将作为UIPickerView中指定列和列表项的标题文本
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lbRow;
    if (view && [view isKindOfClass:[UILabel class]])
    {
        lbRow = (UILabel *)view;
    }
    else
    {
        lbRow = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / [picker numberOfComponents], controlPickerRowHeight)];
        [lbRow setTextAlignment:NSTextAlignmentCenter];
        [lbRow setFont:controlPickerRowTitleFont];
    }
    
    [lbRow setText:[arrItems objectAtIndex:row]];
    [picker clearSpearator];
    
    return lbRow;
}


#pragma mark -UIPickerViewDataSource
//该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}



//该方法的返回值决定该控件指定列包含多少个列表项
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [arrItems count];
}




@end
