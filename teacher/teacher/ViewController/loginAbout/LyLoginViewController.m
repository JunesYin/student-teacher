//
//  LyLoginViewController.m
//  teacher
//
//  Created by Junes on 16/7/13.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyLoginViewController.h"

#import "LyRemindView.h"
#import "LyToolBar.h"
#import "LyIndicator.h"

#import "LyCurrentUser.h"

#import "NSString+Validate.h"

#import "LyUtil.h"



#import "LyRegisterSecondViewController.h"
#import "LyAuthPhotoViewController.h"
#import "LyVerifyProgressViewController.h"

#import "LyForgotPasswordViewController.h"



#define viewItemWidth                   (SCREEN_WIDTH-horizontalSpace*2)
CGFloat const lViewItemHeight = 50.0f;


CGFloat const lLbItemWidth = 70.0f;
CGFloat const lLbItemHeight = lViewItemHeight;

#define lTfItemWidth                     (viewItemWidth-lLbItemWidth)
CGFloat const lTfItemHeight = lViewItemHeight;



//忘记密码
CGFloat const lBtnForgotWidth = 90.0f;
CGFloat const lBtnForgotHeight = 30.0f;



//登录
#define btnLoginWidth                   (SCREEN_WIDTH*4/5.0f)
CGFloat const btnLoginHeight = 50.0f;




typedef NS_ENUM(NSInteger, LoginBarButtonItemTag)
{
    loginBarButtonItemTag_close = 1,
    loginBarButtonItemTag_register
};


typedef NS_ENUM(NSInteger, LoginTextFieldButtonTag) {
    loginButtonItemTag_acc = 10,
    loginButtonItemTag_pwd
};


typedef NS_ENUM(NSInteger, LoginHttpMethod)
{
    loginHttpMethod_login = 100,
};



@interface LyLoginViewController () <UITextFieldDelegate, LyHttpRequestDelegate, LyRemindViewDelegate, RegisterSecondDelegate, LyForgotPasswordViewControllerDelegate>
{
    BOOL                flagGotoAppStore;
    
    
    UIBarButtonItem     *barBtnclose;

    UITextField         *tfAccount;
    UITextField         *tfPwd;
    
    UIButton            *btnLogin;
    UIButton            *btnForgot;
    
    BOOL                bFlag; //控制“密码格式错误”的弹出，防止用户点击空白退出键盘时不弹出或点击“登录”弹出两次
    
    LyIndicator         *indicator_login;
    BOOL                bHttpFlag;
    LoginHttpMethod     curHttpMethod;
}
@end

@implementation LyLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}


- (void)viewWillAppear:(BOOL)animated
{
    if(self.navigationController.viewControllers.count > 1)
    {
        if (self.navigationItem.leftBarButtonItem)
        {
            [self.navigationItem setLeftBarButtonItem:nil];
        }
    }
    else
    {
        if (!barBtnclose)
        {
            barBtnclose = [[UIBarButtonItem alloc] initWithTitle:LyLocalize(@"取消")
                                                           style:UIBarButtonItemStyleDone
                                                          target:self
                                                          action:@selector(targetForBarButtonItem:)];
            [barBtnclose setTag:loginBarButtonItemTag_close];
        }
        [self.navigationItem setLeftBarButtonItem:barBtnclose];
    }
    
    if (tfAccount.text.length < 1)
    {
        NSString *strAccount = [[NSUserDefaults standardUserDefaults] objectForKey:userAccount517Key_tc];
        if (strAccount)
        {
            [tfAccount setText:strAccount];
        }
    }
    [tfPwd setText:nil];
    
    [self addObserverForNotificationFromUITextFieldTextDidChangeNotification];
}


- (void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeObserverForNotificationFromUITextFieldTextDidChangeNotification];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LyAppDidBecomeActive object:nil];
}


- (void)initAndLayoutSubviews
{
    [self.navigationItem setTitle:LyLocalize(@"登录")];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];

    UIBarButtonItem *bbiRegister = [[UIBarButtonItem alloc] initWithTitle:LyLocalize(@"注册")
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self action:@selector(targetForBarButtonItem:)];
    [bbiRegister setTag:loginBarButtonItemTag_register];
    self.navigationItem.rightBarButtonItem = bbiRegister;
    
    UILabel *lbRemind = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 50.0f)];
    [lbRemind setFont:LyFont(14)];
    [lbRemind setTextColor:LyHighLightgrayColor];
    [lbRemind setTextAlignment:NSTextAlignmentCenter];
    lbRemind.text = [[NSString alloc] initWithFormat:@"%@%@", LyLocalize(@"登录用户类型："), [LyUtil userTypeChineseStringFrom:_userType]];
    
    
    tfAccount = [[UITextField alloc] initWithFrame:CGRectMake(0, lbRemind.ly_y+CGRectGetHeight(lbRemind.frame), SCREEN_WIDTH, lTfItemHeight)];
    [tfAccount setTag:loginButtonItemTag_acc];
    [tfAccount setBackgroundColor:[UIColor whiteColor]];
    [tfAccount setKeyboardType:UIKeyboardTypePhonePad];
    [tfAccount setTextColor:LyBlackColor];
    [tfAccount setFont:LyFont(16)];
    [tfAccount setTextAlignment:NSTextAlignmentCenter];
    tfAccount.placeholder = LyLocalize(@"手机号");
    [tfAccount setReturnKeyType:UIReturnKeyDone];
    [tfAccount setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfAccount setDelegate:self];
    [tfAccount setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfAccount]];
    
    tfPwd = [[UITextField alloc] initWithFrame:CGRectMake(0, tfAccount.ly_y+CGRectGetHeight(tfAccount.frame)+verticalSpace*2, SCREEN_WIDTH, lTfItemHeight)];
    [tfPwd setTag:loginButtonItemTag_pwd];
    [tfPwd setBackgroundColor:[UIColor whiteColor]];
    [tfPwd setSecureTextEntry:YES];
    [tfPwd setTextColor:LyBlackColor];
    [tfPwd setFont:LyFont(16)];
    [tfPwd setTextAlignment:NSTextAlignmentCenter];
    tfPwd.placeholder = LyLocalize(@"密码");
    [tfPwd setReturnKeyType:UIReturnKeyGo];
    [tfPwd setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfPwd setDelegate:self];
    [tfPwd setEnablesReturnKeyAutomatically:YES];
    
    
    
    
    
    //登录
    btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f-btnLoginWidth/2.0f, tfPwd.ly_y+CGRectGetHeight(tfPwd.frame)+20.0f, btnLoginWidth, btnLoginHeight)];
    [btnLogin setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnLogin setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btnLogin setTitle:LyLocalize(@"登录") forState:UIControlStateNormal];
    [btnLogin setBackgroundColor:LyWhiteLightgrayColor];
    [[btnLogin layer] setCornerRadius:btnCornerRadius];
    [btnLogin addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //忘记密码
    btnForgot = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-lBtnForgotWidth, SCREEN_HEIGHT-verticalSpace-lBtnForgotHeight, lBtnForgotWidth, lBtnForgotHeight)];
    [btnForgot setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnForgot setTitle:LyLocalize(@"忘记密码？") forState:UIControlStateNormal];
    [[btnForgot titleLabel] setFont:LyFont(12)];
    [btnForgot setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnForgot addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    btnForgot.translatesAutoresizingMaskIntoConstraints = NO;
    
    


    [self.view addSubview:lbRemind];
    [self.view addSubview:tfAccount];
    [self.view addSubview:tfPwd];
    [self.view addSubview:btnForgot];
    [self.view addSubview:btnLogin];
    
    
    NSLayoutConstraint *constraintBtnForgot_trainling = [NSLayoutConstraint constraintWithItem:btnForgot
                                                                                     attribute:NSLayoutAttributeRight
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self.view
                                                                                     attribute:NSLayoutAttributeRight
                                                                                    multiplier:1
                                                                                      constant:-verticalSpace];
    NSLayoutConstraint *constraintBtnForgot_bottom = [NSLayoutConstraint constraintWithItem:btnForgot
                                                                                  attribute:NSLayoutAttributeBottom
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self.view
                                                                                  attribute:NSLayoutAttributeBottom
                                                                                 multiplier:1
                                                                                   constant:-verticalSpace];
    NSLayoutConstraint *constraintBtnForgot_width = [NSLayoutConstraint constraintWithItem:btnForgot
                                                                                 attribute:NSLayoutAttributeWidth
                                                                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                    toItem:nil
                                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                                multiplier:1
                                                                                  constant:150];
    NSLayoutConstraint *constraintBtnForgot_height = [NSLayoutConstraint constraintWithItem:btnForgot
                                                                                 attribute:NSLayoutAttributeHeight
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:nil
                                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                                multiplier:1
                                                                                  constant:lBtnForgotHeight];
    [self.view addConstraints:@[constraintBtnForgot_trainling,
                                constraintBtnForgot_bottom,
                                constraintBtnForgot_width,
                                constraintBtnForgot_height]];
    
    
    [btnLogin setEnabled:NO];
    
    
    if ( [self respondsToSelector:@selector(targetForAppDidBecomeActive:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(targetForAppDidBecomeActive:) name:LyAppDidBecomeActive object:nil];
    }
    
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



- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi
{
    if (loginBarButtonItemTag_close == bbi.tag)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (loginBarButtonItemTag_register == bbi.tag)
    {
        LyRegisterSecondViewController *registerSecond = [[LyRegisterSecondViewController alloc] init];
        [registerSecond setDelegate:self];
        [self.navigationController pushViewController:registerSecond animated:YES];
    }
}



- (void)targetForButton:(UIButton *)button
{
    if (button == btnForgot) {
        
        LyForgotPasswordViewController *forgot = [[LyForgotPasswordViewController alloc] init];
        [forgot setDelegate:self];
        [self.navigationController pushViewController:forgot animated:YES];
        
    } else if (button == btnLogin) {
        [self allControlResignFirstResponder];
        
        [self login];
    }
}



- (void)allControlResignFirstResponder
{
    bFlag = YES;
    
    [tfAccount resignFirstResponder];
    [tfPwd resignFirstResponder];
}



//显示需要升级的提示
- (void)showAlertForUpdate {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitleForUpdate
                                                                   message:alertMessageForUpdate
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self dismissViewControllerAnimated:YES completion:nil];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"前往下载"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                flagGotoAppStore = YES;
                                                NSURL *url = [NSURL URLWithString:appStore_url];
                                                [LyUtil openUrl:url];
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}



- (BOOL)validate:(BOOL)flag {
    
    [btnLogin setEnabled:NO];
    
    if ( ![[tfAccount text] validatePhoneNumber]) {
        if (flag) {
            [tfAccount setTextColor:LyWarnColor];
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号格式错误"] show];
        }
        return NO;
    } else {
        [tfAccount setTextColor:LyBlackColor];
    }
    
    if ( ![[tfPwd text] validatePassword]) {
        if (flag) {
            [tfPwd setTextColor:LyWarnColor];
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"密码格式错误"] show];
        }
        return NO;
    } else  {
        [tfPwd setTextColor:LyBlackColor];
    }
    
    [btnLogin setEnabled:YES];
    
    return YES;
}


//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self allControlResignFirstResponder];
}


- (void)getUserAvatarAsyn:(NSString *)userId
{
    [LyImageLoader loadAvatarWithUserId:userId
                               complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSString * _Nullable userId) {
                                   if (!image) {
                                       image = [LyUtil defaultAvatarForTeacher];
                                   }
                                   
                                   [[LyCurrentUser curUser] setUserAvatar:image];
                                   [LyUtil saveImage:image withUserId:userId withMode:LySaveImageMode_avatar];
                               }];
    
}


- (void)loginDone {
    
    if (LyTeacherVerifyState_access == [LyCurrentUser curUser].verifyState) {
        [_delegate loginDone:self];
        
    } else if (LyTeacherVerifyState_null == [LyCurrentUser curUser].verifyState) {
        LyAuthPhotoViewController *authPhoto = [[LyAuthPhotoViewController alloc] init];
        [self.navigationController pushViewController:authPhoto animated:YES];
        
    } else {
        LyVerifyProgressViewController *verifyProgress = [[LyVerifyProgressViewController alloc] init];
        [self.navigationController pushViewController:verifyProgress animated:YES];
    }
}


- (void)login {
    if (![self validate:YES]) {
        return;
    }
    
    
    if (!indicator_login) {
        indicator_login = [LyIndicator indicatorWithTitle:@"正在登录..."];
    }
    [indicator_login startAnimation];
    
    
    NSString *pwd_encoded = [LyUtil encodePassword:tfPwd.text];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:loginHttpMethod_login];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:login_url
                                 body:@{
                                        accountKey:[tfAccount text],
                                        passowrdKey:pwd_encoded,
                                        userTypeKey:[LyUtil userTypeStringFrom:_userType],
                                        versionKey:[LyUtil getApplicationVersionNoPoint]
                                        }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}



- (void)handleHttpFailed {
    if ([indicator_login isAnimating]) {
        [indicator_login stopAnimation];
        
        LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"登录失败"];
        [remind show];
    }
}



- (void)analysisHttpResult:(NSString *)result {
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
        [indicator_login stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    switch (curHttpMethod) {
        case loginHttpMethod_login: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [self handleHttpFailed];
                        return;
                    }
                    
                    NSString *strAccount = [tfAccount text];
                    NSString *strPassword = [tfPwd text];
                    
                    NSString *strSessionId = [dic objectForKey:sessionIdKey];
                    
                    NSString *strUserId = [dicResult objectForKey:userIdKey];
                    NSString *strNickName = [dicResult objectForKey:nickNameKey];
                    NSString *strAddress = [dicResult objectForKey:addressKey];
                    NSString *strVerify = [dicResult objectForKey:verifyKey];
                    NSString *strUserType = [dicResult objectForKey:userTypeKey];

                    
                    
                    NSString *strAutoLoginFlag = [[NSUserDefaults standardUserDefaults] objectForKey:userAutoLoginFlagKey];
                    if ( !strAutoLoginFlag || [strAutoLoginFlag isEqualToString:@""]) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:userAutoLoginFlagKey];
                    }
                    
                    
                    [LyUtil setHttpSessionId:strSessionId];
                    
                    
                    [[LyCurrentUser curUser] setUserTypeWithString:strUserType];
                    [[LyCurrentUser curUser] setUserId:strUserId];
                    [[LyCurrentUser curUser] setUserPhoneNum:strAccount];
                    [[LyCurrentUser curUser] setUserName:strNickName];
                    [[LyCurrentUser curUser] setUserAddress:strAddress];
                    [[LyCurrentUser curUser] setVerifyState:[strVerify integerValue]];
                    
                    if ([strUserType isEqualToString:@"jl"]) {
                        NSString *strCoachMode = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:coachModeKey]];
                        [[LyCurrentUser curUser] setCoachMode:[strCoachMode integerValue]];
                    }
                    
                    
                    [self getUserAvatarAsyn:strUserId];
                    
                    
                    [[NSUserDefaults standardUserDefaults] setObject:strUserId forKey:userId517Key_tc];
                    [[NSUserDefaults standardUserDefaults] setObject:strAccount forKey:userAccount517Key_tc];
                    [[NSUserDefaults standardUserDefaults] setObject:strPassword forKey:userPassword517Key_tc];
                    [[NSUserDefaults standardUserDefaults] setObject:strNickName forKey:userName517Key_tc];
                    [[NSUserDefaults standardUserDefaults] setObject:strUserType forKey:userTypeKey_tc];
                    [[NSUserDefaults standardUserDefaults] setObject:strVerify forKey:userVerifyKey_tc];
                    
                    
                    [LyUtil setAutoLoginFlag:YES];
                    
                    [indicator_login stopAnimation];
                    
                    
                    switch ([LyCurrentUser curUser].verifyState) {
                        case LyTeacherVerifyState_null: {
                            LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"尚未认证"];
                            [remind setDelegate:self];
                            [remind show];
                            break;
                        }
                        case LyTeacherVerifyState_rejected: {
                            [self loginDone];
                            break;
                        }
                        case LyTeacherVerifyState_verifying: {
                            [self loginDone];
                            break;
                        }
                        case LyTeacherVerifyState_access: {
                            LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"登录成功"];
                            [remind setDelegate:self];
                            [remind show];
                            break;
                        }
                    }
                    
                    break;
                }
                case 1: {
                    //无此帐号
                    [indicator_login stopAnimation];
                    
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"帐号不存在"] show];
                    break;
                }
                case 2: {
                    //密码错误
                    [indicator_login stopAnimation];
                    
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"密码错误"] show];
                    break;
                }
                case 3: {
                    //帐户类型错误
                    [indicator_login stopAnimation];
                    
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"帐号类型错误"] show];
                    break;
                }
                case 4: {
                    //客户端版本过低
                    [indicator_login stopAnimation];
                    
                    [self showAlertForUpdate];
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

- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result
{
    if (bHttpFlag)
    {
        bHttpFlag = NO;
        curHttpMethod = [ahttpRequest mode];
        [self analysisHttpResult:result];
    }
    
    curHttpMethod = 0;
}


#pragma mark -LyAppDidBecomeActive
- (void)targetForAppDidBecomeActive:(NSNotification *)notification {
    
    if (flagGotoAppStore) {
        flagGotoAppStore = NO;
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}





#pragma mark -LyForgotPasswordViewControllerDelegate 
- (LyUserType)obtainUserTypeByForgotPasswordVC:(LyForgotPasswordViewController *)forgotPasswordVC {
    return _userType;
}

- (void)resetPasswordSuccessByForgotPasswordVC:(LyForgotPasswordViewController *)forgotPasswordVC newPwd:(NSString *)newPwd {
    [forgotPasswordVC.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark -UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField == tfPwd)
    {
        [self targetForButton:btnLogin];
    }
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == tfAccount) {
        if (textField.text.length + string.length > LyAccountLength) {
            return NO;
        }
    } else if (textField == tfPwd) {
        if (textField.text.length + string.length > LyPasswordLengthMax) {
            return NO;
        } else {
            return YES;
        }
    }
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == tfAccount) {
        if (tfAccount.text.length > 0) {
            if ( ![tfAccount.text validatePhoneNumber]) {
                [tfAccount setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号格式错误"] show];
            } else {
                [tfAccount setTextColor:LyBlackColor];
            }
        }

    } else if (textField == tfPwd) {
        if (tfPwd.text.length > 0) {
            if ([tfPwd.text validatePassword]) {
                [tfPwd setTextColor:LyBlackColor];
            } else if (bFlag) {
                bFlag = NO;
                [tfPwd setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"密码格式错误"] show];
            }
        }
    }
}



#pragma mark RegisterSecondDelegate
- (LyUserType)obtainUsetType:(LyRegisterSecondViewController *)rsVc {
    return _userType;
}



#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(LyRemindView *)aRemind {
    [self loginDone];
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
