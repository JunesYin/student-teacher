//
//  LyChooseSchoolTableViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/16.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LyDriveSchool;
@class LyChooseSchoolTableViewController;

@protocol LyChooseSchoolTableViewControllerDelegate <NSObject>

- (NSString *)obtainAddressInfoByChooseSchoolTableViewController:(LyChooseSchoolTableViewController *)aChooseSchoolTableViewContoller;

- (void)onSelectedDriveSchoolByChooseSchoolTableViewController:(LyChooseSchoolTableViewController *)aChooseSchoolTableViewContoller andSchool:(LyDriveSchool *)dsch;

@end


@interface LyChooseSchoolTableViewController : UITableViewController

@property ( retain, nonatomic)      NSString            *address;

@property ( weak, nonatomic)        id<LyChooseSchoolTableViewControllerDelegate>                 delegate;



@end
