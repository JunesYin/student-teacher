//
//  LyLicenseInfoPicker.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/25.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyLicenseInfoPicker.h"
#import "LyUtil.h"

#import "UIPickerView+clearSpearator.h"

typedef NS_ENUM( NSInteger, LyLicenseInfoPickerViewButtonItemMode)
{
    licenseInfoPickerViewButtonItemMode_cancal,
    licenseInfoPickerViewButtonItemMode_done
};


@interface LyLicenseInfoPicker () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIButton                *btnBig;
    
    UIView                  *viewUseful;
    
    UIToolbar               *toolBar;
    
    UIPickerView            *picker;
    
    
    CGPoint                 centerViewUseful;
    
    
    NSArray                 *arrLicense;
    NSArray                 *arrObject;
}
@end


@implementation LyLicenseInfoPicker

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
        
        arrLicense = [LyUtil arrDriveLicenses];
        
        arrObject = [LyUtil arrSubjectMode];
    }
    
    
    return self;
}




- (void)initSubviews
{
    btnBig = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [btnBig setBackgroundColor:LyMaskColor];
    [btnBig setTag:licenseInfoPickerViewButtonItemMode_cancal];
    [btnBig addTarget:self action:@selector(lipTargetForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnBig];
    
    
    viewUseful = [[UIView alloc] initWithFrame:CGRectMake( 0, SCREEN_HEIGHT-controlViewUsefulHeight, SCREEN_WIDTH, controlViewUsefulHeight)];
    [viewUseful setBackgroundColor:LyWhiteLightgrayColor];
    centerViewUseful = [viewUseful center];
    
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(verticalSpace, 0, SCREEN_WIDTH-verticalSpace*2, controlToolBarHeight)];
    [toolBar setBackgroundColor:LyWhiteLightgrayColor];
    [toolBar setTintColor:Ly517ThemeColor];
    UIBarButtonItem *btnItemCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(lipTargetForBarButtonItem:)];
    [btnItemCancel setTag:licenseInfoPickerViewButtonItemMode_cancal];
    UIBarButtonItem *btnItemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *btnItemDone = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(lipTargetForBarButtonItem:)];
    [btnItemDone setTag:licenseInfoPickerViewButtonItemMode_done];
    
    [toolBar setItems:@[btnItemCancel, btnItemSpace, btnItemDone]];
    
    
    
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake( 0, toolBar.frame.origin.y+CGRectGetHeight(toolBar.frame), SCREEN_WIDTH, controlPickerHeight)];
    [picker setDelegate:self];
    [picker setDataSource:self];
//    [picker setShowsSelectionIndicator:YES];
    
    [viewUseful addSubview:toolBar];
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



- (void)setLicense:(LyLicenseType)license andObject:(LySubjectMode)subject
{
    [picker selectRow:license inComponent:0 animated:NO];
    [picker selectRow:subject inComponent:1 animated:NO];
}




- (void)lipTargetForButton:(UIButton *)button
{
    switch ( [button tag]) {
        case licenseInfoPickerViewButtonItemMode_cancal: {
            
            break;
        }
            
        default: {
            break;
        }
    }
}


- (void)lipTargetForBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    switch ( [barButtonItem tag]) {
        case licenseInfoPickerViewButtonItemMode_cancal: {
            
            if ( [_delegate respondsToSelector:@selector(onLicenseInfoPickerCancel:)])
            {
                [_delegate onLicenseInfoPickerCancel:self];
            }
            else
            {
                [self hide];
            }
            
            
            break;
        }
        case licenseInfoPickerViewButtonItemMode_done: {
            
            _license = [picker selectedRowInComponent:0];
            _subject = [picker selectedRowInComponent:1];
            
            if ( [_delegate respondsToSelector:@selector(onLicenseInfoPickerDone:andLicense:andObject:)])
            {
                [_delegate onLicenseInfoPickerDone:self andLicense:_license andObject:_subject];
            }
            else
            {
                [self hide];
            }
            
            break;
        }
            
        default:
            break;
    }
}







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
        NSString *text;
        if ( 0 == component)
        {
            text = [arrLicense objectAtIndex:row];
        }
        else if ( 1 == component)
        {
            text = [arrObject objectAtIndex:row];
        }
        
        text;
    })];
    [picker clearSpearator];
    
    return lbRow;
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ( 0 == component)
    {
        [pickerView selectRow:0 inComponent:1 animated:NO];
    }
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
        return [arrLicense count];
    }
    else if ( 1 == component)
    {
        return [arrObject count];
    }
    
    return 0;
}


@end
