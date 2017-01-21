//
//  LyTheoryStudyViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/21.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LySingleInstance.h"






@interface LyTheoryStudyViewController : UIViewController


@property ( strong, nonatomic)                  UIBarButtonItem                 *tsLeftBarBtnItem;
@property ( strong, nonatomic)                  UIBarButtonItem                 *tsRightBarBtnItem;


lySingle_interface

- (void)showAddressPicker;

- (void)showLicenseInfoPicker;

@end
