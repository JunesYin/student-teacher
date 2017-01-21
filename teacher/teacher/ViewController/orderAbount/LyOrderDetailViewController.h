//
//  LyOrderDetailViewController.h
//  teacher
//
//  Created by Junes on 16/8/16.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LyOrder;
@protocol LyOrderDetailViewControllerDelegate;


@interface LyOrderDetailViewController : UIViewController

@property (weak, nonatomic)         id<LyOrderDetailViewControllerDelegate>     delegate;

@property (retain, nonatomic)       LyOrder                 *order;

@end


@protocol LyOrderDetailViewControllerDelegate <NSObject>

@optional
- (LyOrder *)obtainOrderByOrderDetailVC:(LyOrderDetailViewController *)aOrderDetailVC;



@end
