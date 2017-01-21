//
//  LyFeedbackViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/22.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyFeedbackViewController.h"
#import "LyLoginViewController.h"

#import "UITextView+placeholder.h"
#import "UITextView+textCount.h"



#import "LyCurrentUser.h"
#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyMacro.h"
#import "LyUtil.h"
#import "LyHttpRequest.h"


#define fkWidth                         CGRectGetWidth(self.view.frame)
#define fkHeight                        CGRectGetHeight(self.view.frame)


#define viewContentWidth                fkWidth
CGFloat const viewContentHeight = 250.0f;

#define tvContentWidth                  (viewContentWidth-horizontalSpace*2)
#define tvContentHeight                 (viewContentHeight-verticalSpace*2)
#define tvContentFont                   LyFont(14)

#define fbBtnCommitWidth                  (fkWidth/2.0f)
CGFloat const fbBtnCommitHeight = 40.0f;




typedef NS_ENUM( NSInteger, LyFeedBackHttpMethod)
{
    feedbackHttpMethod_commit = 43
};


@interface LyFeedbackViewController () <UITextViewDelegate, LyHttpRequestDelegate, LyRemindViewDelegate>
{
    UIView                          *viewContent;
    UITextView                      *tvContent;
    
    
    NSString                        *fPhone;
    NSString                        *fName;
    
    
    LyIndicator                     *indicator_commit;
    BOOL                            bHttpFlag;
    LyFeedBackHttpMethod            curHttpMethod;
}
@end

@implementation LyFeedbackViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initAndLayoutSubview];
}


- (void)initAndLayoutSubview
{
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.title = @"意见反馈";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    viewContent = [[UIView alloc] initWithFrame:CGRectMake( 0, verticalSpace*3, viewContentWidth, viewContentHeight)];
    [viewContent setBackgroundColor:[UIColor whiteColor]];
    
    tvContent = [[UITextView alloc] initWithFrame:CGRectMake( horizontalSpace, verticalSpace, tvContentWidth, tvContentHeight)];
    [tvContent setDelegate:self];
    [tvContent setFont:tvContentFont];
    [tvContent setTextColor:LyBlackColor];
    [tvContent setPlaceholder:@"请输你宝贵的意见或建议"];
    [tvContent setTextCount:LyEvaluationLengthMax];
    [tvContent setReturnKeyType:UIReturnKeySend];
    
    
    [viewContent addSubview:tvContent];
    
    
    _btnCommit = [[UIButton alloc] initWithFrame:CGRectMake( fkWidth/2.0f-fbBtnCommitWidth/2.0f, viewContent.ly_y+CGRectGetHeight(viewContent.frame)+verticalSpace*4, fbBtnCommitWidth, fbBtnCommitHeight)];
    [_btnCommit setTitle:@"提交" forState:UIControlStateNormal];
    [_btnCommit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnCommit setBackgroundColor:Ly517ThemeColor];
    [[_btnCommit layer] setCornerRadius:5.0f];
    [_btnCommit setClipsToBounds:YES];
    [_btnCommit addTarget:self action:@selector(fkTargetForBtnCommit) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:viewContent];
    [self.view addSubview:_btnCommit];

}


- (void)fkTargetForBtnCommit {
    [tvContent resignFirstResponder];
    
    if ( ![tvContent text] || [NSNull null] == (NSNull *)[tvContent text] || [[tvContent text] isEqualToString:@""]) {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"你还未填写任何内容"] show];
        return;
    }
    
    [self commitFeedback];
}



- (void)commitFeedback {
    
    if ( !indicator_commit) {
        indicator_commit = [[LyIndicator alloc] initWithTitle:@"提交..."];
    }
    [indicator_commit start];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:feedbackHttpMethod_commit];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:feedback_url
                                          body:@{
                                                 contentKey:[tvContent text],
                                                 feedbackUserIdKey:[LyCurrentUser curUser].userId,
                                                 sessionIdKey:[LyUtil httpSessionId]}
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}




- (void)handleHttpFailed {
    if ( [indicator_commit isAnimating]){
        [indicator_commit stop];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"提交失败"] show];
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
        [indicator_commit stop];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_commit stop];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch (curHttpMethod) {
        case feedbackHttpMethod_commit: {
            switch ([strCode integerValue]) {
                case 0: {
                    [indicator_commit stop];
                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"提交成功"];
                    [remind setDelegate:self];
                    [remind show];
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



#pragma mark -UITextViewDelegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        [self fkTargetForBtnCommit];
        return NO;
    }
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [tvContent resignFirstResponder];
}


#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(UIView *)view
{
    [self.navigationController popViewControllerAnimated:YES];
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
