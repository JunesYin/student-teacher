//
//  LyTimeBucketPicker.m
//  teacher
//
//  Created by Junes on 2016/9/24.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyTimeBucketPicker.h"

#import "UIPickerView+clearSpearator.h"


@interface LyTimeBucketPicker () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIButton            *btnMask;
    
    UIView              *viewUseful;
    CGPoint             centerViewUseful;
}

@property (strong, nonatomic)       UIToolbar       *toolbar;
@property (strong, nonatomic)       UIPickerView    *picker;

@end


@implementation LyTimeBucketPicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [self initAndLayoutSubviews];
    }
    
    return self;
}

- (void)initAndLayoutSubviews {
    btnMask = [[UIButton alloc] initWithFrame:self.bounds];
    [btnMask setBackgroundColor:LyMaskColor];
    [btnMask addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnMask];
    
    viewUseful = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-controlViewUsefulHeight, SCREEN_WIDTH, controlViewUsefulHeight)];
    [viewUseful setBackgroundColor:LyWhiteLightgrayColor];
    centerViewUseful = viewUseful.center;
    
    
    UILabel *lbBegin = [[UILabel alloc] initWithFrame:CGRectMake(0, controlToolBarHeight, SCREEN_WIDTH/2.0f, 30.0f)];
    [lbBegin setFont:LyFont(14)];
    [lbBegin setTextColor:[UIColor darkGrayColor]];
    [lbBegin setTextAlignment:NSTextAlignmentCenter];
    [lbBegin setText:@"开始时间"];
    
    UILabel *lbEnd = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f, controlToolBarHeight, SCREEN_WIDTH/2.0f, 30.0f)];
    [lbEnd setFont:LyFont(14)];
    [lbEnd setTextColor:[UIColor darkGrayColor]];
    [lbEnd setTextAlignment:NSTextAlignmentCenter];
    [lbEnd setText:@"结束时间"];
    
    
    [viewUseful addSubview:self.toolbar];
    [viewUseful addSubview:lbBegin];
    [viewUseful addSubview:lbEnd];
    [viewUseful addSubview:self.picker];
    
    [self addSubview:viewUseful];
    
}

- (UIToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(verticalSpace, 0, SCREEN_WIDTH-verticalSpace*2, controlToolBarHeight)];
        [_toolbar setBackgroundColor:LyWhiteLightgrayColor];
        [_toolbar setTintColor:Ly517ThemeColor];
        
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
                                                                   target:self
                                                                   action:@selector(targetForBarButtonItem:)];
        [bbiDone setTag:LyControlBarButtonItemMode_done];
        
        [_toolbar setItems:@[bbiCancel, bbiSpace, bbiDone]];
    }
    
    return _toolbar;
}

- (UIPickerView *)picker {
    if (!_picker) {
        _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, controlToolBarHeight+30.0f, SCREEN_WIDTH, controlPickerHeight-30.0f)];
        [_picker setDelegate:self];
        [_picker setDataSource:self];
//        [_picker setShowsSelectionIndicator:YES];
    }
    
    return _picker;
}

- (void)setTimeBucket:(LyTimeBucket)timeBucket {
    if (timeBucket.begin <= timeBucket.end) {
        if (0 <= timeBucket.begin && timeBucket.begin < 48 &&
            0 <= timeBucket.end && timeBucket.end <= 48) {
            _timeBucket.begin = timeBucket.begin / 2;
            _timeBucket.end = timeBucket.end / 2;
            
        }
    }
}



- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [self.picker selectRow:_timeBucket.begin inComponent:0 animated:NO];
    [self.picker selectRow:_timeBucket.end-1 inComponent:1 animated:NO];
    
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
    if (_delegate && [_delegate respondsToSelector:@selector(onCancelByTimeBucketPicker:)]) {
        [_delegate onCancelByTimeBucketPicker:self];
    } else {
        [self hide];
    }
}

- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    if (LyControlBarButtonItemMode_cancel == bbi.tag) {
        if (_delegate && [_delegate respondsToSelector:@selector(onCancelByTimeBucketPicker:)]) {
            [_delegate onCancelByTimeBucketPicker:self];
        } else {
            [self hide];
        }
    } else if (LyControlBarButtonItemMode_done == bbi.tag) {
        _timeBucket.begin = (int)[self.picker selectedRowInComponent:0];
        _timeBucket.end = (int)[self.picker selectedRowInComponent:1]+1;
        _timeBucket.begin *= 2;
        _timeBucket.end *= 2;
        
        [_delegate onDoneByTimeBucketPicker:self timeBucket:_timeBucket];
    }
}


#pragma mark -UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *lbRow;
    if (view && [view isKindOfClass:[UILabel class]]) {
        lbRow = (UILabel *)view;
    } else {
        lbRow = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / [_picker numberOfComponents], controlPickerRowHeight)];
        [lbRow setFont:controlPickerRowTitleFont];
        [lbRow setTextAlignment:NSTextAlignmentCenter];
    }
    
    [lbRow setText:[[NSString alloc] initWithFormat:@"%02ld:00", (0 == component) ? row : row+1]];
    [lbRow setEnabled:!(1 == component && row < _timeBucket.begin)];
    [_picker clearSpearator];
//    if ((1 == component && [self.picker selectedRowInComponent:1] < _timeBucket.begin)) {
//        [lbRow setEnabled:NO];
//    } else {
//        [lbRow setEnabled:YES];
//    }
    
    return lbRow;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (0 == component) {
        _timeBucket.begin = (int)row;
        [self.picker reloadComponent:1];
        if ([self.picker selectedRowInComponent:1] < _timeBucket.begin) {
            [self.picker selectRow:_timeBucket.begin inComponent:1 animated:YES];
        }
    } else if (1 == component) {
        int tmpEnd = (int)[self.picker selectedRowInComponent:1];
        if (tmpEnd < _timeBucket.begin) {
            [self.picker selectRow:_timeBucket.begin inComponent:1 animated:YES];
        } else {
            _timeBucket.end = tmpEnd+1;
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return controlPickerRowHeight;
}



#pragma mark -UIPickerDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger iCount = 0;
    if (0 == component) {
        iCount = 24;
    } else if (1 == component) {
        iCount = 24;
    }
    
    return iCount;
}
     


@end
