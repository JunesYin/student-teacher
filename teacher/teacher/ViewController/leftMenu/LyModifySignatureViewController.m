//
//  LyModifySignatureViewController.m
//  student
//
//  Created by Junes on 2016/11/18.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyModifySignatureViewController.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"

#import "NSString+Validate.h"
#import "UITextView+textCount.h"
#import "LyUtil.h"


CGFloat const msTvSignHeight = 77.0f;

typedef NS_ENUM(NSInteger, LyModifySignatureBarButtonItemTag) {
    modifySIgnatureBarButtonItemTag_modify = 0,
};

typedef NS_ENUM(NSInteger, LyModifySignatureTextViewTag) {
    modifySignatureTextViewTag_sign = 10,
};

//typedef NS_ENUM(NSInteger, LyModifySignatureHttpMethod) <#new#>;


@interface LyModifySignatureViewController () <UITextViewDelegate, LyHttpRequestDelegate, LyRemindViewDelegate>
{
    UITextView          *tvSign;
    
    LyIndicator         *indicator;
}
@end

@implementation LyModifySignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [tvSign setText:[LyCurrentUser curUser].userSignature];
    [tvSign updateTextCount];
    
    [tvSign becomeFirstResponder];
}


- (void)initAndLayoutSubviews {
    
    self.title = @"签名";
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.view.backgroundColor = LyWhiteLightgrayColor;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    UIBarButtonItem *bbiMdofy = [[UIBarButtonItem alloc] initWithTitle:@"修改"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(targetForBarButtonItem:)];
    [self.navigationItem setRightBarButtonItem:bbiMdofy];
    
    UIView *viewSign = [[UIView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT + 20.0f, SCREEN_WIDTH, msTvSignHeight)];
    [viewSign setBackgroundColor:[UIColor whiteColor]];
    
    tvSign = [[UITextView alloc] initWithFrame:CGRectMake(horizontalSpace, 2, SCREEN_WIDTH - horizontalSpace * 2, msTvSignHeight - 2 * 2)];
    [tvSign setTag:modifySignatureTextViewTag_sign];
    [tvSign setDelegate:self];
    [tvSign setFont:LyFont(14)];
    [tvSign setTextColor:[UIColor blackColor]];
    [tvSign setReturnKeyType:UIReturnKeyDone];
    [tvSign setTextCount:LySignatureLengthMax];
    [tvSign setTextAlignment:NSTextAlignmentLeft];
    
    [viewSign addSubview:tvSign];
    
    [self.view addSubview:viewSign];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    LyModifySignatureBarButtonItemTag bbiTag = bbi.tag;
    switch (bbiTag) {
        case modifySIgnatureBarButtonItemTag_modify: {
            [tvSign resignFirstResponder];
            [self modify_pre];
            break;
        }
        default:
            break;
    }
}

- (BOOL)validate:(BOOL)flag {
    
    if (tvSign.text.length > LySignatureLengthMax) {
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:[[NSString alloc] initWithFormat:@"签名最多%d字", LySignatureLengthMax]] show];
        }
        
        return YES;
    }
    
    return YES;
}

- (void)modify_pre {
    if (![self validate:YES]) {
        return;
    }
    
    if ([tvSign.text isEqualToString:[LyCurrentUser curUser].userSignature]) {
        [_delegate modifySignatureViewController:self done:tvSign.text];
        return;
    }
    
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:nil];
    }
    [indicator startAnimation];
    
    [self performSelector:@selector(modify) withObject:nil afterDelay:validateSensitiveWordDelayTime];
}

- (void)handleHttpFailed {
    if (indicator.isAnimating) {
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
        [LyUtil sessionTimeOut];
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
    if (![tvSign.text validateSensitiveWord]) {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:LyRemindTitle_sensitiveWord] show];
        return;
    }
    
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:modifyUserInfo_url
                    body:@{
                           signatureKey:tvSign.text,
                           userIdKey:[LyCurrentUser curUser].userId,
                           userTypeKey:[[LyCurrentUser curUser] userTypeByString],
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
                           [self handleHttpFailed];
                           return;
                       }
                       
                       NSString *strSignature = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:signatureKey]];
                       [[LyCurrentUser curUser] setUserSignature:strSignature];
                       
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
    [_delegate modifySignatureViewController:self done:tvSign.text];
}


#pragma mark -UITextViewDelegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    LyModifySignatureTextViewTag tvTag = textView.tag;
//    switch (tvTag) {
//        case modifySignatureTextViewTag_sign: {
//            if (textView.text.length + text.length > LySignatureLengthMax) {
//                return NO;
//            }
//            break;
//        }
//        default:
//            break;
//    }
//    return  YES;
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
