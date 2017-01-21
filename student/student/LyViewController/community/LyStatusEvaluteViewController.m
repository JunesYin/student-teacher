//
//  LyStatusEvalutionViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/29.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyStatusEvaluteViewController.h"

#import "UITextView+placeholder.h"
#import "NSString+Validate.h"
#import "UITextView+maxLength.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyStatus.h"
#import "LyCurrentUser.h"
#import "LyUserManager.h"


#import "LyUtil.h"



#define tvContentWidth                      (FULLSCREENWIDTH-horizontalSpace*2.0f)
CGFloat const tvContnetHeight = 200.0f;
#define tvContentFont                       LyFont(14)


typedef NS_ENUM( NSInteger, LyStatusEvaluteNavigationBarButtonItemMode)
{
    statusEvaluteNavigationBarButtonItemMode_left,
    statusEvaluteNavigationBarButtonItemMode_right
};


typedef NS_ENUM( NSInteger, LyStatusEvaluteHttpMethod)
{
    statusEvaluteHttpMethod_send,
};


@interface LyStatusEvaluteViewController () <UITextViewDelegate, LyHttpRequestDelegate, LyRemindViewDelegate>
{
    UIBarButtonItem         *leftBarBtnItem;
    UIBarButtonItem         *rightBarBtnItem;
    
    
    LyIndicator             *indicator_send;
    
    UITextView              *tvContent;
    
    
    
    LyStatusEvaluteHttpMethod   curHttpMethod;
    BOOL                    bHttpFlag;
}
@end

@implementation LyStatusEvaluteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self senLayoutUI];
}


- (void)viewWillAppear:(BOOL)animated
{
    LyStatus *status;
    
    if ( [_delegate respondsToSelector:@selector(obtainStatusByStatusEvalute:)])
    {
        status = [_delegate obtainStatusByStatusEvalute:self];
    }
    
    if ( !status)
    {
        return;
    }

    if ( status == _status)
    {
        return;
    }
    
    _status = status;
    
    UILabel *lbTitle = [LyUtil lbTitleForNavigationBar:@"评论" detail:[[LyUserManager sharedInstance] getUserNameWithId:[_status staMasterId]]];
    [self.navigationItem setTitleView:lbTitle];
}


- (void)viewDidAppear:(BOOL)animated
{
    
    
    
    
}



- (void)senLayoutUI
{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    
    
    
    leftBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(targetForNavigatoinBarButtonItem:)];
    [leftBarBtnItem setTag:statusEvaluteNavigationBarButtonItemMode_left];
    [self.navigationItem setLeftBarButtonItem:leftBarBtnItem];
    rightBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(targetForNavigatoinBarButtonItem:)];
    [rightBarBtnItem setTag:statusEvaluteNavigationBarButtonItemMode_right];
    [self.navigationItem setRightBarButtonItem:rightBarBtnItem];
    
    
    tvContent = [[UITextView alloc] initWithFrame:CGRectMake( horizontalSpace, STATUSBARHEIGHT+NAVIGATIONBARHEIGHT+verticalSpace, tvContentWidth, tvContnetHeight)];
    [[tvContent layer] setCornerRadius:5.0f];
    [tvContent setBackgroundColor:[UIColor whiteColor]];
    [tvContent setTextColor:LyBlackColor];
    [tvContent setScrollEnabled:NO];
    [tvContent setScrollsToTop:NO];
    [tvContent setFont:tvContentFont];
    [tvContent setDelegate:self];
    [tvContent setPlaceholder:@"说点什么吧"];
    [tvContent setReturnKeyType:UIReturnKeyDone];
    [tvContent setMaxLength:evaluationLengthMax];
    
    [self.view addSubview:tvContent];
    
}




- (void)targetForNavigatoinBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [tvContent resignFirstResponder];
    
    if (statusEvaluteNavigationBarButtonItemMode_left == barButtonItem.tag) {
        
        if ( [_delegate respondsToSelector:@selector(onCancelStatusEvalute:)]) {
            [_delegate onCancelStatusEvalute:self];
        } else {
            [self dismissViewControllerAnimated:YES completion:^{
                ;
            }];
        }
        
    } else if (statusEvaluteNavigationBarButtonItemMode_right == barButtonItem.tag){
        [self evaluate];
    }
}


- (void)evaluate {
    
    if (![LyCurrentUser currentUser].isLogined) {
        [LyUtil showLoginVc:self];
        return;
    }
    
    if ( [[tvContent text] length] < 1)
    {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"内容不能为空"] show];
        return;
    }
    
    
    if ( !indicator_send)
    {
        indicator_send = [[LyIndicator alloc] initWithTitle:@"正在发送..."];
    }
    [indicator_send start];
    
    [self performSelector:@selector(evaluateDelay) withObject:nil afterDelay:validateSensitiveWordDelayTime];
    
}


- (void)evaluateDelay
{
    if ( ![[tvContent text] validateSensitiveWord])
    {
        [indicator_send stop];
        LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:remindTitle_sensitiveWord];
        [remind show];
    }
    else
    {
        LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:statusEvaluteHttpMethod_send];
        [httpRequest setDelegate:self];
        bHttpFlag = [[httpRequest startHttpRequest:statusEvalute_url
                                       requestBody:@{
                                                     contentKey:[tvContent text],
                                                     masterIdKey:[[LyCurrentUser currentUser] userId],
                                                     objectIdKey:[_status staMasterId],
                                                     objectStatusIdKey:[_status staId],
                                                     sessionIdKey:[LyUtil httpSessionId],
                                                     userTypeKey:userTypeStudentKey
                                                     }
                                       requestType:AsynchronousPost
                                           timeOut:0] boolValue];
    }
    
}



- (void)handleHttpFailed {
    if ([indicator_send isAnimating]) {
        [indicator_send stop];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"发送失败"] show];
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
        [indicator_send stop];
        
        [LyUtil sessionTimtOut:self];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_send stop];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    
    switch ( curHttpMethod) {
        case statusEvaluteHttpMethod_send: {
            curHttpMethod = 0;
            switch ( [strCode integerValue]) {
                case 0:{
                    
                    [_status setStaEvalutionCount:_status.staEvalutionCount+1];
                    
                    [indicator_send stop];
                    LyRemindView *remindSeccess = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"发送成功"];
                    [remindSeccess setDelegate:self];
                    [remindSeccess show];
                    
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
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest
{
    if ( bHttpFlag)
    {
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
        curHttpMethod = [ahttpRequest mode];
        [self analysisHttpResult:result];
    }
    curHttpMethod = 0;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [tvContent resignFirstResponder];
}



#pragma mark -UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    
    if ( textView.text.length > textView.maxLength)
    {
        textView.text = [textView.text substringFromIndex:textView.maxLength];
    }
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}





#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(UIView *)view
{
    [tvContent setText:@""];
    
    if ( [_delegate respondsToSelector:@selector(onDoneStatusEvalute:)])
    {
        [_delegate onDoneStatusEvalute:self];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            ;
        }];
    }
}


#pragma mark -UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == tvContent)
    {
        [tvContent update];
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
