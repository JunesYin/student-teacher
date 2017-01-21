//
//  LyWeekdaySpanPicker.m
//  teacher
//
//  Created by Junes on 2016/9/24.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyWeekdaySpanPicker.h"

#import "LyUtil.h"

#import "UIPickerView+clearSpearator.h"


@interface LyWeekdaySpanPicker () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIButton                *btnMask;
    
    UIView                  *viewUseful;
    UIToolbar               *toolBar;
    
    UILabel                 *lbTitle_start;
    UILabel                 *lbTitle_end;
    
    UIPickerView            *picker;
    
    CGPoint                 centerViewUseful;
    
}
@end


@implementation LyWeekdaySpanPicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

static NSArray *arrWeekdays = nil;

- (instancetype)init {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [self initAndLayoutSubviews];
    }
    
    return self;
}

- (void)initAndLayoutSubviews {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        arrWeekdays = [LyUtil arrWeekdays];
    });
    
    
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
    
    
    lbTitle_start = [[UILabel alloc] initWithFrame:CGRectMake(0, controlToolBarHeight, SCREEN_WIDTH/2.0f, 30.0f)];
    [lbTitle_start setFont:LyFont(14)];
    [lbTitle_start setTextColor:[UIColor darkGrayColor]];
    [lbTitle_start setText:@"开始"];
    [lbTitle_start setTextAlignment:NSTextAlignmentCenter];
    
    lbTitle_end = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f, controlToolBarHeight, SCREEN_WIDTH/2.0f, 30.0f)];
    [lbTitle_end setFont:LyFont(14)];
    [lbTitle_end setTextColor:[UIColor darkGrayColor]];
    [lbTitle_end setText:@"结束"];
    [lbTitle_end setTextAlignment:NSTextAlignmentCenter];
    
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, controlToolBarHeight+30, SCREEN_WIDTH, controlPickerHeight-30.0f)];
    [picker setDelegate:self];
    [picker setDataSource:self];
//    [picker setShowsSelectionIndicator:YES];
    
    [viewUseful addSubview:toolBar];
    [viewUseful addSubview:lbTitle_start];
    [viewUseful addSubview:lbTitle_end];
    [viewUseful addSubview:picker];
    
    [self addSubview:viewUseful];
    
    
    _weekdaySpan.begin = 0;
    _weekdaySpan.end = 0;
}


- (void)setWeekdaySpan:(LyWeekdaySpan)weekdaySpan {
    if (weekdaySpan.begin <= weekdaySpan.end) {
        if (LyWeekday_monday <= weekdaySpan.begin && weekdaySpan.begin <= LyWeekday_sunday
            && LyWeekday_monday <= weekdaySpan.end && weekdaySpan.end <= LyWeekday_sunday) {
            
            _weekdaySpan = weekdaySpan;
//            
//            [picker selectRow:_weekdaySpan.begin inComponent:0 animated:NO];
//            [picker selectRow:_weekdaySpan.end inComponent:1 animated:NO];
        }
    }
}


- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    
    [picker selectRow:_weekdaySpan.begin inComponent:0 animated:NO];
    [picker selectRow:_weekdaySpan.end inComponent:1 animated:NO];
    
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


- (void)hide {
    
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


- (void)targetForButton:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(onCancelByWeekdaySpanPicker:)]) {
        [_delegate onCancelByWeekdaySpanPicker:self];
    } else {
        [self hide];
    }
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi
{
    if (LyControlBarButtonItemMode_cancel == bbi.tag) {
        if (_delegate && [_delegate respondsToSelector:@selector(onCancelByWeekdaySpanPicker:)]) {
            [_delegate onCancelByWeekdaySpanPicker:self];
        } else {
            [self hide];
        }
    } else if (LyControlBarButtonItemMode_done == bbi.tag) {
        _weekdaySpan.begin = [picker selectedRowInComponent:0];
        _weekdaySpan.end = [picker selectedRowInComponent:1];
        [_delegate onDoneByByWeekdaySpanPicker:self weekdaySpan:_weekdaySpan];
    }
}





#pragma mark -UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *lbRow;
    if (view && [view isKindOfClass:[UILabel class]]) {
        lbRow = (UILabel *)view;
    } else {
        lbRow = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH / [picker numberOfComponents], controlPickerRowHeight)];
        [lbRow setFont:controlPickerRowTitleFont];
        [lbRow setTextAlignment:NSTextAlignmentCenter];
    }
    
    [lbRow setText:[arrWeekdays objectAtIndex:row]];
    [lbRow setEnabled:!(1 == component && row < _weekdaySpan.begin)];
    [picker clearSpearator];
    
    return lbRow;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (0 == component) {
        _weekdaySpan.begin = row;
        [picker reloadComponent:1];
        if ([picker selectedRowInComponent:1] < _weekdaySpan.begin) {
            [picker selectRow:_weekdaySpan.begin inComponent:1 animated:YES];
        }
    } else if (1 == component) {
        LyWeekday tmpWeekdayEnd = row;
        if (tmpWeekdayEnd < _weekdaySpan.begin) {
            [picker selectRow:_weekdaySpan.begin inComponent:1 animated:YES];
        } else {
            _weekdaySpan.end = row;
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return controlPickerRowHeight;
}


#pragma mark UIPickerDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger iCount = 0;
    if (0 == component) {
        iCount = arrWeekdays.count;
    } else if (1 == component) {
        iCount = arrWeekdays.count;
    }
    
    return iCount;
}




@end
