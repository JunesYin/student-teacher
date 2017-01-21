//
//  ViewController.m
//  teacher
//
//  Created by Junes on 16/7/12.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "ViewController.h"

#import "RESideMenu.h"
#import "Reachability.h"

#import "LyCurrentUser.h"

#import "LyGuideViewController.h"
#import "LyAutoLoginViewController.h"
#import "LyLoginViewController.h"
#import "LyRegisterFirstViewController.h"


#import "LyTabBarController.h"
#import "LyLeftMenuViewController.h"
#import "LyPopupMenuViewController.h"

#import "LyUtil.h"

CGFloat const indicatorSize = 30.0f;

CGFloat const btnItemHeight = 40.0f;
CGFloat const btnItemMargin = 20.0f;
#define btnItemWidth                ((SCREEN_WIDTH-btnItemMargin*4)/3.0f)
#define btnItemBackColor            [UIColor colorWithRed:51/255.0 green:14/255.0 blue:1/255.0f alpha:1.0]
#define btnItemTitleFont            LyFont(14)


CGFloat const btnRegisterWidth = 100.0f;
CGFloat const btnRegisterHeight = 30.0f;


typedef NS_ENUM( NSInteger, HomeButtonTag) {
    HomeButtonTag_loginCoach = 1,
    HomeButtonTag_loginSchool,
    HomeButtonTag_loginGuider,
    HomeButtonTag_register,
    HomeButtonTag_autoLogin
};


typedef NS_ENUM( NSInteger, alertViewTag)
{
    alertViewTag_network = 1,
//    alertViewTag_upgrade,
};



typedef NS_ENUM( NSInteger, httpMethod)
{
    httpMethod_lowestVersion = 10,
};


@interface ViewController () <UIAlertViewDelegate, RESideMenuDelegate, LyGuideViewControllerDelegate, LyAutoLoginViewControllerDelegate, LoginDelegate, LyHttpRequestDelegate>
{
    RESideMenu                  *sideMenu;
    LyTabBarController          *tabbarVC;
    LyLeftMenuViewController    *leftMenu;
    LyPopupMenuViewController   *popupMenu;
    
    
    UIButton                *btnLogin_coach;
    UIButton                *btnLogin_school;
    UIButton                *btnLogin_guider;
    UIButton                *btnRegister;
    
    Reachability            *reachNetStatus;
    
    NSString                *objectKeyForFirstLaunch;
    NSString                *flagForFisrtLaunch;
    
    BOOL                    flagForGuidePage;
    BOOL                    flagForAutoLogin;
    
    
    BOOL                    flagForGetAppVersion;
    
    
    BOOL                    flagForEnterBackground;
    BOOL                    flagForGotoAppStore;
    
    
    UIAlertView             *alertNetwork;
    
    UIActivityIndicatorView *indicator_loading;
    
    
    BOOL                    bHttpFlag;
    httpMethod              curHttpMethod;

}
@end

@implementation ViewController

lySingle_implementation(ViewController)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initAndLayoutSubviews];
    [self addNotificationObserver];
}


- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (!flagForGetAppVersion) {
        [self showIndicator_loading];
    }
}


- (void)viewDidAppear:(BOOL)animated {
    if ( !flagForGetAppVersion) {
        [self getLowestAppVersion];
    }
}



- (void)initAndLayoutSubviews {
    
    [LyUtil sharedInstance];
    
    [[self.view layer] setContents:(id)[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Default-ip6p" ofType:@"png"]] CGImage]];
    
    
    NSString *buildVersion = [LyUtil getApplicationBuildVersion];
    objectKeyForFirstLaunch = [[NSString alloc] initWithFormat:@"517Xueche_teacher%@", buildVersion];
    flagForFisrtLaunch = [[NSUserDefaults standardUserDefaults] objectForKey:objectKeyForFirstLaunch];
    
    
    btnLogin_coach = [[UIButton alloc] initWithFrame:CGRectMake(btnItemMargin, SCREEN_HEIGHT-btnItemHeight*2.0f, btnItemWidth, btnItemHeight)];
    [btnLogin_coach setTag:HomeButtonTag_loginCoach];
    [[btnLogin_coach layer] setCornerRadius:btnCornerRadius];
    [btnLogin_coach setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnLogin_coach setTitle:[[NSString alloc] initWithFormat:@"%@%@", LyLocalize(@"我是"), LyLocalize(@"教练")] forState:UIControlStateNormal];
    [[btnLogin_coach titleLabel] setFont:btnItemTitleFont];
    [btnLogin_coach setBackgroundColor:btnItemBackColor];
    [btnLogin_coach addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    btnLogin_school = [[UIButton alloc] initWithFrame:CGRectMake(btnItemMargin*2+btnItemWidth, SCREEN_HEIGHT-btnItemHeight*2.0f, btnItemWidth, btnItemHeight)];
    [btnLogin_school setTag:HomeButtonTag_loginSchool];
    [[btnLogin_school layer] setCornerRadius:btnCornerRadius];
    [btnLogin_school setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnLogin_school setTitle:[[NSString alloc] initWithFormat:@"%@%@", LyLocalize(@"我是"), LyLocalize(@"驾校")] forState:UIControlStateNormal];
    [[btnLogin_school titleLabel] setFont:btnItemTitleFont];
    [btnLogin_school setBackgroundColor:btnItemBackColor];
    [btnLogin_school addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    btnLogin_guider = [[UIButton alloc] initWithFrame:CGRectMake(btnItemMargin*3+btnItemWidth*2, SCREEN_HEIGHT-btnItemHeight*2.0f, btnItemWidth, btnItemHeight)];
    [btnLogin_guider setTag:HomeButtonTag_loginGuider];
    [[btnLogin_guider layer] setCornerRadius:btnCornerRadius];
    [btnLogin_guider setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnLogin_guider setTitle:[[NSString alloc] initWithFormat:@"%@%@", LyLocalize(@"我是"), LyLocalize(@"指导员")] forState:UIControlStateNormal];
    [[btnLogin_guider titleLabel] setFont:btnItemTitleFont];
    [btnLogin_guider setBackgroundColor:btnItemBackColor];
    [btnLogin_guider addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-btnRegisterWidth, SCREEN_HEIGHT-btnRegisterHeight, btnRegisterWidth, btnRegisterHeight)];
    [btnRegister setTag:HomeButtonTag_register];
    [[btnRegister layer] setCornerRadius:btnCornerRadius];
    [btnRegister setTitleColor:[UIColor colorWithRed:152/255.0 green:43/255.0 blue:0/255.0f alpha:1.0] forState:UIControlStateNormal];
    [btnRegister setTitle:LyLocalize(@"注册") forState:UIControlStateNormal];
    [[btnRegister titleLabel] setFont:LyFont(12)];
    [btnRegister setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnRegister addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:btnLogin_coach];
    [self.view addSubview:btnLogin_school];
    [self.view addSubview:btnLogin_guider];
    [self.view addSubview:btnRegister];
    
    
#if DEBUG
    UIButton *btnAutoLogin = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-btnItemHeight, btnItemWidth, btnItemHeight)];
    [btnAutoLogin setTag:HomeButtonTag_autoLogin];
    [btnAutoLogin addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnAutoLogin];
#endif
    
    
    [self setBtnFuncHidden:YES];
    
    
    
}


- (void)showIndicator_loading {
    if (!indicator_loading) {
        indicator_loading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f-indicatorSize/2.0f, SCREEN_HEIGHT*7/8.0f, indicatorSize, indicatorSize)];
        [indicator_loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        
        [self.view addSubview:indicator_loading];
        [indicator_loading startAnimating];
    }
}


- (void)removeIndicator_loading {
    [indicator_loading stopAnimating];
    [indicator_loading removeFromSuperview];
    indicator_loading = nil;
}


- (void)addNotificationObserver
{
    if ( [self respondsToSelector:@selector(targetForReachabilityChange:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(targetForReachabilityChange:) name:kReachabilityChangedNotification object:nil];
        
        reachNetStatus = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        [reachNetStatus startNotifier];
    }
    
    
    if ( [self respondsToSelector:@selector(targetForAppDidEnterBackground:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(targetForAppDidEnterBackground:) name:LyAppDidEnterBackground object:nil];
    }
    
    
    if ( [self respondsToSelector:@selector(targetForAppDidBecomeActive:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(targetForAppDidBecomeActive:) name:LyAppDidBecomeActive object:nil];
    }
    
    
    if ([self respondsToSelector:@selector(targetForUserLogout:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(targetForUserLogout:) name:LyNotificationForLogout object:nil];
    }
}






- (void)targetForButton:(UIButton *)button {
    if (HomeButtonTag_loginCoach == button.tag) {
        LyLoginViewController *login = [[LyLoginViewController alloc] init];
        [login setUserType:LyUserType_coach];
        [login setDelegate:self];
        UINavigationController *nvLogin = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nvLogin animated:YES completion:nil];
    } else if (HomeButtonTag_loginSchool == button.tag) {
        LyLoginViewController *login = [[LyLoginViewController alloc] init];
        [login setUserType:LyUserType_school];
        [login setDelegate:self];
        UINavigationController *nvLogin = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nvLogin animated:YES completion:nil];
    } else if (HomeButtonTag_loginGuider == button.tag) {
        LyLoginViewController *login = [[LyLoginViewController alloc] init];
        [login setUserType:LyUserType_guider];
        [login setDelegate:self];
        UINavigationController *nvLogin = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nvLogin animated:YES completion:nil];
    } else if (HomeButtonTag_register == button.tag) {
        LyRegisterFirstViewController *registerFirst = [[LyRegisterFirstViewController alloc] init];
        UINavigationController *nvRegister = [[UINavigationController alloc] initWithRootViewController:registerFirst];
        [self presentViewController:nvRegister animated:YES completion:nil];
    }
#if DEBUG
    else if (HomeButtonTag_autoLogin == button.tag) {
        [self autoLogin];
    }
#endif
    
}


//初始化完成，显示登录等按钮
- (void)setBtnFuncHidden:(BOOL)hidden
{
//    [btnLogin setHidden:hidden];
    [btnLogin_coach setHidden:hidden];
    [btnLogin_school setHidden:hidden];
    [btnLogin_guider setHidden:hidden];
    [btnRegister setHidden:hidden];
}



//是否可以自动登录
- (BOOL)rtAutoLogin
{
    if ( flagForAutoLogin){
        return NO;
    }
    
    flagForAutoLogin = YES;
    NSString *strUserType = [[NSUserDefaults standardUserDefaults] objectForKey:userTypeKey_tc];
    if (!strUserType) {
        return NO;
    }
    
    NSString *strVerify = [[NSUserDefaults standardUserDefaults] objectForKey:userVerifyKey_tc];
    if (!strVerify || ![strVerify isEqualToString:@"3"]) {
        return NO;
    }
    
    NSString *strAccount = [[NSUserDefaults standardUserDefaults] objectForKey:userAccount517Key_tc];
    if ( !strAccount) {
        return NO;
    }
    
    NSString *strAutoLoginFlag = [[NSUserDefaults standardUserDefaults] objectForKey:userAutoLoginFlagKey];
    if ( [strAutoLoginFlag isEqualToString:@"NO"]) {
        return NO;
    }
    
    return YES;
}

//选择第一个要显示的视图
- (void)rtSelectShowViewControoler {
    if ( [flagForFisrtLaunch isEqualToString:@"YES"]) {
        [self rtShowNextViewController];
    } else {
        if ( !flagForGuidePage) {
            flagForGuidePage = YES;
            
            [self showGuideVC];
        } else {
            [self rtShowNextViewController];
        }
        
    }
}

//选择接下来要显示的视图
- (void)rtShowNextViewController {
    if ( [self rtAutoLogin]) {
        [self autoLogin];
    } else {
        [self removeIndicator_loading];
        
        if ([[LyCurrentUser curUser] isLogined] && LyTeacherVerifyState_access == [LyCurrentUser curUser].verifyState) {
            [self setBtnFuncHidden:YES];
            [self showMainView];
        } else {
            [self setBtnFuncHidden:NO];
        }
    }
}


//显示需要升级的提示
- (void)showAlertViewForUpdate {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitleForUpdate
                                                                   message:alertMessageForUpdate
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                exit(0);
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"前往下载"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                flagForGotoAppStore = YES;
                                                NSURL *url = [NSURL URLWithString:appStore_url];
                                                [LyUtil openUrl:url];
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//显示可用网络的提示
- (void)showAlertViewForNetwork {
    if ( ![[LyUtil sharedInstance] isForbidRemindNetwork]) {
        if ( !alertNetwork) {
            alertNetwork = [[UIAlertView alloc] initWithTitle:alertTitleForWiFi
                                                      message:alertMessageForWiFi
                                                     delegate:self
                                            cancelButtonTitle:@"不再提醒"
                                            otherButtonTitles:@"设置", nil];
            [alertNetwork setTag:alertViewTag_network];
        }
        if (!alertNetwork.isVisible) {
            [alertNetwork show];
        }
    }
}


//关闭已显示的题示
- (void)dismissAlertViewWithTag:(alertViewTag)tag {
    switch (tag) {
        case alertViewTag_network: {
            if (alertNetwork.isVisible) {
                [alertNetwork dismissWithClickedButtonIndex:10 animated:YES];
            }
            break;
        }
    }
}



- (void)showGuideVC {
    LyGuideViewController *guide = [[LyGuideViewController alloc] init];
    [guide setDelegate:self];
    [self presentViewController:guide animated:NO completion:nil];
}


- (void)autoLogin {
    LyAutoLoginViewController *autoLogin = [[LyAutoLoginViewController alloc] init];
    [autoLogin setDelegate:self];
    [self presentViewController:autoLogin animated:YES completion:nil];
}


//进入主界面
- (void)showMainView {
    tabbarVC = [[LyTabBarController alloc] init];
    leftMenu = [[LyLeftMenuViewController alloc] init];
    popupMenu = [[LyPopupMenuViewController alloc] init];
    
    sideMenu = [[RESideMenu alloc] initWithContentViewController:tabbarVC leftMenuViewController:leftMenu rightMenuViewController:popupMenu];
    [sideMenu setMenuPreferredStatusBarStyle:1];
    [sideMenu setDelegate:self];
    [sideMenu setContentViewShadowColor:[UIColor blackColor]];
    [sideMenu setContentViewShadowOffset:CGSizeMake(horizontalSpace, verticalSpace)];
    [sideMenu setContentViewShadowOpacity:0.6];
    [sideMenu setContentViewShadowRadius:12];
    [sideMenu setContentViewShadowEnabled:YES];
    
    [tabbarVC setSideMenu:sideMenu];
    [leftMenu setDelegate:tabbarVC];
    [popupMenu setDelegate:tabbarVC];
    
    [self presentViewController:sideMenu animated:YES completion:^{
        [sideMenu setBackgroundImage:[LyUtil imageForImageName:@"sideMenuBackground" needCache:NO]];
    }];
}



//获取版本信息
- (void)getLowestAppVersion {
    flagForGetAppVersion = YES;
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:httpMethod_lowestVersion];
    [hr setDelegate:self];
    bHttpFlag = [hr startHttpRequest:lowestAppVersion_url
                                body:@{
                                       clientModeKey:@"jl",
                                       deviceModeKey:@"iOS"
                                       }
                                type:LyHttpType_asynPost
                             timeOut:3.0f];
}




- (void)handleHttpFailed {
    [self rtSelectShowViewControoler];
}


- (void)analysisHttpResult:(NSString *)result {
    NSDictionary *dic = [LyUtil getObjFromJson:result];
    if (![LyUtil validateDictionary:dic]) {
        curHttpMethod = 0;
        [self rtSelectShowViewControoler];
        return;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (![LyUtil validateString:strCode]) {
        [self rtSelectShowViewControoler];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    switch ( curHttpMethod) {
        case httpMethod_lowestVersion: {
            
            curHttpMethod = 0;
            
            NSString *strLowestAppVersion = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:lastestKey]];
            NSString *strNewestAppVersion = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:newestKey]];
            NSString *strCurrentAppVersion = [LyUtil getApplicationVersionNoPoint];
            
            [LyUtil setNewestAppVersion:strNewestAppVersion];
            
            if ( [strCurrentAppVersion intValue] < [strLowestAppVersion intValue]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本"
                                                                               message:@"你的客户端版本太旧，请下载最新客户端"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            exit(0);
                                                        }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"前往下载"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            flagForGotoAppStore = YES;
                                                            NSURL *url = [NSURL URLWithString:appStore_url];
                                                            [LyUtil openUrl:url];
                                                        }]];
                [self presentViewController:alert animated:YES completion:nil];
                
                return;
            } else {
                [self rtSelectShowViewControoler];
            }
            
            
            break;
        }
            
        default: {
            [self rtSelectShowViewControoler];
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

//网络状态
#pragma mark -kReachabilityChangedNotification
- (void)targetForReachabilityChange:(NSNotification *)notifi {
    Reachability *curReach = [notifi object];
    
    NetworkStatus curNetStatus = [curReach currentReachabilityStatus];
    
    switch ( curNetStatus) {
        case NotReachable:
        {
            if ( ![[LyUtil sharedInstance] isForbidRemindNetwork]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitleForWiFi
                                                                               message:alertMessageForWiFi
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"不再提醒"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [[LyUtil sharedInstance] setForbidRemindNetwork:YES];
                                                        }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"设置"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
                                                            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                                                [LyUtil openUrl:url];
                                                            } else {
                                                                [LyUtil showAlert:LyAlertViewForAuthorityMode_WiFi vc:self];
                                                            }
                                                        }]];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            break;
        }
        case ReachableViaWiFi: {
            NSLog(@"WiFi");
            break;
        }
        case ReachableViaWWAN:{
            NSLog(@"2G/3G/4G");
            break;
        }
            
        default:
            break;
    }
}


#pragma mark -LyAppDidEnterBackground
- (void)targetForAppDidEnterBackground:(NSNotification *)notification {
    
    flagForEnterBackground = YES;
}


#pragma mark -LyAppDidBecomeActive
- (void)targetForAppDidBecomeActive:(NSNotification *)notification {
    
    if (flagForEnterBackground) {
        flagForEnterBackground = NO;
        
        if ([LyUtil getApplicationVersionNoPoint].intValue < [LyUtil lowestAppVersion].intValue) {
            [self showAlertViewForUpdate];
            return;
        }
    }
    
}



//退出登录
#pragma mark LyNotificationForLogout
- (void)targetForUserLogout:(NSNotification *)nitifi
{
    [sideMenu dismissViewControllerAnimated:YES completion:^{
        
        [tabbarVC setSideMenu:nil];
        [leftMenu setDelegate:nil];
        [sideMenu setNil];
        
        tabbarVC = nil;
        sideMenu = nil;
        leftMenu = nil;
        [self setBtnFuncHidden:NO];
        
        [[LyCurrentUser curUser] logout];
        
        if (nitifi.object) {
            NSString *strObject = [[NSString alloc] initWithFormat:@"%@", nitifi.object];
            if ([strObject isEqualToString:LyNotificationForLogoutObjectAutoLogin]) {
                flagForAutoLogin = NO;
                [self performSelector:@selector(rtShowNextViewController) withObject:nil afterDelay:0.1f];
            } else {
                LyUserType userType = [LyUtil userTypeFromString:strObject];
                switch (userType) {
                    case LyUserType_normal: {
                        //nothing
                        break;
                    }
                    case LyUserType_coach: {
                        [self targetForButton:btnLogin_coach];
                        break;
                    }
                    case LyUserType_school: {
                        [self targetForButton:btnLogin_school];
                        break;
                    }
                    case LyUserType_guider: {
                        [self targetForButton:btnLogin_guider];
                        break;
                    }
                    default: {
                        //nothing
                        break;
                    }
                }
            }
        } else {
            [LyUtil setAutoLoginFlag:NO];
        }
    }];
}



//登录成功
#pragma mark LoginDelegate
- (void)loginDone:(LyLoginViewController *)vc {
    [vc dismissViewControllerAnimated:NO completion:^{
        [self rtShowNextViewController];
    }];
}


//自动登录完成
#pragma mark -LyAutoLoginViewController
- (void)onAutoFinished:(UIViewController *)vc isLogined:(BOOL)isLogined {
    [vc dismissViewControllerAnimated:YES completion:^{
        [self rtShowNextViewController];
    }];
}



//引导员显示完成
#pragma mark -LyGuideViewControllerDelegate
- (void)onClickButtonStartByGuideViewController:(LyGuideViewController *)aGuide {
    [aGuide dismissViewControllerAnimated:YES completion:^{
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:objectKeyForFirstLaunch];
        [self rtShowNextViewController];
    }];
}



#pragma mark RESideMenu Delegate
- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController {
    //    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController {
    //    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController {
    //    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController {
    //    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
    
}



- (BOOL)prefersStatusBarHidden {
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
