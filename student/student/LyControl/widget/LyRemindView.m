//
//  LyRemindView.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/27.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyRemindView.h"
#import "LyUtil.h"

NSTimeInterval const LyRemindViewDelayTime = 0.1f;


#define viewUsefulWidth                     150.0f
#define viewUsefulHeight                    viewUsefulWidth


#define ivIconWidth                         30.0f
#define ivIconHeight                        ivIconWidth

#define lbTitleWidth                        viewUsefulWidth
#define lbTitleHeight                       50.0f
#define lbTitleFont                         LyFont(15)



@interface LyRemindView ()
{
    UIButton                *btnBig;
    
    UIView                  *viewUseful;
    UIImageView             *ivIcon;
    
    UILabel                 *lbTitle;
}
@end


@implementation LyRemindView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+ (instancetype)remindWithMode:(LyRemindViewMode)mode withTitle:(NSString *)title
{
    LyRemindView *tmp = [[LyRemindView alloc] initWithMode:mode withTitle:title];
    
    return tmp;
}


- (instancetype)initWithMode:(LyRemindViewMode)mode withTitle:(NSString *)title
{
    if ( self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        if ( !_title)
        {
            _mode = mode;
            _title = title;
        }
        
        [self initSubviews];
    }
    
    return self;
}



- (void)initSubviews
{
    btnBig = [[UIButton alloc] initWithFrame:self.frame];
    [btnBig setBackgroundColor:[UIColor clearColor]];
    
    CGFloat widthViewUseful = viewUsefulWidth;
    
    CGFloat widthLbTitle = [_title sizeWithAttributes:@{NSFontAttributeName:lbTitleFont}].width;
    if ( widthLbTitle > widthViewUseful-horizontalSpace ) {
        widthViewUseful = widthLbTitle + horizontalSpace;
    }
    
    
    widthViewUseful = ( widthViewUseful > SCREEN_WIDTH/2.0f) ? SCREEN_WIDTH/2.0f : widthViewUseful;
    
    
    CGFloat fHeight = SCREEN_HEIGHT/2.0 - widthViewUseful/2.0;
    if ([LyUtil isKeybaordShowing]) {
        fHeight = SCREEN_HEIGHT/2.0 - widthViewUseful;
    }
    viewUseful = [[UIView alloc] initWithFrame:CGRectMake( SCREEN_WIDTH/2.0f-widthViewUseful/2.0f, fHeight, widthViewUseful, widthViewUseful)];
    [viewUseful setBackgroundColor:LyMaskColor];
    [[viewUseful layer] setCornerRadius:10.0f];
    
    
    ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake( widthViewUseful/2.0f-ivIconWidth/2.0f, widthViewUseful/2.0f-(ivIconHeight+lbTitleHeight)/2.0f+verticalSpace*2, ivIconWidth, ivIconHeight)];
    [ivIcon setContentMode:UIViewContentModeScaleAspectFill];
    NSString *strImageName = @"";
    
    switch (_mode) {
        case LyRemindViewMode_success: {
            strImageName = @"remindView_icon_success";
            break;
        }
        case LyRemindViewMode_fail:
        {
            strImageName = @"remindView_icon_fail";
            break;
        }
        case LyRemindViewMode_warn: {
            strImageName = @"remindView_icon_warn";
            break;
        }
        default:
        {
            strImageName = @"";
            break;
        }
    }
    
    [ivIcon setImage:[LyUtil imageForImageName:strImageName needCache:YES]];

    
    
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake( 0, ivIcon.frame.origin.y+CGRectGetHeight(ivIcon.frame), widthViewUseful, lbTitleHeight)];
    [lbTitle setTextColor:[UIColor whiteColor]];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    [lbTitle setFont:lbTitleFont];
    [lbTitle setNumberOfLines:0];
    [lbTitle setText:_title];
    
    
    
    [viewUseful addSubview:ivIcon];
    [viewUseful addSubview:lbTitle];
    
    
    [self addSubview:btnBig];
    [self addSubview:viewUseful];
    
    
}


- (void)show {
    [self performSelector:@selector(showRightNow) withObject:nil afterDelay:LyRemindViewDelayTime];
}

- (void)showRightNow {
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [self performSelector:@selector(hide) withObject:nil afterDelay:1.0f];
}


- (void)showWithTime:(NSNumber *)duration {
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [self performSelector:@selector(hide) withObject:nil afterDelay:[duration floatValue]];
}


- (void)showRightNowWithTime:(NSTimeInterval)duration {
    [self performSelector:@selector(showWithTime:) withObject:@(duration) afterDelay:LyRemindViewDelayTime];
}



- (void)hide {
    if ( [_delegate respondsToSelector:@selector(remindViewWillHide:)]) {
        [_delegate remindViewWillHide:self];
    }
    
    [LyUtil startAnimationWithView:self
                                  animationDuration:0.3f
                                          initAlpha:1.0f
                                  destinationAplhas:0.0f
                                          completion:^(BOOL finished) {
                                              [self setHidden:YES];
                                              [self setAlpha:1.0f];
                                              [self removeFromSuperview];
                                              
                                              if ( [_delegate respondsToSelector:@selector(remindViewDidHide:)]) {
                                                  [_delegate remindViewDidHide:self];
                                              }
                                          }];
}



@end
