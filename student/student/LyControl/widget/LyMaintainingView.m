//
//  LyMaintainingView.m
//  student
//
//  Created by Junes on 2016/9/28.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyMaintainingView.h"

#import "LyUtil.h"


#define mWidth                  (SCREEN_WIDTH*6/7.0f)
#define mHeight                 (mWidth*1.2f)

CGFloat const mBtnCloseSize = 30.0f;
CGFloat const mIvIconSize = 200.0f;
CGFloat const mLbTitleHeight = 30.0f;
CGFloat const mTvReasonHeight = 50.0f;

CGFloat const mVerticalMargin = 10.0f;



enum {
    maintainingViewButtonTag_close = 10,
}LyMaintainingViewButtonTag;


@interface LyMaintainingView ()
{
    UIView                  *viewUseful;
    UIButton                *btnClose;
    UIImageView             *ivIcon;
    UILabel                 *lbTitle;
    UITextView              *tvReason;
    
    CGPoint                 centerViewUseful;
}
@end


@implementation LyMaintainingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [self initSubviews];
    }
    
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [self initSubviews];
    }
    
    return self;
}


+ (instancetype)maintainingViewWithReason:(NSString *)reason {
    LyMaintainingView *maintain = [[LyMaintainingView alloc] initWithReason:reason];
    
    return maintain;
}

- (instancetype)initWithReason:(NSString *)reason {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _reason = reason;
        [self initSubviews];
    }
    
    return self;
}


- (void)initSubviews {
    [self setBackgroundColor:LyMaskColor];
    
    viewUseful = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f-mWidth/2.0f, SCREEN_HEIGHT/2.0f-mHeight/2.0f, mWidth, mHeight)];
    [viewUseful setBackgroundColor:LyWhiteLightgrayColor];
    [viewUseful.layer setCornerRadius:horizontalSpace];
    
    centerViewUseful = viewUseful.center;
    
    btnClose = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(viewUseful.frame)-mBtnCloseSize*2/3.0f, -mBtnCloseSize/3.0f, mBtnCloseSize, mBtnCloseSize)];
    [btnClose setImage:[LyUtil imageForImageName:@"maintainingView_btnClose" needCache:NO] forState:UIControlStateNormal];
    [btnClose setTag:maintainingViewButtonTag_close];
    [btnClose addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake(mWidth/2.0f-mIvIconSize/2.0f, mHeight/2.0f-(mIvIconSize+mLbTitleHeight+mTvReasonHeight+mVerticalMargin+mVerticalMargin/2.0f)/2.0f, mIvIconSize, mIvIconSize)];
    [ivIcon setImage:[LyUtil imageForImageName:@"maintaingingView_icon" needCache:NO]];

    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, ivIcon.frame.origin.y+CGRectGetHeight(ivIcon.frame)+mVerticalMargin, mWidth-horizontalSpace*2, mLbTitleHeight)];
    [lbTitle setFont:LyFont(16)];
    [lbTitle setTextColor:LyBlackColor];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    [lbTitle setNumberOfLines:0];

    NSMutableAttributedString *strTitle = [[NSMutableAttributedString alloc] initWithString:@"服务器正在维护...\n带来不便，敬请谅解"];
    [strTitle addAttribute:NSFontAttributeName value:LyFont(14) range:[@"服务器正在维护...\n带来不便，敬请谅解" rangeOfString:@"带来不便，敬请谅解"]];
    [lbTitle setAttributedText:strTitle];
    
    tvReason = [[UITextView alloc] initWithFrame:CGRectMake(horizontalSpace, lbTitle.frame.origin.y+CGRectGetHeight(lbTitle.frame)+mVerticalMargin/2.0f, mWidth-horizontalSpace*2, mTvReasonHeight)];
    [tvReason setFont:LyFont(14)];
    [tvReason setTextColor:[UIColor darkGrayColor]];
    [tvReason setTextAlignment:NSTextAlignmentLeft];
    [tvReason setBackgroundColor:LyWhiteLightgrayColor];
    
    [tvReason setText:_reason];
    
    [viewUseful addSubview:btnClose];
    [viewUseful addSubview:ivIcon];
    [viewUseful addSubview:lbTitle];
    [viewUseful addSubview:tvReason];
    
    [self addSubview:viewUseful];
}


- (void)show {
    
    [self setAlpha:0.0f];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [LyUtil startAnimationWithView:self
                 animationDuration:LyAnimationDuration
                         initAlpha:0.0f
                 destinationAplhas:1.0f
                         completion:^(BOOL finished) {
                             
                         }];
    
}


- (void)hide {
    [LyUtil startAnimationWithView:self
                 animationDuration:LyAnimationDuration
                         initAlpha:1.0f
                 destinationAplhas:0.0f
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
}


- (void)targetForButton:(UIButton *)button {
    if (maintainingViewButtonTag_close == button.tag) {
        [self hide];
    }
}



@end
