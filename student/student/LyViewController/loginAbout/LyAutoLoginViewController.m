//
//  LyAutoLoginViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/3.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyAutoLoginViewController.h"
#import "lyCurrentUser.h"
#import "LyBottomControl.h"
#import "LyMacro.h"
#import "LyUtil.h"

#import <WebKit/WebKit.h>

#define alWidth                             CGRectGetWidth(self.view.frame)
#define alHeight                            CGRectGetHeight(self.view.frame)


CGFloat const alIvAvatarSize = 60.0f;


#define alLbNameWidth                         alWidth
CGFloat const alLbNameHeight = 30.0f;
#define lbNameFont                          LyFont(16)


#define tvRemindWidth                       alWidth
CGFloat const alTvRemindHeight = 50.0f;
#define tvRemindFont                        LyFont(16)



#define wvGifWidth                          alWidth
#define wvGifHeight                         (wvGifWidth/3.6f)

#define ivGifWidth                          alWidth
#define ivGifHeight                         (wvGifWidth/3.0f)



typedef NS_ENUM( NSInteger, LyAutoLoginHttpMethod)
{
    autoLoginHttpMethod_autoLogin = 144
};


@interface LyAutoLoginViewController () <LyHttpRequestDelegate>
{
    BOOL                        flagGotoAppStore;
    
    
    UIImageView                 *ivAvatar;
    
    UILabel                     *lbName;
    
    UITextView                  *tvRemind;
    
//    WKWebView       *wvGif;
//    NSData      *dataGif;
    UIWebView                   *wvGif;
    NSURLRequest                *dataReq;
    
    NSTimer                     *timer;
    

    LyAutoLoginHttpMethod       lastHttpMehtod;
    BOOL                        bHttpFlag;
}
@end

@implementation LyAutoLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubview];
}



- (void)viewDidAppear:(BOOL)animated
{
    [self performSelector:@selector(autoLogin) withObject:nil afterDelay:LyDelayTime];
    
    if ( [self respondsToSelector:@selector(targetForAppDidBecomeActive:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(targetForAppDidBecomeActive:) name:LyAppDidBecomeActive object:nil];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LyAppDidBecomeActive object:nil];
}



- (void)initAndLayoutSubview
{
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake( alWidth/2.0f-alIvAvatarSize/2.0f, 100.0f, alIvAvatarSize, alIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [[ivAvatar layer] setCornerRadius:alIvAvatarSize/2.0f];
    [ivAvatar setClipsToBounds:YES];
    
    
    
    lbName = [[UILabel alloc] initWithFrame:CGRectMake( 0, ivAvatar.frame.origin.y+CGRectGetHeight(ivAvatar.frame)+10.0f, alLbNameWidth, alLbNameHeight)];
    [lbName setFont:lbNameFont];
    [lbName setTextColor:LyBlackColor];
    [lbName setTextAlignment:NSTextAlignmentCenter];
    
    
    
    tvRemind = [[UITextView alloc] initWithFrame:CGRectMake( 0, lbName.frame.origin.y+CGRectGetHeight(lbName.frame)+70.0f, tvRemindWidth, alTvRemindHeight)];
    [tvRemind setBackgroundColor:LyWhiteLightgrayColor];
    [tvRemind setTextColor:LyDarkgrayColor];
    [tvRemind setFont:tvRemindFont];
    [tvRemind setTextAlignment:NSTextAlignmentCenter];
    [tvRemind setEditable:NO];
    [tvRemind setScrollEnabled:NO];
    
    
    wvGif = [[UIWebView alloc] initWithFrame:CGRectMake( 0, alHeight-wvGifHeight, wvGifWidth, wvGifHeight)];
    [wvGif setBackgroundColor:LyWhiteLightgrayColor];
    [wvGif setOpaque:NO];
    [wvGif setUserInteractionEnabled:NO];
    
//    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
//    config.preferences = [WKPreferences new];
//    
//    wvGif = [[WKWebView alloc] initWithFrame:CGRectMake(0, alHeight - wvGifHeight, wvGifWidth, wvGifHeight) configuration:config];
//    [wvGif setBackgroundColor:LyWhiteLightgrayColor];
//    [wvGif setOpaque:NO];
//    [wvGif setUserInteractionEnabled:NO];

    
    

//    NSData *dataGif = [NSData dataWithContentsOfFile:[LyUtil filePathForFileName:@"autoLogin.gif"]];
//    [wvGif loadData:dataGif MIMEType:@"image/gif" characterEncodingName:nil baseURL:nil];


    
    [self.view addSubview:ivAvatar];
    [self.view addSubview:lbName];
    
    [self.view addSubview:wvGif];
    
    dataReq = [NSURLRequest requestWithURL:[NSURL URLWithString:[LyUtil filePathForFileName:@"autoLogin.gif"]]];
    [wvGif loadRequest:dataReq];
    [wvGif sizeToFit];
    
//    timer = [NSTimer scheduledTimerWithTimeInterval:1.30f target:self selector:@selector(repeatShowGif) userInfo:nil repeats:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self repeatShowGif];
    });
    
    [self loadUserInfo];
    
}


- (void)repeatShowGif {
    [wvGif loadRequest:dataReq];
    
//    [wvGif loadData:dataGif MIMEType:@"image/gif" characterEncodingName:nil baseURL:nil];
}



//显示需要升级的提示
- (void)showAlertForUpdate {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitleForUpdate
                                                                   message:alertMessageForUpdate
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [_delegate onAutoFinished:self];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"前往下载"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                flagGotoAppStore = YES;
                                                NSURL *url = [NSURL URLWithString:appStore_url];
                                                [LyUtil openUrl:url];
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}




- (void)loadUserInfo {
    NSString *strUserId   = [[NSUserDefaults standardUserDefaults] objectForKey:userId517Key];
    NSString *strName     = [[NSUserDefaults standardUserDefaults] objectForKey:userName517Key];
    

    UIImage *avatar = [LyUtil getAvatarFromDocumentWithUserId:strUserId];
    if (!avatar) {
        avatar = [LyUtil defaultAvatarForStudent];
    }
    [ivAvatar setImage:avatar];
    
    if (![LyUtil validateString:strName]) {
        [lbName setText:@"尊敬的517用户，你好"];
    } else {
        [lbName setText:strName];
    }
}




- (void)autoLogin
{

    NSString *strAccount  = [[NSUserDefaults standardUserDefaults] objectForKey:userAccount517Key];
    NSString *strPassword = [[NSUserDefaults standardUserDefaults] objectForKey:userPassword517Key];
    NSString *pwd_encode = [LyUtil encodePassword:strPassword];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:autoLoginHttpMethod_autoLogin];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:login_url
                                          body:@{
                                                 accountKey:strAccount,
                                                 passowrdKey:pwd_encode,
                                                 userTypeKey:userTypeStudentKey,
                                                 versionKey:[LyUtil getApplicationVersionNoPoint]
                                                 }
                                          type:LyHttpType_asynPost
                                      timeOut:5.0f] boolValue];
}




- (void)analysisResult:(NSString *)userInfo
{
    NSDictionary *dic = [LyUtil getObjFromJson:userInfo];
    
    if ( !dic || [NSNull null] == (NSNull *)dic || ![dic count])
    {
        lastHttpMehtod = 0;
        [tvRemind setText:@"登录失败"];
        [self doSomething];
        
        return;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    
    if ( !strCode || [NSNull null] == (NSNull *)strCode || [strCode length] < 1)
    {
        lastHttpMehtod = 0;
        
        [tvRemind setText:@"登录失败"];
        [self doSomething];
        
        return;
    }
    
    switch ( [strCode intValue]) {
        case 0: {
            //成功
            NSDictionary *dicResult = [dic objectForKey:resultKey];
            if (!dicResult || ![LyUtil validateDictionary:dicResult])
            {
                [tvRemind setText:@"登录失败"];
                [self doSomething];
                return;
            }
            
            NSString *strVerifyState = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:verifyStateKey]];
            if (LyVerifyState_rejected == [strVerifyState integerValue])
            {
                [tvRemind setText:@"登录失败"];
                [self doSomething];
                return;
            }
            
            
            [tvRemind setText:@"欢迎回来"];
            
            NSString *strUserId = [dicResult objectForKey:userIdKey];
            NSString *strNickName = [dicResult objectForKey:nickNameKey];
            NSString *strSessionId = [dic objectForKey:sessionIdKey];
            NSString *strAddress = [dicResult objectForKey:addressKey];
            NSString *strDriveLicenseMode = [dicResult objectForKey:driveLicenseKey];
            NSString *strSubjectMode = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:subjectModeKey]];
            
            LyLicenseType license = [LyUtil driveLicenseFromString:strDriveLicenseMode];
            
            license = (license > LyLicenseType_M) ? 0 : license;
            LySubjectMode subject = [strSubjectMode integerValue];
            subject = (subject > LySubjectMode_fourth || subject < 0) ? 0 : subject;
            
            [LyUtil setHttpSessionId:strSessionId];
            
            
            [[LyCurrentUser curUser] setUserId:strUserId];
            [[LyCurrentUser curUser] setUserPhoneNum:[[NSUserDefaults standardUserDefaults] objectForKey:userAccount517Key]];
            [[LyCurrentUser curUser] setUserName:strNickName];
            [[LyCurrentUser curUser] setUserAddress:strAddress];
            [[LyCurrentUser curUser] setUserLicenseType:license];
            [[LyCurrentUser curUser] setUserSubjectMode:subject];
            
            [[LyBottomControl sharedInstance] setLicenseInfo:license object:[strSubjectMode integerValue]];
            
            [self getUserAvatarAsyn:strUserId];
            
            
            [[NSUserDefaults standardUserDefaults] setObject:strUserId forKey:userId517Key];
            [[NSUserDefaults standardUserDefaults] setObject:strNickName forKey:userName517Key];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            [self doSomething];
            
            break;
        }
            
        case 1:
        {//无此帐号
            [tvRemind setText:@"登录失败"];
            [self doSomething];
            
            break;
        }
            
        case 2:
        {//密码错误
            [tvRemind setText:@"登录失败"];
            [self doSomething];
            
            break;
        }
        case 3: {
            //帐户类型错误
            [tvRemind setText:@"登录失败"];
            [self doSomething];
            
            break;
        }
        case 4: {
            //客户端版本太旧
            [self showAlertForUpdate];
            break;
        }
        default: {
            [tvRemind setText:@"登录失败"];
            [self doSomething];
            break;
        }
    }

}



- (void)getUserAvatarAsyn:(NSString *)userId
{
    [LyImageLoader loadAvatarWithUserId:userId
                               complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSString * _Nullable userId) {
                                   if (image) {
                                       [[LyCurrentUser curUser] setUserAvatar:image];
                                       [LyUtil saveImage:image withUserId:userId withMode:LySaveImageMode_avatar];
                                   }
                               }];
}




- (void)doSomething
{
    [timer invalidate];
    [wvGif removeFromSuperview];
    
    
    [tvRemind setHidden:YES];
    [self.view addSubview:tvRemind];
    
    CGPoint centerTvRemind = tvRemind.center;
    [LyUtil startAnimationWithView:tvRemind
                 animationDuration:0.3f
                      initialPoint:CGPointMake( centerTvRemind.x, centerTvRemind.y+60.0f)
                  destinationPoint:CGPointMake( centerTvRemind.x, centerTvRemind.y-20.0f)
                        completion:^(BOOL finished) {
                            [LyUtil startAnimationWithView:tvRemind
                                         animationDuration:0.1f
                                              initialPoint:CGPointMake( tvRemind.center.x, tvRemind.center.y)
                                          destinationPoint:centerTvRemind
                                                completion:^(BOOL finished) {
                                                    [tvRemind setCenter:centerTvRemind];
                                                    [self performSelector:@selector(autoLoginFinished) withObject:nil afterDelay:1.0f];
                                                }];
                        }];
}



- (void)autoLoginFinished
{
    if ( [_delegate respondsToSelector:@selector(onAutoFinished:)]) {
        [_delegate onAutoFinished:self];
    }
}




#pragma mark -LyHttpRequestDelegate
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest
{
    if ( bHttpFlag)
    {
        bHttpFlag = NO;
        [self analysisResult:@"gadgd"];
    }
}



- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result
{
    if ( bHttpFlag)
    {
        bHttpFlag = NO;
        lastHttpMehtod = ahttpRequest.mode;
        [self analysisResult:result];
    }

    
    
}



#pragma mark -LyAppDidBecomeActive
- (void)targetForAppDidBecomeActive:(NSNotification *)notification {
    
    if (flagGotoAppStore) {
        flagGotoAppStore = NO;
        
        [self dismissViewControllerAnimated:YES completion:nil];
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
