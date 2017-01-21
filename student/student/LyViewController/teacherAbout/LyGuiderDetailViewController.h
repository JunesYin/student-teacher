//
//  LyGuiderDetailViewController.h
//  student
//
//  Created by MacMini on 2016/12/23.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LyGuiderDetailViewControllerDelegate;

@interface LyGuiderDetailViewController : UIViewController

@property (weak, nonatomic)     id<LyGuiderDetailViewControllerDelegate>        delegate;

@property (copy, nonatomic)     NSString        *userId;

@end



@protocol LyGuiderDetailViewControllerDelegate <NSObject>

- (NSString *)userIdByGuiderDetailViewController:(LyGuiderDetailViewController *)aGuiderDetailVC;

@end
