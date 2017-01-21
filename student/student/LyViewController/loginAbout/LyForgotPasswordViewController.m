//
//  LyForgotPasswordViewController.m
//  teacher
//
//  Created by Junes on 16/9/18.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyForgotPasswordViewController.h"

#import "LyGetAuthCodeButton.h"

#import "LyToolBar.h"
#import "LyIndicator.h"
#import "LyRemindView.h"

#import "NSString+Validate.h"

//#import "LyUtil.h"


#import "LyResetPasswordViewController.h"


enum {
    forgotPasswordBarButtonItemTag_next = 0
}LyForgotPasswordBarButtonItemTag;

typedef NS_ENUM(NSInteger, LyForgotPasswordTextFieldTag) {
    forgotPasswordTextFieldTag_account = 10,
    forgotPasswordTextFieldTag_authCode
};


typedef NS_ENUM(NSInteger, LyForgotPasswordHttpMethod) {
    forgotPasswordHttpMethod_auth = 100,
};


@interface LyForgotPasswordViewController () <UITextFieldDelegate, LyGetAuthCodeButtonDelegate, LyRemindViewDelegate, LyHttpRequestDelegate, LyResetPasswordViewControllerDelegate>
{
    UIBarButtonItem             *bbiNext;
    
    UITextField                 *tfAccount;
    UITextField                 *tfAuthCode;
    LyGetAuthCodeButton         *btnGetAuthCode;
    
    
    LyIndicator                 *indicator_auth;
    BOOL                        bHttpFlag;
    LyForgotPasswordHttpMethod  curHttpMethod;
}
@end

@implementation LyForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}


- (void)viewWillAppear:(BOOL)animated {
    [self addObserverForNotificationFromUITextFieldTextDidChangeNotification];
    
    _userType = [_delegate obtainUserTypeByForgotPasswordVC:self];
    
    if (tfAccount.text.length < 1) {
        NSString *strAccount = [[NSUserDefaults standardUserDefaults] objectForKey:userAccount517Key];
        if (strAccount) {
            [tfAccount setText:strAccount];
        }
    }
    
    [self validate:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeObserverForNotificationFromUITextFieldTextDidChangeNotification];
}


- (void)initSubviews {
    [self setTitle:@"忘记密码"];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    //navigationBar
    bbiNext = [[UIBarButtonItem alloc] initWithTitle:@"下一步"
                                               style:UIBarButtonItemStyleDone
                                              target:self
                                              action:@selector(targetForBarButtonItem:)];
    [bbiNext setTag:forgotPasswordBarButtonItemTag_next];
    [self.navigationItem setRightBarButtonItem:bbiNext];
    
    
    //验证-帐号
    //验证-帐号-输入框
    tfAccount = [[UITextField alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT+30.0f, SCREEN_WIDTH, LyViewItemHeight)];
    [tfAccount setBackgroundColor:[UIColor whiteColor]];
    [tfAccount setTag:forgotPasswordTextFieldTag_account];
    [tfAccount setDelegate:self];
    [tfAccount setFont:LyFont(14)];
    [tfAccount setTextColor:LyBlackColor];
    [tfAccount setPlaceholder:@"在这里输入手机号"];
    [tfAccount setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfAccount setKeyboardType:UIKeyboardTypePhonePad];
    [tfAccount setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfAccount]];
    [tfAccount setLeftView:({
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, LyLbTitleItemWidth, LyViewItemHeight)];
        [lbTitle setFont:LyFont(16)];
        [lbTitle setTextColor:[UIColor blackColor]];
        [lbTitle setTextAlignment:NSTextAlignmentCenter];
        [lbTitle setText:@"+86"];
        lbTitle;
    })];
    [tfAccount setLeftViewMode:UITextFieldViewModeAlways];
    
    
    
    //验证-验证码
    UIView *viewAuthCode = [[UIView alloc] initWithFrame:CGRectMake(0, tfAccount.frame.origin.y+CGRectGetHeight(tfAccount.frame)+verticalSpace, SCREEN_WIDTH, LyViewItemHeight)];
    [viewAuthCode setBackgroundColor:[UIColor whiteColor]];
    
    tfAuthCode = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-btnGetAuthCodeWidth-horizontalSpace-verticalSpace, LyViewItemHeight)];
    [tfAuthCode setTag:forgotPasswordTextFieldTag_authCode];
    [tfAuthCode setDelegate:self];
    [tfAuthCode setFont:LyFont(14)];
    [tfAuthCode setTextColor:LyBlackColor];
    [tfAuthCode setPlaceholder:@"在这里输入验证码"];
    [tfAuthCode setKeyboardType:UIKeyboardTypeNumberPad];
    [tfAuthCode setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfAuthCode]];
    
    [tfAuthCode setLeftView:({
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LyLbTitleItemWidth, LyViewItemHeight)];
        [lbTitle setFont:LyFont(16)];
        [lbTitle setTextColor:[UIColor blackColor]];
        [lbTitle setTextAlignment:NSTextAlignmentCenter];
        [lbTitle setText:@"验证码"];
        lbTitle;
    })];
    [tfAuthCode setLeftViewMode:UITextFieldViewModeAlways];
    [tfAuthCode setClearButtonMode:UITextFieldViewModeAlways];
    
    btnGetAuthCode = [[LyGetAuthCodeButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-verticalSpace-btnGetAuthCodeWidth, LyViewItemHeight/2.0f-btnGetAuthCodeHeight/2.0f, btnGetAuthCodeWidth, btnGetAuthCodeHeight)];
    [btnGetAuthCode setDelegate:self];
    
    [viewAuthCode addSubview:tfAuthCode];
    [viewAuthCode addSubview:btnGetAuthCode];
    
    
    [self.view addSubview:tfAccount];
    [self.view addSubview:viewAuthCode];
    
    
    [bbiNext setEnabled:NO];
    [btnGetAuthCode setEnabled:NO];
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



- (BOOL)validate:(BOOL)flag {
    [bbiNext setEnabled:NO];
    [btnGetAuthCode setEnabled:NO];
    
    if (![tfAccount.text validatePhoneNumber]) {
        if (flag) {
            [tfAccount setTextColor:LyWarnColor];
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"手机号格式错误"] show];
        }
        [btnGetAuthCode setEnabled:NO];
        
        return NO;
    } else {
        [tfAccount setTextColor:LyBlackColor];
    }
    
    if (btnGetAuthCode.curTime < 1) {
        [btnGetAuthCode setEnabled:YES];
    }
    
    if (![tfAuthCode.text validateAuthCode]) {
        if (flag) {
            [tfAuthCode setTextColor:LyWarnColor];
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"验证码格式错误"] show];
        }
        return NO;
    } else {
        [tfAuthCode setTextColor:LyBlackColor];
    }
    
    if (!btnGetAuthCode.time) {
        return NO;
    }
    
    [bbiNext setEnabled:YES];
    
    return YES;
}


- (void)allControlResignFirstResponder {
    [tfAccount resignFirstResponder];
    [tfAuthCode resignFirstResponder];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self allControlResignFirstResponder];
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    [self allControlResignFirstResponder];
    
    [NSThread sleepForTimeInterval:0.1f];
    
    if (forgotPasswordBarButtonItemTag_next == bbi.tag) {
        [self authCode];
    }
}


- (void)authCode {
    if (!indicator_auth) {
        indicator_auth = [LyIndicator indicatorWithTitle:@"正在验证"];
    }
    [indicator_auth startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:forgotPasswordHttpMethod_auth];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:checkAuchCode_url
                                 body:@{
                                        phoneKey:tfAccount.text,
                                        authKey:tfAuthCode.text,
                                        timeKey:btnGetAuthCode.time,
//                                        trueAuthKey:btnGetAuthCode.trueAuthCode,
                                       }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)handleHttpFailed {
    if ([indicator_auth isAnimating]) {
        [indicator_auth stopAnimation];
        
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证失败"] show];
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
    
    if (codeTimeOut == [strCode integerValue]) {
        [indicator_auth stopAnimation];
        
        [LyUtil sessionTimeOut:self];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_auth stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    
    switch (curHttpMethod) {
        case forgotPasswordHttpMethod_auth: {
            switch ([strCode integerValue]) {
                case 0: {
                    [indicator_auth stopAnimation];
                    
                    LyResetPasswordViewController *resetPwd = [[LyResetPasswordViewController alloc] init];
                    [resetPwd setDelegate:self];
                    [self.navigationController pushViewController:resetPwd animated:YES];
                    break;
                }
                case 1: {
                    [indicator_auth stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码超时"] show];
                }
                case 2: {
                    [indicator_auth stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码错误"] show];
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


#pragma mark -LyHttpReqeustDelegate
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


#pragma mark -LyResetPasswordViewControllerDelegate
- (NSDictionary *)obtainAccountInfoByResetPasswordVC:(LyResetPasswordViewController *)resetPasswordVC {
    return @{
             phoneKey:tfAccount.text,
             userTypeKey:@(_userType)
             };
}


- (void)resetPasswordSuccessByResetPasswordVC:(LyResetPasswordViewController *)resetPasswordVC newPwd:(NSString *)newPwd {
    [_delegate resetPasswordSuccessByForgotPasswordVC:self newPwd:newPwd];
}


#pragma mark -LyGetAuthCodeButtonDelegate
- (NSString *)obtainPhoneNum:(LyGetAuthCodeButton *)button {
    return tfAccount.text;
}



#pragma mark -UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    LyForgotPasswordTextFieldTag tfTag = textField.tag;
    switch (tfTag) {
        case forgotPasswordTextFieldTag_account: {
            if (tfAccount.text.length > 0) {
                if (![tfAccount.text validatePhoneNumber]) {
                    [tfAccount setTextColor:LyWarnColor];
                    [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"手机号格式错误"] show];
                } else {
                    [tfAccount setTextColor:LyBlackColor];
                }
            }
            break;
        }
        case forgotPasswordTextFieldTag_authCode: {
            if (tfAuthCode.text.length > 0) {
                if (![tfAuthCode.text validateAuthCode]) {
                    [tfAuthCode setTextColor:LyWarnColor];
                    [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"验证码格式错误"] show];
                } else {
                    [tfAuthCode setTextColor:LyBlackColor];
                }
            }
            break;
        }
    }
    
    
    
    [self validate:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (forgotPasswordTextFieldTag_account == textField.tag) {
        [tfAccount resignFirstResponder];
        [tfAuthCode becomeFirstResponder];
    } else if (forgotPasswordTextFieldTag_authCode == textField.tag) {
        [tfAuthCode resignFirstResponder];
    }
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    LyForgotPasswordTextFieldTag tfTag = textField.tag;
    switch (tfTag) {
        case forgotPasswordTextFieldTag_account: {
            if (textField.text.length + string.length > LyAccountLength) {
                return NO;
            }
            break;
        }
        case forgotPasswordTextFieldTag_authCode: {
            if (textField.text.length + string.length > LyPasswordLengthMax) {
                return NO;
            }
            break;
        }
    }
    
    return YES;
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
