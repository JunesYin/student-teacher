//
//  LyReservateCoachViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/19.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyReservateCoachViewController.h"
#import "LyDateTimePicker.h"
#import "LyDetailControlBar.h"

#import "LyCurrentUser.h"
#import "LyUserManager.h"
#import "LyPriceDetailManager.h"
#import "LyTrainBaseManager.h"
#import "LyOrderManager.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "UIView+LyExtension.h"
#import "UIScrollView+LyExtension.h"
#import "LyUtil.h"



//#import "LyReservationPriceDetailViewController.h"
#import "LyPriceDetailViewController.h"
#import "LyOrderInfoViewController.h"


#import <MessageUI/MessageUI.h>



#define rcWidth                         SCREEN_WIDTH
#define rcHeight                        SCREEN_HEIGHT


#define svMainWidth                     rcWidth
#define svMainHeight                    (rcHeight-dcbHeight)


//信息
#define viewInfoWidth                   svMainWidth
CGFloat const rcViewInfoHeight = 210.0f;
CGFloat const viewInfoHorizontalSpace = 7.0f;
CGFloat const viewInfoVerticalSpace = 5.0f;
//头像
CGFloat const rcIvAvatarSize = 60.0f;
//认证标记
CGFloat const ivCertificationFlagWidth = 15.0f;
CGFloat const ivCertificationFlagHeight = ivCertificationFlagWidth;
//姓名
CGFloat const rcLbNameHeight = 20.0f;
#define lbNameFont                      LyFont(16)
//姓别

//地址
#define rcLbAddressWidth                  viewInfoWidth
CGFloat const rcLbAddressHeight = rcLbNameHeight;
#define lbAddressFont                   LyFont(14)
//年龄
CGFloat const rcLbAgeHeight = rcLbNameHeight;
#define lbAgeFont                       LyFont(12)
//教龄
CGFloat const rcLbTeachedAgeHeight = rcLbNameHeight;
#define lbTeachedAgeFont                lbAgeFont
//驾龄
CGFloat const rcLbDrivedAgeHeight = rcLbNameHeight;
#define lbDrivedAgeFont                 lbAgeFont
//通过率
CGFloat const rcLbPerPassHeight = rcLbNameHeight;
#define lbPerPassFont                   LyFont(12)
//好评率
CGFloat const rcLbPerPraiseHeight = rcLbNameHeight;
#define lbPerPraiseFont                 lbPerPassFont
//已教
CGFloat const rcLbTeachAllCountHeight = rcLbNameHeight;
#define lbTeachAllCountFont             lbPerPassFont




#define lbTitleItemWidth                (svMainWidth*2.0/3.0f)
CGFloat const lbTitleItemHeight = 30.0f;
#define lbTitleItemFont                 LyFont(18)


//培训价格
#define viewTrainPriceWidth             svMainWidth
#define viewTrainPriceHeight            (lbTitleItemHeight+rcLbPriceDetailHeight)
//详请按钮
CGFloat const btnPriceDetailWidth = 90.0f;
CGFloat const btnPriceDetailHeight = 30.0f;
#define btnPriceDetailTitleFont         LyFont(12)
//科目二
#define rcLbPriceDetailWidth              (viewTrainPriceWidth-horizontalSpace*2.0f)
CGFloat const rcLbPriceDetailHeight = 50.0f;
#define lbPriceDetailFont               LyFont(13)


//预约时间
#define viewReservationInfoWidth              svMainWidth
#define viewReservationInfoHeight             (lbTitleItemHeight+lbReservateItemHeight+dateTimePickerHeight)
//累计学员//累计课时
#define lbReservateItemWidth            (viewReservationInfoWidth/2.0f)
CGFloat const lbReservateItemHeight = 40.0f;
#define lbReservateItemFont             LyFont(12)
#define lbReservateItemNumFont          LyFont(14)
#define lbReservateStuNumColor          Ly517ThemeColor
#define lbReservatePeriodNumColor       [UIColor colorWithRed:87/255.0 green:214/255.0 blue:58/255.0 alpha:1.0]




#define dateTimePickerWidth             viewReservationInfoWidth
#define dateTimePickerHeight            dateTimePickerDefaultHeight




typedef NS_ENUM( NSInteger, LyReservateCoachButtonItemMode)
{
    reservateCoachButtonItemMode_priceDetail = 23,
    reservateCoachButtonItemMode_
};


typedef NS_ENUM( NSInteger, LyReservateCoachAlertViewMode)
{
    reservateCoachAlertViewMode_deattente = 32,
    reservateCoachAlertViewMode_subject,
    reservateCoachAlertViewMode_confirm
};



typedef NS_ENUM( NSInteger, LyReservateCoachHttpMethod)
{
    reservateCoachHttpMethod_load = 42,
    reservateCoachHttpMethod_loadWithDate,
    reservateCoachHttpMethod_reservate,
    reservateCoachHttpMethod_attente,
    reservateCoachHttpMethod_deattente
};



@interface LyReservateCoachViewController () <LyDateTimePickerDelegate, LyDateTimePickerDataSource, LyDetailControlBarDelegate, LyHttpRequestDelegate, UIScrollViewDelegate, LyPriceDetailViewControllerDelegate, MFMessageComposeViewControllerDelegate, LyOrderInfoViewControllerdelegate>
{
    UIScrollView                    *svMain;
    
//    UIRefreshControl                *refresher;
    LyIndicator                     *indicator_load;
    
    UIView                          *viewError;
    
    
    UIView                          *viewInfo;
    UIImageView     *ivBack;
    UIImageView                     *ivAvatar;
    UIImageView                     *ivCertificationFlag;
    UILabel                         *lbName;
    UIImageView                     *ivSex;
    UILabel                         *lbAddress;
    UILabel                         *lbAge;
    UILabel                         *lbTeachedAge;
    UILabel                         *lbDrivedAge;
    UILabel                         *lbPerPass;
    UILabel                         *lbPerPraise;
    UILabel                         *lbTeachAllCount;
    
    
    UIView                          *viewTrainPrice;
    UILabel                         *lbTitle_trainPrice;
    UIButton                        *btnPriceDetail;
    UILabel                         *lbPriceDetail;
    
    
    UIView                          *viewReservationInfo;
    UILabel                         *lbTitle_reservation;
    UILabel                         *lbTeachAllCountExt;
    UILabel                         *lbTeachAllPeriod;  
//    LyDateTimePicker                *dateTimePicker;
    UIView                          *viewError_reservationInfo;
    
    
    LyDetailControlBar              *controlBar;
    
    
    
    UIActivityIndicatorView         *indicator_loadWithDate;
    LyIndicator                     *indicator_reservate;
    LyIndicator                     *indicator_oper;
    
    
    LyTrainBase                     *currentTrainBase;
    
    NSString                        *curDateStrYMD;
    NSString                        *curDateStrMD;
    NSDate                          *curDate;
    NSInteger                       curTime;
//    NSString                        *curWeekday;
    LyWeekday                       curWeekday;
    LySubjectModeSupportMode        curMode;
    LySubjectModeprac               curSubject;
    float                           curPrice;
    
    
    __strong NSMutableDictionary     *dicTimeDisable;
    
    
    __strong NSMutableDictionary     *dicDateTimeInfo;
    
    LyCoach                         *coach;
    float                           price_second;
    float                           price_third;
    
    LyOrder                         *order;
    
    
    BOOL                            flagLoadSuccess;
    BOOL                            bHttpFlag;
    LyReservateCoachHttpMethod      curHttpMethod;
}

@property (strong, nonatomic)       UIRefreshControl        *refreshControl;
@property (strong, nonatomic)       LyDateTimePicker        *dateTimePicker;

@end

@implementation LyReservateCoachViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}



- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[LyUtil imageForImageName:@"uci_navigatinBar" needCache:NO] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController navigationBar].shadowImage = [LyUtil imageForImageName:@"uci_navigatinBar" needCache:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    NSDictionary *dic = [_delegate obtainCoachObjectByReservateCoachViewController:self];
    if ( !dic)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    _coachId = [dic objectForKey:coachIdKey];
    curSubject = [[dic objectForKey:subjectModeKey] integerValue];
    
    if (!_coachId) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    coach = [[LyUserManager sharedInstance] getCoachWithCoachId:_coachId];
    if (!coach) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (!dicDateTimeInfo || dicDateTimeInfo.count < 1){
        [self loadData];
    }
    
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


- (void)initSubviews
{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 0, svMainWidth, svMainHeight)];
    [svMain setDelegate:self];
    [svMain setBounces:YES];
    [svMain setContentSize:CGSizeMake( CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)*1.5f)];

    
    //教练信息
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, viewInfoWidth, rcViewInfoHeight)];
    
    ivBack = [[UIImageView alloc] initWithFrame:viewInfo.bounds];
    ivBack.contentMode = UIViewContentModeScaleAspectFill;
    ivBack.image = [LyUtil imageForImageName:@"chd_background" needCache:NO];
    
    
    //教练信息-头像
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake( viewInfoWidth/2.0f-rcIvAvatarSize/2.0f, rcViewInfoHeight/2.0f-(rcIvAvatarSize+rcLbNameHeight+rcLbAddressHeight+rcLbAgeHeight+rcLbPerPassHeight)/2.0f, rcIvAvatarSize, rcIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [ivAvatar setClipsToBounds:YES];
    [[ivAvatar layer] setCornerRadius:btnCornerRadius];
    //教练信息-认证信息
    ivCertificationFlag = [[UIImageView alloc] initWithFrame:CGRectMake( ivAvatar.frame.origin.x+CGRectGetWidth(ivAvatar.frame), ivAvatar.frame.origin.y+CGRectGetHeight(ivAvatar.frame)-ivCertificationFlagHeight, ivCertificationFlagWidth, ivCertificationFlagHeight)];
    [ivCertificationFlag setContentMode:UIViewContentModeScaleAspectFit];
    [ivCertificationFlag setClipsToBounds:YES];
    [[ivCertificationFlag layer] setCornerRadius:ivCertificationFlagWidth/2.0f];
    [ivCertificationFlag setImage:[LyUtil imageForImageName:@"dsd_certificate_flag" needCache:NO]];
    //教练信息-姓名
    lbName = [UILabel new];
    [lbName setTextColor:[UIColor whiteColor]];
    [lbName setFont:lbNameFont];
    [lbName setTextAlignment:NSTextAlignmentCenter];
    //教练信息-姓别
    ivSex = [UIImageView new];
    [ivSex setContentMode:UIViewContentModeScaleAspectFit];
    [ivSex setClipsToBounds:YES];
    [[ivSex layer] setCornerRadius:ivSexSize/2.0f];
    //教练信息-地址
    lbAddress = [UILabel new];
    [lbAddress setTextColor:[UIColor whiteColor]];
    [lbAddress setFont:lbAddressFont];
    [lbAddress setTextAlignment:NSTextAlignmentCenter];
    //教练信息-年龄
    lbAge = [UILabel new];
    [lbAge setTextColor:[UIColor whiteColor]];
    [lbAge setFont:lbAgeFont];
    [lbAge setTextAlignment:NSTextAlignmentCenter];
    //教练信息-教龄
    lbTeachedAge = [UILabel new];
    [lbTeachedAge setTextColor:[UIColor whiteColor]];
    [lbTeachedAge setFont:lbTeachedAgeFont];
    [lbTeachedAge setTextAlignment:NSTextAlignmentCenter];
    //教练信息-驾龄
    lbDrivedAge = [UILabel new];
    [lbDrivedAge setTextColor:[UIColor whiteColor]];
    [lbDrivedAge setFont:lbDrivedAgeFont];
    [lbDrivedAge setTextAlignment:NSTextAlignmentCenter];
    //教练信息-通过率
    lbPerPass = [UILabel new];
    [lbPerPass setTextColor:[UIColor whiteColor]];
    [lbPerPass setFont:lbPerPassFont];
    [lbPerPass setTextAlignment:NSTextAlignmentCenter];
    //教练信息-好评率
    lbPerPraise = [UILabel new];
    [lbPerPraise setTextColor:[UIColor whiteColor]];
    [lbPerPraise setFont:lbPerPraiseFont];
    [lbPerPraise setTextAlignment:NSTextAlignmentCenter];
    //教练信息-已教人数
    lbTeachAllCount = [UILabel new];
    [lbTeachAllCount setTextColor:[UIColor whiteColor]];
    [lbTeachAllCount setFont:lbTeachAllCountFont];
    [lbTeachAllCount setTextAlignment:NSTextAlignmentCenter];
    
    
    [viewInfo addSubview:ivBack];
    [viewInfo addSubview:ivAvatar];
    [viewInfo addSubview:ivCertificationFlag];
    [viewInfo addSubview:lbName];
    [viewInfo addSubview:ivSex];
    [viewInfo addSubview:lbAddress];
    [viewInfo addSubview:lbAge];
    [viewInfo addSubview:lbTeachedAge];
    [viewInfo addSubview:lbDrivedAge];
    [viewInfo addSubview:lbPerPass];
    [viewInfo addSubview:lbPerPraise];
    [viewInfo addSubview:lbTeachAllCount];
    
    
    
    //培训价格
    viewTrainPrice = [[UIView alloc] initWithFrame:CGRectMake( 0, viewInfo.frame.origin.y+CGRectGetHeight(viewInfo.frame), viewTrainPriceWidth, viewTrainPriceHeight)];
    [viewTrainPrice setBackgroundColor:[UIColor whiteColor]];
    //培训价格-标题
    lbTitle_trainPrice = [LyUtil lbItemTitleWithText:@"培训价格"];
    //培训价格-详情按钮
    btnPriceDetail = [[UIButton alloc] initWithFrame:CGRectMake( viewTrainPriceWidth-btnPriceDetailWidth, lbTitle_trainPrice.frame.origin.y, btnPriceDetailWidth, btnPriceDetailHeight)];
    [btnPriceDetail setTag:reservateCoachButtonItemMode_priceDetail];
    [[btnPriceDetail titleLabel] setFont:btnPriceDetailTitleFont];
    [btnPriceDetail setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnPriceDetail setTitle:@"详情" forState:UIControlStateNormal];
    [btnPriceDetail addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    //培训价格-科目二
    lbPriceDetail = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, lbTitle_trainPrice.frame.origin.y+CGRectGetHeight(lbTitle_trainPrice.frame), rcLbPriceDetailWidth, rcLbPriceDetailHeight)];
    [lbPriceDetail setTextColor:LyBlackColor];
    [lbPriceDetail setFont:lbPriceDetailFont];
    [lbPriceDetail setTextAlignment:NSTextAlignmentLeft];
    [lbPriceDetail setNumberOfLines:0];
    
    UIView *horizontalLine_trainPrice = [[UIView alloc] initWithFrame:CGRectMake( 0, CGRectGetHeight(viewTrainPrice.frame)-LyHorizontalLineHeight, CGRectGetWidth(viewTrainPrice.frame), LyHorizontalLineHeight)];
    [horizontalLine_trainPrice setBackgroundColor:LyHorizontalLineColor];
    
    [viewTrainPrice addSubview:lbTitle_trainPrice];
    [viewTrainPrice addSubview:btnPriceDetail];
    [viewTrainPrice addSubview:lbPriceDetail];
    [viewTrainPrice addSubview:horizontalLine_trainPrice];
    
    
    
    //预约时间
    viewReservationInfo = [[UIView alloc] initWithFrame:CGRectMake( 0, viewTrainPrice.frame.origin.y+CGRectGetHeight(viewTrainPrice.frame), viewReservationInfoWidth, viewReservationInfoHeight)];
    [viewReservationInfo setBackgroundColor:[UIColor whiteColor]];
    //预约时间-标题
    lbTitle_reservation = [LyUtil lbItemTitleWithText:@"预约学车"];
    //预约时间-累计学员
    lbTeachAllCountExt = [[UILabel alloc] initWithFrame:CGRectMake( 0, lbTitle_reservation.frame.origin.y+CGRectGetHeight(lbTitle_reservation.frame), lbReservateItemWidth, lbReservateItemHeight)];
    [lbTeachAllCountExt setFont:lbReservateItemFont];
    [lbTeachAllCountExt setTextColor:LyBlackColor];
    [lbTeachAllCountExt setTextAlignment:NSTextAlignmentCenter];
    [lbTeachAllCountExt setNumberOfLines:0];
    //预约时间-累计课时
    lbTeachAllPeriod = [[UILabel alloc] initWithFrame:CGRectMake( lbTeachAllCountExt.frame.origin.x+CGRectGetWidth(lbTeachAllCountExt.frame), lbTeachAllCountExt.frame.origin.y, lbReservateItemWidth, lbReservateItemHeight)];
    [lbTeachAllPeriod setFont:lbReservateItemFont];
    [lbTeachAllPeriod setTextColor:LyBlackColor];
    [lbTeachAllPeriod setTextAlignment:NSTextAlignmentCenter];
    [lbTeachAllPeriod setNumberOfLines:0];
    
    
    //预约时间-表格
//    self.dateTimePicker;
    
    
    [viewReservationInfo addSubview:lbTitle_reservation];
    [viewReservationInfo addSubview:lbTeachAllCountExt];
    [viewReservationInfo addSubview:lbTeachAllPeriod];
    [viewReservationInfo addSubview:self.dateTimePicker];

    
    [svMain addSubview:viewInfo];
    [svMain addSubview:viewTrainPrice];
    [svMain addSubview:viewReservationInfo];
    
    [svMain addSubview:self.refreshControl];
    
    [svMain setContentSize:CGSizeMake( svMainWidth, viewReservationInfo.frame.origin.y+CGRectGetHeight(viewReservationInfo.frame)+verticalSpace*2.0f)];
    
    
    controlBar = [LyDetailControlBar controlBarWidthMode:LyDetailControlBarMode_myCDG];
    [controlBar setDelegate:self];
    
    
    [self.view addSubview:svMain];
    [self.view addSubview:controlBar];
    
    curDate = [NSDate dateWithTimeIntervalSinceNow:24*3600];
    dicDateTimeInfo = [[NSMutableDictionary alloc] initWithCapacity:1];
    
}




- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [LyUtil refreshControlWithTitle:nil target:self action:@selector(refreshData:)];
    }
    
    return _refreshControl;
}


- (LyDateTimePicker *)dateTimePicker {
    if (!_dateTimePicker) {
        _dateTimePicker = [[LyDateTimePicker alloc] initWithFrame:CGRectMake( 0, lbTeachAllCountExt.frame.origin.y+CGRectGetHeight(lbTeachAllCountExt.frame), dateTimePickerWidth, dateTimePickerHeight)];
        [_dateTimePicker setDelegate:self];
        [_dateTimePicker setDataSource:self];
    }
    
    return _dateTimePicker;
}


- (void)reloadData
{
    [self removeViewError];
    
    //信息-头像
    if ( ![coach userAvatar]) {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:_coachId]
                    placeholderImage:[LyUtil defaultAvatarForTeacher]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if (image) {
                                   [coach setUserAvatar:image];
                               }
                               else
                               {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:_coachId]
                                                       placeholderImage:[LyUtil defaultAvatarForTeacher]
                                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                  if (image)
                                                                  {
                                                                      [coach setUserAvatar:image];
                                                                  }
                                                              }];
                               }
                           }];
    }
    else {
        [ivAvatar setImage:[coach userAvatar]];
    }
    //信息-认证标识
    if (LyTeacherVerifyState_access == [coach coaVerifyState])
    {
        [ivCertificationFlag setHidden:NO];
    }
    else
    {
        [ivCertificationFlag setHidden:YES];
    }
    //信息-姓名
    CGFloat fWidthLbName = [[coach userName] sizeWithAttributes:@{NSFontAttributeName:lbNameFont}].width;
    [lbName setFrame:CGRectMake( viewInfoWidth/2.0f-(fWidthLbName+horizontalSpace+ivSexSize)/2.0f, ivAvatar.frame.origin.y+CGRectGetHeight(ivAvatar.frame)+horizontalSpace*2.0f, fWidthLbName, rcLbNameHeight)];
    [lbName setText:coach.userName];
    //信息-姓别
    [ivSex setFrame:CGRectMake( lbName.frame.origin.x+CGRectGetWidth(lbName.frame)+horizontalSpace, lbName.frame.origin.y+CGRectGetHeight(lbName.frame)/2.0f-ivSexSize/2.0f, ivSexSize, ivSexSize)];
    [LyUtil setSexImageView:ivSex withUserSex:[coach userSex]];
    //信息-地址
    [lbAddress setFrame:CGRectMake( 0, lbName.frame.origin.y+CGRectGetHeight(lbName.frame)+verticalSpace, rcLbAddressWidth, rcLbAddressHeight)];
//    [lbAddress setText:[coach userAddress]];
    if (currentTrainBase)
    {
        [lbAddress setText:[currentTrainBase tbName]];
    }
    //信息-年龄//信息-教龄//信息-驾龄
    NSString *strLbAge = [[NSString alloc] initWithFormat:@"年龄：%d", [coach userAge]];
    NSString *strLbTeachedAge = [[NSString alloc] initWithFormat:@"教龄：%d", [coach coaTeachedAge]];
    NSString *strLbDrivedAge = [[NSString alloc] initWithFormat:@"驾龄：%d", [coach coaDrivedAge]];
    CGFloat fWidthLbAge = [strLbAge sizeWithAttributes:@{NSFontAttributeName:lbAgeFont}].width;
    CGFloat fWidthLbTeachedAge = [strLbTeachedAge sizeWithAttributes:@{NSFontAttributeName:lbTeachedAgeFont}].width;
    CGFloat fWidthLbDrivedAge = [strLbDrivedAge sizeWithAttributes:@{NSFontAttributeName:lbDrivedAgeFont}].width;
    //信息-年龄
    [lbAge setFrame:CGRectMake( viewInfoWidth/2.0f-(fWidthLbAge+horizontalSpace+fWidthLbTeachedAge+horizontalSpace+fWidthLbDrivedAge)/2.0f, lbAddress.frame.origin.y+CGRectGetHeight(lbAddress.frame)+verticalSpace, fWidthLbAge, rcLbAgeHeight)];
    [lbAge setText:strLbAge];
    //信息-教龄
    [lbTeachedAge setFrame:CGRectMake( lbAge.frame.origin.x+CGRectGetWidth(lbAge.frame)+horizontalSpace, lbAge.frame.origin.y, fWidthLbTeachedAge, rcLbTeachedAgeHeight)];
    [lbTeachedAge setText:strLbTeachedAge];
    //信息-驾龄
    [lbDrivedAge setFrame:CGRectMake( lbTeachedAge.frame.origin.x+CGRectGetWidth(lbTeachedAge.frame)+horizontalSpace, lbTeachedAge.frame.origin.y, fWidthLbDrivedAge, rcLbDrivedAgeHeight)];
    [lbDrivedAge setText:strLbDrivedAge];
    //信息-通地率//信息-好评率//信息-已教人数
    NSString *strLbPerPassNum = [coach perPass];
    NSString *strLbPerPraiseNum = [coach perPraise];
    NSString *strLbTeachAllCountNum = [[NSString alloc] initWithFormat:@"%d人", [coach stuAllCount]];
    
    NSString *strLbPerPassTmp = [[NSString alloc] initWithFormat:@"通过率：%@", strLbPerPassNum];
    NSString *strLbPerPraiseTmp = [[NSString alloc] initWithFormat:@"好评率：%@", strLbPerPraiseNum];
    NSString *strLbTeachAllCountTmp = [[NSString alloc] initWithFormat:@"已教：%@",strLbTeachAllCountNum];
    
    NSRange rangePerPassNum = [strLbPerPassTmp rangeOfString:strLbPerPassNum];
    NSRange rangePerPraiseNum = [strLbPerPraiseTmp rangeOfString:strLbPerPraiseNum];
    NSRange rangeTeachAllCountNum = [strLbTeachAllCountTmp rangeOfString:strLbTeachAllCountNum];
    
    NSMutableAttributedString *strLbPerPass = [[NSMutableAttributedString alloc] initWithString:strLbPerPassTmp];
    NSMutableAttributedString *strLbPerPraise = [[NSMutableAttributedString alloc] initWithString:strLbPerPraiseTmp];
    NSMutableAttributedString *strLbTeachAllCount = [[NSMutableAttributedString alloc] initWithString:strLbTeachAllCountTmp];
    
    [strLbPerPass addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:rangePerPassNum];
    [strLbPerPraise addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:rangePerPraiseNum];
    [strLbTeachAllCount addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:rangeTeachAllCountNum];
    
    
    CGFloat fWidthLbPerPass = [strLbPerPassTmp sizeWithAttributes:@{NSFontAttributeName:lbPerPassFont}].width;
    CGFloat fWidthLbPerPrise = [strLbPerPraiseTmp sizeWithAttributes:@{NSFontAttributeName:lbPerPraiseFont}].width;
    CGFloat fWidthLbTeachAllCount = [strLbTeachAllCountTmp sizeWithAttributes:@{NSFontAttributeName:lbTeachAllCountFont}].width;
    //信息-通地率
    [lbPerPass setFrame:CGRectMake( viewInfoWidth/2.0f-(fWidthLbPerPass+horizontalSpace+fWidthLbPerPrise+horizontalSpace+fWidthLbTeachAllCount)/2.0f, lbAge.frame.origin.y+CGRectGetHeight(lbAge.frame)+verticalSpace, fWidthLbPerPass, rcLbPerPassHeight)];
    [lbPerPass setAttributedText:strLbPerPass];
    //信息-好评率
    [lbPerPraise setFrame:CGRectMake( lbPerPass.frame.origin.x+lbPerPass.frame.size.width+horizontalSpace, lbPerPass.frame.origin.y, fWidthLbPerPrise, rcLbPerPraiseHeight)];
    [lbPerPraise setAttributedText:strLbPerPraise];
    //信息-已教人数
    [lbTeachAllCount setFrame:CGRectMake( lbPerPraise.frame.origin.x+CGRectGetWidth(lbPerPraise.frame)+horizontalSpace, lbPerPraise.frame.origin.y, fWidthLbTeachAllCount, rcLbTeachAllCountHeight)];
    [lbTeachAllCount setAttributedText:strLbTeachAllCount];
    
    
    
    //培训价格
    [lbTitle_trainPrice setText:[[NSString alloc] initWithFormat:@"培训价格（%@）", [coach userLicenseTypeByString]]];
    [lbPriceDetail setText:[[NSString alloc] initWithFormat:@"科目二：%.0f元/小时\n科目三：%.0f元/小时", price_second, price_third]];
    
    
    
    //预约时间
    //累计学员
    NSString *strLbTeachAllCountExtNum = [[NSString alloc] initWithFormat:@"%d人", [coach stuAllCount]];
    NSString *strLbTeachAllCountExtTmp = [[NSString alloc] initWithFormat:@"%@\n累计学员", strLbTeachAllCountExtNum];
    NSRange rangeTeachAllCountExtNum = [strLbTeachAllCountExtTmp rangeOfString:strLbTeachAllCountExtNum];
    NSMutableAttributedString *strLbTeachAllCountExt = [[NSMutableAttributedString alloc] initWithString:strLbTeachAllCountExtTmp];
    [strLbTeachAllCountExt addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:rangeTeachAllCountExtNum];
    [strLbTeachAllCountExt addAttribute:NSFontAttributeName value:lbReservateItemNumFont range:rangeTeachAllCountExtNum];
    
    [lbTeachAllCountExt setAttributedText:strLbTeachAllCountExt];
    //累计课时
    NSString *strLbAllPeriodNum = [[NSString alloc] initWithFormat:@"%d时", [coach coaTeachAllPeriod]];
    NSString *strLbAllPeriodTmp = [[NSString alloc] initWithFormat:@"%@\n累计课时", strLbAllPeriodNum];
    NSRange rangeTeachAllPeriodNum = [strLbAllPeriodTmp rangeOfString:strLbAllPeriodNum];
    NSMutableAttributedString *strLbTeachAllPeriod = [[NSMutableAttributedString alloc] initWithString:strLbAllPeriodTmp];
    [strLbTeachAllPeriod addAttribute:NSForegroundColorAttributeName value:lbReservatePeriodNumColor range:rangeTeachAllPeriodNum];
    [strLbTeachAllPeriod addAttribute:NSFontAttributeName value:lbReservateItemNumFont range:rangeTeachAllPeriodNum];
    
    [lbTeachAllPeriod setAttributedText:strLbTeachAllPeriod];
    
    
    [self.dateTimePicker reloadData];
    
    [svMain setContentSize:CGSizeMake( svMainWidth, viewReservationInfo.frame.origin.y+CGRectGetHeight(viewReservationInfo.frame)+verticalSpace+dcbHeight)];
}


- (void)showViewError
{
    
    if ( !viewError)
    {
        viewError = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.1f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        
        [viewError addSubview:[LyUtil lbErrorWithMode:0]];
    }
    [svMain setContentSize:CGSizeMake( svMainWidth, svMainHeight*1.05f)];
    [svMain addSubview:viewError];
}

- (void)removeViewError
{
    [viewError removeFromSuperview];
    viewError = nil;
}




- (void)showIndicator_loadWithDate {
    if ( !indicator_loadWithDate) {
        indicator_loadWithDate = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [indicator_loadWithDate setColor:LyBlackColor];
        [indicator_loadWithDate setFrame:CGRectMake( viewReservationInfoWidth/2.0f-30/2.0f, 125, 30, 30)];
    }
    [viewReservationInfo addSubview:indicator_loadWithDate];
    [indicator_loadWithDate startAnimating];
}

- (void)removeIndicator_loadWithDate {
    [indicator_loadWithDate removeFromSuperview];
    [indicator_loadWithDate stopAnimating];
    indicator_loadWithDate = nil;
}


- (void)showViewError_reservationInfo {
    if (!viewError_reservationInfo) {
        viewError_reservationInfo = [[UIView alloc] initWithFrame:CGRectMake(0, dtpCvDateHeight, SCREEN_WIDTH, dtpCvTimeHeight)];
        [viewError_reservationInfo setBackgroundColor:LyWhiteLightgrayColor];
        
        UILabel *lbError = [LyUtil lbErrorWithMode:1];
        [viewError_reservationInfo addSubview:lbError];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadWithDate)];
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        
        [lbError setUserInteractionEnabled:YES];
        [viewError_reservationInfo setUserInteractionEnabled:YES];
        [viewError_reservationInfo addGestureRecognizer:tap];
    }
    
    [self.dateTimePicker addSubview:viewError_reservationInfo];
}

- (void)removeViewError_reservationInfo {
    [viewError_reservationInfo removeFromSuperview];
    viewError_reservationInfo = nil;
}



//所的时间段都先置为不可用
- (void)disableDicTimeDisableAllItem {
    if ( !dicTimeDisable) {
        dicTimeDisable = [[NSMutableDictionary alloc] initWithCapacity:1];
    } else {
        [dicTimeDisable removeAllObjects];
    }
    int i = 24;
    while ( i-- ) {
        [dicTimeDisable setObject:@"NO" forKey:@(i)];
    }
}

//添加可用时间段
- (void)enableDicTimeDisable:(LyPriceDetail *)priceDetail {
    for ( int j = priceDetail.pdTimeBucket.begin; j < priceDetail.pdTimeBucket.end; ++j) {
        [dicTimeDisable removeObjectForKey:@(j/2)];
    }
}



- (void)targetForButtonItem:(UIButton *)button
{
    
    switch ( [button tag]) {
        case reservateCoachButtonItemMode_priceDetail: {
            LyPriceDetailViewController *reservationPriceDetail = [[LyPriceDetailViewController alloc] init];
            [reservationPriceDetail setDelegate:self];
            [self.navigationController pushViewController:reservationPriceDetail animated:YES];
            break;
        }
        case reservateCoachButtonItemMode_: {
            
            break;
        }
        default: {
            break;
        }
            
    }
    
    
}



- (void)refreshData:(UIRefreshControl *)refreshControl
{
    [self loadData];
}



- (void)loadData
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(loadData) object:nil];
        return;
    }
    
    if ( !indicator_load) {
        indicator_load = [[LyIndicator alloc] initWithTitle:@""];
    }
    [indicator_load startAnimation];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:reservateCoachHttpMethod_load];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:reservateCoach_url
                                          body:@{
                                                objectIdKey:_coachId,
                                                driveLicenseKey:[coach userLicenseTypeByString],
                                                dateKey:[[[LyUtil dateFormatterForAll] stringFromDate:curDate] substringToIndex:dateStringLength],
                                                userIdKey:[[LyCurrentUser curUser] userId],
                                                sessionIdKey:[LyUtil httpSessionId]
                                                }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
    
}



- (void)loadWithDate
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(loadWithDate) object:nil];
        return;
    }
    
    [self showIndicator_loadWithDate];
    
    LyHttpRequest *httpReqeust = [LyHttpRequest httpRequestWithMode:reservateCoachHttpMethod_loadWithDate];
    [httpReqeust setDelegate:self];
    bHttpFlag = [[httpReqeust startHttpRequest:reservateCoach_url
                                          body:@{
                                                 objectIdKey:_coachId,
                                                 driveLicenseKey:[coach userLicenseTypeByString],
                                                 dateKey:[[[LyUtil dateFormatterForAll] stringFromDate:curDate] substringToIndex:dateStringLength],
                                                 userIdKey:[[LyCurrentUser curUser] userId],
                                                 sessionIdKey:[LyUtil httpSessionId]
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}


- (void)prereservate {
    
    curPrice = [[LyPriceDetailManager sharedInstance] getPriceWithDate:curDate
                                                            andWeekday:curWeekday
                                                          andTimeStart:curTime
                                                            andLicense:curSubject
                                                                userId:coach.userId];
    
    NSString *message = [[NSString alloc] initWithFormat:@"%@/%@/%@\n%@/%@/%@\n价格：%.0f元", coach.userName, [coach userLicenseTypeByString], [LyUtil subjectModePracStringForm:curSubject], curDateStrMD, [LyUtil weekdayStringFrom:curWeekday], [[NSString alloc] initWithFormat:@"%ld:00-%ld:00", curTime/2, curTime/2+1], curPrice];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请确认你的预约信息"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"预约"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self reservate];
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)reservate
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(reservate) object:nil];
        return;
    }
    
    if ( !indicator_reservate) {
        indicator_reservate = [LyIndicator indicatorWithTitle:@"正在预约..."];
    }
    [indicator_reservate startAnimation];
    
    
//    LyDriveSchool *driveSchool = [[LyUserManager sharedInstance] getDriveSchoolWithDriveSchoolId:[coach coaMasterId]];
    
    NSString *strDescription = [[NSString alloc] initWithFormat:@"%@/%@ %@/%@ %ld:00-%ld:00", [coach userLicenseTypeByString], [LyUtil subjectModePracStringForm:curSubject], curDateStrYMD, [LyUtil weekdayStringFrom:curWeekday], curTime/2, curTime/2+1];
    
    
    NSDictionary *dic = @{
                          masterIdKey:[[LyCurrentUser curUser] userId],
                          phoneKey:[[LyCurrentUser curUser] userPhoneNum],
                          masNameKey:[[LyCurrentUser curUser] userName],
                          objectIdKey:[coach userId],
                          classIdKey:[[NSString alloc] initWithFormat:@"%d", (int)curTime],
                          orderModeKey:@"4",
                          studentCountKey:@"1",
                          applyModeKey:@"0",
                          couponModeKey:@"0",
                          orderNameKey:[coach userName],
                          orderDetailKey:strDescription,
                          remarkKey:@"无",
//                          addressKey:([LyCurrentUser curUser].location.province && [LyCurrentUser curUser].location.city) ? [[NSString alloc] initWithFormat:@"%@%@", [LyCurrentUser curUser].location.province, [LyCurrentUser curUser].location.city] : @"无",
                          addressKey:(currentTrainBase) ? currentTrainBase.tbName : @"无",
                          trainBaseNameKey:(currentTrainBase) ? currentTrainBase.tbName : @"无",
                          stampKey:curDateStrYMD,
                          numKey:[[NSString alloc] initWithFormat:@"%d", (int)curTime],
                          driveLicenseKey:[coach userLicenseTypeByString],
                          subjectModeKey:@(curSubject),
                          durationKey:strDescription,
                          orderPriceKey:[[NSString alloc] initWithFormat:@"%.0f", curPrice],
                          userTypeKey:userTypeCoachKey,
                          sessionIdKey:[LyUtil httpSessionId]
                          };
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:reservateCoachHttpMethod_reservate];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:reservate_url
                                   body:dic
                                   type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
    //reservate_url
}


- (void)attente {
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(attente) object:nil];
        return;
    }
    
    if ( !indicator_oper) {
        indicator_oper = [[LyIndicator alloc] initWithTitle:LyIndicatorTitle_attente];
    }
    [indicator_oper setTitle:LyIndicatorTitle_attente];
    [indicator_oper startAnimation];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:reservateCoachHttpMethod_attente];
    [httpRequest setDelegate:self];
    bHttpFlag =[[httpRequest startHttpRequest:addAttention_url
                                         body:@{
                                                userIdKey:[[LyCurrentUser curUser] userId],
                                                objectIdKey:_coachId,
                                                sessionIdKey:[LyUtil httpSessionId],
                                                userTypeKey:userTypeCoachKey
                                                }
                                         type:LyHttpType_asynPost
                                      timeOut:0] boolValue];
    
}



- (void)deattente {
    
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(deattente) object:nil];
        return;
    }
    if ( !indicator_oper) {
        indicator_oper = [[LyIndicator alloc] initWithTitle:LyIndicatorTitle_deattente];
    }
    [indicator_oper startAnimation];
    
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:reservateCoachHttpMethod_deattente];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:removeAttention_url
                                          body:@{
                                                 userIdKey:[[LyCurrentUser curUser] userId],
                                                 objectIdKey:_coachId,
                                                 sessionIdKey:[LyUtil httpSessionId],
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}



- (void)handleHttpFailed {
    if ([indicator_load isAnimating]) {
        [indicator_load stopAnimation];
        [self showViewError];
        [self.refreshControl endRefreshing];
        [self.navigationController.navigationBar setHidden:NO];
    }
    
    if ([indicator_reservate isAnimating]) {
        [indicator_reservate stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"预约失败"] show];
    }
    
    if ([indicator_loadWithDate isAnimating]) {
        [self removeIndicator_loadWithDate];
        [self showViewError_reservationInfo];
    }
    
    if ( [indicator_oper isAnimating]){
        [indicator_oper stopAnimation];
        
        NSString *remindTitle;
        if ( [[indicator_oper title] isEqualToString:LyIndicatorTitle_attente]) {
            remindTitle = @"关注失败";
        } else if ( [[indicator_oper title] isEqualToString:LyIndicatorTitle_deattente]) {
            remindTitle = @"取关失败";
        }
        
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:remindTitle] show];
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
        [indicator_load stopAnimation];
        [indicator_oper stopAnimation];
        [indicator_reservate stopAnimation];
        [self removeIndicator_loadWithDate];
        [self.refreshControl endRefreshing];
        
        [LyUtil sessionTimeOut:self];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_load stopAnimation];
        [indicator_oper stopAnimation];
        [indicator_reservate stopAnimation];
        [self removeIndicator_loadWithDate];
        [self.refreshControl endRefreshing];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    
    switch ( curHttpMethod) {
        case reservateCoachHttpMethod_load: {
            switch ( [strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [self handleHttpFailed];
                        return;
                    }
                    
                    NSString *strFlag = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:flagKey]];
                    [controlBar setAttentionStatus:[strFlag boolValue]];
                    
                    
                    //教练信息-begin
                    NSDictionary *dicCoachInfo = [dicResult objectForKey:coachKey];
                    if (![LyUtil validateDictionary:dicCoachInfo]) {
                        [self handleHttpFailed];
                        return;
                    }
                    
                    NSString *strCoachId = [dicCoachInfo objectForKey:userIdKey];
                    NSString *strCoachName = [dicCoachInfo objectForKey:nickNameKey];
                    NSString *strMasterId = [dicCoachInfo objectForKey:masterIdKey];
                    NSString *strMasterName = [dicCoachInfo objectForKey:masterNameKey];
                    NSString *strBirthday = [dicCoachInfo objectForKey:birthdayKey];
                    NSString *strTeachBirthday = [dicCoachInfo objectForKey:teachBirthdayKey];
                    NSString *strDriveBirthday = [dicCoachInfo objectForKey:driveBirthdayKey];
                    NSString *strAllCount = [[NSString alloc] initWithFormat:@"%@", [dicCoachInfo objectForKey:teachAllCountKey]];
                    NSString *strPassedCount = [[NSString alloc] initWithFormat:@"%@", [dicCoachInfo objectForKey:teachedPassedCountKey]];
                    NSString *strEvaluationCount = [[NSString alloc] initWithFormat:@"%@", [dicCoachInfo objectForKey:evalutionCountKey]];
                    NSString *strPraiseCount = [[NSString alloc] initWithFormat:@"%@", [dicCoachInfo objectForKey:praiseCountKey]];
                    NSString *strTimeFlag = [[NSString alloc] initWithFormat:@"%@", [dicCoachInfo objectForKey:timeFlagKey]];
                    NSString *strAllPeriod = [[NSString alloc] initWithFormat:@"%@", [dicCoachInfo objectForKey:teachAllPeriodKey]];
                    
                    price_second = [[dicCoachInfo objectForKey:priceSecondKey] floatValue];
                    price_third = [[dicCoachInfo objectForKey:priceThirdKey] floatValue];
                    
                    if (![LyUtil validateString:strCoachId]) {
                        [self handleHttpFailed];
                        return;
                    }
                    
                    if ( !coach || LyUserType_coach != coach.userType) {
                        coach = [LyCoach userWithId:strCoachId
                                             userName:strCoachName];
                        [[LyUserManager sharedInstance] addUser:coach];
                    }
                    [coach setCoaMasterId:strMasterId];
                    [coach setUserBirthday:strBirthday];
                    [coach setCoaTeachBirthday:strTeachBirthday];
                    [coach setCoaDriveBirthday:strDriveBirthday];
                    [coach setStuAllCount:[strAllCount intValue]];
                    [coach setCoaTeachedPassedCount:[strPassedCount intValue]];
                    [coach setCoaEvaluationCount:[strEvaluationCount intValue]];
                    [coach setCoaPraiseCount:[strPraiseCount intValue]];
                    [coach setTimeFlag:[strTimeFlag boolValue]];
                    [coach setCoaTeachAllPeriod:[strAllPeriod intValue]];
                    
                    
                    if ([LyUtil validateString:strMasterId]) {
                        LyDriveSchool *driveSchool = [[LyUserManager sharedInstance] getDriveSchoolWithDriveSchoolId:strMasterId];
                        if ( !driveSchool) {
                            driveSchool = [LyDriveSchool userWithId:strMasterId
                                                                  userName:strMasterName];
                            
                            [[LyUserManager sharedInstance] addUser:driveSchool];
                        }
                    }
                    //教练信息-end
                    
                    //基地-begin
                    NSDictionary *dicTrainBase = [dicResult objectForKey:trainBaseKey];
                    if ([LyUtil validateDictionary:dicTrainBase]) {
                        NSString *strId = [dicTrainBase objectForKey:idKey];
                        NSString *strName = [dicTrainBase objectForKey:trainBaseNameKey];
                        NSString *strAddress = [dicTrainBase objectForKey:addressKey];
                        NSString *strCoachCount = [[NSString alloc] initWithFormat:@"%@", [dicTrainBase objectForKey:coachCountKey]];
                        NSString *strStudentCount = [[NSString alloc] initWithFormat:@"%@", [dicTrainBase objectForKey:studentCountKey]];
                        
                        
                        currentTrainBase = [[LyTrainBaseManager sharedInstance] getTrainBaseWithTbId:strId];
                        if ( !currentTrainBase) {
                            currentTrainBase = [LyTrainBase trainBaseWithTbId:strId
                                                                       tbName:strName
                                                                    tbAddress:strAddress
                                                                 tbCoachCount:[strCoachCount integerValue]
                                                               tbStudentCount:[strStudentCount integerValue]];
                            
                            [[LyTrainBaseManager sharedInstance] addTrainBase:currentTrainBase];
                        }
                    }
                    //基地-end
                    
                    
                    //将所的时间段都先置为不可用
                    [self disableDicTimeDisableAllItem];
                    
                    
                    
                    //解析日期信息
//                    NSString *strDate = [dicResult objectForKey:dateKey];
//                    strDate = [LyUtil fixDateTimeString:strDate isExplicit:YES];
//                    
//                    curDate = [[LyUtil dateFormatterForAll] dateFromString:strDate];
                    curDateStrYMD = [[curDate description] substringToIndex:dateStringLength];
                    curDateStrMD = [[curDate description] substringWithRange:NSMakeRange( 5, 5)];
                    curWeekday = [LyUtil weekdayWithDate:curDate];
                    
                    
                    //价格详情-begin
                    NSArray *arrPrice = [dicResult objectForKey:priceKey];
                    if ([LyUtil validateArray:arrPrice]) {
                        for (NSDictionary *dicItem in arrPrice) {
                            if (![LyUtil validateDictionary:dicItem]) {
                                continue;
                            }
                            
                            NSString *strId = [dicItem objectForKey:idKey];
                            NSString *strWeekdays = [dicItem objectForKey:weekdaysKey];
                            NSString *strTimeBucket = [dicItem objectForKey:timebucketKey];
                            NSString *strPrice = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:priceKey]];
                            NSString *strDriveLicense = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:driveLicenseKey]];
                            NSString *strSubject = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:subjectModeKey]];
                            
                            LyPriceDetail *priceDetail = [LyPriceDetail priceDetailWithPdId:strId
                                                                              pdLicenseType:[LyUtil driveLicenseFromString:strDriveLicense]
                                                                              pdSubjectMode:[strSubject integerValue]
                                                                                 pdMasterId:_coachId
                                                                                  pdWeekday:strWeekdays
                                                                                     pdTime:strTimeBucket
                                                                                    pdPrice:[strPrice floatValue]];
                            
                            if (LySubjectModeprac_second == [strSubject integerValue]) {
                                if (price_second < 1 || [strPrice floatValue] < price_second) {
                                    price_second = [strPrice floatValue];
                                }
                            } else if (LySubjectModeprac_third == [strSubject integerValue]) {
                                if (price_third < 1 || [strPrice floatValue] < price_third) {
                                    price_third = [strPrice floatValue];
                                }
                            }
                            
                            if (priceDetail.pdWeekdaySpan.begin <= curWeekday && curWeekday <= priceDetail.pdWeekdaySpan.end) {
                                [self enableDicTimeDisable:priceDetail];
                            }
                            
                            
                            [[LyPriceDetailManager sharedInstance] addPriceDetail:priceDetail];
                        }
                    }
                    //价格详情-end
                    
                    //今日已预约信息-begin
                    //先将所有时间段信息置为空
                    [dicDateTimeInfo removeAllObjects];
                    
                    NSArray *arrReser = [dicResult objectForKey:reservationInfoKey];
                    if ([LyUtil validateArray:arrReser]) {
                        for ( int i = 0; i < [arrReser count]; ++i) {
                            NSDictionary *dicItem = [arrReser objectAtIndex:i];
                            if (![LyUtil validateDictionary:dicItem]) {
                                continue;
                            }

                            NSString *strMasterId = [dicItem objectForKey:masterIdKey];
                            NSString *strTime = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:numKey]];
                            NSString *strMasterName = [dicItem objectForKey:nickNameKey];
                            
                            NSInteger iTime = [strTime integerValue] / 2;
                            
                            LyDateTimeInfo *dti = [LyDateTimeInfo dateTimeInfoWithMode:iTime
                                                                                  date:curDate
                                                                                 state:LyDateTimeInfoState_used
                                                                              objectId:[coach userId]
                                                                              masterId:strMasterId
                                                                            masterName:strMasterName];
                            [dicDateTimeInfo setObject:dti forKey:@(iTime)];
                            
                        }
                    }
                    //今日已预约信息-end
                    
                    
                    //完善今日所有时段的情况-begin
                    for ( int i = 0; i < 24; ++i) {
                        LyDateTimeInfo *dti = [dicDateTimeInfo objectForKey:@(i)];
                        
                        if ( !dti) {
                            if ( [dicTimeDisable objectForKey:@(i)]) {
                                dti = [LyDateTimeInfo dateTimeInfoWithMode:i
                                                                      date:curDate
                                                                     state:LyDateTimeInfoState_disable
                                                                  objectId:[coach userId]
                                                                  masterId:nil
                                                                masterName:nil];
                            } else {
                                dti = [LyDateTimeInfo dateTimeInfoWithMode:i
                                                                      date:curDate
                                                                     state:LyDateTimeInfoState_useable
                                                                  objectId:[coach userId]
                                                                  masterId:nil
                                                                masterName:nil];
                            }
                            
                            [dicDateTimeInfo setObject:dti forKey:@(i)];
                        }
                    }
                    //完善今日所有时段的情况-end
                    
                    [self reloadData];
                    
                    [indicator_load stopAnimation];
                    [self.refreshControl endRefreshing];

                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            
            break;
        }
        case reservateCoachHttpMethod_loadWithDate: {
            switch ( [strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [self removeIndicator_loadWithDate];
                        [self showViewError_reservationInfo];
                        return;
                    }
                
                    
                    //解析日期信息
//                    NSString *strDate = [dicResult objectForKey:dateKey];
//                    strDate = [LyUtil fixDateTimeString:strDate isExplicit:YES];
//                    
//                    curDate = [[LyUtil dateFormatterForAll] dateFromString:strDate];
                    curDateStrYMD = [[curDate description] substringToIndex:dateStringLength];
                    curDateStrMD = [[curDate description] substringWithRange:NSMakeRange( 5, 5)];
                    curWeekday = [LyUtil weekdayWithDate:curDate];
                    
                    
                    //将所的时间段都先置为不可用
                    [self disableDicTimeDisableAllItem];
                    
                    NSArray *arr = [[LyPriceDetailManager sharedInstance] priceDetailWithUserId:coach.userId];
                    for (LyPriceDetail *priceDetail in arr) {
                        if (priceDetail.pdWeekdaySpan.begin <= curWeekday && curWeekday <= priceDetail.pdWeekdaySpan.end) {
                            [self enableDicTimeDisable:priceDetail];
                        }
                    }
                    
                    //今日已预约信息-begin
                    //先将所有时间段信息置为空
                    [dicDateTimeInfo removeAllObjects];
                    
                    NSArray *arrReser = [dicResult objectForKey:reservationInfoKey];
                    if ([LyUtil validateArray:arrReser]) {
                        for ( int i = 0; i < [arrReser count]; ++i) {
                            NSDictionary *dicItem = [arrReser objectAtIndex:i];
                            if (![LyUtil validateDictionary:dicItem]) {
                                continue;
                            }
                            
                            NSString *strMasterId = [dicItem objectForKey:masterIdKey];
                            NSString *strTime = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:numKey]];
                            NSString *strMasterName = [dicItem objectForKey:nickNameKey];
                            
                            NSInteger iTime = [strTime integerValue] / 2;
                            
                            LyDateTimeInfo *dti = [LyDateTimeInfo dateTimeInfoWithMode:iTime
                                                                                  date:curDate
                                                                                 state:LyDateTimeInfoState_used
                                                                              objectId:[coach userId]
                                                                              masterId:strMasterId
                                                                            masterName:strMasterName];
                            [dicDateTimeInfo setObject:dti forKey:@(iTime)];
                        }
                    }
                    //今日已预约信息-end
                    
                    
                    //完善今日所有时段的情况-begin
                    for ( int i = 0; i < 24; ++i) {
                        LyDateTimeInfo *dti = [dicDateTimeInfo objectForKey:@(i)];
                        if ( !dti) {
                            if ( [dicTimeDisable objectForKey:@(i)]) {
                                dti = [LyDateTimeInfo dateTimeInfoWithMode:i
                                                                      date:curDate
                                                                     state:LyDateTimeInfoState_disable
                                                                  objectId:[coach userId]
                                                                  masterId:nil
                                                                masterName:nil];
                            } else {
                                dti = [LyDateTimeInfo dateTimeInfoWithMode:i
                                                                      date:curDate
                                                                     state:LyDateTimeInfoState_useable
                                                                  objectId:[coach userId]
                                                                  masterId:nil
                                                                masterName:nil];
                            }
                            
                            [dicDateTimeInfo setObject:dti forKey:@(i)];
                        }
                    }
                    //完善今日所有时段的情况-end
                    
                    [self reloadData];
                    
                    [self removeIndicator_loadWithDate];
                    [self removeViewError_reservationInfo];

                    break;
                }
                    
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case reservateCoachHttpMethod_reservate: {
            switch ( [strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [indicator_reservate stopAnimation];
                        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"预约失败"] show];
                        
                        return;
                    }
                    
                    NSString *strOrderId = [dicResult objectForKey:orderIdKey];
                    NSString *strConsignee = [dicResult objectForKey:masNameKey];
                    NSString *strMasterId = [dicResult objectForKey:masterIdKey];
                    NSString *strObjectId = [dicResult objectForKey:objectIdKey];
                    NSString *strAddress = [dicResult objectForKey:addressKey];
                    NSString *strTrainBaseName = [dicResult objectForKey:trainBaseNameKey];
                    NSString *strPhone = [dicResult objectForKey:phoneKey];
                    NSString *strRemark = [dicResult objectForKey:remarkKey];
                    NSString *strOrderTime = [dicResult objectForKey:orderTimeKey];
                    NSString *strMode = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:orderModeKey]];
                    NSString *strPrice = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:orderPriceKey]];
                    NSString *strPreferentialPrice = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:orderPreferentialPriceKey]];
                    NSString *strPaidNum = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:paidNumKey]];
                    NSString *strStuCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:studentCountKey]];
                    NSString *strState = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:orderStateKey]];
                    NSString *strCouponMode = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:couponModeKey]];
                    NSString *strNum = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:numKey]];
                    NSString *strDuration = [dicResult objectForKey:durationKey];
                    NSString *strOrderName = [dicResult objectForKey:orderNameKey];
                    NSString *strOrderDetail = [dicResult objectForKey:orderDetailKey];
                    NSString *strClassId = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:classIdKey]];
                    
                    order = [LyOrder orderWithOrderId:strOrderId
                                        orderMasterId:strMasterId
                                            orderName:strOrderName
                                          orderDetail:strOrderDetail
                                       orderConsignee:strConsignee
                                     orderPhoneNumber:strPhone
                                         orderAddress:strAddress
                                  orderTrainBaseName:strTrainBaseName
                                            orderTime:strOrderTime
                                         orderPayTime:@""
                                        orderObjectId:strObjectId
                                         orderClassId:strClassId
                                          orderRemark:strRemark
                                          orderStatus:[strState integerValue]
                                            orderMode:[strMode integerValue]
                                    orderStudentCount:[strStuCount integerValue]
                                           orderPrice:[strPrice doubleValue]
                               orderPreferentialPrice:[strPreferentialPrice doubleValue]
                                         orderPaidNum:[strPaidNum doubleValue]
                                       orderApplyMode:0
                                            orderFlag:1];
                    
                    [order setOrderDuration:strDuration];
                    
                    [[LyOrderManager sharedInstance] addOrder:order];
                    
                    
                    [indicator_reservate stopAnimation];
                    LyOrderInfoViewController *orderInfo = [[LyOrderInfoViewController alloc] init];
                    [orderInfo setDelegate:self];
                    [self.navigationController pushViewController:orderInfo animated:YES];
                    
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case reservateCoachHttpMethod_attente: {
            switch ( [strCode integerValue]) {
                case 0: {
                    [controlBar setAttentionStatus:YES];
                    [indicator_oper stopAnimation];
                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"关注成功"];
                    [remind show];
                    break;
                }
                case 1: {
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"关注失败"] show];
                    break;
                }
                case 2: {
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"关注已达上限"] show];
                    break;
                }
                case 3: {
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"你已关注过该用户"] show];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case reservateCoachHttpMethod_deattente: {
    
            switch ( [strCode integerValue]) {
                case 0: {
                    [controlBar setAttentionStatus:NO];
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"取关成功"] show];
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


#pragma mark -LyDetailControlBarDelegate
- (void)onClickedButtonAttente {
    if ( [controlBar attentionStatus]) {
        
        UIAlertController *action = [UIAlertController alertControllerWithTitle:[[NSString alloc] initWithFormat:@"你确定不再关注「%@」吗？", coach.userName]
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
        [action addAction:[UIAlertAction actionWithTitle:@"取消"
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
        [action addAction:[UIAlertAction actionWithTitle:@"不再关注"
                                                   style:UIAlertActionStyleDestructive
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     [self deattente];
                                                 }]];
        [self presentViewController:action animated:YES completion:nil];
        
    } else {
        [self attente];
    }
}

- (void)onClickedButtonPhone {
    [LyUtil call:phoneNum_517];
}


- (void)onClickedButtonMessage {
    [LyUtil sendSMS:nil
         recipients:@[messageNum_517]
             target:self];
}


#pragma mark -MFMessageComposeViewControllerDelegate
// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    [NSThread sleepForTimeInterval:sleepTime];
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled) {
        [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"短信发送取消"] show];
    } else if (result == MessageComposeResultSent) {
        [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"短信发送成功"] show];
    } else {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"短信发送失败"] show];
    }
}


#pragma mark -LyOrderInfoViewControllerdelegate
- (LyOrder *)obtainOrderByOrderInfoViewController:(LyOrderInfoViewController *)aOrderInfoVC
{
    return order;
}


#pragma mark -LyPriceDetailViewControllerDelegate
//- (NSString *)obtainTeacherIdByReservationPriceDetailViewController:(LyReservationPriceDetailViewController *)aReservationPriceDetail
- (NSString *)obtainTeacherIdByPriceDetailVC:(LyPriceDetailViewController *)aPriceDetailVC {
    return [coach userId];
}




#pragma mark -LyDateTimePickerDelegate
- (void)dateTimePicker:(LyDateTimePicker *)aDateTimePicker didSelectDateItemAtIndex:(NSInteger)index andDate:(NSDate *)date {
    if (![LyCurrentUser curUser].isLogined) {
        [LyUtil showLoginVc:self];
        return;
    }
    
    curDate = date;
    curDateStrYMD = [[curDate description] substringToIndex:dateStringLength];
    curDateStrMD = [[curDate description] substringWithRange:NSMakeRange( 5, 5)];
    
    
    [self loadWithDate];
}

- (void)dateTimePicker:(LyDateTimePicker *)aDateTimePicker didSelectTimeItemAtIndex:(NSInteger)index andDate:(NSDate *)date andWeekday:(LyWeekday)weekday
{
    if (![LyCurrentUser curUser].isLogined) {
        [LyUtil showLoginVc:self];
        return;
    }
    
    curDate = date;
    curWeekday = weekday;
    curTime = index*2;
    
    
    curDateStrYMD = [[curDate description] substringToIndex:dateStringLength];
    curDateStrMD = [[curDate description] substringWithRange:NSMakeRange( 5, 5)];
    
    
    //判断支持的科目
    curMode = [[LyPriceDetailManager sharedInstance] getSubjectSupportModeWith:curWeekday andTimeStart:curTime userId:coach.userId];
    UIAlertController *action = [UIAlertController alertControllerWithTitle:@"请选择要预约的科目"
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    [action addAction:[UIAlertAction actionWithTitle:@"取消"
                                               style:UIAlertActionStyleCancel
                                             handler:nil]];
    switch (curMode) {
        case LySubjectModeSupportMode_none: {
            return;
            break;
        }
        case LySubjectModeSupportMode_second: {
            [action addAction:[UIAlertAction actionWithTitle:@"科目二"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         curSubject = LySubjectModeprac_second;
                                                         [self prereservate];
                                                     }]];
            break;
        }
        case LySubjectModeSupportMode_third: {
            [action addAction:[UIAlertAction actionWithTitle:@"科目三"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         curSubject = LySubjectModeprac_third;
                                                         [self prereservate];
                                                     }]];
            break;
        }
        case LySubjectModeSupportMode_both: {
            [action addAction:[UIAlertAction actionWithTitle:@"科目二"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         curSubject = LySubjectModeprac_second;
                                                         [self prereservate];
                                                     }]];
            
            [action addAction:[UIAlertAction actionWithTitle:@"科目三"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         curSubject = LySubjectModeprac_third;
                                                         [self prereservate];
                                                     }]];
            break;
        }
    }
    
    [self presentViewController:action animated:YES completion:nil];
}


#pragma mark -LyDateTimePickerDataSource
- (NSDate *)dateInDateTimePicker:(LyDateTimePicker *)aDateTimePicker
{
    return curDate;
}


- (LyDateTimeInfo *)dateTimePicker:(LyDateTimePicker *)aDateTimePicker forItemIndex:(NSInteger)index
{
    return [dicDateTimeInfo objectForKey:@(index)];
}






#pragma mark -UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.ly_offsetY < 0)
    {
        CGFloat newHeight = rcViewInfoHeight - scrollView.ly_offsetY;
        CGFloat newWidth = SCREEN_WIDTH * newHeight / rcViewInfoHeight;
        
        CGFloat newX = (SCREEN_WIDTH - newWidth) / 2.0;
        CGFloat newY = scrollView.ly_offsetY;
        
        ivBack.frame = CGRectMake(newX, newY, newWidth, newHeight);
    }
    else
    {
        ivBack.frame = CGRectMake(0, 0, SCREEN_WIDTH, rcViewInfoHeight);
    }
        
    if ( [svMain contentOffset].y > rcViewInfoHeight-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT)
    {
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else
    {
        [self.navigationController.navigationBar setBackgroundImage:[LyUtil imageForImageName:@"uci_navigatinBar" needCache:NO] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController navigationBar].shadowImage = [LyUtil imageForImageName:@"uci_navigatinBar" needCache:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
