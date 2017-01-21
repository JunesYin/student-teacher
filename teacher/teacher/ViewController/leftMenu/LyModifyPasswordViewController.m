//
//  LyModifyPasswordViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/10.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyModifyPasswordViewController.h"

#import "LyCurrentUser.h"
#import "LyIndicator.h"
#import "LyRemindView.h"

#import "NSString+Validate.h"
#import "LyMacro.h"
#import "LyUtil.h"


#import "LyForgotPasswordViewController.h"




//CGFloat const mpwdfItemHeight = 50.0f;

#define btnModifyWidth                  (SCREEN_WIDTH/2.0f)
CGFloat const btnModifyHeight = 40.0f;


CGFloat const mpBtnForgotWidth = 90.0f;
CGFloat const mpBtnForgotHeight = 30.0f;




typedef NS_ENUM( NSInteger, LyModifyPasswordTextFieldMode)
{
    modifyPasswordTextFieldMode_oldPwd = 10,
    modifyPasswordTextFieldMode_newPwd,
};



typedef NS_ENUM( NSInteger, LyModifyPasswordButtonItemMode)
{
    modifyPasswordButtonItemMode_visiableOld = 20,
    modifyPasswordButtonItemMode_visiableNew,
    modifyPasswordButtonItemMode_modify,
    modifyPasswordButtonItemMode_forgot
};



typedef NS_ENUM( NSInteger, LyModifyPasswordHttpMethod)
{
    modifyPasswordHttpMethod_modify = 42
};



@interface LyModifyPasswordViewController () <UITextFieldDelegate, LyHttpRequestDelegate, LyRemindViewDelegate, LyForgotPasswordViewControllerDelegate> {
    
    UITextField                 *tfOldPwd;
    UIButton                    *btnVisiableOld;
    
    UITextField                 *tfNewPwd;
    UIButton                    *btnVisiableNew;
    
    UIButton                    *btnModify;
    UIButton                    *btnForgot;
    
    
    LyIndicator                 *indicator;
    
    
    BOOL                        bHttpFlag;
    LyModifyPasswordHttpMethod  curHttpMethod;
}
@end

@implementation LyModifyPasswordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubview];
}



- (void)viewWillAppear:(BOOL)animated {
    [self addObserverForNotificationFromUITextFieldTextDidChangeNotification];
}



- (void)viewWillDisappear:(BOOL)animated {
    [self removeObserverForNotificationFromUITextFieldTextDidChangeNotification];
}



- (void)initAndLayoutSubview
{
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.title = @"修改密码";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    //原密码
    UIView *viewOldPwd = [[UIView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT + 30.0f, SCREEN_WIDTH, LyViewItemHeight)];
    [viewOldPwd setBackgroundColor:[UIColor whiteColor]];
    //原密码-输入框
    tfOldPwd = [[UITextField alloc] initWithFrame:CGRectMake(LyViewItemHeight, 0, SCREEN_WIDTH-LyViewItemHeight * 2, LyViewItemHeight)];
    [tfOldPwd setTag:modifyPasswordTextFieldMode_oldPwd];
    [tfOldPwd setSecureTextEntry:YES];
    [tfOldPwd setKeyboardType:UIKeyboardTypeASCIICapable];
    [tfOldPwd setTextColor:[UIColor blackColor]];
    [tfOldPwd setFont:LyFont(16)];
    [tfOldPwd setTextAlignment:NSTextAlignmentCenter];
//    [tfOldPwd setBackgroundColor:[UIColor whiteColor]];
    [tfOldPwd setPlaceholder:@"原密码"];
    [tfOldPwd setReturnKeyType:UIReturnKeyDone];
    [tfOldPwd setDelegate:self];

    [tfOldPwd setClearButtonMode:UITextFieldViewModeWhileEditing];
    //原密码-可视按钮
    btnVisiableOld = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-LyViewItemHeight, 0, LyViewItemHeight, LyViewItemHeight)];
    [btnVisiableOld setTag:modifyPasswordButtonItemMode_visiableOld];
    [btnVisiableOld setImage:[LyUtil imageForImageName:@"pwdVisiable_n" needCache:NO] forState:UIControlStateNormal];
    [btnVisiableOld setImage:[LyUtil imageForImageName:@"pwdVisiable_h" needCache:NO] forState:UIControlStateSelected];
    [btnVisiableOld addTarget:self action:@selector(mpwdTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];

    [viewOldPwd addSubview:tfOldPwd];
    [viewOldPwd addSubview:btnVisiableOld];
    
    
    
    //新密码
    UIView *viewNewPwd = [[UIView alloc] initWithFrame:CGRectMake(0, viewOldPwd.ly_y + CGRectGetHeight(viewOldPwd.frame)+verticalSpace, SCREEN_WIDTH, LyViewItemHeight)];
    [viewNewPwd setBackgroundColor:[UIColor whiteColor]];
    //新密码-输入框
    tfNewPwd = [[UITextField alloc] initWithFrame:CGRectMake(LyViewItemHeight, 0, SCREEN_WIDTH - LyViewItemHeight * 2, LyViewItemHeight)];
    [tfNewPwd setTag:modifyPasswordTextFieldMode_newPwd];
    [tfNewPwd setSecureTextEntry:YES];
    [tfNewPwd setKeyboardType:UIKeyboardTypeASCIICapable];
    [tfNewPwd setTextColor:[UIColor blackColor]];
    [tfNewPwd setFont:LyFont(16)];
    [tfNewPwd setTextAlignment:NSTextAlignmentCenter];
    [tfNewPwd setBackgroundColor:[UIColor whiteColor]];
    [tfNewPwd setPlaceholder:@"新密码"];
    [tfNewPwd setReturnKeyType:UIReturnKeyDone];
    [tfNewPwd setDelegate:self];
    
    [tfNewPwd setClearButtonMode:UITextFieldViewModeWhileEditing];
    //新密码-可视按钮
    btnVisiableNew = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-LyViewItemHeight, 0, LyViewItemHeight, LyViewItemHeight)];
    [btnVisiableNew setTag:modifyPasswordButtonItemMode_visiableNew];
    [btnVisiableNew setImage:[LyUtil imageForImageName:@"pwdVisiable_n" needCache:NO] forState:UIControlStateNormal];
    [btnVisiableNew setImage:[LyUtil imageForImageName:@"pwdVisiable_h" needCache:NO] forState:UIControlStateSelected];
    [btnVisiableNew addTarget:self action:@selector(mpwdTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
   
    [viewNewPwd addSubview:tfNewPwd];
    [viewNewPwd addSubview:btnVisiableNew];
    
    
    //修改按钮
    btnModify = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH/2.0f-btnModifyWidth/2.0f, viewNewPwd.ly_y+CGRectGetHeight(viewNewPwd.frame)+verticalSpace*3.0f, btnModifyWidth, btnModifyHeight)];
    [btnModify setTitle:@"修改密码" forState:UIControlStateNormal];
    [btnModify setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnModify setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btnModify setBackgroundColor:LyWhiteLightgrayColor];
    [[btnModify layer] setCornerRadius:5.0f];
    [btnModify setTag:modifyPasswordButtonItemMode_modify];
    [btnModify addTarget:self action:@selector(mpwdTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    btnForgot = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH-mpBtnForgotWidth, SCREEN_HEIGHT-verticalSpace-mpBtnForgotHeight, mpBtnForgotWidth, mpBtnForgotHeight)];
    [btnForgot setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [[btnForgot titleLabel] setFont:LyFont(12)];
    [btnForgot setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnForgot setTag:modifyPasswordButtonItemMode_forgot];
    [btnForgot addTarget:self action:@selector(mpwdTargetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:viewOldPwd];
    [self.view addSubview:viewNewPwd];
    [self.view addSubview:btnModify];
    [self.view addSubview:btnForgot];
    
    
    [btnModify setEnabled:NO];
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


- (void)mpwdTargetForButtonItem:(UIButton *)button {

    [self mpAllItemsResignFirstResponder];
    
    if (modifyPasswordButtonItemMode_visiableOld == button.tag) {
        
        [btnVisiableOld setSelected:!btnVisiableOld.isSelected];
        [tfOldPwd setSecureTextEntry:!btnVisiableOld.isSelected];
        
    } else if (modifyPasswordButtonItemMode_visiableNew == button.tag) {
        
        [btnVisiableNew setSelected:!btnVisiableNew.isSelected];
        [tfNewPwd setSecureTextEntry:!btnVisiableNew.isSelected];
        
    } else if (modifyPasswordButtonItemMode_modify == button.tag) {
      
        [self modify];
        
    } else if (modifyPasswordButtonItemMode_forgot == button.tag) {
        
        LyForgotPasswordViewController *forgot = [[LyForgotPasswordViewController alloc] init];
        [forgot setDelegate:self];
        [self.navigationController pushViewController:forgot animated:YES];
    }
}




- (void)mpAllItemsResignFirstResponder
{
    [tfOldPwd resignFirstResponder];
    [tfNewPwd resignFirstResponder];
}



//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self mpAllItemsResignFirstResponder];
}





- (BOOL)validate:(BOOL)flag {
    
    [btnModify setEnabled:NO];
    
    if (![tfOldPwd.text validatePassword]) {
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"新密码格式错误"] show];
            [tfOldPwd setTextColor:LyWarnColor];
        }
        return NO;
    } else {
        [tfOldPwd setTextColor:[UIColor blackColor]];
    }
    
    
    if ( ![tfNewPwd.text validatePassword]) {
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"新密码格式错误"] show];
            [tfNewPwd setTextColor:LyWarnColor];
        }
        return NO;
    } else {
        [tfNewPwd setTextColor:[UIColor blackColor]];
    }
    
    [btnModify setEnabled:YES];
    
    return YES;
}



- (void)modify {
    
    if ( ![self validate:YES]) {
        return;
    }
    
    if ( !indicator) {
        indicator = [[LyIndicator alloc] initWithTitle:@"修改密码..."];
    }
    [self.view addSubview:indicator];
    [indicator startAnimation];
    
    
    
    NSString *strOldPassword_encode = [LyUtil encodePassword:[tfOldPwd text]];
    NSString *strNewPassword_encode = [LyUtil encodePassword:[tfNewPwd text]];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:modifyPasswordHttpMethod_modify];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:modifyPassword_url
                                          body:@{
                                                 userIdKey:[LyCurrentUser curUser].userId,
                                                 accountKey:[[LyCurrentUser curUser] userPhoneNum],
                                                 passowrdKey:strOldPassword_encode,
                                                 newPasswordKey:strNewPassword_encode,
                                                 sessionIdKey:[LyUtil httpSessionId],
                                                 userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}



- (void)handleHttpFailed {
    if ( [indicator isAnimating]) {
        [indicator stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"修改失败"] show];
    }
    
}


- (void)analysisHttpResult:(NSString *)result {
    NSDictionary *dic = [LyUtil getObjFromJson:(NSString *)result];
    
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
    
    switch ( curHttpMethod)
    {
        case modifyPasswordHttpMethod_modify:
        {
            curHttpMethod = 0;
            
            switch ( [strCode integerValue]) {
                case 0: {
                    [indicator stopAnimation];
                    
                    LyRemindView *remindView = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"密码修改成功,请重新登录"];
                    [remindView setDelegate:self];
                    [remindView performSelector:@selector(show) withObject:nil afterDelay:LyRemindViewDelayTime];
                    
                    break;
                }
                    
                case 1:
                {
                    [indicator stopAnimation];
                    [indicator removeFromSuperview];
                    
                    NSString *strMessage = [dic objectForKey:messageKey];
                    if (![LyUtil validateString:strMessage]) {
                        strMessage = @"修改失败";
                    }
                    
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:strMessage] show];
                    
                    break;
                }
                    
                case 2:
                {
                    [indicator stopAnimation];
                    [indicator removeFromSuperview];
                    
                    NSString *strMessage = [dic objectForKey:messageKey];
                    if (![LyUtil validateString:strMessage]) {
                        strMessage = @"修改失败";
                    }
                    
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:strMessage] show];
                    
                    
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
    if ( bHttpFlag) {
        bHttpFlag = NO;
        [self handleHttpFailed];
    }
    
    curHttpMethod = 0;
}



- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result {
    if ( bHttpFlag) {
        bHttpFlag = NO;
        curHttpMethod = [ahttpRequest mode];
        [self analysisHttpResult:result];
    }
    
    curHttpMethod = 0;
}


#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (modifyPasswordTextFieldMode_oldPwd == textField.tag) {
        if (textField.text.length + string.length > LyPasswordLengthMax) {
            return NO;
        }
    }
    
    if (modifyPasswordTextFieldMode_newPwd == textField.tag) {
        if (textField.text.length + string.length > LyPasswordLengthMax) {
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (modifyPasswordTextFieldMode_oldPwd == textField.tag) {
        if (textField.text.length > 0) {
            if ([textField.text validatePassword]) {
                [textField setTextColor:[UIColor blackColor]];
            } else {
                [textField setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"旧密码格式不正确"] show];
            }
        }
    } else if (modifyPasswordTextFieldMode_newPwd == textField.tag) {
        if (textField.text.length > 0) {
            if ([textField.text validatePassword]) {
                [textField setTextColor:[UIColor blackColor]];
            } else {
                [textField setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"旧密码格式不正确"] show];
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




#pragma mark -LyForgotPasswordViewControllerDelegate
- (LyUserType)obtainUserTypeByForgotPasswordVC:(LyForgotPasswordViewController *)forgotPasswordVC {
    return [LyCurrentUser curUser].userType;
}


- (void)resetPasswordSuccessByForgotPasswordVC:(LyForgotPasswordViewController *)forgotPasswordVC newPwd:(NSString *)newPwd {
    [LyUtil logout:nil];
}


#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(UIView *)view {
    
    [LyUtil logout:nil];
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
