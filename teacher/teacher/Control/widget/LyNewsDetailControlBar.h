//
//  LyNewsDetailControlBar.h
//  teacher
//
//  Created by Junes on 2016/10/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const ndcbHeight;


@protocol LyNewsDetailControlBarDelegate;

@interface LyNewsDetailControlBar : UIView

@property ( weak, nonatomic)        id<LyNewsDetailControlBarDelegate>        delegate;

- (void)setPraise:(BOOL)isPraise;

@end


@protocol LyNewsDetailControlBarDelegate <NSObject>

- (void)onClickedForPraiseByNewsDetailControlBar:(LyNewsDetailControlBar *)aControlBar;

- (void)onClickedForEvaluteByNewsDetailControlBar:(LyNewsDetailControlBar *)aControlBar;

- (void)onClickedForTransmitByNewsDetailControlBar:(LyNewsDetailControlBar *)aControlBar;

@end
