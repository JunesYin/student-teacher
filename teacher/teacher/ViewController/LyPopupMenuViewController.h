//
//  LyPopupMenuViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/24.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LyPopupMenuViewControllerDelegate;


@interface LyPopupMenuViewController : UIViewController

@property (weak, nonatomic)     id<LyPopupMenuViewControllerDelegate>       delegate;

@end


@protocol LyPopupMenuViewControllerDelegate <NSObject>

//- (void)pushVCByPopupMenuViewController:(LyPopupMenuViewController *)aPopupMenuVC index:(NSInteger)index;
- (void)pushViewControllerWithIndex:(NSInteger)index;

@end
