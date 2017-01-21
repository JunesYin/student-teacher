//
//  LyEvaluateOrderViewController.h
//  student
//
//  Created by Junes on 2016/11/28.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, LyEvaluateOrderViewControllerMode)
{
    LyEvaluateOrderViewControllerMode_evaluate,
    LyEvaluateOrderViewControllerMode_evaluateAgain
};


@class LyOrder;
@protocol LyEvaluateOrderViewControllerDelegate;

@interface LyEvaluateOrderViewController : UIViewController

@property (weak, nonatomic)     id<LyEvaluateOrderViewControllerDelegate>       delegate;
@property (assign, nonatomic)       LyEvaluateOrderViewControllerMode       mode;
@property (retain, nonatomic)       LyOrder     *order;

@end


@protocol LyEvaluateOrderViewControllerDelegate <NSObject>

@required
- (LyOrder *)obtainOrderByEvaluateOrderViewController:(LyEvaluateOrderViewController *)aEvaluateOrderVC;

@optional
- (void)onDoneByEvaluateOrderViewController:(LyEvaluateOrderViewController *)aEvaluateOrderVC;

@end
