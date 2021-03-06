//
//  LyIndicator.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/27.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyIndicator.h"
//#import "DDIndicator.h"
#import "LyUtil.h"


#define viewUsefulWidth                     147.0f
#define viewUsefulHeight                    viewUsefulWidth


#define indicatorWidth                      40.0f
#define indicatorHeight                     indicatorWidth


#define titleWidth                           viewUsefulWidth
#define titleHeight                          20.0f
#define titleFont                            LyFont(14)


@interface LyIndicator ()
{
    
    UIButton                    *btnBig;
    
    
    UIButton                    *btnCancel;
    
    
    UIView                      *viewUseful;
    UIButton                    *btnInterupt;
    UILabel                     *lbTitle;
    
    
    CGFloat     yVUD;
}
@end


@implementation LyIndicator

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)indicatorWithTitle:(NSString *)title
{
    LyIndicator *indicator = [[LyIndicator alloc] initWithTitle:title];
    
    return indicator;
}



- (instancetype)initWithTitle:(NSString *)title
{
    if ( self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)])
    {
        _title = title;
        _allowCancel = NO;
        [self initAndLayoutSubview];
    }
    
    return self;
}


+ (instancetype)indicatorWithTitle:(NSString *)title allowCancel:(BOOL)allowCancel
{
    LyIndicator *indicator = [[LyIndicator alloc] initWithTitle:title allowCancel:allowCancel];
    
    return indicator;
}



- (instancetype)initWithTitle:(NSString *)title allowCancel:(BOOL)allowCancel
{
    if ( self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)])
    {
        _title = title;
        _allowCancel = allowCancel;
        [self initAndLayoutSubview];
    }
    
    return self;
}


- (void)dealloc
{
    [self removeObserverForNotification];
}



- (void)initAndLayoutSubview
{
    yVUD = SCREEN_CENTER_Y;
    [self addObserverForNotification];
    
    btnBig = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    if (![LyUtil validateString:_title]) {
        _title = @"正在加载...";
    }
    
    [btnBig setBackgroundColor:[UIColor clearColor]];
    

    viewUseful = [[UIView alloc] initWithFrame:CGRectMake( SCREEN_WIDTH/2.0f-viewUsefulWidth/2.0f, SCREEN_HEIGHT/2.0f-viewUsefulHeight/2.0f, viewUsefulWidth, viewUsefulHeight)];
    [viewUseful setBackgroundColor:LyMaskColor];
    [[viewUseful layer] setCornerRadius:10.0f];
    
    
    _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake( viewUsefulWidth/2.0f-indicatorWidth/2.0f, viewUsefulHeight/2.0f-(indicatorHeight+titleHeight+verticalSpace*2)/2.0f, indicatorWidth, indicatorHeight)];
    [_indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_indicator setColor:[UIColor whiteColor]];
    
    
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake( 0, _indicator.ly_y+CGRectGetHeight(_indicator.frame)+verticalSpace*2, titleWidth, titleHeight)];
    lbTitle.font = titleFont;
    [lbTitle setTextColor:[UIColor whiteColor]];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    [lbTitle setText:_title];
    
    
    if (_allowCancel)
    {
        btnCancel = [[UIButton alloc] initWithFrame:CGRectMake( viewUsefulWidth-10-20, 10, 20, 20)];
        [btnCancel setImage:[UIImage imageNamed:@"pv_btn_close"] forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(targetForBtnCancel:) forControlEvents:UIControlEventTouchUpInside];
        [viewUseful addSubview:btnCancel];
    
    }
    
    [viewUseful addSubview:_indicator];
    [viewUseful addSubview:lbTitle];


    
    [self addSubview:btnBig];
    [self addSubview:viewUseful];
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


- (BOOL)isAnimating
{
    if ( [_indicator isAnimating])
    {
        return YES;
    }
    
    return NO;
}


- (void)targetForBtnCancel:(UIButton *)button {
    if (!_allowCancel) {
        [self stopAnimation];
    }
}



- (void)startInView:(UIView *)view
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_indicator startAnimating];
    
    if ( [_delegate respondsToSelector:@selector(onDidStartIndicator:)])
    {
        [_delegate onDidStartIndicator:self];
    }
}


- (void)startAnimation {
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    if ( ![_indicator isAnimating]) {
        [_indicator startAnimating];
    }
    
    if ( [_delegate respondsToSelector:@selector(onDidStartIndicator:)]) {
        [_delegate onDidStartIndicator:self];
    }
}

- (void)stopAnimation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if ( [_indicator isAnimating]) {
        [_indicator stopAnimating];
    }
    
    [self removeFromSuperview];
    
    if ( [_delegate respondsToSelector:@selector(onDidStopIndicator:)]) {
        [_delegate onDidStopIndicator:self];
    }
}



- (void)start
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    if ( ![_indicator isAnimating])
    {
        [_indicator startAnimating];
    }
    
    if ( [_delegate respondsToSelector:@selector(onDidStartIndicator:)])
    {
        [_delegate onDidStartIndicator:self];
    }
}


- (void)stop
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if ( [_indicator isAnimating])
    {
        [_indicator stopAnimating];
    }

    [self removeFromSuperview];
    
    if ( [_delegate respondsToSelector:@selector(onDidStopIndicator:)])
    {
        [_delegate onDidStopIndicator:self];
    }
    
}


- (void)addObserverForNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(actionForNotification_keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(actionForNotificaton_keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeObserverForNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - NSNotification -- UIKeyboard
- (void)actionForNotification_keyboardWillShow:(NSNotification *)notification
{
    CGFloat fHeightKeyboard = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    if (SCREEN_HEIGHT - fHeightKeyboard > viewUseful.ly_y + viewUseful.ly_height + 10)
    {
        viewUseful.ly_y = SCREEN_HEIGHT - fHeightKeyboard - viewUseful.ly_height - 10;
    }
}

- (void)actionForNotificaton_keyboardWillHide:(NSNotification *)notification
{
    
    if (viewUseful.ly_y < yVUD) {
        [UIView animateWithDuration:0.1
                              delay:0
             usingSpringWithDamping:0.5
              initialSpringVelocity:0
                            options:UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             viewUseful.ly_y = yVUD;
                         } completion:nil];
    }
}


@end
