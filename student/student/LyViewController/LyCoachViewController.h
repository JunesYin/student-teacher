//
//  LyCoachViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/21.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LySingleInstance.h"
#import "RESideMenu.h"


@interface LyCoachViewController : UIViewController


lySingle_interface

- (void)searchWillBegin;

- (void)search:(NSString *)strSearch;

- (void)openAddressPicker;



@end
