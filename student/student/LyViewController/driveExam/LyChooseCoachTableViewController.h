//
//  LyChooseCoachTableViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/17.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>



@class LyCoach;
@class LyChooseCoachTableViewController;


@protocol LyChooseCoachTableViewControllerDelegate <NSObject>

- (NSString *)obtainDriveSchoolIdByChooseCoachTableViewController:(LyChooseCoachTableViewController *)aChooseCoachTableViewController;

- (void)onSelectedCoachByChooseCoachTableViewController:(LyChooseCoachTableViewController *)aChooseCoachTableViewController andCoach:(LyCoach *)coach;

@end

@interface LyChooseCoachTableViewController : UITableViewController

@property ( retain, nonatomic)  NSString                    *driveSchoolId;

@property ( weak, nonatomic)    id<LyChooseCoachTableViewControllerDelegate>        delegate;



@end
