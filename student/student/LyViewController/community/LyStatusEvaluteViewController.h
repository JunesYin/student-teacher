//
//  LyStatusEvalutionViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/29.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyUtil.h"



@class LyStatus;
@class LyStatusEvaluteViewController;


@protocol LyStatusEvaluteViewControllerDelegate <NSObject>

@required
- (LyStatus *)obtainStatusByStatusEvalute:(LyStatusEvaluteViewController *)aStatusEvaluteViewController;

- (void)onCancelStatusEvalute:(LyStatusEvaluteViewController *)aStatusEvaluteViewController;

- (void)onDoneStatusEvalute:(LyStatusEvaluteViewController *)aStatusEvaluteViewController;

@end

@interface LyStatusEvaluteViewController : UIViewController


@property ( retain, nonatomic)          LyStatus            *status;

@property ( strong, nonatomic)          NSString            *content;


@property ( assign, nonatomic)          id<LyStatusEvaluteViewControllerDelegate>     delegate;


@end
