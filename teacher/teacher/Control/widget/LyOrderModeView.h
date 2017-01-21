//
//  LyOrderModeView.h
//  student
//
//  Created by Junes on 2016/12/1.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LyOrder.h"

@protocol LyOrderModeViewDelegate;

@interface LyOrderModeView : UIView

@property (weak, nonatomic)     id<LyOrderModeViewDelegate>     delegate;

@property (assign, nonatomic)       LyOrderMode         orderMode;

- (void)show;

- (void)hide;

@end



@protocol LyOrderModeViewDelegate <NSObject>

@required
- (void)orderModeView:(LyOrderModeView *)aOrderModeView didSelectedOrderMode:(LyOrderMode)aOrderMode;

@optional

@end
