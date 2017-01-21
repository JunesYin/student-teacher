//
//  LyEvaluationForTeacherTableViewController.h
//  student
//
//  Created by MacMini on 2016/12/28.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LyUser;
@protocol LyEvaluationForTeacherTableViewControllerDelegate;



@interface LyEvaluationForTeacherTableViewController : UITableViewController

@property (weak, nonatomic)     id<LyEvaluationForTeacherTableViewControllerDelegate>       delegate;

@property (retain, nonatomic)       LyUser      *user;

@end


@protocol LyEvaluationForTeacherTableViewControllerDelegate <NSObject>

- (LyUser *)userByEvaluationForTeacherTableViewController:(LyEvaluationForTeacherTableViewController *)aEvaluationTVC;

@end
