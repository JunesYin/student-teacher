//
//  LyDetailControlBar.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/21.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyDetailControlBar.h"
#import "LyUtil.h"





#define btnItemWidth_fourBig                (320*2/5.0f)
#define btnItemWidth_fourSmall              (320/5.0f)
#define btnItemMargin_four                  ((SCREEN_WIDTH-btnItemWidth_fourBig-btnItemWidth_fourSmall*3)/4.0f)

#define btnItemWidth_three                  (320/3.0f)
#define btnItemMargin_three                 ((SCREEN_WIDTH-btnItemWidth_three*3)/4.0f)

#define btnItemWidth_two                    (320/2.0f)
#define btnItemMargin_two                   ((SCREEN_WIDTH-btnItemWidth_two*2)/3.0f)

#define btnItemWidth_one                    (320*2/3.0f)
#define btnItemMargin_one                   ((SCREEN_WIDTH-btnItemWidth_one)/2.0f)



//#define dcbBtnItemHeight                       dcbHeight
//
//#define btnHugeWidth                        (SCREEN_WIDTH*2.0/3.0f)
//
//
//#define btnBigWidth                         (SCREEN_WIDTH*2.0f/5.0f)
//
//
//#define btnMidWidth                         (SCREEN_WIDTH/3.0f)
//
//
//#define btnSmallWidth                       (SCREEN_WIDTH/5.0f)


CGFloat const dcbHeight = 50.0f;

CGFloat const dcbBtnItemHeight = dcbHeight;


#define ivVerticalLineWidth                 2.0f
#define ivVerticalLineHeight                dcbHeight



typedef NS_ENUM( NSInteger, LyDetailControlBarButtonTag)
{
    detailControlBarButtonTag_attente,
    detailControlBarButtonTag_phone,
    detailControlBarButtonTag_message,
    detailControlBarButtonTag_apply,
    
    detailControlBarButtonTag_leaveMessage
};



@interface LyDetailControlBar ()
{
    UIButton                *btnAttente;
    UIButton                *btnPhone;
    UIButton                *btnMessage;
    
    UIButton                *btnApply;
    UIButton                *btnLeaveMessage;
    
//    UIButton                *btnFirst;
//    UIButton                *btnSecond;
//    UIButton                *btnThird;
//    
//    UIButton                *btnBig;
}
@end


@implementation LyDetailControlBar


+ (instancetype)controlBarWidthMode:(LyDetailControlBarMode)mode
{
    LyDetailControlBar *controlBar = [[LyDetailControlBar alloc] initWidthMode:mode];
    
    return controlBar;
}



- (instancetype)initWidthMode:(LyDetailControlBarMode)mode
{
    if ( self = [super initWithFrame:CGRectMake( 0, SCREEN_HEIGHT-dcbHeight, SCREEN_WIDTH, dcbHeight)])
    {
        _controlBarMode = mode;
        
        [self initAndLayoutSubview];
    }
    
    
    return self;
}



- (void)initAndLayoutSubview
{
    [self setBackgroundColor:LyWhiteLightgrayColor];
    
    
    switch ( _controlBarMode) {
        case LyDetailControlBarMode_chDsGe: {
            [self initAndLayoutSubviews_chDsGe];
            break;
        }
        case LyDetailControlBarMode_myCDG: {
            [self initAndLayoutSubviews_myCDG];
            break;
        }
            
        case LyDetailControlBarMode_user: {
            [self initAndLayoutSubviews_user];
            break;
        }
            
        case LyDetailControlBarMode_trainClass: {
            [self initAndLayoutSubviews_trainClass];
            break;
        }
        
        case LyDetailControlBarMode_studentInfo: {
            [self initAndLayoutSubviews_studentInfo];
            break;
        }
            
        default : {
            [self initAndLayoutSubviews_chDsGe];
            break;
        }
    }
    
}



- (void)initAndLayoutSubviews_chDsGe
{
    btnAttente = [[UIButton alloc] initWithFrame:CGRectMake( btnItemMargin_four, 0, btnItemWidth_fourSmall, dcbBtnItemHeight)];
    [btnAttente setTag:detailControlBarButtonTag_attente];
    [btnAttente setImage:[LyUtil imageForImageName:@"controlBar_attente_four_n" needCache:NO] forState:UIControlStateNormal];
    [btnAttente setImage:[LyUtil imageForImageName:@"controlBar_attente_four_h" needCache:NO] forState:UIControlStateSelected];
    [btnAttente addTarget:self action:@selector(dcbTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *verticalLineFirst = [[UIImageView alloc] initWithFrame:CGRectMake( btnAttente.frame.origin.x+CGRectGetWidth(btnAttente.frame)+btnItemMargin_four/2.0f-ivVerticalLineWidth/2.0f, 0, ivVerticalLineWidth, ivVerticalLineHeight)];
    [verticalLineFirst setImage:[LyUtil imageForImageName:@"controlBar_verticalLine" needCache:NO]];
    
    btnPhone = [[UIButton alloc] initWithFrame:CGRectMake( btnAttente.frame.origin.x+CGRectGetWidth(btnAttente.frame)+btnItemMargin_four, 0, btnItemWidth_fourSmall, dcbBtnItemHeight)];
    [btnPhone setTag:detailControlBarButtonTag_phone];
    [btnPhone setBackgroundImage:[LyUtil imageForImageName:@"controlBar_phone_four" needCache:NO] forState:UIControlStateNormal];
    [btnPhone addTarget:self action:@selector(dcbTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *verticalLineSecond = [[UIImageView alloc] initWithFrame:CGRectMake( btnPhone.frame.origin.x+CGRectGetWidth(btnPhone.frame)+btnItemMargin_four/2.0f-ivVerticalLineWidth/2.0f, 0, ivVerticalLineWidth, ivVerticalLineHeight)];
    [verticalLineSecond setImage:[LyUtil imageForImageName:@"controlBar_verticalLine" needCache:NO]];
    
    
    btnMessage = [[UIButton alloc] initWithFrame:CGRectMake( btnPhone.frame.origin.x+CGRectGetWidth(btnPhone.frame)+btnItemMargin_four, 0, btnItemWidth_fourSmall, dcbBtnItemHeight)];
    [btnMessage setTag:detailControlBarButtonTag_message];
    [btnMessage setImage:[LyUtil imageForImageName:@"controlBar_message_four" needCache:NO] forState:UIControlStateNormal];
    [btnMessage addTarget:self action:@selector(dcbTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    
    btnApply = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH-btnItemWidth_fourBig, 0, btnItemWidth_fourBig, dcbHeight)];
    [btnApply setTag:detailControlBarButtonTag_apply];
    [btnApply setBackgroundColor:Ly517ThemeColor];
    [btnApply setTitle:@"马上报名" forState:UIControlStateNormal];
    [btnApply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnApply addTarget:self action:@selector(dcbTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *horizontalLineTop = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, CGRectGetWidth(self.frame), LyHorizontalLineHeight)];
    [horizontalLineTop setBackgroundColor:LyHorizontalLineColor];
    
    
    
    [self addSubview:btnAttente];
    [self addSubview:verticalLineFirst];
    [self addSubview:btnPhone];
    [self addSubview:verticalLineSecond];
    [self addSubview:btnMessage];
    [self addSubview:btnApply];
    [self addSubview:horizontalLineTop];
    
}



- (void)initAndLayoutSubviews_myCDG
{
    btnAttente = [[UIButton alloc] initWithFrame:CGRectMake( btnItemMargin_three, 0, btnItemWidth_three, dcbBtnItemHeight)];
    [btnAttente setTag:detailControlBarButtonTag_attente];
    [btnAttente setImage:[LyUtil imageForImageName:@"controlBar_attente_three_n" needCache:NO] forState:UIControlStateNormal];
    [btnAttente setImage:[LyUtil imageForImageName:@"controlBar_attente_three_h" needCache:NO] forState:UIControlStateSelected];
    [btnAttente addTarget:self action:@selector(dcbTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *verticalLineFirst = [[UIImageView alloc] initWithFrame:CGRectMake( btnAttente.frame.origin.x+CGRectGetWidth(btnAttente.frame)+btnItemMargin_three/2.0f-ivVerticalLineWidth/2.0f, 0, ivVerticalLineWidth, ivVerticalLineHeight)];
    [verticalLineFirst setImage:[LyUtil imageForImageName:@"controlBar_verticalLine" needCache:NO]];
    
    
    btnPhone = [[UIButton alloc] initWithFrame:CGRectMake( btnAttente.frame.origin.x+CGRectGetWidth(btnAttente.frame)+btnItemMargin_three, 0, btnItemWidth_three, dcbBtnItemHeight)];
    [btnPhone setTag:detailControlBarButtonTag_phone];
    [btnPhone setImage:[LyUtil imageForImageName:@"controlBar_phone_three" needCache:NO] forState:UIControlStateNormal];
    [btnPhone addTarget:self action:@selector(dcbTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *verticalLineSecond = [[UIImageView alloc] initWithFrame:CGRectMake( btnPhone.frame.origin.x+CGRectGetWidth(btnPhone.frame)+btnItemMargin_three/2.0f-ivVerticalLineWidth/2.0f, 0, ivVerticalLineWidth, ivVerticalLineHeight)];
    [verticalLineSecond setImage:[LyUtil imageForImageName:@"controlBar_verticalLine" needCache:NO]];
    
    btnMessage = [[UIButton alloc] initWithFrame:CGRectMake( btnPhone.frame.origin.x+CGRectGetWidth(btnPhone.frame)+btnItemMargin_three, 0, btnItemWidth_three, dcbBtnItemHeight)];
    [btnMessage setTag:detailControlBarButtonTag_message];
    [btnMessage setImage:[LyUtil imageForImageName:@"controlBar_message_three" needCache:NO] forState:UIControlStateNormal];
    [btnMessage addTarget:self action:@selector(dcbTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *horizontalLineTop = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, CGRectGetWidth(self.frame), LyHorizontalLineHeight)];
    [horizontalLineTop setBackgroundColor:LyHorizontalLineColor];
    
    [self addSubview:btnAttente];
    [self addSubview:verticalLineFirst];
    [self addSubview:btnPhone];
    [self addSubview:verticalLineSecond];
    [self addSubview:btnMessage];
    [self addSubview:horizontalLineTop];
}



- (void)initAndLayoutSubviews_user
{
    btnAttente = [[UIButton alloc] initWithFrame:CGRectMake( btnItemMargin_one, 0, btnItemWidth_one, dcbBtnItemHeight)];
    [btnAttente setTag:detailControlBarButtonTag_attente];
    [btnAttente setImage:[LyUtil imageForImageName:@"controlBar_attente_two_n" needCache:NO] forState:UIControlStateNormal];
    [btnAttente setImage:[LyUtil imageForImageName:@"controlBar_attente_two_h" needCache:NO] forState:UIControlStateSelected];
    [btnAttente addTarget:self action:@selector(dcbTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btnAttente];
}



- (void)initAndLayoutSubviews_trainClass
{
    btnApply = [[UIButton alloc] initWithFrame:CGRectMake( btnItemMargin_one, dcbHeight/2.0f-dcbBtnItemHeight*4/5.0f/2.0f, btnItemWidth_one, dcbBtnItemHeight*4/5.0f)];
    [btnApply setTag:detailControlBarButtonTag_apply];
    [btnApply setBackgroundColor:Ly517ThemeColor];
    [btnApply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnApply setTitle:@"马上报名" forState:UIControlStateNormal];
    [[btnApply layer] setCornerRadius:5.0f];
    [btnApply setClipsToBounds:YES];
    [btnApply addTarget:self action:@selector(dcbTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:btnApply];
}


- (void)initAndLayoutSubviews_studentInfo
{
    btnMessage = [[UIButton alloc] initWithFrame:CGRectMake(btnItemMargin_two, 0, btnItemWidth_two, dcbBtnItemHeight)];
    [btnMessage setTag:detailControlBarButtonTag_message];
    [btnMessage setImage:[LyUtil imageForImageName:@"controlBar_message_two" needCache:NO] forState:UIControlStateNormal];
    [btnMessage addTarget:self action:@selector(dcbTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *verticalLineFirst = [[UIImageView alloc] initWithFrame:CGRectMake( btnMessage.frame.origin.x+CGRectGetWidth(btnMessage.frame)+btnItemMargin_two/2.0f-ivVerticalLineWidth/2.0f, 0, ivVerticalLineWidth, ivVerticalLineHeight)];
    [verticalLineFirst setImage:[LyUtil imageForImageName:@"controlBar_verticalLine" needCache:NO]];
    
    btnPhone = [[UIButton alloc] initWithFrame:CGRectMake(btnItemMargin_two*2+btnItemWidth_two, 0, btnItemWidth_two, dcbBtnItemHeight)];
    [btnPhone setTag:detailControlBarButtonTag_phone];
    [btnPhone setImage:[LyUtil imageForImageName:@"controlBar_phone_two" needCache:NO] forState:UIControlStateNormal];
    [btnPhone addTarget:self action:@selector(dcbTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btnMessage];
    [self addSubview:verticalLineFirst];
    [self addSubview:btnPhone];
}


- (void)iamGuider
{
    [btnApply setTitle:@"报名资询" forState:UIControlStateNormal];
}




- (void)dcbTargetForButtonItem:(UIButton *)button
{
    switch ( [button tag]) {
        case detailControlBarButtonTag_attente:
        {
            if ( [_delegate respondsToSelector:@selector(onClickedButtonAttente)])
            {
                [_delegate onClickedButtonAttente];
            }
            break;
        }
            
        case detailControlBarButtonTag_phone:
        {
            if ( LyDetailControlBarMode_user == _controlBarMode)
            {
                if ( [_delegate respondsToSelector:@selector(onClickedButtonLeaveMessage)])
                {
                    [_delegate onClickedButtonLeaveMessage];
                }
            }
            else
            {
                if ( [_delegate respondsToSelector:@selector(onClickedButtonPhone)])
                {
                    [_delegate onClickedButtonPhone];
                }
            }
            
            
            break;
        }
            
        case detailControlBarButtonTag_message:
        {
            if ( [_delegate respondsToSelector:@selector(onClickedButtonMessage)])
            {
                [_delegate onClickedButtonMessage];
            }
            break;
        }
            
        case detailControlBarButtonTag_apply:
        {
            if ( [_delegate respondsToSelector:@selector(onClickedButtonApply)])
            {
                [_delegate onClickedButtonApply];
            }
            break;
        }
            
        case detailControlBarButtonTag_leaveMessage: {
            if ( [_delegate respondsToSelector:@selector(onClickedButtonLeaveMessage)])
            {
                [_delegate onClickedButtonLeaveMessage];
            }
            break;
        }
            
        default:
        {
//            if ( [_delegate respondsToSelector:@selector(onClickedButtonApply)])
//            {
//                [_delegate onClickedButtonApply];
//            }
            break;
        }
    }
}



- (void)setAttentionStatus:(BOOL)attentionStatus
{
    if ( _attentionStatus == attentionStatus)
    {
        return;
    }
    

    _attentionStatus = attentionStatus;
    
    
    if ( _attentionStatus)
    {
        [btnAttente setSelected:YES];
    }
    else
    {
        [btnAttente setSelected:NO];
    }
    
}



@end





