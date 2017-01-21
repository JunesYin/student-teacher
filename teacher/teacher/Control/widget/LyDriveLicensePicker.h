//
//  LyDriveLicensePicker.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/6.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyUtil.h"


@class LyDriveLicensePicker;

@protocol LyDriveLicensePickerDelegate <NSObject>

@optional
- (void)onDriveLicensePickerCancel:(LyDriveLicensePicker *)picker;

- (void)onDriveLicensePickerDone:(LyDriveLicensePicker *)picker license:(LyLicenseType)license;

@end


@interface LyDriveLicensePicker : UIView

@property ( assign, nonatomic, readonly)        LyLicenseType                           license;
@property ( weak, nonatomic)                    id<LyDriveLicensePickerDelegate>        delegate;


+ (instancetype)driveLicensePicker;

- (void)setInitDriveLicense:(LyLicenseType)newLicenseType;

- (void)show;

- (void)hide;

@end
