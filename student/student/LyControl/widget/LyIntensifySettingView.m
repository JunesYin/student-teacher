//
//  LyIntensifySettingView.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/16.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyIntensifySettingView.h"
#import "LyUtil.h"




#define isvWidth                            SCREEN_WIDTH
#define isvHeight                           SCREEN_HEIGHT


#define viewUsefulWidth                     (isvWidth*9.0/10.0f)
CGFloat const isViewUsefulHeight = 200.0f;



#define viewItemWidth                       (viewUsefulWidth*4.0/5.0f)
//CGFloat const LyViewItemHeight = 50.0f;

#define lbTitleWidth                        viewItemWidth
//#define LyViewItemHeight                       LyViewItemHeight
#define lbTitleFont                         LyFont(18)

#define horizontalLineWidth                 viewItemWidth


CGFloat const ivItemWidth = 20.0f;
CGFloat const ivItemHeight = ivItemWidth;

#define lbItemWidth                         (viewItemWidth-ivItemWidth-swhItemWidth-horizontalSpace*2.0f)
//CGFloat const lbItemHeight = 20.0f;
#define lbItemFont                          LyFont(12)

CGFloat const swhItemWidth = 40.0f;
CGFloat const swhItemHeight = 20.0f;

#define btnDoneWidth                        (viewUsefulWidth/2.0f)
CGFloat const btnDoneHeight = 40.0f;






typedef NS_ENUM( NSInteger, LyIntensifySettingViewSwitchMode)
{
    intensifySettingViewSwitchMode_next = 43,
};


typedef NS_ENUM( NSInteger, LyIntensifySettingViewButtonMode)
{
    intensifySettingViewButtonMode_done = 43
};



@interface LyIntensifySettingView ()
{
    UIView                      *viewMask;
    
    UIView                      *viewUseful;
    CGPoint                     centerViewUseful;
    
    UILabel                     *lbTitle;
    
    UIView                      *viewFirst;
//    UIView                      *viewSecond;
    
    UISwitch                    *swhNext;
//    UISwitch                    *swhSolution;
    
    
    UIButton                    *btnDone;
}
@end



@implementation LyIntensifySettingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if ( self = [super initWithFrame:CGRectMake( 0, 0, isvWidth, isvHeight)])
//    {
//        [self initAndLyaoutSubviews];
//    }
//    
//    return self;
//}
//
//
//- (instancetype)init
//{
//    if ( self = [super initWithFrame:CGRectMake( 0, 0, isvWidth, isvHeight)])
//    {
//        [self initAndLyaoutSubviews];
//    }
//    
//    return self;
//}



+ (instancetype)settingViewWithMode:(LyIntensifySettingViewMode)mode
{
    LyIntensifySettingView *view = [[LyIntensifySettingView alloc] initWithMode:mode];
    
    return view;
}

- (instancetype)initWithMode:(LyIntensifySettingViewMode)mode
{
    if ( self = [super initWithFrame:CGRectMake( 0, 0, isvWidth, isvHeight)])
    {
        _mode = mode;
        
        [self initAndLyaoutSubviews];
    }
    
    return self;
}



- (void)initAndLyaoutSubviews
{
    viewMask = [[UIView alloc] initWithFrame:self.bounds];
    [viewMask setBackgroundColor:LyMaskColor];
    [self addSubview:viewMask];
    
    
    
    viewUseful = [[UIView alloc] initWithFrame:CGRectMake( isvWidth/2.0f-viewUsefulWidth/2.0f, isvHeight/4.0f, viewUsefulWidth, isViewUsefulHeight)];
    [viewUseful setBackgroundColor:LyWhiteLightgrayColor];
    [[viewUseful layer] setCornerRadius:5.0f];
    [viewUseful setOpaque:YES];
    centerViewUseful = [viewUseful center];
    
    
    
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake( viewUsefulWidth/2.0f-lbTitleWidth/2.0f, 0, lbTitleWidth, LyViewItemHeight)];
    [lbTitle setFont:lbTitleFont];
    [lbTitle setTextColor:LyBlackColor];
    [lbTitle setText:({
        NSString *str;
        switch ( _mode) {
            case LyIntensifySettingViewMode_intensify: {
                str = @"练习设置";
                break;
            }
            case LyIntensifySettingViewMode_myMistake: {
                str = @"答题设置";
                break;
            }
            default: {
                str = @"练习设置";
                break;
            }
        }
        str;
    })];
    
    
    viewFirst = [[UIView alloc] initWithFrame:CGRectMake( viewUsefulWidth/2.0f-viewItemWidth/2.0f, lbTitle.frame.origin.y+CGRectGetHeight(lbTitle.frame), viewItemWidth, LyViewItemHeight)];
    [viewFirst setBackgroundColor:[UIColor clearColor]];
    
    
    UIImageView *ivFirst = [[UIImageView alloc] initWithFrame:CGRectMake( 0, LyViewItemHeight/2.0f-ivItemHeight/2.0f, ivItemWidth, ivItemHeight)];
    [ivFirst setContentMode:UIViewContentModeScaleAspectFit];
    [ivFirst setImage:({
        UIImage *image;
        switch ( _mode) {
            case LyIntensifySettingViewMode_intensify: {
                image = [LyUtil imageForImageName:@"settingView_intensify" needCache:NO];
                break;
            }
            case LyIntensifySettingViewMode_myMistake: {
                image = [LyUtil imageForImageName:@"settingView_myMistake" needCache:NO];
                break;
            }
            default: {
                image = [LyUtil imageForImageName:@"settingView_intensify" needCache:NO];
                break;
            }
        }
        image;
    })];
    
    UILabel *lbFirst = [[UILabel alloc]initWithFrame:CGRectMake( ivFirst.frame.origin.x+CGRectGetWidth(ivFirst.frame)+horizontalSpace, LyViewItemHeight/2.0f-lbItemHeight/2.0f, lbItemWidth, lbItemHeight)];
    [lbFirst setTextColor:LyBlackColor];
    [lbFirst setFont:lbItemFont];
    [lbFirst setText:({
        NSString *str;
        switch ( _mode) {
            case LyIntensifySettingViewMode_intensify: {
                str = @"答题正确自动跳转至下一题";
                break;
            }
            case LyIntensifySettingViewMode_myMistake: {
                str = @"答对后自动移除错题";
                break;
            }
            default: {
                str = @"答题正确自动跳转至下一题";;
                break;
            }
        }
        str;
    })];
    
    swhNext = [[UISwitch alloc] init];
    [swhNext addTarget:self action:@selector(targetForSwitchItem:) forControlEvents:UIControlEventValueChanged];
    [swhNext setTag:intensifySettingViewSwitchMode_next];
    [swhNext setTransform:CGAffineTransformMakeScale( 0.75, 0.75)];
    [swhNext setCenter:CGPointMake( viewItemWidth-swhItemWidth/2.0f, LyViewItemHeight/2.0f)];
    
    
    [viewFirst addSubview:ivFirst];
    [viewFirst addSubview:lbFirst];
    [viewFirst addSubview:swhNext];
    
    
    
    [self loadAutoFlag];
    
    
    UIView *horizontalLineFirst = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, viewItemWidth, LyHorizontalLineHeight)];
    [horizontalLineFirst setBackgroundColor:LyHorizontalLineColor];
    
    UIView *horizontalLineThird = [[UIView alloc] initWithFrame:CGRectMake( 0, LyViewItemHeight-LyHorizontalLineHeight, viewItemWidth, LyHorizontalLineHeight)];
    [horizontalLineThird setBackgroundColor:LyHorizontalLineColor];
    
    
    [viewFirst addSubview:horizontalLineFirst];
    [viewFirst addSubview:horizontalLineThird];
    
    
    btnDone = [[UIButton alloc] initWithFrame:CGRectMake( viewUsefulWidth/2.0f-btnDoneWidth/2.0f, isViewUsefulHeight-verticalSpace*2.0f-btnDoneHeight, btnDoneWidth, btnDoneHeight)];
    [btnDone setBackgroundColor:Ly517ThemeColor];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDone setTitle:@"确定" forState:UIControlStateNormal];
    [btnDone setTag:intensifySettingViewButtonMode_done];
    [[btnDone layer] setCornerRadius:5.0f];
    [btnDone setClipsToBounds:YES];
    [btnDone addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [viewUseful addSubview:lbTitle];
    [viewUseful addSubview:viewFirst];
    
    [viewUseful addSubview:btnDone];
    
    
    [self addSubview:viewUseful];
}


- (void)loadAutoFlag
{
    switch ( _mode) {
        case LyIntensifySettingViewMode_intensify: {
            
            BOOL flagNext = [LyUtil loadTheoryStudyAutoFlagWithMode:0];
            
            _flagAuto = flagNext;
            
            [swhNext setOn:_flagAuto];
            
            
            break;
        }
        case LyIntensifySettingViewMode_myMistake: {
            
            BOOL flagExclude = [LyUtil loadTheoryStudyAutoFlagWithMode:1];
            
            _flagAuto = flagExclude;
            
            [swhNext setOn:_flagAuto];
            
            break;
        }
    }
}


- (void)show
{
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [LyUtil startAnimationWithView:viewMask
                 animationDuration:0.3f
                         initAlpha:0.0f
                 destinationAplhas:1.0f
                         completion:^(BOOL finished) {
                             ;
                         }];
    
    [LyUtil startAnimationWithView:viewUseful
                 animationDuration:0.3f
                      initialPoint:CGPointMake( centerViewUseful.x, centerViewUseful.y+CGRectGetHeight(viewUseful.frame))
                  destinationPoint:centerViewUseful
                        completion:^(BOOL finished) {
                            ;
                        }];
    

}



- (void)hide
{
    
    [LyUtil startAnimationWithView:viewMask
                 animationDuration:0.3f
                         initAlpha:1.0f
                 destinationAplhas:0.0f completion:^(BOOL finished) {
                                      
                 }];
    
    
    [LyUtil startAnimationWithView:viewUseful
                 animationDuration:0.3f
                      initialPoint:centerViewUseful
                  destinationPoint:CGPointMake( centerViewUseful.x, centerViewUseful.y+CGRectGetHeight(viewUseful.frame))
                        completion:^(BOOL finished) {
                            [self removeFromSuperview];
                            [viewMask setAlpha:1.0f];
                        }];
    
    
}


- (void)targetForButton:(UIButton *)button
{
    _flagAuto = [swhNext isOn];
    
    [LyUtil setTheoryStudyAutoFlagAutoWithMode:_mode andFlag:_flagAuto];
    
    switch ( _mode) {
        case LyIntensifySettingViewMode_intensify: {
            if ( [_delegate respondsToSelector:@selector(onDoneIntensifySettingView:andFlagAuto:)])
            {
                [_delegate onDoneIntensifySettingView:self andFlagAuto:_flagAuto];
            }
            break;
        }
        case LyIntensifySettingViewMode_myMistake: {
            if ( [_delegate respondsToSelector:@selector(onDoneIntensifySettingView:andFlagAuto:)])
            {
                [_delegate onDoneIntensifySettingView:self andFlagAuto:_flagAuto];
            }
            break;
        }
    }
    
}



- (void)targetForSwitchItem:(UISwitch *)switchItem
{
    
    switch ( [switchItem tag]) {
        case intensifySettingViewSwitchMode_next: {
            
            _flagAuto = [switchItem isOn];
            
            break;
        }
    }
}




@end
