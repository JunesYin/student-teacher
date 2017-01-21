//
//  LyModifyPhoneNumerView.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/4.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyModifyPhoneNumerView.h"
#import "LyGetAuthCodeButton.h"
#import "LyCurrentUser.h"

#import "LyIndicator.h"
#import "LyRemindView.h"
#import "LyToolBar.h"

#import "NSString+Validate.h"
#import "LyUtil.h"


#define mpWidth                                 FULLSCREENWIDTH
#define mpHeight                                FULLSCREENHEIGHT


#define mpViewUsefulWidth                         (mpWidth-horizontalSpace*2)
CGFloat const mpViewUsefulHeight = 300.0f;


CGFloat const mpIvIconSize = 40.0f;

#define lbCurrentPhoneNumberWidth               mpViewUsefulWidth
CGFloat const lbCurrentPhoneNumberHeight = 15.0f;
#define lbCurrentPhoneNumberFont                LyFont(16)

#define fpLbRemindWidth                           mpViewUsefulWidth
CGFloat const mpLbRemindHeight = 20.0f;
#define lbRemindFont                            LyFont(12)

#define tfPasswordWidth                         mpViewUsefulWidth
CGFloat const tfPasswordHeight = 20.0f;
#define tfPasswordFont                          LyFont(14)

CGFloat const btnNextWidth = 200.0f;
CGFloat const btnNextHeight = 40.0f;



#define viewUseful_secondFrame                  CGRectMake( mpWidth/2.0f-mpViewUsefulWidth/2.0f, mpHeight/2.0f-mpViewUsefulHeight/2.0f, mpViewUsefulWidth, mpViewUsefulHeight)

#define viewTvWidth                             (mpViewUsefulWidth*4/5.0f)
CGFloat const viewTvHeight = 40.0f;

#define tvPhoneNumberWidth                      (viewTvWidth-horizontalSpace*2.0f)
CGFloat const tvPhoneNumberHeight = viewTvHeight;
#define tvPhoneNumberFont                       LyFont(14)

#define tvAuthCodeWidth                         (tvPhoneNumberWidth-btnGetAuthCodeWidth-horizontalSpace)
CGFloat const tvAuthCodeHeight = tvPhoneNumberHeight;
#define tvAuthCodeFont                          tvPhoneNumberFont

#define btnConfirmWidth                         tvPhoneNumberWidth
CGFloat const btnConfirmHeight = btnNextHeight;



typedef NS_ENUM( NSInteger, LyModifyPhoneNumberButtonItemMode)
{
    modifyPhoneNumberButtonItemMode_big = 43,
    modifyPhoneNumberButtonItemMode_closeFist,
    modifyPhoneNumberButtonItemMode_next,
    modifyPhoneNumberButtonItemMode_closeSecond,
    modifyPhoneNumberButtonItemMode_getAuthCode,
    modifyPhoneNumberButtonItemMode_confirm
};


typedef NS_ENUM( NSInteger, LyModifyPhoneNumberTextFieldMode)
{
    modifyPhoneNumberTextFieldMode_phoneOld = 60,
    modifyPhoneNumberTextFieldMode_authCodeOld,
    modifyPhoneNumberTextFieldMode_phoneNew,
    modifyPhoneNumberTextFieldMode_authCodeNew
};


typedef NS_ENUM(NSInteger, LyModifyPhoneNumberHttpMethod)
{
    modifyPhoneNumberHttpMethod_checkOldAuthCode = 100,
    modifyPhoneNumberHttpMethod_checkNewAuthCode
};


@interface LyModifyPhoneNumerView () <UITextFieldDelegate, LyHttpRequestDelegate>
{
    UIButton                    *btnBig;
    
    
    UIView                      *viewUseful_first;
    UIImageView                 *ivIcon;
    UIButton                    *btnCloseFirst;
    UILabel                     *lbCurrentPhoneNumber;
    UILabel                     *lbRemindFisrt;
    UIView                      *viewPhoneNumer_old;
    UITextField                 *tfPhone_old;
    UIView                      *viewAuthCode_old;
    UITextField                 *tfAuthCode_old;
    LyGetAuthCodeButton         *btnGetAuthCode_old;
    UIButton                    *btnNext;
    CGPoint                     centerViewUsefulFirst;
    
    
    UIView                      *viewUseful_second;
    UIButton                    *btnCloseSecond;
    UILabel                     *lbRemindSecond;
    UIView                      *viewPhoneNumer_new;
    UITextField                 *tfPhone_new;
    UIView                      *viewAuthCode_new;
    UITextField                 *tfAuthCode_new;
    LyGetAuthCodeButton         *btnGetAuthCode_new;
    UIButton                    *btnConfirm;
    CGPoint                     centerViewUsefulSecond;
    
    
    
    LyIndicator                 *indicator;
    BOOL                        bHttpFlag;
    LyModifyPhoneNumberHttpMethod curHttpMethod;
    
}
@end


@implementation LyModifyPhoneNumerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    if ( self = [super initWithFrame:CGRectMake( 0, 0, mpWidth, mpHeight)])
    {
        [self initAndLayoutSubview];
    }
    
    return self;
}




- (void)initAndLayoutSubview
{
    btnBig = [[UIButton alloc] initWithFrame:self.bounds];
    [btnBig setBackgroundColor:LyMaskColor];
    [btnBig setTag:modifyPhoneNumberButtonItemMode_big];
    [btnBig addTarget:self action:@selector(mpTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnBig];
    
    
    
    
    viewUseful_first = [[UIView alloc] initWithFrame:CGRectMake( mpWidth/2.0f-mpViewUsefulWidth/2.0f, mpHeight/2.0f-mpViewUsefulHeight/2.0f, mpViewUsefulWidth, mpViewUsefulHeight)];
    [viewUseful_first setBackgroundColor:LyWhiteLightgrayColor];
    [[viewUseful_first layer] setCornerRadius:5.0f];
    centerViewUsefulFirst = [viewUseful_first center];
    
    btnCloseFirst = [[UIButton alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewUseful_first.frame)-btnCloseSize-horizontalSpace, verticalSpace*2, btnCloseSize, btnCloseSize)];
    [btnCloseFirst setTag:modifyPhoneNumberButtonItemMode_closeFist];
    [btnCloseFirst setBackgroundImage:[LyUtil imageForImageName:@"btn_close_dark" needCache:NO] forState:UIControlStateNormal];
    [btnCloseFirst addTarget:self action:@selector(mpTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewUseful_first.frame)/2.0f-mpIvIconSize/2.0f, verticalSpace*4, mpIvIconSize, mpIvIconSize)];
    [ivIcon setBackgroundColor:[UIColor clearColor]];
    [ivIcon setContentMode:UIViewContentModeScaleAspectFill];
    [ivIcon setClipsToBounds:YES];
    [ivIcon setImage:[LyUtil imageForImageName:@"mpn_icon" needCache:NO]];
    
    
    lbCurrentPhoneNumber = [[UILabel alloc] initWithFrame:CGRectMake( 0, ivIcon.frame.origin.y+CGRectGetHeight(ivIcon.frame)+verticalSpace*2.0f, lbCurrentPhoneNumberWidth, lbCurrentPhoneNumberHeight)];
    [lbCurrentPhoneNumber setFont:lbCurrentPhoneNumberFont];
    [lbCurrentPhoneNumber setTextColor:LyBlackColor];
    [lbCurrentPhoneNumber setTextAlignment:NSTextAlignmentCenter];
    [lbCurrentPhoneNumber setBackgroundColor:[UIColor clearColor]];
    [lbCurrentPhoneNumber setText:[[NSString alloc] initWithFormat:@"你当前的手机号为%@", [LyUtil hidePhoneNumber:[[LyCurrentUser currentUser] userPhoneNum]]]];
    
    lbRemindFisrt = [[UILabel alloc] initWithFrame:CGRectMake( 0, lbCurrentPhoneNumber.frame.origin.y+CGRectGetHeight(lbCurrentPhoneNumber.frame), fpLbRemindWidth, mpLbRemindHeight)];
    [lbRemindFisrt setFont:lbRemindFont];
    [lbRemindFisrt setTextColor:[UIColor darkGrayColor]];
    [lbRemindFisrt setTextAlignment:NSTextAlignmentCenter];
    [lbRemindFisrt setBackgroundColor:[UIColor clearColor]];
    [lbRemindFisrt setText:@"更换后个人信息不变，下次可以使用新手机号登录"];
    
    viewPhoneNumer_old = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(viewUseful_first.frame)/2.0f-viewTvWidth/2.0f, lbRemindFisrt.frame.origin.y+CGRectGetHeight(lbRemindFisrt.frame)+verticalSpace, viewTvWidth, viewTvHeight)];
    [viewPhoneNumer_old setBackgroundColor:[UIColor whiteColor]];
    [[viewPhoneNumer_old layer] setCornerRadius:5.0f];
    [viewPhoneNumer_old setClipsToBounds:YES];
    
    tfPhone_old = [[UITextField alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewPhoneNumer_old.frame)/2.0f-tvPhoneNumberWidth/2.0f, 0, tvPhoneNumberWidth, tvPhoneNumberHeight)];
    [tfPhone_old setFont:tvPhoneNumberFont];
    [tfPhone_old setKeyboardType:UIKeyboardTypeNumberPad];
    [tfPhone_old setTextColor:[UIColor darkGrayColor]];
    [tfPhone_old setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfPhone_old setDelegate:self];
    [tfPhone_old setTag:modifyPhoneNumberTextFieldMode_phoneOld];
    [tfPhone_old setReturnKeyType:UIReturnKeyDone];
    [tfPhone_old setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfPhone_old]];
    [tfPhone_old setPlaceholder:@"请输入当前完整的手机号"];
    
    [viewPhoneNumer_old addSubview:tfPhone_old];
    
    viewAuthCode_old = [[UIView alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewUseful_first.frame)/2.0f-viewTvWidth/2.0f, viewPhoneNumer_old.frame.origin.y+CGRectGetHeight(viewPhoneNumer_old.frame)+verticalSpace, viewTvWidth, viewTvHeight)];
    [[viewAuthCode_old layer] setCornerRadius:5.0f];
    [viewAuthCode_old setBackgroundColor:[UIColor whiteColor]];
    [viewAuthCode_old setClipsToBounds:YES];
    
    tfAuthCode_old = [[UITextField alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewAuthCode_old.frame)/2.0f-(tvAuthCodeWidth+horizontalSpace+btnGetAuthCodeWidth)/2.0f, 0, tvAuthCodeWidth, tvAuthCodeHeight)];
    [tfAuthCode_old setFont:tvAuthCodeFont];
    [tfAuthCode_old setKeyboardType:UIKeyboardTypeNumberPad];
    [tfAuthCode_old setTextColor:[UIColor darkGrayColor]];
    [tfAuthCode_old setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfAuthCode_old setDelegate:self];
    [tfAuthCode_old setTag:modifyPhoneNumberTextFieldMode_authCodeOld];
    [tfAuthCode_old setReturnKeyType:UIReturnKeyDone];
    [tfAuthCode_old setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfAuthCode_old]];
    [tfAuthCode_old setPlaceholder:@"请输入验证码"];
    
    btnGetAuthCode_old = [[LyGetAuthCodeButton alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewAuthCode_old.frame)-2-btnGetAuthCodeWidth, tfAuthCode_old.frame.origin.y+CGRectGetHeight(tfAuthCode_old.frame)/2.0f-btnGetAuthCodeHeight/2.0f, btnGetAuthCodeWidth, btnGetAuthCodeHeight)];
    
    [viewAuthCode_old addSubview:tfAuthCode_old];
    [viewAuthCode_old addSubview:btnGetAuthCode_old];
    
    
    
    
    btnNext = [[UIButton alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewUseful_first.frame)/2.0f-btnNextWidth/2.0f, CGRectGetHeight(viewUseful_first.frame)-verticalSpace*2-btnNextHeight, btnNextWidth, btnNextHeight)];
    [btnNext setTitle:@"更换手机号" forState:UIControlStateNormal];
    [btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnNext setBackgroundColor:Ly517ThemeColor];
    [[btnNext layer] setCornerRadius:5.0f];
    [btnNext setClipsToBounds:YES];
    [btnNext setTag:modifyPhoneNumberButtonItemMode_next];
    [btnNext addTarget:self action:@selector(mpTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [btnNext setEnabled:NO];
    
    [viewUseful_first addSubview:btnCloseFirst];
    [viewUseful_first addSubview:ivIcon];
    [viewUseful_first addSubview:lbCurrentPhoneNumber];
    [viewUseful_first addSubview:lbRemindFisrt];
    [viewUseful_first addSubview:viewPhoneNumer_old];
    [viewUseful_first addSubview:viewAuthCode_old];
    [viewUseful_first addSubview:btnNext];
    
    
    
    
    
    viewUseful_second = [[UIView alloc] initWithFrame:viewUseful_secondFrame];
    [viewUseful_second setBackgroundColor:LyWhiteLightgrayColor];
    [[viewUseful_second layer] setCornerRadius:5.0f];
    centerViewUsefulSecond = [viewUseful_second center];
    
    btnCloseSecond = [[UIButton alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewUseful_first.frame)-btnCloseSize-horizontalSpace, verticalSpace, btnCloseSize, btnCloseSize)];
    [btnCloseSecond setTag:modifyPhoneNumberButtonItemMode_closeSecond];
    [btnCloseSecond setBackgroundImage:[LyUtil imageForImageName:@"btn_close_dark" needCache:NO] forState:UIControlStateNormal];
    [btnCloseSecond addTarget:self action:@selector(mpTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    lbRemindSecond = [[UILabel alloc] initWithFrame:CGRectMake( 0, verticalSpace*5.0f, fpLbRemindWidth, mpLbRemindHeight)];
    [lbRemindSecond setFont:lbRemindFont];
    [lbRemindSecond setTextColor:[UIColor darkGrayColor]];
    [lbRemindSecond setTextAlignment:NSTextAlignmentCenter];
    [lbRemindSecond setBackgroundColor:[UIColor clearColor]];
    [lbRemindSecond setText:@"更换后个人信息不变，下次可以使用新手机号登录"];
    
    viewPhoneNumer_new = [[UIView alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewUseful_second.frame)/2.0f-viewTvWidth/2.0f, lbRemindSecond.frame.origin.y+CGRectGetHeight(lbRemindSecond.frame)+verticalSpace*2.0f, viewTvWidth, viewTvHeight)];
    [[viewPhoneNumer_new layer] setCornerRadius:5.0f];
    [[viewPhoneNumer_new layer] setBorderWidth:1.0f];
    [[viewPhoneNumer_new layer] setBorderColor:[LyWhiteLightgrayColor CGColor]];
    
    tfPhone_new = [[UITextField alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewPhoneNumer_new.frame)/2.0f-tvPhoneNumberWidth/2.0f, 0, tvPhoneNumberWidth, tvPhoneNumberHeight)];
    [tfPhone_new setFont:tvPhoneNumberFont];
    [tfPhone_new setKeyboardType:UIKeyboardTypeNumberPad];
    [tfPhone_new setTextColor:[UIColor darkGrayColor]];
    [tfPhone_new setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfPhone_new setDelegate:self];
    [tfPhone_new setTag:modifyPhoneNumberTextFieldMode_phoneNew];
    [tfPhone_new setReturnKeyType:UIReturnKeyDone];
    [tfPhone_new setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfPhone_new]];
    
    [viewPhoneNumer_new addSubview:tfPhone_new];
    
    viewAuthCode_new = [[UIView alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewUseful_second.frame)/2.0f-viewTvWidth/2.0f, viewPhoneNumer_new.frame.origin.y+CGRectGetHeight(viewPhoneNumer_new.frame)+verticalSpace, viewTvWidth, viewTvHeight)];
    [[viewAuthCode_new layer] setCornerRadius:5.0f];
    [[viewAuthCode_new layer] setBorderWidth:1.0f];
    [[viewAuthCode_new layer] setBorderColor:[LyWhiteLightgrayColor CGColor]];
    
    tfAuthCode_new = [[UITextField alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewAuthCode_new.frame)/2.0f-(tvAuthCodeWidth+horizontalSpace+btnGetAuthCodeWidth)/2.0f, 0, tvAuthCodeWidth, tvAuthCodeHeight)];
    [tfAuthCode_new setFont:tvAuthCodeFont];
    [tfAuthCode_new setKeyboardType:UIKeyboardTypeNumberPad];
    [tfAuthCode_new setTextColor:[UIColor darkGrayColor]];
    [tfAuthCode_new setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfAuthCode_new setDelegate:self];
    [tfAuthCode_new setTag:modifyPhoneNumberTextFieldMode_authCodeNew];
    [tfAuthCode_new setReturnKeyType:UIReturnKeyDone];
    [tfAuthCode_new setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfAuthCode_new]];
    
    btnGetAuthCode_new = [[LyGetAuthCodeButton alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewAuthCode_new.frame)-2-btnGetAuthCodeWidth, tfAuthCode_new.frame.origin.y+CGRectGetHeight(tfAuthCode_new.frame)/2.0f-btnGetAuthCodeHeight/2.0f, btnGetAuthCodeWidth, btnGetAuthCodeHeight)];
    [btnGetAuthCode_new setTimeInterval:1.0f];
    [btnGetAuthCode_new setTimeTotal:60.0f];
    
    [viewAuthCode_new addSubview:tfAuthCode_new];
    [viewAuthCode_new addSubview:btnGetAuthCode_new];
    
    
    btnConfirm = [[UIButton alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewUseful_second.frame)/2.0f-btnConfirmWidth/2.0f, CGRectGetHeight(viewUseful_second.frame)-verticalSpace*2.0f-btnConfirmHeight, btnConfirmWidth, btnConfirmHeight)];
    [btnConfirm setTitle:@"确认更换" forState:UIControlStateDisabled];
    [btnConfirm setTitle:@"确认更换" forState:UIControlStateNormal];
    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnConfirm setBackgroundImage:[LyUtil imageWithColor:[UIColor lightGrayColor] withSize:btnConfirm.frame.size] forState:UIControlStateDisabled];
    [btnConfirm setBackgroundImage:[LyUtil imageWithColor:Ly517ThemeColor withSize:btnConfirm.frame.size] forState:UIControlStateNormal];
    [btnConfirm setTag:modifyPhoneNumberButtonItemMode_confirm];
    [[btnConfirm layer] setCornerRadius:5.0f];
    [btnConfirm setClipsToBounds:YES];
    [btnConfirm addTarget:self action:@selector(mpTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [btnConfirm setEnabled:NO];
    
    
    [viewUseful_second addSubview:btnCloseSecond];
    [viewUseful_second addSubview:lbRemindSecond];
    [viewUseful_second addSubview:viewPhoneNumer_new];
    [viewUseful_second addSubview:viewAuthCode_new];
    [viewUseful_second addSubview:btnConfirm];
    
    
    
    [self addSubview:viewUseful_first];
    [self addSubview:viewUseful_second];
    
    [viewUseful_first setHidden:YES];
    [viewUseful_second setHidden:YES];
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self allTfResignFirstResponder];
}



- (void)mpAddKeyboardEventNotification
{
    //增加监听，当键盘出现或改变时收出消息
    if ( [self respondsToSelector:@selector(mpTargetForNotificationToKeyboardWillShow:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mpTargetForNotificationToKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    
    //增加监听，当键退出时收出消息
    if ( [self respondsToSelector:@selector(mpTargetForNotificationToKeyboardWillHide:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mpTargetForNotificationToKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}


- (void)mpRemoveKeyboardEventNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (BOOL)verifyAuthCode
{
    return NO;
}



- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [self mpAddKeyboardEventNotification];
    
    
    [LyUtil startAnimationWithView:viewUseful_first
                                  animationDuration:0.3f
                                       initialPoint:CGPointMake( centerViewUsefulFirst.x, centerViewUsefulFirst.y+CGRectGetHeight(viewUseful_first.frame))
                                   destinationPoint:centerViewUsefulFirst
                                         completion:^(BOOL finished) {
                                             ;
                                         }];
    
    [LyUtil startAnimationWithView:btnBig
                                  animationDuration:0.3f
                                          initAlpha:0.0f
                                  destinationAplhas:1.0f
                                          comletion:^(BOOL finished) {
                                              ;
                                          }];
}




- (void)hide
{
    [self mpRemoveKeyboardEventNotification];
    
    [btnConfirm setEnabled:NO];
    
    if ( ![viewUseful_first isHidden])
    {
        [LyUtil startAnimationWithView:viewUseful_first
                                      animationDuration:0.3f
                                           initialPoint:centerViewUsefulFirst
                                       destinationPoint:CGPointMake( centerViewUsefulFirst.x, centerViewUsefulFirst.y+CGRectGetHeight(viewUseful_first.frame))
                                             completion:^(BOOL finished) {
                                                 
                                                 [viewUseful_first setHidden:YES];
                                                 [viewUseful_first setCenter:centerViewUsefulFirst];
                                             }];
        
    }
    else if ( ![viewUseful_second isHidden])
    {
        [LyUtil startAnimationWithView:viewUseful_second
                                      animationDuration:0.3f
                                           initialPoint:centerViewUsefulSecond
                                       destinationPoint:CGPointMake( centerViewUsefulSecond.x, centerViewUsefulSecond.y+CGRectGetHeight(viewUseful_second.frame))
                                             completion:^(BOOL finished) {
                                                 [viewUseful_second setHidden:YES];
                                                 [viewUseful_second setCenter:centerViewUsefulSecond];
                                             }];
    }
    
    
    [LyUtil startAnimationWithView:btnBig
                                  animationDuration:0.3f
                                          initAlpha:1.0f
                                  destinationAplhas:0.0f
                                          comletion:^(BOOL finished) {
                                              [self setHidden:YES];
                                              [btnBig setAlpha:1.0f];
                                              [self removeFromSuperview];
                                          }];
    
    
    
}


- (void)mpTargetForButtonItem:(UIButton *)button
{
    switch ( [button tag]) {
        case modifyPhoneNumberButtonItemMode_big:
        {
            if ( [_delegate respondsToSelector:@selector(onClickButtonClose:)])
            {
                [_delegate onClickButtonClose:self];
            }
            break;
        }
            
        case modifyPhoneNumberButtonItemMode_closeFist: {
            
            if ( [_delegate respondsToSelector:@selector(onClickButtonClose:)])
            {
                [_delegate onClickButtonClose:self];
            }
            break;
        }
        case modifyPhoneNumberButtonItemMode_next: {
            
            if (![tfPhone_old.text isEqualToString:[LyCurrentUser currentUser].userPhoneNum]) {
                [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号不符"];
                return;
            }
            
            [self verifyOld];
            
            break;
        }
        case modifyPhoneNumberButtonItemMode_closeSecond: {
            
            if ( [_delegate respondsToSelector:@selector(onClickButtonClose:)])
            {
                [_delegate onClickButtonClose:self];
            }
            break;
        }
        case modifyPhoneNumberButtonItemMode_getAuthCode: {
            //
            break;
        }
        case modifyPhoneNumberButtonItemMode_confirm: {
            
            if ( ![[tfPhone_new text] validatePhoneNumber])
            {
                [tfPhone_new setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号格式错误"] show];
                return;
            }
            
            if ( ![[tfAuthCode_new text] validateAuthCode])
            {
                [tfAuthCode_new setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码格式错误"] show];
                return;
            }
            
            [self modify];
        
            
            break;
        }
    }
}



- (void)allTfResignFirstResponder
{
    [tfPhone_old resignFirstResponder];
    [tfAuthCode_old resignFirstResponder];
    [tfPhone_new resignFirstResponder];
    [tfAuthCode_new resignFirstResponder];
}



- (void)mpTargetForNotificationToKeyboardWillShow:(NSNotification *)notification
{
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat originY = viewUseful_secondFrame.origin.y+CGRectGetHeight(viewUseful_secondFrame) - (mpHeight-keyboardHeight);
    if ( originY > 0)
    {
        [viewUseful_second setFrame:CGRectMake( viewUseful_secondFrame.origin.x, viewUseful_secondFrame.origin.y-originY-verticalSpace, viewUseful_secondFrame.size.width, viewUseful_secondFrame.size.height)];
    }
}


- (void)mpTargetForNotificationToKeyboardWillHide:(NSNotification *)notification
{
    [viewUseful_second setFrame:viewUseful_secondFrame];
}



- (void)verifyOld {
    if ( !indicator) {
        indicator = [LyIndicator indicatorWithTitle:indicatorTitle_verify];
    } else {
        [indicator setTitle:indicatorTitle_verify];
    }
    [indicator start];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:modifyPhoneNumberHttpMethod_checkOldAuthCode];
    [hr setDelegate:self];
    bHttpFlag = [hr startHttpRequest:checkAuchCode_url
                         requestBody:@{
                                       phoneKey:tfPhone_old.text,
                                       authKey:tfAuthCode_old.text
                                       }
                         requestType:AsynchronousPost
                             timeOut:0];
}


- (void)modify {
    if ( !indicator) {
        indicator = [LyIndicator indicatorWithTitle:indicatorTitle_modify];
    } else {
        [indicator setTitle:indicatorTitle_modify];
    }
    [indicator start];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:modifyPhoneNumberHttpMethod_checkNewAuthCode];
    [hr setDelegate:self];
    bHttpFlag = [hr startHttpRequest:checkAuchCode_url
                         requestBody:@{
                                       phoneKey:tfPhone_new.text,
                                       authKey:tfAuthCode_new.text
                                       }
                         requestType:AsynchronousPost
                             timeOut:0];
}


- (void)handleHttpFailed {
    if ([indicator isAnimating]) {
        [indicator stop];
        NSString *str;
        if ([indicator.title isEqualToString:indicatorTitle_verify]) {
            str = @"验证失败";
        } else if ([indicator.title isEqualToString:indicatorTitle_modify]) {
            str = @"修改失败";
        }
        
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:str] show];
    }
}



- (void)analysisHttpResult:(NSString *)result
{
    NSDictionary *dic = [LyUtil getObjFromJson:result];
    if (![LyUtil validateDictionary:dic]) {
        [self handleHttpFailed];
        return;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (![LyUtil validateString:strCode]) {
        [self handleHttpFailed];
        return;
    }
    
    if (codeTimeOut == [strCode integerValue]) {
        [indicator stop];

        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stop];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    

    switch (curHttpMethod) {
        case modifyPhoneNumberHttpMethod_checkOldAuthCode: {
            curHttpMethod = 0;
            switch ([strCode intValue]) {
                case 0: {
                    [indicator stop];
                    
                    [LyUtil startAnimationWithView:viewUseful_first
                                                  animationDuration:0.15f
                                                       initialPoint:centerViewUsefulFirst
                                                   destinationPoint:CGPointMake( centerViewUsefulFirst.x, centerViewUsefulFirst.y+CGRectGetHeight(viewUseful_first.frame)) completion:^(BOOL finished) {
                                                       [viewUseful_first setHidden:YES];
                                                       [viewUseful_first setCenter:centerViewUsefulFirst];
                                                       
                                                       [LyUtil startAnimationWithView:viewUseful_second
                                                                                     animationDuration:0.15f
                                                                                          initialPoint:CGPointMake( centerViewUsefulSecond.x, centerViewUsefulSecond.y+CGRectGetHeight(viewUseful_second.frame))
                                                                                      destinationPoint:centerViewUsefulSecond
                                                                                            completion:^(BOOL finished) {
                                                                                                ;
                                                                                            }];
                                                   }];

                    break;
                }
                case 1: {
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码超时"] show];
                    break;
                }
                case 2: {
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码错误"] show];
                    break;
                }
                default: {
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码错误"] show];
                    break;
                }
            }
            break;
        }
        case modifyPhoneNumberHttpMethod_checkNewAuthCode: {
            curHttpMethod = 0;
            
            switch ([strCode intValue]) {
                case 0: {
                    [indicator stop];
                    
                    [_delegate onModifyFinished:self newPhoneNumber:[tfPhone_new text]];
                    break;
                }
                case 1: {
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码超时"] show];
                    break;
                }
                case 2: {
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码错误"] show];
                    break;
                }
                default: {
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码错误"] show];
                    break;
                }
            }
            break;
        }
        default: {
            [self handleHttpFailed];
            break;
        }
    }
                
}


#pragma mark -LyHttpRequestDelegate
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest {
    if (bHttpFlag) {
        bHttpFlag = NO;
        [self handleHttpFailed];
    }
    
    curHttpMethod = 0;
}

- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result {
    if (bHttpFlag) {
        bHttpFlag = NO;
        curHttpMethod = [ahttpRequest mode];
        
        [self analysisHttpResult:result];
    }
    
    curHttpMethod = 0;
}




#pragma mark -UITextfieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    switch ( [textField tag]) {
        case modifyPhoneNumberTextFieldMode_phoneOld: {
            if ( [[textField text] length] + [string length] > 11)
            {
                return NO;
            }
            else
            {
                return YES;
            }
            break;
        }
        case modifyPhoneNumberTextFieldMode_authCodeOld :
        {
            if ( 6 == [[textField text] length] + [string length])
            {
                [self performSelector:@selector(allTfResignFirstResponder) withObject:nil afterDelay:0.05];
                return YES;
            }
            
            if ( [[textField text] length] + [string length] > 6)
            {
                return NO;
            }
            break;
        }
        case modifyPhoneNumberTextFieldMode_phoneNew: {
            if ( [[textField text] length] + [string length] > 11)
            {
                return NO;
            }
            else
            {
                return YES;
            }
            break;
        }
        case modifyPhoneNumberTextFieldMode_authCodeNew:
        {
            if ( 6 == [[textField text] length] + [string length])
            {
                [self performSelector:@selector(allTfResignFirstResponder) withObject:nil afterDelay:0.05];
                return YES;
            }
            
            if ( [[textField text] length] + [string length] > 6)
            {
                return NO;
            }
            break;
        }
            
        default:
            break;
    }
    
    return YES;
}






- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (modifyPhoneNumberTextFieldMode_phoneOld == textField.tag)
    {
        if ( 0 == [[textField text] length])
        {
            
        }
        else
        {
            if ( [[textField text] validatePhoneNumber])
            {
                [tfPhone_old setTextColor:LyBlackColor];
            }
            else
            {
                [tfPhone_old setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号格式错误"] show];
            }
        }
    }
    else if (modifyPhoneNumberTextFieldMode_authCodeOld == textField.tag)
    {
        if ( 0 == [[textField text] length])
        {
            
        }
        else
        {
            if ( [[textField text] validateAuthCode])
            {
                [tfAuthCode_old setTextColor:LyBlackColor];
            }
            else
            {
                [tfAuthCode_old setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码错误"] show];
            }
        }
    }
    else if (modifyPhoneNumberTextFieldMode_phoneNew == textField.tag)
    {
        if ( 0 == [[textField text] length])
        {
            
        }
        else
        {
            if ( [[textField text] validatePhoneNumber])
            {
                [tfPhone_new setTextColor:LyBlackColor];
            }
            else
            {
                [tfPhone_new setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号格式错误"] show];
            }
        }
    }
    else if (modifyPhoneNumberTextFieldMode_authCodeNew == textField.tag)
    {
        if ( 0 == [[textField text] length])
        {
            
        }
        else
        {
            if ( [[textField text] validateAuthCode])
            {
                [tfAuthCode_new setTextColor:LyBlackColor];
            }
            else
            {
                [tfAuthCode_new setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码错误"] show];
            }
        }
    }
    
    
    if ([viewUseful_second isHidden])
    {
        if ( [[tfPhone_old text] validatePhoneNumber] && [[tfAuthCode_old text] validateAuthCode])
        {
            [btnNext setEnabled:YES];
        }
        else
        {
            [btnNext setEnabled:NO];
        }
    }
    else
    {
        if ( [[tfPhone_new text] validatePhoneNumber] && [[tfAuthCode_new text] validateAuthCode])
        {
            [btnConfirm setEnabled:YES];
        }
        else
        {
            [btnConfirm setEnabled:NO];
        }
    }
}



@end




