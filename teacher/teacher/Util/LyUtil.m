//
//  LyUtil.m
//  LyMusic
//
//  Created by Junes on 16/3/4.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyUtil.h"
#import "AESCrypt.h"
#import "LyMacro.h"


#import "LyRemindView.h"
#import "LyMaintainingView.h"
#import "UIViewController+Utils.h"

#import "NSString+Emoji.h"

#import "LyCurrentUser.h"

#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>




CGFloat const LyViewErrorHeight = 400;
CGFloat const LyViewNullHeight = 400;

CGFloat const LyNullItemHeight = 40.0f;
CGFloat const LyLbNullHeight = 200.0f;
CGFloat const LyLbErrorHeight = 200.0f;


NSString *const alertTitleForUpdate = @"请更新";
//#define alertTitleForWiFi                           [LyUtil getAppDisplayName]
NSString *const alertTitleForAddressBook = @"无法访问通讯录";
NSString *const alertTitleForAlbum = @"无法访问照片";
NSString *const alertTitleForCamera = @"无法访问相机";
NSString *const alertTitleForNotification = @"打开通知";
NSString *const alertTitleForLocatoinService = @"打开定位服务";
NSString *const alertTitleForLocate = @"无法访问位置";


NSString *const alertMessageForUpdate = @"客户端版本太旧，请下载最新客户端";
NSString *const alertMessageForWiFi = @"请前往系统【设置】>【Wi-Fi】或【蜂窝移动网络】连接网络";
//#define alertMessageForAddressBook                  [[NSString alloc] initWithFormat:@"请前往系统【设置】>【稳私】>【通讯录】允许“%@”访问通讯录", [LyUtil getAppDisplayName]]
//#define alertMessageForAlbum                        [[NSString alloc] initWithFormat:@"请前往系统【设置】>【稳私】>【照片】允许“%@”访问照片", [LyUtil getAppDisplayName]]
//#define alertMessageForCamera                       [[NSString alloc] initWithFormat:@"请前往系统【设置】>【稳私】>【相机】允许“%@”访问相机", [LyUtil getAppDisplayName]]
//#define alertMessageForNotificaion                  [[NSString alloc] initWithFormat:@"请前往系统【设置】>【通知】>【%@】打开“允许通知”", [LyUtil getAppDisplayName]]
NSString *const alertMessageForLocationService = @"请前往系统【设置】>【隐私】>【定位服务】打开开关";
//#define alertMessageForLocate                       [[NSString alloc] initWithFormat:@"请前往系统【设置】>【隐私】>【定位服务】>【%@】允许“%@”访问位置信息", [LyUtil getAppDisplayName]]





CGFloat const maxPicWidth = 800.0f;
CGFloat const maxPicHeight = 1420.0f;
CGFloat const maxPicWidth_WiFi = 1000.0f;
CGFloat const maxPicHeight_WiFi = 1775.0f;


CGFloat const controlViewUsefulHeight = 200.0f;
CGFloat const controlToolBarHeight = 40.0f;
CGFloat const controlPickerHeight = 160.0f;
CGFloat const controlPickerRowHeight = 30.0f;
//#define controlPickerRowTitleFont                           LyFont(14)


CGFloat const avatarSizeMax = 500;


#pragma mark 字数限制
int const remarkMaxCount = 20;


CGFloat const btnCornerRadius = 5.0f;



CGFloat const LyBtnMoreHeight = 30.0f;
CGFloat const LyBtnMoreWidth = 60.0f;


NSTimeInterval const LyAnimationDuration = 0.3f;
NSTimeInterval const LyDelayTime = 0.1f;


CGFloat const LyViewHeaderHeight = 200.0f;
CGFloat const LyViewItemHeight = 50.0f;
CGFloat const LyLbTitleItemWidth = 80.0f;
CGFloat const LyLbTitleItemHeight = LyViewItemHeight;
//#define LyLbTitleItemFont                               LyFont(16)


int const detailEvaOrConCount = 2;

float const minFiveStar = 4.75;
float const everyHalfStarLimit = 0.5;

int const autoLoadMoreMaxCount = 2;


int const driveSchoolListMaxCount = 100;
int const coachListMaxCount = 100;
int const guiderListMaxCount = 100;

float const showDistanceMax = 50000.0f;


int const coordinateRandBase = 10000;
float const coordinateRandBase_all = 1000000.0f;
float const coordinateRandBase_search = 100000.0f;


NSString *const LyNofiticationForRequestLocate = @"LyNofiticationForRequestLocate";
NSString *const LyNotificationForLocationChanged = @"LyNotificationForLocationChanged";
NSString *const LyNotificationForAddressTranslated = @"LyNotificationForAddressTranslated";
NSString *const LyNotificationForHttpRequest = @"LyNotificationForHttpRequest";
NSString *const LyNotificationForUserCenterPush = @"LyNotificationForUserCenterPush";

NSString *const LyAppDidEnterBackground = @"LyAppDidEnterBackground";
NSString *const LyAppDidBecomeActive = @"LyAppDidBecomeActive";
NSString *const LyNotificationForLogout = @"LyNotificationForLogout";

NSString *const LyNotificationForLogoutObjectAutoLogin = @"LyNotificationForLogoutObjectAutoLogin";

NSString *const LyNotificationForJumpReady = @"LyNotificationForJumpReady";


NSString *const areaKey = @"area";
NSString *const provinceKey = @"province";
NSString *const cityKey = @"city";
NSString *const districtKey = @"district";


NSString *const currentUserKey = @"currentUser";
NSString *const userKey = @"user";
NSString *const coachKey = @"coach";
NSString *const schoolKey = @"school";
NSString *const guiderKey = @"guider";



NSString *const lbNameWhole = @"付全款报名";
NSString *const lbNamePrepay = @"预付费报名";


NSString *const phoneNum_517 = @"400-8040-517";
NSString *const messageNum_517 = @"17321049517";


CGFloat const horizontalSpace = 10.0f;
CGFloat const verticalSpace = 5.0f;




CGFloat const imageSizeMaxWidth = 400.0f;
CGFloat const imageSizeMaxHeight = 750.0f;


CGFloat const sparaterLineHeight = 5.0f;

CGFloat const LyHorizontalLineHeight = 2.0f;


NSString *const autoJumpToNexFlag = @"autoJumpToNexFlag";
NSString *const autoExcludeFlag = @"autoExcludeFlag";


CGFloat const bottomControlHideCerticality = 10.0f;


NSString *const goodKey = @"good";
NSString *const teacherKey = @"teacher";

NSString *const LyFooterTitle_error = @"出错了";

NSString *const mapBtnLocateDefaultTitle = @"正在获取...";

NSString *const LyIndicatorTitle_load = @"正在加载...";
NSString *const LyIndicatorTitle_upload = @"正在上传...";
NSString *const LyIndicatorTitle_modify = @"正在修改...";
NSString *const LyIndicatorTitle_cancel = @"正在取消...";
NSString *const LyIndicatorTitle_delete = @"正在删除...";
NSString *const LyIndicatorTitle_confirm = @"正在确认...";
NSString *const LyIndicatorTitle_evaluate = @"正在评价...";
NSString *const LyIndicatorTitle_attente = @"正在关注...";
NSString *const LyIndicatorTitle_deattente = @"正在取关...";
NSString *const LyIndicatorTitle_commit = @"正在提交...";
NSString *const LyIndicatorTitle_replace = @"正在更换...";
NSString *const LyIndicatorTitle_transmit = @"正在转发...";
NSString *const LyIndicatorTitle_add = @"正在添加...";
NSString *const LyIndicatorTitle_verify = @"正在验证...";
NSString *const LyIndicatorTitle_reply = @"正在回复...";

NSString *const LyRemindTitle_sensitiveWord = @"含有敏感信息";


int const LyUserIdLength = 36;
int const LyAccountLength = 11;
int const LyAuthCodeLength = 6;
int const LyPasswordLengthMin = 6;
int const LyPasswordLengthMax = 18;
int const LyNewsLengthMax = 500;
int const LyEvaluationLengthMax = 200;
int const LySignatureLengthMax = 20;
int const LyReplyLengthMax = 50;
int const LyNameLengthMax = 10;
int const LyPriceLengthMax = 5;

NSTimeInterval const validateSensitiveWordDelayTime = 0.05f;
NSTimeInterval const closeDelayTime = 0.1f;

int const dateStringLength = 10;


CGFloat const lbItemHeight = 20.0f;
CGFloat const btnCloseSize = 20.0f;
CGFloat const ivMoreSize = 20.0f;


CGFloat const LyChatCellHeightMin = 10;
CGFloat const LyChatCellHeightMax = 1000;


@interface LyUtil ()
{

    
    NSMutableData       *receiveData;
    
    
}
@end




@implementation LyUtil


lySingle_implementation(LyUtil)

static BOOL isReady = NO;
//static BOOL isLaunchByPush = NO;


static BOOL timeFlag = YES;


static NSDictionary *dicInfoPlist = nil;
static NSString *appBunleIdentifier = nil;
static NSString *appVersion = nil;
static NSString *appVersionNoPoint = nil;
static NSString *appBuildVersion = nil;
static NSString *appUrlScheme = nil;
static NSString *appDisplayName = nil;


static NSString *bundlePath = nil;
static NetworkStatus currentNetworkStatus = NotReachable;



static NSCalendar *calendar = nil;

#pragma mark 会话id
static NSString *httpSessionId = nil;

#pragma mark 是否已成功获取用户信息
static BOOL flagForGetUserInfo = NO;

#pragma mark 最新版本
static NSString *newestAppVersion = nil;
#pragma mark 当前支持的最低版本号
static NSString *lowestAppVersion = nil;



static NSDateFormatter *dateFormatterForYMD = nil;
static NSDateFormatter *dateFormatterForAll = nil;
static NSDateFormatter *dateFormatterForAllTest = nil;


#pragma mark 驾照类型
static NSArray *arrDriveLicenses = nil;
static NSArray *arrTrainModes = nil;
static NSArray *arrPickModes = nil;
static NSArray *arrSubjectMode = nil;
static NSArray *arrSubjectModePrac = nil;
static NSArray *arrPayInfo = nil;
static NSArray *arrWeekdays = nil;


#pragma mark 默认头像
static UIImage *defaultAvatarForStudent = nil;
static UIImage *defaultAvatarForTeacher = nil;


static BOOL isKeybaordShowing = NO;

- (instancetype)init
{
    if ( self = [super init])
    {
        
        [self addObserverForKeybaord];
        
        arrDriveLicenses = @[
                             @"C1",
                             @"C2",
                             @"C3",
                             @"C4",
                             @"C5",
                             
                             @"A1",
                             @"A3",
                             @"B1",
                             
                             @"B2",
                             @"A2",
                             
                             @"D",
                             @"E",
                             @"F"];
        
        arrTrainModes = @[
                          @"一人一车",
                          @"多人一车",
//                          @"四人一车",
                          ];
        
        arrPickModes = @[
                         @"不接送",
                         @"班车接送"
                         ];
        
        
        arrSubjectMode = @[
                           @"科一",
                           @"科二",
                           @"科三",
                           @"科四",
                           @"拿本"
                           ];
        
        arrSubjectModePrac= @[
                              @"科目二",
                              @"科目三"
                              ];
        
        
        arrPayInfo = @[
                       @"已付全款",
                       @"已付预报名费",
                       @"未付款"
                       ];
        
        
        arrWeekdays = @[
                        @"周一",
                        @"周二",
                        @"周三",
                        @"周四",
                        @"周五",
                        @"周六",
                        @"周日",
                        ];
    }
    
    return self;
}



- (void)dealloc {
    [self removeObserverForKeyboard];
}

- (void)addObserverForKeybaord {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(actionForKeyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(actionForKeybarodDidHide)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)removeObserverForKeyboard {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}



#pragma mark Push
+ (BOOL)isReady {
    return isReady;
}

+ (void)ready:(BOOL)flag target:(__kindof UIViewController *)target {
    if (!isReady && flag && target) {
        isReady = flag;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LyNotificationForJumpReady object:target];
    }
    
    isReady = flag;
}



#pragma mark - timeFlag
+ (BOOL)timeFlag {
    return timeFlag;
}


#pragma mark 键盘
+ (BOOL)isKeybaordShowing {
    return isKeybaordShowing;
}



#pragma mark 机器及系统信息
+ (NSString *)machineName {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPod Touch 6G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad Mini 4G";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad Mini 4G";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro (9.7 inch)";
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro (9.7 inch)";
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro (12.9 inch)";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro (12.9 inch)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}
+ (NSString *)osName
{
    return [[NSString alloc] initWithFormat:@"%@%@", [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
}
+ (float)osVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}




#pragma mark iOS 10干掉了所的有 Url Scheme
+ (void)showAlert:(LyAlertViewForAuthorityMode)mode vc:(__kindof UIViewController *)vc {
    NSString *title = nil;
    NSString *message = nil;
    
    switch (mode) {
        case LyAlertViewForAuthorityMode_WiFi: {
            title = alertTitleForWiFi;
            message = alertMessageForWiFi;
            break;
        }
        case LyAlertViewForAuthorityMode_addressBook: {
            title = alertTitleForAddressBook;
            message = alertMessageForAddressBook;
            break;
        }
        case LyAlertViewForAuthorityMode_album: {
            title = alertTitleForAlbum;
            message = alertMessageForAlbum;
            break;
        }
        case LyAlertViewForAuthorityMode_camera: {
            title = alertTitleForCamera;
            message = alertMessageForCamera;
            break;
        }
        case LyAlertViewForAuthorityMode_notification: {
            title = alertTitleForNotification;
            message = alertMessageForNotificaion;
            break;
        }
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    
    [vc presentViewController:alert animated:YES completion:nil];
}
+ (void)openUrl:(nullable NSURL *)url {
    if (!url) {
        return;
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if ([LyUtil osVersion] > 10.0f) {
            [[UIApplication sharedApplication] openURL:url
                                               options:@{}
                                     completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}






#pragma mark 打电话
+ (void)call:(NSString *)phone {
    UIWebView *callWebView = [[UIWebView alloc] init];
    NSString *strContact = [[NSString alloc] initWithFormat:@"tel:%@", phone];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strContact]]];
    [[UIApplication sharedApplication].keyWindow addSubview:callWebView];
}
+ (void)sendSMS:(nullable NSString *)bodyOfMessage recipients:(nullable NSArray *)recipients target:(__kindof UIViewController <MFMessageComposeViewControllerDelegate> * _Nonnull)target {
    if (!recipients || recipients.count < 1) {
        return;
    }
    
    MFMessageComposeViewController *messageCompose = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText]) {
        
        [messageCompose setBody:bodyOfMessage];
        [messageCompose setRecipients:recipients];
        [messageCompose setMessageComposeDelegate:target];
        
        [target presentViewController:messageCompose animated:YES completion:nil];
        
    } else {
        [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"设备不支持短信功能"] show];
    }
}





#pragma mark 当前app版本信息
+ (NSString *)getAppBunleIdentifier
{
    if ( !appBunleIdentifier)
    {
        if ( !dicInfoPlist)
        {
            dicInfoPlist = [[NSBundle mainBundle] infoDictionary];
        }
        appBunleIdentifier = [dicInfoPlist objectForKey:@"CFBundleIdentifier"];
        
    }
    
    return  appBunleIdentifier;
}
+ (NSString *)getApplicationVersion
{
    if ( !appVersion)
    {
        if ( !dicInfoPlist)
        {
            dicInfoPlist = [[NSBundle mainBundle] infoDictionary];
        }
        
        appVersion = [dicInfoPlist objectForKey:@"CFBundleShortVersionString"];
    }
    
    return appVersion;
}
+ (NSString *)getApplicationVersionNoPoint
{
    if ( !appVersionNoPoint)
    {
        NSRange rangeFirstPoint = [[LyUtil getApplicationVersion] rangeOfString:@"."];
        NSRange rangeLastPoint = [[LyUtil getApplicationVersion] rangeOfString:@"." options:NSBackwardsSearch];
        
        NSString *strFirst = [[LyUtil getApplicationVersion] substringToIndex:rangeFirstPoint.location];
        NSString *strSencond = [[LyUtil getApplicationVersion] substringWithRange:NSMakeRange( rangeFirstPoint.location+rangeFirstPoint.length, rangeLastPoint.location-rangeFirstPoint.location-rangeFirstPoint.length)];
        NSString *strThird = [[LyUtil getApplicationVersion] substringFromIndex:rangeLastPoint.location+rangeLastPoint.length];
        
        appVersionNoPoint = [[NSString alloc] initWithFormat:@"%@%@%@", strFirst, strSencond, strThird];
        
    }
    
    
    return appVersionNoPoint;
}
+ (NSString *)getApplicationBuildVersion
{
    if ( !appBuildVersion)
    {
        if ( !dicInfoPlist)
        {
            dicInfoPlist = [[NSBundle mainBundle] infoDictionary];
        }
        
        appBuildVersion = [dicInfoPlist objectForKey:(NSString *)kCFBundleVersionKey];
    }
    
    return appBuildVersion;
}
+ (NSString *)getAppUrlScheme
{
    if ( !appUrlScheme)
    {
        if ( !dicInfoPlist)
        {
            dicInfoPlist = [[NSBundle mainBundle] infoDictionary];
        }
        
        NSArray *urlTypes = [dicInfoPlist objectForKey:@"CFBundleURLTypes"];
        
        for ( NSDictionary *dicItem in urlTypes)
        {
            NSString *bundleIdentifier = [dicItem objectForKey:@"CFBundleURLName"];
            if ( [bundleIdentifier isEqualToString:[LyUtil getAppBunleIdentifier]])
            {
                appUrlScheme = [[dicItem objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
            }
        }
    }
    
    return appUrlScheme;
}
+ (NSString *)getAppDisplayName {
    if (!appDisplayName) {
        if ( !dicInfoPlist) {
            dicInfoPlist = [[NSBundle mainBundle] infoDictionary];
        }
        
        appDisplayName = [dicInfoPlist objectForKey:@"CFBundleDisplayName"];
    }
    
    return appDisplayName;
}






#pragma mark 设置当前最新的app版本号
+ (void)setNewestAppVersion:(NSString *)newestVersion
{
    newestAppVersion = newestVersion;
}
+ (NSString *)newestAppVersion
{
    return newestAppVersion;
}
+ (void)setLowestAppVersion:(NSString *)lowestVersion
{
    lowestAppVersion = lowestVersion;
}
+ (NSString *)lowestAppVersion
{
    return lowestAppVersion;
}



#pragma mark 当前网络网状态
+ (void)networkStatusChanged:(NetworkStatus)status
{
    currentNetworkStatus = status;
}
+ (NetworkStatus)currentNetworkStatus
{
    return currentNetworkStatus;
}



#pragma mark bundle文件读取
+ (UIImage *)imageForImageName:(NSString *)imageName needCache:(BOOL)needCache
{
    if (needCache)
    {
        return [UIImage imageNamed:[LyUtil imagePathForImageName:imageName]];
    }
    else
    {
        return [UIImage imageWithContentsOfFile:[LyUtil imagePathForImageName:imageName]];
    }
}
+ (NSString *)imagePathForImageName:(NSString *)imageName
{
    if (!bundlePath)
    {
        bundlePath = [[NSBundle mainBundle] pathForResource:@"resource" ofType:@"bundle"];
    }
    
    return [bundlePath stringByAppendingFormat:@"/images/%@", imageName];
}
+ (NSString *)filePathForFileName:(NSString *)fileName
{
    if (!bundlePath)
    {
        bundlePath = [[NSBundle mainBundle] pathForResource:@"resource" ofType:@"bundle"];
    }
    
    return [bundlePath stringByAppendingFormat:@"/files/%@", fileName];
}



#pragma mark 验证对象是否合法
+ (BOOL)validateDictionary:(id)obj
{
    if (!obj || [obj isKindOfClass:[NSNull class]] || ![obj isKindOfClass:[NSDictionary class]] || [obj count] < 1)
    {
        return NO;
    }
    
    return YES;
}
+ (BOOL)validateArray:(id)obj
{
    if (!obj || [obj isKindOfClass:[NSNull class]] || ![obj isKindOfClass:[NSArray class]] || [obj count] < 1)
    {
        return NO;
    }
    
    return YES;
}
+ (BOOL)validateString:(id)obj
{
    if (!obj || [obj isKindOfClass:[NSNull class]] || ![obj isKindOfClass:[NSString class]] || [obj length] < 1 || [obj rangeOfString:@"null"].length > 0)
    {
        return NO;
    }
    
    return YES;
}
+ (BOOL)validateUserId:(NSString *)userId {
    if (!userId || ![userId isKindOfClass:[NSString class]] || userId.length != LyUserIdLength  || [userId rangeOfString:@"null"].length > 0) {
        return NO;
    }
    
    return YES;
}




#pragma mark 加密
+ (NSString*)base64forData:(NSData*)theData
{
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+ (NSString *)encodeAuthCode:(NSString *)authCode
{
    NSData *dataSour = [authCode dataUsingEncoding:NSUTF8StringEncoding];
    
    //aes128加密
    NSData *data_aes128 = [dataSour AES128EncryptWithKey:aes128key iv:aes128iv];
    while ( !data_aes128)
    {
        data_aes128 = [dataSour AES128EncryptWithKey:aes128key iv:aes128iv];
    }
    
    //hex字符串
    NSString *strHex = [LyUtil hexStringFromData:data_aes128];
    NSString *strResult = [LyUtil md5:strHex];
    
    return strResult;
}

+ (NSString *)encodePassword:(NSString *)pwd
{
    NSData *dataSour = [pwd dataUsingEncoding:NSUTF8StringEncoding];
    //aes128加密
    NSData *data_aes128 = [dataSour AES128EncryptWithKey:aes128key iv:aes128iv];
    while ( !data_aes128)
    {
        data_aes128 = [dataSour AES128EncryptWithKey:aes128key iv:aes128iv];
    }
    
    
    //aes256加密
    //    NSData *data_aes256 = [dataSour AES256EncryptWithKey:aes256key iv:aes256iv];
    //    while ( !data_aes256)
    //    {
    //        data_aes256 = [dataSour AES256EncryptWithKey:aes256key iv:aes256iv];
    //    }
    
    
    //hex字符串
    NSString *strHex = [LyUtil hexStringFromData:data_aes128];
    NSString *strResult = [LyUtil md5:strHex];
    
    //hex字符串
    //    NSString *strHex256 = [self hexStringFromData:data_aes256];
    //    NSString *strResult256 = [self md5:strHex];
    
    
    //    //aes128解密
    //    NSData *dataDeHex = getDataFromHexString(strHex);
    //    NSData *decodeDataHex = [dataDeHex AES128DecryptWithKey:aes128key iv:aes128iv];
    //    NSString *strPwd = [[NSString alloc] initWithData:decodeDataHex encoding:NSUTF8StringEncoding];
    
    //    //aes256解密
    //    NSData *dataDeHex256 = getDataFromHexString(strHex256);
    //    NSData *decodeDataHex256 = [dataDeHex256 AES256DecryptWithKey:aes128key iv:aes128iv];
    //    NSString *strPwd256 = [[NSString alloc] initWithData:decodeDataHex256 encoding:NSUTF8StringEncoding];
    
    return strResult;
    //    return strResult256;
}

+ (NSString *)md5:(NSString *)str
{
    if ( !str)
    {
        return nil;
    }
    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    
    return [[NSString alloc] initWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *) hexStringFromData:(NSData *)dataSour
{
    Byte *bytes = (Byte *)[dataSour bytes];
    
    NSMutableString *strHex = [[NSMutableString alloc] initWithCapacity:1];
    for ( int i = 0; i < [dataSour length]; ++i)
    {
        NSString *tmpStr = [[NSString alloc] initWithFormat:@"%x", bytes[i] & 0xff];
        
        if ( 1 == [tmpStr length])
        {
            [strHex appendString:[[NSString alloc] initWithFormat:@"0%@", tmpStr]];
        }
        else
        {
            [strHex appendString:tmpStr];
        }
    }
    
    return [NSString stringWithString:strHex];
}


unsigned char strToChar (char a, char b)
{
    char encoder[3] = {'\0','\0','\0'};
    encoder[0] = a;
    encoder[1] = b;
    return (char) strtol(encoder,NULL,16);
}


NSData* getDataFromHexString(NSString *strSour)
{
    const char * bytes = [strSour cStringUsingEncoding: NSUTF8StringEncoding];
    NSUInteger length = strlen(bytes);
    unsigned char * r = (unsigned char *) malloc(length / 2 + 1);
    unsigned char * index = r;
    
    while ((*bytes) && (*(bytes +1))) {
        *index = strToChar(*bytes, *(bytes +1));
        index++;
        bytes+=2;
    }
    *index = '\0';
    
    NSData * result = [NSData dataWithBytes: r length: length / 2];
    free(r);
    
    return result;
}





#pragma mark 设置自动登录
+ (void)setAutoLoginFlag:(BOOL)flag {
    [[NSUserDefaults standardUserDefaults] setObject:flag ? @"YES" : @"NO"  forKey:userAutoLoginFlagKey];
}





#pragma mark 是否已成功获取个人信息
+ (void)setFinishGetUserIfo:(BOOL)flag {
    flagForGetUserInfo = flag;
}
+ (BOOL)flagForGetUserInfo {
    return flagForGetUserInfo;
}




#pragma mark 会话id
+ (void)setHttpSessionId:(NSString *)strHttpSessionId {
    httpSessionId = [strHttpSessionId copy];
}

+ (NSString *)httpSessionId {
    return httpSessionId;
}

+ (void)logout:(NSString *)flag {
    [[NSNotificationCenter defaultCenter] postNotificationName:LyNotificationForLogout object:flag];
}

+ (void)sessionTimeOut {
    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"会话已超时，请重新登录"];
    [remind showWithTime:@(3.0f)];
    
    [LyUtil performSelector:@selector(logout:) withObject:LyNotificationForLogoutObjectAutoLogin afterDelay:3.1f];
}

+ (void)serverMaintaining {
    [[LyCurrentUser curUser] logout];
    
    LyMaintainingView *mView = [[LyMaintainingView alloc] init];
    [mView show];
}



+ (UIBarButtonItem *)barButtonItem:(NSInteger)tag imageName:(NSString *)imageName target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    [button setImage:[LyUtil imageForImageName:imageName needCache:NO] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithCustomView:button];
    bbi.tintColor = [UIColor whiteColor];
    
    return bbi;
}




#pragma mark json解析与封装
+ (NSString *)getJsonString:(NSDictionary *)dictionary
{
    NSString * result= @"";
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:nil];
    result= [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"json:%@", result);
    return result;
}

+ (id)getObjFromJson:(NSString *)jsonString
{
    if ( !jsonString || [jsonString isKindOfClass:[NSNull class]] || [jsonString isEqualToString:@""])
    {
        return nil;
    }
    
    NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    return obj;
}






#pragma mark httpBody解析与封装
+ (NSString *)getHttpBody:(NSDictionary *)dictionary {
    
    NSMutableString *bodyTmp = [[NSMutableString alloc] initWithCapacity:1];
    
    for ( NSString *key in dictionary) {
        
        NSString *strValue = [[NSString alloc] initWithFormat:@"%@", [dictionary objectForKey:key]];
        strValue = [strValue stringByReplacingOccurrencesOfString:@"\"" withString:@"”"];
        strValue = [strValue stringByReplacingOccurrencesOfString:@"(" withString:@"（"];
        strValue = [strValue stringByReplacingOccurrencesOfString:@")" withString:@"）"];
        
        [bodyTmp appendFormat:@"%@=%@&", key, strValue];
    }
    
    [bodyTmp deleteCharactersInRange:NSMakeRange(bodyTmp.length - 1, 1)];
    NSString *body = [bodyTmp stringByReplacingEmojiUnicodeWithCheatCodes];
    NSLog(@"strHttpBody = %@", body);
    
    body = [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return body;
}
+ (NSDictionary *)getDicFromHttpBodyStr:(NSString *)strHttpBody
{
    if (!strHttpBody || strHttpBody.length < 1 || [strHttpBody rangeOfString:@"&"].length < 1)
    {
        return nil;
    }
    NSString *strSour = strHttpBody.copy;
    
    NSMutableDictionary *dicResult = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    NSArray *arrNodes = [LyUtil separateString:strSour separator:@"&"];
    for (NSString *item in arrNodes) {
        NSArray *arrNode = [LyUtil separateString:item separator:@"="];
        
        if (arrNode && arrNode.count >= 2) {
            [dicResult setObject:arrNode[1] forKey:arrNode[0]];
        }
    }
    
    return dicResult.copy;
}






#pragma mark 排除重复元素
+ (__kindof NSArray *)uniquifyArray:(__kindof NSArray *)arr key:(NSString *)key
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    for (id obj in arr) {
        [dic setObject:obj forKey:[obj valueForKey:key]];
    }
    
    if ([arr isKindOfClass:[NSMutableArray class]]) {
        arr = [NSMutableArray arrayWithArray:[dic allValues]];
    } else {
        arr = [NSArray arrayWithArray:[dic allValues]];
    }
    return arr;
}

#pragma mark 数组排序
+ (__kindof NSArray *)sortArrByDate:(__kindof NSArray *)arr andKey:(NSString *)key asc:(BOOL)asc
{
    if (!arr || arr.count < 1) {
        return nil;
    }
    
    if ([arr isKindOfClass:[NSMutableArray class]]) {
        [arr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSDate *date1 = [[LyUtil dateFormatterForAll] dateFromString:( [[obj1 valueForKey:key] length] < 25) ? [[obj1 valueForKey:key] stringByAppendingString:@" +0800"] : [obj1 valueForKey:key]];
            NSDate *date2 = [[LyUtil dateFormatterForAll] dateFromString:( [[obj2 valueForKey:key] length] < 25) ? [[obj2 valueForKey:key] stringByAppendingString:@" +0800"] : [obj2 valueForKey:key]];
            
            NSComparisonResult result = ([date1 timeIntervalSinceDate:date2] > 0) ? NSOrderedAscending : NSOrderedDescending;
            if (asc) {
                result = ([date1 timeIntervalSinceDate:date2] > 0) ? NSOrderedDescending : NSOrderedAscending;
            }
            
            return result;
        }];
    } else {
        arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSDate *date1 = [[LyUtil dateFormatterForAll] dateFromString:( [[obj1 valueForKey:key] length] < 25) ? [[obj1 valueForKey:key] stringByAppendingString:@" +0800"] : [obj1 valueForKey:key]];
            NSDate *date2 = [[LyUtil dateFormatterForAll] dateFromString:( [[obj2 valueForKey:key] length] < 25) ? [[obj2 valueForKey:key] stringByAppendingString:@" +0800"] : [obj2 valueForKey:key]];
            
            NSComparisonResult result = ([date1 timeIntervalSinceDate:date2] > 0) ? NSOrderedAscending : NSOrderedDescending;
            if (asc) {
                result = ([date1 timeIntervalSinceDate:date2] > 0) ? NSOrderedDescending : NSOrderedAscending;
            }
            
            return result;
        }];
    }
    
    return arr;
}
+ (__kindof NSArray *)sortArrByStr:(__kindof NSArray *)arr andKey:(NSString *)key
{
    if (!arr || arr.count < 1) {
        return nil;
    }
    
    if ([arr isKindOfClass:[NSMutableArray class]]) {
        [arr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
        }];
    } else {
        arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
        }];
    }
    
    return arr;
}


#pragma mark 唯一化并排序
+ (__kindof NSArray *)uniquifyAndSort:(__kindof NSArray *)arr keyUniquify:(NSString *)keyUniquify keySort:(NSString *)keySort asc:(BOOL)asc
{
    if (!arr || arr.count < 1) {
        return arr;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    for (id obj in arr) {
        [dic setObject:obj forKey:[obj valueForKey:keyUniquify]];
    }
    
    if ([arr isKindOfClass:[NSMutableArray class]]) {
        arr = [[NSMutableArray alloc] initWithArray:[dic allValues]];
    } else {
        arr = [NSArray arrayWithArray:[dic allValues]];
    }
    
    arr = [LyUtil sortArrByDate:arr andKey:keySort asc:asc];
    
    
    return arr;
}





#pragma mark 字符串处理
#pragma mark 转换时间为驾考圈模式
+ (NSString *)translateTime:(NSString *)strTime
{
    if (!strTime)
    {
        return @" ";
    }
    
    NSDate *now = [NSDate date];
    NSDate *date = [[LyUtil dateFormatterForAll] dateFromString:strTime];
    NSTimeInterval timeInterval = [now timeIntervalSinceDate:date];
    
    if (timeInterval < 60)
    {
//        return @"刚刚";
        return LyLocalize(@"刚刚");
    }
    else if (timeInterval < 60 * 60)
    {
        //x分钟前
        int minutes = timeInterval / 60;
        
        return [[NSString alloc] initWithFormat:@"%d %@", minutes, LyLocalize(@"分钟前")];
    }
    else if (timeInterval < 60 * 60 * 24)
    {
        //x小时前
        int hours = timeInterval / (60 * 60);
        
        return [[NSString alloc] initWithFormat:@"%d %@", hours, LyLocalize(@"小时前")];
    }
    else
    {
        if (!calendar)
        {
            calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法 NSCalendarIdentifierGregorian,NSCalendarIdentifierGregorian
            [calendar setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
        }
        
        
        NSDateComponents *compNow = [calendar components:
                                     NSCalendarUnitSecond |
                                     NSCalendarUnitMonth |
                                     NSCalendarUnitDay
                                                fromDate:now];
        
        
        NSDateComponents *compDate = [calendar components:
                                      NSCalendarUnitSecond |
                                      NSCalendarUnitMonth |
                                      NSCalendarUnitDay
                                                 fromDate:date];
        
        NSInteger yearNow = compNow.year;
        NSInteger monthNow = compNow.month;
        NSInteger dayNow = compNow.day;
        
        NSInteger yearDate = compDate.year;
        NSInteger monthDate = compDate.month;
        NSInteger dayDate = compDate.day;
        
        
        if (yearNow != yearDate)
        {
            return [LyUtil cutTimeString:strTime];
        }
        else if (monthNow != monthDate)
        {
            return [strTime substringWithRange:NSMakeRange(5, 11)];
        }
        else if (dayNow - dayDate < 2)
        {
            return [[NSString alloc] initWithFormat:@"%@ %@", LyLocalize(@"昨天"), [strTime substringWithRange:NSMakeRange(11, 5)]];
        }
//        else if (dayNow - dayDate < 3)
//        {
//            return [[NSString alloc] initWithFormat:@"前天 %@", [strTime substringWithRange:NSMakeRange(11, 5)]];
//        }
        else
        {
            return [strTime substringWithRange:NSMakeRange(5, 11)];
        }
    }
    
    return strTime;
}

+ (NSString *)cutTimeString:(NSString *)strSour
{
    if ( !strSour || [NSNull null] == (NSNull *)strSour || [strSour isEqualToString:@""])
    {
        return strSour;
    }
    
    NSRange rangeFore = [strSour rangeOfString:@":"];
    NSRange rangeBack = [strSour rangeOfString:@":" options:NSBackwardsSearch];
    
    
    if ( rangeFore.length < 1)
    {
        return strSour;
    }
    
    if ( rangeFore.location == rangeBack.location)
    {
        return strSour;
    }
    
    NSString *strDest = [strSour substringToIndex:rangeBack.location];
    
    return strDest;
}

+ (NSArray *)separateString:(NSString *)strSour separator:(NSString *)separator
{
    if ( !strSour || [NSNull null] == (NSNull *)strSour || [strSour isEqualToString:@""])
    {
        return nil;
    }
    
    NSString *strTmp = [strSour copy];
    
    NSRange rangeOfSeparator = [strTmp rangeOfString:separator];
    
    if ( rangeOfSeparator.length < 1)
    {
        return @[strSour];
    }
    
    NSString *strItem = [strTmp substringToIndex:rangeOfSeparator.location];
    
    NSString *strRemain = [strTmp substringFromIndex:rangeOfSeparator.location+rangeOfSeparator.length];
    
    
    return [@[strItem] arrayByAddingObjectsFromArray:[self separateString:strRemain separator:separator]];
}

+ (NSArray *)separateAnswerString:(NSString *)strSour
{
    if ( !strSour || [NSNull null] == (NSNull *)strSour || [strSour isEqualToString:@""])
    {
        return nil;
    }
    
    NSString *strItem = [strSour substringWithRange:NSMakeRange( 0, 1)];
    
    return [@[strItem] arrayByAddingObjectsFromArray:[self separateAnswerString:[strSour substringFromIndex:1]]];
}

+ (NSString *)getPinyinFromHanzi:(NSString *)hanzi
{
    if ( [hanzi length])
    {
        NSMutableString *result = [[NSMutableString alloc] initWithString:hanzi];
        CFStringTransform( (__bridge CFMutableStringRef)result, 0, kCFStringTransformMandarinLatin, NO);
        CFStringTransform( (__bridge CFMutableStringRef)result, 0, kCFStringTransformStripDiacritics, NO);
        
        return [result lowercaseString];
    }
    
    return hanzi;
}
#pragma mark 支付宝结果解析
+ (NSDictionary *)dicFormAliPayString:(NSString *)sourString
{
    if ( !sourString || [NSNull null] == (NSNull *)sourString || [sourString rangeOfString:@"(null)"].length > 0 || [sourString length] < 1)
    {
        return nil;
    }
    
    NSMutableDictionary *dicResult = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    NSArray *arr = [LyUtil separateString:sourString separator:@"&"];
    for ( NSString *item in arr)
    {
        NSArray *arrItem = [LyUtil separateString:item separator:@"="];
        
        if ( 2 == [arrItem count])
        {
            NSString *strValue = [arrItem objectAtIndex:1];
            strValue = [strValue substringWithRange:NSMakeRange( 1, strValue.length-2)];
            [dicResult setObject:strValue forKey:[arrItem objectAtIndex:0]];
        }
    }
    
    return [dicResult copy];
}
#pragma mark 隐藏电话号中间四位
+ (NSString *)hidePhoneNumber:(NSString *)strPhone
{
    return [[NSString alloc] initWithFormat:@"%@****%@", [strPhone substringToIndex:3], [strPhone substringFromIndex:7]];
}



#pragma mark 日期与时间
+ (NSString *)timeNow
{
    NSDate *now = [NSDate date];
    
    NSString *strNow = [[NSString alloc] initWithFormat:@"%@", now];
    
    
    return [strNow substringToIndex:19];
}

+ (int)secondsFrom1970
{
    NSDate *now = [NSDate date];
    
    double secondsFrom1970 = [now timeIntervalSince1970];
    
    return secondsFrom1970;
}

+ (NSDateFormatter *)dateFormatterForYMD
{
    if ( !dateFormatterForYMD)
    {
        dateFormatterForYMD = [[NSDateFormatter alloc] init];
        
        NSTimeZone* localzone = [NSTimeZone localTimeZone];
        NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        [dateFormatterForYMD setTimeZone:GTMzone];
        [dateFormatterForYMD setTimeZone:localzone];
        
        
        [dateFormatterForYMD setDateFormat:@"yyyy-MM-dd"];
        [dateFormatterForYMD setLocale:LyChinaLocale];
    }
    
    return dateFormatterForYMD;
}

+ (NSDateFormatter *)dateFormatterForAll
{
    if ( !dateFormatterForAll)
    {
        dateFormatterForAll = [[NSDateFormatter alloc] init];
        [dateFormatterForAll setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        [dateFormatterForAll setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        [dateFormatterForAll setLocale:LyChinaLocale];
    }
    
    return dateFormatterForAll;
}

+ (NSDateFormatter *)dateFormatterForAllTest
{
    if ( !dateFormatterForAllTest)
    {
        dateFormatterForAllTest = [[NSDateFormatter alloc] init];
        [dateFormatterForAllTest setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        [dateFormatterForAllTest setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        [dateFormatterForAllTest setLocale:LyChinaLocale];
    }
    
    return dateFormatterForAllTest;
}

+ (int)calculSecondsWithString:(NSString *)strDate
{
    NSDate *date = [[LyUtil dateFormatterForAll] dateFromString:strDate];
    
    return [LyUtil calculSecondsWithDate:date];
}


+ (int)calculdateAgeWithStr:(NSString *)birthday
{
    NSDate *dateBirthday;
    if ( !birthday || [NSNull null] == (NSNull *)birthday || [birthday isEqualToString:@""])
    {
        dateBirthday = [NSDate date];
    }
    else
    {
        dateBirthday = [[LyUtil dateFormatterForAll] dateFromString:birthday];
        
        if ( !dateBirthday)
        {
            dateBirthday = [[LyUtil dateFormatterForYMD] dateFromString:birthday];
        }
    }
    
    if ( !dateBirthday)
    {
        return 0;
    }
    
    
    NSDate *today = [NSDate date];
    
    if (!calendar)
    {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法 NSCalendarIdentifierGregorian,NSCalendarIdentifierGregorian
        [calendar setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    }
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:dateBirthday toDate:today options:0];
    
    int age = (int)[components year];
    return age;
}

+ (int)calculSecondsWithDate:(NSDate *)date
{
    if ( !date)
    {
        return 0;
    }
    
    NSDate *now = [NSDate date];
    
    if (!calendar)
    {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法 NSCalendarIdentifierGregorian,NSCalendarIdentifierGregorian
        [calendar setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    }
    
    NSDateComponents *components = [calendar components:NSCalendarUnitSecond fromDate:date toDate:now options:0];
    int seconds = (int)[components second];
    
    return seconds;
}

+ (int)calculdateAgeWithDate:(NSDate *)birthday
{
    if ( !birthday || [NSNull null] == (NSNull *)birthday)
    {
        birthday = [NSDate date];
    }
    
    NSDate *today = [NSDate date];
    
    if (!calendar)
    {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法 NSCalendarIdentifierGregorian,NSCalendarIdentifierGregorian
        [calendar setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    }
    
    
    NSDateComponents *components = [calendar components:NSCalendarUnitSecond fromDate:birthday toDate:today options:0];
    
    int age = (int)[components year];
    return age;
}

+ (NSString *)fixDateTimeString:(NSString *)strDateTime
{
    if (!strDateTime || ![LyUtil validateString:strDateTime])
    {
        NSString *str = [LyUtil timeNow];
        
        return str;
    }
    
    NSString *oriDateTime = strDateTime;
    oriDateTime = [oriDateTime stringByReplacingOccurrencesOfString:@"r" withString:@""];
    oriDateTime = [oriDateTime stringByReplacingOccurrencesOfString:@"n" withString:@""];
    
    NSArray *arrDateTime = [LyUtil separateString:oriDateTime separator:@" "];
    NSString *strDate;
    NSString *strTime;
    if (arrDateTime.count < 2)
    {
        int h = arc4random() % (24-8)+8;
        int m = arc4random() % 60;
        int s = arc4random() % 60;
        strTime = [[NSString alloc] initWithFormat:@"%02d:%02d:%02d", h, m , s];
    }
    else
    {
        strTime = [arrDateTime objectAtIndex:1];
    }
    
    NSArray *arrDate = [LyUtil separateString:[arrDateTime objectAtIndex:0] separator:@"-"];
    strDate = [[NSString alloc] initWithFormat:@"%02d-%02d-%02d", [[arrDate objectAtIndex:0] intValue], [[arrDate objectAtIndex:1] intValue], [[arrDate objectAtIndex:2] intValue]];
    
    
    
    NSString *newDateTime = [[NSString alloc] initWithFormat:@"%@ %@ +0800", strDate, strTime];
    
    return newDateTime;
}

+ (NSString *)fixDateTimeString:(NSString *)strDateTime isExplicit:(BOOL)isExplicit
{
    if (!strDateTime || ![LyUtil validateString:strDateTime])
    {
        NSString *str = [LyUtil timeNow];
        
        return str;
    }
    
    NSString *oriDateTime = strDateTime;
    oriDateTime = [oriDateTime stringByReplacingOccurrencesOfString:@"r" withString:@""];
    oriDateTime = [oriDateTime stringByReplacingOccurrencesOfString:@"n" withString:@""];
    
    NSArray *arrDateTime = [LyUtil separateString:oriDateTime separator:@" "];
    NSString *strDate;
    NSString *strTime;
    if (arrDateTime.count < 2)
    {
        if (isExplicit) {
            strTime = @"10:00:00";
        } else {
            int h = arc4random() % (24-8)+8;
            int m = arc4random() % 60;
            int s = arc4random() % 60;
            strTime = [NSString stringWithFormat:@"%02d:%02d:%02d", h, m , s];
        }
    }
    else
    {
        strTime = [arrDateTime objectAtIndex:1];
    }
    
    NSArray *arrDate = [LyUtil separateString:[arrDateTime objectAtIndex:0] separator:@"-"];
    strDate = [NSString stringWithFormat:@"%02d-%02d-%02d", [[arrDate objectAtIndex:0] intValue], [[arrDate objectAtIndex:1] intValue], [[arrDate objectAtIndex:2] intValue]];
    
    
    
    NSString *newDateTime = [[NSString alloc] initWithFormat:@"%@ %@ +0800", strDate, strTime];
    
    return newDateTime;
}

+ (nullable NSDate *)dateWithString:(nonnull NSString *)dateStr
{
    if (![LyUtil validateString:dateStr]) {
        return nil;
    }
    
    NSString *sDate = [LyUtil fixDateTimeString:dateStr];
    NSDate *date = [[LyUtil dateFormatterForAll] dateFromString:sDate];
    
    return date;
}

+ (NSTimeInterval)compareDateByString:(nonnull NSString *)sDate_1 with:(nonnull NSString *)sDate_2
{
    if (!sDate_1) {
        if (!sDate_2) {
            return 0;
        } else {
            return -1;
        }
    } else if (!sDate_2) {
        return 1;
    }
    
    return [[LyUtil dateWithString:sDate_1] timeIntervalSinceDate:[LyUtil dateWithString:sDate_2]];
}


+ (int)getDaysFrom:(NSDate *)startDate To:(NSDate *)endDate
{
    if (!calendar) {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法 NSCalendarIdentifierGregorian,NSCalendarIdentifierGregorian
        [calendar setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    }
    //    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    //    [gregorian setFirstWeekday:2];
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:startDate];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
    
    return (int)dayComponents.day;
}


+ (NSString *)stringOnlyDateFromDate:(id)date {
    if (!date) {
        return @"";
    }
    
    if ([date isKindOfClass:[NSDate class]]){
        return [[[LyUtil dateFormatterForAll] stringFromDate:date] substringToIndex:10];
    } else if ([date isKindOfClass:[NSString class]]) {
        NSString *str = date;
        if (str.length >= 10) {
            return [str substringToIndex:10];
        }
    }
    
    return @"";
}
+ (NSString *)weekdayStringWithDate:(id)date {
    if (!date) {
        return @"";
    }
    
    NSDate *uDate;
    
    if ([date isKindOfClass:[NSDate class]]) {
        uDate = date;
    } else if ([date isKindOfClass:[NSString class]]) {
        uDate = [[LyUtil dateFormatterForAll] dateFromString:date];
    }
    
    if (!uDate) {
        return @"";
    }
    
    if (!calendar) {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法 NSCalendarIdentifierGregorian,NSCalendarIdentifierGregorian
        [calendar setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    }
    
    // NSDateComponent 可以获得日期的详细信息，即日期的组成
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday
                                          fromDate:uDate];
    
    NSString *strWeekday;
    switch ( [comps weekday]) {
        case 1: {
            strWeekday = @"周日";
            break;
        }
        case 2: {
            strWeekday = @"周一";
            break;
        }
        case 3: {
            strWeekday = @"周二";
            break;
        }
        case 4: {
            strWeekday = @"周三";
            break;
        }
        case 5: {
            strWeekday = @"周四";
            break;
        }
        case 6: {
            strWeekday = @"周五";
            break;
        }
        case 7: {
            strWeekday = @"周六";
            break;
        }
        default: {
            strWeekday = @"";
            break;
        }
    }
    
    
    return strWeekday;
}
+ (LyWeekday)weekdayWithDate:(id)date {
    if (!date) {
        return LyWeekday_monday;
    }
    
    return [LyUtil weekdayFromString:[LyUtil weekdayStringWithDate:date]];
}




#pragma mark 设置图片
+ (void)setScoreImageView:(UIImageView *)imageView withScore:(float)score
{
    if ( !imageView)
    {
        return;
    }
    
    int limitCount = 0;
    NSString *imageName;
    
    if ( score >= minFiveStar-(everyHalfStarLimit*limitCount++))          //五星
    {
        imageName = @"ct_score_five";
    }
    else if ( score >= minFiveStar-(everyHalfStarLimit*limitCount++))     //四星半
    {
        imageName = @"ct_score_fourAndHalf";
    }
    else if ( score >= minFiveStar-(everyHalfStarLimit*limitCount++))     //四星
    {
        imageName = @"ct_score_four";
    }
    else if ( score >= minFiveStar-(everyHalfStarLimit*limitCount++))     //三星半
    {
        imageName = @"ct_score_threeAndHalf";
    }
    else if ( score >= minFiveStar-(everyHalfStarLimit*limitCount++))     //三星
    {
        imageName = @"ct_score_three";
    }
    else if ( score >= minFiveStar-(everyHalfStarLimit*limitCount++))     //二星半
    {
        imageName = @"ct_score_twoAndHalf";
    }
    else if ( score >= minFiveStar-(everyHalfStarLimit*limitCount++))    //二星
    {
        imageName = @"ct_score_two";
    }
    else if ( score >= minFiveStar-(everyHalfStarLimit*limitCount++))     //一星半
    {
        imageName = @"ct_score_oneAndHalf";
    }
    else if ( score >= minFiveStar-(everyHalfStarLimit*limitCount++))     //一星
    {
        imageName = @"ct_score_one";
    }
    else if ( score >= minFiveStar-(everyHalfStarLimit*limitCount++))    //半星
    {
        imageName = @"ct_score_half";
    }
    else     //零星
    {
        imageName = @"ct_score_zero";
    }
    
    [imageView setImage:[LyUtil imageForImageName:imageName needCache:NO]];
}

+ (void)setDegreeImageView:(UIImageView *)imageView withDegree:(NSInteger)degree
{
    if ( !imageView)
    {
        return;
    }
    
    NSString *imageName;
    switch ( degree) {
        case 0: {
            imageName = @"ct_score_zero";
            break;
        }
            
        case 1: {
            imageName = @"ct_score_one";
            break;
        }
            
        case 2: {
            imageName = @"ct_score_two";
            break;
        }
            
        case 3: {
            imageName = @"ct_score_three";
            break;
        }
            
        case 4: {
            imageName = @"ct_score_four";
            break;
        }
            
        case 5: {
            imageName = @"ct_score_five";
            break;
        }
            
        default: {
            imageName = @"ct_score_zero";
            break;
        }
    }
    
    [imageView setImage:[LyUtil imageForImageName:@"imageName" needCache:NO]];
}

+ (void)setSexImageView:(UIImageView *)imageView withUserSex:(LySex)sex
{
    NSString *sexImageName;
    switch ( sex)
    {
        case LySexUnkown:
        {
            sexImageName = @"sex_Unkown";
            break;
        }
        case LySexMale:
        {
            sexImageName = @"sex_Male";
            break;
        }
        case LySexFemale:
        {
            sexImageName = @"sex_Female";
            break;
        }
        default:
        {
            sexImageName = @"sex_Unkown";
            break;
        }
    }
    
    [imageView setImage:[LyUtil imageForImageName:sexImageName needCache:NO]];
}

+ (void)setUserLevelImageView:(UIImageView *)imageView withUserLevel:(LyUserLevel)userLevel
{
    if ( !imageView)
    {
        return;
    }
    
    NSString *strUserLevelImageName;
    
    switch ( userLevel)
    {
        case LyUserLevel_killer:
        {
            strUserLevelImageName = @"level_killer";
            break;
        }
        case LyUserLevel_newbird:
        {
            strUserLevelImageName = @"level_killer";
            break;
        }
        case LyUserLevel_mass:
        {
            strUserLevelImageName = @"level_killer";
            break;
        }
        case LyUserLevel_superior:
        {
            strUserLevelImageName = @"level_killer";
            break;
        }
        case LyUserLevel_master:
        {
            strUserLevelImageName = @"level_killer";
            break;
        }
            
        default:
        {
            strUserLevelImageName = @"level_killer";
            break;
        }
    }
    
    [imageView setImage:[LyUtil imageForImageName:strUserLevelImageName needCache:NO]];
}

+ (void)setAttentionKindImageView:(UIImageView *)imageView withMode:(LyUserType)userType
{
    if ( !imageView)
    {
        return;
    }
    
    NSString *strAttentionKindImageName;
    
    switch ( userType) {
        case LyUserType_normal: {
            strAttentionKindImageName = @"attention_null";
            break;
        }
        case LyUserType_coach: {
            strAttentionKindImageName = @"attention_coach";
            break;
        }
        case LyUserType_school: {
            strAttentionKindImageName = @"attention_driveschool";
            break;
        }
        case LyUserType_guider: {
            strAttentionKindImageName = @"attention_guider";
            break;
        }
            
        default: {
            strAttentionKindImageName = @"attention_null";
            break;
        }
    }
    
    [imageView setImage:[LyUtil imageForImageName:strAttentionKindImageName needCache:NO]];
}





#pragma mark 动画
+ (void)startAnimationWithView:(UIView *)view
             animationDuration:(NSTimeInterval)duration
                  initialPoint:(CGPoint)iniPoint
              destinationPoint:(CGPoint)desPoint
                    completion:(void (^)(BOOL finished))completion
{
    [view setCenter:iniPoint];
    [view setHidden:NO];
    
    [UIView animateWithDuration:duration animations:^{
        [view setCenter:desPoint];
    } completion:^(BOOL isFinished) {
        if (completion) {
            completion(isFinished);
        }
    }];
}

+ (void)startAnimationWithView:(UIScrollView *)view
             animationDuration:(NSTimeInterval)duration
                 initialOffset:(CGPoint)iniPoint
             destinationOffset:(CGPoint)desPoint
                    completion:(void (^)(BOOL finished))completion
{
    [view setHidden:NO];
    [view setContentOffset:iniPoint];
    
    [UIView animateWithDuration:duration animations:^{
        [view setContentOffset:desPoint];
    } completion:^(BOOL isFinished) {
        if (completion) {
            completion(isFinished);
        }
    }];
}

+ (void)startAnimationWithView:(UIView *)view
             animationDuration:(NSTimeInterval)duration
                  initialColor:(UIColor *)iniColor
              destinationColor:(UIColor *)desColor
                    completion:(void (^)(BOOL finished))completion
{
    [view setHidden:NO];
    [view setBackgroundColor:iniColor];
    
    [UIView animateWithDuration:duration animations:^{
        [view setBackgroundColor:desColor];
    } completion:^(BOOL isFinished) {
        if (completion) {
            completion(isFinished);
        }
    }];
}

+ (void)startAnimationWithView:(UIView *)view
             animationDuration:(NSTimeInterval)duration
                     initAlpha:(float)initAlpha
             destinationAplhas:(float)desAlpha
                     comletion:(void(^)(BOOL finished))completion
{
    [view setHidden:NO];
    [view setAlpha:initAlpha];
    
    [UIView animateWithDuration:duration animations:^{
        [view setAlpha:desAlpha];
    } completion:^(BOOL isFinished) {
        if (completion) {
            completion(isFinished);
        }
    }];
}





#pragma mark 生成控件
+ (UILabel *)lbTitleForNavigationBar:(NSString *)title detail:(NSString *)detail
{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, 120, LyNavigationItemHeight)];
    [lb setTextColor:LyBlackColor];
    [lb setFont:LyNavigationItemTitleFont];
    [lb setNumberOfLines:0];
    [lb setTextAlignment:NSTextAlignmentCenter];
    
    NSString *strLbTmp = [[NSString alloc] initWithFormat:@"%@\n%@", title, detail];
    NSRange range = [strLbTmp rangeOfString:detail];
    
    NSMutableAttributedString *strLb = [[NSMutableAttributedString alloc] initWithString:strLbTmp];
    [strLb addAttribute:NSFontAttributeName value:LyFont(12) range:range];
    [strLb addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:range];
    
    [lb setAttributedText:strLb];
    
    return lb;
}

+ (UILabel *)lbTitleForNavigationBar:(NSString *)title
{
    CGFloat fWidthLbTitle = [title sizeWithAttributes:@{NSFontAttributeName:LyNavigationItemTitleFont}].width;
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, fWidthLbTitle, LyNavigationItemHeight)];
    [lbTitle setText:title];
    [lbTitle setFont:LyNavigationItemTitleFont];
    [lbTitle setTextColor:LyBlackColor];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    
    return lbTitle;
}

+ (UILabel *)lbItemTitleWithText:(NSString *)text
{
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, 0, SCREEN_WIDTH*2.0/3.0f, 30.0f)];
    [tmpLabel setText:text];
    [tmpLabel setTextColor:Ly517ThemeColor];
    [tmpLabel setFont:LyFont(16)];
    [tmpLabel setTextAlignment:NSTextAlignmentLeft];
    [tmpLabel setBackgroundColor:LyWhiteLightgrayColor];
    
    return tmpLabel;
}

+ (UIRefreshControl *)refreshControlWithTitle:(nullable NSString *)title target:(id)target action:(SEL)actoin
{
    UIRefreshControl *refresher = [[UIRefreshControl alloc] init];
    [refresher setBackgroundColor:LyWhiteLightgrayColor];
    [refresher setTintColor:[UIColor darkGrayColor]];
    NSMutableAttributedString *strRefresherTitle = [[NSMutableAttributedString alloc] initWithString:(title) ? title : @"正在加载..."];
    [strRefresherTitle addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange( 0, [title length])];
    [refresher setAttributedTitle:strRefresherTitle];
    [refresher addTarget:target action:actoin forControlEvents:UIControlEventValueChanged];
    
    return  refresher;
}

+ (UILabel *)lbErrorWithMode:(NSInteger)mode {
    UILabel *lbError = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LyLbErrorHeight)];
    [lbError setFont:LyLbErrorFont];
    [lbError setTextColor:LyLbErrorTextColor];
    [lbError setTextAlignment:NSTextAlignmentCenter];
    [lbError setBackgroundColor:LyWhiteLightgrayColor];
    lbError.numberOfLines = 0;
    if (1 == mode) {
        lbError.text = LyLocalize(@"加载失败，点击再次加载");
    } else {
        lbError.text = LyLocalize(@"加载失败，下拉再次加载");
    }
    
    return lbError;
}

+ (UILabel *)lbNullWithText:(NSString *)text {
    UILabel *lbNull = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LyLbNullHeight)];
    [lbNull setFont:LyLbErrorFont];
    [lbNull setTextColor:LyLbErrorTextColor];
    [lbNull setTextAlignment:NSTextAlignmentCenter];
    [lbNull setBackgroundColor:LyWhiteLightgrayColor];
    [lbNull setNumberOfLines:0];
    [lbNull setText:text];
    
    return lbNull;
}



#pragma mark 数值转换
#pragma mark 转换秒数为 分：秒
+ (NSString *)translateSecondsToClock:(NSInteger)seconds
{
    NSInteger minute = seconds / 60;
    NSInteger second = seconds % 60;
    
    return [[NSString alloc] initWithFormat:@"%02ld:%02ld", (long)minute, (long)second];
}

+ (NSString *)transmitNumWithWan:(NSInteger)num
{
    NSString *str;
    if ( num < 1) {
        str = @"";
    } else if ( num < 10000) {
        str = [[NSString alloc] initWithFormat:@"%d", (int)num];
    } else {
        str = [[NSString alloc] initWithFormat:@"%ld万", num / 10000];
    }
    
    return str;
}

+ (NSString *)getDistance:(float)distance
{
    NSString *strDistance;
    if ( distance < 999)
    {
        strDistance = [[NSString alloc] initWithFormat:@"%.0fm", distance];
    }
    else if ( distance < 9999)
    {
        strDistance = [[NSString alloc] initWithFormat:@"%.1fkm", distance/1000.0];
    }
    else
    {
        strDistance = [[NSString alloc] initWithFormat:@"%.0fkm", distance/1000.0];
    }
    
    return strDistance;
}





#pragma mark 驾照类型
+ (NSArray *)arrDriveLicenses
{
    return arrDriveLicenses;
}

+ (NSString *)driveLicenseStringFrom:(LyLicenseType)driveLicense {
    
    if (LyLicenseType_C1 > driveLicense || driveLicense > LyLicenseType_M) {
        driveLicense = LyLicenseType_C1;
    }
    
    return [arrDriveLicenses objectAtIndex:driveLicense];
}

+ (LyLicenseType)driveLicenseFromString:(NSString *)strDriveLicense {
    
    LyLicenseType license = [arrDriveLicenses indexOfObject:strDriveLicense];
    if (LyLicenseType_C1 > license || license > LyLicenseType_M) {
        license = LyLicenseType_C1;
    }
    
    return license;
}

#pragma mark 练车方式
+ (NSArray *)arrTrainModes
{
    return arrTrainModes;
}

+ (NSString *)trainModeStringFrom:(LyTrainClassTrainMode)trainType {
    
    if (LyTrainClassTrainMode_one > trainType || trainType > LyTrainClassTrainMode_multi) {
        trainType = LyTrainClassTrainMode_multi;
    }
    
    return [arrTrainModes objectAtIndex:trainType-LyTrainClassTrainMode_one];
}

+ (LyTrainClassTrainMode)trainModeFromString:(NSString *)strTrainType {
    LyTrainClassTrainMode trainMode = [arrTrainModes indexOfObject:strTrainType] + LyTrainClassTrainMode_one;
    if (LyTrainClassTrainMode_one > trainMode || trainMode > LyTrainClassTrainMode_multi) {
        trainMode = LyTrainClassTrainMode_one;
    }
    
    return trainMode;
}
#pragma mark 接送方式
+ (NSString *)pickTypeStringFrom:(LyTrainClassPickType)pickType {
    
    if (LyTrainClassPickType_none > pickType || pickType > LyTrainClassPickType_bus) {
        pickType = LyTrainClassPickType_none;
    }
    
    return [arrPickModes objectAtIndex:pickType];
}
+ (LyTrainClassPickType)pickTypeFromString:(NSString *)strPickType {
    LyTrainClassPickType pickType = [arrPickModes indexOfObject:strPickType];
    if (LyTrainClassPickType_none > pickType || pickType > LyTrainClassPickType_bus) {
        pickType = LyTrainClassPickType_none;
    }
    
    return pickType;
}
#pragma mark 科目进度
+ (NSArray *)arrSubjectMode
{
    return arrSubjectMode;
}

+ (NSString *)subjectModeStringFrom:(LySubjectMode)subjectMode
{
    return [arrSubjectMode objectAtIndex:subjectMode-1];
}

+ (LySubjectMode)subjectModeFromString:(NSString *)strSubjectMode
{
    return [arrSubjectMode indexOfObject:strSubjectMode]+1;
}
#pragma mark 科目-实践
+ (nullable NSArray *)arrSubjectModePrac {
    return arrSubjectModePrac;
}
+ (nullable NSString *)subjectModePracStringForm:(LySubjectModeprac)subjectMode {
    if (LySubjectModeprac_second > subjectMode || LySubjectModeprac_second > LySubjectModeprac_third) {
        subjectMode = 0;
    } else {
        subjectMode = subjectMode - LySubjectModeprac_second;
    }
    
    return [arrSubjectModePrac objectAtIndex:subjectMode];
}
+ (LySubjectModeprac)subjectModePracFromString:(nullable NSString *)strSubjectMode {
    LySubjectModeprac subjectModeprac = [arrSubjectModePrac indexOfObject:strSubjectMode] + LySubjectModeprac_second;
    if (LySubjectModeprac_second > subjectModeprac || subjectModeprac > LySubjectModeprac_third) {
        subjectModeprac = LySubjectModeprac_second;
    }
    
    return subjectModeprac;
}

#pragma mark 付款情况
+ (NSArray *)arrPayInfo {
    return arrPayInfo;
}
+ (NSString *)payInfoStringFrom:(LyPayInfo)payInfo {
    if (LyPayInfo_whole > payInfo || payInfo > LyPayInfo_notyet) {
        payInfo = LyPayInfo_notyet;
    }
    return [arrPayInfo objectAtIndex:payInfo];
}
+ (LyPayInfo)payInfoFromString:(NSString *)strPayInfo {
    LyPayInfo payInfo = [arrPayInfo indexOfObject:strPayInfo];
    if (LyPayInfo_whole > payInfo || payInfo > LyPayInfo_notyet) {
        payInfo = LyPayInfo_notyet;
    }
    return payInfo;
}

#pragma mark 星期几
+ (NSArray *)arrWeekdays {
    return arrWeekdays;
}
+ (nullable NSString *)weekdayStringFrom:(LyWeekday)weekday {
    if (LyWeekday_monday > weekday || weekday > LyWeekday_sunday) {
        weekday = LyWeekday_monday;
    }
    return [arrWeekdays objectAtIndex:weekday];
}
+ (LyWeekday)weekdayFromString:(NSString *)strWeekday {
    LyWeekday weekday = [arrWeekdays indexOfObject:strWeekday];
    if (LyWeekday_monday > weekday || weekday > LyWeekday_sunday) {
        weekday = LyWeekday_monday;
    }
    
    return weekday;
}
+ (NSString *)getWeekdayWithIndex:(NSInteger)index {
    if (LyWeekday_monday > index || index > LyWeekday_sunday) {
        index = LyWeekday_monday;
    }
    return [arrWeekdays objectAtIndex:index];
}
+ (NSInteger)getWeekdayIndex:(NSString *)strWeekday {
    LyWeekday weekday = [arrWeekdays indexOfObject:strWeekday];
    if (LyWeekday_monday > weekday || weekday > LyWeekday_sunday) {
        weekday = LyWeekday_monday;
    }
    
    return weekday;
}
+ (NSString *)weekdaySpanStringFrom:(LyWeekdaySpan)weekdaySpan {
    return [[NSString alloc] initWithFormat:@"%ld-%ld", weekdaySpan.begin, weekdaySpan.end];
}
+ (LyWeekdaySpan)weekdaySpanFromString:(NSString *)strWeekdaySpan {
    NSArray *arr = [LyUtil separateString:strWeekdaySpan separator:@"-"];
    LyWeekdaySpan ws;
    if (!arr || arr.count < 2) {
        ws.begin = 0;
        ws.end = 0;
    } else {
        ws.begin = [[arr objectAtIndex:0] integerValue];
        ws.end = [[arr objectAtIndex:1] integerValue];
    }
    
    return ws;
}
+ (NSString *)weekdaySpanChineseStringFrom:(LyWeekdaySpan)weekdaySpan {
    return [[NSString alloc] initWithFormat:@"%@-%@", [LyUtil weekdayStringFrom:weekdaySpan.begin], [LyUtil weekdayStringFrom:weekdaySpan.end]];
}
+ (LyWeekdaySpan)weekdaySpanFromChineseString:(NSString *)strWeekdaySpan {
    NSArray *arr = [LyUtil separateString:strWeekdaySpan separator:@"-"];
    LyWeekdaySpan ws;
    if (!arr || arr.count < 2) {
        ws.begin = 0;
        ws.end = 0;
    } else {
        ws.begin = [LyUtil weekdayFromString:[arr objectAtIndex:0]];
        ws.end = [LyUtil weekdayFromString:[arr objectAtIndex:1]];
    }
    
    return ws;
}
+ (NSString *)weekdaySpanChineseStringFromString:(NSString *)strWeekdaySpan {
    return [LyUtil weekdaySpanChineseStringFrom:[LyUtil weekdaySpanFromString:strWeekdaySpan]];
}
#pragma mark 时间段
+ (nullable NSString *)timeBucketStringFrom:(LyTimeBucket)timeBucket {// needHandle:(BOOL)needHandle {
    return [[NSString alloc] initWithFormat:@"%d-%d", timeBucket.begin, timeBucket.end];
}
+ (LyTimeBucket)timeBucketFromString:(nullable NSString *)strTimeBucket {
    NSArray *arr = [LyUtil separateString:strTimeBucket separator:@"-"];
    LyTimeBucket tb;
    if (!arr || arr.count < 2) {
        tb.begin = 0;
        tb.end = 0;
    } else {
        tb.begin = [[arr objectAtIndex:0] intValue];
        tb.end = [[arr objectAtIndex:1] intValue];
    }
    
    return tb;
}
+ (nullable NSString *)timeBucketChineseStringFrom:(LyTimeBucket)timeBucket {// needHandle:(BOOL)needHandle {
    return [[NSString alloc] initWithFormat:@"%@-%@", [LyUtil transmitTimeBucketIndexToTime:timeBucket.begin], [LyUtil transmitTimeBucketIndexToTime:timeBucket.end]];
}
//+ (LyTimeBucket)timeBucketFromChineseString:(nullable NSString *)strTimeBucket {
//    NSArray *arr = [LyUtil separateString:strTimeBucket separator:@"-"];
//    LyTimeBucket tb;
//    if (!arr || arr.count < 2) {
//        tb.begin = 0;
//        tb.end = 0;
//    } else {
//        tb.begin = [[arr objectAtIndex:0] intValue];
//        tb.end = [[arr objectAtIndex:1] intValue];
//    }
//    
//    return tb;
//}
+ (NSString *)transmitTimeBucketIndexToTime:(NSInteger)timeBucket
{
    return [[NSString alloc] initWithFormat:@"%ld:%@", timeBucket/2, ( 0 == timeBucket%2) ? @"00" : @"30" ];
}





#pragma mark 默认头像
+ (UIImage *)defaultAvatarForStudent {
    if (!defaultAvatarForStudent) {
        defaultAvatarForStudent = [LyUtil imageForImageName:@"ct_avatar" needCache:NO];
    }
    
    return defaultAvatarForStudent;
}

+ (UIImage *)defaultAvatarForTeacher {
    if (!defaultAvatarForTeacher) {
        defaultAvatarForTeacher = [LyUtil imageForImageName:@"ds_avatar" needCache:NO];
    }
    
    return defaultAvatarForTeacher;
}




+ (LyUserType)userTypeFromString:(NSString *)strUserType {
    
    if ([strUserType isEqualToString:@"jl"]) {
        return LyUserType_coach;
    } else if ([strUserType isEqualToString:@"jx"]) {
        return LyUserType_school;
    } else if ([strUserType isEqualToString:@"zdy"]) {
        return LyUserType_guider;
    } else {
        return LyUserType_normal;
    }
}

+ (NSString *)userTypeStringFrom:(LyUserType)userType {
    NSString *strUserType;
    switch (userType) {
        case LyUserType_normal: {
            strUserType = @"xy";
            break;
        }
        case LyUserType_coach: {
            strUserType = @"jl";
            break;
        }
        case LyUserType_school: {
            strUserType = @"jx";
            break;
        }
        case LyUserType_guider: {
            strUserType = @"zdy";
            break;
        }
        default: {
            strUserType = @"xy";
            break;
        }
    }
    
    return strUserType;
}
+ (NSString *)userTypeChineseStringFrom:(LyUserType)userType {
    NSString *strUserType;
    switch (userType) {
        case LyUserType_normal: {
            strUserType = LyLocalize(@"学员");
            break;
        }
        case LyUserType_coach: {
            strUserType = LyLocalize(@"教练");
            break;
        }
        case LyUserType_school: {
            strUserType = LyLocalize(@"驾校");
            break;
        }
        case LyUserType_guider: {
            strUserType = LyLocalize(@"指导员");
            break;
        }
        default: {
            strUserType = LyLocalize(@"学员");
            break;
        }
    }
    
    return strUserType;
}





+ (NSString *)getUserNameWithUserId:(NSString *)userId
{
    if ( !userId || [userId isKindOfClass:[NSNull class]] || [userId isEqualToString:@""])
    {
        return @"匿名用户";
    }
    
    
    NSString *strResult = [LyHttpRequest getUserName:userId];
    
    NSDictionary *dic = [self getObjFromJson:strResult];
    if ( !dic || [NSNull null] == (NSNull *)dic || ![dic isKindOfClass:[NSDictionary class]] || ![dic count])
    {
        return @"匿名用户";
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if ( !strCode || [NSNull null] == (NSNull *)strCode || [strCode isEqualToString:@""] || ![strCode isEqualToString:@"0"])
    {
        return @"匿名用户";
    }
    
    NSDictionary *dicResult = [dic objectForKey:resultKey];
    if ( !dicResult || [NSNull null] == (NSNull *)dicResult || ![dicResult isKindOfClass:[NSDictionary class]] || ![dicResult count])
    {
        return @"匿名用户";
    }
    
    NSString *strUserName = [dicResult objectForKey:nickNameKey];
    if ( !strUserName)
    {
        strUserName = [[dic objectForKey:resultKey] objectForKey:nameKey];
    }
    if ( !strUserName)
    {
        strUserName = [[dic objectForKey:resultKey] objectForKey:trueNameKey];
    }
    
    if ( !strUserName || [NSNull null] == (NSNull *)strUserName || [strUserName isEqualToString:@""])
    {
        return @"匿名用户";
    }
    
    
    return strUserName;
}


#pragma mark 大图地址
+ (NSString *)bigPicUrl:(NSString *)strSmallPicUrl
{
    if ( !strSmallPicUrl || [strSmallPicUrl isKindOfClass:[NSNull class]] || [strSmallPicUrl isEqualToString:@""])
    {
        return @"";
    }
    NSRange rangeSmall = [strSmallPicUrl rangeOfString:@"small/"];
    
    
    if ( rangeSmall.length < 1)
    {
        rangeSmall = [strSmallPicUrl rangeOfString:@"small"];
    }
    
    if ( rangeSmall.length < 1)
    {
        return strSmallPicUrl;
    }
    
    NSMutableString *strResult = [[NSMutableString alloc] initWithString:[strSmallPicUrl substringToIndex:rangeSmall.location]];
    [strResult appendString:[strSmallPicUrl substringFromIndex:rangeSmall.location+rangeSmall.length]];
    
    return [strResult copy];
}



#pragma mark 用户头像地址
+ (NSURL *)getUserAvatarUrlWithUserId:(NSString *)userId
{
    return [NSURL URLWithString:[LyUtil getUserAvatarPathWithUserId:userId]];
}

+ (NSString *)getUserAvatarPathWithUserId:(NSString *)userId
{
    NSString *imageName = [[NSString alloc] initWithFormat:@"%@.png", userId];
    
    return getAvatar_url(imageName);
}

+ (NSURL *)getJpgUserAvatarUrlWithUserId:(NSString *)userId
{
    NSString *imageName = [[NSString alloc] initWithFormat:@"%@.jpg", userId];
    
    return [NSURL URLWithString:getAvatar_url(imageName)];
}
#pragma mark 获取图片尺寸
+ (CGSize)getSizeOfPngImageWithUrlString:(NSString *)strUrl
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strUrl]];
    
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:nil
                                                     error:nil];
    
    int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
    
    [data getBytes:&w1 range:NSMakeRange(0, 1)];
    
    [data getBytes:&w2 range:NSMakeRange(1, 1)];
    
    [data getBytes:&w3 range:NSMakeRange(2, 1)];
    
    [data getBytes:&w4 range:NSMakeRange(3, 1)];
    
    int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
    
    int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
    
    [data getBytes:&h1 range:NSMakeRange(4, 1)];
    
    [data getBytes:&h2 range:NSMakeRange(5, 1)];
    
    [data getBytes:&h3 range:NSMakeRange(6, 1)];
    
    [data getBytes:&h4 range:NSMakeRange(7, 1)];
    
    int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
    
    
    
    return CGSizeMake(w, h);
}
#pragma mark 获取驾校banner图
+ (UIImage *)getBannerFromServerWithUrl:(NSString *)strUrl
{
    UIImage *image = [self getPicFromServerWithUrl:strUrl isBig:NO];
    if ( !image)
    {
        image = [LyUtil imageForImageName:@"dsd_banner_default" needCache:NO];
    }
    
    return image;
}
#pragma mark 获取驾校banner图
+ (UIImage *)getBannerFromServerWithUseId:(NSString *)userId
{
    NSString *strImageName = [[NSString alloc] initWithFormat:@"%@.png", userId];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:getDriveSchoolBanner(strImageName)]]];
    
    if ( !image)
    {
        image = [LyUtil imageForImageName:@"dsd_banner_default" needCache:NO];
    }
    
    return image;
}
#pragma mark 获取图片
#pragma mark 获取图片
+ (UIImage *)getPicFromServerWithUrl:(NSString *)strUrl isBig:(BOOL)isBig
{
    if ( !strUrl || [strUrl isKindOfClass:[NSNull class]] || ![strUrl isKindOfClass:[NSString class]] || [strUrl isEqualToString:@""])
    {
        return nil;
    }
    
    NSString *ultimateUrl;
    if ( isBig)
    {
        NSRange rangeSmall = [strUrl rangeOfString:@"small/"];
        NSMutableString *tmpUrl = [[NSMutableString alloc] initWithString:[strUrl substringToIndex:rangeSmall.location]];
        [tmpUrl appendString:[strUrl substringFromIndex:rangeSmall.location+rangeSmall.length]];
        
        ultimateUrl = [[NSString alloc] initWithFormat:@"%@", tmpUrl];
    }
    else
    {
        ultimateUrl = strUrl;
    }
    
    NSURL *url = [NSURL URLWithString:[ultimateUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    
    return image;
}

#pragma mark 获取普通用户头像
+ (UIImage *)getImageFromServerWithUserId:(NSString *)userId
{
    if (!userId)
    {
        return nil;
    }
    
    NSString *imageName = [[NSString alloc] initWithFormat:@"%@.png", userId];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:getAvatar_url(imageName)]]];
    ;
    
    if ( !image)
    {
        imageName = [[NSString alloc] initWithFormat:@"%@.jpg", userId];
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:getAvatar_url(imageName)]]];
    }
    
    if ( !image)
    {
        imageName = [[NSString alloc] initWithFormat:@"%@.jpeg", userId];
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:getAvatar_url(imageName)]]];
    }
    
    if ( !image)
    {
        image = [LyUtil imageForImageName:@"ct_avatar" needCache:NO];
    }
    
    return image;
}
#pragma mark 获取并保存
+ (UIImage *)getAndSaveAvatarWithUserId:(NSString *)userId
{
    UIImage *image = [LyUtil getDschAvatarwithUserId:userId];
    
    [self saveImage:image withUserId:userId withMode:LySaveImageMode_avatar];
    
    return image;
}
#pragma mark 存图
+ (void)saveImage:(UIImage *)image withUserId:(NSString *)userId withMode:(LySaveImageMode)mode
{
    dispatch_queue_t globalQueue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        NSData *imageData = UIImagePNGRepresentation(image);
        
        NSString *strImagePath;
        switch ( mode) {
            case LySaveImageMode_avatar: {
                strImagePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"%@avatar.png", userId]];
                break;
            }
            case LySaveImageMode_qrCode: {
                strImagePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"%@qrCode.png", userId]];
                break;
            }
            default:
            {
                strImagePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"%@avatar.png", userId]];
                break;
            }
        }
        
        [imageData writeToFile:strImagePath atomically:YES];
    });
    
}
#pragma mark 从本地获取用户头像
+ (UIImage *)getAvatarFromDocumentWithUserId:(NSString *)userId
{
    NSString *strImagePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"%@avatar.png", userId]];
    UIImage *image = [UIImage imageWithContentsOfFile:strImagePath];
    
    if (!image) {
        image = [LyUtil defaultAvatarForTeacher];
    }
    
    return image;
}
#pragma mark 根据图片名获取用户头像
+ (UIImage *)getUserAvatarWithAvatarName:(NSString *)avatarName isTeacher:(BOOL)isTeacher
{
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:getAvatar_url(avatarName)]]];
    
    if (!image)
    {
        if (isTeacher)
        {
            image = [LyUtil imageForImageName:@"ds_avatar" needCache:NO];
        }
        else
        {
            image = [LyUtil imageForImageName:@"ct_avatar" needCache:NO];
        }
    }
    
    return image;
}
#pragma mark 获取用户头像
+ (UIImage *)getUserAvatarwithUserId:(NSString *)userId
{
    if ( !userId || [NSNull null] == (NSNull *)userId || [userId isEqualToString:@""])
    {
        return nil;
    }
    UIImage *image = [LyUtil getImageFromServerWithUserId:userId];
    
    if ( !image)
    {
        image = [LyUtil imageForImageName:@"ct_avatar" needCache:NO];
    }
    
    return image;
}
#pragma mark 获取驾校头像
+ (UIImage *)getDschAvatarwithUserId:(NSString *)userIdForDsch
{
    NSString *imageName = [[NSString alloc] initWithFormat:@"%@.png", userIdForDsch];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:getAvatar_url(imageName)]]];
    
    if (!image) {
        imageName = [[NSString alloc] initWithFormat:@"%@.jpg", userIdForDsch];
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:getAvatar_url(imageName)]]];
    }
    
    if (!image) {
        imageName = [[NSString alloc] initWithFormat:@"%@.jpeg", userIdForDsch];
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:getAvatar_url(imageName)]]];
    }
    
    if ( !image) {
        image = [LyUtil imageForImageName:@"ds_avatar" needCache:NO];
    }
    
    return image;
    
}




#pragma mark 颜色生成图
+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size
{
    CGRect rect = CGRectMake( 0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor( context, [color CGColor]);
    CGContextFillRect( context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    return image;
}




#pragma mark Swift
+ (NSRange)rangeOf:(NSString *)fullStr subStr:(NSString *)subStr
{
    return [fullStr rangeOfString:subStr];
}





#pragma mark UIKeyboardWillShowNotification
- (void)actionForKeyboardWillShow {
    isKeybaordShowing = YES;
}

#pragma mark -UIKeyboardDidHideNotification
- (void)actionForKeybarodDidHide {
    isKeybaordShowing = NO;
}






@end




