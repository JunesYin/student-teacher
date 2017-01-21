//
//  LyGuiderViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/21.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LySingleInstance.h"


@interface LyGuiderViewController : UIViewController

lySingle_interface

- (void)searchWillBegin;

- (void)search:(NSString *)strSearch;

- (void)openAddressPicker;

@end
