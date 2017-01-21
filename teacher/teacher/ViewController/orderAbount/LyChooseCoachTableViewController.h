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

@required
- (void)onSelectedCoachByChooseCoachTVC:(LyChooseCoachTableViewController *)aChooseCoachTVC andCoach:(LyCoach *)coach;

@optional
- (NSString *)obtainMasterBossIdByChooseCoachTVC:(LyChooseCoachTableViewController *)aChooseCoachTVC;

- (NSString *)obtainTrainBaseIdByChooseCoachTVC:(LyChooseCoachTableViewController *)aChooseCoachTVC;

@end

@interface LyChooseCoachTableViewController : UITableViewController

@property ( retain, nonatomic)  NSString                    *masterbossId;
@property (retain, nonatomic)   NSString                    *trainBaseId;

@property ( weak, nonatomic)    id<LyChooseCoachTableViewControllerDelegate>        delegate;



@end
