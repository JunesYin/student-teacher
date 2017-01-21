//
//  LyAddressPicker.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/5.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyAddressPicker.h"
#import "LyCurrentUser.h"
#import "LyUtil.h"

#import "UIPickerView+clearSpearator.h"



@interface LyAddressPicker () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIButton                        *btnBig;
    
    
    UIView                          *viewUseful;
    UIToolbar                       *toolBar;
    

    UIPickerView                    *picker;
    

    NSDictionary                    *dicAllArea;
    
    NSArray                         *arrProvince;
    NSArray                         *arrCity;
//    NSArray                         *_arrDistricts;
    
    NSString                        *currentProvince;
    NSString                        *currentCity;
    NSString                        *currentDistrict;
    
    
    
    CGPoint                         centerViewUseful;
}

@end


@implementation LyAddressPicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//
//- (instancetype)init
//{
//    if ( self = [super initWithFrame:[UIScreen mainScreen].bounds])
//    {
//        
//    }
//    
//    return self;
//}



+ (instancetype)addressPickerWithMode:(LyAddressPickerMode)mode
{
    LyAddressPicker *addressPicker = [[LyAddressPicker alloc] initWithMode:mode];
    
    return addressPicker;
}

- (instancetype)initWithMode:(LyAddressPickerMode)mode
{
    if ( self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        _mode = mode;
        
        [self initAndLayoutSubview];
    }
    
    return self;
}


- (instancetype)initWithDatas:(NSArray *)datas
{
    if ( !datas)
    {
        return nil;
    }
    
    if ( self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        _mode = LyAddressPickerMode_addGuider;
        _citys = datas;
        [self initAndLayoutSubview];
    }
    
    return self;
}



- (void)initAndLayoutSubview
{
    [self analysisAreaInfo];
    
    btnBig = [[UIButton alloc] initWithFrame:self.bounds];
    [btnBig setBackgroundColor:LyMaskColor];
    [btnBig setTag:LyControlBarButtonItemMode_cancel];
    [btnBig addTarget:self action:@selector(apTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnBig];
    
    
    viewUseful = [[UIView alloc] initWithFrame:CGRectMake( 0, SCREEN_HEIGHT-controlViewUsefulHeight, SCREEN_WIDTH, controlViewUsefulHeight)];
    [viewUseful setBackgroundColor:LyWhiteLightgrayColor];
    centerViewUseful = [viewUseful center];
    
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake( horizontalSpace, 0, SCREEN_WIDTH-horizontalSpace*2, controlToolBarHeight)];
    [toolBar setTintColor:Ly517ThemeColor];
    UIBarButtonItem *btnItemCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(apTargetForBarButtonItem:)];
    [btnItemCancel setTag:LyControlBarButtonItemMode_cancel];
    UIBarButtonItem *btnItemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *btnItemDone = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(apTargetForBarButtonItem:)];
    [btnItemDone setTag:LyControlBarButtonItemMode_done];
    
    switch ( _mode) {
        case LyAddressPickerMode_all: {
            [toolBar setItems:@[btnItemCancel, btnItemSpace, btnItemDone]];
            break;
        }
        case LyAddressPickerMode_provinceAndCity: {
            [toolBar setItems:@[btnItemCancel, btnItemSpace, btnItemDone]];
            break;
        }
        case LyAddressPickerMode_map: {
            
            UIBarButtonItem *btnItemLocate = [[UIBarButtonItem alloc] initWithTitle:@"自动定位" style:UIBarButtonItemStyleDone target:self action:@selector(apTargetForBarButtonItem:)];
            [btnItemLocate setTag:LyControlBarButtonItemMode_ext];
            [toolBar setItems:@[btnItemCancel, btnItemSpace, btnItemLocate, btnItemDone]];
            break;
        }
        case LyAddressPickerMode_addGuider: {
            [toolBar setItems:@[btnItemCancel, btnItemSpace, btnItemDone]];
            break;
        }
        case LyAddressPickerMode_landMark: {
            [toolBar setItems:@[btnItemCancel, btnItemSpace, btnItemDone]];
            break;
        }
        default: {
            [toolBar setItems:@[btnItemCancel, btnItemSpace, btnItemDone]];
            break;
        }
    }
    
    
    
    
    
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake( 0, toolBar.ly_y+CGRectGetHeight(toolBar.frame), SCREEN_WIDTH, controlPickerHeight)];
    [picker setDelegate:self];
    [picker setDataSource:self];
//    [picker setShowsSelectionIndicator:YES];
    
    [viewUseful addSubview:toolBar];
    [viewUseful addSubview:picker];
    
    
    [self addSubview:viewUseful];
}





- (void)apTargetForButtonItem:(UIButton *)button
{
    switch ( [button tag])
    {
        case LyControlBarButtonItemMode_cancel:
        {
            if ( [_delegate respondsToSelector:@selector(onAddressPickerCancel:)])
            {
                [_delegate onAddressPickerCancel:self];
            }
            break;
        }
            
        default:
        {
            break;
        }
    }
}


- (void)apTargetForBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    
    switch ( [barButtonItem tag])
    {
        case LyControlBarButtonItemMode_cancel:
        {
            if ( [_delegate respondsToSelector:@selector(onAddressPickerCancel:)])
            {
                [_delegate onAddressPickerCancel:self];
            }
            break;
        }
            
        case LyControlBarButtonItemMode_done:
        {
            switch ( _mode) {
                case LyAddressPickerMode_all: {
                    
                    NSInteger rowDistrict = [picker selectedRowInComponent:2];
                    currentDistrict = [_arrDistricts objectAtIndex:rowDistrict];
                    
                    _address = [[NSString alloc] initWithFormat:@"%@ %@ %@", currentProvince, currentCity, currentDistrict];
                    break;
                }
                case LyAddressPickerMode_provinceAndCity: {
                    NSInteger rowCity = [picker selectedRowInComponent:1];
                    currentCity = [arrCity objectAtIndex:rowCity];
                    
                    _address = [[NSString alloc] initWithFormat:@"%@ %@", currentProvince, currentCity];
                    break;
                }
                case LyAddressPickerMode_landMark: {
                    NSInteger rowCity = [picker selectedRowInComponent:1];
                    currentCity = [arrCity objectAtIndex:rowCity];
                    
                    _address = [[NSString alloc] initWithFormat:@"%@ %@", currentProvince, currentCity];
                    
                    
//                    NSInteger rowCity = [picker selectedRowInComponent:1];
//                    currentCity = [arrCity objectAtIndex:rowCity];
                    
                    NSString *provinceIndex = [[NSString alloc] initWithFormat: @"%ld", [arrProvince indexOfObject: currentProvince]];
                    NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [dicAllArea objectForKey: provinceIndex]];
                    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey:currentProvince]];
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
                    _arrDistricts = [NSArray arrayWithArray:[cityDic objectForKey:[cityKeyArray objectAtIndex:0]]];
                    
                    break;
                }
                default: {
                    NSInteger rowDistrict = [picker selectedRowInComponent:2];
                    currentDistrict = [_arrDistricts objectAtIndex:rowDistrict];
                    
                    _address = [[NSString alloc] initWithFormat:@"%@ %@ %@", currentProvince, currentCity, currentDistrict];
                    break;
                }
            }

            

            if ( [_delegate respondsToSelector:@selector(onAddressPickerDone:addressPicker:)])
            {
                [_delegate onAddressPickerDone:_address addressPicker:self];
            }
            break;
        }
            
        case LyControlBarButtonItemMode_ext: {
            if ( [_delegate respondsToSelector:@selector(onAddressPickerAutoLocate:)])
            {
                [_delegate onAddressPickerAutoLocate:self];
            }
            break;
        }
        default: {
            if ( [_delegate respondsToSelector:@selector(onAddressPickerCancel:)])
            {
                [_delegate onAddressPickerCancel:self];
            }
            break;
        }
    }
    
    
}



- (void)reloadWithAddress:(NSString *)address {
    
    if (!address) {
        address = _address;
    }
    
    if (!address) {
        return;
    }
    
    NSArray *arr = [LyUtil separateString:address separator:@" "];
    
    switch ( _mode) {
        case LyAddressPickerMode_all: {
            
            if ( [arr count] < 3) {
                return;
            }
            NSString *strProvince = [arr objectAtIndex:0];
            NSString *strCity = [arr objectAtIndex:1];
            NSString *strDistrict = [arr objectAtIndex:2];
            
            NSInteger indexProvince = [arrProvince indexOfObject:strProvince];
            if ( indexProvince < 0 ||  indexProvince > [picker numberOfRowsInComponent:0])
            {
                return;
            }
            [picker selectRow:indexProvince inComponent:0 animated:NO];
            [picker reloadComponent:1];
            
            NSInteger indexCity = [arrCity indexOfObject:strCity];
            if ( indexCity < 0 || indexCity > [picker numberOfRowsInComponent:1])
            {
                return;
            }
            [picker selectRow:indexCity inComponent:1 animated:NO];
            [picker reloadComponent:2];
            
            NSInteger indexDistrict = [_arrDistricts indexOfObject:strDistrict];
            if ( indexDistrict < 0 || indexDistrict > [picker numberOfRowsInComponent:2])
            {
                return;
            }
            [picker selectRow:indexDistrict inComponent:2 animated:NO];
            break;
        }
        case LyAddressPickerMode_provinceAndCity: {
            
            if ( [arr count] < 2)
            {
                return;
            }
            NSString *strProvince = [arr objectAtIndex:0];
            NSString *strCity = [arr objectAtIndex:1];
            
            
            NSInteger indexProvince = [arrProvince indexOfObject:strProvince];
            if ( indexProvince < 0 ||  indexProvince > [picker numberOfRowsInComponent:0])
            {
                return;
            }
            [picker selectRow:indexProvince inComponent:0 animated:NO];
            [picker reloadComponent:1];
            
            NSInteger indexCity = [arrCity indexOfObject:strCity];
            if ( indexCity < 0 || indexCity > [picker numberOfRowsInComponent:1])
            {
                return;
            }
            [picker selectRow:indexCity inComponent:1 animated:NO];
            
            break;
        }
        case LyAddressPickerMode_map: {
            if ( [arr count] < 3)
            {
                return;
            }
            NSString *strProvince = [arr objectAtIndex:0];
            NSString *strCity = [arr objectAtIndex:1];
            NSString *strDistrict = [arr objectAtIndex:2];
            
            NSInteger indexProvince = [arrProvince indexOfObject:strProvince];
            if ( indexProvince < 0 ||  indexProvince > [picker numberOfRowsInComponent:0])
            {
                return;
            }
            [picker selectRow:indexProvince inComponent:0 animated:NO];
            [picker reloadComponent:1];
            
            NSInteger indexCity = [arrCity indexOfObject:strCity];
            if ( indexCity < 0 || indexCity > [picker numberOfRowsInComponent:1])
            {
                return;
            }
            [picker selectRow:indexCity inComponent:1 animated:NO];
            [picker reloadComponent:2];
            
            NSInteger indexDistrict = [_arrDistricts indexOfObject:strDistrict];
            if ( indexDistrict < 0 || indexDistrict > [picker numberOfRowsInComponent:2])
            {
                return;
            }
            [picker selectRow:indexDistrict inComponent:2 animated:NO];
            break;
        }
        case LyAddressPickerMode_addGuider: {
            break;
        }
        case LyAddressPickerMode_landMark: {
            if ( [arr count] < 2)
            {
                return;
            }
            NSString *strProvince = [arr objectAtIndex:0];
            NSString *strCity = [arr objectAtIndex:1];
            
            
            NSInteger indexProvince = [arrProvince indexOfObject:strProvince];
            if ( indexProvince < 0 ||  indexProvince > [picker numberOfRowsInComponent:0])
            {
                return;
            }
            [picker selectRow:indexProvince inComponent:0 animated:NO];
            [picker reloadComponent:1];
            
            NSInteger indexCity = [arrCity indexOfObject:strCity];
            if ( indexCity < 0 || indexCity > [picker numberOfRowsInComponent:1])
            {
                return;
            }
            [picker selectRow:indexCity inComponent:1 animated:NO];
            
            
            
            
            NSInteger rowCity = [picker selectedRowInComponent:1];
            currentCity = [arrCity objectAtIndex:rowCity];
            
            NSString *provinceIndex = [[NSString alloc] initWithFormat: @"%ld", [arrProvince indexOfObject: currentProvince]];
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [dicAllArea objectForKey: provinceIndex]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey:currentProvince]];
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
            _arrDistricts = [NSArray arrayWithArray:[cityDic objectForKey:[cityKeyArray objectAtIndex:0]]];
            
            break;
        }
    }

    
}


//- (void)setAddress:(NSString *)address {
//    
//    _address = address;
//}





- (void)showInView:(UIView *)view {
    [self show];
}


- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [self reloadWithAddress:_address];
    
    
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
    
    
    [LyUtil startAnimationWithView:btnBig
                                  animationDuration:0.3
                                          initAlpha:1.0f
                                  destinationAplhas:0.0f
                                          comletion:^(BOOL finished) {
                                              [self removeFromSuperview];
                                              
                                              [viewUseful setCenter:centerViewUseful];
                                              [btnBig setAlpha:1.0f];
                                          }];
    
    
    
}



- (void)analysisAreaInfo
{
    NSString *plistPath = [LyUtil filePathForFileName:@"area.plist"];
    
    if ( !plistPath || [plistPath isEqualToString:@""])
    {
        return;
    }
    
    dicAllArea = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    if ( !dicAllArea || ![dicAllArea count])
    {
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
    
    currentCity = [arrCity objectAtIndex:0];
    _arrDistricts = [NSArray arrayWithArray:[cityDic objectForKey:currentCity]];
    
    currentProvince = [arrProvince objectAtIndex:0];
    currentDistrict = [_arrDistricts objectAtIndex:0];
    
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
        NSString *text;
        if ( 0 == component)
        {
            text = [arrProvince objectAtIndex:row];
        }
        else if ( 1 == component)
        {
            text = [arrCity objectAtIndex:row];
        }
        else if ( 2 == component)
        {
            text = [_arrDistricts objectAtIndex:row];
        }
        
        text;
    })];
    [picker clearSpearator];
    
    return lbRow;
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch ( _mode) {
        case LyAddressPickerMode_all: {
            
            if ( 0 == component)
            {
                [pickerView selectRow:0 inComponent:1 animated:NO];
                [pickerView reloadComponent:1];
                [pickerView selectRow:0 inComponent:2 animated:NO];
                [pickerView reloadComponent:2];
            }
            else if ( 1 == component)
            {
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:NO];
            }
            break;
        }
        case LyAddressPickerMode_provinceAndCity: {
            
            if ( 0 == component)
            {
                [pickerView selectRow:0 inComponent:1 animated:NO];
                [pickerView reloadComponent:1];
            }
            break;
        }
        case LyAddressPickerMode_map: {
            if ( 0 == component)
            {
                [pickerView selectRow:0 inComponent:1 animated:NO];
                [pickerView reloadComponent:1];
                [pickerView selectRow:0 inComponent:2 animated:NO];
                [pickerView reloadComponent:2];
            }
            else if ( 1 == component)
            {
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:NO];
            }
            break;
        }
        case LyAddressPickerMode_addGuider: {
            
            break;
        }
        case LyAddressPickerMode_landMark: {
            if ( 0 == component)
            {
                [pickerView selectRow:0 inComponent:1 animated:NO];
                [pickerView reloadComponent:1];
            }
            else if (1 == component)
            {
                NSInteger rowCity = [pickerView selectedRowInComponent:1];
                currentCity = [arrCity objectAtIndex:rowCity];
                
                NSString *provinceIndex = [[NSString alloc] initWithFormat: @"%ld", [arrProvince indexOfObject: currentProvince]];
                NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [dicAllArea objectForKey: provinceIndex]];
                NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey:currentProvince]];
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
                _arrDistricts = [NSArray arrayWithArray:[cityDic objectForKey:[cityKeyArray objectAtIndex:0]]];
            }
            break;
        }
            
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
    switch ( _mode) {
        case LyAddressPickerMode_all: {
            return 3;
            break;
        }
        case LyAddressPickerMode_provinceAndCity: {
            return 2;
            break;
        }
        case LyAddressPickerMode_map: {
            return 3;
            break;
        }
        case LyAddressPickerMode_addGuider: {
            return 1;
            break;
        }
        case LyAddressPickerMode_landMark: {
            return 2;
            break;
        }
        default: {
            return 3;
            break;
        }
    }
    
    return 3;
}



//该方法的返回值决定该控件指定列包含多少个列表项
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (0 == component)
    {
        if ( LyAddressPickerMode_addGuider == _mode)
        {
            return [_citys count];
        }
            
        return [arrProvince count];
    }
    if ( 1 == component)
    {
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        currentProvince = [arrProvince objectAtIndex:rowProvince];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [dicAllArea objectForKey: [[NSString alloc] initWithFormat:@"%d", (int)rowProvince]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: currentProvince]];
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
    }
    else if ( 2 == component)
    {
        NSInteger rowCity = [pickerView selectedRowInComponent:1];
        currentCity = [arrCity objectAtIndex:rowCity];
        
        NSString *provinceIndex = [[NSString alloc] initWithFormat: @"%ld", [arrProvince indexOfObject: currentProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [dicAllArea objectForKey: provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey:currentProvince]];
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
        _arrDistricts = [NSArray arrayWithArray:[cityDic objectForKey:[cityKeyArray objectAtIndex:0]]];
        
        
        return [_arrDistricts count];
    }
    
    
    return 0;
}




@end
