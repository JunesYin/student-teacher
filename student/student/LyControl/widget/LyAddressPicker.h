//
//  LyAddressPicker.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/5.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LyAddressPicker;



typedef NS_ENUM( NSInteger, LyAddressPickerMode)
{
    LyAddressPickerMode_all,
    LyAddressPickerMode_provinceAndCity,
    LyAddressPickerMode_map,
    LyAddressPickerMode_addGuider,
    LyAddressPickerMode_theoryStudy,
    LyAddressPickerMode_landMark
};



@protocol LyAddressPickerDelegate <NSObject>

@optional
- (void)onAddressPickerCancel:(LyAddressPicker *)addressPicker;

- (void)onAddressPickerDone:(NSString *)address addressPicker:(LyAddressPicker *)addressPicker;

- (void)onAddressPickerAutoLocate:(LyAddressPicker *)aAddressPicker;

@end

@interface LyAddressPicker : UIView

@property ( strong, nonatomic)              NSString                            *address;

@property ( assign, nonatomic, readonly)    LyAddressPickerMode                 mode;

@property ( retain, nonatomic)              NSArray                             *citys;

@property (retain, nonatomic)               NSArray                             *arrDistricts;

@property ( weak, nonatomic)                id<LyAddressPickerDelegate>         delegate;

+ (instancetype)addressPickerWithMode:(LyAddressPickerMode)mode;

- (instancetype)initWithMode:(LyAddressPickerMode)mode;

- (instancetype)initWithDatas:(NSArray *)datas;

- (void)setAddress:(NSString *)address;

- (void)show;

- (void)showInView:(UIView *)view;

- (void)hide;

@end
