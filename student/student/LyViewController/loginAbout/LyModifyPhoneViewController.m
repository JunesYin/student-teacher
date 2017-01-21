//
//  LyModifyPhoneViewController.m
//  teacher
//
//  Created by Junes on 2016/9/29.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyModifyPhoneViewController.h"
#import "LyGetAuthCodeButton.h"
#import "LyToolBar.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"

#import "NSString+Validate.h"

#import "LyUtil.h"


#import "LyResetPhoneViewController.h"


enum {
    modifyPhoneBarButtonItemTag_next = 0,
}LyModifyPhoneBarButtonItemTag;

typedef NS_ENUM(NSInteger, LyModifyPhoneTextFieldTag) {
    modifyPhoneTextFieldTag_phone = 10,
    modifyPhoneTextFieldTag_authCode
};


typedef NS_ENUM(NSInteger, LyModifyPhoneHttpMethod) {
    modifyPhoneHttpMethod_verify = 100,
};


@interface LyModifyPhoneViewController () <UITextFieldDelegate, LyGetAuthCodeButtonDelegate, LyHttpRequestDelegate, LyResetPhoneViewControllerDelegate>
{
    UIBarButtonItem         *bbiNext;
    
    UITextField             *tfPhone;
//    UIView                  *viewAuthCode;
    UITextField             *tfAuthCode;
    LyGetAuthCodeButton     *btnGetAuthCode;
    
    
    LyIndicator             *indicator;
    BOOL                    bHttpFlag;
    LyModifyPhoneHttpMethod curHttpMethod;
}
@end

@implementation LyModifyPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}


- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self addObserverForNotificationFromUITextFieldTextDidChangeNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeObserverForNotificationFromUITextFieldTextDidChangeNotification];
}


- (void)initSubviews {
    self.title = @"修改手机号";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    bbiNext = [[UIBarButtonItem alloc] initWithTitle:@"下一步"
                                               style:UIBarButtonItemStyleDone
                                              target:self
                                              action:@selector(targetForBarButtonItem:)];
    [bbiNext setTag:modifyPhoneBarButtonItemTag_next];
    [self.navigationItem setRightBarButtonItem:bbiNext];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    UILabel *lbRemindUpper = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT+20.0f, SCREEN_WIDTH-horizontalSpace*2, LyViewItemHeight)];
    [lbRemindUpper setBackgroundColor:LyWhiteLightgrayColor];
    [lbRemindUpper setFont:LyFont(14)];
    [lbRemindUpper setTextColor:[UIColor grayColor]];
    [lbRemindUpper setTextAlignment:NSTextAlignmentCenter];
    [lbRemindUpper setText:[[NSString alloc] initWithFormat:@"你当前的手机号为：%@\n为保证你是此帐号的主人，请验证以下信息", [LyUtil hidePhoneNumber:[LyCurrentUser curUser].userPhoneNum]]];
    [lbRemindUpper setNumberOfLines:0];
    
    
    tfPhone = [[UITextField alloc] initWithFrame:CGRectMake(0, lbRemindUpper.frame.origin.y+CGRectGetHeight(lbRemindUpper.frame)+verticalSpace*2, SCREEN_WIDTH, LyViewItemHeight)];
    [tfPhone setTag:modifyPhoneTextFieldTag_phone];
    [tfPhone setFont:LyFont(16)];
    [tfPhone setBackgroundColor:[UIColor whiteColor]];
    [tfPhone setTextColor:[UIColor blackColor]];
    [tfPhone setTextAlignment:NSTextAlignmentCenter];
    [tfPhone setDelegate:self];
    [tfPhone setPlaceholder:@"手机号"];
    [tfPhone setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfPhone setKeyboardType:UIKeyboardTypePhonePad];
    [tfPhone setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfPhone]];
    
    
    UIView *viewAuthCode = [[UIView alloc] initWithFrame:CGRectMake(0, tfPhone.frame.origin.y+CGRectGetHeight(tfPhone.frame)+verticalSpace, SCREEN_WIDTH, LyViewItemHeight)];
    [viewAuthCode setBackgroundColor:[UIColor whiteColor]];
    
    tfAuthCode = [[UITextField alloc] initWithFrame:CGRectMake(btnGetAuthCodeWidth, 0, SCREEN_WIDTH-btnGetAuthCodeWidth*2, LyViewItemHeight)];
    [tfAuthCode setTag:modifyPhoneTextFieldTag_authCode];
    [tfAuthCode setFont:LyFont(16)];
    [tfAuthCode setTextColor:[UIColor blackColor]];
    [tfAuthCode setTextAlignment:NSTextAlignmentCenter];
    [tfAuthCode setDelegate:self];
    [tfAuthCode setPlaceholder:@"验证码"];
    [tfAuthCode setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfAuthCode setKeyboardType:UIKeyboardTypeNumberPad];
    [tfAuthCode setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfAuthCode]];
    
    
    btnGetAuthCode = [[LyGetAuthCodeButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-btnGetAuthCodeWidth-verticalSpace, LyViewItemHeight/2.0f-btnGetAuthCodeHeight/2.0f, btnGetAuthCodeWidth, btnGetAuthCodeHeight)];
    [btnGetAuthCode setDelegate:self];
    
    [viewAuthCode addSubview:tfAuthCode];
    [viewAuthCode addSubview:btnGetAuthCode];
    
    
    UILabel *lbRemindLower = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, SCREEN_HEIGHT-LyViewItemHeight, SCREEN_WIDTH-horizontalSpace*2, LyViewItemHeight)];
    [lbRemindLower setBackgroundColor:LyWhiteLightgrayColor];
    [lbRemindLower setFont:LyFont(12)];
    [lbRemindLower setTextColor:[UIColor grayColor]];
    [lbRemindLower setTextAlignment:NSTextAlignmentCenter];
    [lbRemindLower setNumberOfLines:0];
    [lbRemindLower setAttributedText:({
        NSString *strRemindLowerTmp = [[NSString alloc] initWithFormat:@"温馨提示：如果此手机无法接收短信，可求助\n我要去学车服务热线：%@", phoneNum_517];
        NSMutableAttributedString *strRemindLower = [[NSMutableAttributedString alloc] initWithString:strRemindLowerTmp];
        [strRemindLower addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[strRemindLowerTmp rangeOfString:phoneNum_517]];
        strRemindLower;
    })];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForTapGestureFromLbRemindLower)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    
    [lbRemindLower setUserInteractionEnabled:YES];
    [lbRemindLower addGestureRecognizer:tap];
     
    
    [self.view addSubview:lbRemindUpper];
    [self.view addSubview:tfPhone];
    [self.view addSubview:viewAuthCode];
    [self.view addSubview:lbRemindLower];
    
    
    [bbiNext setEnabled:NO];
    [btnGetAuthCode setEnabled:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)validate:(BOOL)flag {
    
    [bbiNext setEnabled:NO];
    
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
    
    if (!btnGetAuthCode.time) {
        return NO;
    }
    
    
    [bbiNext setEnabled:YES];
    
    return YES;
}


- (void)allControlResignFirstResponder {
    [tfPhone resignFirstResponder];
    [tfAuthCode resignFirstResponder];
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


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    [self allControlResignFirstResponder];
    
    if (modifyPhoneBarButtonItemTag_next == bbi.tag) {
        [self virify];
    }
}

- (void)targetForTapGestureFromLbRemindLower {
    [LyUtil call:phoneNum_517];
}



- (void)virify {
    
    if (![self validate:YES]) {
        return;
    }
    
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:LyIndicatorTitle_verify];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [[LyHttpRequest alloc] initWithMode:modifyPhoneHttpMethod_verify];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:checkAuchCode_url
                                 body:@{
                                        phoneKey:tfPhone.text,
                                        authKey:tfAuthCode.text,
                                        timeKey:btnGetAuthCode.time,
//                                        trueAuthKey:btnGetAuthCode.trueAuthCode
                                        }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)handleHttpFailed {
    if ([indicator isAnimating]) {
        [indicator stopAnimation];
        [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"验证失败"];
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
        
        [LyUtil sessionTimeOut:self];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch (curHttpMethod) {
        case modifyPhoneHttpMethod_verify: {
            switch ([strCode integerValue]) {
                case 0: {
                    [indicator stopAnimation];
                    
                    LyResetPhoneViewController *resetPhone = [[LyResetPhoneViewController alloc] init];
                    [resetPhone setDelegate:self];
                    [self.navigationController pushViewController:resetPhone animated:YES];
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


#pragma mark -LyResetPhoneViewControllerDelegate
- (void)onDoneByResetPhoneVC:(LyResetPhoneViewController *)aResetPhoneVC {
    [_delegate onDoneByModifyPhoneVC:self];
}


#pragma mark -LyGetAuthCodeButtonDelegate
- (NSString *)obtainPhoneNum:(LyGetAuthCodeButton *)button {
    
    [self allControlResignFirstResponder];
    
    if (![tfPhone.text isEqualToString:[LyCurrentUser curUser].userPhoneNum]) {
        
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号错误"] show];
        return @"";
    }
    
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

    LyModifyPhoneTextFieldTag tfTag = textField.tag;
    switch (tfTag) {
        case modifyPhoneTextFieldTag_phone: {
            if (tfPhone.text.length + string.length > LyAccountLength) {
                return NO;
            }
            break;
        }
        case modifyPhoneTextFieldTag_authCode: {
            if (tfAuthCode.text.length + string.length > LyAuthCodeLength) {
                return NO;
            }
            break;
        }
    }
    
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    LyModifyPhoneTextFieldTag tfTag = textField.tag;
    switch (tfTag) {
        case modifyPhoneTextFieldTag_phone: {
            if (tfPhone.text.length > 0) {
                if ([tfPhone.text validatePhoneNumber]) {
                    [tfPhone setTextColor:[UIColor blackColor]];
                } else {
                    [tfPhone setTextColor:LyWarnColor];
                    [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"手机号格式错误"] show];
                }
            }
            break;
        }
        case modifyPhoneTextFieldTag_authCode: {
            if (tfAuthCode.text.length > 0) {
                if ([tfAuthCode.text validateAuthCode]) {
                    [tfAuthCode setTextColor:[UIColor blackColor]];
                } else {
                    [tfAuthCode setTextColor:LyWarnColor];
                    [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"验证码格式错误"] show];
                }
            }
            break;
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
