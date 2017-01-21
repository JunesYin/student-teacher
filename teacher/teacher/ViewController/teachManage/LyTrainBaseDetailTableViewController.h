//
//  LyTrainBaseDetailTableViewController.h
//  teacher
//
//  Created by Junes on 16/8/26.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LyTrainBase;
@protocol LyTrainBaseDetailTableViewControllerDelegate;

@interface LyTrainBaseDetailTableViewController : UITableViewController

@property (retain, nonatomic)       LyTrainBase             *trainBase;

@property (weak, nonatomic)         id<LyTrainBaseDetailTableViewControllerDelegate>     delegate;

@end




@protocol LyTrainBaseDetailTableViewControllerDelegate <NSObject>

@required
//- (LyTrainBase *)obtainTrainBaseByTrainBaseDetailTVC:(LyTrainBaseDetailTableViewController *)aTrainBaseDetailTVC;
- (NSDictionary *)trainBaseInfoByTrainBaseDetailTVC:(LyTrainBaseDetailTableViewController *)aTrainBaseDetailTVC;

- (void)onDeleteByTrainBaseDetailTVC:(LyTrainBaseDetailTableViewController *)aTrainBaseDetailTVC;

@end
