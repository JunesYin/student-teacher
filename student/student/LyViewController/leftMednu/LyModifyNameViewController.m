//
//  LyModifyNameViewController.m
//  student
//
//  Created by Junes on 2016/11/18.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyModifyNameViewController.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"

#import "NSString+Validate.h"
#import "LyUtil.h"


CGFloat const mnTfNameHeight = 40.0f;

typedef NS_ENUM(NSInteger, LyModifyNameBarButtonItemTag) {
    modifyNameBarButtonItemTag_modify = 0,
};

typedef NS_ENUM(NSInteger, LyModifyNameTextFieldTag) {
    modifyNameTextFieldTag_name = 10,
};

typedef NS_ENUM(NSInteger, LyModifyNameHttpMethod) {
    modifyNameHttpMethod_modify = 100,
};

@interface LyModifyNameViewController () <UITextFieldDelegate, LyRemindViewDelegate>
{
    UIBarButtonItem         *bbiModify;
    
    UITextField             *tfName;
    
    LyIndicator             *indicator;
}
@end

@implementation LyModifyNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [tfName setText:[LyCurrentUser curUser].userName];
    [tfName becomeFirstResponder];
}


- (void)initSubviews {
    
    self.title = @"姓名";
    self.view.backgroundColor = LyWhiteLightgrayColor;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    bbiModify = [[UIBarButtonItem alloc] initWithTitle:@"修改"
                                               style:UIBarButtonItemStyleDone
                                              target:self
                                              action:@selector(targetForBarButtonItem:)];
    [self.navigationItem setRightBarButtonItem:bbiModify];
    
    
    tfName = [[UITextField alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT + verticalSpace * 4, SCREEN_WIDTH, mnTfNameHeight)];
    [tfName setTag:modifyNameTextFieldTag_name];
    [tfName setDelegate:self];
    [tfName setFont:LyFont(14)];
    [tfName setTextColor:[UIColor blackColor]];
    [tfName setTextAlignment:NSTextAlignmentLeft];
    [tfName setBackgroundColor:[UIColor whiteColor]];
    [tfName setPlaceholder:@"姓名"];
    [tfName setReturnKeyType:UIReturnKeyDone];
    
    [tfName setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, horizontalSpace, mnTfNameHeight)]];
    [tfName setLeftViewMode:UITextFieldViewModeAlways];
    [tfName setClearButtonMode:UITextFieldViewModeAlways];
    
    [self.view addSubview:tfName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    
    LyModifyNameBarButtonItemTag bbiTag = bbi.tag;
    switch (bbiTag) {
        case modifyNameBarButtonItemTag_modify: {
            
            [tfName resignFirstResponder];
            [self modify_pre];
            break;
        }
        default:
            break;
    }
}


- (BOOL)validate:(BOOL)flag {
    
    if (![tfName.text validateName]) {
        if (flag) {
            [tfName setTextColor:LyWarnColor];
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"姓名格式错误"] show];
        }
        
        return NO;
    } else {
        [tfName setTextColor:[UIColor blackColor]];
    }
        
    return YES;
}


- (void)modify_pre {
    if (![self validate:YES]) {
        return;
    }
    
    if ([tfName.text isEqualToString:[LyCurrentUser curUser].userName]) {
        [_delegate modifyNameViewController:self modifyDone:tfName.text];
        return;
    }
    
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:nil];
    }
    [indicator startAnimation];
    
    [self performSelector:@selector(modify) withObject:nil afterDelay:validateSensitiveWordDelayTime];
}


- (void)handleHttpFailed {
    if ([indicator isAnimating]) {
        [indicator stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"修改失败"] show];
    }
}


- (NSDictionary *)analysisHttpResult:(NSString *)result {
    NSDictionary *dic = [LyUtil getObjFromJson:result];
    if (![LyUtil validateDictionary:dic]) {
        [self handleHttpFailed];
        return nil;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (![LyUtil validateString:strCode]) {
        [self handleHttpFailed];
        return nil;
    }
    
    if (codeTimeOut == strCode.integerValue) {
        [indicator stopAnimation];
        [LyUtil sessionTimeOut:self];
        return nil;
    }
    
    if (codeMaintaining == strCode.integerValue) {
        [indicator stopAnimation];
        [LyUtil serverMaintaining];
        return nil;
    }
    
    return dic;
}



- (void)modify {
    if (![tfName.text validateSensitiveWord]) {
        [indicator stopAnimation];
        
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:LyRemindTitle_sensitiveWord] show];
        return;
    }
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:modifyNameHttpMethod_modify];
    [hr startHttpRequest:modifyUserInfo_url
                    body:@{
                           nickNameKey:tfName.text,
                           userIdKey:[[LyCurrentUser curUser] userId],
                           userTypeKey:userTypeStudentKey,
                           sessionIdKey:[LyUtil httpSessionId]
                           }
                    type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
           if (error) {
               [self handleHttpFailed];
           } else {
               NSDictionary *dic = [self analysisHttpResult:resStr];
               if (!dic) {
                   [self handleHttpFailed];
                   return;
               }
               NSString *strCode = [dic objectForKey:codeKey];
               
               switch (strCode.integerValue) {
                   case 0: {
                       NSDictionary *dicResult = [dic objectForKey:resultKey];
                       if (![LyUtil validateDictionary:dicResult]) {
                           
                           return;
                       }
                       NSString *newNickName = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:nickNameKey]];
                       [[LyCurrentUser curUser] setUserName:newNickName];
                       [[NSUserDefaults standardUserDefaults] setObject:newNickName forKey:userName517Key];
                       [[NSUserDefaults standardUserDefaults] synchronize];
                       
                       [indicator stopAnimation];
                       LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"修改成功"];
                       [remind setDelegate:self];
                       [remind show];
                       break;
                   }
                   default: {
                       [self handleHttpFailed];
                       break;
                   }
               }
           }
       }];
}


#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(LyRemindView *)aRemind {
    [_delegate modifyNameViewController:self modifyDone:tfName.text];
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    LyModifyNameTextFieldTag tfTag = textField.tag;
    switch (tfTag) {
        case modifyNameTextFieldTag_name: {
            if (textField.text.length + string.length > LyNameLengthMax) {
                return NO;
            }
            break;
        }
        default:
            break;
    }
    
    return YES;
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
