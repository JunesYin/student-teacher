//
//  LyRootViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/21.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyRootViewController.h"
#import "LyBottomControl.h"

#import "LyGuideViewController.h"
#import "LyTabBarViewController.h"
#import "LyAutoLoginViewController.h"


#import "LyUserCenterViewController.h"
#import "LyPopupMenuViewController.h"

#import "LyRemindView.h"
#import "LyActivity.h"


#import "LyCurrentUser.h"
#import "Reachability.h"
#import "RESideMenu.h"

#import "LyUtil.h"

#import "UIViewController+CloseSelf.h"



#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>




//7903984
//517学车
//xZscMN7FzRngDxAX1gWURHLG





CGFloat const rtIndicatorSize = 30.0f;

float const rtTimeInterval = 5.0f;




typedef NS_ENUM( NSInteger, LyRootAlertViewTag)
{
    rootAlertViewTag_network = 70,
    rootAlertViewTag_update,
    rootAlertViewTag_locationServiceClose,
    rootAlertViewTag_locationDenied
};

typedef NS_ENUM( NSInteger, LyRootHttpMethod)
{
    rootHttpMethod_loadAppVersion = 100,
};


@interface LyRootViewController () < CLLocationManagerDelegate, BMKGeneralDelegate, BMKLocationServiceDelegate, RESideMenuDelegate, LyGuideViewControllerDelegate, LyAutoLoginViewControllerDelegate, UIAlertViewDelegate, LyHttpRequestDelegate>
{
    BOOL                    flagBaiduMapLaunchSuccess;          //百度地图开启服务是否成功
    BMKMapManager           *_baiduMapManager;
    BMKLocationService      *baiduLocationService;
    
    
    Reachability            *reachNetStatus;
    
    NSString                *objectKeyForFirstLaunch;
    BOOL                    flagShowedGuideVC;
    
    BOOL                    flagForAutoLoginVC;                 //是否已自动登录过
    
    BOOL                    flagForGetAppVersion;               //是否已获取过服务器版本号
    
    BOOL                    flagForEnterBackground;             //之前是否进入了后台
//    BOOL                    flagForGotoAppStore;                //是否跳转至App Store
    
    
    BOOL                    flagForLocationServicesEnable;      //定位服务是否可用
    CLAuthorizationStatus   locationAuthStatus;                 //用户对本应用的定位授权状态
    NSTimer                 *timer;                             //自动定拉计时器
    
    UIAlertView             *alertNetwork;
    UIAlertView             *alertLocationClose;
    UIAlertView             *alertLocationDenied;
    
    
    UIActivityIndicatorView *indicator_appVer;                  //刚进入应用读取indicator
    BOOL                    bHttpFlag;
    LyRootHttpMethod        curHttpMethod;
}
@end

@implementation LyRootViewController


lySingle_implementation(LyRootViewController)

static NSString *const baiduMapAppId = @"8097803";
static NSString *const baiduMapKey = @"AfrvFaQDgrNqdHfeMsNEDSROL0X7Hr3x";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self rtInit];
    
    [self rtAddNotificationObserver];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    if (!indicator_appVer) {
        indicator_appVer = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f-rtIndicatorSize/2.0f, SCREEN_HEIGHT*7/8.0f, rtIndicatorSize, rtIndicatorSize)];
        [indicator_appVer setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        
        [self.view addSubview:indicator_appVer];
        [indicator_appVer startAnimating];
    }
    
    if (kCLAuthorizationStatusNotDetermined == locationAuthStatus) {
        locationAuthStatus = [CLLocationManager authorizationStatus];
    }
    
}


- (void)viewDidAppear:(BOOL)animated {
    if ( !flagForGetAppVersion) {
        [self getLowestAppVersion];
    }
}

- (void)rtAddNotificationObserver {
    
    if ( [self respondsToSelector:@selector(rtTargetForReachabilityChange:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rtTargetForReachabilityChange:) name:kReachabilityChangedNotification object:nil];
        
        reachNetStatus = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        [reachNetStatus startNotifier];
    }
    
    
    if ( [self respondsToSelector:@selector(rtTargetForAppDidEnterBackground:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rtTargetForAppDidEnterBackground:) name:LyAppDidEnterBackground object:nil];
    }
    
    
    if ( [self respondsToSelector:@selector(rtTargetForAppDidBecomeActive:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rtTargetForAppDidBecomeActive:) name:LyAppDidBecomeActive object:nil];
    }
    
    
    if ( [self respondsToSelector:@selector(rtTargetForRequestLocate:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rtTargetForRequestLocate:) name:LyNofiticationForRequestLocate object:nil];
    }
}


- (void)rtInit
{
    [LyUtil sharedInstance];
    
    UIImageView *ivBack = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [ivBack setContentMode:UIViewContentModeScaleToFill];
    [ivBack setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Default-ip6p" ofType:@"png"]]];
    [self.view addSubview:ivBack];
    
    
    NSString *buildVersion = [LyUtil getApplicationBuildVersion];
    objectKeyForFirstLaunch = [[NSString alloc] initWithFormat:@"517Xueche_student%@", buildVersion];
//    flagForFisrtLaunch = [[NSUserDefaults standardUserDefaults] objectForKey:objectKeyForFirstLaunch];
    NSString *sqlVersion = [[NSString alloc] initWithFormat:@"SELECT COUNT(version) AS num FROM %@ WHERE version = '%@'",
                     LyRecordTableName_guide,
                     [LyUtil getApplicationVersion]];
    FMResultSet *rsVersion = [[LyUtil dbRecord] executeQuery:sqlVersion];
    while ([rsVersion next]) {
        int iCount = [rsVersion intForColumn:@"num"];
        if (iCount) {
            flagShowedGuideVC = YES;
        }
        break;
    }
    
    //百度地图相关
    _baiduMapManager = [[BMKMapManager alloc] init];
    flagBaiduMapLaunchSuccess = [_baiduMapManager start:baiduMapKey generalDelegate:self];
    
    baiduLocationService = [[BMKLocationService alloc] init];
    [baiduLocationService setDelegate:self];
    
    
    [[RESideMenu sharedInstance] setContentViewController:[LyTabBarViewController sharedInstance]];
    [[RESideMenu sharedInstance] setLeftMenuViewController:[LyUserCenterViewController sharedInstance]];
    [[RESideMenu sharedInstance] setRightMenuViewController:[LyPopupMenuViewController sharedInstance]];

    
    [[RESideMenu sharedInstance] setBackgroundImage:[[LyUtil imageForImageName:@"Stars" needCache:NO] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[RESideMenu sharedInstance] setMenuPreferredStatusBarStyle:1];
    [[RESideMenu sharedInstance] setDelegate:self];
    [[RESideMenu sharedInstance] setContentViewShadowColor:[UIColor blackColor]];
    [[RESideMenu sharedInstance] setContentViewShadowOffset:CGSizeZero];
    [[RESideMenu sharedInstance] setContentViewShadowOpacity:0.6];
    [[RESideMenu sharedInstance] setContentViewShadowRadius:12];
    [[RESideMenu sharedInstance] setContentViewShadowEnabled:YES];
    
    
    locationAuthStatus = [CLLocationManager authorizationStatus];
    flagForLocationServicesEnable = [CLLocationManager locationServicesEnabled];

}



- (void)refreshUserLocation {
//    NSLog(@"开始定位");
    
    if (kCLAuthorizationStatusNotDetermined == locationAuthStatus) {
        CLLocationManager *lm = [[CLLocationManager alloc] init];
        [lm requestWhenInUseAuthorization];
    } else {
        [baiduLocationService startUserLocationService];
    }
}


- (BOOL)rtJudgeAutoLotin {
    
    if ( flagForAutoLoginVC) {
        return NO;
    }
    
    flagForAutoLoginVC = YES;
    NSString *strAccount = [[NSUserDefaults standardUserDefaults] objectForKey:userAccount517Key];
    if ( !strAccount) {
        return NO;
    }
    
    NSString *strAutoLoginFlag = [[NSUserDefaults standardUserDefaults] objectForKey:userAutoLoginFlagKey];
    if ( [strAutoLoginFlag isEqualToString:@"NO"]) {
        return NO;
    }
    
    return YES;
}


//选择接下来要显示的
- (void)rtShowNextViewController {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    if ( [self rtJudgeAutoLotin]) {
        LyAutoLoginViewController *autoLogin = [[LyAutoLoginViewController alloc] init];
        [self presentViewController:autoLogin animated:YES completion:^{
            [autoLogin setDelegate:self];
        }];
    } else {
        [indicator_appVer stopAnimating];
        [indicator_appVer removeFromSuperview];
        indicator_appVer = nil;
        
        dispatch_queue_t globalQueue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async( globalQueue, ^{
            [[LyActivity sharedInstance] go];
        });
        
        timer = [NSTimer scheduledTimerWithTimeInterval:rtTimeInterval
                                                 target:self
                                               selector:@selector(refreshUserLocation)
                                               userInfo:nil
                                                repeats:YES];
        
        [self presentViewController:[RESideMenu sharedInstance] animated:YES completion:nil];
        
    }
}


//选择第一次要显示的
- (void)rtSelectShowViewControoler {
    
    if (flagShowedGuideVC) {
        [self rtShowNextViewController];
    } else {
        flagShowedGuideVC = YES;
        
        LyGuideViewController *guide = [[LyGuideViewController alloc] init];
        [guide setDelegate:self];
        [self presentViewController:guide animated:YES completion:^{
            NSString *sqlInsert = [[NSString alloc] initWithFormat:@"INSERT INTO %@ \
                                   (version) VALUES \
                                   ('%@')",
                                   LyRecordTableName_guide,
                                   [LyUtil getApplicationVersion]];
            BOOL flag = [[LyUtil dbRecord] executeUpdate:sqlInsert];
        }];

    }
}


//添加每隔时间定位一次的定时器
- (void)addTimerForLocate {
    
}


//显示需要升级的提示
- (void)showAlertViewForUpdate {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请更新客户端"
                                                    message:@"你的客户端版本太旧，请下载最新客户端"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"前往下载", nil];
    [alert setTag:rootAlertViewTag_update];
    [alert show];
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
            [alertNetwork setTag:rootAlertViewTag_network];
        }
        if (!alertNetwork.isVisible) {
            [alertNetwork show];
        }
    }
}

//显示定位服务被关闭的提示
- (void)showAlertViewForLocationServieClosed {
    if ( !alertLocationClose) {
        alertLocationClose = [[UIAlertView alloc] initWithTitle:alertTitleForLocatoinService
                                                        message:alertMessageForLocationService
                                                       delegate:self
                                              cancelButtonTitle:@"不再提醒"
                                              otherButtonTitles:@"设置", nil];
        [alertLocationClose setTag:rootAlertViewTag_locationServiceClose];
    }
    
    if ( ![alertLocationClose isVisible]) {
        [alertLocationClose show];
    }
}

//显示用户已禁止访问定位信息的提示
- (void)showAlertViewForLocatoinDenied {
    if ( ![[LyUtil sharedInstance] isForbidRemindNetwork]) {
        if ( !alertNetwork) {
            alertNetwork = [[UIAlertView alloc] initWithTitle:alertTitleForWiFi
                                                      message:alertMessageForWiFi
                                                     delegate:self
                                            cancelButtonTitle:@"不再提醒"
                                            otherButtonTitles:@"设置", nil];
            [alertNetwork setTag:rootAlertViewTag_network];
        }
        if (!alertNetwork.isVisible) {
            [alertNetwork show];
        }
    }
}


//关闭已显示的题示
- (void)dismissAlertViewWithTag:(LyRootAlertViewTag)tag {
    switch (tag) {
        case rootAlertViewTag_network: {
            if (alertNetwork.isVisible) {
                [alertNetwork dismissWithClickedButtonIndex:10 animated:YES];
            }
            break;
        }
        case rootAlertViewTag_update: {
            //nothing
            break;
        }
        case rootAlertViewTag_locationServiceClose: {
            if (alertLocationClose.isVisible) {
                [alertLocationClose dismissWithClickedButtonIndex:10 animated:YES];
            }
            break;
        }
        case rootAlertViewTag_locationDenied: {
            if (alertLocationDenied.isVisible) {
                [alertLocationDenied dismissWithClickedButtonIndex:10 animated:YES];
            }
            break;
        }
        default: {
            
            break;
        }
    }
}



//从服务器获取客户端版本信息
- (void)getLowestAppVersion {
    flagForGetAppVersion = YES;
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:rootHttpMethod_loadAppVersion];
    [hr setDelegate:self];
    bHttpFlag = [hr startHttpRequest:lowestAppVersion_url
                                body:@{
                                       clientModeKey:@"xy",
                                       deviceModeKey:@"ios"
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
        [self handleHttpFailed];
        return;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (![LyUtil validateString:strCode]) {
        [self handleHttpFailed];
        return;
    }
    
    
    switch ( curHttpMethod) {
        case rootHttpMethod_loadAppVersion: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSString *strLowestAppVersion = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:lastestKey]];
                    NSString *strNewestAppVersion = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:newestKey]];
                    
                    [LyUtil setNewestAppVersion:strNewestAppVersion];
                    [LyUtil setLowestAppVersion:strLowestAppVersion];
                    
                    if ([LyUtil getApplicationVersionNoPoint].intValue < strLowestAppVersion.intValue) {
                        [self showAlertViewForUpdate];
                        return;
                    }
                    
                    [self handleHttpFailed];
                    
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



#pragma mark -LyAutoLoginViewController
- (void)onAutoFinished:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:^{
        [self rtSelectShowViewControoler];
    }];
}



#pragma mark -LyGuideViewControllerDelegate
- (void)onClickButtonStart:(LyGuideViewController *)aGuideVC {
    [aGuideVC dismissViewControllerAnimated:NO completion:^{
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:objectKeyForFirstLaunch];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self rtShowNextViewController];
    }];
}



#pragma mark -kReachabilityChangedNotification
- (void)rtTargetForReachabilityChange:(NSNotification *)notification
{
    Reachability *curReach = [notification object];
    
    NetworkStatus curNetStatus = [curReach currentReachabilityStatus];
    [LyUtil networkStatusChanged:curNetStatus];
    
    switch (curNetStatus) {
        case NotReachable: {
            [self showAlertViewForNetwork];
            break;
        }
        case ReachableViaWiFi: {
            NSLog(@"WiFi");
            [self dismissAlertViewWithTag:rootAlertViewTag_network];
            break;
        }
        case ReachableViaWWAN: {
            NSLog(@"2G/3G/4G");
            [self dismissAlertViewWithTag:rootAlertViewTag_network];
            break;
        }
    }
}


#pragma mark -LyAppDidEnterBackground
- (void)rtTargetForAppDidEnterBackground:(NSNotification *)notification {
    
    flagForEnterBackground = YES;
    [timer invalidate];
    timer = nil;
}


#pragma mark -LyAppDidBecomeActive
- (void)rtTargetForAppDidBecomeActive:(NSNotification *)notification {
    
    if (flagForEnterBackground) {
        flagForEnterBackground = NO;
        
        if ([LyUtil getApplicationVersionNoPoint].intValue < [LyUtil lowestAppVersion].intValue) {
            [self showAlertViewForUpdate];
            return;
        } else {
            
            if (arc4random() % 1000 > 990) {
                [self rtSelectShowViewControoler];
            }
            timer = [NSTimer scheduledTimerWithTimeInterval:rtTimeInterval
                                                     target:self
                                                   selector:@selector(refreshUserLocation)
                                                   userInfo:nil
                                                    repeats:YES];
            
            if (!flagForLocationServicesEnable && [CLLocationManager locationServicesEnabled]) {
                
                flagForLocationServicesEnable = YES;
                
                [_baiduMapManager stop];
                [NSThread sleepForTimeInterval:sleepTime];
                flagBaiduMapLaunchSuccess = [_baiduMapManager start:baiduMapKey generalDelegate:self];
                
                baiduLocationService = [[BMKLocationService alloc] init];
                [baiduLocationService setDelegate:self];
                
                if (flagBaiduMapLaunchSuccess) {
                    [self performSelector:@selector(refreshUserLocation) withObject:nil afterDelay:sleepTime];
                }
            }
        }
    }

}


//地图视图要求马上定位
#pragma mark -LyNofiticationForRequestLocate
- (void)rtTargetForRequestLocate:(NSNotification *)notification {
    
    [self refreshUserLocation];
}


#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( rootAlertViewTag_network == [alertView tag]) {
        if ( 0 == buttonIndex) {
            [[LyUtil sharedInstance] setForbidRemindNetwork:YES];
        } else if ( 1 == buttonIndex) {
            NSURL *url = [NSURL URLWithString:[LyUtil LyURLSchemeForWIFI]];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [LyUtil openUrl:url];
            } else {
                [LyUtil showAlert:LyAlertForAuthorityMode_WiFi vc:self];
            }
            
        }
        
    } else if ( rootAlertViewTag_update == [alertView tag]) {
        if ( 1 == buttonIndex) {
//            flagForGotoAppStore = YES;
            NSURL *url = [NSURL URLWithString:appStore_url];
            [LyUtil openUrl:url];
        } else {
            exit(0);
        }
        
    } else if ( rootAlertViewTag_locationServiceClose == [alertView tag]) {
        if ( 0 == buttonIndex) {
            [[LyUtil sharedInstance] setForbidRemindLocate:YES];
        } else {
            NSURL *url = [NSURL URLWithString:[LyUtil LyURLSchemeForLOCATION_SERVICES]];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [LyUtil openUrl:url];
            } else {
                [LyUtil showAlert:LyAlertForAuthorityMode_locationService vc:self];
            }
        }
        
    } else if ( rootAlertViewTag_locationDenied == [alertView tag]) {
        if ( 0 == buttonIndex) {
            [[LyUtil sharedInstance] setForbidRemindLocate:YES];
        } else {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [LyUtil openUrl:url];
            } else {
                [LyUtil showAlert:LyAlertForAuthorityMode_locate vc:self];
            }
        }
    }
}



#pragma mark -BMKLocationServiceDelegate
/**
 *  百度地图定位protocol--BMKLocationServiceDelegate
 */

//在将要启动定位时，会调用此函数
- (void)willStartLocatingUser {
    
}


//在停止定位后，会调用此函数
- (void)didStopLocatingUser {
//    BMKUserLocation *userLocation = [baiduLocationService userLocation];
//
//    if (/*userLocation.isUpdating && */userLocation.location) {
//
////        [userLocation setValue:[[CLLocation alloc] initWithLatitude:20.0f longitude:105.0f] forKey:@"location"];
//        
//        [self dismissAlertViewWithTag:rootAlertViewTag_locationServiceClose];
//        [self dismissAlertViewWithTag:rootAlertViewTag_locationDenied];
//        
//        [[LyCurrentUser curUser] setLocationWithLocation:[userLocation location]];
//        [[NSNotificationCenter defaultCenter] postNotificationName:LyNotificationForLocationChanged object:userLocation];
//    }
    
}


//用户方向更新后，会调用此函数--@param userLocation 新的用户位置
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    //    NSLog(@"rt--didUpdateUserHeading");
    
    [baiduLocationService stopUserLocationService];
    
}


//用户位置更新后，会调用此函数--@param userLocation 新的用户位置
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"rt--didUpdateBMKUserLocation");
    
    [baiduLocationService stopUserLocationService];
    
    if (/*userLocation.isUpdating && */userLocation.location) {
        
        [self dismissAlertViewWithTag:rootAlertViewTag_locationServiceClose];
        [self dismissAlertViewWithTag:rootAlertViewTag_locationDenied];
        
        [[LyCurrentUser curUser] setLocationWithLocation:[userLocation location]];
        [[NSNotificationCenter defaultCenter] postNotificationName:LyNotificationForLocationChanged object:userLocation];
    }
}


//定位失败后，会调用此函数--@param error 错误号
- (void)didFailToLocateUserWithError:(NSError *)error {
    if ( ![[LyUtil sharedInstance] isForbidRemindLocate]) {
        
        if ( !flagForLocationServicesEnable) {
            [self showAlertViewForLocationServieClosed];
        } else if ( kCLAuthorizationStatusDenied == [CLLocationManager authorizationStatus]) {
            [self showAlertViewForLocatoinDenied];
        }
    }
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
    [[LyTabBarViewController sharedInstance] pushSomeViewController];
}




- (BOOL)prefersStatusBarHidden {
    return YES;
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
