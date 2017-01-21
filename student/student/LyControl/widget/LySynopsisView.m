//
//  LySynopsisView.m
//  LyStudyDrive
//
//  Created by Junes on 16/7/16.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LySynopsisView.h"
#import "LyUtil.h"



#define synViewUsefulWidth                 (SCREEN_WIDTH-horizontalSpace*2)
#define synViewUsefulHeight                (SCREEN_HEIGHT*5/6.0f)

#define synLbTitleWidth                    synViewUsefulWidth
CGFloat const synLbTitleHeight = 50.0f;

#define tvContentWidth                  synViewUsefulWidth
#define tvContentHeight                 (synViewUsefulHeight-synLbTitleHeight-verticalSpace)
#define tvContentFont                   LyFont(14)



@interface LySynopsisView ()
{
    UIButton                    *btnMask;
    
    
    UIView                      *viewUseful;
    UILabel                     *lbTitle;
    UITextView                  *tvContent;
    
    CGPoint                     centerViewUseful;
}
@end


@implementation LySynopsisView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (instancetype)init
{
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)])
    {
        
    }
    
    return self;
}


+ (instancetype)synopsisViewWithContent:(NSString *)content  withTitle:(NSString *)title;
{
    LySynopsisView *synopsis = [[LySynopsisView alloc] initWithContent:content withTitle:title];
    
    return synopsis;
}

- (instancetype)initWithContent:(NSString *)content  withTitle:(NSString *)title;
{
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)])
    {
        _content = content;
        _title = title;
        [self initSubviews];
    }
    
    return self;
}



- (void)initSubviews
{
    btnMask = [[UIButton alloc] initWithFrame:self.bounds];
    [btnMask setBackgroundColor:LyMaskColor];
    [btnMask addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnMask];
    
    
    viewUseful = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f-synViewUsefulWidth/2.0f, SCREEN_HEIGHT/2.0f-synViewUsefulHeight/2.0f, synViewUsefulWidth, synViewUsefulHeight)];
    viewUseful.layer.cornerRadius = 5.0f;
    centerViewUseful = viewUseful.center;
    [viewUseful setBackgroundColor:LyWhiteLightgrayColor];
    
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, synLbTitleWidth, synLbTitleHeight)];
    [lbTitle setTextColor:Ly517ThemeColor];
    [lbTitle setFont:LyFont(18)];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    [lbTitle setText:_title];
    
    tvContent = [[UITextView alloc] initWithFrame:CGRectMake(0, lbTitle.frame.origin.y+CGRectGetHeight(lbTitle.frame), tvContentWidth, tvContentHeight)];
    [tvContent setTextContainerInset:UIEdgeInsetsMake(horizontalSpace, verticalSpace, horizontalSpace, verticalSpace)];
    [tvContent setFont:tvContentFont];
    [tvContent setTextColor:LyDarkgrayColor];
    [tvContent setEditable:NO];
    [tvContent setScrollsToTop:NO];
    [tvContent setSelectable:NO];
    
    
    [viewUseful addSubview:lbTitle];
    [viewUseful addSubview:tvContent];
    
    [self addSubview:viewUseful];
    
    if (_content)
    {
        [tvContent setText:_content];
    }
}


- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [LyUtil startAnimationWithView:viewUseful
                 animationDuration:0.3f
                      initialPoint:CGPointMake( centerViewUseful.x, centerViewUseful.y+CGRectGetHeight(viewUseful.frame))
                  destinationPoint:centerViewUseful
                        completion:^(BOOL finished) {
                        }];
    
    [LyUtil startAnimationWithView:btnMask
                 animationDuration:0.3f
                         initAlpha:0.0f
                 destinationAplhas:1.0f
                         completion:^(BOOL finished) {
                         }];
}


- (void)hide
{
    [LyUtil startAnimationWithView:viewUseful
                 animationDuration:0.3f
                      initialPoint:centerViewUseful
                  destinationPoint:CGPointMake( centerViewUseful.x, centerViewUseful.y+CGRectGetHeight(viewUseful.frame))
                        completion:^(BOOL finished) {
                            [tvContent setHidden:YES];
                            [tvContent setCenter:centerViewUseful];
                        }];
    
    [LyUtil startAnimationWithView:btnMask
                 animationDuration:0.3f
                         initAlpha:1.0f
                 destinationAplhas:0.0f
                         completion:^(BOOL finished) {
                             [btnMask setHidden:NO];
                             [self removeFromSuperview];
                         }];
}


- (void)targetForButton:(UIButton *)button
{
    [self hide];
}



@end
