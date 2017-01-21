//
//  LyTrainBasePicker.m
//  student
//
//  Created by Junes on 16/9/13.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyTrainBasePicker.h"

#import "LyTrainBaseManager.h"

#import "LyUtil.h"

#import "UIPickerView+clearSpearator.h"





typedef NS_ENUM( NSInteger, LyTrainBasePickerBarButtonItemMode)
{
    trainBasePickerBarButtonItemMode_cancel,
    trainBasePickerBarButtonItemMode_done
};

@interface LyTrainBasePicker () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIButton                *btnMask;
    
    UIView                  *viewUseful;
    
    UIToolbar               *toolBar;
    
    UIPickerView            *picker;
    
    CGPoint                 centerViewUseful;
}

@end



@implementation LyTrainBasePicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)init
{
    if ( self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        [self initSubviews];
    }
    
    return self;
}



- (instancetype)initWithTrainBase:(NSArray *)arrTrainBase
{
    if ( self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        _arrTrainBase = arrTrainBase;
        [self initSubviews];
    }
    
    return self;
}



- (void)initSubviews
{
    
    btnMask = [[UIButton alloc] initWithFrame:self.bounds];
    [btnMask setBackgroundColor:LyMaskColor];
    [btnMask setTag:trainBasePickerBarButtonItemMode_cancel];
    [btnMask addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnMask];
    
    
    viewUseful = [[UIView alloc] initWithFrame:CGRectMake( 0, SCREEN_HEIGHT-controlViewUsefulHeight, SCREEN_WIDTH, controlViewUsefulHeight)];
    [viewUseful setBackgroundColor:LyWhiteLightgrayColor];
    centerViewUseful = [viewUseful center];
    
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake( verticalSpace, 0, SCREEN_WIDTH-verticalSpace*2, controlToolBarHeight)];
    [toolBar setTintColor:Ly517ThemeColor];
    UIBarButtonItem *btnItemCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(targetForBarButtonItem:)];
    [btnItemCancel setTag:trainBasePickerBarButtonItemMode_cancel];
    UIBarButtonItem *btnItemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *btnItemDone = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(targetForBarButtonItem:)];
    [btnItemDone setTag:trainBasePickerBarButtonItemMode_done];
    [toolBar setItems:@[btnItemCancel, btnItemSpace, btnItemDone]];
    
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake( 0, toolBar.frame.origin.y+CGRectGetHeight(toolBar.frame), SCREEN_WIDTH, controlPickerHeight)];
    [picker setDelegate:self];
    [picker setDataSource:self];
//    [picker setShowsSelectionIndicator:YES];
    
    [viewUseful addSubview:toolBar];
    [viewUseful addSubview:picker];
    
    
    [self addSubview:viewUseful];
}



- (void)targetForButton:(UIButton *)button
{
    if ( trainBasePickerBarButtonItemMode_cancel == [button tag]) {
        [_delegate onCancelByTrainBasePicker:self];
    }
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)barBtnItem
{
    if ( trainBasePickerBarButtonItemMode_cancel == [barBtnItem tag])
    {
        [_delegate onCancelByTrainBasePicker:self];
    }
    else if ( trainBasePickerBarButtonItemMode_done == [barBtnItem tag])
    {
        _trainBase = [_arrTrainBase objectAtIndex:[picker selectedRowInComponent:0]];
        
        [_delegate onDoneByaTrainBasePicker:self trainBase:_trainBase];
    }
}


- (void)setTrainBase:(LyTrainBase *)trainBase {
    [picker selectRow:[_arrTrainBase indexOfObject:trainBase] inComponent:0 animated:NO];
}

- (void)showWithTrainBase:(LyTrainBase *)trainBase
{
    [self setTrainBase:trainBase];
    [self show];
}


- (void)showWithInfoString:(NSString *)infoString {
    
    if (!infoString) {
        [self show];
    }

    LyTrainBase *trainBase = [LyTrainBaseManager getTrainBaseWithTbName:infoString withDataSouce:_arrTrainBase];
    
    if ( !trainBase)
    {
        [self show]; }
    else {
        [self showWithTrainBase:trainBase];
    }
}


- (void)show {
    
    
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
                         completion:^(BOOL finished) {
                         }];
}



- (void)hide {
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




#pragma mark -UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    UILabel *lbRow;
    if ([view isKindOfClass:[UILabel class]]) {
        lbRow = (UILabel *)lbRow;
    }  else {
        lbRow = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH / [picker numberOfComponents], controlPickerRowHeight)];
        [lbRow setFont:controlPickerRowTitleFont];
        [lbRow setTextAlignment:NSTextAlignmentCenter];
    }
    
    [lbRow setText:[[_arrTrainBase objectAtIndex:row] tbName]];
    [picker clearSpearator];
    
    return lbRow;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return controlPickerRowHeight;
}

#pragma mark -UIPickerViewDataSource
//该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView {
    return 1;
}


//该方法的返回值决定该控件指定列包含多少个列表项
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ( 0 == component) {
        return [_arrTrainBase count];
    }
    
    return 0;
}





@end
