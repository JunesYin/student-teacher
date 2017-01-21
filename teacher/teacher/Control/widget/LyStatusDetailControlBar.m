//
//  LyStatusDetailControlBar.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/3.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyStatusDetailControlBar.h"

#import "LyUtil.h"



CGFloat const sdcbHeight = 50.0f;


CGFloat const verticalLineWidth = 2.0f;
CGFloat const verticalLineHeight = sdcbHeight;

int const sdcbBtnItemCount = 3;
#define btnItemMargin                   ((sdcbWidth-sdcbBtnItemWidth*sdcbBtnItemCount)/(sdcbBtnItemCount+1))

CGFloat const sdcbBtnItemWidth = 100.0f;
CGFloat const sdcbBtnItemHeight = 50.0f;



typedef NS_ENUM( NSInteger, LyStatusDetailControlBarButtonMode)
{
    statusDetailControlBarButtonMode_praise,
    statusDetailControlBarButtonMode_evalute,
    statusDetailControlBarButtonMode_transmit
};


@interface LyStatusDetailControlBar ()
{
    UIButton                    *btnPraise;
    
    UIButton                    *btnEvalute;
    
    UIButton                    *btnTransmit;
}
@end


@implementation LyStatusDetailControlBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:CGRectMake( 0, FULLSCREENHEIGHT-sdcbHeight, sdcbWidth, sdcbHeight)])
    {
        [self initAndLayoutSubviews];
    }
    
    return self;
}



- (instancetype)init
{
    if ( self = [super initWithFrame:CGRectMake( 0, FULLSCREENHEIGHT-sdcbHeight, sdcbWidth, sdcbHeight)])
    {
        [self initAndLayoutSubviews];
    }
    
    return self;
}



- (void)initAndLayoutSubviews
{
    [self setBackgroundColor:LyWhiteLightgrayColor];
    [self setAlpha:0.9];
    
    
    btnTransmit = [[UIButton alloc] initWithFrame:CGRectMake( btnItemMargin, sdcbHeight/2.0f-sdcbBtnItemHeight/2.0f, sdcbBtnItemWidth, sdcbBtnItemHeight)];
    [btnTransmit setTag:statusDetailControlBarButtonMode_transmit];
    [btnTransmit setImage:[LyUtil imageForImageName:@"sdcb_transmit" needCache:NO] forState:UIControlStateNormal];
    [btnTransmit addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnTransmit];
    
    
    UIImageView *ivVerticalLine_first = [[UIImageView alloc] initWithFrame:CGRectMake( sdcbWidth/3.0f-verticalLineWidth/2.0f, 0, verticalLineWidth, verticalLineHeight)];
    [ivVerticalLine_first setImage:[LyUtil imageForImageName:@"controlBar_verticalLine" needCache:NO]];
    [self addSubview:ivVerticalLine_first];
    
    
    btnEvalute = [[UIButton alloc] initWithFrame:CGRectMake( btnTransmit.frame.origin.x+CGRectGetWidth(btnTransmit.frame)+btnItemMargin, sdcbHeight/2.0f-sdcbBtnItemHeight/2.0f, sdcbBtnItemWidth, sdcbBtnItemHeight)];
    [btnEvalute setTag:statusDetailControlBarButtonMode_evalute];
    [btnEvalute setImage:[LyUtil imageForImageName:@"sdcb_evalute" needCache:NO] forState:UIControlStateNormal];
    [btnEvalute addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnEvalute];
    
    
    UIImageView *ivVerticalLine_second = [[UIImageView alloc] initWithFrame:CGRectMake( sdcbWidth*2/3.0f-verticalLineWidth/2.0f, 0, verticalLineWidth, verticalLineHeight)];
    [ivVerticalLine_second setImage:[LyUtil imageForImageName:@"controlBar_verticalLine" needCache:NO]];
    [self addSubview:ivVerticalLine_second];
    
    
    btnPraise = [[UIButton alloc] initWithFrame:CGRectMake( btnEvalute.frame.origin.x+CGRectGetWidth(btnEvalute.frame)+btnItemMargin, sdcbHeight/2.0f-sdcbBtnItemHeight/2.0f, sdcbBtnItemWidth, sdcbBtnItemHeight)];
    [btnPraise setTag:statusDetailControlBarButtonMode_praise];
    [btnPraise setImage:[LyUtil imageForImageName:@"sdcb_praise_n" needCache:NO] forState:UIControlStateNormal];
    [btnPraise setImage:[LyUtil imageForImageName:@"sdcb_praise_h" needCache:NO] forState:UIControlStateSelected];
    [btnPraise addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnPraise];
    
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, CGRectGetWidth(self.frame), LyHorizontalLineHeight)];
    [horizontalLine setBackgroundColor:LyHorizontalLineColor];
    
    [self addSubview:horizontalLine];
}



- (void)setPraise:(BOOL)isPraise
{
    [btnPraise setSelected:isPraise];
}




- (void)targetForButton:(UIButton *)button
{
    
    switch ( [button tag]) {
        case statusDetailControlBarButtonMode_transmit: {
            if ( [_delegate respondsToSelector:@selector(onClickedTransmitByStatusDetailControlBar:)])
            {
                [_delegate onClickedTransmitByStatusDetailControlBar:self];
            }
            break;
        }
        case statusDetailControlBarButtonMode_evalute: {
            if ( [_delegate respondsToSelector:@selector(onClickedEvaluteByStatusDetailControlBar:)])
            {
                [_delegate onClickedEvaluteByStatusDetailControlBar:self];
            }
            break;
        }
        case statusDetailControlBarButtonMode_praise: {
            if ( [_delegate respondsToSelector:@selector(onClickedPraiseByStatusDetailControlBar:)])
            {
                [_delegate onClickedPraiseByStatusDetailControlBar:self];
            }
            break;
        }
    }
}



@end
