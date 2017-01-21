//
//  LySendStatusViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/1.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>



@class LySendStatusViewController;

@protocol LySendStatusViewControllerDelegate <NSObject>

@optional
- (void)onSendStatusSucess:(LySendStatusViewController *)ssvc;

@end


@interface LySendStatusViewController : UIViewController

@property ( weak, nonatomic)                        id<LySendStatusViewControllerDelegate>  delegate;


@end
