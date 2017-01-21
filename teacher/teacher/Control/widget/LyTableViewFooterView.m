//
//  LyTableViewFooterView.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/14.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyTableViewFooterView.h"

#import "UIView+LyExtension.h"
#import "LyUtil.h"


CGFloat const tvFooterViewDefaultHeight = 50.0f;


CGFloat const indicatorWidth = 30.0f;
CGFloat const indicatorHeight = indicatorWidth;

CGFloat const indicatorLargeWidth = 40.0f;
CGFloat const indicatorLargeHeight = indicatorLargeWidth;



#define lbTitleFont                         LyFont(14)



@interface LyTableViewFooterView ()
{
    UIActivityIndicatorView             *indicator;
    UILabel                             *lbTitle;
}
@end


@implementation LyTableViewFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+ (instancetype)tableViewFooterViewWithDelegate:(id<LyTableViewFooterViewDelegate>)deledate
{
    LyTableViewFooterView *tvFooter = [[LyTableViewFooterView alloc] initWithDelegate:deledate];
    
    return tvFooter;
}

- (instancetype)initWithDelegate:(id<LyTableViewFooterViewDelegate>)delegate
{
    if (self = [super initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, tvFooterViewDefaultHeight)])
    {
        _delegate = delegate;
        
        [self initAndLayoutSubviews];
    }
    
    return self;
}


- (instancetype)init
{
    if (self = [super initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, tvFooterViewDefaultHeight)])
    {
        [self initAndLayoutSubviews];
    }
    
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        [self initAndLayoutSubviews];
    }
    
    
    return self;
}


- (void)initAndLayoutSubviews
{
    _title = @"正在加载";
    _titleForDisable = @"没有更多了";
    _style = UIActivityIndicatorViewStyleWhite;
    _tintColor = LyTvFooterColor;
    _font = lbTitleFont;
    
    CGSize sizeLbTitle = [_title sizeWithAttributes:@{NSFontAttributeName:_font}];
    
    indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake( CGRectGetWidth(self.frame)/2.0f-(indicatorWidth+sizeLbTitle.width)/2.0f, CGRectGetHeight(self.frame)/2.0f-indicatorHeight/2.0f, indicatorWidth, indicatorHeight)];
    [indicator setActivityIndicatorViewStyle:_style];
    [indicator setColor:_tintColor];
    
    
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake( indicator.frame.origin.x+CGRectGetWidth(indicator.frame), indicator.ly_y+CGRectGetHeight(indicator.frame)/2.0f-sizeLbTitle.height/2.0f, sizeLbTitle.width, sizeLbTitle.height)];
    [lbTitle setFont:_font];
    [lbTitle setTextColor:_tintColor];
    [lbTitle setText:_title];
    
    
    [indicator setUserInteractionEnabled:YES];
    [lbTitle setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForTapGesture)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:tapGesture];
    
    
    
    [self addSubview:indicator];
    [self addSubview:lbTitle];
    
    
    [self setStatus:LyTableViewFooterViewStatus_normal];
}


- (void)setStatus:(LyTableViewFooterViewStatus)status
{
    [indicator stopAnimating];
    _status = status;
    
    switch ( _status) {
        case LyTableViewFooterViewStatus_normal: {
            [self setTitle:@"上拉加载更多"];
            break;
        }
        case LyTableViewFooterViewStatus_disable: {
            
            [self setTitle:@"没有更多了"];
            
            break;
        }
        case LyTableViewFooterViewStatus_isAnimation: {
            
            [self setTitle:@"正在加载"];
            
            break;
        }
        case LyTableViewFooterViewStatus_error: {
            
            [self setTitle:@"出错了"];
            
            break;
        }
    }
    
    
}



- (void)setTitle:(NSString *)title
{
    if ( !title || [title isEqualToString:@""])
    {
        return;
    }
    
    _title = title;
    
    CGSize sizeLbTitle = [_title sizeWithAttributes:@{NSFontAttributeName:_font}];
    
    if ( UIActivityIndicatorViewStyleWhiteLarge == _style)
    {
        [indicator setFrame:CGRectMake( CGRectGetWidth(self.frame)/2.0f-(indicatorLargeWidth+sizeLbTitle.width)/2.0f, CGRectGetHeight(self.frame)/2.0f-indicatorLargeHeight/2.0f, indicatorLargeWidth, indicatorLargeHeight)];
    }
    else
    {
        [indicator setFrame:CGRectMake( CGRectGetWidth(self.frame)/2.0f-(indicatorWidth+sizeLbTitle.width)/2.0f, CGRectGetHeight(self.frame)/2.0f-indicatorHeight/2.0f, indicatorWidth, indicatorHeight)];
        
    }
    
    [lbTitle setFrame:CGRectMake( indicator.frame.origin.x+CGRectGetWidth(indicator.frame), indicator.ly_y+CGRectGetHeight(indicator.frame)/2.0f-sizeLbTitle.height/2.0f, sizeLbTitle.width, sizeLbTitle.height)];
    [lbTitle setText:_title];
    
}


- (void)setStyle:(UIActivityIndicatorViewStyle)style
{
    if ( style == _style)
    {
        return;
    }
    
    _style = style;
    
    [indicator setActivityIndicatorViewStyle:_style];
    [indicator setColor:_tintColor];
    
    
    CGSize sizeLbTitle = [_title sizeWithAttributes:@{NSFontAttributeName:_font}];
    
    if ( UIActivityIndicatorViewStyleWhiteLarge == _style)
    {
        
        [indicator setFrame:CGRectMake( CGRectGetWidth(self.frame)/2.0f-(indicatorLargeWidth+sizeLbTitle.width)/2.0f, CGRectGetHeight(self.frame)/2.0f-indicatorLargeHeight/2.0f, indicatorLargeWidth, indicatorLargeHeight)];
    }
    else
    {
        [indicator setFrame:CGRectMake( CGRectGetWidth(self.frame)/2.0f-(indicatorWidth+sizeLbTitle.width)/2.0f, CGRectGetHeight(self.frame)/2.0f-indicatorHeight/2.0f, indicatorWidth, indicatorHeight)];
    }
    
    [lbTitle setFrame:CGRectMake( indicator.frame.origin.x+CGRectGetWidth(indicator.frame), indicator.ly_y+CGRectGetHeight(indicator.frame)/2.0f-sizeLbTitle.height/2.0f, sizeLbTitle.width, sizeLbTitle.height)];
}




- (void)setFont:(UIFont *)font
{
    if ( !font)
    {
        return;
    }
    
    _font = font;
    
    CGSize sizeLbTitle = [_title sizeWithAttributes:@{NSFontAttributeName:_font}];
    
    if ( UIActivityIndicatorViewStyleWhiteLarge == _style)
    {
        [indicator setFrame:CGRectMake( CGRectGetWidth(self.frame)/2.0f-(indicatorLargeWidth+sizeLbTitle.width)/2.0f, CGRectGetHeight(self.frame)/2.0f-indicatorLargeHeight/2.0f, indicatorLargeWidth, indicatorLargeHeight)];
    }
    else
    {
        [indicator setFrame:CGRectMake( CGRectGetWidth(self.frame)/2.0f-(indicatorWidth+sizeLbTitle.width)/2.0f, CGRectGetHeight(self.frame)/2.0f-indicatorHeight/2.0f, indicatorWidth, indicatorHeight)];
        
    }
    
    [lbTitle setFont:_font];
    [lbTitle setFrame:CGRectMake( indicator.frame.origin.x+CGRectGetWidth(indicator.frame), indicator.ly_y+CGRectGetHeight(indicator.frame)/2.0f-sizeLbTitle.height/2.0f, sizeLbTitle.width, sizeLbTitle.height)];
    
}



- (void)startAnimation
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    _animation = YES;
    [self setStatus:LyTableViewFooterViewStatus_isAnimation];
    [indicator startAnimating];
}

- (void)stopAnimation
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    _animation = NO;
    [self setStatus:LyTableViewFooterViewStatus_normal];
    [indicator stopAnimating];
}



- (void)targetForTapGesture
{
    if ( LyTableViewFooterViewStatus_disable == _status)
    {
        return;
    }
    
    if ( [_delegate respondsToSelector:@selector(loadMoreData:)])
    {
        [self startAnimation];
        [_delegate loadMoreData:self];
    }
}


@end





