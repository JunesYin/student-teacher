//
//  LyForgotPasswordView.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/10.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyForgotPasswordView.h"
//#import "JVFloatLabeledTextField.h"
#import "LyGetAuthCodeButton.h"

#import "LyRemindView.h"
#import "LyIndicator.h"
#import "LyToolBar.h"

//#import "LyCurrentUser.h"

#import "NSString+Validate.h"

#import "LyUtil.h"



#define fpWidth                                 FULLSCREENWIDTH
#define fpHeight                                FULLSCREENHEIGHT


#define viewUsefulWidth                         fpWidth
CGFloat const viewUsefulHeight = 250.0f;


#define viewItemWidth                           (viewUsefulWidth*9.0/10.0f)
CGFloat const viewItemHeight = 50.0f;

#define lbTitleWidth                            (viewItemWidth/2.0f)
CGFloat const lbTitleHeight = viewItemHeight;
#define lbTitleFont                             LyFont(20)

CGFloat const btnCloseWidth = 20.0f;
CGFloat const btnCloseHeight = 20.0f;

CGFloat const lbPhoneNumTxtWidth = 70.0f;
CGFloat const lbPhoneNumTxtHeight = viewItemHeight;
#define lbPhoneNumTxtFont                       LyFont(16)

#define tfItemWidth                             (viewItemWidth-horizontalSpace*2.0f)
CGFloat const tfItemHeight = viewItemHeight;


#define tfPhoneNumWidth                         (viewItemWidth-lbPhoneNumTxtWidth-horizontalSpace*2.0f)
#define tfAuthCodeWidth                         (viewItemWidth-btnGetAuthCodeWidth-horizontalSpace*3.0f)


//#define btnGetAuthCodeWidth                     100.0f
//#define btnGetAuthCodeHeight                    (viewItemHeight*2.0f/3.0f)

#define btnItemWidth                            (fpWidth/2.0f)
#define btnItemHeight                           40.0f


CGFloat const ivKickWidth = 30.0f;
CGFloat const ivKickHeight = ivKickWidth;




#define viewUsefulFrame                         CGRectMake( 0, fpHeight-viewUsefulHeight, viewUsefulWidth, viewUsefulHeight)
//#define

typedef NS_ENUM( NSInteger, LyForgotPasswordViewTextFieldMode)
{
    forgotPasswordViewTextFieldMode_phoneNum = 83,
    forgotPasswordViewTextFieldMode_authCode,
    forgotPasswordViewTextFieldMode_newPassword,
    forgotPasswordViewTextFieldMode_reNewPassword
};


typedef NS_ENUM( NSInteger, LyForgotPasswordViewButtonItemMode)
{
    forgotPasswordViewButtonItemMode_big = 42,
    forgotPasswordViewButtonItemMode_closeFirst,
    forgotPasswordViewButtonItemMode_next,
    forgotPasswordViewButtonItemMode_closeSecond,
    forgotPasswordViewButtonItemMode_finish
};


typedef NS_ENUM( NSInteger, LyForgotPasswordViewHttpMethod)
{
    forgotPasswordViewHttpMethod_check = 432,
    forgotPasswordViewHttpMethod_modify
};


typedef NS_ENUM( NSInteger, LyForgotPasswordViewResetSuccess)
{
    forgotPasswordViewResetSuccess = 433
};


@interface LyForgotPasswordView () <UITextFieldDelegate, LyGetAuthCodeButtonDelegate, LyHttpRequestDelegate, LyRemindViewDelegate>
{
    
    UIButton                        *btnBig;
    
    UIView                          *viewUseful;
    
    UIView                          *viewFirst;
    UILabel                         *lbTitleFirst;
    UIButton                        *btnCloseFirst;
    UILabel                         *lbPhoneNumTxt;
    UIView                          *viewPhonNum;
//    JVFloatLabeledTextField         *tfPhoneNum;
    UITextField                     *tfPhoneNum;
    UIView                          *viewAuthCode;
//    JVFloatLabeledTextField         *tfAuthCode;
    UITextField                     *tfAuthCode;
    LyGetAuthCodeButton             *btnGetAuthCode;
    UIButton                        *btnNext;
    
    
    UIView                          *viewSecond;
    UILabel                         *lbTitleSecond;
    UIButton                        *btnCloseSecond;
    UIView                          *viewNewPassword;
    UIImageView                     *ivNewPassword;
//    JVFloatLabeledTextField         *tfNewPassword;
    UITextField                     *tfNewPassword;
    UIView                          *viewReNewPassword;
    UIImageView                     *ivReNewPassword;
//    JVFloatLabeledTextField         *tfReNewPassword;
    UITextField                     *tfReNewPassword;
    UIButton                        *btnFinish;
    
    
    CGPoint                         centerViewUseful;
    CGPoint                         centerViewItem;
    
    
    LyForgotPasswordViewHttpMethod  lastHttpMethod;
    BOOL                            bHttpFlag;
    
    
    LyIndicator                     *indicatorForCheck;
    LyIndicator                     *indicatorForModify;
    
}
@end


@implementation LyForgotPasswordView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    if ( self = [super initWithFrame:CGRectMake( 0, 0, fpWidth, fpHeight)])
    {
        [self initAndLayoutSubview];
    }
    
    
    return self;
}




- (void)initAndLayoutSubview
{
    btnBig = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, fpWidth, fpHeight)];
    [btnBig setTag:forgotPasswordViewButtonItemMode_big];
    [btnBig setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.8f]];
    [btnBig addTarget:self action:@selector(fpTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnBig];
    
    
    
    
    viewUseful = [[UIView alloc] initWithFrame:viewUsefulFrame];
    [viewUseful setBackgroundColor:[UIColor clearColor]];
    
    centerViewUseful = [viewUseful center];
    
    [self addSubview:viewUseful];
    
    
    
    
    
    
    viewFirst = [[UIView alloc] initWithFrame:viewUseful.bounds];
//    [[viewFirst layer] setContents:(id)[[UIImage imageNamed:@"fp_backGroud"] CGImage]];
    [[viewFirst layer] setContents:(id)[[LyUtil imageForImageName:@"fp_backGroud" needCache:NO] CGImage]];
    
    centerViewItem = [viewFirst center];
    
    lbTitleFirst = [[UILabel alloc] initWithFrame:CGRectMake( viewUsefulWidth/2.0f-lbTitleWidth/2.0f, 0, lbTitleWidth, lbTitleHeight)];
    [lbTitleFirst setTextColor:[UIColor whiteColor]];
    [lbTitleFirst setFont:lbTitleFont];
    [lbTitleFirst setTextAlignment:NSTextAlignmentCenter];
    [lbTitleFirst setText:@"忘记密码"];
    
    btnCloseFirst = [[UIButton alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewFirst.frame)-horizontalSpace-btnCloseWidth, verticalSpace*2.0f, btnCloseWidth, btnCloseHeight)];
    [btnCloseFirst setTag:forgotPasswordViewButtonItemMode_closeFirst];
    [btnCloseFirst setBackgroundImage:[LyUtil imageForImageName:@"fp_btn_close" needCache:NO] forState:UIControlStateNormal];
    [btnCloseFirst addTarget:self action:@selector(fpTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    viewPhonNum = [[UIView alloc] initWithFrame:CGRectMake( viewUsefulWidth/2.0f-viewItemWidth/2.0f, lbTitleFirst.frame.origin.y+CGRectGetHeight(lbTitleFirst.frame)+verticalSpace*3.0f, viewItemWidth, viewItemHeight)];
    [viewPhonNum setBackgroundColor:viewTfBackColor];
    [[viewPhonNum layer] setCornerRadius:5.0f];
    [viewPhonNum setClipsToBounds:YES];
    
    lbPhoneNumTxt = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, 60, CGRectGetHeight(viewPhonNum.frame))];
    [lbPhoneNumTxt setFont:lbPhoneNumTxtFont];
    [lbPhoneNumTxt setTextColor:[UIColor whiteColor]];
    [lbPhoneNumTxt setTextAlignment:NSTextAlignmentCenter];
    [lbPhoneNumTxt setText:@"+86"];
    
//    tfPhoneNum = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake( lbPhoneNumTxt.frame.origin.x+CGRectGetWidth(lbPhoneNumTxt.frame)+horizontalSpace, viewItemHeight/2.0f-tfItemHeight/2.0f, tfPhoneNumWidth, tfItemHeight)];
    tfPhoneNum = [[UITextField alloc] initWithFrame:CGRectMake( lbPhoneNumTxt.frame.origin.x+CGRectGetWidth(lbPhoneNumTxt.frame), viewItemHeight/2.0f-tfItemHeight/2.0f, tfPhoneNumWidth, tfItemHeight)];
    [tfPhoneNum setKeyboardType:UIKeyboardTypePhonePad];
    [tfPhoneNum setFont:LyTextFieldFont];
    [tfPhoneNum setTextColor:[UIColor whiteColor]];
    [tfPhoneNum setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName:LyAttributePlaceholderColor}]];
    [tfPhoneNum setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfPhoneNum setDelegate:self];
    [tfPhoneNum setTag:forgotPasswordViewTextFieldMode_phoneNum];
    [tfPhoneNum setReturnKeyType:UIReturnKeyDone];
    [tfPhoneNum setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfPhoneNum]];
    
    [viewPhonNum addSubview:lbPhoneNumTxt];
    [viewPhonNum addSubview:tfPhoneNum];
    
    
    
    viewAuthCode = [[UIView alloc] initWithFrame:CGRectMake( viewUsefulWidth/2.0f-viewItemWidth/2.0f, viewPhonNum.frame.origin.y+CGRectGetHeight(viewPhonNum.frame)+verticalSpace*3.0f, viewItemWidth, viewItemHeight)];
    [viewAuthCode setBackgroundColor:viewTfBackColor];
    [[viewAuthCode layer] setCornerRadius:5.0f];
    [viewAuthCode setClipsToBounds:YES];
    
    UILabel *lbAuthCode = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, CGRectGetHeight(viewAuthCode.frame))];
    [lbAuthCode setFont:lbPhoneNumTxtFont];
    [lbAuthCode setTextColor:[UIColor whiteColor]];
    [lbAuthCode setTextAlignment:NSTextAlignmentCenter];
    [lbAuthCode setText:@"验证码"];
    
    btnGetAuthCode = [[LyGetAuthCodeButton alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewAuthCode.frame)-2-btnGetAuthCodeWidth, CGRectGetHeight(viewAuthCode.frame)/2.0f-btnGetAuthCodeHeight/2.0f, btnGetAuthCodeWidth, btnGetAuthCodeHeight)];
    [btnGetAuthCode setTimeInterval:1];
    [btnGetAuthCode setTimeTotal:60.0f];
    [btnGetAuthCode setDelegate:self];
    
    
    tfAuthCode = [[UITextField alloc] initWithFrame:CGRectMake( lbAuthCode.frame.origin.x+CGRectGetWidth(lbAuthCode.frame), viewItemHeight/2.0f-tfItemHeight/2.0f, tfAuthCodeWidth-CGRectGetWidth(lbAuthCode.frame), tfItemHeight)];
    [tfAuthCode setKeyboardType:UIKeyboardTypeNumberPad];
    [tfAuthCode setFont:LyTextFieldFont];
    [tfAuthCode setTextColor:[UIColor whiteColor]];
    [tfAuthCode setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName:LyAttributePlaceholderColor}]];
    [tfAuthCode setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfAuthCode setDelegate:self];
    [tfAuthCode setTag:forgotPasswordViewTextFieldMode_authCode];
    [tfAuthCode setReturnKeyType:UIReturnKeyDone];
    [tfAuthCode setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfAuthCode]];
    
    [viewAuthCode addSubview:lbAuthCode];
    [viewAuthCode addSubview:tfAuthCode];
    [viewAuthCode addSubview:btnGetAuthCode];
    
    
    btnNext = [[UIButton alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewFirst.frame)/2.0f-btnItemWidth/2.0f, viewAuthCode.frame.origin.y+CGRectGetHeight(viewAuthCode.frame)+verticalSpace*3.0f, btnItemWidth, btnItemHeight)];
    [btnNext setTag:forgotPasswordViewButtonItemMode_next];
    [btnNext setBackgroundColor:LyThemeButtonColor];
    [btnNext setTitle:@"下一步" forState:UIControlStateNormal];
    [btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[btnNext layer] setMasksToBounds:YES];
    [[btnNext layer] setCornerRadius:5.0f];
    [btnNext addTarget:self action:@selector(fpTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [viewFirst addSubview:lbTitleFirst];
    [viewFirst addSubview:btnCloseFirst];
    [viewFirst addSubview:viewPhonNum];
    [viewFirst addSubview:viewAuthCode];
    [viewFirst addSubview:btnNext];
    
    
    
    
    
    viewSecond = [[UIView alloc] initWithFrame:viewUseful.bounds];
//    [[viewSecond layer] setContents:(id)[[UIImage imageNamed:@"fp_backGroud"] CGImage]];
    [[viewSecond layer] setContents:(id)[[LyUtil imageForImageName:@"fp_backGroud" needCache:NO] CGImage]];
    
    lbTitleSecond = [[UILabel alloc] initWithFrame:CGRectMake( viewUsefulWidth/2.0f-lbTitleWidth/2.0f, 0, lbTitleWidth, lbTitleHeight)];
    [lbTitleSecond setTextAlignment:NSTextAlignmentCenter];
    [lbTitleSecond setTextColor:[UIColor whiteColor]];
    [lbTitleSecond setFont:lbTitleFont];
    [lbTitleSecond setText:@"重设密码"];
    
    btnCloseSecond = [[UIButton alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewFirst.frame)-horizontalSpace-btnCloseWidth, verticalSpace*2.0f, btnCloseWidth, btnCloseHeight)];
    [btnCloseSecond setTag:forgotPasswordViewButtonItemMode_closeSecond];
    [btnCloseSecond setBackgroundImage:[LyUtil imageForImageName:@"fp_btn_close" needCache:NO] forState:UIControlStateNormal];
    [btnCloseSecond addTarget:self action:@selector(fpTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    
    viewNewPassword = [[UIView alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewSecond.frame)/2.0f-viewItemWidth/2.0f, lbTitleSecond.frame.origin.y+CGRectGetHeight(lbTitleSecond.frame)+verticalSpace*3.f, viewItemWidth, viewItemHeight)];
    [viewNewPassword setBackgroundColor:viewTfBackColor];
    [[viewNewPassword layer] setCornerRadius:5.0f];
    [viewNewPassword setClipsToBounds:YES];
    
    
    ivNewPassword = [[UIImageView alloc] initWithFrame:CGRectMake( horizontalSpace, viewItemHeight/2.0-ivKickHeight/2.0f, ivKickWidth, ivKickHeight)];
    [ivNewPassword setContentMode:UIViewContentModeScaleAspectFit];
    [ivNewPassword setImage:[LyUtil imageForImageName:@"fp_kick" needCache:NO]];
    
    tfNewPassword = [[UITextField alloc] initWithFrame:CGRectMake( ivNewPassword.frame.origin.x+CGRectGetWidth(ivNewPassword.frame)+horizontalSpace/2.0f, viewItemHeight/2.0f-tfItemHeight/2.0f, tfItemWidth-(ivNewPassword.frame.origin.x+CGRectGetWidth(ivNewPassword.frame)+horizontalSpace/2.0f), tfItemHeight)];
    [tfNewPassword setSecureTextEntry:YES];
    //    [tfNewPassword setKeyboardType:UIKeyboardTypeNumberPad];
    [tfNewPassword setFont:LyTextFieldFont];
    [tfNewPassword setTextColor:[UIColor whiteColor]];
    [tfNewPassword setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"新密码" attributes:@{NSForegroundColorAttributeName:LyAttributePlaceholderColor}]];
    [tfNewPassword setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfNewPassword setDelegate:self];
    [tfNewPassword setTag:forgotPasswordViewTextFieldMode_newPassword];
    [tfNewPassword setReturnKeyType:UIReturnKeyDone];
    
    [viewNewPassword addSubview:ivNewPassword];
    [viewNewPassword addSubview:tfNewPassword];
    
    
    
    viewReNewPassword = [[UIView alloc] initWithFrame:CGRectMake( viewNewPassword.frame.origin.x, viewNewPassword.frame.origin.y+CGRectGetHeight(viewNewPassword.frame)+verticalSpace, viewItemWidth, viewItemHeight)];
    [viewReNewPassword setBackgroundColor:viewTfBackColor];
    [[viewReNewPassword layer] setCornerRadius:5.0f];
    [viewReNewPassword setClipsToBounds:YES];
    
    ivReNewPassword = [[UIImageView alloc] initWithFrame:CGRectMake( horizontalSpace, viewItemHeight/2.0-ivKickHeight/2.0f, ivKickWidth, ivKickHeight)];
    [ivReNewPassword setContentMode:UIViewContentModeScaleAspectFit];
    [ivReNewPassword setImage:[UIImage imageNamed:@"fp_kick"]];
    
    tfReNewPassword = [[UITextField alloc] initWithFrame:CGRectMake( ivNewPassword.frame.origin.x+CGRectGetWidth(ivNewPassword.frame)+horizontalSpace/2.0f, viewItemHeight/2.0f-tfItemHeight/2.0f, tfItemWidth-(ivNewPassword.frame.origin.x+CGRectGetWidth(ivNewPassword.frame)+horizontalSpace/2.0f), tfItemHeight)];
    [tfReNewPassword setSecureTextEntry:YES];
    //    [tfNewPassword setKeyboardType:UIKeyboardTypeNumberPad];
    [tfReNewPassword setFont:LyTextFieldFont];
    [tfReNewPassword setTextColor:[UIColor whiteColor]];
    [tfReNewPassword setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"确认新密码" attributes:@{NSForegroundColorAttributeName:LyAttributePlaceholderColor}]];
    [tfReNewPassword setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfReNewPassword setDelegate:self];
    [tfReNewPassword setTag:forgotPasswordViewTextFieldMode_reNewPassword];
    [tfReNewPassword setReturnKeyType:UIReturnKeyDone];
    
    
    [viewReNewPassword addSubview:ivReNewPassword];
    [viewReNewPassword addSubview:tfReNewPassword];
    
    
    btnFinish = [[UIButton alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewSecond.frame)/2.0f-btnItemWidth/2.0f, viewReNewPassword.frame.origin.y+CGRectGetHeight(viewReNewPassword.frame)+verticalSpace*3.0f, btnItemWidth, btnItemHeight)];
    [btnFinish setTag:forgotPasswordViewButtonItemMode_finish];
    [btnFinish setBackgroundColor:LyThemeButtonColor];
    [btnFinish setTitle:@"完成" forState:UIControlStateNormal];
    [btnFinish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[btnFinish layer] setMasksToBounds:YES];
    [[btnFinish layer] setCornerRadius:5.0f];
    [btnFinish addTarget:self action:@selector(fpTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [viewSecond addSubview:lbTitleSecond];
    [viewSecond addSubview:btnCloseSecond];
    [viewSecond addSubview:viewNewPassword];
    [viewSecond addSubview:viewReNewPassword];
    [viewSecond addSubview:btnFinish];
    
    
    
    [viewUseful addSubview:viewFirst];
    [viewUseful addSubview:viewSecond];
    
    
    
    
    
    [viewFirst setHidden:YES];
    [viewSecond setHidden:YES];
    
    
}



- (void)setPhoneNum:(NSString *)phoneNum
{
    [tfPhoneNum setText:phoneNum];
}



- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [self fpAddKeyboardEventNotification];
    
    
    [[LyUtil sharedInstance] startAnimationWithView:viewFirst
                                  animationDuration:0.3f
                                       initialPoint:CGPointMake( centerViewItem.x, centerViewItem.y+CGRectGetHeight(viewFirst.frame))
                                   destinationPoint:centerViewItem
                                         completion:^(BOOL finished) {
                                             ;
                                         }];
    
    
    [[LyUtil sharedInstance] startAnimationWithView:btnBig
                                  animationDuration:0.3f
                                          initAlpha:0.0f
                                  destinationAplhas:1.0f
                                          comletion:^(BOOL finished) {
                                              ;
                                          }];
}


- (void)showInView:(UIView *)view
{
    [self show];
}

- (void)hide
{
    [self fpAddKeyboardEventNotification];
    
    UIView *brontView;
    if ( ![viewFirst isHidden])
    {
        brontView = viewFirst;
    }
    else if ( ![viewSecond isHidden])
    {
        brontView = viewSecond;
    }
    
    
    [[LyUtil sharedInstance] startAnimationWithView:brontView
                                  animationDuration:0.3f
                                       initialPoint:centerViewItem
                                   destinationPoint:CGPointMake( centerViewItem.x, centerViewItem.y+CGRectGetHeight(brontView.frame))
                                         completion:^(BOOL finished) {
                                             ;
                                         }];
    
    
    [[LyUtil sharedInstance] startAnimationWithView:btnBig
                                  animationDuration:0.3f
                                          initAlpha:1.0f
                                  destinationAplhas:0.0f comletion:^(BOOL finished) {
                                      [self removeFromSuperview];
//                                      [btnBig setAlpha:1.0f];
                                      [brontView setCenter:centerViewItem];
                                      [brontView setHidden:YES];
                                  }];
    
    
}


- (void)fpAddKeyboardEventNotification
{
    //增加监听，当键盘出现或改变时收出消息
    if ( [self respondsToSelector:@selector(fpTargetForNotificationToKeyboardWillShow:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fpTargetForNotificationToKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    
    //增加监听，当键退出时收出消息
    if ( [self respondsToSelector:@selector(fpTargetForNotificationToKeyboardWillHide:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fpTargetForNotificationToKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}




- (void)fpRemoveKeyboardEventNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



- (void)fpTargetForButtonItem:(UIButton *)button
{
    
    switch ( [button tag]) {
        case forgotPasswordViewButtonItemMode_big: {
            
            [self fpAllTfResignFirstResponder];
            
            break;
        }
        case forgotPasswordViewButtonItemMode_closeFirst: {
            
            [self fpAllTfResignFirstResponder];
            
            if ( [_delegate respondsToSelector:@selector(onForgotPasswordCancel:)])
            {
                [_delegate onForgotPasswordCancel:self];
            }
            
            break;
        }
        case forgotPasswordViewButtonItemMode_next: {
            
            [self fpAllTfResignFirstResponder];
            
            if ( ![[tfPhoneNum text] validatePhoneNumber])
            {
                [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号格式错误"] showInView:self];
                return;
            }
            
            if ( ![[tfAuthCode text] validateAuthCode])
            {
                [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码格式错误"] showInView:self];
                return;
            }
            
            
            
            if ( !indicatorForCheck)
            {
                indicatorForCheck = [[LyIndicator alloc] initWithTitle:@"正在验证..."];
            }
            [self addSubview:indicatorForCheck];
            [indicatorForCheck start];
            
            
            LyHttpRequest *httpRequeest = [LyHttpRequest httpRequestWithMode:forgotPasswordViewHttpMethod_check];
            [httpRequeest setDelegate:self];
            
            bHttpFlag = [[httpRequeest startHttpRequest:checkAuchCode_url
                                           requestBody:@{
                                                         phoneKey:[tfPhoneNum text],
                                                         authKey:[tfAuthCode text]
                                                         }
                                           requestType:AsynchronousPost
                                                timeOut:0] boolValue];
            break;
        }
        case forgotPasswordViewButtonItemMode_closeSecond: {
            
            [self fpAllTfResignFirstResponder];
            
            if ( [_delegate respondsToSelector:@selector(onForgotPasswordCancel:)])
            {
                [_delegate onForgotPasswordCancel:self];
            }
            
            break;
        }
        case forgotPasswordViewButtonItemMode_finish: {
            
            [self fpAllTfResignFirstResponder];
            
            if ( ![[tfNewPassword text] validatePassword])
            {
                [tfNewPassword setTextColor:LyWainningColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"密码格式错误"] showInView:self];
                return;
            }
            
            
            if ( ![[tfReNewPassword text] validatePassword])
            {
                [tfReNewPassword setTextColor:LyWainningColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"确定密码格式错误"] showInView:self];
                return;
            }
            
            if ( ![[tfNewPassword text] isEqualToString:[tfReNewPassword text]])
            {
                [tfReNewPassword setTextColor:LyWainningColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"两次密码不一致"] showInView:self time:2];
                return;
            }
            
            
            if ( !indicatorForModify)
            {
                indicatorForModify = [[LyIndicator alloc] initWithTitle:@"正在重设..."];
            }
            [self addSubview:indicatorForModify];
            [indicatorForModify start];
            
            
            NSString *newPassword = [[LyUtil sharedInstance] encodePassword:[tfNewPassword text]];
            

            LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:forgotPasswordViewHttpMethod_modify];
            [httpRequest setDelegate:self];
            bHttpFlag = [[httpRequest startHttpRequest:resetPassword_url
                                          requestBody:@{
                                                         phoneKey:[tfPhoneNum text],
                                                         accountKey:[tfPhoneNum text],
                                                         newPasswordKey:newPassword
                                                        }
                                          requestType:AsynchronousPost
                                               timeOut:0] boolValue];
            
            
            
            break;
        }
    }

}



- (void)fpAllTfResignFirstResponder
{
    [tfPhoneNum resignFirstResponder];
    [tfAuthCode resignFirstResponder];
    [tfNewPassword resignFirstResponder];
    [tfReNewPassword resignFirstResponder];
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self fpAllTfResignFirstResponder];
}




- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    switch ( [textField tag]) {
        case forgotPasswordViewTextFieldMode_phoneNum: {
            
            if ( 0 == [[tfPhoneNum text] length])
            {
                
            }
            else
            {
                if ( [[tfPhoneNum text] validatePhoneNumber])
                {
                    [tfPhoneNum setTextColor: [UIColor whiteColor]];
                }
                else
                {
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号格式错误"] showInView:self];
                    
                    [tfPhoneNum setTextColor:LyWainningColor];
                    return;
                }
            }
            
            break;
        }
        case forgotPasswordViewTextFieldMode_authCode: {
            
            if ( 0 == [[tfAuthCode text] length])
            {
                
            }
            else
            {
                if ( [[tfAuthCode text] validateAuthCode])
                {
                    [tfAuthCode setTextColor: [UIColor whiteColor]];
                }
                else
                {
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码格式错误"] showInView:self];
                    
                    [tfAuthCode setTextColor:LyWainningColor];
                    return;
                }
            }
            break;
        }
        case forgotPasswordViewTextFieldMode_newPassword: {
            
            if ( 0 == [[tfNewPassword text] length])
            {
                
            }
            else
            {
                if ( ![[textField text] validatePassword])
                {
                    [tfNewPassword setTextColor:LyWainningColor];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"密码格式错误"] showInView:self time:2];
                    
                    return;
                }
                else
                {
                    if ( ![[tfReNewPassword text] isEqualToString:@""] && ![[tfNewPassword text] isEqualToString:[tfReNewPassword text]])
                    {
                        [tfReNewPassword setTextColor:LyWainningColor];
                        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"两次密码不一致"] showInView:self time:2];
                        
                        return;
                    }
                    else
                    {
                        [tfNewPassword setTextColor:[UIColor whiteColor]];
                        [tfReNewPassword setTextColor:[UIColor whiteColor]];
                    }
                }
            }
            
            break;
        }
        case forgotPasswordViewTextFieldMode_reNewPassword: {
            if ( 0 == [[tfReNewPassword text] length])
            {
                
            }
            else
            {
                if ( ![[tfReNewPassword text] validatePassword])
                {
                    [tfReNewPassword setTextColor:LyWainningColor];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"确定密码格式错误"] showInView:self time:2];
                    
                    return;
                }
                else
                {
                    if ( ![[tfNewPassword text] isEqualToString:[tfReNewPassword text]])
                    {
                        [tfReNewPassword setTextColor:LyWainningColor];
                        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"两次密码不一致"] showInView:self time:2];
                        
                        return;
                    }
                    else
                    {
                        [tfNewPassword setTextColor:[UIColor whiteColor]];
                        [tfReNewPassword setTextColor:[UIColor whiteColor]];
                    }
                    
                }
            }
            
            
            break;
        }
    }
}





- (void)fpTargetForNotificationToKeyboardWillShow:(NSNotification *)notification
{
    CGFloat keyboardHight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGFloat offSetNeed = (viewUsefulFrame.origin.y + CGRectGetHeight(viewUsefulFrame)) - (fpHeight-keyboardHight);
    
    if ( offSetNeed > 0.0)
    {
        [viewUseful setFrame:CGRectMake( viewUsefulFrame.origin.x, viewUsefulFrame.origin.y-offSetNeed, viewUsefulFrame.size.width, viewUsefulFrame.size.height)];
    }
    
    
}


- (void)fpTargetForNotificationToKeyboardWillHide:(NSNotification *)notification
{
    [viewUseful setFrame:viewUsefulFrame];
}



#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(UIView *)view
{
    if ( forgotPasswordViewResetSuccess == [view tag])
    {
        [self hide];
    }
    
}




#pragma mark -LyGetAuthCodeButtonDelegate

- (NSString *)obtainPhoneNum:(LyGetAuthCodeButton *)button
{
    if ( [[tfPhoneNum text] validatePhoneNumber])
    {
        return [tfPhoneNum text];
    }
    else
    {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号格式错误"] showInView:self];
        return @"";
    }
}



#pragma mark -LyHttpRequestDelegate
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result
{
    if ( bHttpFlag)
    {
        bHttpFlag = NO;
        lastHttpMethod = 0;
        
        if ( [indicatorForCheck isActive])
        {
            [indicatorForCheck stop];
            [indicatorForCheck removeFromSuperview];
        }
        else if ( [indicatorForModify isActive])
        {
            [indicatorForModify stop];
            [indicatorForModify removeFromSuperview];
        }
        
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"出错，请稍后再试"] showInView:self];
    }
}


- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result
{
    if ( bHttpFlag)
    {
        bHttpFlag = NO;
        
        lastHttpMethod = [ahttpRequest mode];
        
        NSDictionary *dic = [[LyUtil sharedInstance] getObjFromJson:result];
        
        if ( !dic || ![dic count])
        {
            lastHttpMethod = 0;
            
            if ( [indicatorForCheck isActive])
            {
                [indicatorForCheck stop];
            }
            else if ( [indicatorForModify isActive])
            {
                [indicatorForModify stop];
            }
            
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"出错，请稍后再试"] showInView:self];
            
            return;
        }
        
        NSString *strCode = [NSString stringWithFormat:@"%@", [dic objectForKey:codeKey]];
        
        if ( !strCode || (NSNull *)strCode == [NSNull null] || [strCode length] < 1)
        {
            lastHttpMethod = 0;
            
            if ( [indicatorForCheck isActive])
            {
                [indicatorForCheck stop];
            }
            else if ( [indicatorForModify isActive])
            {
                [indicatorForModify stop];
            }
            
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"出错，请稍后再试"] showInView:self];
            
            return;
        }
        
        
        switch ( lastHttpMethod) {
            case forgotPasswordViewHttpMethod_check:
            {
                lastHttpMethod = 0;
                
                if ( 0 == [strCode integerValue])
                {
                    [indicatorForCheck stop];
                    [indicatorForCheck removeFromSuperview];
                    
                    [[LyUtil sharedInstance] startAnimationWithView:viewFirst
                                                  animationDuration:0.2f
                                                       initialPoint:centerViewItem
                                                   destinationPoint:CGPointMake( centerViewItem.x, centerViewItem.y+CGRectGetHeight(viewFirst.frame))
                                                         completion:^(BOOL finished) {
                                                             [viewFirst setHidden:YES];
                                                             [viewFirst setCenter:centerViewItem];
                                                             
                                                             
                                                             [[LyUtil sharedInstance] startAnimationWithView:viewSecond
                                                                                           animationDuration:0.2f
                                                                                                initialPoint:CGPointMake(centerViewItem.x, centerViewItem.y+CGRectGetHeight(viewSecond.frame))
                                                                                            destinationPoint:centerViewItem
                                                                                                  completion:^(BOOL finished) {
                                                                                                      ;
                                                                                                  }];
                                                         }];
                }
                else
                {
                    [indicatorForCheck stop];
                    [indicatorForCheck removeFromSuperview];
                    
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码错误"] showInView:self];
                }
                
                
                break;
            }
                
            case forgotPasswordViewHttpMethod_modify:
            {
                lastHttpMethod = 0;
                
                if ( 0 == [strCode integerValue])
                {
                    [indicatorForModify stop];
                    
                    LyRemindView *remindView_modify = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"重设成功"];
                    [remindView_modify setTag:forgotPasswordViewResetSuccess];
                    [remindView_modify setDelegate:self];
                    [remindView_modify showInView:self];
                }
                else
                {
                    [indicatorForModify stop];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"重设失败"] show];
//                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"重设失败"];
//                    [remind performSelector:@selector(show) withObject:nil afterDelay:remin];
                }
                
                
                break;
            }
                
            default:
            {
                lastHttpMethod = 0;
                if ( [indicatorForCheck isActive])
                {
                    [indicatorForCheck stop];
                }
                else if ( [indicatorForModify isActive])
                {
                    [indicatorForModify stop];
                }
                [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"出错，请稍后再试"] showInView:self];
                break;
            }
        }
        
    }
    
    
    
}








@end
