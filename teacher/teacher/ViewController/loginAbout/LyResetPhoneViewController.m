//
//  LyResetPhoneViewController.m
//  teacher
//
//  Created by Junes on 2016/9/29.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyResetPhoneViewController.h"
#import "LyGetAuthCodeButton.h"

#import "LyIndicator.h"
#import "LyRemindView.h"
#import "LyToolBar.h"

#import "LyCurrentUser.h"

#import "NSString+Validate.h"

#import "LyUtil.h"


#define rpBtnResetWidth             (SCREEN_WIDTH*4/5.0f)
CGFloat const rpBtnResetHeight = 50.0f;


enum {
    resetPhoneTextFieldTag_phone = 10,
    resetPhoneTextFieldTag_authCode,
}LyResetPhoneTextFieldTag;

enum {
    resetPhoneButtonTag_reset = 20,
}LyResetPhoneButtonTag;

typedef NS_ENUM(NSInteger, LyResetPhoneHttpMethod) {
    resetPhoneHttpMethod_reset = 100,
};


@interface LyResetPhoneViewController () <UITextFieldDelegate, LyHttpRequestDelegate, LyGetAuthCodeButtonDelegate>
{
    UITextField             *tfPhone;
    UITextField             *tfAuthCode;
    LyGetAuthCodeButton     *btnGetAuthCode;
    
    UIButton                *btnReset;
    
    LyIndicator             *indicator;
    BOOL                    bHttpFlag;
    LyResetPhoneHttpMethod curHttpMethod;
}
@end

@implementation LyResetPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [self addObserverForNotificationFromUITextFieldTextDidChangeNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeObserverForNotificationFromUITextFieldTextDidChangeNotification];
}


- (void)initAndLayoutSubviews {
    
    self.title = @"修改手机号";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    UILabel *lbRemind = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, LyViewItemHeight)];
    [lbRemind setBackgroundColor:LyWhiteLightgrayColor];
    [lbRemind setFont:LyFont(14)];
    [lbRemind setTextColor:Ly517ThemeColor];
    [lbRemind setTextAlignment:NSTextAlignmentCenter];
    [lbRemind setText:@"特别提醒：修改后只能用新手机号登录"];
    [lbRemind setNumberOfLines:0];
    
    tfPhone = [[UITextField alloc] initWithFrame:CGRectMake(0, lbRemind.ly_y+CGRectGetHeight(lbRemind.frame), SCREEN_WIDTH, LyViewItemHeight)];
    [tfPhone setTag:resetPhoneTextFieldTag_phone];
    [tfPhone setFont:LyFont(16)];
    [tfPhone setBackgroundColor:[UIColor whiteColor]];
    [tfPhone setTextColor:[UIColor blackColor]];
    [tfPhone setTextAlignment:NSTextAlignmentCenter];
    [tfPhone setDelegate:self];
    [tfPhone setPlaceholder:@"新手机号"];
    [tfPhone setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfPhone setKeyboardType:UIKeyboardTypePhonePad];
    [tfPhone setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfPhone]];
    
    
    UIView *viewAuthCode = [[UIView alloc] initWithFrame:CGRectMake(0, tfPhone.ly_y+CGRectGetHeight(tfPhone.frame)+verticalSpace, SCREEN_WIDTH, LyViewItemHeight)];
    [viewAuthCode setBackgroundColor:[UIColor whiteColor]];
    
    tfAuthCode = [[UITextField alloc] initWithFrame:CGRectMake(btnGetAuthCodeWidth, 0, SCREEN_WIDTH-btnGetAuthCodeWidth*2, LyViewItemHeight)];
    [tfAuthCode setTag:resetPhoneTextFieldTag_authCode];
    [tfAuthCode setFont:LyFont(16)];
    [tfAuthCode setTextColor:[UIColor blackColor]];
    [tfAuthCode setTextAlignment:NSTextAlignmentCenter];
    [tfAuthCode setDelegate:self];
    [tfAuthCode setPlaceholder:@"验证码"];
    [tfAuthCode setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfAuthCode setKeyboardType:UIKeyboardTypeNumberPad];
    [tfAuthCode setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfAuthCode]];
    [tfAuthCode setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    
    btnGetAuthCode = [[LyGetAuthCodeButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-btnGetAuthCodeWidth-verticalSpace, LyViewItemHeight/2.0f-btnGetAuthCodeHeight/2.0f, btnGetAuthCodeWidth, btnGetAuthCodeHeight)];
    [btnGetAuthCode setDelegate:self];
    
    [viewAuthCode addSubview:tfAuthCode];
    [viewAuthCode addSubview:btnGetAuthCode];
    
    
    //登录
    btnReset = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f-rpBtnResetWidth/2.0f, viewAuthCode.ly_y+CGRectGetHeight(viewAuthCode.frame)+20.0f, rpBtnResetWidth, rpBtnResetHeight)];
    [btnReset setTag:resetPhoneButtonTag_reset];
    [btnReset setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnReset setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btnReset setTitle:@"重设手机号" forState:UIControlStateNormal];;
    [btnReset setBackgroundColor:LyWhiteLightgrayColor];
    [[btnReset layer] setCornerRadius:btnCornerRadius];
    [btnReset addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:lbRemind];
    [self.view addSubview:tfPhone];
    [self.view addSubview:viewAuthCode];
    [self.view addSubview:btnReset];
    
    
    [btnReset setEnabled:NO];
    [btnGetAuthCode setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)validate:(BOOL)flag {
    
    [btnReset setEnabled:NO];
    
    if (![tfPhone.text validatePhoneNumber]) {
        if (flag) {
            [tfPhone setTextColor:LyWarnColor];
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"手机号格试错误"] show];
        }
        [btnGetAuthCode setEnabled:NO];
        
        return NO;
    } else {
        [tfPhone setTextColor:[UIColor blackColor]];
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
        [tfAuthCode setTextColor:[UIColor blackColor]];
    }
    
    [btnReset setEnabled:YES];
    
    return YES;
}


- (void)allControlResignFirstResponder {
    [tfPhone resignFirstResponder];
    [tfAuthCode resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self allControlResignFirstResponder];
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



- (void)targetForButton:(UIButton *)button {
    if (resetPhoneButtonTag_reset == button.tag) {
        [self reset];
    }
}


- (void)reset {
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:LyIndicatorTitle_modify];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:resetPhoneHttpMethod_reset];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:modifyUserInfo_url
                                 body:@{
                                        userIdKey:[LyCurrentUser curUser].userId,
                                        phoneKey:tfPhone.text,
                                        authKey:tfAuthCode.text,
                                        timeKey:btnGetAuthCode.time,
//                                        trueAuthKey:btnGetAuthCode.trueAuthCode,
                                        sessionIdKey:[LyUtil httpSessionId],
                                        userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                       }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}

- (void)handleHttpFailed {
    if ([indicator isAnimating]) {
        [indicator stopAnimation];
        [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"重设失败"];
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
        [indicator stopAnimation];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch (curHttpMethod) {
        case resetPhoneHttpMethod_reset: {
            switch ([strCode integerValue]) {
                case 0: {
                    [indicator stopAnimation];
                    
                    [[LyCurrentUser curUser] setUserPhoneNum:tfPhone.text];
                    [[NSUserDefaults standardUserDefaults] setObject:tfPhone.text forKey:userAccount517Key_tc];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:LyNotificationForLogout object:[[LyCurrentUser curUser] userTypeByString]];
                    
                    break;
                }
                case 1: {
                    [indicator stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码超时"] show];
                    break;
                }
                case 2: {
                    [indicator stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证码错误"] show];
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


#pragma mark -LyGetAuthCodeButtonDelegate
- (NSString *)obtainPhoneNum:(LyGetAuthCodeButton *)button {
    if ([tfPhone.text validatePhoneNumber]) {
        return tfPhone.text;
    } else {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号格式错误"] show];
        return @"";
    }
}




#pragma mark -UITextFeildDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (resetPhoneTextFieldTag_phone == textField.tag) {
        if (tfPhone.text.length + string.length > LyAccountLength) {
            return NO;
        }
    } else if (resetPhoneTextFieldTag_authCode == textField.tag) {
        if (tfAuthCode.text.length + string.length > LyAuthCodeLength) {
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (resetPhoneTextFieldTag_phone == textField.tag) {
        if (tfPhone.text.length > 0) {
            if ([tfPhone.text validatePhoneNumber]) {
                [tfPhone setTextColor:[UIColor blackColor]];
            } else {
                [tfPhone setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"手机号格式错误"] show];
            }
        }
        
    } else if (resetPhoneTextFieldTag_authCode == textField.tag) {
        if (tfAuthCode.text.length > 0) {
            if ([tfAuthCode.text validateAuthCode]) {
                [tfAuthCode setTextColor:[UIColor blackColor]];
            } else {
                [tfAuthCode setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"验证码格式错误"] show];
            }
        }
        
    }
}


#pragma mark -UITextFieldTextDidChangeNotification
- (void)targetForNotificationFormUITextFieldTextDidChangeNotification:(NSNotification *)notifi {
    if ([notifi.object isKindOfClass:[UITextField class]]) {
        [self validate:NO];
    }
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
