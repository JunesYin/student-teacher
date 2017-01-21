//
//  LyShareView.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/22.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LySingleInstance.h"



@class LyShareView;

@protocol LyShareViewDelegate <NSObject>

@optional
- (void)onClickButtonClose:(LyShareView *)aShareView;

- (void)onSharedByQQFriend:(LyShareView *)aShareView;
- (void)onSharedByQQZone:(LyShareView *)aShareView;
- (void)onSharedByWeiBo:(LyShareView *)aShareView;
- (void)onSharedByWeChatFriend:(LyShareView *)aShareView;
- (void)onSharedByWeChatMoments:(LyShareView *)aShareView;


@end


@interface LyShareView : UIView

@property ( strong, nonatomic)                  UIButton                    *btnClose;
@property ( strong, nonatomic)                  UIButton                    *btnQQFriend;
@property ( strong, nonatomic)                  UIButton                    *btnQQZone;
@property ( strong, nonatomic)                  UIButton                    *btnSinaWeiBo;
@property ( strong, nonatomic)                  UIButton                    *btnWeChatFriend;
@property ( strong, nonatomic)                  UIButton                    *btnWeChatMoments;


@property ( weak, nonatomic)                    id<LyShareViewDelegate>     delegate;




- (void)show;

- (void)hide;

@end
