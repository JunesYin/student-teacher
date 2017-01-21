//
//  LyCoachDetailViewController.h
//  student
//
//  Created by MacMini on 2016/12/23.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LyCoachDetailViewControllerDelegate;

@interface LyCoachDetailViewController : UIViewController

@property (weak, nonatomic)     id<LyCoachDetailViewControllerDelegate>     delegate;

@property (copy, nonatomic)     NSString        *coachId;

@end


@protocol LyCoachDetailViewControllerDelegate <NSObject>

- (NSString *)coachIdByCoachDetailViewController:(LyCoachDetailViewController *)aCoachDetailVC;

@end
