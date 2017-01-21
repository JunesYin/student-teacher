//
//  LyOrderDispatchTableViewController.h
//  teacher
//
//  Created by Junes on 16/9/10.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LyCoach;
@protocol LyOrderDispatchTableViewControllerDelegate;

@interface LyOrderDispatchTableViewController : UITableViewController

@property (retain, nonatomic)   NSString                    *orderId;
@property (weak, nonatomic)     id<LyOrderDispatchTableViewControllerDelegate>      delegate;

@end



@protocol LyOrderDispatchTableViewControllerDelegate <NSObject>

@required
- (NSString *)obtainOrderIdByOrderDispatchTVC:(LyOrderDispatchTableViewController *)aOrderDispatchTVC;

- (void)onDisptachByOrderDispatchTVC:(LyOrderDispatchTableViewController *)aOrderDispatchTVC coach:(LyCoach *)coach;

@end