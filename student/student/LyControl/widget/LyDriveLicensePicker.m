//
//  LyDriveLicensePicker.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/6.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyDriveLicensePicker.h"


#import "UIPickerView+clearSpearator.h"


typedef NS_ENUM( NSInteger, LyDriveLicensePickerButtonItemMode)
{
    driveLicensePickerButtonItemMode_big = 42,
};


@interface LyDriveLicensePicker () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIButton                    *btnBig;
    
    UIView                      *viewUseful;
    CGPoint                     centerViewUseful;
    
    UIToolbar                   *toolBar;
    UIPickerView                *picker;
    
    
    NSArray                     *arrItems;
}
@end


@implementation LyDriveLicensePicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+ (instancetype)driveLicensePicker
{
    LyDriveLicensePicker *tmpPicker = [[LyDriveLicensePicker alloc] init];
    
    return tmpPicker;
}


- (instancetype)init
{
    if ( self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        [self initAndLayoutSubview];
        
        arrItems = [LyUtil arrDriveLicenses];
    }
    
    return self;
}



- (void)initAndLayoutSubview
{
    btnBig = [[UIButton alloc] initWithFrame:self.bounds];
    [btnBig setBackgroundColor:LyMaskColor];
    [btnBig setTag:driveLicensePickerButtonItemMode_big];
    [btnBig addTarget:self action:@selector(dlTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnBig];
    
    
    
    UIBarButtonItem *btnItemCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(dlTargetForBarButtonItem:)];
    [btnItemCancel setTag:LyControlBarButtonItemMode_cancel];
    UIBarButtonItem *btnItemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *btnItemDone = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(dlTargetForBarButtonItem:)];
    [btnItemDone setTag:LyControlBarButtonItemMode_done];
    
    
    viewUseful = [[UIView alloc] initWithFrame:CGRectMake( 0, SCREEN_HEIGHT-controlViewUsefulHeight, SCREEN_WIDTH, controlViewUsefulHeight)];
    [viewUseful setBackgroundColor:LyWhiteLightgrayColor];
    centerViewUseful = viewUseful.center;
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake( verticalSpace, 0, SCREEN_WIDTH-verticalSpace*2, controlToolBarHeight)];
    [toolBar setTintColor:Ly517ThemeColor];
    [toolBar setItems:@[
                        btnItemCancel,
                        btnItemSpace,
                        btnItemDone
                        ]];

    
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake( 0, toolBar.frame.origin.y+CGRectGetHeight(toolBar.frame), SCREEN_WIDTH, controlPickerHeight)];
    [picker setDelegate:self];
    [picker setDataSource:self];
//    [picker setShowsSelectionIndicator:YES];
    
    [viewUseful addSubview:toolBar];
    [viewUseful addSubview:picker];
    
    
    [self addSubview:viewUseful];
    
}




- (void)setInitDriveLicense:(LyLicenseType)newLicenseType
{
    [picker selectRow:newLicenseType-LyLicenseType_C1 inComponent:0 animated:NO];
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
    
    
    [LyUtil startAnimationWithView:btnBig
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
    
    
    [LyUtil startAnimationWithView:btnBig
                 animationDuration:0.3
                         initAlpha:1.0f
                 destinationAplhas:0.0f
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                             
                             [viewUseful setCenter:centerViewUseful];
                             [btnBig setAlpha:1.0f];
                         }];
}



- (void)dlTargetForButtonItem:(UIButton *)button
{
    switch ( [button tag]) {
        case driveLicensePickerButtonItemMode_big:
        {
            if ( [_delegate respondsToSelector:@selector(onDriveLicensePickerCancel:)])
            {
                [_delegate onDriveLicensePickerCancel:self];
            }
            else  {
                [self hide];
            }
            break;
        }
            
        default:
            break;
    }
}



- (void)dlTargetForBarButtonItem:(UIBarButtonItem *)barBtn
{
    switch ( [barBtn tag]) {
        case LyControlBarButtonItemMode_cancel:
        {
            if ( [_delegate respondsToSelector:@selector(onDriveLicensePickerCancel:)])
            {
                [_delegate onDriveLicensePickerCancel:self];
            }
            else  {
                [self hide];
            }
            break;
        }
         
        case LyControlBarButtonItemMode_done:
        {
            _license = [picker selectedRowInComponent:0];
            
            if ( [_delegate respondsToSelector:@selector(onDriveLicensePickerDone:license:)])
            {
                [_delegate onDriveLicensePickerDone:self license:_license];
            }
            break;
        }
            
        default:
            break;
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




