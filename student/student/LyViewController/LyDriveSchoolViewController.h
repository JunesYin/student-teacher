//
//  LyDriveSchoolViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/31.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LySingleInstance.h"
#import "RESideMenu.h"



@class BMKMapView;
@class LyFloatView;

@interface LyDriveSchoolViewController : UIViewController



lySingle_interface

- (void)searchWillBegin;

- (void)search:(NSString *)strSearch;

- (void)openAddressPicker;




@end
