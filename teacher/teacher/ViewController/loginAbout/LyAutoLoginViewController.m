//
//  LyAutoLoginViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/3.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyAutoLoginViewController.h"

#import "LyCurrentUser.h"
//#import "LyBottomControl.h"

#import "LyUtil.h"




CGFloat const alIvAvatarSize = 60.0f;


CGFloat const alLbNameHeight = 30.0f;
#define lbNameFont                          LyFont(16)


CGFloat const alTvRemindHeight = 50.0f;
#define tvRemindFont                        LyFont(16)

#define wvGifHeight                         (SCREEN_WIDTH/3.6f)




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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self performSelector:@selector(autoLogin) withObject:nil afterDelay:0.5f];
}



- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LyAppDidBecomeActive object:nil];
}


- (void)initAndLayoutSubview
{
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake( SCREEN_WIDTH/2.0f-alIvAvatarSize/2.0f, 100.0f, alIvAvatarSize, alIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [[ivAvatar layer] setCornerRadius:btnCornerRadius];
    [ivAvatar setClipsToBounds:YES];
    
    
    
    lbName = [[UILabel alloc] initWithFrame:CGRectMake( 0, ivAvatar.ly_y+CGRectGetHeight(ivAvatar.frame)+10.0f, SCREEN_WIDTH, alLbNameHeight)];
    [lbName setFont:lbNameFont];
    [lbName setTextColor:LyBlackColor];
    [lbName setTextAlignment:NSTextAlignmentCenter];
    
    
    
    tvRemind = [[UITextView alloc] initWithFrame:CGRectMake( 0, lbName.ly_y+CGRectGetHeight(lbName.frame)+70.0f, SCREEN_WIDTH, alTvRemindHeight)];
    [tvRemind setBackgroundColor:[UIColor clearColor]];
    [tvRemind setTextColor:[UIColor darkGrayColor]];
    [tvRemind setFont:tvRemindFont];
    [tvRemind setTextAlignment:NSTextAlignmentCenter];
    [tvRemind setEditable:NO];
    [tvRemind setScrollEnabled:NO];
    
    
    wvGif = [[UIWebView alloc] initWithFrame:CGRectMake( 0, SCREEN_HEIGHT-wvGifHeight, SCREEN_WIDTH, wvGifHeight)];
    [wvGif setBackgroundColor:LyWhiteLightgrayColor];
    [wvGif setOpaque:NO];
    [wvGif setUserInteractionEnabled:NO];

    dataReq = [NSURLRequest requestWithURL:[NSURL URLWithString:[LyUtil filePathForFileName:@"autoLogin.gif"]]];
    [wvGif loadRequest:dataReq];
    [wvGif sizeToFit];
    [self.view addSubview:wvGif];
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.30f target:self selector:@selector(alTargetForTimer) userInfo:nil repeats:YES];
    
    
    [self.view addSubview:ivAvatar];
    [self.view addSubview:lbName];
    
    [self loadUserInfo];
    
    if ( [self respondsToSelector:@selector(targetForAppDidBecomeActive:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(targetForAppDidBecomeActive:) name:LyAppDidBecomeActive object:nil];
    }
}


- (void)alTargetForTimer {
    [wvGif loadRequest:dataReq];
}




- (void)loadUserInfo
{
    NSString *strUserId   = [[NSUserDefaults standardUserDefaults] objectForKey:userId517Key_tc];
    NSString *strName     = [[NSUserDefaults standardUserDefaults] objectForKey:userName517Key_tc];
    
    
    [ivAvatar setImage:[LyUtil getAvatarFromDocumentWithUserId:strUserId]];
    
    if (![LyUtil validateString:strName]){
        lbName.text = LyLocalize(@"亲爱的517用户，你好！");
    } else {
        [lbName setText:strName];
    }
}





//显示需要升级的提示
- (void)showAlertForUpdate {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitleForUpdate
                                                                   message:alertMessageForUpdate
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:LyLocalize(@"退出")
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self dismissViewControllerAnimated:YES completion:nil];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:LyLocalize(@"登录")
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                flagGotoAppStore = YES;
                                                NSURL *url = [NSURL URLWithString:appStore_url];
                                                [LyUtil openUrl:url];
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)autoLogin
{

    NSString *strAccount  = [[NSUserDefaults standardUserDefaults] objectForKey:userAccount517Key_tc];
    NSString *strPassword = [[NSUserDefaults standardUserDefaults] objectForKey:userPassword517Key_tc];
    NSString *strUserType = [[NSUserDefaults standardUserDefaults] objectForKey:userTypeKey_tc];

    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:autoLoginHttpMethod_autoLogin];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:login_url
                                          body: @{
                                                  accountKey:strAccount,
                                                  passowrdKey:[LyUtil encodePassword:strPassword],
                                                  clientModeKey:strUserType,
                                                  versionKey:[LyUtil getApplicationVersionNoPoint]
                                                  }
                                          type:LyHttpType_asynPost
                                      timeOut:5.0f] boolValue];
}




- (void)analysisResult:(NSString *)userInfo
{
    NSDictionary *dic = [LyUtil getObjFromJson:userInfo];
    
    if (![LyUtil validateDictionary:dic]) {
        lastHttpMehtod = 0;
        tvRemind.text = LyLocalize(@"登录失败");
        [self doSomething:NO];
        
        return;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (![LyUtil validateString:strCode]) {
        lastHttpMehtod = 0;
        
        tvRemind.text = LyLocalize(@"登录失败");
        [self doSomething:NO];
        
        return;
    }
    
    switch ( [strCode intValue]) {
        case 0:
        {//成功
            NSDictionary *dicResult = [dic objectForKey:resultKey];
            if (![LyUtil validateDictionary:dicResult]) {
                tvRemind.text = LyLocalize(@"登录失败");
                [self doSomething:NO];
                return;
            }
            
            tvRemind.text = LyLocalize(@"欢迎回来");
            
            NSString *strSessionId = [dic objectForKey:sessionIdKey];
            
            NSString *strUserId = [dicResult objectForKey:userIdKey];
            NSString *strNickName = [dicResult objectForKey:nickNameKey];
            NSString *strAddress = [dicResult objectForKey:addressKey];
            NSString *strVerify = [dicResult objectForKey:verifyKey];
            NSString *strUserType = [dicResult objectForKey:userTypeKey];
            
            [LyUtil setHttpSessionId:strSessionId];
            
            
            [[LyCurrentUser curUser] setUserTypeWithString:strUserType];
            [[LyCurrentUser curUser] setUserId:strUserId];
            [[LyCurrentUser curUser] setUserPhoneNum:[[NSUserDefaults standardUserDefaults] objectForKey:userAccount517Key_tc]];
            [[LyCurrentUser curUser] setUserName:strNickName];
            [[LyCurrentUser curUser] setUserAddress:strAddress];
            [[LyCurrentUser curUser] setVerifyState:[strVerify integerValue]];
            
            
            if ([strUserType isEqualToString:@"jl"]) {
                NSString *strCoachMode = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:coachModeKey]];
                [[LyCurrentUser curUser] setCoachMode:[strCoachMode integerValue]];
            }
            
            
            [self getUserAvatarAsyn:strUserId];
            
            [[NSUserDefaults standardUserDefaults] setObject:strUserId forKey:userId517Key_tc];
            [[NSUserDefaults standardUserDefaults] setObject:strNickName forKey:userName517Key_tc];
            [[NSUserDefaults standardUserDefaults] setObject:strUserType forKey:userTypeKey_tc];
            [[NSUserDefaults standardUserDefaults] setObject:strVerify forKey:userVerifyKey_tc];
            
            [self doSomething:YES];
            
            break;
        }
        case 1: {
            //无此帐号
            tvRemind.text = LyLocalize(@"登录失败");
            [self doSomething:NO];
            
            break;
        }
        case 2: {
            //密码错误
            tvRemind.text = LyLocalize(@"登录失败");
            [self doSomething:NO];
            
            break;
        }
        case 3: {
            //帐户类型错误
            tvRemind.text = LyLocalize(@"登录失败");
            [self doSomething:NO];
            
            break;
        }
        case 4: {
            //客户端版本过低
            [self showAlertForUpdate];
            
            break;
        }
        default: {
            tvRemind.text = LyLocalize(@"登录失败");
            [self doSomething:NO];
            break;
        }
    }

}



- (void)getUserAvatarAsyn:(NSString *)userId
{
    [LyImageLoader loadAvatarWithUserId:userId
                               complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSString * _Nullable userId) {
                                   if (!image) {
                                       image = [LyUtil defaultAvatarForTeacher];
                                   }
                                   
                                   [[LyCurrentUser curUser] setUserAvatar:image];
                                   [LyUtil saveImage:image withUserId:userId withMode:LySaveImageMode_avatar];
                               }];
}




- (void)doSomething:(BOOL)isLogined {
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
                                                                                      
                                                                                      [self performSelector:@selector(autoLoginFinished:)
                                                                                                 withObject:[NSNumber numberWithBool:isLogined]
                                                                                                 afterDelay:1.0f];
                                                                                  }];
                                         }];
}



- (void)autoLoginFinished:(NSString *)isLogined
{
    if ([_delegate respondsToSelector:@selector(onAutoFinished:isLogined:)]) {
        [_delegate onAutoFinished:self isLogined:[isLogined boolValue]];
    }
}




#pragma mark -LyHttpRequestDelegate
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest {
    if ( bHttpFlag) {
        bHttpFlag = NO;
        lastHttpMehtod = 0;
        tvRemind.text = LyLocalize(@"登录失败");
        [self doSomething:NO];
    }
}



- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result {
    if ( bHttpFlag) {
        bHttpFlag = NO;
        lastHttpMehtod = [ahttpRequest mode];
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
