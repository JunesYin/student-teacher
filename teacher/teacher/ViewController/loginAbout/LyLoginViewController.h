//
//  LyLoginViewController.h
//  teacher
//
//  Created by Junes on 16/7/13.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyUtil.h"


@class LyLoginViewController;


@protocol LoginDelegate <NSObject>

- (void)loginDone:(LyLoginViewController *)vc;

@end

@interface LyLoginViewController : UIViewController

@property (weak, nonatomic)         id<LoginDelegate>           delegate;

@property (assign, nonatomic)       LyUserType                  userType;

@end
