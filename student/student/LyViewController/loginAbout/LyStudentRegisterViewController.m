//
//  LyRegisterViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/16.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyStudentRegisterViewController.h"
#import "LyTxtViewController.h"

#import "UIViewController+CloseSelf.h"
#import "JVFloatLabeledTextField.h"
#import "LyGetAuthCodeButton.h"
#import "LyIndicator.h"
#import "NSString+Validate.h"
#import "LyRemindView.h"
#import "LyCurrentUser.h"
#import "LyToolBar.h"

#import "LyUtil.h"






#define SRVIEWUSEFRAME                              [UIScreen mainScreen].bounds


#define viewTfBackColor                             [UIColor colorWithWhite:1 alpha:0.1]



#define viewItemWidth                               (FULLSCREENWIDTH*9/10.0f)
CGFloat const srViewItemHeight = 50.0f;

#define tfItemWidth                                 (viewItemWidth-horizontalSpace*4)
CGFloat const tfItemHeight = srViewItemHeight;


#define tfAuthCodeWidth                             (viewItemWidth-btnGetAuthCodeWidth-horizontalSpace*4)


//密码提示
#define tvPwdRemindWidth                            viewItemWidth
CGFloat const tvPwdRemindHeight = 10.0f;
#define tvPwdRemindFont                             LyFont(12)

//吾要去用户协议
CGFloat const btnAgreenWidth = 20.0f;
CGFloat const btnAgreenHeight = btnAgreenWidth;
CGFloat const lbProtocolWidth = 10.0f;
CGFloat const lbProtocolHeight = btnAgreenHeight;
#define lbProtocolFont                              LyFont(13)

//注册按钮
#define btnRegisterWidth                          (FULLSCREENWIDTH*3/4.0f)
CGFloat const btnRegisterHeight = 50.0f;



#define tfItemFont                                    LyFont(15)

#define SRVIEWHORIZONTALLINECOLOR                   [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1]


typedef NS_ENUM ( NSInteger, LySrTextFieldTag)
{
    LySrTextFieldTag_name,
    LySrTextFieldTag_phoneNumber,
    LySrTextFieldTag_authCode,
    LySrTextFieldTag_password,
    LySrTextFieldTag_checkPassword
};



typedef NS_ENUM( NSInteger, LySrButtonItemMode)
{
    srButtonItemMode_register = 53,
    srButtonItemMode_agreen
};



typedef NS_ENUM( NSInteger, LySrHttpMethod)
{
    srHttpMethod_register = 84
};



@interface LyStudentRegisterViewController () < UITextFieldDelegate, LyRemindViewDelegate, LyHttpRequestDelegate, LyGetAuthCodeButtonDelegate>
{
    UIView                      *srViewUse;
    
    UIView                      *srViewName;
    UIView                      *srViewPhoneNumber;
    UIView                      *srViewAuthCode;
    UIView                      *srViewPassword;
    UIView                      *srViewCheckPassword;
    
    UITextView                  *tvPsdRemind;
    
    
    UIButton                    *btnAgreen;
    UILabel                     *lbProtocol;
    
    
    NSTimer                     *srTimerAuth;
    int                         srTimerMaxTime;
//    NSString                    *time;
    
    
    
    LyIndicator                 *indicator;
    
    LySrHttpMethod              curHttpMethod;
    BOOL                        bHttpFlag;
}
@end

@implementation LyStudentRegisterViewController



//lySingle_implementation(LyStudentRegisterViewController)

//__weak LyStudentRegisterViewController *weakSelf = self;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self srLayoutUI];
    [self srAddKeyboardEventNotification];
}



- (void)viewWillAppear:(BOOL)animated
{
    
}



- (void)viewWillDisappear:(BOOL)animated
{
    
    [self rsAllItemsResignFirstResponder];
}



- (void)srLayoutUI
{
    self.title = @"注册";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    [[self.view layer] setContents:(id)[[LyUtil imageForImageName:@"backGroud" needCache:NO] CGImage]];
    
    
    CGRect rectSrViewUse = SRVIEWUSEFRAME;
    srViewUse = [[UIView alloc] initWithFrame:rectSrViewUse];
    [srViewUse setBackgroundColor:[UIColor clearColor]];
    
    
    //姓名
    srViewName = [[UIView alloc] initWithFrame:CGRectMake(FULLSCREENWIDTH/2.0f-viewItemWidth/2.0f, STATUSBARHEIGHT+NAVIGATIONBARHEIGHT+10, viewItemWidth, srViewItemHeight)];
    [srViewName setBackgroundColor:viewTfBackColor];
    [[srViewName layer] setCornerRadius:5.0f];
    
    _srTfName = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(viewItemWidth/2.0f-tfItemWidth/2.0f, 0, tfItemWidth, tfItemHeight)];
    [_srTfName setFont:tfItemFont];
    [_srTfName setTextColor:[UIColor whiteColor]];
    [_srTfName setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"真实姓名" attributes:@{NSForegroundColorAttributeName:LyAttributePlaceholderColor}]];
    [_srTfName setFloatingLabelFont:LyFloatTextFont];
    [_srTfName setFloatingLabelTextColor:LyFloatTextColor];
    [_srTfName setFloatingLabelActiveTextColor:LyFloatActiveTextColor];
    [_srTfName setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_srTfName setDelegate:self];
    [_srTfName setTag:LySrTextFieldTag_name];
    [_srTfName setReturnKeyType:UIReturnKeyDone];
    
//    [srViewName addSubview:lbSrViewNameTxt];
    [srViewName addSubview:_srTfName];
    
    //手机
    srViewPhoneNumber = [[UIView alloc] initWithFrame:CGRectMake(srViewName.frame.origin.x, srViewName.frame.origin.y+CGRectGetHeight(srViewName.frame)+verticalSpace, viewItemWidth, srViewItemHeight)];
    [srViewPhoneNumber setBackgroundColor:viewTfBackColor];
    [[srViewPhoneNumber layer] setCornerRadius:5.0f];
    _srTfPhoneNumber = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(viewItemWidth/2.0f-tfItemWidth/2.0f, 0, tfItemWidth, tfItemHeight)];
    [_srTfPhoneNumber setKeyboardType:UIKeyboardTypePhonePad];
    [_srTfPhoneNumber setFont:tfItemFont];
    [_srTfPhoneNumber setTextColor:[UIColor whiteColor]];
    [_srTfPhoneNumber setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName:LyAttributePlaceholderColor}]];
    [_srTfPhoneNumber setFloatingLabelFont:LyFloatTextFont];
    [_srTfPhoneNumber setFloatingLabelTextColor:LyFloatTextColor];
    [_srTfPhoneNumber setFloatingLabelActiveTextColor:LyFloatActiveTextColor];
    [_srTfPhoneNumber setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_srTfPhoneNumber setDelegate:self];
    [_srTfPhoneNumber setTag:LySrTextFieldTag_phoneNumber];
    [_srTfPhoneNumber setReturnKeyType:UIReturnKeyDone];
    [_srTfPhoneNumber setInputAccessoryView:[LyToolBar toolBarWithInputControl:_srTfPhoneNumber]];
    
//    [srViewPhoneNumber addSubview:lbSrViewPhoneNumberTxt];
    [srViewPhoneNumber addSubview:_srTfPhoneNumber];
    
    
    
    
    //验证码
    srViewAuthCode = [[UIView alloc] initWithFrame:CGRectMake(srViewName.frame.origin.x, srViewPhoneNumber.frame.origin.y+CGRectGetHeight(srViewPhoneNumber.frame)+verticalSpace, viewItemWidth, srViewItemHeight)];
//    [srViewAuthCode setBackgroundColor:[UIColor blueColor]];
    [srViewAuthCode setBackgroundColor:viewTfBackColor];
    [[srViewAuthCode layer] setCornerRadius:5.0f];
//    //验证码文字
//    CGRect rectSrViewAuthCodeTxt = CGRectMake( SRHORIZONTALSPACE, 0, SRVIEWAUTHCODETXTWIDTH, SRVIEWAUTHCODETXTHEIGHT);
//    UILabel *lbSrViewAuthCodeTxt = [[UILabel alloc] initWithFrame:rectSrViewAuthCodeTxt];
//    [lbSrViewAuthCodeTxt setText:@"验证码"];
//    [lbSrViewAuthCodeTxt setTextColor:[UIColor whiteColor]];
//    [lbSrViewAuthCodeTxt setTextAlignment:NSTextAlignmentCenter];
    //验证码输入框
//    CGRect rectSrViewAuthCodeTf = CGRectMake( rectSrViewAuthCodeTxt.origin.x+rectSrViewAuthCodeTxt.size.width+SRHORIZONTALSPACE, rectSrViewAuthCodeTxt.origin.y, SRVIEWAUTHCODETFWIDTH, SRVIEWAUTHCODETFHEIGHT);
//    _srTfAuthCode = [[UITextField alloc] initWithFrame:rectSrViewAuthCodeTf];
//    [_srTfAuthCode setPlaceholder:@"输入验证码"];
//    [_srTfAuthCode setTextColor:[UIColor whiteColor]];
//    [_srTfAuthCode setDelegate:self];
//    [_srTfAuthCode setTag:LySrTextFieldTag_authCode];
//    [_srTfAuthCode setFont:SRTFFONT];
    _srTfAuthCode = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(viewItemWidth/2.0f-tfItemWidth/2.0f, 0, tfItemWidth, tfItemHeight)];
    [_srTfAuthCode setKeyboardType:UIKeyboardTypeNumberPad];
    [_srTfAuthCode setFont:tfItemFont];
    [_srTfAuthCode setTextColor:[UIColor whiteColor]];
    [_srTfAuthCode setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName:LyAttributePlaceholderColor}]];
    [_srTfAuthCode setFloatingLabelFont:LyFloatTextFont];
    [_srTfAuthCode setFloatingLabelTextColor:LyFloatTextColor];
    [_srTfAuthCode setFloatingLabelActiveTextColor:LyFloatActiveTextColor];
    [_srTfAuthCode setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_srTfAuthCode setDelegate:self];
    [_srTfAuthCode setTag:LySrTextFieldTag_authCode];
    [_srTfAuthCode setReturnKeyType:UIReturnKeyDone];
    
    [_srTfAuthCode setInputAccessoryView:[LyToolBar toolBarWithInputControl:_srTfAuthCode]];
    
    //获取验证码按钮
//    CGRect rectSrBtnGetAuthCode = CGRectMake( rectSrViewAuthCode.size.width-SRVIEWAUTHCODEBTNWIDTH-horizontalSpace, SRVIEWAUTHCODEHEIGHT/2-SRVIEWAUTHCODEBTNHEIGHT/2, SRVIEWAUTHCODEBTNWIDTH, SRVIEWAUTHCODEBTNHEIGHT);
//    _srBtnGetAuthCode = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_srBtnGetAuthCode setFrame:rectSrBtnGetAuthCode];
//    [_srBtnGetAuthCode setTitle:@"获取验证码" forState:UIControlStateNormal];
//    [_srBtnGetAuthCode setBackgroundImage:[LyUtil imageWithColor:Ly517ThemeColor withSize:rectSrBtnGetAuthCode.size] forState:UIControlStateNormal];
//    [_srBtnGetAuthCode setBackgroundImage:[LyUtil imageWithColor:[UIColor colorWithRed:201/255 green:201/255 blue:201/255 alpha:1] withSize:rectSrBtnGetAuthCode.size] forState:UIControlStateDisabled];
//    [[_srBtnGetAuthCode titleLabel] setFont:SRBTNGETAUTHCODETITLEFONT];
//    [[_srBtnGetAuthCode layer] setMasksToBounds:YES];
//    [[_srBtnGetAuthCode layer] setCornerRadius:5.0f];
//    [_srBtnGetAuthCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_srBtnGetAuthCode setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
//    [_srBtnGetAuthCode addTarget:self action:@selector(srTargetForBtnGetAuthCode) forControlEvents:UIControlEventTouchUpInside];
    _srBtnGetAuthCode = [[LyGetAuthCodeButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(srViewAuthCode.frame)-horizontalSpace-btnGetAuthCodeWidth, srViewItemHeight/2.0f-btnGetAuthCodeHeight/2.0f, btnGetAuthCodeWidth, btnGetAuthCodeHeight)];
    [_srBtnGetAuthCode setDelegate:self];
    [_srBtnGetAuthCode setTimeInterval:1.0f];
    [_srBtnGetAuthCode setTimeTotal:60.0f];
    
    

    [srViewAuthCode addSubview:_srTfAuthCode];
    [srViewAuthCode addSubview:_srBtnGetAuthCode];
    
    
    //密码
    srViewPassword = [[UIView alloc] initWithFrame:CGRectMake(srViewAuthCode.frame.origin.x, srViewAuthCode.frame.origin.y+CGRectGetHeight(srViewAuthCode.frame)+verticalSpace, viewItemWidth, srViewItemHeight)];
    [srViewPassword setBackgroundColor:viewTfBackColor];
    [[srViewPassword layer] setCornerRadius:5.0f];
    //密码文字
//    CGRect rectSrViewPasswordTxt = CGRectMake( SRHORIZONTALSPACE, 0, SRVIEWPASSWORDTXTWIDTH, SRVIEWPASSWORDTXTHEIGHT);
//    UILabel *lbSrViewPasswordTxt = [[UILabel alloc] initWithFrame:rectSrViewPasswordTxt];
//    [lbSrViewPasswordTxt setText:@"密码"];
//    [lbSrViewPasswordTxt setTextColor:[UIColor whiteColor]];
//    [lbSrViewPasswordTxt setTextAlignment:NSTextAlignmentCenter];
    //密码输入框
//    CGRect rectSrViewPasswordTf = CGRectMake( rectSrViewPasswordTxt.origin.x+rectSrViewPasswordTxt.size.width+SRHORIZONTALSPACE, 0, SRVIEWPASSWORDTFWIDTH, SRVIEWPASSWORDTFHEIGHT);
//    _srTfPassword = [[UITextField alloc] initWithFrame:rectSrViewPasswordTf];
//    [_srTfPassword setPlaceholder:@"请输入6到12位的密码"];
//    [_srTfPassword setTextColor:[UIColor whiteColor]];
//    [_srTfPassword setSecureTextEntry:YES];
//    [_srTfPassword setDelegate:self];
//    [_srTfPassword setTag:LySrTextFieldTag_password];
//    [_srTfPassword setFont:SRTFFONT];
    _srTfPassword = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(viewItemWidth/2.0f-tfItemWidth/2.0f, 0, tfItemWidth, tfItemHeight)];
    [_srTfPassword setSecureTextEntry:YES];
    [_srTfPassword setFont:tfItemFont];
    [_srTfPassword setTextColor:[UIColor whiteColor]];
    [_srTfPassword setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName:LyAttributePlaceholderColor}]];
    [_srTfPassword setFloatingLabelFont:LyFloatTextFont];
    [_srTfPassword setFloatingLabelTextColor:LyFloatTextColor];
    [_srTfPassword setFloatingLabelActiveTextColor:LyFloatActiveTextColor];
    [_srTfPassword setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_srTfPassword setDelegate:self];
    [_srTfPassword setTag:LySrTextFieldTag_password];
    [_srTfPassword setReturnKeyType:UIReturnKeyDone];
    
//    [srViewPassword addSubview:lbSrViewPasswordTxt];
    [srViewPassword addSubview:_srTfPassword];
    
    //确认密码
    srViewCheckPassword = [[UIView alloc] initWithFrame:CGRectMake(srViewPassword.frame.origin.x, srViewPassword.frame.origin.y+CGRectGetHeight(srViewPassword.frame)+verticalSpace, viewItemWidth, srViewItemHeight)];
    [srViewCheckPassword setBackgroundColor:viewTfBackColor];
    [[srViewCheckPassword layer] setCornerRadius:5.0f];
//    //确认密码文字
//    CGRect rectSrViewCheckPasswordTxt = CGRectMake( SRHORIZONTALSPACE, 0, SRVIEWCHECKPASSWORDTXTWIDTH, SRVIEWCHECKPASSWORDTXTHEIGHT);
//    UILabel *lbSrViewCheckPasswordTxt = [[UILabel alloc] initWithFrame:rectSrViewCheckPasswordTxt];
//    [lbSrViewCheckPasswordTxt setText:@"确认密码"];
//    [lbSrViewCheckPasswordTxt setTextColor:[UIColor whiteColor]];
//    [lbSrViewCheckPasswordTxt setTextAlignment:NSTextAlignmentCenter];
    //确认密码输入框
//    CGRect rectSrViewCheckPasswordTf = CGRectMake( rectSrViewCheckPasswordTxt.origin.x+rectSrViewCheckPasswordTxt.size.width+SRHORIZONTALSPACE, 0, SRVIEWCHECKPASSWORDTFWIDTH, SRVIEWCHECKPASSWORDTFHEIGHT);
//    _srTfCheckPassword = [[UITextField alloc] initWithFrame:rectSrViewCheckPasswordTf];
//    [_srTfCheckPassword setPlaceholder:@"请再次输入你的密码"];
//    [_srTfCheckPassword setTextColor:[UIColor whiteColor]];
//    [_srTfCheckPassword setSecureTextEntry:YES];
//    [_srTfCheckPassword setDelegate:self];
//    [_srTfCheckPassword setTag:LySrTextFieldTag_checkPassword];
//    [_srTfCheckPassword setFont:SRTFFONT];

    _srTfCheckPassword = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(viewItemWidth/2.0f-tfItemWidth/2.0f, 0, tfItemWidth, tfItemHeight)];
    [_srTfCheckPassword setSecureTextEntry:YES];
    [_srTfCheckPassword setFont:tfItemFont];
    [_srTfCheckPassword setTextColor:[UIColor whiteColor]];
    [_srTfCheckPassword setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"确认密码" attributes:@{NSForegroundColorAttributeName:LyAttributePlaceholderColor}]];
    [_srTfCheckPassword setFloatingLabelFont:LyFloatTextFont];
    [_srTfCheckPassword setFloatingLabelTextColor:LyFloatTextColor];
    [_srTfCheckPassword setFloatingLabelActiveTextColor:LyFloatActiveTextColor];
    [_srTfCheckPassword setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_srTfCheckPassword setDelegate:self];
    [_srTfCheckPassword setTag:LySrTextFieldTag_checkPassword];
    [_srTfCheckPassword setReturnKeyType:UIReturnKeyDone];
    
//    [srViewCheckPassword addSubview:lbSrViewCheckPasswordTxt];
    [srViewCheckPassword addSubview:_srTfCheckPassword];
    
    
    
    //提示
    tvPsdRemind = [[UITextView alloc] init];
    [tvPsdRemind setEditable:NO];
    [tvPsdRemind setScrollEnabled:NO];
    [tvPsdRemind setFont:tvPwdRemindFont];
    [tvPsdRemind setTextColor:Ly517ThemeColor];
    [tvPsdRemind setBackgroundColor:[UIColor clearColor]];
    [tvPsdRemind setTextAlignment:NSTextAlignmentLeft];
    [tvPsdRemind setText:@"*密码需在6~18位之间\n*密码至少由字母和数字组成（可以输入特殊字符）"];
    CGFloat fHeightTvPsdRemind =  [tvPsdRemind sizeThatFits:CGSizeMake(tvPwdRemindWidth, MAXFLOAT)].height;
//    WithFrame:CGRectMake( srViewName.frame.origin.x, srViewCheckPassword.frame.origin.y+CGRectGetHeight(srViewCheckPassword.frame)+verticalSpace, tvPwdRemindWidth, tvPwdRemindHeight)]
    [tvPsdRemind setFrame:CGRectMake( srViewName.frame.origin.x, srViewCheckPassword.frame.origin.y+CGRectGetHeight(srViewCheckPassword.frame)+verticalSpace, tvPwdRemindWidth, fHeightTvPsdRemind)];
    
    
    //吾要去用户协议
    NSString *strLbProtocolTmp = @"我同意《吾要去用户协议》";
    NSRange rangeProtocol = [strLbProtocolTmp rangeOfString:@"《吾要去用户协议》"];
    NSMutableAttributedString *strLbProtocol = [[NSMutableAttributedString alloc] initWithString:strLbProtocolTmp];
    [strLbProtocol addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:rangeProtocol];
    CGFloat fWidthLbProtocol = [strLbProtocolTmp sizeWithAttributes:@{NSFontAttributeName:lbProtocolFont}].width;
    lbProtocol = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-horizontalSpace/2.0f-fWidthLbProtocol, tvPsdRemind.frame.origin.y+CGRectGetHeight(tvPsdRemind.frame)+verticalSpace, fWidthLbProtocol, lbProtocolHeight)];
    [lbProtocol setFont:lbProtocolFont];
    [lbProtocol setTextColor:LyWhiteLightgrayColor];
    [lbProtocol setAttributedText:strLbProtocol];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(srTargetForTapGesture517Protocol)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    
    [lbProtocol setUserInteractionEnabled:YES];
    [lbProtocol addGestureRecognizer:tapGesture];
    
    btnAgreen = [[UIButton alloc] initWithFrame:CGRectMake( lbProtocol.frame.origin.x-btnAgreenWidth, lbProtocol.frame.origin.y, btnAgreenWidth, btnAgreenHeight)];
    [btnAgreen setTag:srButtonItemMode_agreen];
    [btnAgreen setImage:[LyUtil imageForImageName:@"sr_btn_agreen_n" needCache:NO] forState:UIControlStateNormal];
    [btnAgreen setImage:[LyUtil imageForImageName:@"sr_btn_agreen_h" needCache:NO] forState:UIControlStateSelected];
    [btnAgreen addTarget:self action:@selector(srTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnAgreen setSelected:YES];
    
    //注册按钮
    CGRect rectSrBtnRegister = CGRectMake( FULLSCREENWIDTH/2-btnRegisterWidth/2, btnAgreen.frame.origin.y+btnAgreen.frame.size.height+verticalSpace*2, btnRegisterWidth, btnRegisterHeight);
    _srBtnRegister = [[UIButton alloc] initWithFrame:rectSrBtnRegister];
    [_srBtnRegister setTag:srButtonItemMode_register];
    [_srBtnRegister setTitle:@"注册" forState:UIControlStateNormal];
    [_srBtnRegister setBackgroundColor:LyThemeButtonColor];
    [[_srBtnRegister layer] setMasksToBounds:YES];
    [[_srBtnRegister layer] setCornerRadius:5.0f];
    [[_srBtnRegister titleLabel] setFont:LyFont(18)];
    [_srBtnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_srBtnRegister addTarget:self action:@selector(srTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [srViewUse addSubview:srViewName];
    [srViewUse addSubview:srViewPhoneNumber];
    [srViewUse addSubview:srViewAuthCode];
    [srViewUse addSubview:srViewPassword];
    [srViewUse addSubview:srViewCheckPassword];
    [srViewUse addSubview:tvPsdRemind];
    [srViewUse addSubview:btnAgreen];
    [srViewUse addSubview:lbProtocol];
    [srViewUse addSubview:_srBtnRegister];
    
    
    [self.view addSubview:srViewUse];
    
    
    
}



- (void)srTargetForTapGesture517Protocol
{
    
    LyTxtViewController *txt = [[LyTxtViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:txt];
    [self presentViewController:navigationController animated:YES completion:^{
        [txt setMode:LyTxtViewControllerMode_517Protocol];
    }];
}



- (void)srTargetForLeftBarBtnItem
{
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)srTargetForButtonItem:(UIButton *)button
{
    switch ( [button tag]) {
        case srButtonItemMode_register: {
            
            if ( ![self validate])
            {
                return;
            }
            
            
            if ( ![btnAgreen isSelected])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"你还没有同意《吾要去用户协议》"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
                
                [alert show];
                return;
            }
            
            
            if (!indicator)
            {
                indicator = [[LyIndicator alloc] initWithTitle:@"注册..."];
            }
            [indicator start];
            
            
            NSString *strMd5Password = [LyUtil encodePassword:[_srTfPassword text]];
            
            LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:srHttpMethod_register];
            [httpRequest setDelegate:self];
            bHttpFlag = [httpRequest startHttpRequest:register_url
                                          requestBody:@{
                                                        accountKey:_srTfPhoneNumber.text,
                                                        nickNameKey:_srTfName.text,
                                                        passowrdKey:strMd5Password,
                                                        authKey:_srTfAuthCode.text,
                                                        userTypeKey:userTypeStudentKey,
                                                        timeKey:_srBtnGetAuthCode.time,
                                                        versionKey:[LyUtil getApplicationVersionNoPoint]
                                                        }
                                          requestType:AsynchronousPost
                                              timeOut:0];
            
            break;
        }
        case srButtonItemMode_agreen: {
            
            if ( [btnAgreen isSelected])
            {
                [btnAgreen setSelected:NO];
            }
            else
            {
                [btnAgreen setSelected:YES];
            }
            
            break;
        }
    }
}


- (void)handleHttpFailed {
    if ([indicator isAnimating]) {
        [indicator stopAnimation];
        
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"注册失败"] show];
    }
}



- (void)srAnalysisUserInfo:(NSString *)userInfo {
    
    NSDictionary *dic = [LyUtil getObjFromJson:userInfo];
    if (![LyUtil validateDictionary:dic]) {
        [self handleHttpFailed];
        return;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (![LyUtil validateString:strCode]) {
        [self handleHttpFailed];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    switch ( curHttpMethod) {
        case srHttpMethod_register: {
            switch ( [strCode intValue])
            {
                case 0:
                {
                    NSString *strAccount = [_srTfPhoneNumber text];
                    NSString *strPassword = [_srTfPassword text];
                    
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [self handleHttpFailed];
                        return;
                    }
                    
                    
                    NSString *strUserId = [dicResult objectForKey:userIdKey];
                    NSString *strNickName = [dicResult objectForKey:nickNameKey];
                    NSString *strHttpSessionId = [dic objectForKey:sessionIdKey];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:strAccount forKey:userAccount517Key];
                    [[NSUserDefaults standardUserDefaults] setObject:strPassword forKey:userPassword517Key];
                    [[NSUserDefaults standardUserDefaults] setObject:strUserId forKey:userId517Key];
                    [[NSUserDefaults standardUserDefaults] setObject:strNickName forKey:userName517Key];
                    
                    [LyUtil setHttpSessionId:strHttpSessionId];
                    
                    [[LyCurrentUser currentUser] setUserId:strUserId];
                    [[LyCurrentUser currentUser] setUserPhoneNum:strAccount];
                    [[LyCurrentUser currentUser] setUserName:strNickName];
                    
                    
                    [indicator stopAnimation];
                    
                    
                    LyRemindView *remindView = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"注册成功"];
                    [remindView setDelegate:self];
                    [remindView performSelector:@selector(show) withObject:nil afterDelay:LyRemindViewDelayTime];
                    
                    break;
                }
                case 1: {
                    //验证超时
                    [indicator stopAnimation];
                    
                    LyRemindView *remindView = [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码超时"];
                    [remindView performSelector:@selector(show) withObject:nil afterDelay:LyRemindViewDelayTime];
                    
                    break;
                }
                case 2: {
                    
                    //注册失败
//                    NSString *strMessage = [dic objectForKey:messageKey];
                    
                    [self handleHttpFailed];
                    break;
                }
                    
                case 3: {
                    //验证码错误
                    [indicator stopAnimation];
//                    NSString *strMessage = [dic objectForKey:messageKey];
                    
                    LyRemindView *remindView = [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码错误"];
                    [remindView performSelector:@selector(show) withObject:nil afterDelay:LyRemindViewDelayTime];
                    
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    
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




- (void)srAddKeyboardEventNotification
{
    //增加监听，当键盘出现或改变时收出消息
    if ( [self respondsToSelector:@selector(srTargetForNotificationToKeyboardWillShow:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(srTargetForNotificationToKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    
    //增加监听，当键退出时收出消息
    if ( [self respondsToSelector:@selector(srTargetForNotificationToKeyboardWillHide:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(srTargetForNotificationToKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}



- (void)srAnimationForMoveUp:(int)heightForMoveUp
{
    [UIView beginAnimations:nil context:nil];
    CGPoint pointDes = CGPointMake( SRVIEWUSEFRAME.size.width/2, SRVIEWUSEFRAME.size.height/2-heightForMoveUp);
    [srViewUse setCenter:pointDes];
    [UIView commitAnimations];

}



- (void)srAnimationForBack
{
    [UIView beginAnimations:nil context:nil];
    CGPoint pointDes = CGPointMake( SRVIEWUSEFRAME.size.width/2, SRVIEWUSEFRAME.size.height/2);
    [srViewUse setCenter:pointDes];
    [UIView commitAnimations];
}


- (void)srTargetForNotificationToKeyboardWillShow:(NSNotification *)notification
{
    int keyboardHight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    int keyboardY = FULLSCREENHEIGHT - keyboardHight;
    int currentTfY = 0;
    
    int heightForMoveUp = 0;
    
    if ( [_srTfName isFirstResponder])
    {
        currentTfY = [srViewName frame].origin.y + [srViewName frame].size.height;
    }
    else if ( [_srTfPhoneNumber isFirstResponder])
    {
        currentTfY = [srViewPhoneNumber frame].origin.y + [srViewPhoneNumber frame].size.height;
    }
    else if ( [_srTfAuthCode isFirstResponder])
    {
        currentTfY = [srViewAuthCode frame].origin.y + [srViewAuthCode frame].size.height;
    }
    else if ( [_srTfPassword isFirstResponder])
    {
        currentTfY = [srViewPassword frame].origin.y + [srViewPassword frame].size.height;
    }
    else if  ( [_srTfCheckPassword isFirstResponder])
    {
        currentTfY = [srViewCheckPassword frame].origin.y + [srViewCheckPassword frame].size.height;
    }
    
    heightForMoveUp = currentTfY - keyboardY + horizontalSpace/2;
    if ( heightForMoveUp > 0)
    {
        [self srAnimationForMoveUp:heightForMoveUp];
    }
    
}



- (void)srTargetForNotificationToKeyboardWillHide:(NSNotification *)notification
{
    [srViewUse setFrame:SRVIEWUSEFRAME];
}



- (BOOL)validate
{
    if ( ![[_srTfName text] validateName])
    {
        [_srTfName setTextColor:LyWainningColor];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"姓名格式错误"] show];
        
        return NO;
    }
    
    
    if ( ![[_srTfPhoneNumber text] validatePhoneNumber])
    {
        [_srTfPhoneNumber setTextColor:LyWainningColor];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号格式错误"] show];
        
        return NO;
    }
    
    if ( ![[_srTfAuthCode text] validateAuthCode])
    {
        [_srTfAuthCode setTextColor:LyWainningColor];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码格式错误"] show];
        
        return NO;
    }
    
    
    if ( ![_srTfPassword text] || [[_srTfPassword text] isEqualToString:@""] || ![[_srTfPassword text] validatePassword])
    {
        [_srTfPassword setTextColor:LyWainningColor];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"密码格式错误"] show];
        
        return NO;
        
    }
    
    
    if ( ![_srTfCheckPassword text] || [[_srTfCheckPassword text] isEqualToString:@""] || ![[_srTfCheckPassword text] validatePassword])
    {
        
        [_srTfCheckPassword setTextColor:LyWainningColor];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"密码格式错误"] show];
        
        return NO;
    }
    
    if ( ![[_srTfPassword text] isEqualToString:[_srTfCheckPassword text]])
    {
        [_srTfCheckPassword setTextColor:LyWainningColor];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"两次密码不一致"] show];
        
        return NO;
    }
    
    

    return YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{

    switch ( [textField tag]) {
        case LySrTextFieldTag_name: {
            
            if ( 0 == [[textField text] length])
            {
                
            }
            else
            {
                if ( ![[textField text] validateName])
                {
                    [_srTfName setTextColor:LyWainningColor];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"姓名格式错误"] show];
                    
                }
                else
                {
                    [_srTfName setTextColor:[UIColor whiteColor]];
                }
            }
            
            break;
        }
        case LySrTextFieldTag_phoneNumber: {
            if (textField.text.length > 0) {
                if ( ![[textField text] validatePhoneNumber]) {
                    [_srTfPhoneNumber setTextColor:LyWainningColor];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号格式错误"] show];
                } else {
                    [_srTfPhoneNumber setTextColor:[UIColor whiteColor]];
                }
            }
            
            break;
        }
        case LySrTextFieldTag_authCode: {
            
            if (textField.text.length > 0) {
                if ( ![[textField text] validateAuthCode]) {
                    [_srTfAuthCode setTextColor:LyWainningColor];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码格式错误"] show];
                    return;
                } else {
                    [_srTfAuthCode setTextColor:[UIColor whiteColor]];
                }
            }
            break;
        }
        case LySrTextFieldTag_password: {
            
            if (textField.text.length > 0) {
                if ( ![[textField text] validatePassword]) {
                    [_srTfPassword setTextColor:LyWainningColor];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"密码格式错误"] show];
                    
                    return;
                } else {
                    if ( ![[_srTfCheckPassword text] isEqualToString:@""] && ![[_srTfPassword text] isEqualToString:[_srTfCheckPassword text]]) {
                        [_srTfCheckPassword setTextColor:LyWainningColor];
                        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"两次密码不一致"] show];
                        
                        return;
                    } else {
                        [_srTfPassword setTextColor:[UIColor whiteColor]];
                        [_srTfCheckPassword setTextColor:[UIColor whiteColor]];
                    }
                }
            }
            
            break;
        }
        case LySrTextFieldTag_checkPassword: {
            
            if (textField.text.length > 0) {
                if ( ![[_srTfCheckPassword text] validatePassword]) {
                    [_srTfCheckPassword setTextColor:LyWainningColor];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"密码格式错误"] show];
                    
                    return;
                } else {
                    if ( ![[_srTfPassword text] isEqualToString:[_srTfCheckPassword text]]) {
                        [_srTfCheckPassword setTextColor:LyWainningColor];
                        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"两次密码不一致"] show];
                        
                        return;
                    } else {
                        [_srTfPassword setTextColor:[UIColor whiteColor]];
                        [_srTfCheckPassword setTextColor:[UIColor whiteColor]];
                    }

                }
            }
            
            break;
        }
    }
    
  
}


//点击return
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}



#pragma  mark -LyHttpRequestDelegate

- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest
{
    if ( bHttpFlag)
    {
        bHttpFlag = NO;
        
        curHttpMethod = 0;
        
        [indicator stopAnimation];
        [indicator removeFromSuperview];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"出错，请稍后再试"] show];
    }
}


- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result
{
    if ( bHttpFlag)
    {
        bHttpFlag = NO;
        curHttpMethod = ahttpRequest.mode;
        [self srAnalysisUserInfo:(NSString *)result];
    }
}





//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self rsAllItemsResignFirstResponder];
}


- (void)rsAllItemsResignFirstResponder
{
    [_srTfName resignFirstResponder];
    [_srTfPhoneNumber resignFirstResponder];
    [_srTfAuthCode resignFirstResponder];
    [_srTfPassword resignFirstResponder];
    [_srTfCheckPassword resignFirstResponder];
}



#pragma  mark -LyGetAuthCodeButtonDelegate
- (NSString *)obtainPhoneNum:(LyGetAuthCodeButton *)button
{
    if ( [[_srTfPhoneNumber text] validatePhoneNumber]) {
        return [_srTfPhoneNumber text];
    } else {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号格式错误"] show];
        return @"";
    }
}

//- (void)sendSuccessByGetAuthCodeButton:(LyGetAuthCodeButton *)aGetAuthCodeButton time:(NSString *)aTime {
//    time = aTime;
//}




#pragma  mark -LyRemindViewDelegate
- (void)remindViewDidHide:(UIView *)view
{
//    NSArray *viewControllers = [self.navigationController viewControllers];
//    [self.navigationController popToViewController:[viewControllers objectAtIndex:0] animated:YES];
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
