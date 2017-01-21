//
//  LyAddSchoolTableViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/17.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyUtil.h"




@class LyDriveSchool;
@class LyAddSchoolTableViewController;


@protocol LyAddSchoolTableViewControllerDelegate <NSObject>

- (LyAddTeacherMode)obtainModeViewControllerModeByAddSchoolTableViewController:(LyAddSchoolTableViewController *)aAddSchool;

- (void)addSchoolFinishedByAddSchoolTableViewController:(LyAddSchoolTableViewController *)aAddSchool andDriveSchool:(LyDriveSchool *)driveSchool;

@end


@interface LyAddSchoolTableViewController : UITableViewController

@property ( assign, nonatomic)      LyAddTeacherMode         mode;

@property ( weak, nonatomic)    id<LyAddSchoolTableViewControllerDelegate>      delegate;



@end
