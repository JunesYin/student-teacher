//
//  LyOrderStateView.h
//  teacher
//
//  Created by Junes on 16/8/15.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyOrder.h"


UIKIT_EXTERN CGFloat const LyOrderStateViewHeight;


@protocol LyOrderStateViewDelegate;

@interface LyOrderStateView : UIView

@property (weak, nonatomic)         id<LyOrderStateViewDelegate>            delegate;

@property (assign, nonatomic)     LyOrderPayStatus        orderPayStatus;

@end



@protocol LyOrderStateViewDelegate <NSObject>

@required
//- (void)orderStateView:(LyOrderStateView *)aOrderStateView didSelectItemAtIndex:(NSInteger)index;
- (void)orderStateView:(LyOrderStateView *)aOrderStateView didSelectLyOrderPayStatus:(LyOrderPayStatus)orderPayStatus;

@end
