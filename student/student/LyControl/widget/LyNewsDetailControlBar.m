//
//  LyNewsDetailControlBar.m
//  teacher
//
//  Created by Junes on 2016/10/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyNewsDetailControlBar.h"
#import "LyUtil.h"


CGFloat const ndcbHeight = 50.0f;


CGFloat const verticalLineWidth = 2.0f;
CGFloat const verticalLineHeight = ndcbHeight;

int const ndcbBtnItemCount = 3;
#define btnItemMargin                   ((SCREEN_WIDTH-ndcbBtnItemWidth*ndcbBtnItemCount)/(ndcbBtnItemCount+1))

CGFloat const ndcbBtnItemWidth = 100.0f;
CGFloat const ndcbBtnItemHeight = 50.0f;



typedef NS_ENUM( NSInteger, LyNewsDetailControlBarButtonMode)
{
    statusDetailControlBarButtonMode_praise,
    statusDetailControlBarButtonMode_evalute,
    statusDetailControlBarButtonMode_transmit
};


@interface LyNewsDetailControlBar ()
{
    UIButton                    *btnPraise;
    
    UIButton                    *btnEvalute;
    
    UIButton                    *btnTransmit;
}
@end

@implementation LyNewsDetailControlBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if ( self = [super initWithFrame:CGRectMake( 0, SCREEN_HEIGHT-ndcbHeight, SCREEN_WIDTH, ndcbHeight)]) {
        [self initSubviews];
    }
    
    return self;
}



- (instancetype)init {
    if ( self = [super initWithFrame:CGRectMake( 0, SCREEN_HEIGHT-ndcbHeight, SCREEN_WIDTH, ndcbHeight)]) {
        [self initSubviews];
    }
    
    return self;
}



- (void)initSubviews {
    
    [self setBackgroundColor:LyWhiteLightgrayColor];
    [self setAlpha:0.9];
    
    
    UIView *viewHorizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [viewHorizontalLine setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:viewHorizontalLine];
    
    
    btnTransmit = [[UIButton alloc] initWithFrame:CGRectMake( btnItemMargin, ndcbHeight/2.0f-ndcbBtnItemHeight/2.0f, ndcbBtnItemWidth, ndcbBtnItemHeight)];
    [btnTransmit setTag:statusDetailControlBarButtonMode_transmit];
    [btnTransmit setImage:[LyUtil imageForImageName:@"sdcb_transmit" needCache:NO] forState:UIControlStateNormal];
    [btnTransmit addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnTransmit];
    
    
    UIImageView *ivVerticalLine_first = [[UIImageView alloc] initWithFrame:CGRectMake( SCREEN_WIDTH/3.0f-verticalLineWidth/2.0f, 0, verticalLineWidth, verticalLineHeight)];
    [ivVerticalLine_first setImage:[LyUtil imageForImageName:@"controlBar_verticalLine" needCache:NO]];
    [self addSubview:ivVerticalLine_first];
    
    
    btnEvalute = [[UIButton alloc] initWithFrame:CGRectMake( btnTransmit.frame.origin.x+CGRectGetWidth(btnTransmit.frame)+btnItemMargin, ndcbHeight/2.0f-ndcbBtnItemHeight/2.0f, ndcbBtnItemWidth, ndcbBtnItemHeight)];
    [btnEvalute setTag:statusDetailControlBarButtonMode_evalute];
    [btnEvalute setImage:[LyUtil imageForImageName:@"sdcb_evalute" needCache:NO] forState:UIControlStateNormal];
    [btnEvalute addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnEvalute];
    
    
    UIImageView *ivVerticalLine_second = [[UIImageView alloc] initWithFrame:CGRectMake( SCREEN_WIDTH*2/3.0f-verticalLineWidth/2.0f, 0, verticalLineWidth, verticalLineHeight)];
    [ivVerticalLine_second setImage:[LyUtil imageForImageName:@"controlBar_verticalLine" needCache:NO]];
    [self addSubview:ivVerticalLine_second];
    
    
    btnPraise = [[UIButton alloc] initWithFrame:CGRectMake( btnEvalute.frame.origin.x+CGRectGetWidth(btnEvalute.frame)+btnItemMargin, ndcbHeight/2.0f-ndcbBtnItemHeight/2.0f, ndcbBtnItemWidth, ndcbBtnItemHeight)];
    [btnPraise setTag:statusDetailControlBarButtonMode_praise];
    [btnPraise setImage:[LyUtil imageForImageName:@"sdcb_praise_n" needCache:NO] forState:UIControlStateNormal];
    [btnPraise setImage:[LyUtil imageForImageName:@"sdcb_praise_h" needCache:NO] forState:UIControlStateSelected];
    [btnPraise addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnPraise];
    
}



- (void)setPraise:(BOOL)isPraise {
    [btnPraise setSelected:isPraise];
}


- (void)targetForButton:(UIButton *)button {
    
    if (statusDetailControlBarButtonMode_transmit == button.tag) {
        if ( [_delegate respondsToSelector:@selector(onClickedForTransmitByNewsDetailControlBar:)]) {
            [_delegate onClickedForTransmitByNewsDetailControlBar:self];
        }
        
    } else if (statusDetailControlBarButtonMode_evalute == button.tag) {
        if ( [_delegate respondsToSelector:@selector(onClickedForEvaluteByNewsDetailControlBar:)]) {
            [_delegate onClickedForEvaluteByNewsDetailControlBar:self];
        }
        
    } else if (statusDetailControlBarButtonMode_praise == button.tag) {
        if ( [_delegate respondsToSelector:@selector(onClickedForPraiseByNewsDetailControlBar:)]) {
            [_delegate onClickedForPraiseByNewsDetailControlBar:self];
        }
        
    }
}

@end
