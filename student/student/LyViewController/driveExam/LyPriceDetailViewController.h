//
//  LyPriceDetailViewController.h
//  student
//
//  Created by Junes on 2016/9/27.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol LyPriceDetailViewControllerDelegate;

@interface LyPriceDetailViewController : UIViewController

@property (weak, nonatomic)     id<LyPriceDetailViewControllerDelegate>     delegate;

@property (retain, nonatomic)   NSString            *teacherId;

@end



@protocol LyPriceDetailViewControllerDelegate <NSObject>

@required
- (NSString *)obtainTeacherIdByPriceDetailVC:(LyPriceDetailViewController *)aPriceDetailVC;

@end
