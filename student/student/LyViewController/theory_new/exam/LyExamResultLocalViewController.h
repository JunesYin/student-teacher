//
//  LyExamResultLocalViewController.h
//  student
//
//  Created by MacMini on 2016/12/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LyExamResultLocalViewControllerDelegate;

@interface LyExamResultLocalViewController : UIViewController

@property (weak, nonatomic)     id<LyExamResultLocalViewControllerDelegate>     delegate;

@property (retain, nonatomic)       NSArray         *arrQuestion;
@property (assign, nonatomic)       NSInteger       useMinutes;

@property (assign, nonatomic)       NSInteger       score;

@end



@protocol LyExamResultLocalViewControllerDelegate <NSObject>

@required
- (void)onReexamByExamResultLocalViewController:(LyExamResultLocalViewController *)aExamResultVC;

@end
