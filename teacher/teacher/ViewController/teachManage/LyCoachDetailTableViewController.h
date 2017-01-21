//
//  LyCoachDetailTableViewController.h
//  teacher
//
//  Created by Junes on 16/8/31.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LyCoachDetailTableViewController;


@protocol LyCoachDetailTableViewControllerDelegate <NSObject>

- (NSString *)obtainCoachIdByCoachDetailTVC:(LyCoachDetailTableViewController *)aCoachDetailTVC;

- (void)onDeleteByCoachDetailTVC:(LyCoachDetailTableViewController *)aCoachDetailTVC;

@end



@interface LyCoachDetailTableViewController : UITableViewController

@property (retain, nonatomic)       NSString                                            *coachId;

@property (weak, nonatomic)         id<LyCoachDetailTableViewControllerDelegate>        delegate;

@end
