//
//  LyAddTrainBaseTableViewController.h
//  teacher
//
//  Created by Junes on 16/9/5.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LyTrainBase;
@protocol LyAddTrainBaseTableViewControllerDelegate;



@interface LyAddTrainBaseTableViewController : UITableViewController


@property (weak, nonatomic)     id<LyAddTrainBaseTableViewControllerDelegate>      delegate;

@property (retain, nonatomic)   LyTrainBase                     *trainBase;



@end




@protocol LyAddTrainBaseTableViewControllerDelegate <NSObject>

@required
- (NSArray *)trainBaseInfoByAddTrainBaseTVC:(LyAddTrainBaseTableViewController *)aAddTrainBaseTVC;

@optional
- (void)onDoneByAddTrainBaseTVC:(LyAddTrainBaseTableViewController *)aAddTrainBaseVC trainBase:(LyTrainBase *)aTrainBase;

@end
