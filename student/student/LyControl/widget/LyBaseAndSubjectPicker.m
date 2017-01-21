//
//  LyBaseAndSubjectPicker.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/17.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyBaseAndSubjectPicker.h"

#import "LyTrainBaseManager.h"

#import "LyUtil.h"

#import "UIPickerView+clearSpearator.h"





typedef NS_ENUM( NSInteger, LyBaseAndSubjectPickerBarButtonItemMode)
{
    baseAndSubjectPickerBarButtonItemMode_cancel,
    baseAndSubjectPickerBarButtonItemMode_done
};



@interface LyBaseAndSubjectPicker () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIButton                *btnMask;
    
    UIView                  *viewUseful;
    
    UIToolbar               *toolBar;
    
    UIPickerView            *picker;
    
    NSArray                 *arrSubject;
    CGPoint                 centerViewUseful;
}
@end


@implementation LyBaseAndSubjectPicker

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
    arrSubject = [LyUtil arrSubjectModePrac];
    
    btnMask = [[UIButton alloc] initWithFrame:self.bounds];
    [btnMask setBackgroundColor:LyMaskColor];
    [btnMask setTag:baseAndSubjectPickerBarButtonItemMode_cancel];
    [btnMask addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnMask];
    
    
    viewUseful = [[UIView alloc] initWithFrame:CGRectMake( 0, SCREEN_HEIGHT-controlViewUsefulHeight, SCREEN_WIDTH, controlViewUsefulHeight)];
    [viewUseful setBackgroundColor:LyWhiteLightgrayColor];
    centerViewUseful = [viewUseful center];
    
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake( verticalSpace, 0, SCREEN_WIDTH-horizontalSpace*2, controlToolBarHeight)];
    [toolBar setTintColor:Ly517ThemeColor];
    UIBarButtonItem *btnItemCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(targetForBarButtonItem:)];
    [btnItemCancel setTag:baseAndSubjectPickerBarButtonItemMode_cancel];
    UIBarButtonItem *btnItemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *btnItemDone = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(targetForBarButtonItem:)];
    [btnItemDone setTag:baseAndSubjectPickerBarButtonItemMode_done];
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
    if ( baseAndSubjectPickerBarButtonItemMode_cancel == [button tag])
    {
        [_delegate onCancelByBaseAndSubjectPicker:self];
    }
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)barBtnItem
{
    if ( baseAndSubjectPickerBarButtonItemMode_cancel == [barBtnItem tag])
    {
        [_delegate onCancelByBaseAndSubjectPicker:self];
    }
    else if ( baseAndSubjectPickerBarButtonItemMode_done == [barBtnItem tag])
    {
        _subject = [picker selectedRowInComponent:0]+LySubjectModeprac_second;
        _trainBase = [_arrTrainBase objectAtIndex:[picker selectedRowInComponent:1]];
        
        [_delegate onDoneByBaseAndSubjectPicker:self andSubject:_subject andTrainBase:_trainBase];
    }
}


- (void)setSubject:(LySubjectModeprac)subject andTrainBase:(LyTrainBase *)trainBase
{
    [picker selectRow:(subject-LySubjectModeprac_second) inComponent:0 animated:NO];
    [picker selectRow:[_arrTrainBase indexOfObject:trainBase] inComponent:1 animated:NO];
}

- (void)showWithSubject:(LySubjectModeprac)subject andTrainBase:(LyTrainBase *)trainBase
{
    [self setSubject:subject andTrainBase:trainBase];
    [self show];
}


- (void)showWithInfoString:(NSString *)infoString
{
    NSArray *arrInfo = [LyUtil separateString:infoString separator:@" "];
    if ( !arrInfo || [arrInfo isKindOfClass:[NSNull class]] || [arrInfo count] < 2)
    {
        [self show];
    }
    else
    {
        LySubjectModeprac subject = [arrSubject indexOfObject:[arrInfo objectAtIndex:0]]+LySubjectModeprac_second;
        LyTrainBase *trainBase = [LyTrainBaseManager getTrainBaseWithTbName:[arrInfo objectAtIndex:1] withDataSouce:_arrTrainBase];
        
        if ( !trainBase)
        {
            [self show];
        }
        else
        {
            [self showWithSubject:subject andTrainBase:trainBase];
        }
        
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
    
    [lbRow setText:({
        NSString *text = @"";
        if ( 0 == component)
        {
            text = [arrSubject objectAtIndex:row];
        }
        else if ( 1 == component)
        {
            text = [[_arrTrainBase objectAtIndex:row] tbName];
        }
        
        text;
    })];
    [picker clearSpearator];
    
    return lbRow;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return controlPickerRowHeight;
}

#pragma mark -UIPickerViewDataSource
//该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 2;
}


//该方法的返回值决定该控件指定列包含多少个列表项
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ( 0 == component)
    {
        return 2;
    }
    else if ( 1 == component)
    {
        return [_arrTrainBase count];
    }
    
    return 0;
}



@end
