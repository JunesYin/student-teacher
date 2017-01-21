//
//  LyUpdateCoachTrainBaseTableViewController.h
//  teacher
//
//  Created by Junes on 16/9/7.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LyCoach;
@class LyTrainBase;
@protocol LyUpdateCoachTrainBaseTableViewControllerDelegate;

@interface LyUpdateCoachTrainBaseTableViewController : UITableViewController

@property (weak, nonatomic)     id<LyUpdateCoachTrainBaseTableViewControllerDelegate>      delegate;

@property (retain, nonatomic)   LyTrainBase                     *trainBase;

@end



@protocol LyUpdateCoachTrainBaseTableViewControllerDelegate <NSObject>

- (LyCoach *)obtainCoachByUpdateCoachTrainBaseTVC:(LyUpdateCoachTrainBaseTableViewController *)aUpdateCoachTrainBaseTVC;

- (void)onDoneByUpdateCoachTrainBaseTVC:(LyUpdateCoachTrainBaseTableViewController *)aUpdateCoachTrainBaseTVC trainBase:(LyTrainBase *)aTrainBase;

@end
