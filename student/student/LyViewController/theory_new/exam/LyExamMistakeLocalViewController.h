//
//  LyExamMistakeLocalViewController.h
//  student
//
//  Created by MacMini on 2016/12/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LyExamMistakeLocalViewControllerDelegate;

@interface LyExamMistakeLocalViewController : UIViewController

@property (weak, nonatomic)     id<LyExamMistakeLocalViewControllerDelegate>        delegate;

@property (weak, nonatomic)     NSArray     *arrQuestion;

@end



@protocol LyExamMistakeLocalViewControllerDelegate <NSObject>

@required
- (void)onReexamByExamMistakeLocalViewController:(LyExamMistakeLocalViewController *)aExamMistakeLocalVC;

@end
