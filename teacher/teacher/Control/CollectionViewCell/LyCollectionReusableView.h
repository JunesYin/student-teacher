//
//  LyCollectionReusableView.h
//  teacher
//
//  Created by Junes on 16/8/11.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const LyCollectionReusableViewHeight;


@class LyCollectionReusableView;

@protocol LyCollectionReusableViewDelegate <NSObject>

- (void)onClickButtonFuncByCollectionReusableView:(LyCollectionReusableView *)aCrv;

@end

@interface LyCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic)     id<LyCollectionReusableViewDelegate>        delegate;

- (void)setTitle:(NSString *)title;// detail:(NSString *)detail;

- (void)setFunc:(NSString *)func;

- (void)setFuncHide:(BOOL)isHidden;

@end



