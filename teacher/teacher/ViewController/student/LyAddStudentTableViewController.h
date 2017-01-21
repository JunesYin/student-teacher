//
//  LyAddStudentTableViewController.h
//  teacher
//
//  Created by Junes on 16/8/17.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LyAddStudentTableViewControllerDelegate;

@interface LyAddStudentTableViewController : UITableViewController

@property (weak, nonatomic)     id<LyAddStudentTableViewControllerDelegate>     delegate;

@end


@protocol LyAddStudentTableViewControllerDelegate <NSObject>

@optional
- (void)onAddDoneByAddStudentTVC:(LyAddStudentTableViewController *)aAddStudentTVC;

@end
