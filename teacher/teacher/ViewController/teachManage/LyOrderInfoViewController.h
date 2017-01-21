//
//  LyOrderInfoViewController.h
//  teacher
//
//  Created by Junes on 16/8/15.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>



@class LyOrderInfoViewController;

@protocol LyOrderInfoViewControllerDelegate <NSObject>

- (NSString *)obtainCoachIdByOrderInfoVC:(LyOrderInfoViewController *)aOrderInfoVC;

@end


@interface LyOrderInfoViewController : UIViewController

@property (retain, nonatomic)       NSString                                    *coachId;

@property (weak, nonatomic)         id<LyOrderInfoViewControllerDelegate>       delegate;

@end
