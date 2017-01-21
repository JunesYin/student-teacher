//
//  LyTableViewFooterView.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/14.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyTableViewFooterView.h"
#import "LyUtil.h"


CGFloat const tvFooterViewDefaultHeight = 50.0f;


CGFloat const tvfIndicatorSize = 30.0f;

CGFloat const tvfIndicatorLargeSize = 40.0f;



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
        
        [self initSubviews];
    }
    
    return self;
}



- (instancetype)init
{
    if (self = [super initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, tvFooterViewDefaultHeight)])
    {
        [self initSubviews];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        [self initSubviews];
    }
    
    
    return self;
}


- (void)initSubviews
{
    _title = @"正在加载";
    _titleForDisable = @"没有更多了";
    _style = UIActivityIndicatorViewStyleWhite;
    _tintColor = LyTvFooterColor;
    _font = lbTitleFont;
    
    CGSize sizeLbTitle = [_title sizeWithAttributes:@{NSFontAttributeName:_font}];
    
    indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake( CGRectGetWidth(self.frame)/2.0f-(tvfIndicatorSize+sizeLbTitle.width)/2.0f, CGRectGetHeight(self.frame)/2.0f-tvfIndicatorSize/2.0f, tvfIndicatorSize, tvfIndicatorSize)];
    [indicator setActivityIndicatorViewStyle:_style];
    [indicator setColor:_tintColor];
    
    
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake( indicator.frame.origin.x+CGRectGetWidth(indicator.frame), indicator.frame.origin.y+CGRectGetHeight(indicator.frame)/2.0f-sizeLbTitle.height/2.0f, sizeLbTitle.width, sizeLbTitle.height)];
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
    _status = status;
    
    switch ( _status) {
        case LyTableViewFooterViewStatus_normal: {
            [self setTitle:@"点击或上拉加载更多"];
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
        [indicator setFrame:CGRectMake( CGRectGetWidth(self.frame)/2.0f-(tvfIndicatorLargeSize+sizeLbTitle.width)/2.0f, CGRectGetHeight(self.frame)/2.0f-tvfIndicatorLargeSize/2.0f, tvfIndicatorLargeSize, tvfIndicatorLargeSize)];
    }
    else
    {
        [indicator setFrame:CGRectMake( CGRectGetWidth(self.frame)/2.0f-(tvfIndicatorSize+sizeLbTitle.width)/2.0f, CGRectGetHeight(self.frame)/2.0f-tvfIndicatorSize/2.0f, tvfIndicatorSize, tvfIndicatorSize)];
        
    }
    
    [lbTitle setFrame:CGRectMake( indicator.frame.origin.x+CGRectGetWidth(indicator.frame), indicator.frame.origin.y+CGRectGetHeight(indicator.frame)/2.0f-sizeLbTitle.height/2.0f, sizeLbTitle.width, sizeLbTitle.height)];
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
        
        [indicator setFrame:CGRectMake( CGRectGetWidth(self.frame)/2.0f-(tvfIndicatorLargeSize+sizeLbTitle.width)/2.0f, CGRectGetHeight(self.frame)/2.0f-tvfIndicatorLargeSize/2.0f, tvfIndicatorLargeSize, tvfIndicatorLargeSize)];
    }
    else
    {
        [indicator setFrame:CGRectMake( CGRectGetWidth(self.frame)/2.0f-(tvfIndicatorSize+sizeLbTitle.width)/2.0f, CGRectGetHeight(self.frame)/2.0f-tvfIndicatorSize/2.0f, tvfIndicatorSize, tvfIndicatorSize)];
    }
    
    [lbTitle setFrame:CGRectMake( indicator.frame.origin.x+CGRectGetWidth(indicator.frame), indicator.frame.origin.y+CGRectGetHeight(indicator.frame)/2.0f-sizeLbTitle.height/2.0f, sizeLbTitle.width, sizeLbTitle.height)];
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
        [indicator setFrame:CGRectMake( CGRectGetWidth(self.frame)/2.0f-(tvfIndicatorLargeSize+sizeLbTitle.width)/2.0f, CGRectGetHeight(self.frame)/2.0f-tvfIndicatorLargeSize/2.0f, tvfIndicatorLargeSize, tvfIndicatorLargeSize)];
    }
    else
    {
        [indicator setFrame:CGRectMake( CGRectGetWidth(self.frame)/2.0f-(tvfIndicatorSize+sizeLbTitle.width)/2.0f, CGRectGetHeight(self.frame)/2.0f-tvfIndicatorSize/2.0f, tvfIndicatorSize, tvfIndicatorSize)];
        
    }
    
    [lbTitle setFont:_font];
    [lbTitle setFrame:CGRectMake( indicator.frame.origin.x+CGRectGetWidth(indicator.frame), indicator.frame.origin.y+CGRectGetHeight(indicator.frame)/2.0f-sizeLbTitle.height/2.0f, sizeLbTitle.width, sizeLbTitle.height)];
    
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
//    if ( LyTableViewFooterViewStatus_disable == _status)
//    {
//        return;
//    }
    
    if ( [_delegate respondsToSelector:@selector(loadMoreData:)])
    {
        [_delegate loadMoreData:self];
    }
}


@end





