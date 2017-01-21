//
//  LyLoginViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/16.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyLoginViewController.h"
#import "LyCurrentUser.h"
#import "NSString+Validate.h"

#import "LyBottomControl.h"
#import "LyIndicator.h"
#import "LyRemindView.h"
#import "LyToolBar.h"


#import "LyUtil.h"


#import "LyRegisterViewController.h"
#import "LyForgotPasswordViewController.h"




#define lnTfTextFont                            LyFont(16)

//帐号框view
#define viewitemWidth                           (SCREEN_WIDTH-2*horizontalSpace)
//CGFloat const LyViewItemHeight = 50.0f;

//帐号框左侧文字
CGFloat const lbItemWidth = 70.0f;
//CGFloat const LyViewItemHeight = LyViewItemHeight;
//帐号输入框
#define tfItemWidth                             (viewitemWidth-lbItemWidth-5)
//CGFloat const LyViewItemHeight = LyViewItemHeight;



//忘记密码按钮
CGFloat const lBtnForgotWidth = 100.0f;
CGFloat const lBtnForgotHeight = 30.0f;
#define btnForgotTitleFont                      LyFont(14)


//登录
#define btnLoginWidth                           (SCREEN_WIDTH*4/5.0f)
CGFloat const btnLoginHeight = 50.0f;



enum {
    loginBarButtonItemTag_close = 0,
    loginBarButtonItemTag_register
}LyLoginBarButtonItemTag;

typedef NS_ENUM( NSInteger, LyLoginHttpMethod) {
    loginHttpMethod_login = 100,
};



@interface LyLoginViewController () <UITextFieldDelegate, LyRemindViewDelegate, LyHttpRequestDelegate, LyForgotPasswordViewControllerDelegate>
{
    BOOL                        flagGotoAppStore;
    
    
    //登录
    UITextField                 *tfAcc;
    UITextField                 *tfPwd;
    
    UIButton                    *btnForgot;
    UIButton                    *btnLogin;
    
    
    LyIndicator                 *indicator;
    
    BOOL                bFlag; //控制“密码格式错误”的弹出，防止用户点击空白退出键盘时不弹出或点击“登录”弹出两次
    
    
    LyLoginHttpMethod       curHttpMethod;
    BOOL                    bHttpFlag;
    
    
}

@end

@implementation LyLoginViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}



- (void)viewWillAppear:(BOOL)animated {
    [tfPwd setText:@""];
    
    [self addObserverForNotification];
}



- (void)viewWillDisappear:(BOOL)animated {
    [self lnAllItemsResignFirstResponder];
    
    [self removeObserverForNotification];
}



- (void)initSubviews {
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    self.title = @"登录";
    
    UIBarButtonItem *bbiClose = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(lnTargetForRightBarBtnItem:)];
    [bbiClose setTag:loginBarButtonItemTag_close];
    
    UIBarButtonItem *bbiRegister = [[UIBarButtonItem alloc] initWithTitle:@"注册"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(lnTargetForRightBarBtnItem:)];
    [bbiRegister setTag:loginBarButtonItemTag_register];
    
    [self.navigationItem setLeftBarButtonItem:bbiClose];
    [self.navigationItem setRightBarButtonItem:bbiRegister];

    
    
    //提示
    UILabel *lbPrompt = [[UILabel alloc] initWithFrame:CGRectMake( 0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT+10, SCREEN_WIDTH-horizontalSpace*2, 50.0f)];
    [lbPrompt setText:@"为了方便你快速预约，请先登录"];
    [lbPrompt setFont:LyFont(12)];
    [lbPrompt setTextColor:[UIColor lightGrayColor]];
    [lbPrompt setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:lbPrompt];
    
    
    
    //帐号框
    tfAcc = [[UITextField alloc] initWithFrame:CGRectMake(0, lbPrompt.frame.origin.y + CGRectGetHeight(lbPrompt.frame) + verticalSpace, SCREEN_WIDTH, LyViewItemHeight)];
    [tfAcc setBackgroundColor:[UIColor whiteColor]];
    [tfAcc setBackgroundColor:[UIColor whiteColor]];
    [tfAcc setKeyboardType:UIKeyboardTypePhonePad];
    [tfAcc setTextColor:LyBlackColor];
    [tfAcc setFont:LyFont(16)];
    [tfAcc setTextAlignment:NSTextAlignmentCenter];
    [tfAcc setPlaceholder:@"手机号"];
    [tfAcc setReturnKeyType:UIReturnKeyDone];
    [tfAcc setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfAcc setDelegate:self];
    [tfAcc setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfAcc]];


    //密码框
    tfPwd = [[UITextField alloc] initWithFrame:CGRectMake(0, tfAcc.frame.origin.y + CGRectGetHeight(tfAcc.frame) + verticalSpace, SCREEN_WIDTH, LyViewItemHeight)];
    [tfPwd setBackgroundColor:[UIColor whiteColor]];
    [tfPwd setSecureTextEntry:YES];
    [tfPwd setTextColor:LyBlackColor];
    [tfPwd setFont:LyFont(16)];
    [tfPwd setTextAlignment:NSTextAlignmentCenter];
    [tfPwd setPlaceholder:@"密码"];
    [tfPwd setReturnKeyType:UIReturnKeyGo];
    [tfPwd setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfPwd setDelegate:self];
    [tfPwd setEnablesReturnKeyAutomatically:YES];
    
    
    //登录
    btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f-btnLoginWidth/2.0f, tfPwd.frame.origin.y+CGRectGetHeight(tfPwd.frame)+20.0f, btnLoginWidth, btnLoginHeight)];
    [btnLogin setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnLogin setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btnLogin setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnLogin setTitle:@"登录" forState:UIControlStateNormal];;
    [btnLogin setBackgroundColor:LyWhiteLightgrayColor];
    [[btnLogin layer] setCornerRadius:btnCornerRadius];
    [btnLogin addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //忘记密码
    btnForgot = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-lBtnForgotWidth, SCREEN_HEIGHT-verticalSpace-lBtnForgotHeight, lBtnForgotWidth, lBtnForgotHeight)];
    [btnForgot setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnForgot setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [[btnForgot titleLabel] setFont:LyFont(12)];
    [btnForgot setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnForgot addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    [self.view addSubview:lbPrompt];
    [self.view addSubview:tfAcc];
    [self.view addSubview:tfPwd];
    [self.view addSubview:btnForgot];
    [self.view addSubview:btnLogin];
    
    
    
    [btnLogin setEnabled:NO];
    NSString *localAccount = [[NSUserDefaults standardUserDefaults] objectForKey:userAccount517Key];
    if (localAccount) {
        [tfAcc setText:localAccount];
    }
    
}



- (void)addObserverForNotification {
    
    if ( [self respondsToSelector:@selector(targetForAppDidBecomeActive:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(targetForAppDidBecomeActive:) name:LyAppDidBecomeActive object:nil];
    }
    
    if ([self respondsToSelector:@selector(targetForNotificationFormUITextFieldTextDidChangeNotification:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(targetForNotificationFormUITextFieldTextDidChangeNotification:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:nil];
    }
}


- (void)removeObserverForNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LyAppDidBecomeActive object:nil];
}





//显示需要升级的提示
- (void)showAlertForUpdate {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitleForUpdate
                                                                   message:alertMessageForUpdate
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleDestructive
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"前往下载"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                flagGotoAppStore = YES;
                                                NSURL *url = [NSURL URLWithString:appStore_url];
                                                [LyUtil openUrl:url];
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)lnTargetForRightBarBtnItem:(UIBarButtonItem *)bbi {
    if (loginBarButtonItemTag_close == bbi.tag) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (loginBarButtonItemTag_register == bbi.tag) {
        LyRegisterViewController *registerVc = [[LyRegisterViewController alloc] init];
        [self.navigationController pushViewController:registerVc animated:YES];
    }
}


- (void)targetForButton:(UIButton *)button {
    [self lnAllItemsResignFirstResponder];
    
    if (button == btnLogin) {
        [self login];
        
    } else if (button == btnForgot) {
        LyForgotPasswordViewController *forgotPwd = [[LyForgotPasswordViewController alloc] init];
        [forgotPwd setDelegate:self];
        [self.navigationController pushViewController:forgotPwd animated:YES];
        
    }
}




- (void)getUserAvatarAsyn:(NSString *)userId
{
    [LyImageLoader loadAvatarWithUserId:userId
                               complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSString * _Nullable userId) {
                                   if (image) {
                                       [[LyCurrentUser curUser] setUserAvatar:image];
                                       [LyUtil saveImage:image withUserId:userId withMode:LySaveImageMode_avatar];
                                   }
                               }];
}




//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self lnAllItemsResignFirstResponder];
}



- (void)lnAllItemsResignFirstResponder
{
    bFlag = YES;
    
    [tfAcc resignFirstResponder];
    [tfPwd resignFirstResponder];
}





- (BOOL)validate:(BOOL)flag {
    
    [btnLogin setEnabled:NO];
    
    if ( ![[tfAcc text] validatePhoneNumber]) {
        if (flag) {
            [tfAcc setTextColor:LyWarnColor];
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号格式错误"] show];
        }
        
        return NO;
    } else {
        [tfAcc setTextColor:LyBlackColor];
    }
    
    if ( ![[tfPwd text] validatePassword]) {
        if (flag) {
            [tfPwd setTextColor:LyWarnColor];
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"密码格式错误"] show];
        }
        
        return NO;
    } else {
        [tfPwd setTextColor:LyBlackColor];
    }
    
    [btnLogin setEnabled:YES];
    
    return YES;
}



- (void)login {
    
    if ( ![self validate:YES])
    {
        return;
    }
    
    indicator = [[LyIndicator alloc] initWithTitle:@"登录中..."];
    [self.view addSubview:indicator];
    [indicator startAnimation];
    
    
    NSString *pwd_encoded = [LyUtil encodePassword:[tfPwd text]];
    
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:loginHttpMethod_login];
    [httpRequest setDelegate:self];
    curHttpMethod = loginHttpMethod_login;
    bHttpFlag = [[httpRequest startHttpRequest:login_url
                                          body:@{
                                                 accountKey:tfAcc.text,
                                                 passowrdKey:pwd_encoded,
                                                 userTypeKey:userTypeStudentKey,
                                                 versionKey:[LyUtil getApplicationVersionNoPoint]
                                                 }
                  
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}



- (void)handleHttpFailed {
    if ([indicator isAnimating]) {
        [indicator stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"登录失败"] show];
    }
}



- (void)analysisUserInfo:(NSString *)userInfo
{
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
        case loginHttpMethod_login: {
            switch ( [strCode intValue]) {
                case 0: {
                    //成功
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (!dicResult || ![LyUtil validateDictionary:dicResult])
                    {
                        [indicator stopAnimation];
                        return;
                    }
                    
                    NSString *strVerifyState = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:verifyStateKey]];
                    if (LyVerifyState_rejected == [strVerifyState integerValue])
                    {
                        [indicator stopAnimation];
                        
                        return;
                    }
                    
                    NSString *strAccount = [tfAcc text];
                    NSString *strPassword = [tfPwd text];
                    
                    NSString *strUserId = [[dic objectForKey:resultKey] objectForKey:userIdKey];
                    NSString *strNickName = [[dic objectForKey:resultKey] objectForKey:nickNameKey];
                    NSString *strSessionId = [dic objectForKey:sessionIdKey];
                    NSString *strAddress = [[dic objectForKey:resultKey] objectForKey:addressKey];
                    
                    NSString *strDriveLicenseMode = [[dic objectForKey:resultKey] objectForKey:driveLicenseKey];
                    NSString *strSubjectMode = [[NSString alloc] initWithFormat:@"%@", [[dic objectForKey:resultKey] objectForKey:subjectModeKey]];
                    LyLicenseType license = [LyUtil driveLicenseFromString:strDriveLicenseMode];
                    license = (license > LyLicenseType_M) ? 0 : license;
                    LySubjectMode subject = [strSubjectMode integerValue];
                    subject = (subject > LySubjectMode_fourth || subject < 0) ? 0 : subject;
                    
                    
                    [[NSUserDefaults standardUserDefaults] setObject:strUserId forKey:userId517Key];
                    [[NSUserDefaults standardUserDefaults] setObject:strAccount forKey:userAccount517Key];
                    [[NSUserDefaults standardUserDefaults] setObject:strPassword forKey:userPassword517Key];
                    [[NSUserDefaults standardUserDefaults] setObject:strNickName forKey:userName517Key];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    
                    [LyUtil setHttpSessionId:strSessionId];
                    
                    
                    [[LyCurrentUser curUser] setUserId:strUserId];
                    [[LyCurrentUser curUser] setUserPhoneNum:strAccount];
                    [[LyCurrentUser curUser] setUserName:strNickName];
                    [[LyCurrentUser curUser] setUserAddress:strAddress];
                    [[LyCurrentUser curUser] setUserLicenseType:license];
                    [[LyCurrentUser curUser] setUserSubjectMode:subject];
                    
                    [[LyBottomControl sharedInstance] setLicenseInfo:license object:[strSubjectMode integerValue]];
                    
                    [self getUserAvatarAsyn:strUserId];
                    
                    [indicator stopAnimation];
                    
                    [LyUtil setAutoLoginFlag:YES];
                    
                    
                    LyRemindView *loginRemind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"登录成功"];
                    [loginRemind setDelegate:self];
                    [loginRemind show];
                    
                    break;
                }
                case 1: {
                    //无此帐号
                    [indicator stopAnimation];
                    
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"帐号不存在"] show];
                    
                    break;
                }
                case 2: {
                    //密码错误
                    [indicator stopAnimation];
                    
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"密码错误"] show];
                    break;
                }
                case 3: {
                    //帐户类型错误
                    [indicator stopAnimation];
                    
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"帐号类型错误"] show];
                    break;
                }
                case 4: {
                    //客户端版本太旧
                    [indicator stopAnimation];
                    
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
        }
    }


}



#pragma mark -LyHttpRequestDelegate
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest {
    if ( bHttpFlag) {
        bHttpFlag = NO;
        [self handleHttpFailed];
    }
    
    curHttpMethod = 0;
}

- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result
{
    if ( bHttpFlag)
    {
        bHttpFlag = NO;
        curHttpMethod = ahttpRequest.mode;
        [self analysisUserInfo:result];
    }
    
    curHttpMethod = 0;
}




#pragma mark -LyRmindViewDelegate
- (void)remindViewDidHide:(UIView *)view {
    if (_delegate && [_delegate respondsToSelector:@selector(loginDoneByLoginViewController:)]) {
        [_delegate loginDoneByLoginViewController:self];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



#pragma mark -LyForgotPasswordViewControllerDelegate
- (LyUserType)obtainUserTypeByForgotPasswordVC:(LyForgotPasswordViewController *)forgotPasswordVC {
    return LyUserType_normal;
}

- (void)resetPasswordSuccessByForgotPasswordVC:(LyForgotPasswordViewController *)forgotPasswordVC newPwd:(NSString *)newPwd {
    [forgotPasswordVC.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark -LyAppDidBecomeActive
- (void)targetForAppDidBecomeActive:(NSNotification *)notification {
    
    if (flagGotoAppStore) {
        flagGotoAppStore = NO;
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark -UITextFieldDelegate
//点击return 按钮 去掉
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (textField == tfPwd) {
        [self targetForButton:btnLogin];
    }
    return YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == tfAcc) {
        if (tfAcc.text.length > 0) {
            if ( ![tfAcc.text validatePhoneNumber]) {
                [tfAcc setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号格式错误"] show];
            } else {
                [tfAcc setTextColor:LyBlackColor];
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
    
    [self validate:NO];
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
