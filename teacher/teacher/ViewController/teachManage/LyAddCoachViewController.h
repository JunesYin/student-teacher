//
//  LyAddCoachViewController.h
//  teacher
//
//  Created by Junes on 16/8/13.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol LyAddCoachViewControllerDelegate;

@interface LyAddCoachViewController : UIViewController

@property (weak, nonatomic)     id<LyAddCoachViewControllerDelegate>        delegate;

@end



@protocol LyAddCoachViewControllerDelegate <NSObject>

- (void)onDoneByAddCoachVC:(LyAddCoachViewController *)aAddCoachVC;

@end