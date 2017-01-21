//
//  LyPayViewController.h
//  student
//
//  Created by Junes on 2016/11/21.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "ViewController.h"

@class LyOrder;
@protocol LyPayViewControllerDelegate;

@interface LyPayViewController : ViewController

@property (retain, nonatomic)       LyOrder         *order;

@property (weak, nonatomic)     id<LyPayViewControllerDelegate>     delegate;

@end



@protocol LyPayViewControllerDelegate <NSObject>

@required
- (LyOrder *)orderOfPayViewController:(LyPayViewController *)aPayVC;

- (void)payDoneViewControler:(LyPayViewController *)aPayVC order:(LyOrder *)order;

@end
