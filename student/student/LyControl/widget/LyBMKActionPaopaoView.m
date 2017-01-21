//
//  LyBMKActionPaopaoView.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/27.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyBMKActionPaopaoView.h"
#import "LyUtil.h"



#define paoWith                         CGRectGetWidth(self.frame)
#define paoHeight                       CGRectGetHeight(self.frame)

#define lbTitleWidth                    paoWith
#define lbTitleHeight                   (paoHeight*30/60.0f)
#define lbTitleFont                     LyFont(14)

#define lbPriceWidth                    (paoWith*2/5.0f)
#define lbPriceHeight                   (paoHeight*20/60.0f)
#define lbPriceFont                     LyFont(13)

#define ivScoreWidth                    (paoWith-lbPriceWidth)
#define ivScoreHeight                   (lbPriceHeight*2/3.0f)





@interface LyBMKActionPaopaoView ()
{
    UILabel             *lbTitle;
    
    UIImageView         *ivScore;
//    UILabel             *lbPrice;
}
@end


@implementation LyBMKActionPaopaoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        [self initSubviews];
    }
    
    return self;
}


- (instancetype)init
{
    if ( self = [super initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH/2.0f, SCREEN_WIDTH/2.0f*60/160.0f)])
    {
        [self initSubviews];
    }
    
    return self;
}


- (void)initSubviews
{
    [self.layer setContents:(id)[[LyUtil imageForImageName:@"annotation_pao" needCache:NO] CGImage]];
    [self setAlpha:0.8f];
    
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, lbTitleWidth, lbTitleHeight)];
    [lbTitle setFont:lbTitleFont];
    [lbTitle setTextColor:LyBlackColor];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbTitle];
    
    
//    lbPrice = [[UILabel alloc] initWithFrame:CGRectMake( paoWith-lbPriceWidth, lbTitle.frame.origin.y+CGRectGetHeight(lbTitle.frame), lbPriceWidth, lbPriceHeight)];
//    [lbPrice setFont:lbPriceFont];
//    [lbPrice setTextColor:Ly517ThemeColor];
//    [lbPrice setTextAlignment:NSTextAlignmentCenter];
//    [self addSubview:lbPrice];
    
    ivScore = [[UIImageView alloc] initWithFrame:CGRectMake( lbPriceWidth/2.0f, lbTitle.frame.origin.y+CGRectGetHeight(lbTitle.frame)+lbPriceHeight/2.0f-ivScoreHeight/2.0f, ivScoreWidth, ivScoreHeight)];
    [ivScore setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:ivScore];
}


- (void)setTitle:(NSString *)title
{
    if ( !title)
    {
        return;
    }
    
    _title = title;
    
    [lbTitle setText:_title];
}


- (void)setScore:(float)score
{
    _score = score;
    [LyUtil setScoreImageView:ivScore withScore:_score];
}





@end


