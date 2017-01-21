//
//  LyLeftMenuViewController.h
//  teacher
//
//  Created by Junes on 16/7/30.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LyLeftMenuViewController;


@protocol LyLeftMenuDelegate <NSObject>

- (void)pushViewControllerWithIndex:(NSInteger)index;

@end


@interface LyLeftMenuViewController : UIViewController

@property (assign, nonatomic)         id<LyLeftMenuDelegate>          delegate;

@end
