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

#import "GIFLoader.h"
#import "UIImageView+WebCache.h"
#import "LyMacro.h"
#import "LyImageLoader.h"
#import "LyHttpRequest.h"
#import "FMDatabase.h"

#import "UIView+LyExtension.h"
#import "UIScrollView+LyExtension.h"





#pragma mark 满屏幕
#define SCREEN_BOUNDS                                   [[UIScreen mainScreen] bounds]
#define SCREEN_WIDTH                                    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT                                   [[UIScreen mainScreen] bounds].size.height

#pragma mark 屏幕x轴中点
#define SCREEN_CENTER_X                                 (SCREEN_WIDTH / 2.0)
#define SCREEN_CENTER_Y                                 (SCREEN_HEIGHT / 2.0)


#define STATUSBAR_NAVIGATIONBAR_HEIGHT                  64.0

#pragma mark 状态栏高度
#define STATUSBAR_HEIGHT                                 20.0

#pragma mark 导航栏高度
#define NAVIGATIONBAR_HEIGHT                             44.0
#define TABBAR_HEIGHT                                    [[self.tabBarController tabBar] frame].size.height


#define LyLocalize(key)                                 NSLocalizedString(key, key)
//#define LyLocalize(key, comment)                        NSLocalizedString(key, comment)


#pragma mark 517主题颜色
#define Ly517ThemeColor                                 [UIColor colorWithRed:255/255.0 green:90/255.0 blue:0/255.0 alpha:1]
#define LyThemeButtonColor                              [UIColor colorWithRed:255/255.0 green:90/255.0 blue:0/255.0 alpha:.3f]
#define LyGrayColor                                     [UIColor grayColor]
#define LyDarkgrayColor                                 [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1]
#define LyLightgrayColor                                [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1]
#define LyHighLightgrayColor                            [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1]
//#define LyWhiteLightgrayColor                           [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]
#define LyWhiteLightgrayColor                           [UIColor colorWithRed:239/255.0 green:239/255.0 blue:245/255.0 alpha:1]
#define LyTranparentWhiteLightgrayColor                 [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:0.7f]
#define LyBlackColor                                    [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1]
#define LyCellSelectedBackgroundColor                   [UIColor colorWithWhite:1 alpha:.2f]
#define LyUserCenterCellSelectedBackgroundColor         [UIColor colorWithWhite:1 alpha:.2f]
#define LyMaskColor                                     [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]
#define LyLightMaskColor                                [UIColor colorWithWhite:1 alpha:.5f]
#define LyWarnColor                                     LyWrongColor
#define LyNotificationColor                             [UIColor colorWithRed:255.0f/255.0f green:60/255.0 blue:50/255.0f alpha:1.0f]

#define LyGreenColor                                    [UIColor colorWithRed:40/255.0 green:195/255.0 blue:19/255.0 alpha:1]
#define LyBlueColor                                     [UIColor colorWithRed:0/255.0f green:162/255.0 blue:255/255.0f alpha:1.0f]
#define LyRedColor                                      [UIColor colorWithRed:232.0/255.0f green:11.0/255.0f blue:11.0/255.0f alpha:1]
#define LyOrangeColor                                   Ly517ThemeColor

#define LyRightColor                                    LyGreenColor
#define LyWrongColor                                    LyRedColor

#define viewTfBackColor                                 [UIColor colorWithWhite:1 alpha:0.1]



#define LyRefresherColor                                LyDarkgrayColor
#define LyIndicatorColor                                LyDarkgrayColor
#define LyTvFooterColor                                 LyDarkgrayColor



#define LyFont(size)                                    [UIFont systemFontOfSize:size]
#define LyListTitleFont                                 LyFont(18)
#define LyListSortModeFont                              LyFont(14)
#define LyItemTitleFont                                 LyFont(16)

#define LyNavigationItemTitleFont                       LyFont(18)
//#define                           44
UIKIT_EXTERN CGFloat const LyNavigationItemHeight;
UIKIT_EXTERN CGFloat const LyToolBarHeight;

UIKIT_EXTERN int const maxLoadGifCount;


#define LyTextFieldFont                                 LyFont(16)
#define LyFloatTextFont                                 LyFont(12)
#define LyFloatTextColor                                Ly517ThemeColor
#define LyFloatActiveTextColor                          LyLightgrayColor
#define LyAttributePlaceholderColor                     LyGrayColor


UIKIT_EXTERN CGFloat const LyViewErrorHeight;
UIKIT_EXTERN CGFloat const LyViewNullHeight;

UIKIT_EXTERN CGFloat const LyNullItemHeight;
#define LyNullItemTitleFont                             LyFont(18)
#define LyNullItemTextColor                             LyLightgrayColor
UIKIT_EXTERN CGFloat const LyLbNullHeight;
UIKIT_EXTERN CGFloat const LyLbErrorHeight;
#define LyLbErrorFont                                   LyFont(18)
#define LyLbErrorTextColor                              [UIColor lightGrayColor]



#define LyBtnMoreTitleFont                              LyFont(14)


UIKIT_EXTERN NSString *const alertTitleForUpdate;
#define alertTitleForWiFi                           [LyUtil getAppDisplayName]
UIKIT_EXTERN NSString *const alertTitleForAddressBook;
UIKIT_EXTERN NSString *const alertTitleForAlbum;
UIKIT_EXTERN NSString *const alertTitleForCamera;
UIKIT_EXTERN NSString *const alertTitleForNotification;
UIKIT_EXTERN NSString *const alertTitleForLocatoinService;
UIKIT_EXTERN NSString *const alertTitleForLocate;
UIKIT_EXTERN NSString *const alertTitleForApplePay;

UIKIT_EXTERN NSString *const alertMessageForUpdate;
UIKIT_EXTERN NSString *const alertMessageForWiFi;
UIKIT_EXTERN NSString *const alertMessageForAddressBook;
UIKIT_EXTERN NSString *const alertMessageForAlbum;
UIKIT_EXTERN NSString *const alertMessageForCamera;
UIKIT_EXTERN NSString *const alertMessageForNotificaion;
//#define alertMessageForAddressBook                  [[NSString alloc] initWithFormat:@"请前往系统【设置】>【隐私】>【通讯录】允许“%@”访问通讯录", [LyUtil getAppDisplayName]]
//#define alertMessageForAlbum                        [[NSString alloc] initWithFormat:@"请前往系统【设置】>【隐私】>【照片】允许“%@”访问照片", [LyUtil getAppDisplayName]]
//#define alertMessageForCamera                       [[NSString alloc] initWithFormat:@"请前往系统【设置】>【隐私】>【相机】允许“%@”访问相机", [LyUtil getAppDisplayName]]
//#define alertMessageForNotificaion                  [[NSString alloc] initWithFormat:@"请前往系统【设置】>【通知】>【%@】打开“允许通知”", [LyUtil getAppDisplayName]]
UIKIT_EXTERN NSString *const  alertMessageForLocationService;
UIKIT_EXTERN NSString *const alertMessageForLocate;
//#define alertMessageForLocate                [[NSString alloc] initWithFormat:@"请前往系统【设置】>【隐私】>【定位服务】>【%@】允许“%@”访问位置信息", [LyUtil getAppDisplayName], [LyUtil getAppDisplayName]]
UIKIT_EXTERN NSString *const alertMessageForApplePay;




UIKIT_EXTERN CGFloat const maxPicWidth;
UIKIT_EXTERN CGFloat const maxPicHeight;

UIKIT_EXTERN CGFloat const maxPicWidth_WiFi;
UIKIT_EXTERN CGFloat const maxPicHeight_WiFi;


UIKIT_EXTERN CGFloat const LyControlBarHeight;
#define LyControlBarButtonWidth                     (SCREEN_WIDTH / 3.0f)
UIKIT_EXTERN CGFloat const LyControlBarButtonHeight;

UIKIT_EXTERN CGFloat const controlViewUsefulHeight;
UIKIT_EXTERN CGFloat const controlToolBarHeight;
UIKIT_EXTERN CGFloat const controlPickerHeight;
UIKIT_EXTERN CGFloat const controlPickerRowHeight;
#define controlPickerRowTitleFont                       LyFont(14)



UIKIT_EXTERN CGFloat const btnCornerRadius;


UIKIT_EXTERN double const applyPrepayDeposit;

UIKIT_EXTERN CGFloat const LyBtnMoreHeight;
UIKIT_EXTERN CGFloat const LyBtnMoreWidth;


#define LyChinaLocale                                   [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]


UIKIT_EXTERN NSTimeInterval const LyAnimationDuration;
UIKIT_EXTERN NSTimeInterval const LyDelayTime;





UIKIT_EXTERN CGFloat const LyViewHeaderHeight;
UIKIT_EXTERN CGFloat const LyViewItemWidth;
UIKIT_EXTERN CGFloat const LyViewItemHeight;
UIKIT_EXTERN CGFloat const LyLbTitleItemWidth;
UIKIT_EXTERN CGFloat const LyLbTitleItemHeight;

UIKIT_EXTERN int const autoLoadMoreMaxCount;
UIKIT_EXTERN int const showIconInMapMaxDistance;
UIKIT_EXTERN int const teacherLandMarkMaxCount;
UIKIT_EXTERN int const driveSchoolListMaxCount;
UIKIT_EXTERN int const coachListMaxCount;
UIKIT_EXTERN int const guiderListMaxCount;


#define LyRegionForMapOfChina                           {{20.0,105.0}, {60.0,70.0}}


UIKIT_EXTERN float const showDistanceMax;

UIKIT_EXTERN int const coordinateRandBase;
UIKIT_EXTERN float const coordinateRandBase_all;
UIKIT_EXTERN float const coordinateRandBase_search;

#pragma mark 定位变化
UIKIT_EXTERN NSString *const LyNofiticationForRequestLocate;
UIKIT_EXTERN NSString *const LyNotificationForLocationChanged;
UIKIT_EXTERN NSString *const LyNotificationForAddressTranslated;
UIKIT_EXTERN NSString *const LyNotificationForShowNotification;
UIKIT_EXTERN NSString *const LyNotificationForHttpRequest;
UIKIT_EXTERN NSString *const LyNotificationForUserCenterPush;
UIKIT_EXTERN NSString *const LyNotificationForExamMistakeRequestRetest;

UIKIT_EXTERN NSString *const LyAppDidEnterBackground;
UIKIT_EXTERN NSString *const LyAppDidBecomeActive;

UIKIT_EXTERN NSString *const LyNotificationForJumpReady;


UIKIT_EXTERN NSString *const areaKey;
UIKIT_EXTERN NSString *const provinceKey;
UIKIT_EXTERN NSString *const cityKey;
UIKIT_EXTERN NSString *const districtKey;

UIKIT_EXTERN NSString *const currentUserKey;
UIKIT_EXTERN NSString *const userKey;
UIKIT_EXTERN NSString *const coachKey;
//UIKIT_EXTERN NSString *const schoolKey;
UIKIT_EXTERN NSString *const guiderKey;





UIKIT_EXTERN NSString *const lbApplyModeTitleWhole;
UIKIT_EXTERN NSString *const lbApplyModeTitlePrepay;


UIKIT_EXTERN NSString *const phoneNum_517;
UIKIT_EXTERN NSString *const messageNum_517;



UIKIT_EXTERN CGFloat const horizontalSpace;
UIKIT_EXTERN CGFloat const verticalSpace;




UIKIT_EXTERN CGFloat const imageSizeMaxWidth;
UIKIT_EXTERN CGFloat const imageSizeMaxHeight;


#define tvFooterViewWidth                               SCREEN_WIDTH
UIKIT_EXTERN CGFloat const tvFooterViewHeight;








UIKIT_EXTERN CGFloat const sparaterLineHeight;

UIKIT_EXTERN CGFloat const LyHorizontalLineHeight;
#define LyHorizontalLineColor                           LyLightgrayColor


UIKIT_EXTERN CGFloat const LyViewHeaderHeight;
UIKIT_EXTERN CGFloat const LyViewItemHeight;
UIKIT_EXTERN CGFloat const LyLbTitleItemHeight;
#define LyLbTitleItemFont                               LyFont(16)


UIKIT_EXTERN int const detailEvaOrConCount;


UIKIT_EXTERN NSString *const autoJumpToNexFlag;
UIKIT_EXTERN NSString *const autoExcludeFlag;



UIKIT_EXTERN CGFloat const bottomControlHideCerticality;


UIKIT_EXTERN NSString *const goodKey;
UIKIT_EXTERN NSString *const teacherKey;


UIKIT_EXTERN NSString *const mapBtnLocateDefaultTitle;

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
UIKIT_EXTERN NSString *const LyIndicatorTitle_ask;
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


UIKIT_EXTERN CGFloat const lbItemHeight;
UIKIT_EXTERN CGFloat const btnCloseSize;
UIKIT_EXTERN CGFloat const ivMoreSize;
UIKIT_EXTERN CGFloat const ivSexSize;


#define LyTheoryTextFont            LyFont(14)
#define tsTvContentWidth                   (SCREEN_WIDTH - horizontalSpace * 2)
UIKIT_EXTERN CGFloat const tsIvQuestionModeWidth;
UIKIT_EXTERN CGFloat const tsIvQuestionModeHeight;
UIKIT_EXTERN CGFloat const tsLbTitleWidth;
UIKIT_EXTERN CGFloat const tsLbTitleHeight;
UIKIT_EXTERN CGFloat const tsIvDegreeWidth;
UIKIT_EXTERN CGFloat const tsIvDegreeHeight;
UIKIT_EXTERN CGFloat const tsLbDegreeWidth;
UIKIT_EXTERN CGFloat const tsLbDegreeHeight;
UIKIT_EXTERN CGFloat const tsBtnConfirmWidth;
UIKIT_EXTERN CGFloat const tsBtnConfirmHeight;
UIKIT_EXTERN CGFloat const tsTvRemindHeight;
UIKIT_EXTERN CGFloat const tsViewSolutionHeight;
UIKIT_EXTERN CGFloat const tsLbAnserHeight;



UIKIT_EXTERN CGFloat const synopsisLinesMax;

UIKIT_EXTERN NSTimeInterval const validateSensitiveWordDelayTime;
UIKIT_EXTERN NSTimeInterval const sleepTime;


UIKIT_EXTERN int const dateStringLength;
UIKIT_EXTERN int const lastestClickForReservate;
UIKIT_EXTERN int const lastestClickForCancelReser;



UIKIT_EXTERN float const EPSINON;

UIKIT_EXTERN NSString *const LyTheoryDefaultUserId;

UIKIT_EXTERN NSString *const LyTheoryDatabaseName;
UIKIT_EXTERN NSString *const LyTheoryTableName_chapter;
UIKIT_EXTERN NSString *const LyTheoryTableName_province;
UIKIT_EXTERN NSString *const LyTheoryTableName_question;
UIKIT_EXTERN NSString *const LyTheoryTableName_analysis;

UIKIT_EXTERN NSString *const LyRecordDatabaseName;
UIKIT_EXTERN NSString *const LyRecordTableName_examScore;
UIKIT_EXTERN NSString *const LyRecordTableName_queAnalysis;
UIKIT_EXTERN NSString *const LyRecordTableName_exeSpeed;
UIKIT_EXTERN NSString *const LyRecordTableName_exeMistake;
UIKIT_EXTERN NSString *const LyRecordTableName_queBank;
UIKIT_EXTERN NSString *const LyRecordTableName_user;
UIKIT_EXTERN NSString *const LyRecordTableName_guide;
UIKIT_EXTERN NSString *const LyRecordTableName_news;

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
    LyUserType_school,
    LyUserType_coach,
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





typedef NS_ENUM( NSInteger, LyTheoryStudyChildViewControllerIndex)
{
    theoryStudyChildViewControllerIndex_simulate = 1000,
    theoryStudyChildViewControllerIndex_chapter,
//    theoryStudyChildViewControllerIndex_intensify,
//    theoryStudyChildViewControllerIndex_random,
//    theoryStudyChildViewControllerIndex_sequence,
//    theoryStudyChildViewControllerIndex_section,
    theoryStudyChildViewControllerIndex_analysis,
    theoryStudyChildViewControllerIndex_mistake,
    theoryStudyChildViewControllerIndex_library
};


typedef NS_ENUM(NSInteger, LySortMode) {
    LySortMode_none,
    LySortMode_distance,
    LySortMode_spell,
    LySortMode_star,
    LySortMode_price,
    LySortMode_allCount
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
    LySubjectMode_first,
    LySubjectMode_fourth
};


typedef NS_ENUM( NSInteger, LySubjectModeprac)
{
    LySubjectModeprac_second = 2,
    LySubjectModeprac_third
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


typedef NS_ENUM( NSInteger, LyUserLevel)
{
    userLevel_killer,   //杀手
    userLevel_newbird,  //菜鸟
    userLevel_mass,     //群众
    userLevel_superior, //达人
    userLevel_master    //大师
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



typedef NS_ENUM( NSInteger, LyAnswerRightOrWrongMode)
{
    answerRightOrWrongMode_notyet,
    answerRightOrWrongMode_right,
    answerRightOrWrongMode_wrong
};

typedef NS_ENUM( NSInteger, LyAddTeacherMode)
{
    LyAddTeacherMode_add,
    LyAddTeacherMode_replace
};



#pragma mark 培训课程相关
typedef NS_ENUM( NSInteger, LyTrainClassMode)
{
    LyTrainClassMode_coach = 1,
    LyTrainClassMode_driveSchool,
    LyTrainClassMode_guider
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



typedef NS_ENUM( NSInteger, LyTrainClassPickType)
{
    LyTrainClassPickType_none,
    LyTrainClassPickType_bus,
};



typedef NS_ENUM( NSInteger, LyTrainClassTrainMode)
{
    LyTrainClassTrainMode_multi,
    LyTrainClassTrainMode_four,
    LyTrainClassTrainMode_one
};



typedef NS_ENUM(NSInteger, LyAlertForAuthorityMode) {
    LyAlertForAuthorityMode_WiFi,
    LyAlertForAuthorityMode_addressBook,
    LyAlertForAuthorityMode_album,
    LyAlertForAuthorityMode_camera,
    LyAlertForAuthorityMode_notification,
    LyAlertForAuthorityMode_locationService,
    LyAlertForAuthorityMode_locate,
    LyAlertForAuthorityMode_ApplePay
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


typedef NS_ENUM(NSInteger, LyShowVcMode) {
    LyShowVcMode_push,
    LyShowVcMode_present
};


@class LyOrder;
@class CLLocation;
@class LyBMKPointAnnotaion;
@protocol MFMessageComposeViewControllerDelegate;
@class LyQuestion;


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


#pragma mark 本地数据库
+ (FMDatabase *)dbTheory;
+ (FMDatabase *)dbRecord;
+ (UIView *)viewForThoery;
+ (UIImageView *)ivQuestionModeForTheory;
+ (UITextView *)tvQuestionForTheory;
+ (UIImageView *)ivPicForTheory;
+ (UIButton *)btnConfirmForTheory:(NSInteger)btnTag target:(id)target action:(SEL)action;
+ (UILabel *)lbTitleForTheory;
+ (UIImageView *)ivDegreeForTheory;
+ (UILabel *)lbDegreeForTheory;
+ (UILabel *)lbAnswerForTheory;
+ (UITextView *)tvSolutionForTheory;
+ (NSString *)filePathForTheory:(NSString *)imageName;
+ (UIImage *)imageForImageNameForTheory:(NSString *)iamgeName;
+ (void)setIvQuestionModeForThoery:(UIImageView *)ivQuestionMode questionMode:(NSInteger)questionMode;
+ (CGFloat)setTvContentForTheory:(UITextView *)tvQuestion content:(NSString *)content isAnalysis:(BOOL)isAnalysis;
+ (CGFloat)showPicForTheory:(UIImageView *)iv iamgeName:(NSString *)imageName;
+ (void)transitionForTheory:(UIView *)view subtype:(NSString *)subtype;
+ (NSString *)loadQueAnalysisForTheory:(NSString *)tid;
+ (void)loadQueBankIdForTheory:(LyQuestion *)question userId:(NSString *)userId;
+ (NSInteger)cartypeWithLicenseType:(LyLicenseType)licenseType;

#pragma mark 是否开启驾考学堂
+ (BOOL)driveExamOpenFlag;

#pragma mark URLSchemes
+ (nullable NSString *)LyURLSchemeForWIFI;
+ (nullable NSString *)LyURLSchemeForLOCATION_SERVICES;


#pragma mark 键盘
+ (BOOL)isKeybaordShowing;



#pragma mark 机器及系统信息
+ (nullable NSString *)machineName;
+ (nullable NSString *)osName;
+ (float)osVersion;



#pragma mark iOS 10干掉了所的有 Url Scheme
#pragma mark 显示提示
+ (void)showAlert:(LyAlertForAuthorityMode)mode vc:(nullable __kindof UIViewController *)vc;
+ (void)showAlert:(nullable NSString *)title message:(nullable NSString *)message vc:(__kindof UIViewController *)vc;
+ (void)openUrl:(nullable NSURL *)url;

#pragma mark 打电话
+ (void)call:(nullable NSString *)phone;
+ (void)sendSMS:(nullable NSString *)bodyOfMessage recipients:(nullable NSArray *)recipients target:(__kindof UIViewController <MFMessageComposeViewControllerDelegate> * _Nonnull)target;


#pragma mark 当前app版本信息
+ (nonnull NSString *)getApplicationVersion;
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

#pragma mark 理论学习bunle文件读取
+ (NSString *)theoryImagePathForImageName:(NSString *)imageName;
+ (UIImage *)theoryImageForImageName:(NSString *)imageName;
+ (NSString *)theoryFilePathForFileName:(NSString *)fileName;


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


#pragma mark 理论学习自动选项
+ (BOOL)loadTheoryStudyAutoFlagWithMode:(NSInteger)mode;
+ (void)setTheoryStudyAutoFlagAutoWithMode:(NSInteger)mode andFlag:(BOOL)flagAuto;


#pragma mark 会话id
+ (void)showLoginVc:(__kindof UIViewController * _Nullable)vc;
+ (void)showLoginVc:(__kindof UIViewController * _Nullable)target nextVC:(__kindof UIViewController * _Nullable)nextVc showMode:(LyShowVcMode)showMode;
+ (void)showLoginVc:(__kindof UIViewController * _Nullable)target action:(SEL _Nullable)action object:(id _Nullable)object;
+ (void)setHttpSessionId:(nullable NSString *)strHttpSessionId;
+ (nonnull NSString *)httpSessionId;
+ (void)sessionTimeOut:(__kindof UIViewController * _Nonnull)vc;
+ (void)serverMaintaining;


#pragma mark 导航按钮
+ (UIBarButtonItem *)barButtonItem:(NSInteger)tag imageName:(nullable NSString *)imageName target:(nullable id)target action:(nullable SEL)action;


#pragma mark json解析与封装
+ (nullable NSString *)getJsonString:(nullable NSDictionary *)dictionary;
+ (nullable id)getObjFromJson:(nullable NSString *)jsonString;

#pragma mark analysis string from http
+ (NSDictionary *)analysisHttpResult:(NSString *)result delegate:(id<LyUtilAnalysisHttpResultDelegate>)delegate;

#pragma mark httpBody解析与封装
+ (NSString *)getHttpBody:(NSDictionary *)dictionary;
+ (NSDictionary *)getDicFromHttpBodyStr:(NSString *)strHttpBody;


#pragma mark 排除重复元素
+ (__kindof NSArray *)uniquifyArray:(__kindof NSArray *)arr key:(NSString *)key;
#pragma mark 数组排序
+ (__kindof NSArray *)sortArrByDate:(__kindof NSArray *)arr andKey:(NSString *)key asc:(BOOL)asc;
+ (__kindof NSArray *)sortArrByStr:(__kindof NSArray *)arr andKey:(NSString *)key;
+ (__kindof NSArray *)sortTeacherArr:(__kindof NSArray *)arr sortMode:(LySortMode)sortMode;


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
+ (nonnull NSCalendar *)calendar;
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
+ (nullable NSString *)stringOnlyYMDFromDate:(nullable id)date;
+ (NSString *)stringFromDate:(id)date;
+ (nullable NSString *)weekdayStringWithDate:(nullable id)date;
+ (LyWeekday)weekdayWithDate:(id)date;

#pragma mark 预约
+ (BOOL)isAvaiableToCancelReservation:(nullable LyOrder *)order;


#pragma mark 报名方式
+ (int)applyModeNum;



#pragma mark 设置图片
+ (void)setScoreImageView:(nullable UIImageView *)imageView withScore:(float)score;
+ (void)setDegreeImageView:(nullable UIImageView *)imageView withDegree:(NSInteger)degree;
+ (void)setSexImageView:(nullable UIImageView *)imageView withUserSex:(LySex)sex;
+ (void)setUserLevelImageView:(nullable UIImageView *)imageView withUserLevel:(LyUserLevel)userLevel;
+ (void)setAttentionKindImageView:(nullable UIImageView *)imageView withMode:(LyUserType)userType;


#pragma mark 动画
+ (void)startAnimationWithView:(nullable UIView *)view animationDuration:(NSTimeInterval)duration initialPoint:(CGPoint)iniPoint destinationPoint:(CGPoint)desPoint completion:(nullable void (^)(BOOL finished))completion;
+ (void)startAnimationWithView:(nullable UIView *)view animationDuration:(NSTimeInterval)duration initialOffset:(CGPoint)iniPoint destinationOffset:(CGPoint)desPoint completion:(nullable void (^)(BOOL finished))completion;
+ (void)startAnimationWithView:(nullable UIView *)view animationDuration:(NSTimeInterval)duration initialColor:(nullable UIColor *)iniColor destinationColor:(nullable UIColor *)desColor completion:(nullable void (^)(BOOL finished))completion;
+ (void)startAnimationWithView:(nullable UIView *)view animationDuration:(NSTimeInterval)duration initAlpha:(float)initAlpha destinationAplhas:(float)desAlpha completion:(nullable void(^)(BOOL finished))completion;



#pragma mark 生成控件
+ (nonnull UILabel *)lbTitleForNavigationBar:(nullable NSString *)title detail:(nullable NSString *)detail;
+ (nonnull UILabel *)lbTitleForNavigationBar:(nullable NSString *)title;
+ (nonnull UILabel *)lbItemTitleWithText:(nullable NSString *)text;
+ (nonnull UIRefreshControl *)refreshControlWithTitle:(nullable NSString *)title target:(nullable id)target action:(nullable SEL)actoin;
+ (nonnull UILabel *)lbErrorWithMode:(NSInteger)mode;
+ (nonnull UILabel *)lbNullWithText:(nullable NSString *)text;


#pragma mark 数值转换
+ (nullable NSString *)translateSecondsToClock:(NSInteger)seconds;
+ (nullable NSString *)transmitNumWithWan:(NSInteger)num;
//+ (nullable NSString *)transmitTimeBucketIndexToTime:(NSInteger)timeBucket;
+ (nullable NSString *)getDistance:(float)distance;

#pragma mark 姓别
+ (nonnull NSString *)sexStringFrom:(LySex)sex;
+ (LySex)sexFromString:(nullable NSString *)strSex;
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
#pragma mark 科目---理论
+ (nullable NSArray *)arrSubjectMode;
+ (LySubjectMode)subjectFromString:(nullable NSString *)subjectString;
+ (nullable NSString *)subjectStringForm:(LySubjectMode)subjectMode;
#pragma mark 科目-实践
+ (nullable NSArray *)arrSubjectModePrac;
+ (nullable NSString *)subjectModePracStringForm:(LySubjectModeprac)subjectMode;
+ (LySubjectModeprac)subjectModePracFromString:(nullable NSString *)strSubjectMode;
#pragma mark 星期几
//+ (nullable NSString *)getWeekdayWithIndex:(NSInteger)index;
//+ (NSInteger)getWeekdayIndex:(nullable NSString *)strWeekday;
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
#pragma mark 老师列表排序方式
+ (NSArray *)arrSortMode;
+ (NSString *)sortModeStringFrom:(LySortMode)sortMode;
+ (LySortMode)sortModeFromString:(NSString *)strSortMode;



#pragma mark 默认头像
+ (nullable UIImage *)defaultAvatarForStudent;
+ (nullable UIImage *)defaultAvatarForTeacher;


#pragma mark 用户类型
+ (LyUserType)userTypeFromString:(nullable NSString *)strUserType;
+ (nullable NSString *)userTypeStringFrom:(LyUserType)userType;
+ (nullable NSString *)userTypeChineseStringFrom:(LyUserType)userType;


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
+ (NSRange)rangeOf:(NSString *)fullStr subStr:(NSString *)subStr options:(NSStringCompareOptions)mask;




@end


NS_ASSUME_NONNULL_END



