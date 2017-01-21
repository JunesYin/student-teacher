//
//  LyPaySuccessViewController.h
//  student
//
//  Created by Junes on 2016/11/24.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "ViewController.h"
#import "LyPayManager.h"

@class LyOrder;
@protocol LyPaySuccessViewControllerDelegate;

@interface LyPaySuccessViewController : ViewController

@property (weak, nonatomic)     id<LyPaySuccessViewControllerDelegate>      delegate;

@property (retain, nonatomic)       LyOrder         *order;
@property (assign, nonatomic)       LyPayMode       payMode;
@property (assign, nonatomic)       float           discount;

@end


@protocol LyPaySuccessViewControllerDelegate <NSObject>

@optional
- (void)onCloseByPayViewController:(LyPaySuccessViewController *)aPaySuccessVC;

@end
