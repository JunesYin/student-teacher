//
//  LyExamingLocalViewController.h
//  student
//
//  Created by MacMini on 2016/12/16.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LyExamingLocalViewControllerDelegate;


@interface LyExamingLocalViewController : UIViewController

@property (weak, nonatomic)     id<LyExamingLocalViewControllerDelegate>        delegate;

@property (retain, nonatomic)       NSMutableArray      *arrQuestion;

@end



@protocol LyExamingLocalViewControllerDelegate <NSObject>

@required
- (void)onCommitByExamingLocalViewController:(LyExamingLocalViewController *)aExamingLocalVC arrQuestion:(NSArray *)arrQuestion useMinutes:(NSInteger)useMinutes;

@optional
- (void)onCloseByExamingLocalViewController:(LyExamingLocalViewController *)aExamingLocalVC;

@end
