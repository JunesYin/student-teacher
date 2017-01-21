//
//  LySendNewsViewController.h
//  teacher
//
//  Created by Junes on 2016/10/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LySendNewsViewControllerDelegate;

@interface LySendNewsViewController : UIViewController

@property (nonatomic, weak)     id<LySendNewsViewControllerDelegate>    delegate;

@end


@protocol LySendNewsViewControllerDelegate <NSObject>

@required
- (void)onDoneBySendNewsVC:(LySendNewsViewController *)aSendNewsVC;

@end

