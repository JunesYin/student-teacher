//
//  LyCreateOrderViewController.h
//  student
//
//  Created by Junes on 2016/11/7.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LyTrainClass;


@protocol LyCreateOrderViewControllerDelegate;


@interface LyCreateOrderViewController : UIViewController

@property (weak, nonatomic)                     id<LyCreateOrderViewControllerDelegate> delegate;

@property (strong, nonatomic, readonly)         NSDictionary                *goodsInfo;



@end


@protocol LyCreateOrderViewControllerDelegate <NSObject>

@required
- (NSDictionary *)obtainGoodsInfo_crateOrder;

@end
