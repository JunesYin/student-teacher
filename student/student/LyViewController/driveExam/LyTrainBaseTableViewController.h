//
//  LyTrainBaseTableViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/17.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LyTrainBaseTableViewController;


@protocol LyTrainBaseTableViewControllerDelegate <NSObject>

- (NSString *)obtainDriveSchoolIdByTrainBaseTableViewController:(LyTrainBaseTableViewController *)aTrainBase;

- (NSArray *)obtainArrTrainBaseByTrainBaseTableViewController:(LyTrainBaseTableViewController *)aTrainBase;

@end

@interface LyTrainBaseTableViewController : UITableViewController

@property ( retain, nonatomic)  NSString            *driveSchoolId;

@property ( retain, nonatomic)  NSArray             *arrTrainBase;

@property ( weak, nonatomic)    id<LyTrainBaseTableViewControllerDelegate>      delegate;



@end
