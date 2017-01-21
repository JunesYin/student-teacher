//
//  LyLicenseInfoPicker.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/25.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyUtil.h"


@class LyLicenseInfoPicker;


@protocol LyLicenseInfoPickerDelegate <NSObject>

@optional
- (void)onLicenseInfoPickerCancel:(LyLicenseInfoPicker *)licenseInfoPicker;

- (void)onLicenseInfoPickerDone:(LyLicenseInfoPicker *)licenseInfoPicker andLicense:(LyLicenseType)license andObject:(LySubjectMode)subject;

@end


@interface LyLicenseInfoPicker : UIView

@property ( assign, nonatomic)      LyLicenseType                           license;

@property ( assign, nonatomic)      LySubjectMode                           subject;

@property ( assign, nonatomic)      id<LyLicenseInfoPickerDelegate>         delegate;

- (void)show;


- (void)hide;

- (void)setLicense:(LyLicenseType)license andObject:(LySubjectMode)subject;


@end
