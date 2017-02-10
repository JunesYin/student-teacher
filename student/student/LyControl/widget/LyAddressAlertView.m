//
//  LyAddressAlertView.m
//  teacher
//
//  Created by Junes on 16/8/10.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyAddressAlertView.h"
#import "UITextView+placeholder.h"
#import "LyUtil.h"

#import "UIPickerView+clearSpearator.h"



CGFloat const aavViewUsefulHeight = 250.0f;

CGFloat const aavPickerHeight = 160.0f;
CGFloat const aavPickerRowHeight = 30.0f;
#define pickerRowTitleFont                          LyFont(14)



@interface LyAddressAlertView () <UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIButton                *btnMask;
    
    UIView                  *viewUseful;
    UIToolbar               *toolBar;
    UITextView              *tvContent;
    
    UIPickerView            *picker;
    
    CGPoint                 centerViewUseful;
    
    
    
    NSDictionary                    *dicAllArea;
    
    NSArray                         *arrProvince;
    NSArray                         *arrCity;
    NSArray                         *arrDistrict;
    
    NSString                        *curProvince;
    NSString                        *curCity;
    NSString                        *curDistrict;
}
@end


@implementation LyAddressAlertView

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
    }
    
    return self;
}



+ (instancetype)addressAlertViewWithAddress:(NSString *)address {
    LyAddressAlertView *aa = [[LyAddressAlertView alloc] initWithAddress:address];
    
    return aa;
}

- (instancetype)initWithAddress:(NSString *)address {
    
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _address = address;
        
        [self initSubviews];
    }
    
    return self;
}



- (void)initSubviews {
    btnMask = [[UIButton alloc] initWithFrame:self.bounds];
    [btnMask setBackgroundColor:LyMaskColor];
    [btnMask addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnMask];
    
    viewUseful = [[UIView alloc] initWithFrame:CGRectMake(horizontalSpace, SCREEN_HEIGHT/2.0f-aavViewUsefulHeight/2.0f, SCREEN_WIDTH-horizontalSpace*2, aavViewUsefulHeight)];
    [viewUseful setBackgroundColor:LyWhiteLightgrayColor];
    [viewUseful.layer setCornerRadius:btnCornerRadius];
    centerViewUseful = viewUseful.center;
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(horizontalSpace, 0, CGRectGetWidth(viewUseful.frame)-horizontalSpace*2, controlToolBarHeight)];
    [toolBar setTintColor:Ly517ThemeColor];
    
    UIBarButtonItem *bbiCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(targetForBarButtonItem:)];
    UIBarButtonItem *bbiSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    UIBarButtonItem *bbiDone = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                style:UIBarButtonItemStyleDone
                                                               target:self action:@selector(targetForBarButtonItem:)];
    [bbiCancel setTag:LyControlBarButtonItemMode_cancel];
    [bbiDone setTag:LyControlBarButtonItemMode_done];
    [toolBar setItems:@[bbiCancel, bbiSpace, bbiDone]];
    
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, toolBar.frame.origin.y+CGRectGetHeight(toolBar.frame), CGRectGetWidth(viewUseful.frame), aavPickerHeight)];
    [picker setDelegate:self];
    [picker setDataSource:self];
//    [picker setShowsSelectionIndicator:YES];
    
    
    tvContent = [[UITextView alloc] initWithFrame:CGRectMake(verticalSpace, toolBar.frame.origin.y+CGRectGetHeight(toolBar.frame)+CGRectGetHeight(picker.frame)+verticalSpace, CGRectGetWidth(viewUseful.frame)-verticalSpace*2, CGRectGetHeight(viewUseful.frame)-CGRectGetHeight(toolBar.frame)-CGRectGetHeight(picker.frame)-verticalSpace*2)];
    [tvContent setTextContainerInset:UIEdgeInsetsMake(verticalSpace, verticalSpace, verticalSpace, verticalSpace)];
    [tvContent.layer setCornerRadius:btnCornerRadius];
    [tvContent.layer setBorderWidth:1.0f];
    [tvContent.layer setBorderColor:[LyWhiteLightgrayColor CGColor]];
    [tvContent setFont:LyFont(14)];
    [tvContent setTextColor:LyBlackColor];
    [tvContent setTextAlignment:NSTextAlignmentLeft];
    [tvContent setDelegate:self];
    [tvContent setReturnKeyType:UIReturnKeyDone];
    
    [viewUseful addSubview:toolBar];
    [viewUseful addSubview:picker];
    [viewUseful addSubview:tvContent];
    
    [self addSubview:viewUseful];
    
    
    
    [self analysisAreaInfo];
    [tvContent setPlaceholder:@"请填写你的详细地址"];
    if (_address) {
        [self setAddress:_address];
    }
}


- (void)analysisAreaInfo {
    NSString *plistPath = [LyUtil filePathForFileName:@"area.plist"];
    
    if ( !plistPath || [plistPath isEqualToString:@""]) {
        return;
    }
    
    dicAllArea = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    if ( !dicAllArea || ![dicAllArea count]) {
        return;
    }
    
    NSArray *components = [dicAllArea allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[dicAllArea objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    arrProvince = [[NSArray alloc] initWithArray:provinceTmp];
    
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [arrProvince objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[dicAllArea objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    arrCity = [NSArray arrayWithArray:[cityDic allKeys]];
    
    curCity = [arrCity objectAtIndex:0];
    arrDistrict = [NSArray arrayWithArray:[cityDic objectForKey:curCity]];
    
    curProvince = [arrProvince objectAtIndex:0];
    curDistrict = [arrDistrict objectAtIndex:0];
    
}


- (void)reloadWithAddress:(NSString *)address {
    
    if (!address) {
        address = _address;
    }
    
    if (!address) {
        return;
    }
    
    NSArray *arr = [LyUtil separateString:_address separator:@" "];

    if ( [arr count] < 3) {
        return;
    }
    NSString *strProvince = [arr objectAtIndex:0];
    NSString *strCity = [arr objectAtIndex:1];
    NSString *strDistrict = [arr objectAtIndex:2];

    NSInteger indexProvince = [arrProvince indexOfObject:strProvince];
    if ( indexProvince < 0 ||  indexProvince > [picker numberOfRowsInComponent:0]) {
        return;
    }
    [picker selectRow:indexProvince inComponent:0 animated:YES];
    [picker reloadComponent:1];

    NSInteger indexCity = [arrCity indexOfObject:strCity];
    if ( indexCity < 0 || indexCity > [picker numberOfRowsInComponent:1]) {
        return;
    }
    [picker selectRow:indexCity inComponent:1 animated:YES];
    [picker reloadComponent:2];

    NSInteger indexDistrict = [arrDistrict indexOfObject:strDistrict];
    if ( indexDistrict < 0 || indexDistrict > [picker numberOfRowsInComponent:2]) {
        return;
    }
    [picker selectRow:indexDistrict inComponent:2 animated:YES];

    if (arr.count >= 4) {
        [tvContent setText:[arr objectAtIndex:3]];
        [tvContent updatePlaceholder];
    }
    
}


//- (void)setAddress:(NSString *)address {
//    
//    _address = address;
//    
//    /*
//    NSArray *arr = [LyUtil separateString:address separator:@" "];
//
//    if ( [arr count] < 3) {
//        return;
//    }
//    NSString *strProvince = [arr objectAtIndex:0];
//    NSString *strCity = [arr objectAtIndex:1];
//    NSString *strDistrict = [arr objectAtIndex:2];
//    
//    NSInteger indexProvince = [arrProvince indexOfObject:strProvince];
//    if ( indexProvince < 0 ||  indexProvince > [picker numberOfRowsInComponent:0]) {
//        return;
//    }
//    [picker selectRow:indexProvince inComponent:0 animated:YES];
//    [picker reloadComponent:1];
//    
//    NSInteger indexCity = [arrCity indexOfObject:strCity];
//    if ( indexCity < 0 || indexCity > [picker numberOfRowsInComponent:1]) {
//        return;
//    }
//    [picker selectRow:indexCity inComponent:1 animated:YES];
//    [picker reloadComponent:2];
//    
//    NSInteger indexDistrict = [arrDistrict indexOfObject:strDistrict];
//    if ( indexDistrict < 0 || indexDistrict > [picker numberOfRowsInComponent:2]) {
//        return;
//    }
//    [picker selectRow:indexDistrict inComponent:2 animated:YES];
//    
//    if (arr.count >= 4) {
//        [tvContent setText:[arr objectAtIndex:3]];
//        [tvContent updatePlaceholder];
//    }
//    */
//}




- (void)show {
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(targetForNotificatinFromKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(targetForNotificationFromKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self reloadWithAddress:_address];
    
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
                         completion:^(BOOL finished) {
                         }];
}


- (void)hide {
    [tvContent resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [LyUtil startAnimationWithView:viewUseful
                 animationDuration:0.3f
                      initialPoint:centerViewUseful
                  destinationPoint:CGPointMake( centerViewUseful.x, centerViewUseful.y+CGRectGetHeight(viewUseful.frame))
                        completion:^(BOOL finished) {
                            [tvContent setHidden:YES];
                            [tvContent setCenter:centerViewUseful];
                        }];
    [LyUtil startAnimationWithView:btnMask
                 animationDuration:0.3f
                         initAlpha:1.0f
                 destinationAplhas:0.0f
                         completion:^(BOOL finished) {
                             [btnMask setHidden:YES];
                             [self removeFromSuperview];
                         }];
}


- (void)targetForButton:(UIButton *)button
{
    [tvContent resignFirstResponder];
    
    if (_delegate && [_delegate respondsToSelector:@selector(addressAlertView:onClickButtonDone:)]) {
        [_delegate addressAlertView:self onClickButtonDone:NO];
    } else {
        [self hide];
    }
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    [tvContent resignFirstResponder];
    
    if (LyControlBarButtonItemMode_cancel == bbi.tag) {
        if (_delegate && [_delegate respondsToSelector:@selector(addressAlertView:onClickButtonDone:)]) {
            [_delegate addressAlertView:self onClickButtonDone:NO];
        } else {
            [self hide];
        }
    } else if (LyControlBarButtonItemMode_done == bbi.tag) {
        NSInteger rowDistrict = [picker selectedRowInComponent:2];
        curDistrict = [arrDistrict objectAtIndex:rowDistrict];
        
        _address = [[NSString alloc] initWithFormat:@"%@ %@ %@ %@", curProvince, curCity, curDistrict, tvContent.text];
        _city = curCity;
        [_delegate addressAlertView:self onClickButtonDone:YES];
    }
}


#pragma mark -UIKeyboardWillShowNotification
- (void)targetForNotificatinFromKeyboardWillShow:(NSNotification *)notifi {
    CGFloat keyboardHeight = [[[notifi userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [viewUseful setFrame:CGRectMake(horizontalSpace, SCREEN_HEIGHT-keyboardHeight-aavViewUsefulHeight, SCREEN_WIDTH-horizontalSpace*2, aavViewUsefulHeight)];
}

#pragma mark -UIKeyboardWillHideNotification
- (void)targetForNotificationFromKeyboardWillHide:(NSNotification *)notifi {
    [viewUseful setFrame:CGRectMake(horizontalSpace, SCREEN_HEIGHT/2.0f-aavViewUsefulHeight/2.0f, SCREEN_WIDTH-horizontalSpace*2, aavViewUsefulHeight)];
}


#pragma mark -UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [tvContent resignFirstResponder];
        return NO;
    }
    
    return YES;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [tvContent resignFirstResponder];
}



#pragma mark -UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *lbRow;
    if (view && [view isKindOfClass:[UILabel class]]) {
        lbRow = (UILabel *)view;
    } else {
        lbRow = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH / [picker numberOfComponents], aavPickerRowHeight)];
        [lbRow setFont:controlPickerRowTitleFont];
        [lbRow setTextAlignment:NSTextAlignmentCenter];
    }
    
    [lbRow setText:({
        NSString *text;
        if ( 0 == component) {
            text = [arrProvince objectAtIndex:row];
        } else if ( 1 == component) {
            text = [arrCity objectAtIndex:row];
        } else if ( 2 == component) {
            text = [arrDistrict objectAtIndex:row];
        }
        
        text;
    })];
    [picker clearSpearator];
    
    return lbRow;
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if ( 0 == component) {
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        [pickerView reloadComponent:2];
    } else if ( 1 == component) {
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
}



- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return aavPickerRowHeight;
}



#pragma mark -UIPickerViewDataSource
//该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView {
    return 3;
}



//该方法的返回值决定该控件指定列包含多少个列表项
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (0 == component) {
        return [arrProvince count];
    } else if ( 1 == component) {
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        curProvince = [arrProvince objectAtIndex:rowProvince];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [dicAllArea objectForKey: [[NSString alloc] initWithFormat:@"%d", (int)rowProvince]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: curProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        arrCity = [array copy];
        
        return [arrCity count];
        
    } else if ( 2 == component) {
        NSInteger rowCity = [pickerView selectedRowInComponent:1];
        curCity = [arrCity objectAtIndex:rowCity];
        
        NSString *provinceIndex = [[NSString alloc] initWithFormat: @"%ld", [arrProvince indexOfObject: curProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [dicAllArea objectForKey: provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey:curProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: rowCity]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        arrDistrict = [NSArray arrayWithArray:[cityDic objectForKey:[cityKeyArray objectAtIndex:0]]];
        
        return [arrDistrict count];
    }
    
    
    return 0;
}



@end
