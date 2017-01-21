//
//  LyRegisterSecondViewController.h
//  teacher
//
//  Created by Junes on 16/7/22.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyUtil.h"


@class LyRegisterSecondViewController;

@protocol RegisterSecondDelegate <NSObject>

@required
- (LyUserType)obtainUsetType:(LyRegisterSecondViewController *)rsVc;

@end

@interface LyRegisterSecondViewController : UIViewController

@property (weak, nonatomic)         id<RegisterSecondDelegate>          delegate;

@property (assign, nonatomic)       LyUserType                          userType;

@end
