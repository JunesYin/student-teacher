//
//  LyConsultDetailTableViewController.h
//  student
//
//  Created by MacMini on 2016/12/28.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LyConsult;
@protocol LyConsultDetailTableViewControllerDelegate;

@interface LyConsultDetailTableViewController : UITableViewController

@property (weak, nonatomic)     id<LyConsultDetailTableViewControllerDelegate>      delegate;

@property (retain, nonatomic)       LyConsult       *con;

@end

@protocol LyConsultDetailTableViewControllerDelegate <NSObject>

- (LyConsult *)consultByConsultDetailTableViewController:(LyConsultDetailTableViewController *)aConsultDetailTVC;

@end
