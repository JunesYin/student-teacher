//
//  LyConsultTableViewController.h
//  student
//
//  Created by MacMini on 2016/12/28.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LyUser;
@protocol LyConsultTableViewControllerDelegate;

@interface LyConsultTableViewController : UITableViewController

@property (weak, nonatomic)     id<LyConsultTableViewControllerDelegate>        delegate;

@property (retain, nonatomic)       LyUser      *user;

@end


@protocol LyConsultTableViewControllerDelegate <NSObject>

- (LyUser *)userByConsultTableViewController:(LyConsultTableViewController *)aConsultTVC;

@end
