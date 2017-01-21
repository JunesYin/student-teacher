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


#define sViewUsefulWidth                     seWidth
CGFloat const sViewUsefulHeight = 260.0f;


CGFloat const  btnCloseWidth = 20.0f;
CGFloat const btnCloseHeight = btnCloseWidth;


int const sBtnItemCount = 3;
CGFloat const swpBtnItemWidth = 100.0f;
CGFloat const swpBtnItemHeight = swpBtnItemWidth;

#define btnItemHorizontalSpace              ((sViewUsefulWidth-swpBtnItemWidth*3.0)/4.0)
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
    UIView                  *viewDark;
    UIButton                *btnBig;
    
    UIView                  *viewUseful;
    CGPoint                 centerViewUseful;
    
    
    UIViewController        *vcDelegate;
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
    viewDark = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, seWidth, seHeight)];
    [viewDark setBackgroundColor:LyMaskColor];
    
    
    btnBig = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, btnBigWidth, btnBigHeight)];
    [btnBig setBackgroundColor:[UIColor clearColor]];
    [btnBig addTarget:self action:@selector(targetForBtnClose) forControlEvents:UIControlEventTouchUpInside];
    
    viewUseful = [[UIView alloc] initWithFrame:CGRectMake( 0, seHeight-sViewUsefulHeight, sViewUsefulWidth, sViewUsefulHeight)];
    [viewUseful setBackgroundColor:LyWhiteLightgrayColor];
    centerViewUseful = [viewUseful center];
    
    _btnClose = [[UIButton alloc] initWithFrame:CGRectMake( sViewUsefulWidth-horizontalSpace-btnCloseWidth, horizontalSpace, btnCloseWidth, btnCloseHeight)];
    [_btnClose setBackgroundImage:[LyUtil imageForImageName:@"btn_close_dark" needCache:NO] forState:UIControlStateNormal];
    [_btnClose addTarget:self action:@selector(targetForBtnClose) forControlEvents:UIControlEventTouchUpInside];
    
    
    _btnQQFriend = [self buttonWithMode:shareViewFuncButtonMode_qqFriend];
    _btnQQZone = [self buttonWithMode:shareViewFuncButtonMode_qqZone];
    _btnSinaWeiBo = [self buttonWithMode:shareViewFuncButtonMode_sinaWeibo];
    _btnWeChatFriend = [self buttonWithMode:shareViewFuncButtonMode_wechatFriend];
    _btnWeChatMoments = [self buttonWithMode:shareViewFuncButtonMode_wechatMoments];
    
    
    
    [viewDark addSubview:btnBig];
    
    [viewUseful addSubview:_btnClose];
    [viewUseful addSubview:_btnQQFriend];
    [viewUseful addSubview:_btnQQZone];
    [viewUseful addSubview:_btnSinaWeiBo];
    [viewUseful addSubview:_btnWeChatFriend];
    [viewUseful addSubview:_btnWeChatMoments];
    
    
    
    [self addSubview:viewDark];
    [self addSubview:viewUseful];
    
    
    [self setHidden:YES];
    
}

- (void)setDelegate:(id<LyShareViewDelegate>)delegate
{
    _delegate = delegate;
    vcDelegate = (UIViewController *)_delegate;
}


- (void)show
{
    [self setHidden:NO];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
    [LyUtil startAnimationWithView:viewUseful
                                  animationDuration:0.1f
                                       initialPoint:CGPointMake( centerViewUseful.x, centerViewUseful.y+CGRectGetHeight(viewUseful.frame)/2.0)
                                   destinationPoint:centerViewUseful
                                         completion:^(BOOL finished) {
                                             [viewUseful setCenter:centerViewUseful];
                                         }];
    
    
    [LyUtil startAnimationWithView:viewDark
                                  animationDuration:0.3f
                                          initAlpha:0
                                  destinationAplhas:1
                                          comletion:^(BOOL finished) {
                                              [viewDark setAlpha:1];
                                          }];
    
}



- (void)hide
{
    [LyUtil startAnimationWithView:viewUseful
                                  animationDuration:0.3f initialPoint:centerViewUseful
                                   destinationPoint:CGPointMake( centerViewUseful.x, centerViewUseful.y+CGRectGetHeight(viewUseful.frame))
                                         completion:^(BOOL finished) {
                                             [viewUseful setHidden:YES];
                                             [viewUseful setCenter:centerViewUseful];
                                         }];
    
    
    [LyUtil startAnimationWithView:viewDark
                                  animationDuration:0.3f
                                          initAlpha:1.0f
                                  destinationAplhas:0.0f
                                          comletion:^(BOOL finished) {
                                              [viewDark setHidden:YES];
                                              [viewDark setAlpha:1.0f];
                                              
                                              [self setHidden:YES];
                                              [self removeFromSuperview];
                                          }];
    
    
}




- (UIButton *)buttonWithMode:(LyShareViewFuncButtonMode)mode
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake( btnItemHorizontalSpace*(mode%sBtnItemCount+1)+swpBtnItemWidth*(mode%sBtnItemCount), _btnClose.ly_y+CGRectGetHeight(_btnClose.frame)+btnItemVerticalSpace*(mode/sBtnItemCount)+swpBtnItemHeight*(mode/sBtnItemCount), swpBtnItemWidth, swpBtnItemHeight)];
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
