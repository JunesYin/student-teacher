//
//  LyDetailControlBar.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/21.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>

#define dcbWidth                            SCREEN_WIDTH
UIKIT_EXTERN CGFloat const dcbHeight;


typedef NS_ENUM( NSInteger, LyDetailControlBarMode)
{
    LyDetailControlBarMode_chDsGe,
    LyDetailControlBarMode_myCDG,
    LyDetailControlBarMode_user,
    LyDetailControlBarMode_trainClass
};

//
//typedef NS_ENUM( NSInteger, LyDetailControlBarAttentionStatus)
//{
//    detailControlBarAttentionStatus_attented,
//    detailControlBarAttentionStatus_notyet
//};



@protocol LyDetailControlBarDelegate <NSObject>

@optional
- (void)onClickedButtonAttente;
- (void)onClickedButtonPhone;
- (void)onClickedButtonMessage;

- (void)onClickedButtonApply;

- (void)onClickedButtonLeaveMessage;


@end



@interface LyDetailControlBar : UIView

@property ( assign, nonatomic, readonly)    LyDetailControlBarMode          controlBarMode;

@property ( assign, nonatomic)              BOOL                            attentionStatus;

@property ( weak, nonatomic)                id<LyDetailControlBarDelegate>  delegate;


+ (instancetype)controlBarWidthMode:(LyDetailControlBarMode)mode;

- (instancetype)initWidthMode:(LyDetailControlBarMode)mode;

- (void)iamGuider;


@end
