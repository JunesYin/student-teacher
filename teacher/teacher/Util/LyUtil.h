//
//  LyUtil.h
//  LyMusic
//
//  Created by Junes on 16/3/4.
//  Copyright © 2016年 Junes. All rights reserved.
//




#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LySingleInstance.h"
#import "UIImage+Scale.h"

#import "Reachability.h"

#import "UIImageView+WebCache.h"
#import "LyMacro.h"
#import "LyHttpRequest.h"
#import "LyImageLoader.h"

#import "UIView+LyExtension.h"
#import "UIScrollView+LyExtension.h"





#pragma mark 满屏幕
#define SCREEN_BOUNDS                                   [[UIScreen mainScreen] bounds]
#define SCREEN_WIDTH                                 CGRectGetWidth([[UIScreen mainScreen] bounds])
#define SCREEN_HEIGHT                                CGRectGetHeight([[UIScreen mainScreen] bounds])

#pragma mark 屏幕x轴中点
#define SCREEN_CENTER_X                                 (SCREEN_WIDTH / 2.0)
#define SCREEN_CENTER_Y                                 (SCREEN_HEIGHT / 2.0)


#define STATUSBAR_NAVIGATIONBAR_HEIGHT                  64.0


#pragma mark 状态栏高度
#define STATUSBAR_HEIGHT                                 20

#pragma mark 导航栏高度
#define NAVIGATIONBAR_HEIGHT                             44

#define TABBAR_HEIGHT                                    [[self.tabBarController tabBar] frame].size.height


#define LyLocalize(key)                                 NSLocalizedString(key, key)
//#define LyLocalize(key, comment)                        NSLocalizedString(key, comment)


#pragma mark 517主题颜色
#define Ly517ThemeColor                                 [UIColor colorWithRed:255/255.0 green:90/255.0 blue:0/255.0 alpha:1]
//#define LyThemeButtonColor                              [UIColor colorWithRed:255/255.0 green:90/255.0 blue:0/255.0 alpha:.3f]
//#define [UIColor darkGrayColor]                                 [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1]
#define LyHighLightgrayColor                            [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1]
//#define LyWhiteLightgrayColor                           [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]
#define LyWhiteLightgrayColor                           [UIColor colorWithRed:239/255.0 green:239/255.0 blue:245/255.0 alpha:1]
#define LyTranparentWhiteLightgrayColor                 [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:0.7f]
#define LyBlackColor                                    [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1]
#define LyCellSelectedBackgroundColor                   [UIColor colorWithWhite:1 alpha:0.2f]
#define LyUserCenterCellSelectedBackgroundColor         [UIColor colorWithWhite:1 alpha:0.2f]
#define LyMaskColor                                     [UIColor colorWithWhite:0 alpha:0.6f]
#define LyLightMaskColor                                [UIColor colorWithWhite:1 alpha:0.5f]
#define LyWarnColor                                     LyWrongColor
#define LyNotificationColor                             [UIColor colorWithRed:255.0f/255.0f green:60/255.0 blue:50/255.0f alpha:1.0f]

#define LyGreenColor                                    [UIColor colorWithRed:40/255.0 green:195/255.0 blue:19/255.0 alpha:1]
#define LyBlueColor                                     [UIColor colorWithRed:0/255.0f green:162/255.0 blue:255/255.0f alpha:1.0f]
#define LyRedColor                                      [UIColor colorWithRed:232.0/255.0f green:11.0/255.0f blue:11.0/255.0f alpha:1]
#define LyOrangeColor                                   Ly517ThemeColor

#define LyRightColor                                    LyGreenColor
#define LyWrongColor                                    LyRedColor

#define viewTfBackColor                                 [UIColor colorWithWhite:1 alpha:0.1]



#define LyIndicatorColor                                [UIColor darkGrayColor]
#define LyTvFooterColor                                 [UIColor darkGrayColor]



#define LyFont(size)                                    [UIFont systemFontOfSize:size]
#define LyListTitleFont                                 LyFont(18)
#define LyListSortModeFont                              LyFont(14)
#define LyItemTitleFont                                 LyFont(16)

#define LyNavigationItemTitleFont                       LyFont(18)
#define LyNavigationItemHeight                          44


UIKIT_EXTERN CGFloat const LyViewErrorHeight;
UIKIT_EXTERN CGFloat const LyViewNullHeight;


UIKIT_EXTERN CGFloat const LyNullItemHeight;
#define LyNullItemTitleFont                             LyFont(18)
#define LyNullItemTextColor                             [UIColor lightGrayColor]
UIKIT_EXTERN CGFloat const LyLbNullHeight;
UIKIT_EXTERN CGFloat const LyLbErrorHeight;
#define LyLbErrorFont                                   LyFont(18)
#define LyLbErrorTextColor                              [UIColor lightGrayColor]




UIKIT_EXTERN NSString *const alertTitleForUpdate;
#define alertTitleForWiFi                           [LyUtil getAppDisplayName]
UIKIT_EXTERN NSString *const alertTitleForAddressBook;
UIKIT_EXTERN NSString *const alertTitleForAlbum;
UIKIT_EXTERN NSString *const alertTitleForCamera;
UIKIT_EXTERN NSString *const alertTitleForNotification;
UIKIT_EXTERN NSString *const alertTitleForLocatoinService;
UIKIT_EXTERN NSString *const alertTitleForLocate;

UIKIT_EXTERN NSString *const alertMessageForUpdate;
UIKIT_EXTERN NSString *const alertMessageForWiFi;
#define alertMessageForAddressBook                  [[NSString alloc] initWithFormat:@"请前往系统【设置】>【隐私】>【通讯录】允许“%@”访问通讯录", [LyUtil getAppDisplayName]]
#define alertMessageForAlbum                        [[NSString alloc] initWithFormat:@"请前往系统【设置】>【隐私】>【照片】允许“%@”访问照片", [LyUtil getAppDisplayName]]
#define alertMessageForCamera                       [[NSString alloc] initWithFormat:@"请前往系统【设置】>【隐私】>【相机】允许“%@”访问相机", [LyUtil getAppDisplayName]]
#define alertMessageForNotificaion                  [[NSString alloc] initWithFormat:@"请前往系统【设置】>【通知】>【%@】打开“允许通知”", [LyUtil getAppDisplayName]]
UIKIT_EXTERN NSString *const  alertMessageForLocationService;
#define alertMessageForLocate                       [[NSString alloc] initWithFormat:@"请前往系统【设置】>【隐私】>【定位服务】>【%@】允许“%@”访问位置信息", [LyUtil getAppDisplayName], [LyUtil getAppDisplayName]]



UIKIT_EXTERN CGFloat const maxPicWidth;
UIKIT_EXTERN CGFloat const maxPicHeight;

UIKIT_EXTERN CGFloat const maxPicWidth_WiFi;
UIKIT_EXTERN CGFloat const maxPicHeight_WiFi;


//UIKIT_EXTERN CGFloat const viewItemHeight;

UIKIT_EXTERN CGFloat const controlViewUsefulHeight;
UIKIT_EXTERN CGFloat const controlToolBarHeight;
UIKIT_EXTERN CGFloat const controlPickerHeight;
UIKIT_EXTERN CGFloat const controlPickerRowHeight;
#define controlPickerRowTitleFont                       LyFont(16)


UIKIT_EXTERN CGFloat const avatarSizeMax;



UIKIT_EXTERN int const remarkMaxCount;


UIKIT_EXTERN CGFloat const btnCornerRadius;
//UIKIT_EXTERN CGFloat const btnGetAuthCodeWidth;
//UIKIT_EXTERN CGFloat const btnGetAuthCodeHeight;



#define LyBtnMoreTitleFont                              LyFont(14)
UIKIT_EXTERN CGFloat const LyBtnMoreHeight;
UIKIT_EXTERN CGFloat const LyBtnMoreWidth;


#define LyChinaLocale                                   [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]


UIKIT_EXTERN NSTimeInterval const LyAnimationDuration;
UIKIT_EXTERN NSTimeInterval const LyDelayTime;



UIKIT_EXTERN CGFloat const LyViewHeaderHeight;
UIKIT_EXTERN CGFloat const LyViewItemHeight;
UIKIT_EXTERN CGFloat const LyLbTitleItemWidth;
UIKIT_EXTERN CGFloat const LyLbTitleItemHeight;
#define LyLbTitleItemFont                               LyFont(16)

UIKIT_EXTERN int const autoLoadMoreMaxCount;

UIKIT_EXTERN int const driveSchoolListMaxCount;
UIKIT_EXTERN int const coachListMaxCount;
UIKIT_EXTERN int const guiderListMaxCount;



UIKIT_EXTERN float const showDistanceMax;


UIKIT_EXTERN int const coordinateRandBase;
UIKIT_EXTERN float const coordinateRandBase_all;
UIKIT_EXTERN float const coordinateRandBase_search;

#pragma mark 定位变化
UIKIT_EXTERN NSString *const LyNofiticationForRequestLocate;
UIKIT_EXTERN NSString *const LyNotificationForLocationChanged;
UIKIT_EXTERN NSString *const LyNotificationForAddressTranslated;


UIKIT_EXTERN NSString *const LyNotificationForHttpRequest;
UIKIT_EXTERN NSString *const LyNotificationForUserCenterPush;
UIKIT_EXTERN NSString *const LyAppDidEnterBackground;
UIKIT_EXTERN NSString *const LyAppDidBecomeActive;
UIKIT_EXTERN NSString *const LyNotificationForLogout;

UIKIT_EXTERN NSString *const LyNotificationForLogoutObjectAutoLogin;

UIKIT_EXTERN NSString *const LyNotificationForJumpReady;



UIKIT_EXTERN NSString *const areaKey;
UIKIT_EXTERN NSString *const provinceKey;
UIKIT_EXTERN NSString *const cityKey;
UIKIT_EXTERN NSString *const districtKey;

UIKIT_EXTERN NSString *const currentUserKey;
UIKIT_EXTERN NSString *const userKey;
UIKIT_EXTERN NSString *const coachKey;
UIKIT_EXTERN NSString *const schoolKey;
UIKIT_EXTERN NSString *const guiderKey;



UIKIT_EXTERN NSString *const lbNameWhole;
UIKIT_EXTERN NSString *const lbNamePrepay;


UIKIT_EXTERN NSString *const phoneNum_517;
UIKIT_EXTERN NSString *const messageNum_517;



UIKIT_EXTERN CGFloat const horizontalSpace;
UIKIT_EXTERN CGFloat const verticalSpace;




UIKIT_EXTERN CGFloat const imageSizeMaxWidth;
UIKIT_EXTERN CGFloat const imageSizeMaxHeight;




UIKIT_EXTERN CGFloat const sparaterLineHeight;

UIKIT_EXTERN CGFloat const LyHorizontalLineHeight;
#define LyHorizontalLineColor                           [UIColor lightGrayColor]


UIKIT_EXTERN int const detailEvaOrConCount;


UIKIT_EXTERN NSString *const autoJumpToNexFlag;
UIKIT_EXTERN NSString *const autoExcludeFlag;



UIKIT_EXTERN CGFloat const bottomControlHideCerticality;


UIKIT_EXTERN NSString *const goodKey;
UIKIT_EXTERN NSString *const teacherKey;

UIKIT_EXTERN NSString *const LyFooterTitle_error;


UIKIT_EXTERN NSString *const mapBtnLocateDefaultTitle;

UIKIT_EXTERN NSString *const LyIndicatorTitle_load;
UIKIT_EXTERN NSString *const LyIndicatorTitle_upload;
UIKIT_EXTERN NSString *const LyIndicatorTitle_modify;
UIKIT_EXTERN NSString *const LyIndicatorTitle_cancel;
UIKIT_EXTERN NSString *const LyIndicatorTitle_delete;
UIKIT_EXTERN NSString *const LyIndicatorTitle_confirm;
UIKIT_EXTERN NSString *const LyIndicatorTitle_evaluate;
UIKIT_EXTERN NSString *const LyIndicatorTitle_attente;
UIKIT_EXTERN NSString *const LyIndicatorTitle_deattente;
UIKIT_EXTERN NSString *const LyIndicatorTitle_commit;
UIKIT_EXTERN NSString *const LyIndicatorTitle_replace;
UIKIT_EXTERN NSString *const LyIndicatorTitle_transmit;
UIKIT_EXTERN NSString *const LyIndicatorTitle_add;
UIKIT_EXTERN NSString *const LyIndicatorTitle_verify;
UIKIT_EXTERN NSString *const LyIndicatorTitle_reply;

UIKIT_EXTERN NSString *const LyRemindTitle_sensitiveWord;

UIKIT_EXTERN int const LyUserIdLength;
UIKIT_EXTERN int const LyAccountLength;
UIKIT_EXTERN int const LyAuthCodeLength;
UIKIT_EXTERN int const LyPasswordLengthMin;
UIKIT_EXTERN int const LyPasswordLengthMax;
UIKIT_EXTERN int const LyNewsLengthMax;
UIKIT_EXTERN int const LyEvaluationLengthMax;
UIKIT_EXTERN int const LySignatureLengthMax;
UIKIT_EXTERN int const LyReplyLengthMax;
UIKIT_EXTERN int const LyNameLengthMax;
UIKIT_EXTERN int const LyPriceLengthMax;

UIKIT_EXTERN NSTimeInterval const validateSensitiveWordDelayTime;
UIKIT_EXTERN NSTimeInterval const closeDelayTime;

UIKIT_EXTERN int const dateStringLength;


UIKIT_EXTERN CGFloat const lbItemHeight;
UIKIT_EXTERN CGFloat const btnCloseSize;
UIKIT_EXTERN CGFloat const ivMoreSize;


UIKIT_EXTERN CGFloat const LyChatCellHeightMin;
UIKIT_EXTERN CGFloat const LyChatCellHeightMax;



typedef NS_ENUM( NSInteger, LyMapAddAnnonationMode)
{
    LyMapAddAnnonationMode_all,
    LyMapAddAnnonationMode_search
};

typedef NS_ENUM( NSInteger, LyLocateMode)
{
    LyLocateMode_auto,
    LyLocateMode_pick
};


typedef NS_ENUM( NSInteger, LyUserType)
{
    LyUserType_normal,
    LyUserType_coach,
    LyUserType_school,
    LyUserType_guider
};


typedef NS_ENUM( NSInteger, LyCoachMode)
{
    LyCoachMode_normal,
    LyCoachMode_alone,
    LyCoachMode_boss,
    LyCoachMode_staff
};


typedef NS_ENUM( NSInteger, LySex)
{
    LySexUnkown,
    LySexMale,
    LySexFemale
};





typedef NS_ENUM( NSInteger, LyApplyMode)
{
    LyApplyMode_whole,
    LyApplyMode_prepay
};



typedef NS_ENUM( NSInteger, LyOrderInfoButtonTag)
{
    orderInfoButtonTag_cancel = 70,
    orderInfoButtonTag_delete,
    orderInfoButtonTag_refund,
    
    
    orderInfoButtonTag_pay,
    orderInfoButtonTag_reapply,
    orderInfoButtonTag_confirm,
    orderInfoButtonTag_evalute,
    orderInfoButtonTag_evaluteAgain
};


typedef NS_ENUM( NSInteger, LyLicenseType)
{
    LyLicenseType_C1,
    LyLicenseType_C2,
    LyLicenseType_C3,
    LyLicenseType_C4,
    LyLicenseType_C5,
    
    LyLicenseType_A1,
    LyLicenseType_A3,
    LyLicenseType_B1,
    
    LyLicenseType_B2,
    LyLicenseType_A2,
    
    LyLicenseType_D,
    LyLicenseType_E,
    LyLicenseType_F,
    
    LyLicenseType_M
};


typedef NS_ENUM( NSInteger, LySubjectMode)
{
    LySubjectMode_first = 1,
    LySubjectMode_second,
    LySubjectMode_third,
    LySubjectMode_fourth,
    LySubjectMode_finish
};

typedef NS_ENUM( NSInteger, LySubjectModeprac)
{
    LySubjectModeprac_second = LySubjectMode_second,
    LySubjectModeprac_third = LySubjectMode_third,
};


typedef NS_ENUM(NSInteger, LyWeekday) {
    LyWeekday_monday,
    LyWeekday_tuesday,
    LyWeekday_wednesday,
    LyWeekday_thursday,
    LyWeekday_friday,
    LyWeekday_saturday,
    LyWeekday_sunday
};


typedef NS_ENUM(NSInteger, LyPayInfo)
{
    LyPayInfo_whole = 0,
    LyPayInfo_prepay,
    LyPayInfo_notyet
};


typedef NS_ENUM( NSInteger, LyUserLevel)
{
    LyUserLevel_killer,   //杀手
    LyUserLevel_newbird,  //菜鸟
    LyUserLevel_mass,     //群众
    LyUserLevel_superior, //达人
    LyUserLevel_master    //大师
};





typedef NS_ENUM( NSInteger, LyUIImageMode)
{
    LyUIImageMode_JPG,
    LyUIImageMode_PNG,
    LyUIImageMode_Unknown
};


typedef NS_ENUM( NSInteger, LySaveImageMode)
{
    LySaveImageMode_avatar,
    LySaveImageMode_qrCode
};



typedef NS_ENUM(NSInteger, LyControlBarButtonItemMode)
{
    LyControlBarButtonItemMode_cancel = 1,
    LyControlBarButtonItemMode_done,
    LyControlBarButtonItemMode_ext
};



#pragma mark 培训课程相关
typedef NS_ENUM( NSInteger, LyTrainClassMode)
{
    LyTrainClassMode_coach = 1,
    LyTrainClassMode_driveSchool,
    LyTrainClassMode_guider
};



typedef NS_ENUM( NSInteger, LyTrainClassPickType)
{
    LyTrainClassPickType_none,
    LyTrainClassPickType_bus,
};



typedef NS_ENUM( NSInteger, LyTrainClassTrainMode)
{
    LyTrainClassTrainMode_one = 1,
//    LyTrainClassTrainMode_four,
    LyTrainClassTrainMode_multi,
    
};


struct LyTrainClassObjectPeriod {
    int secondPeriod;
    int thirdPeriod;
};
typedef struct LyTrainClassObjectPeriod LyTrainClassObjectPeriod;


struct LyWeekdaySpan {
    LyWeekday begin;
    LyWeekday end;
};
typedef struct LyWeekdaySpan LyWeekdaySpan;


struct LyTimeBucket {
    int begin;
    int end;
};
typedef struct LyTimeBucket LyTimeBucket;


typedef NS_ENUM(NSInteger, LyAlertViewForAuthorityMode) {
    LyAlertViewForAuthorityMode_WiFi,
    LyAlertViewForAuthorityMode_addressBook,
    LyAlertViewForAuthorityMode_album,
    LyAlertViewForAuthorityMode_camera,
    LyAlertViewForAuthorityMode_notification,
};



typedef NS_ENUM(NSInteger, LyWebMode) {
    LyWebMode_userProtocol,
    
    LyWebMode_FAQ,
    
    LyWebMode_studyFlow,
    LyWebMode_outline,
    LyWebMode_selectionGuide,
    LyWebMode_applyNote,
    LyWebMode_physicalExam,
    LyWebMode_studyFee,
    LyWebMode_cheating,
    LyWebMode_deformedMan,
    
    LyWebMode_studySelf,
    LyWebMode_studyCost,
    
    LyWebMode_schoolProtocol,
    LyWebMode_coaInsProtocol
};


typedef NS_ENUM(NSInteger, LyPushMode) {
    /* student - reservation not finish */
    LyPushMode_reserNoFinish = 1001,
    /* teacher - new reservation */
    LyPushMode_newReservation = 1002,
    /* teacher - new order */
    LyPushMode_newOrder = 1003,
    /* all - new reply to evaluation */
    LyPushMode_newEvaRep = 1004,
    /* teacher - new consult */
    LyPushMode_newConsult = 1005,
    /* all - new reply to consult */
    LyPushMode_newConRep = 1006,
    /* teacher - new evaluation */
    LyPushMode_newEva = 1007,
    
    LyPushMode_local_theory = 10000,
};



@class CLLocation;
@protocol MFMessageComposeViewControllerDelegate;


@protocol LyUtilAnalysisHttpResultDelegate <NSObject>

- (void)handleHttpFailed:(BOOL)needRemind;

@end



NS_ASSUME_NONNULL_BEGIN


@interface LyUtil : NSObject

@property ( assign, nonatomic, getter=isForbidRemindNetwork)    BOOL            forbidRemindNetwork;
@property ( assign, nonatomic, getter=isForbidRemindLocate)     BOOL            forbidRemindLocate;

lySingle_interface


#pragma mark Push
+ (BOOL)isReady;
+ (void)ready:(BOOL)flag target:(nullable __kindof UIViewController *)target;
//+ (BOOL)isLaunchByPush;
//+ (void)launchByPush;


#pragma mark - timeFlag
+ (BOOL)timeFlag;


#pragma mark 键盘
+ (BOOL)isKeybaordShowing;


#pragma mark 机器及系统信息
+ (nullable NSString *)machineName;
+ (nullable NSString *)osName;
+ (float)osVersion;


#pragma mark iOS 10干掉了所的有 Url Scheme
//+ (void)showAlertView:(LyAlertViewForAuthorityMode)mode;
+ (void)showAlert:(LyAlertViewForAuthorityMode)mode vc:(nullable __kindof UIViewController *)vc;
+ (void)openUrl:(nullable NSURL *)url;


#pragma mark 打电话
+ (void)call:(nullable NSString *)phone;
+ (void)sendSMS:(nullable NSString *)bodyOfMessage recipients:(nullable NSArray *)recipients target:(__kindof UIViewController <MFMessageComposeViewControllerDelegate> * _Nonnull)target;




#pragma mark 当前app版本信息
+ (nullable NSString *)getApplicationVersion;
+ (nullable NSString *)getApplicationVersionNoPoint;
+ (nullable NSString *)getApplicationBuildVersion;
+ (nullable NSString *)getAppUrlScheme;
+ (nullable NSString *)getAppDisplayName;


#pragma mark 设置上线当前最新的app版本号
+ (void)setNewestAppVersion:(nullable NSString *)newestVersion;
+ (nullable NSString *)newestAppVersion;
+ (void)setLowestAppVersion:(nullable NSString *)lowestVersion;
+ (nullable NSString *)lowestAppVersion;


#pragma mark 当前网络网状态
+ (void)networkStatusChanged:(NetworkStatus)status;
+ (NetworkStatus)currentNetworkStatus;


#pragma mark bundle文件读取
+ (nullable UIImage *)imageForImageName:(nullable NSString *)imageName needCache:(BOOL)needCache;
+ (nullable NSString *)imagePathForImageName:(nullable NSString *)imageName;
+ (nullable NSString *)filePathForFileName:(nullable NSString *)fileName;


#pragma mark 验证对象是否合法
+ (BOOL)validateDictionary:(nullable id)obj;
+ (BOOL)validateArray:(nullable id)obj;
+ (BOOL)validateString:(nullable id)obj;
+ (BOOL)validateUserId:(nullable NSString *)userId;

#pragma mark 加密
+ (nullable NSString *)base64forData:(nullable NSData *)theData;
+ (nullable NSString *)encodeAuthCode:(nullable NSString *)authCode;
+ (nullable NSString *)encodePassword:(nullable NSString *)pwd;
+ (nullable NSString *)md5:(nullable NSString *)str;



#pragma mark 设置自动登录
+ (void)setAutoLoginFlag:(BOOL)flag;


#pragma mark 是否已成功获取个人信息
+ (void)setFinishGetUserIfo:(BOOL)flag;
+ (BOOL)flagForGetUserInfo;


#pragma mark 会话id
+ (void)setHttpSessionId:(nullable NSString *)strHttpSessionId;
+ (nullable NSString *)httpSessionId;
+ (void)logout:(nullable NSString *)flag;
+ (void)sessionTimeOut;
+ (void)serverMaintaining;


+ (UIBarButtonItem *)barButtonItem:(NSInteger)tag imageName:(NSString *)imageName target:(id)target action:(SEL)action;


#pragma mark json解析与封装
+ (nullable NSString *)getJsonString:(nullable NSDictionary *)dictionary;
+ (nullable id)getObjFromJson:(nullable NSString *)jsonString;


#pragma mark analysis string from http
+ (NSDictionary *)analysisHttpResult:(NSString *)result delegate:(id<LyUtilAnalysisHttpResultDelegate>)delegate;

#pragma mark httpBody解析与封装
+ (NSString *)getHttpBody:(NSDictionary *)dictionary;
+ (NSDictionary *)getDicFromHttpBodyStr:(NSString *)strHttpBody;



#pragma mark 排除重复元素
//+ (__kindof NSArray *)singleElementArray:(__kindof NSArray *)arr;
+ (__kindof NSArray *)uniquifyArray:(__kindof NSArray *)arr key:(NSString *)key;
//+ (__kindof NSArray **)uniquifyArray:(__kindof NSArray **)arr key:(NSString *)key;
#pragma mark 数组排序
+ (__kindof NSArray *)sortArrByDate:(__kindof NSArray *)arr andKey:(NSString *)key asc:(BOOL)asc;
//+ (__kindof NSArray *)sortTeacherArr:(__kindof NSArray *)arr sortMode:(LySortMode)sortMode;
+ (__kindof NSArray *)sortArrByStr:(__kindof NSArray *)arr andKey:(NSString *)key;


#pragma mark 唯一化并排序
+ (__kindof NSArray *)uniquifyAndSort:(__kindof NSArray *)arr keyUniquify:(NSString *)keyUniquify keySort:(NSString *)keySort asc:(BOOL)asc;


#pragma mark 字符串处理
+ (nullable NSString *)translateTime:(nullable NSString *)strTime;
+ (nullable NSString *)cutTimeString:(nullable NSString *)strSour;
+ (nullable NSArray *)separateString:(nullable NSString *)strTime separator:(nullable NSString *)separator;
+ (nullable NSArray *)separateAnswerString:(nullable NSString *)strSour;
+ (nullable NSString *)getPinyinFromHanzi:(nullable NSString *)hanzi;
#pragma mark 支付宝结果解析
+ (nullable NSDictionary *)dicFormAliPayString:(nullable NSString *)sourString;
#pragma mark 隐藏电话号中间四位
+ (nullable NSString *)hidePhoneNumber:(nullable NSString *)strPhone;




#pragma mark 日期与时间
+ (nullable NSString *)timeNow;
+ (int)secondsFrom1970;
+ (nullable NSDateFormatter *)dateFormatterForYMD;
+ (nullable NSDateFormatter *)dateFormatterForAll;
+ (int)calculSecondsWithString:(nullable NSString *)strDate;
+ (int)calculSecondsWithDate:(nullable NSDate *)date;
+ (int)calculdateAgeWithStr:(nullable NSString *)birthday;
+ (int)calculdateAgeWithDate:(nullable NSDate *)birthday;
+ (nullable NSString *)fixDateTimeString:(nullable NSString *)strDateTime;
+ (nullable NSString *)fixDateTimeString:(nullable NSString *)strDateTime isExplicit:(BOOL)isExplicit;
+ (nullable NSDate *)dateWithString:(nonnull NSString *)dateStr;
+ (NSTimeInterval)compareDateByString:(nonnull NSString *)sDate_1 with:(nonnull NSString *)sDate_2;
+ (int)getDaysFrom:(nullable NSDate *)startDate To:(nullable NSDate *)endDate;
+ (nullable NSString *)stringOnlyDateFromDate:(nullable id)date;
+ (nullable NSString *)weekdayStringWithDate:(nullable id)date;
+ (LyWeekday)weekdayWithDate:(id)date;



#pragma mark 设置图片
+ (void)setScoreImageView:(nullable UIImageView *)imageView withScore:(float)score;
+ (void)setDegreeImageView:(nullable UIImageView *)imageView withDegree:(NSInteger)degree;
+ (void)setSexImageView:(nullable UIImageView *)imageView withUserSex:(LySex)sex;
+ (void)setUserLevelImageView:(nullable UIImageView *)imageView withUserLevel:(LyUserLevel)userLevel;
+ (void)setAttentionKindImageView:(nullable UIImageView *)imageView withMode:(LyUserType)userType;



#pragma mark 动画
+ (void)startAnimationWithView:(nonnull UIView *)view
             animationDuration:(NSTimeInterval)duration
                  initialPoint:(CGPoint)iniPoint
              destinationPoint:(CGPoint)desPoint
                    completion:(nullable void (^)(BOOL isFinished))completion;
+ (void)startAnimationWithView:(nonnull UIView *)view
             animationDuration:(NSTimeInterval)duration
                 initialOffset:(CGPoint)iniPoint
             destinationOffset:(CGPoint)desPoint
                    completion:(nullable void (^)(BOOL isFinished))completion;
+ (void)startAnimationWithView:(nonnull UIView *)view
             animationDuration:(NSTimeInterval)duration
                  initialColor:(nullable UIColor *)iniColor
              destinationColor:(nullable UIColor *)desColor
                    completion:(nullable void (^)(BOOL isFinished))completion;
+ (void)startAnimationWithView:(nonnull UIView *)view
             animationDuration:(NSTimeInterval)duration
                     initAlpha:(float)initAlpha
             destinationAplhas:(float)desAlpha
                     comletion:(nullable void(^)(BOOL isFinished))completion;



#pragma mark 生成控件
+ (nonnull UILabel *)lbTitleForNavigationBar:(nullable NSString *)title detail:(nullable NSString *)detail;
+ (nonnull UILabel *)lbTitleForNavigationBar:(nullable NSString *)title;
+ (nonnull UILabel *)lbItemTitleWithText:(nullable NSString *)text;
+ (nonnull UIRefreshControl *)refreshControlWithTitle:(nullable NSString *)title target:(nullable id)target action:(nonnull SEL)actoin;
+ (nonnull UILabel *)lbErrorWithMode:(NSInteger)mode;
+ (nonnull UILabel *)lbNullWithText:(nullable NSString *)text;



#pragma mark 数值转换
+ (nullable NSString *)translateSecondsToClock:(NSInteger)seconds;
+ (nullable NSString *)transmitNumWithWan:(NSInteger)num;
+ (nullable NSString *)getDistance:(float)distance;



#pragma mark 驾照类型
+ (nullable NSArray *)arrDriveLicenses;
+ (nullable NSString *)driveLicenseStringFrom:(LyLicenseType)driveLicense;
+ (LyLicenseType)driveLicenseFromString:(nullable NSString *)strDriveLicens;
#pragma mark 练车方式
+ (nullable NSArray *)arrTrainModes;
+ (nullable NSString *)trainModeStringFrom:(LyTrainClassTrainMode)trainType;
+ (LyTrainClassTrainMode)trainModeFromString:(nullable NSString *)strTrainType;
#pragma mark 接送方式
+ (nullable NSString *)pickTypeStringFrom:(LyTrainClassPickType)pickType;
+ (LyTrainClassPickType)pickTypeFromString:(nullable NSString *)strPickType;
#pragma mark 科目进度
+ (nullable NSArray *)arrSubjectMode;
+ (nullable NSString *)subjectModeStringFrom:(LySubjectMode)subjectMode;
+ (LySubjectMode)subjectModeFromString:(nullable NSString *)strSubjectMode;
#pragma mark 科目-实践
+ (nullable NSArray *)arrSubjectModePrac;
+ (nullable NSString *)subjectModePracStringForm:(LySubjectModeprac)subjectMode;
+ (LySubjectModeprac)subjectModePracFromString:(nullable NSString *)strSubjectMode;
#pragma mark 付款情况
+ (nullable NSArray *)arrPayInfo;
+ (nullable NSString *)payInfoStringFrom:(LyPayInfo)payInfo;
+ (LyPayInfo)payInfoFromString:(nullable NSString *)strPayInfo;
#pragma mark 星期几
+ (nullable NSArray *)arrWeekdays;
+ (nullable NSString *)weekdayStringFrom:(LyWeekday)weekday;
+ (LyWeekday)weekdayFromString:(nullable NSString *)strWeekday;
+ (nullable NSString *)getWeekdayWithIndex:(NSInteger)index;
+ (NSInteger)getWeekdayIndex:(nullable NSString *)strWeekday;
+ (nullable NSString *)weekdaySpanStringFrom:(LyWeekdaySpan)weekdaySpan;
+ (LyWeekdaySpan)weekdaySpanFromString:(nullable NSString *)strWeekdaySpan;
+ (nullable NSString *)weekdaySpanChineseStringFrom:(LyWeekdaySpan)weekdaySpan;
+ (LyWeekdaySpan)weekdaySpanFromChineseString:(nullable NSString *)strWeekdaySpan;
+ (nullable NSString *)weekdaySpanChineseStringFromString:(nullable NSString *)strWeekdaySpan;
#pragma mark 时间段
+ (nullable NSString *)timeBucketStringFrom:(LyTimeBucket)timeBucket;// needHandle:(BOOL)needHandle;
+ (LyTimeBucket)timeBucketFromString:(nullable NSString *)strTimeBucket;
+ (nullable NSString *)timeBucketChineseStringFrom:(LyTimeBucket)timeBucket;// needHandle:(BOOL)needHandle;
//+ (LyTimeBucket)timeBucketFromChineseString:(nullable NSString *)strTimeBucket;
+ (nullable NSString *)transmitTimeBucketIndexToTime:(NSInteger)timeBucket;

#pragma mark 默认头像
+ (nullable UIImage *)defaultAvatarForStudent;
+ (nullable UIImage *)defaultAvatarForTeacher;


#pragma mark 用户
+ (LyUserType)userTypeFromString:(nullable NSString *)strUserType;
+ (nullable NSString *)userTypeStringFrom:(LyUserType)userType;
+ (NSString *)userTypeChineseStringFrom:(LyUserType)userType;


#pragma mark 获取用户名
+ (nullable NSString *)getUserNameWithUserId:(nullable NSString *)userId;

#pragma mark 大图地址
+ (nullable NSString *)bigPicUrl:(nullable NSString *)strSmallPicUrl;

#pragma mark 用户头像地址
+ (nullable NSURL *)getUserAvatarUrlWithUserId:(nullable NSString *)userId;
+ (nullable NSString *)getUserAvatarPathWithUserId:(nullable NSString *)userId;
+ (nullable NSURL *)getJpgUserAvatarUrlWithUserId:(nullable NSString *)userId;
#pragma mark 获取图片尺寸
+ (CGSize)getSizeOfPngImageWithUrlString:(nullable NSString *)strUrl;
#pragma mark 获取驾校banner图
+ (nullable UIImage *)getBannerFromServerWithUrl:(nullable NSString *)strUrl;
+ (nullable UIImage *)getBannerFromServerWithUseId:(nullable NSString *)userId;
#pragma mark 获取图片
+ (nullable UIImage *)getPicFromServerWithUrl:(nullable NSString *)strUrl isBig:(BOOL)isBig;
#pragma mark 获取普通用户头像
+ (nullable UIImage *)getImageFromServerWithUserId:(nullable NSString *)userId;
#pragma mark 获取并保存
+ (nullable UIImage *)getAndSaveAvatarWithUserId:(nullable NSString *)userId;
#pragma mark 存图
+ (void)saveImage:(nullable UIImage *)image withUserId:(nullable nullable NSString *)userId withMode:(LySaveImageMode)mode;
#pragma mark 从本地获取用户头像
+ (nullable UIImage *)getAvatarFromDocumentWithUserId:(nullable NSString *)userId;
#pragma mark 根据图片名获取用户头像
+ (nullable UIImage *)getUserAvatarWithAvatarName:(nullable NSString *)avatarName isTeacher:(BOOL)isTeacher;
#pragma mark 获取用户头像
+ (nullable UIImage *)getUserAvatarwithUserId:(nullable NSString *)userId;
#pragma mark 获取驾校头像
+ (nullable UIImage *)getDschAvatarwithUserId:(nullable NSString *)userIdForDsch;


#pragma mark 颜色生成图
+ (nullable UIImage *)imageWithColor:(nullable UIColor *)color withSize:(CGSize)size;



#pragma mark -
+ (void)showWebViewController:(LyWebMode)mode target:(__kindof UIViewController *)target;



#pragma mark Swift
+ (NSRange)rangeOf:(NSString *)fullStr subStr:(NSString *)subStr;



@end




NS_ASSUME_NONNULL_END
