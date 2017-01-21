//
//  LyNewsDetailExtBar.h
//  teacher
//
//  Created by Junes on 2016/10/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const ndebHeight;


@protocol LyNewsDetailExtBarDelegate;

@interface LyNewsDetailExtBar : UIView

@property ( assign, nonatomic)          NSInteger           transmitCount;
@property ( assign, nonatomic)          NSInteger           evalutionCount;
@property ( assign, nonatomic)          NSInteger           praiseCount;

@property ( weak, nonatomic)            id<LyNewsDetailExtBarDelegate>        delegate;

@end


@protocol LyNewsDetailExtBarDelegate <NSObject>

- (void)onClickedTransmitByNewsDetailExtBar:(LyNewsDetailExtBar *)aExtBar;

- (void)onClickedEvalutionByNewsDetailExtBar:(LyNewsDetailExtBar *)aExtBar;

- (void)onClickedPraiseByNewsDetailExtBar:(LyNewsDetailExtBar *)aExtBar;

@end
