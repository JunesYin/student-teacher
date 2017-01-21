//
//  LyAutoLoginViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/3.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>



@class LyAutoLoginViewController;
@protocol LyAutoLoginViewControllerDelegate <NSObject>

@required
- (void)onAutoFinished:(UIViewController *)vc isLogined:(BOOL)isLogined;


@end


@interface LyAutoLoginViewController : UIViewController

@property ( weak, nonatomic)            id<LyAutoLoginViewControllerDelegate>       delegate;



@end
