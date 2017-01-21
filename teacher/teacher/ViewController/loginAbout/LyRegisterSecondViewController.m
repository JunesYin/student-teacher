//
//  LyRegisterSecondViewController.m
//  teacher
//
//  Created by Junes on 16/7/22.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyRegisterSecondViewController.h"

#import "LyGetAuthCodeButton.h"

#import "LyCurrentUser.h"

#import "LyRemindView.h"
#import "LyIndicator.h"
#import "LyToolBar.h"

#import "UILabel+LyTextAlignmentLeftAndRight.h"
#import "NSString+Validate.h"

#import "LyUtil.h"

#import "LyTxtViewController.h"
#import "LyAuthPhotoViewController.h"


//view
#define viewItemWidth                       (SCREEN_WIDTH-horizontalSpace*2)
CGFloat const rsViewItemHeight = 50.0;

//标题
CGFloat const rsLbItemWidth = 100.0;
CGFloat const rsLbItemHeight = rsViewItemHeight;
#define lbItemFont                          LyFont(16)

//输入框
#define rsTfItemWidth                         (viewItemWidth-rsLbItemWidth-horizontalSpace)
CGFloat const rsTfItemHeight = rsViewItemHeight;
#define tfItemFont                          LyFont(14)

#define btnRegisterWidth                    (SCREEN_WIDTH*2/3.0f)
CGFloat const rsBtnRegisterHeight = 40.0f;




typedef NS_ENUM(NSInteger, LyRegisterSecondTextFieldTag) {
    registerSecondTextFieldTag_name = 10,
    registerSecondTextFieldTag_phone,
    registerSecondTextFieldTag_authCode,
    registerSecondTextFieldTag_password
};


enum {
    registerSecondButtonTag_visiable = 20,
    registerSecondButtonTag_register,
}LyRegisterSecondButtonTag;


typedef NS_ENUM(NSInteger, LyRegisterSecondHttpMethod) {
    registerSecondHttpMethod_register = 1,
};



@interface LyRegisterSecondViewController () <UITextFieldDelegate, LyHttpRequestDelegate, LyGetAuthCodeButtonDelegate, LyRemindViewDelegate>
{
    UITextField                 *tfName;
    UITextField                 *tfPhone;
    UITextField                 *tfAuthCode;
    LyGetAuthCodeButton         *btnGetAuthCode;
    UITextField                 *tfPassword;
    UIButton                    *btnVisiable;
    
    UIButton                    *btnRegister;
    
    
    LyIndicator                 *indicator_register;
    LyRegisterSecondHttpMethod  curHttpMethod;
    BOOL                        bHttpFlag;
}
@end

@implementation LyRegisterSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}


- (void)viewWillAppear:(BOOL)animated
{
    _userType = [_delegate obtainUsetType:self];
    
    if (LyUserType_school == _userType) {
        UILabel *lbName = (UILabel *)tfName.leftView;
        lbName.text = LyLocalize(@"驾校名");
        
        tfName.placeholder = LyLocalize(@"请输入驾校名");
    }
    
    [self addObserverForNotificationFromUITextFieldTextDidChangeNotification];
}


- (void)viewWillDisappear:(BOOL)animated {
    [self removeObserverForNotificationFromUITextFieldTextDidChangeNotification];
}



- (void)initAndLayoutSubviews
{
    self.title = LyLocalize(@"注册");
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    //用户名
    tfName = [[UITextField alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT+20.0f, SCREEN_WIDTH, LyViewItemHeight)];
    [tfName setTag:registerSecondTextFieldTag_name];
    [tfName setBackgroundColor:[UIColor whiteColor]];
    [tfName setDelegate:self];
    [tfName setFont:tfItemFont];
    [tfName setTextColor:LyBlackColor];
    tfName.placeholder = LyLocalize(@"请输入真实姓名");
    [tfName setReturnKeyType:UIReturnKeyNext];
    
    [tfName setLeftView:[self lbTitleWithText:LyLocalize(@"姓名")]];
    [tfName setLeftViewMode:UITextFieldViewModeAlways];
    
    [tfName setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    
    
    //电话
    tfPhone = [[UITextField alloc] initWithFrame:CGRectMake(0, tfName.ly_y+CGRectGetHeight(tfName.frame)+verticalSpace, SCREEN_WIDTH, LyViewItemHeight)];
    [tfPhone setTag:registerSecondTextFieldTag_phone];
    [tfPhone setBackgroundColor:[UIColor whiteColor]];
    [tfPhone setDelegate:self];
    [tfPhone setKeyboardType:UIKeyboardTypePhonePad];
    [tfPhone setFont:tfItemFont];
    [tfPhone setTextColor:LyBlackColor];
    tfPhone.placeholder = LyLocalize(@"请输入手机号");
    [tfPhone setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfPhone setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfPhone]];
    [tfPhone setReturnKeyType:UIReturnKeyNext];
    
    [tfPhone setLeftView:[self lbTitleWithText:LyLocalize(@"手机号")]];
    [tfPhone setLeftViewMode:UITextFieldViewModeAlways];
    
    [tfPhone setClearButtonMode:UITextFieldViewModeWhileEditing];

    
    
    //验证码
    UIView *viewAuthCode = [[UIView alloc] initWithFrame:CGRectMake(0, tfPhone.ly_y+CGRectGetHeight(tfPhone.frame)+verticalSpace, SCREEN_WIDTH, LyViewItemHeight)];
    [viewAuthCode setBackgroundColor:[UIColor whiteColor]];
    
    tfAuthCode = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-btnGetAuthCodeWidth-horizontalSpace-verticalSpace, LyViewItemHeight)];
    [tfAuthCode setTag:registerSecondTextFieldTag_authCode];
    [tfAuthCode setBackgroundColor:[UIColor whiteColor]];
    [tfAuthCode setDelegate:self];
    [tfAuthCode setKeyboardType:UIKeyboardTypeNumberPad];
    [tfAuthCode setFont:tfItemFont];
    [tfAuthCode setTextColor:LyBlackColor];
    tfAuthCode.placeholder = LyLocalize(@"请输入验证码");
    [tfAuthCode setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfAuthCode setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfAuthCode]];
    [tfAuthCode setReturnKeyType:UIReturnKeyNext];
    
    [tfAuthCode setLeftView:[self lbTitleWithText:LyLocalize(@"验证码")]];
    [tfAuthCode setLeftViewMode:UITextFieldViewModeAlways];
    [tfAuthCode setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    btnGetAuthCode = [[LyGetAuthCodeButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-btnGetAuthCodeWidth-verticalSpace, LyViewItemHeight/2.0f-btnGetAuthCodeHeight/2.0f, btnGetAuthCodeWidth, btnGetAuthCodeHeight)];
    [btnGetAuthCode setDelegate:self];
    
    [viewAuthCode addSubview:tfAuthCode];
    [viewAuthCode addSubview:btnGetAuthCode];
    


    //密码
    UIView *viewPassword = [[UIView alloc] initWithFrame:CGRectMake(0, viewAuthCode.ly_y+CGRectGetHeight(viewAuthCode.frame)+verticalSpace, SCREEN_WIDTH, LyViewItemHeight)];
    [viewPassword setBackgroundColor:[UIColor whiteColor]];
    
    tfPassword = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-LyViewItemHeight-horizontalSpace, LyViewItemHeight)];
    [tfPassword setTag:registerSecondTextFieldTag_password];
    [tfPassword setBackgroundColor:[UIColor whiteColor]];
    [tfPassword setKeyboardType:UIKeyboardTypeASCIICapable];
    [tfPassword setDelegate:self];
    [tfPassword setSecureTextEntry:YES];
    [tfPassword setFont:tfItemFont];
    [tfPassword setTextColor:LyBlackColor];
    tfPassword.placeholder = LyLocalize(@"请输入密码");
    [tfPassword setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfPassword setReturnKeyType:UIReturnKeyDone];
    
    [tfPassword setLeftView:[self lbTitleWithText:LyLocalize(@"密码")]];
    [tfPassword setLeftViewMode:UITextFieldViewModeAlways];
    [tfPassword setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    btnVisiable = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-LyViewItemHeight, 0, LyViewItemHeight, LyViewItemHeight)];
    [btnVisiable setTag:registerSecondButtonTag_visiable];
    [btnVisiable setImage:[LyUtil imageForImageName:@"pwdVisiable_n" needCache:NO] forState:UIControlStateNormal];
    [btnVisiable setImage:[LyUtil imageForImageName:@"pwdVisiable_h" needCache:NO] forState:UIControlStateSelected];
    [btnVisiable addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewPassword addSubview:tfPassword];
    [viewPassword addSubview:btnVisiable];
    

    
    
    //517协议
    //517协议-文字
    NSString *strLb517Protocal_pre = LyLocalize(@"《吾要去用户协议》");
    NSString *strLb517ProtocolTmp = [[NSString alloc] initWithFormat:@"%@%@", LyLocalize(@"注册即代表同意"), strLb517Protocal_pre];
    CGFloat fWidthLb517Protocol = [strLb517ProtocolTmp sizeWithAttributes:@{NSFontAttributeName:LyFont(12)}].width;
    NSMutableAttributedString *strLb517Protocol = [[NSMutableAttributedString alloc] initWithString:strLb517ProtocolTmp];
    [strLb517Protocol addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[strLb517ProtocolTmp rangeOfString:strLb517Protocal_pre]];
    //517协议-gestureRecognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForTapGestureFromLb517Protocol:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    //517协议-view
    UILabel *lb517Protocol = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-fWidthLb517Protocol, viewPassword.ly_y+CGRectGetHeight(viewPassword.frame)+verticalSpace, fWidthLb517Protocol, 30.0f)];
    [lb517Protocol setFont:LyFont(12)];
    [lb517Protocol setTextColor:LyBlackColor];
    [lb517Protocol setAttributedText:strLb517Protocol];
    [lb517Protocol setUserInteractionEnabled:YES];
    [lb517Protocol addGestureRecognizer:tapGesture];
    
    //密码格式提示
    UILabel *lbPsdRemind = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, lb517Protocol.ly_y+CGRectGetHeight(lb517Protocol.frame)+verticalSpace, (SCREEN_WIDTH-horizontalSpace*2), 40.0f)];
    [lbPsdRemind setFont:LyFont(12)];
    [lbPsdRemind setTextColor:Ly517ThemeColor];
    [lbPsdRemind setNumberOfLines:0];
    [lbPsdRemind setTextAlignment:NSTextAlignmentLeft];
//    [lbPsdRemind setText:@"*密码需在6~18位之间\n*密码至少由字母和数字组成（可以输入特殊字符）"];
    lbPsdRemind.text = LyLocalize(@"*密码需在6~18位之间\n*密码至少由字母和数字组成（可以输入特殊字符）");
    
    
    //注册按钮
    btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f-btnRegisterWidth/2.0f, lbPsdRemind.ly_y+CGRectGetHeight(lbPsdRemind.frame)+20.0f, btnRegisterWidth, rsBtnRegisterHeight)];
    [btnRegister setTag:registerSecondButtonTag_register];
    [btnRegister setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    [btnRegister setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnRegister setTitle:LyLocalize(@"注册") forState:UIControlStateNormal];
    [btnRegister addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:tfName];
    [self.view addSubview:tfPhone];
    [self.view addSubview:viewAuthCode];
    [self.view addSubview:viewPassword];
    [self.view addSubview:lb517Protocol];
    [self.view addSubview:lbPsdRemind];
    [self.view addSubview:btnRegister];
    
    
    [btnRegister setEnabled:NO];
    
}



- (UILabel *)lbTitleWithText:(NSString *)text {
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rsLbItemWidth, LyViewItemHeight)];
    [lb setFont:lbItemFont];
    [lb setTextColor:[UIColor blackColor]];
    [lb setTextAlignment:NSTextAlignmentCenter];
    [lb setText:text];
    
    return lb;
}


- (void)allControlResignFirstResponder {
    [tfName resignFirstResponder];
    [tfPhone resignFirstResponder];
    [tfAuthCode resignFirstResponder];
    [tfPassword resignFirstResponder];
}




- (void)addObserverForNotificationFromUITextFieldTextDidChangeNotification {
    if ([self respondsToSelector:@selector(targetForNotificationFormUITextFieldTextDidChangeNotification:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(targetForNotificationFormUITextFieldTextDidChangeNotification:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:nil];
    }
}

- (void)removeObserverForNotificationFromUITextFieldTextDidChangeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self allControlResignFirstResponder];
}



- (void)targetForTapGestureFromLb517Protocol:(UITapGestureRecognizer *)tap
{
    LyTxtViewController *txt = [[LyTxtViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:txt];
    [self presentViewController:nav animated:YES completion:^{
        [txt setMode:LyTxtViewControllerMode_517UserProtocol];
    }];
}


- (void)targetForButton:(UIButton *)button {
    if (registerSecondButtonTag_visiable == button.tag) {
        
        [button setSelected:!button.isSelected];
        [tfPassword setSecureTextEntry:!button.isSelected];
    } else if (registerSecondButtonTag_register == button.tag) {
        [self register_];
    }
}



- (BOOL)validate:(BOOL)flag {
    
    [btnRegister setEnabled:NO];
    
    if ( ![tfName.text validateName]) {
        if (flag) {
            [tfName setTextColor:LyWarnColor];
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"姓名格式错误"] show];
        }
        
        return NO;
    } else {
        [tfName setTextColor:LyBlackColor];
    }
    
    
    if ( ![tfPhone.text validatePhoneNumber]) {
        if (flag) {
            [tfPhone setTextColor:LyWarnColor];
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号格式错误"] show];
        }
        
        return NO;
    } else {
        [tfPhone setTextColor:LyBlackColor];
    }
    
    if ( ![tfAuthCode.text validateAuthCode]) {
        if (flag) {
            [tfAuthCode setTextColor:LyWarnColor];
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码格式错误"] show];
        }
        
        return NO;
    } else {
        [tfAuthCode setTextColor:LyBlackColor];
    }
    
    
    if ( !tfPassword.text || tfPassword.text.length < 1 || ![tfPassword.text validatePassword]) {
        if (flag) {
            [tfPassword setTextColor:LyWarnColor];
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"密码格式错误"] show];
        }
        
        return NO;
    } else {
        [tfPassword setTextColor:LyBlackColor];
    }
    
    
    [btnRegister setEnabled:YES];
    
    
    if (![LyUtil validateString:btnGetAuthCode.time]) {
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没有获取验证码"] show];
        }

        return NO;
    }
    
    return YES;
}


- (void)register_ {
    
    if (![self validate:YES]) {
        return;
    }
    
    
    if (!indicator_register) {
        indicator_register = [LyIndicator indicatorWithTitle:@"正在注册..."];
    }
    [indicator_register startAnimation];
    
    NSString *strUserName = tfName.text;
    NSString *strUserNameSuffix = [LyUtil userTypeChineseStringFrom:_userType];
    if ([strUserName rangeOfString:strUserNameSuffix].length < 1) {
        strUserName = [strUserName stringByAppendingString:strUserNameSuffix];
    }
    
    NSString *pwd = [LyUtil encodePassword:tfPassword.text];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:registerSecondHttpMethod_register];
    [httpRequest setDelegate:self];
    bHttpFlag = [httpRequest startHttpRequest:register_url
                                         body:@{
                                                nickNameKey:strUserName,
                                                accountKey:tfPhone.text,
                                                passowrdKey:pwd,
                                                authKey:tfAuthCode.text,
                                                timeKey:btnGetAuthCode.time,
//                                                trueAuthKey:btnGetAuthCode.trueAuthCode,
                                                userTypeKey:[LyUtil userTypeStringFrom:_userType],
                                                }
                                         type:LyHttpType_asynPost
                                      timeOut:0];
}



- (void)handleHttpFailed {
    if ([indicator_register isAnimating]) {
        [indicator_register stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"注册失败"] show];
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
    
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_register stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    switch (curHttpMethod) {
        case registerSecondHttpMethod_register: {
            switch ([strCode integerValue]) {
                case 0: {
                    
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [self handleHttpFailed];
                        return;
                    }
                    
                    NSString *strAccount = [tfPhone text];
                    NSString *strPassword = [tfPassword text];
                    
                    NSString *strHttpSessionId = [dic objectForKey:sessionIdKey];
                    NSString *strUserId = [dicResult objectForKey:userIdKey];
                    NSString *strNickName = [dicResult objectForKey:nickNameKey];
                    NSString *strUserType = [dicResult objectForKey:userTypeKey];
                    
                    
                    [[NSUserDefaults standardUserDefaults] setObject:strAccount forKey:userAccount517Key_tc];
                    [[NSUserDefaults standardUserDefaults] setObject:strPassword forKey:userPassword517Key_tc];
                    [[NSUserDefaults standardUserDefaults] setObject:strUserId forKey:userId517Key_tc];
                    [[NSUserDefaults standardUserDefaults] setObject:strNickName forKey:userName517Key_tc];
                    [[NSUserDefaults standardUserDefaults] setObject:strUserType forKey:userTypeKey_tc];
                    
                    [LyUtil setHttpSessionId:strHttpSessionId];
                    
                    
                    [[LyCurrentUser curUser] setUserTypeWithString:strUserType];
                    [[LyCurrentUser curUser] setUserId:strUserId];
                    [[LyCurrentUser curUser] setUserPhoneNum:strAccount];
                    [[LyCurrentUser curUser] setUserName:strNickName];
                    
                    
                    [indicator_register stopAnimation];
                    
                    
                    LyRemindView *remindView = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"注册成功"];
                    [remindView setDelegate:self];
                    [remindView show];
                    break;
                }
                case 1: {
                    NSString *strMessage = [dic objectForKey:messageKey];
                    if (![LyUtil validateString:strMessage]) {
                        [self handleHttpFailed];
                    } else {
                        [indicator_register stopAnimation];
                        
                        LyRemindView *remindView = [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:strMessage];
                        [remindView show];
                    }
                    break;
                }
                    
                case 2: {
                    NSString *strMessage = [dic objectForKey:messageKey];
                    if (![LyUtil validateString:strMessage]) {
                        [self handleHttpFailed];
                    } else {
                        [indicator_register stopAnimation];
                        
                        LyRemindView *remindView = [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:strMessage];
                        [remindView show];
                    }
                    
                    break;
                }
                    
                case 3: {
                    NSString *strMessage = [dic objectForKey:messageKey];
                    if (![LyUtil validateString:strMessage]) {
                        [self handleHttpFailed];
                    } else {
                        [indicator_register stopAnimation];
                        
                        LyRemindView *remindView = [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:strMessage];
                        [remindView show];
                    }
                    
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
        curHttpMethod = ahttpRequest.mode;
        [self analysisHttpResult:result];
    }
    
    curHttpMethod = 0;
}



#pragma mark -LyGetAuthCodeButtonDelegate
- (NSString *)obtainPhoneNum:(LyGetAuthCodeButton *)button {
    if ( [[tfPhone text] validatePhoneNumber]) {
        return [tfPhone text];
    } else {
        [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"手机号格式错误"] show];
        return @"";
    }
}

- (void)sendSuccessByGetAuthCodeButton:(LyGetAuthCodeButton *)aGetAuthCodeButton time:(NSString *)aTime trueAuth:(NSString *)trueAuth {
    [self validate:NO];
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (registerSecondTextFieldTag_name == textField.tag) {
        [tfPhone becomeFirstResponder];
    }
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == tfName)
    {
        if (tfName.text.length > 0)
        {
            if ([tfName.text validateName])
            {
                [tfName setTextColor:LyBlackColor];
            }
            else
            {
                [tfName setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"姓名格式错误"] show];
            }
        }
    }
    else if (textField == tfPhone)
    {
        if (tfPhone.text.length > 0)
        {
            if ([tfPhone.text validatePhoneNumber])
            {
                [tfPhone setTextColor:LyBlackColor];
            }
            else
            {
                [tfPhone setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号格式错误"] show];
            }
        }
    }
    else if (textField == tfAuthCode)
    {
        if (tfAuthCode.text.length > 0)
        {
            if ([tfAuthCode.text validateAuthCode])
            {
                [tfAuthCode setTextColor:LyBlackColor];
            }
            else
            {
                [tfAuthCode setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码格式错误"] show];
            }
        }
    }
    else if (textField == tfPassword) {
        if (tfPassword.text.length > 0) {
            if ([tfPassword.text validatePassword]) {
                 [tfPassword setTextColor:LyBlackColor];
            } else {
                [tfPassword setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"密码格式错误"] show];
            }
        }
    }
  
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (registerSecondTextFieldTag_name == textField.tag) {
        if (textField.text.length + string.length > LyNameLengthMax) {
            return NO;
        }
    }
    else if (registerSecondTextFieldTag_phone == textField.tag) {
        if (textField.text.length + string.length > LyAccountLength) {
            return NO;
        }
    } else if (registerSecondTextFieldTag_authCode == textField.tag) {
        if (textField.text.length + string.length > 6) {
            return NO;
        }
    } else if (registerSecondTextFieldTag_password == textField.tag) {
        if (textField.text.length + string.length > LyPasswordLengthMax) {
            return NO;
        }
    }
    
    return YES;
}



#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(LyRemindView *)aRemind
{
    LyAuthPhotoViewController *authPhoto = [[LyAuthPhotoViewController alloc] init];
    [self.navigationController pushViewController:authPhoto animated:YES];
}



#pragma mark -UITextFieldTextDidChangeNotification
- (void)targetForNotificationFormUITextFieldTextDidChangeNotification:(NSNotification *)notifi {
    if ([notifi.object isKindOfClass:[UITextField class]]) {
        [self validate:NO];
    }
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
