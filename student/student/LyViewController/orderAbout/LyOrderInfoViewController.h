//
//  LyOrderInfoViewController.h
//  student
//
//  Created by Junes on 2016/11/28.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LyOrder;
@protocol LyOrderInfoViewControllerdelegate;


@interface LyOrderInfoViewController : UIViewController

@property (weak, nonatomic)     id<LyOrderInfoViewControllerdelegate>       delegate;
@property (retain, nonatomic)     LyOrder         *order;


@end


@protocol LyOrderInfoViewControllerdelegate <NSObject>

@required
- (LyOrder *)obtainOrderByOrderInfoViewController:(LyOrderInfoViewController *)aOrderInfoVC;

@end
