//
//  LyCollectionReusableView.m
//  teacher
//
//  Created by Junes on 16/8/11.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyCollectionReusableView.h"
#import "LyUtil.h"



CGFloat const LyCollectionReusableViewHeight = 50.0f;

CGFloat const crvBtnFuncWidth = 90.0f;


@interface LyCollectionReusableView ()
{
    UILabel             *lbTitle;
    
//    UILabel             *lbDetail;
    
    UIButton            *btnFunc;
}
@end

@implementation LyCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, CGRectGetWidth(self.bounds)*2/3.0f, CGRectGetHeight(self.bounds))];
        [lbTitle setFont:[UIFont systemFontOfSize:16]];
        [lbTitle setTextColor:LyBlackColor];
        [lbTitle setTextAlignment:NSTextAlignmentLeft];
        
        
//        lbDetail = [[UILabel alloc] initWithFrame:CGRectMake(lbTitle.frame.origin.x+CGRectGetWidth(lbTitle.frame)+horizontalSpace, 0, CGRectGetWidth(self.bounds)/3.0f, CGRectGetHeight(self.bounds))];
//        [lbDetail setFont:[UIFont systemFontOfSize:14]];
//        [lbDetail setTextColor:[UIColor lightGrayColor]];
//        [lbDetail setTextAlignment:NSTextAlignmentLeft];
        
        
        [self addSubview:lbTitle];
//        [self addSubview:lbDetail];
    }
    return self;
}


- (void)setTitle:(NSString *)title {// detail:(NSString *)detail {
    [lbTitle setText:title];
//    [lbDetail setText:detail];
}

- (void)setFunc:(NSString *)func {
    if (!btnFunc) {
        btnFunc = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)-horizontalSpace-crvBtnFuncWidth, CGRectGetHeight(self.bounds)/2.0f-LyCollectionReusableViewHeight/2.0f,crvBtnFuncWidth, LyCollectionReusableViewHeight)];
        [btnFunc setTitle:func forState:UIControlStateNormal];
        [btnFunc setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btnFunc setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [btnFunc.titleLabel setFont:LyFont(14)];
        [btnFunc addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btnFunc];
    } else {
        [btnFunc setTitle:func forState:UIControlStateNormal];
    }
}


- (void)setFuncHide:(BOOL)isHidden {
    [btnFunc setHidden:isHidden];
}


- (void)targetForButton:(UIButton *)button {
    [_delegate onClickButtonFuncByCollectionReusableView:self];
}

@end
