//
//  LyEvaluateNewsViewController.m
//  teacher
//
//  Created by Junes on 2016/10/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyEvaluateNewsViewController.h"

#import "UITextView+placeholder.h"
#import "NSString+Validate.h"
#import "UITextView+textCount.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyNews.h"
#import "LyCurrentUser.h"
#import "LyUserManager.h"


#import "LyUtil.h"


#define tvContentWidth                      (SCREEN_WIDTH-horizontalSpace*2.0f)
CGFloat const tvContnetHeight = 200.0f;
#define tvContentFont                       LyFont(14)

typedef NS_ENUM( NSInteger, LyEvaluateNewsBarButtonItemTag) {
    evaluateNewsBarButtonItemTag_close = 0,
    evaluateNewsBarButtonItemTag_send
};


typedef NS_ENUM( NSInteger, LyEvaluateNewsHttpMethod) {
    evaluateNewsHttpMethod_send = 100,
};


@interface LyEvaluateNewsViewController () <UITextViewDelegate, LyHttpRequestDelegate, LyRemindViewDelegate>
{
    UIBarButtonItem         *bbiClose;
    UIBarButtonItem         *bbiSeond;
    
    UITextView              *tvContent;
    
    LyIndicator             *indicator;
    LyEvaluateNewsHttpMethod   curHttpMethod;
    BOOL                    bHttpFlag;
}
@end

@implementation LyEvaluateNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}



- (void)viewWillAppear:(BOOL)animated
{
    
    if ( [_delegate respondsToSelector:@selector(obtainNewsByEvaluateNewsVC:)]) {
        _news = [_delegate obtainNewsByEvaluateNewsVC:self];
    }
    
    if ( !_news) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
    UILabel *lbTitle = [LyUtil lbTitleForNavigationBar:@"评论" detail:[[LyUserManager sharedInstance] getUserNameWithId:_news.newsMasterId]];
    [self.navigationItem setTitleView:lbTitle];
}


- (void)initSubviews {
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    
    bbiClose = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(targetForBarButtonItem:)];
    [bbiClose setTag:evaluateNewsBarButtonItemTag_close];
    [self.navigationItem setLeftBarButtonItem:bbiClose];
    bbiSeond = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(targetForBarButtonItem:)];
    [bbiSeond setTag:evaluateNewsBarButtonItemTag_send];
    [self.navigationItem setRightBarButtonItem:bbiSeond];
    
    
    tvContent = [[UITextView alloc] initWithFrame:CGRectMake( horizontalSpace, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT+verticalSpace, tvContentWidth, tvContnetHeight)];
    [[tvContent layer] setCornerRadius:5.0f];
    [tvContent setBackgroundColor:[UIColor whiteColor]];
    [tvContent setTextColor:LyBlackColor];
    [tvContent setScrollEnabled:NO];
    [tvContent setScrollsToTop:NO];
    [tvContent setFont:tvContentFont];
    [tvContent setDelegate:self];
    [tvContent setPlaceholder:@"说点什么吧"];
    [tvContent setReturnKeyType:UIReturnKeyDone];
    [tvContent setTextCount:LyEvaluationLengthMax];
    
    [self.view addSubview:tvContent];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    
    [tvContent resignFirstResponder];
    
    if (evaluateNewsBarButtonItemTag_close == bbi.tag) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else if (evaluateNewsBarButtonItemTag_send == bbi.tag) {
        
        if (tvContent.text.length < 1) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"内容不能为空"] show];
            return;
        }
        
        if ( !indicator) {
            indicator = [[LyIndicator alloc] initWithTitle:@"正在发送..."];
        }
        [indicator startAnimation];
        
        [self performSelector:@selector(evaluateDelay) withObject:nil afterDelay:validateSensitiveWordDelayTime];
    }
   
}


- (void)evaluateDelay {
    
    if ( ![[tvContent text] validateSensitiveWord]) {
        [indicator stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:LyRemindTitle_sensitiveWord] show];
    } else {
        LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:evaluateNewsHttpMethod_send];
        [httpRequest setDelegate:self];
        bHttpFlag = [[httpRequest startHttpRequest:statusEvalute_url
                                              body:@{
                                                     contentKey:[tvContent text],
                                                     masterIdKey:[LyCurrentUser curUser].userId,
                                                     objectIdKey:_news.newsMasterId,
                                                     objectingIdKey:_news.newsId,
                                                     sessionIdKey:[LyUtil httpSessionId],
                                                     userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                                     }
                                              type:LyHttpType_asynPost
                                           timeOut:0] boolValue];
    }
    
}



- (void)handleHttpFailed {
    if (indicator.isAnimating) {
        [indicator stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"发送失败"] show];
    }
}




- (void)analysisHttpResult:(NSString *)result
{
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
    
    switch ( curHttpMethod) {
        case evaluateNewsHttpMethod_send: {
            switch ( [strCode integerValue]) {
                case 0:{
                    [_news setNewsEvaluationCount:_news.newsEvaluationCount + 1];
                    
                    [indicator stopAnimation];
                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"发送成功"];
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
        bHttpFlag = NO;
        [self handleHttpFailed];
    }
    
    curHttpMethod = 0;
}


- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result {
    
    if ( bHttpFlag) {
        bHttpFlag = NO;
        curHttpMethod = ahttpRequest.mode;
        [self analysisHttpResult:result];
    }
    curHttpMethod = 0;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [tvContent resignFirstResponder];
}



#pragma mark -UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    [textView resignFirstResponder];
    
    if ( textView.text.length > textView.textCount) {
        textView.text = [textView.text substringFromIndex:textView.textCount];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}





#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(UIView *)view {
    [tvContent setText:@""];
    
    [_delegate onDoneByEvaluateNewsVC:self];
}


#pragma mark -UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == tvContent) {
        [tvContent update];
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





