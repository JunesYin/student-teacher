//
//  LyEvaluationForTeacherDetailTableViewController.h
//  student
//
//  Created by MacMini on 2016/12/28.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LyEvaluationForTeacher;
@protocol LyEvaluationForTeacherDetailTableViewControllerDelegate;


@interface LyEvaluationForTeacherDetailTableViewController : UITableViewController

@property (weak, nonatomic)     id<LyEvaluationForTeacherDetailTableViewControllerDelegate>     delegate;

@property (retain, nonatomic)       LyEvaluationForTeacher      *eva;

@end


@protocol LyEvaluationForTeacherDetailTableViewControllerDelegate <NSObject>

- (LyEvaluationForTeacher *)evaluationForTeacherByEvaluationForTeacherDetailTableViewController:(LyEvaluationForTeacherDetailTableViewController *)aEvaluationForTeacherDetailTVC;

@end
