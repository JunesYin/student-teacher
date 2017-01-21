//
//  LyShareView.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/22.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyShareView.h"
#import "LyUtil.h"


#define seWidth                             SCREEN_WIDTH
#define seHeight                            SCREEN_HEIGHT


#define btnBigWidth                         seWidth
#define btnBigHeight                        (seHeight-sViewUsefulHeight)


#define viewUsefulWidth                     seWidth
CGFloat const sViewUsefulHeight = 260.0f;


int const sBtnItemCount = 3;
CGFloat const sBtnItemWidth = 100.0f;
CGFloat const sBtnItemHeight = sBtnItemWidth;

#define btnItemHorizontalSpace              ((viewUsefulWidth-sBtnItemWidth*3.0)/4.0)
#define btnItemVerticalSpace                (btnItemHorizontalSpace/2.0f)



typedef  NS_ENUM( NSInteger, LyShareViewFuncButtonMode)
{
    shareViewFuncButtonMode_qqFriend,
    shareViewFuncButtonMode_qqZone,
    shareViewFuncButtonMode_sinaWeibo,
    shareViewFuncButtonMode_wechatFriend,
    shareViewFuncButtonMode_wechatMoments
};



@interface LyShareView ()
{
    UIButton                *btnBig;
    
    UIView                  *viewUseful;
    
    
}
@end



@implementation LyShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//lySingle_implementation(LyShareView)


- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:CGRectMake( 0, 0, seWidth, seWidth)])
    {
        [self initAndLayoutSubView];
    }
    
    return self;
}


- (instancetype)init
{
    if ( self = [super initWithFrame:CGRectMake( 0, 0, seWidth, seHeight)])
    {
        [self initAndLayoutSubView];
    }
    
    return self;
}



- (void)initAndLayoutSubView
{
    
    btnBig = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, btnBigWidth, btnBigHeight)];
    [btnBig setBackgroundColor:LyMaskColor];
    [btnBig addTarget:self action:@selector(targetForBtnClose) forControlEvents:UIControlEventTouchUpInside];
    
    viewUseful = [[UIView alloc] initWithFrame:CGRectMake( 0, seHeight-sViewUsefulHeight, viewUsefulWidth, sViewUsefulHeight)];
    [viewUseful setBackgroundColor:LyWhiteLightgrayColor];
    
    
    _btnClose = [[UIButton alloc] initWithFrame:CGRectMake( viewUsefulWidth-horizontalSpace-btnCloseSize, horizontalSpace, btnCloseSize, btnCloseSize)];
    [_btnClose setBackgroundImage:[LyUtil imageForImageName:@"share_btn_close" needCache:NO] forState:UIControlStateNormal];
    [_btnClose addTarget:self action:@selector(targetForBtnClose) forControlEvents:UIControlEventTouchUpInside];
    
    
    _btnQQFriend = [self buttonWithMode:shareViewFuncButtonMode_qqFriend];
    _btnQQZone = [self buttonWithMode:shareViewFuncButtonMode_qqZone];
    _btnSinaWeiBo = [self buttonWithMode:shareViewFuncButtonMode_sinaWeibo];
    _btnWeChatFriend = [self buttonWithMode:shareViewFuncButtonMode_wechatFriend];
    _btnWeChatMoments = [self buttonWithMode:shareViewFuncButtonMode_wechatMoments];
    
    
    
    
    [viewUseful addSubview:_btnClose];
    [viewUseful addSubview:_btnQQFriend];
    [viewUseful addSubview:_btnQQZone];
    [viewUseful addSubview:_btnSinaWeiBo];
    [viewUseful addSubview:_btnWeChatFriend];
    [viewUseful addSubview:_btnWeChatMoments];
    
    
    
    [self addSubview:btnBig];
    [self addSubview:viewUseful];
    
    
    [self setHidden:YES];
    
}



- (void)show
{
    [self setHidden:NO];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    CGPoint centerViewUseful = [viewUseful center];
    
    
    [LyUtil startAnimationWithView:viewUseful
                 animationDuration:0.1f
                      initialPoint:CGPointMake( centerViewUseful.x, centerViewUseful.y+CGRectGetHeight(viewUseful.frame)/2.0)
                  destinationPoint:centerViewUseful
                        completion:^(BOOL finished) {
                            [viewUseful setCenter:centerViewUseful];
                        }];
    
    
    [LyUtil startAnimationWithView:btnBig
                 animationDuration:0.3f
                         initAlpha:0
                 destinationAplhas:1
                         completion:^(BOOL finished) {
                             [btnBig setAlpha:1];
                         }];
    
}



- (void)hide
{
    CGPoint centerViewUseful = [viewUseful center];
    [LyUtil startAnimationWithView:viewUseful
                 animationDuration:0.3f initialPoint:centerViewUseful
                  destinationPoint:CGPointMake( centerViewUseful.x, centerViewUseful.y+CGRectGetHeight(viewUseful.frame))
                        completion:^(BOOL finished) {
                            [viewUseful setHidden:YES];
                            [viewUseful setCenter:centerViewUseful];
                        }];
    
    
    [LyUtil startAnimationWithView:btnBig
                 animationDuration:0.3f
                         initAlpha:1.0f
                 destinationAplhas:0.0f
                         completion:^(BOOL finished) {
                             [btnBig setHidden:YES];
                             [btnBig setAlpha:1.0f];
                             
                             [self setHidden:YES];
                             [self removeFromSuperview];
                         }];
    
    
}




- (UIButton *)buttonWithMode:(LyShareViewFuncButtonMode)mode
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake( btnItemHorizontalSpace*(mode%sBtnItemCount+1)+sBtnItemWidth*(mode%sBtnItemCount), _btnClose.frame.origin.y+CGRectGetHeight(_btnClose.frame)+btnItemVerticalSpace*(mode/sBtnItemCount)+sBtnItemHeight*(mode/sBtnItemCount), sBtnItemWidth, sBtnItemHeight)];
    [button setTag:mode];
    [button setBackgroundImage:[LyUtil imageForImageName:[[NSString alloc] initWithFormat:@"share_item_%ld", mode-shareViewFuncButtonMode_qqFriend] needCache:NO] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(targetForFuncItemButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}




- (void)targetForBtnClose
{
    if ( [_delegate respondsToSelector:@selector(onClickButtonClose:)])
    {
        [_delegate onClickButtonClose:self];
    }
    else
    {
        [self removeFromSuperview];
    }
}





- (void)targetForFuncItemButton:(UIButton *)button
{
    switch ( [button tag]) {
        case shareViewFuncButtonMode_qqFriend: {
            if ( [_delegate respondsToSelector:@selector(onSharedByQQFriend:)])
            {
                [_delegate onSharedByQQFriend:self];
            }
            break;
        }
        case shareViewFuncButtonMode_qqZone: {
            if ( [_delegate respondsToSelector:@selector(onSharedByQQZone:)])
            {
                [_delegate onSharedByQQZone:self];
            }
            break;
        }
        case shareViewFuncButtonMode_sinaWeibo: {
            if ( [_delegate respondsToSelector:@selector(onSharedByWeiBo:)])
            {
                [_delegate onSharedByWeiBo:self];
            }
            break;
        }
        case shareViewFuncButtonMode_wechatFriend: {
            if ( [_delegate respondsToSelector:@selector(onSharedByWeChatFriend:)])
            {
                [_delegate onSharedByWeChatFriend:self];
            }
            break;
        }
        case shareViewFuncButtonMode_wechatMoments: {
            if ( [_delegate respondsToSelector:@selector(onSharedByWeChatMoments:)])
            {
                [_delegate onSharedByWeChatMoments:self];
            }
            break;
        }
    }
}







@end
