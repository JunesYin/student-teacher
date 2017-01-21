//
//  LyAutoLoginViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/3.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol LyAutoLoginViewControllerDelegate <NSObject>

@required
- (void)onAutoFinished:(UIViewController *)viewController;


@end


@interface LyAutoLoginViewController : UIViewController

@property ( weak, nonatomic)            id<LyAutoLoginViewControllerDelegate>       delegate;



@end
