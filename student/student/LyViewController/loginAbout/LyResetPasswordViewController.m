//
//  LyResetPasswordViewController.m
//  teacher
//
//  Created by Junes on 16/9/18.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyResetPasswordViewController.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "NSString+Validate.h"

//#import "LyUtil.h"



enum {
    resetPasswordTextFieldTag_newPwd = 10,
}LyResetPasswordTextFieldTag;

enum {
    resetPasswordButtonTag_visiable = 20,
    resetPasswordButtonTag_reset,
}LyResetPasswordButtonTag;

typedef NS_ENUM(NSInteger, LyResetPasswordHttpMethod) {
    resetPasswordHttpMethod_reset = 100,
};


@interface LyResetPasswordViewController () <UITextFieldDelegate, LyRemindViewDelegate, LyHttpRequestDelegate>
{
    UILabel                     *lbCurAcc;
    UITextField                 *tfNewPwd;
    UIButton                    *btnVisiable;
    UIButton                    *btnReset;
    
    
    LyIndicator                 *indicator_reset;
    BOOL                        bHttpFlag;
    LyResetPasswordHttpMethod   curHttpMethod;
}
@end

@implementation LyResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}


- (void)viewWillAppear:(BOOL)animated {
    [self addObserverForNotificationFromUITextFieldTextDidChangeNotification];
    
    
    NSDictionary *dic = [_delegate obtainAccountInfoByResetPasswordVC:self];
    
    if (!dic) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    NSString *acc = [dic objectForKey:phoneKey];
    if (!acc) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    _userType = [[dic objectForKey:userTypeKey] integerValue];
    
    [self setCurAcc:acc];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeObserverForNotificationFromUITextFieldTextDidChangeNotification];
}

- (void)initSubviews {
    self.title = @"重设密码";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    lbCurAcc = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT+10.0f, SCREEN_WIDTH-horizontalSpace*2, 30.0f)];
    [lbCurAcc setFont:LyFont(14)];
    [lbCurAcc setTextColor:[UIColor darkGrayColor]];
    [lbCurAcc setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:lbCurAcc];
    
    
    //新密码
    UIView *viewNewsPwd = [[UIView alloc] initWithFrame:CGRectMake(0, lbCurAcc.frame.origin.y + CGRectGetHeight(lbCurAcc.frame) + 10.0f, SCREEN_WIDTH, LyViewItemHeight)];
    [viewNewsPwd setBackgroundColor:[UIColor whiteColor]];
    //新密码-输入框
    tfNewPwd = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - LyViewItemHeight, LyViewItemHeight)];
    [tfNewPwd setBackgroundColor:[UIColor whiteColor]];
    [tfNewPwd setTag:resetPasswordTextFieldTag_newPwd];
    [tfNewPwd setFont:LyFont(14)];
    [tfNewPwd setTextColor:LyBlackColor];
    [tfNewPwd setKeyboardType:UIKeyboardTypeASCIICapable];
    [tfNewPwd setSecureTextEntry:YES];
    [tfNewPwd setPlaceholder:@"在这里输入新密码"];
    [tfNewPwd setDelegate:self];
    
    [tfNewPwd setLeftView:({
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LyLbTitleItemWidth, LyViewItemHeight)];
        [lbTitle setFont:LyLbTitleItemFont];
        [lbTitle setTextColor:[UIColor blackColor]];
        [lbTitle setTextAlignment:NSTextAlignmentCenter];
        [lbTitle setText:@"新密码"];
        lbTitle;
    })];
    [tfNewPwd setLeftViewMode:UITextFieldViewModeAlways];
    [tfNewPwd setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    btnVisiable = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-LyViewItemHeight, 0, LyViewItemHeight, LyViewItemHeight)];
    [btnVisiable setTag:resetPasswordButtonTag_visiable];
    [btnVisiable setImage:[LyUtil imageForImageName:@"pwdVisiable_n" needCache:NO] forState:UIControlStateNormal];
    [btnVisiable setImage:[LyUtil imageForImageName:@"pwdVisiable_h" needCache:NO] forState:UIControlStateSelected];
    [btnVisiable addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewNewsPwd addSubview:tfNewPwd];
    [viewNewsPwd addSubview:btnVisiable];
    
    
    
    //密码格式提示
    UILabel *lbPsdRemind = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, viewNewsPwd.frame.origin.y+CGRectGetHeight(viewNewsPwd.frame)+verticalSpace, (SCREEN_WIDTH-horizontalSpace*2), 40.0f)];
    [lbPsdRemind setFont:LyFont(12)];
    [lbPsdRemind setTextColor:Ly517ThemeColor];
    [lbPsdRemind setNumberOfLines:0];
    [lbPsdRemind setTextAlignment:NSTextAlignmentLeft];
    [lbPsdRemind setText:@"*密码需在6~18位之间\n*密码至少由字母和数字组成（可以输入特殊字符）"];
    
    
    
    
    btnReset = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4.0f, lbPsdRemind.frame.origin.y+CGRectGetHeight(lbPsdRemind.frame)+50.0f, SCREEN_WIDTH/2.0f, 40.0f)];
    [btnReset setTag:resetPasswordButtonTag_reset];
    [btnReset setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btnReset setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnReset setTitle:@"重设密码" forState:UIControlStateNormal];
    [btnReset addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:viewNewsPwd];
    [self.view addSubview:lbPsdRemind];
    [self.view addSubview:btnReset];
    
    
    [btnReset setEnabled:NO];
}



- (void)setCurAcc:(NSString *)curAcc {
    _curAcc = curAcc;
    
    [lbCurAcc setText:[[NSString alloc] initWithFormat:@"当前手机号为：%@", [LyUtil hidePhoneNumber:_curAcc]]];
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



- (void)allControlResignFirstResponder {
    [tfNewPwd resignFirstResponder];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self allControlResignFirstResponder];
}



- (void)targetForButton:(UIButton *)btn {
    [self allControlResignFirstResponder];
    
    if (resetPasswordButtonTag_visiable == btn.tag) {
        [btn setSelected:!btn.isSelected];
        
        [tfNewPwd setSecureTextEntry:!btn.isSelected];
    } else if (resetPasswordButtonTag_reset == btn.tag) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认密码"
                                                                       message:[[NSString alloc] initWithFormat:@"确定重设密码为「%@」", tfNewPwd.text]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"重设"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    [self resetPassword];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}


- (BOOL)validate:(BOOL)flag {
    
    [btnReset setEnabled:NO];
    
    if (![tfNewPwd.text validatePassword]) {
        if (flag) {
            [tfNewPwd setTextColor:LyWarnColor];
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"新密码格式不正确"] show];
        }
        return NO;
    } else {
        [tfNewPwd setTextColor:LyBlackColor];
    }
    
    [btnReset setEnabled:YES];
    
    return YES;
}


- (void)resetPassword {
    if (!indicator_reset) {
        indicator_reset = [LyIndicator indicatorWithTitle:@"正在重设密码"];
    }
    [indicator_reset startAnimation];
    
    NSString *newPwd_encode = [LyUtil encodePassword:tfNewPwd.text];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:resetPasswordHttpMethod_reset];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:resetPassword_url
                                 body:@{
                                       phoneKey:_curAcc,
                                       accountKey:_curAcc,
                                       newPasswordKey:newPwd_encode,
                                       userTypeKey:[LyUtil userTypeStringFrom:_userType]
                                       }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)handleHttpFailed {
    if ([indicator_reset isAnimating]) {
        [indicator_reset stopAnimation];
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
        [indicator_reset stopAnimation];
        
        [LyUtil sessionTimeOut:self];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_reset stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch (curHttpMethod) {
        case resetPasswordHttpMethod_reset: {
            switch ([strCode integerValue]) {
                case 0: {
                    [indicator_reset stopAnimation];
                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"重设成功，请重新登录"];
                    [remind setDelegate:self];
                    [remind show];
                    break;
                }
                case 1: {
                    [indicator_reset stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"新密码不能与旧密码一致"] show];
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



#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(LyRemindView *)aRemind {
    [_delegate resetPasswordSuccessByResetPasswordVC:self newPwd:tfNewPwd.text];
}


#pragma mark -UITextFieldDelegate 
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (resetPasswordTextFieldTag_newPwd == textField.tag) {
        [textField resignFirstResponder];
        return YES;
    }
        
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (resetPasswordTextFieldTag_newPwd == textField.tag) {
        if (textField.text.length + string.length > LyPasswordLengthMax) {
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (resetPasswordTextFieldTag_newPwd == textField.tag) {
        if (textField.text.length > 0) {
            if ([textField.text validatePassword]) {
                [textField setTextColor:LyBlackColor];
            } else {
                [textField setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"新密码格式不正确"] show];
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
