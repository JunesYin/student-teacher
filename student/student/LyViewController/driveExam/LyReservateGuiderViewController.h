//
//  LyReservateGuiderViewController.h
//  student
//
//  Created by Junes on 16/9/13.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LyReservateGuiderViewControllerDelegate;

@interface LyReservateGuiderViewController : UIViewController

@property (retain, nonatomic)   NSString            *guiderId;

@property (weak, nonatomic)     id<LyReservateGuiderViewControllerDelegate>     delegate;

@end



@protocol LyReservateGuiderViewControllerDelegate <NSObject>

@required
- (NSString *)obtainGuiderIdByReservateGuiderVC:(LyReservateGuiderViewController *)aReservateGuiderVC;

@end
