//
//  LyMyCoachViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/17.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyMyCoachViewController.h"
#import "LyTrainClassTableViewCell.h"
//#import "LyHistoryCoachTableViewCell.h"
//#import "LyTableViewFooterView.h"
#import "LyDateTimePicker.h"
#import "LyDetailControlBar.h"

#import "LyPriceDetailManager.h"
#import "LyOrderManager.h"


#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyUserManager.h"
#import "LyCurrentUser.h"
#import "LyTrainClassManager.h"
#import "LyTrainBaseManager.h"

#import "UIView+LyExtension.h"
#import "UIScrollView+LyExtension.h"
#import "LyUtil.h"


#import "LyAddCoachTableViewController.h"
//#import "LyReservationPriceDetailViewController.h"
#import "LyPriceDetailViewController.h"
#import "LyOrderInfoViewController.h"


#import <MessageUI/MessageUI.h>

#define mcoaWidth                       SCREEN_WIDTH
#define mcoaHeight                      SCREEN_HEIGHT


#define svMainWidth                     mcoaWidth
#define svMainHeight                    mcoaHeight

#define viewErrorWidth                  mcoaWidth
#define viewErrorHeight                 svMainHeight


//信息
#define mcViewInfoWidth                   mcoaWidth
CGFloat const mcViewInfoHeight = 220.0f;
//信息-头像
CGFloat const mcIvAvatarSize = 60.0f;
//信息-名
#define lbNameWidth                     mcViewInfoWidth
CGFloat const mcLbNameHeight = 30.0f;
#define lbNameFont                      LyFont(15)
//信息-计时培训
#define mcLbMasterNameWidth              mcViewInfoWidth
CGFloat const mcLbMasterNameHeight = 20.0f;
#define lbMasterNameFont               LyFont(14)

#define mcLbTrainBaseNameWidth           mcViewInfoWidth
CGFloat const mcLbTrainBaseNameHeight = 20.0f;
#define lbTrainBaseNameFont            LyFont(12)


//培训课程
#define viewTrainClassWidth             svMainWidth
CGFloat const viewTrainClassHeight = 10.0f;


//培训价格
CGFloat const mcViewPriceDetailHeight = 80.0f;

#define mcLbPriceDetailWidth              (svMainWidth-horizontalSpace*2)
CGFloat const mcLbPriceDetailHeight = 50.0f;
#define lbPriceDetailFont               LyFont(13)


//预约时间
#define viewReservationInfoWidth        svMainWidth
#define viewReservationInfoHeight       (dateTimePickerDefaultHeight+mcLbStudentCountHeight+30)

#define mcLbStudentCountWidth             (viewReservationInfoWidth/2.0f)
CGFloat const mcLbStudentCountHeight = 40.0f;

#define mcLbPeriodCountWidth              mcLbStudentCountWidth
CGFloat const mcLbPeriodCountHeight = 40.0f;

#define lbStudentCountFont              LyFont(12)
#define lbStudentCountNumFont           LyFont(14)



typedef NS_ENUM( NSInteger, LyMyCoachBarButtonItemMode)
{
    myCoachBarButtonItemMode_right = 0
};


typedef NS_ENUM( NSInteger, LyMyCoachButtonMode)
{
    myCoachButtonMode_priceDetail = 10,
};




typedef NS_ENUM( NSInteger, LyMyCoachTableViewMode)
{
    myCoachTableViewMode_trainClass = 20
};



typedef NS_ENUM( NSInteger, LyMyCoachHttpMethod)
{
    myCoachHttpMethod_load = 100,
    myCoachHttpMethod_loadWithDate,
    myCoachHttpMethod_reservate,
    myCoachHttpMethod_attente,
    myCoachHttpMethod_deattente
};


NSString *const lyMyCoachTrainClassTableViewCellReuseIdentifier = @"lyMyCoachTrainClassTableViewCellReuseIdentifier";



@interface LyMyCoachViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, LyHttpRequestDelegate, LyDateTimePickerDelegate, LyDateTimePickerDataSource, LyDetailControlBarDelegate, LyAddCoachTableViewControllerDelegate, LyPriceDetailViewControllerDelegate, MFMessageComposeViewControllerDelegate, LyOrderInfoViewControllerdelegate>
{
    
    UIScrollView            *svMain;
    
//    UIRefreshControl        *refresher;
    LyIndicator             *indicator_load;
    
    
    UIView                  *viewError;
    
    UIView                  *viewInfo;
    UIImageView     *ivBack;
    UIImageView             *ivAvatar;
    UILabel                 *lbName;
    UILabel                 *lbMasterName;
    UILabel                 *lbTrainBaseName;
    
    UIView                  *viewTrainClass;
    UILabel                 *lbTitle_trainClass;
    UITableView             *tvTrainClass;
    UILabel                 *lbNull_trainClass;
    UIView                  *horizontalLine_trainClass;

    UIView                  *viewPriceDetail;
    UILabel                 *lbTitle_priceDetail;
    UIButton                *btnFunc_priceDetail;
    UILabel                 *lbPriceDetail;
    UIView                  *horizontalLine_priceDetail;
    

    UIView                  *viewReservationInfo;
    UILabel                 *lbTitle_reservation;
    UILabel                 *lbStudentCount;
    UILabel                 *lbPeriodCount;
//    LyDateTimePicker        *dateTimePicker;
    UILabel                 *lbNull_reservation;
    UIView                  *viewError_reservationInfo;
    
    
    
    LyDetailControlBar      *controlBar;
    
    
    LyIndicator             *indicator_reservate;
    
    UIActivityIndicatorView *indicator_loadWithDate;
    
    LyOrder                 *order;
    NSIndexPath             *curIdx;
    
    LyTrainClass            *currentTrainClass;
    LyTrainBase             *currentTrainBase;
    LyCoach                 *coach;
    LyDriveSchool           *driveSchool;
    
    NSDictionary            *dicPriceDetail;

    float                   price_second;
    float                   price_third;
    
    NSString                *curDateStrYMD;
    NSString                *curDateStrMD;
    NSDate                  *curDate;
    NSInteger               curTime;
//    NSString                *curWeekday;
    LyWeekday                curWeekday;
    LySubjectModeSupportMode curMode;
    LySubjectModeprac       curSubject;
    float                   curPrice;
    
    NSMutableDictionary     *dicTimeDisable;
    
    NSMutableDictionary     *dicDateTimeInfo;
    
    LyIndicator             *indicator_oper;
    
    BOOL                    flagLoadSuccess;
    BOOL                    bHttpFlag;
    LyMyCoachHttpMethod     curHttpMethod;
}

@property (strong, nonatomic)       UIRefreshControl        *refreshControl;
@property (strong, nonatomic)       LyDateTimePicker        *dateTimePicker;

@end

@implementation LyMyCoachViewController



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
    
    
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    
    [svMain setContentOffset:CGPointMake(0, 0)];
    
    if (!flagLoadSuccess){
        [self loadData];
    }
}



- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}



- (void)initSubviews
{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"更换" style:UIBarButtonItemStyleDone target:self action:@selector(targetForBarButtonItem:)];
    [right setTag:myCoachBarButtonItemMode_right];
    [self.navigationItem setRightBarButtonItem:right];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 0, svMainWidth, svMainHeight)];
    [svMain setBackgroundColor:[UIColor whiteColor]];
    [svMain setBounces:YES];
    [svMain setDelegate:self];
    [svMain setContentSize:CGSizeMake( svMainWidth, svMainHeight*1.5f)];
    
    
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, mcViewInfoWidth, mcViewInfoHeight)];
    
    ivBack = [[UIImageView alloc] initWithFrame:viewInfo.bounds];
    ivBack.contentMode = UIViewContentModeScaleAspectFill;
    ivBack.image = [LyUtil imageForImageName:@"chd_background" needCache:NO];
    
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake( mcViewInfoWidth/2.0f-mcIvAvatarSize/2.0f, mcViewInfoHeight-(mcIvAvatarSize+verticalSpace+mcLbNameHeight+verticalSpace+mcLbMasterNameHeight+verticalSpace+mcLbTrainBaseNameHeight+verticalSpace), mcIvAvatarSize, mcIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [[ivAvatar layer] setCornerRadius:btnCornerRadius];
    [ivAvatar setClipsToBounds:YES];
    
    lbName = [[UILabel alloc] initWithFrame:CGRectMake( 0, ivAvatar.frame.origin.y+CGRectGetHeight(ivAvatar.frame)+verticalSpace, lbNameWidth, mcLbNameHeight)];
    [lbName setFont:lbNameFont];
    [lbName setTextColor:[UIColor whiteColor]];
    [lbName setTextAlignment:NSTextAlignmentCenter];
    
    lbMasterName = [[UILabel alloc] initWithFrame:CGRectMake( 0, lbName.frame.origin.y+CGRectGetHeight(lbName.frame)+verticalSpace, mcLbMasterNameWidth, mcLbMasterNameHeight)];
    [lbMasterName setFont:lbMasterNameFont];
    [lbMasterName setTextColor:[UIColor whiteColor]];
    [lbMasterName setTextAlignment:NSTextAlignmentCenter];
    
    lbTrainBaseName = [[UILabel alloc] initWithFrame:CGRectMake( 0, lbMasterName.frame.origin.y+CGRectGetHeight(lbMasterName.frame)+verticalSpace, mcLbTrainBaseNameWidth, mcLbTrainBaseNameHeight)];
    [lbTrainBaseName setFont:lbTrainBaseNameFont];
    [lbTrainBaseName setTextColor:[UIColor whiteColor]];
    [lbTrainBaseName setTextAlignment:NSTextAlignmentCenter];
    
    [viewInfo addSubview:ivBack];
    [viewInfo addSubview:ivAvatar];
    [viewInfo addSubview:lbName];
    [viewInfo addSubview:lbMasterName];
    [viewInfo addSubview:lbTrainBaseName];
    
    
    
    viewTrainClass = [[UIView alloc] initWithFrame:CGRectMake( 0, viewInfo.frame.origin.y+CGRectGetHeight(viewInfo.frame), viewTrainClassWidth, viewTrainClassHeight)];
    [viewTrainClass setBackgroundColor:[UIColor whiteColor]];
    lbTitle_trainClass = [LyUtil lbItemTitleWithText:@"当前课程"];
    tvTrainClass = [[UITableView alloc] initWithFrame:CGRectMake( 0, lbTitle_trainClass.frame.origin.y+CGRectGetHeight(lbTitle_trainClass.frame), SCREEN_WIDTH, tcHeight*1)
                                                style:UITableViewStylePlain];
    [tvTrainClass setTag:myCoachTableViewMode_trainClass];
    [tvTrainClass setDelegate:self];
    [tvTrainClass setDataSource:self];
    [tvTrainClass setScrollsToTop:NO];
    [tvTrainClass setScrollEnabled:NO];
    [tvTrainClass setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tvTrainClass registerClass:[LyTrainClassTableViewCell class] forCellReuseIdentifier:lyMyCoachTrainClassTableViewCellReuseIdentifier];
    
    horizontalLine_trainClass = [[UIView alloc] init];
    [horizontalLine_trainClass setBackgroundColor:LyHorizontalLineColor];
    
    [viewTrainClass addSubview:lbTitle_trainClass];
    [viewTrainClass addSubview:tvTrainClass];
    [viewTrainClass addSubview:horizontalLine_trainClass];
    
    
    
    viewPriceDetail = [[UIView alloc] initWithFrame:CGRectMake( 0, viewTrainClass.frame.origin.y+CGRectGetHeight(viewTrainClass.frame), SCREEN_WIDTH, mcViewPriceDetailHeight)];
    lbTitle_priceDetail = [LyUtil lbItemTitleWithText:@"培训价格"];
    btnFunc_priceDetail = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH-LyBtnMoreWidth, 0, LyBtnMoreWidth, LyBtnMoreHeight)];
    [btnFunc_priceDetail setTag:myCoachButtonMode_priceDetail];
    [[btnFunc_priceDetail titleLabel] setFont:LyFont(12)];
    [btnFunc_priceDetail setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnFunc_priceDetail setTitle:@"详情" forState:UIControlStateNormal];
    [btnFunc_priceDetail addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    lbPriceDetail = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, lbTitle_priceDetail.frame.origin.y+CGRectGetHeight(lbTitle_priceDetail.frame), mcLbPriceDetailWidth, mcLbPriceDetailHeight)];
    [lbPriceDetail setFont:lbPriceDetailFont];
    [lbPriceDetail setTextColor:LyBlackColor];
    [lbPriceDetail setNumberOfLines:0];
    [lbPriceDetail setTextAlignment:NSTextAlignmentLeft];
    
    horizontalLine_priceDetail = [[UIView alloc] init];
    [horizontalLine_priceDetail setBackgroundColor:LyHorizontalLineColor];
    
    [viewPriceDetail addSubview:lbTitle_priceDetail];
    [viewPriceDetail addSubview:btnFunc_priceDetail];
    [viewPriceDetail addSubview:lbPriceDetail];
    [viewPriceDetail addSubview:horizontalLine_priceDetail];
    
    
    viewReservationInfo = [[UIView alloc] initWithFrame:CGRectMake( 0, viewPriceDetail.frame.origin.y+CGRectGetHeight(viewPriceDetail.frame), dateTimePickerDefaultWidth, viewReservationInfoHeight)];
    [viewReservationInfo setBackgroundColor:[UIColor whiteColor]];
    
    lbTitle_reservation = [LyUtil lbItemTitleWithText:@"预约时间"];
    
    lbStudentCount = [[UILabel alloc] initWithFrame:CGRectMake( 0, lbTitle_reservation.frame.origin.y+CGRectGetHeight(lbTitle_reservation.frame), mcLbStudentCountWidth, mcLbStudentCountHeight)];
    [lbStudentCount setFont:lbStudentCountFont];
    [lbStudentCount setTextColor:LyBlackColor];
    [lbStudentCount setTextAlignment:NSTextAlignmentCenter];
    [lbStudentCount setNumberOfLines:0];
    
    lbPeriodCount = [[UILabel alloc] initWithFrame:CGRectMake( mcLbStudentCountWidth, lbStudentCount.frame.origin.y, mcLbPeriodCountWidth, mcLbPeriodCountHeight)];
    [lbPeriodCount setFont:lbStudentCountFont];
    [lbPeriodCount setTextColor:LyBlackColor];
    [lbPeriodCount setTextAlignment:NSTextAlignmentCenter];
    [lbPeriodCount setNumberOfLines:0];

    //
//    self.dateTimePicker;
    
    [viewReservationInfo addSubview:lbTitle_reservation];
    [viewReservationInfo addSubview:lbStudentCount];
    [viewReservationInfo addSubview:lbPeriodCount];
    [viewReservationInfo addSubview:self.dateTimePicker];
    
    
    [svMain addSubview:viewInfo];
    [svMain addSubview:viewTrainClass];
    [svMain addSubview:viewPriceDetail];
    [svMain addSubview:viewReservationInfo];
    
    
    [svMain addSubview:self.refreshControl];
    
    
    controlBar = [LyDetailControlBar controlBarWidthMode:LyDetailControlBarMode_myCDG];
    [controlBar setDelegate:self];
    
    
    [viewPriceDetail setHidden:YES];
    [self.dateTimePicker setHidden:YES];
    
    
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
        _dateTimePicker = [[LyDateTimePicker alloc] initWithFrame:CGRectMake( 0, lbStudentCount.frame.origin.y+CGRectGetHeight(lbStudentCount.frame), dateTimePickerDefaultWidth, dateTimePickerDefaultHeight)];
        [_dateTimePicker setDelegate:self];
        [_dateTimePicker setDataSource:self];
    }
    
    return _dateTimePicker;
}


- (void)reloadData {
    if ( !coach) {
        [self showViewError];
        return;
    }
    
    if ( ![coach userAvatar]) {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:[coach userId]]
                    placeholderImage:[LyUtil defaultAvatarForTeacher]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if (image) {
                                   [coach setUserAvatar:image];
                               } else {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:[coach userId]]
                                                       placeholderImage:[LyUtil defaultAvatarForTeacher]
                                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                  if (image) {
                                                                      [coach setUserAvatar:image];
                                                                  }
                                                              }];
                               }
                           }];
    } else {
        [ivAvatar setImage:[coach userAvatar]];
    }
    
    [lbName setText:coach.userName];
    [lbMasterName setText:[driveSchool userName]];
    [lbTrainBaseName setText:@""];
    
    if ( currentTrainBase) {
        [lbTrainBaseName setHidden:NO];
        [lbTrainBaseName setText:[currentTrainBase tbName]];
    }
    else {
        [lbTrainBaseName setHidden:YES];
    }
    
    
    if ( !currentTrainClass) {
        if ( !lbNull_trainClass) {
            lbNull_trainClass = [[UILabel alloc] initWithFrame:CGRectMake( 0, lbTitle_trainClass.frame.origin.y+CGRectGetHeight(lbTitle_trainClass.frame), SCREEN_WIDTH, LyNullItemHeight)];
            [lbNull_trainClass setFont:LyNullItemTitleFont];
            [lbNull_trainClass setTextColor:LyNullItemTextColor];
            [lbNull_trainClass setTextAlignment:NSTextAlignmentCenter];
            [lbNull_trainClass setText:@"当前没有课程信息"];
        }
        
        [viewTrainClass addSubview:lbNull_trainClass];
        [tvTrainClass removeFromSuperview];
        [viewTrainClass setFrame:CGRectMake( 0, viewInfo.frame.origin.y+CGRectGetHeight(viewInfo.frame), SCREEN_WIDTH, lbNull_trainClass.frame.origin.y+CGRectGetHeight(lbNull_trainClass.frame)+verticalSpace)];
    }
    else {
        [lbNull_trainClass removeFromSuperview];
        [viewTrainClass addSubview:tvTrainClass];
        [viewTrainClass setFrame:CGRectMake( 0, viewInfo.frame.origin.y+CGRectGetHeight(viewInfo.frame), SCREEN_WIDTH, tvTrainClass.frame.origin.y+CGRectGetHeight(tvTrainClass.frame)+verticalSpace)];
        
        [tvTrainClass reloadData];
    }
    
    [horizontalLine_trainClass setFrame:CGRectMake( 0, CGRectGetHeight(viewTrainClass.frame)-LyHorizontalLineHeight, CGRectGetWidth(viewTrainClass.frame), LyHorizontalLineHeight)];
    
    
    [self removeViewError];
    
    
    if ( [coach timeFlag]) {
        [viewPriceDetail setHidden:NO];
        [self.dateTimePicker setHidden:NO];
        [lbStudentCount setHidden:NO];
        [lbPeriodCount setHidden:NO];
        
        [lbNull_reservation removeFromSuperview];
        lbNull_reservation = nil;
        
        [viewPriceDetail setFrame:CGRectMake( 0, viewTrainClass.frame.origin.y+CGRectGetHeight(viewTrainClass.frame), SCREEN_WIDTH, mcViewPriceDetailHeight)];
        [lbTitle_priceDetail setText:[[NSString alloc] initWithFormat:@"培训价格（%@）", [coach userLicenseTypeByString]]];
        [lbPriceDetail setText:[[NSString alloc] initWithFormat:@"科目二：%.0f元/小时起\n科目三：%.0f元/小时起", price_second, price_third]];
        [horizontalLine_priceDetail setFrame:CGRectMake( 0, mcViewPriceDetailHeight-LyHorizontalLineHeight, CGRectGetWidth(viewPriceDetail.frame), LyHorizontalLineHeight)];
        
        
        [viewReservationInfo setFrame:CGRectMake( 0, viewPriceDetail.frame.origin.y+CGRectGetHeight(viewPriceDetail.frame), viewReservationInfoWidth, viewReservationInfoHeight)];
        
        NSString *strLbStudentCountNum = [[NSString alloc] initWithFormat:@"%d人", [coach stuAllCount]];
        NSString *strLbStudentCountTmp = [[NSString alloc] initWithFormat:@"%@\n累计学员", strLbStudentCountNum];
        NSMutableAttributedString *strLbStudentCount = [[NSMutableAttributedString alloc] initWithString:strLbStudentCountTmp];
        NSRange rangeStudentCountNum = [strLbStudentCountTmp rangeOfString:strLbStudentCountNum];
        [strLbStudentCount addAttribute:NSFontAttributeName value:lbStudentCountNumFont range:rangeStudentCountNum];
        [strLbStudentCount addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:rangeStudentCountNum];
        [lbStudentCount setAttributedText:strLbStudentCount];
        
        NSString *strLbPeriodCountNum = [[NSString alloc] initWithFormat:@"%d时", [coach coaTeachAllPeriod]];
        NSString *strLbPeriodCountTmp = [[NSString alloc] initWithFormat:@"%@\n累计课时", strLbPeriodCountNum];
        NSMutableAttributedString *strLbPeriodCount = [[NSMutableAttributedString alloc] initWithString:strLbPeriodCountTmp];
        NSRange rangePeriodCountNum = [strLbPeriodCountTmp rangeOfString:strLbPeriodCountNum];
        [strLbPeriodCount addAttribute:NSFontAttributeName value:lbStudentCountNumFont range:rangePeriodCountNum];
        [strLbPeriodCount addAttribute:NSForegroundColorAttributeName value:LyGreenColor range:rangePeriodCountNum];
        [lbPeriodCount setAttributedText:strLbPeriodCount];
        
        
        [self.dateTimePicker reloadData];
        
        [svMain setContentSize:CGSizeMake( svMainWidth, viewReservationInfo.frame.origin.y+CGRectGetHeight(viewReservationInfo.frame)+verticalSpace+dcbHeight)];
    }
    else {
        [viewPriceDetail setHidden:YES];
        [self.dateTimePicker setHidden:YES];
        [lbStudentCount setHidden:YES];
        [lbPeriodCount setHidden:YES];
        
        if ( !lbNull_reservation)
        {
            lbNull_reservation = [[UILabel alloc] initWithFrame:CGRectMake( 0, lbTitle_reservation.frame.origin.y+CGRectGetHeight(lbTitle_reservation.frame), SCREEN_WIDTH, LyNullItemHeight)];
            [lbNull_reservation setFont:LyNullItemTitleFont];
            [lbNull_reservation setTextColor:LyNullItemTextColor];
            [lbNull_reservation setText:@"当前教练不支持计时培训"];
            [lbNull_reservation setTextAlignment:NSTextAlignmentCenter];
        }
        [viewReservationInfo addSubview:lbNull_reservation];
        [viewReservationInfo setFrame:CGRectMake(0, viewTrainClass.frame.origin.y+CGRectGetHeight(viewTrainClass.frame), SCREEN_WIDTH, lbNull_reservation.frame.origin.y+CGRectGetHeight(lbNull_reservation.frame))];
        
        [svMain setContentSize:CGSizeMake( svMainWidth, svMainHeight*1.1f)];
    }
}




- (void)showViewError
{
    flagLoadSuccess = NO;
    [controlBar setHidden:YES];
    
    if ( !viewError) {
        viewError = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, svMainWidth, svMainHeight*1.2f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewError addSubview:[LyUtil lbErrorWithMode:0]];
    }
    
    [svMain setContentSize:CGSizeMake( svMainWidth, svMainHeight*1.05f)];
    [svMain addSubview:viewError];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


- (void)removeViewError
{
    flagLoadSuccess = YES;
    [controlBar setHidden:NO];
    [viewError removeFromSuperview];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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



- (void)targetForButton:(UIButton *)button {
    if ( myCoachButtonMode_priceDetail == [button tag]) {
        LyPriceDetailViewController *reservationPriceDetail = [[LyPriceDetailViewController alloc] init];
        [reservationPriceDetail setDelegate:self];
        [self.navigationController pushViewController:reservationPriceDetail animated:YES];
    }
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    if (myCoachBarButtonItemMode_right == barButtonItem.tag) {
        LyAddCoachTableViewController *addCoach = [[LyAddCoachTableViewController alloc] init];
        [addCoach setDelegate:self];
        [self.navigationController pushViewController:addCoach animated:YES];
    }
}


- (void)refreshData:(UIRefreshControl *)refreshControl {
    [self loadData];
}




- (void)loadData {
    
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(loadData) object:nil];
        return;
    }
    
    if ( !indicator_load) {
        indicator_load = [LyIndicator indicatorWithTitle:@""];
    }
    [indicator_load startAnimation];
    
    if (!curDate) {
        curDate = [NSDate dateWithTimeIntervalSinceNow:24*3600];
    }
    
//    NSString *strLicense = [coach userLicenseTypeByString];
//    if (![LyUtil validateString:strLicense]) {
//        strLicense = [[LyCurrentUser curUser] userLicenseTypeByString];
//    }
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:myCoachHttpMethod_load];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:myChoach_url
                                          body:@{
                                                myCoachIdKey:[LyCurrentUser curUser].userCoachId,
                                                classIdKey:([LyCurrentUser curUser].userTrainClassId) ? [LyCurrentUser curUser].userTrainClassId: @(0),
//                                                driveLicenseKey:strLicense,
                                                dateKey:[[[LyUtil dateFormatterForAll] stringFromDate:curDate] substringToIndex:dateStringLength],
                                                userIdKey:[[LyCurrentUser curUser] userId],
                                                sessionIdKey:[LyUtil httpSessionId]
                                                }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}




- (void)loadWithDate {
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(loadWithDate) object:nil];
        return;
    }
    
    [self showIndicator_loadWithDate];
    
    LyHttpRequest *httpReqeust = [LyHttpRequest httpRequestWithMode:myCoachHttpMethod_loadWithDate];
    [httpReqeust setDelegate:self];
    bHttpFlag = [[httpReqeust startHttpRequest:myChoach_url
                                          body:@{
                                                myCoachIdKey:[LyCurrentUser curUser].userCoachId,
                                                classIdKey:([LyCurrentUser curUser].userTrainClassId) ? [LyCurrentUser curUser].userTrainClassId: @(0),
                                                driveLicenseKey:[coach userLicenseTypeByString],
                                                dateKey:[[curDate description] substringToIndex:dateStringLength],
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
    
    if ( !indicator_reservate)
    {
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
                          classIdKey:@"0",
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
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:myCoachHttpMethod_reservate];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:reservate_url
                                  body:dic
                                  type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}



- (void)attente
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(attente) object:nil];
        return;
    }
    
    if ( !indicator_oper)
    {
        indicator_oper = [[LyIndicator alloc] initWithTitle:LyIndicatorTitle_attente];
    }
    [indicator_oper setTitle:LyIndicatorTitle_attente];
    [indicator_oper startAnimation];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:myCoachHttpMethod_attente];
    [httpRequest setDelegate:self];
    bHttpFlag =[[httpRequest startHttpRequest:addAttention_url
                                         body:@{
                                                userIdKey:[[LyCurrentUser curUser] userId],
                                                objectIdKey:[coach userId],
                                                sessionIdKey:[LyUtil httpSessionId],
                                                userTypeKey:userTypeCoachKey
                                                }
                                         type:LyHttpType_asynPost
                                      timeOut:0] boolValue];
    
}



- (void)deattente
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(deattente) object:nil];
        return;
    }
    
    if ( !indicator_oper)
    {
        indicator_oper = [[LyIndicator alloc] initWithTitle:LyIndicatorTitle_deattente];
    }
    [indicator_oper startAnimation];
    
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:myCoachHttpMethod_deattente];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:removeAttention_url
                                          body:@{
                                                 userIdKey:[[LyCurrentUser curUser] userId],
                                                 objectIdKey:[coach userId],
                                                 sessionIdKey:[LyUtil httpSessionId]
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}



//网张通讯失败
- (void)handleHttpFailed {
    if ( [indicator_load isAnimating]) {
        [indicator_load stopAnimation];
        [self showViewError];
        [self.refreshControl endRefreshing];
        [self.navigationController.navigationBar setHidden:NO];
    }
    
    if ( [indicator_reservate isAnimating]) {
        [indicator_reservate stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"预约失败"] show];
    }
    
    if ([indicator_loadWithDate isAnimating]) {
        [self removeIndicator_loadWithDate];
        [self showViewError_reservationInfo];
    }
    
    if ( [indicator_oper isAnimating]) {
        [indicator_oper stopAnimation];
        NSString *str;
        if ( [[indicator_oper title] isEqualToString:LyIndicatorTitle_attente]) {
            str =  @"关注失败";
        } else if ( [[indicator_oper title] isEqualToString:LyIndicatorTitle_deattente]) {
            str = @"取关失败";
        }
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:str] show];
    }
}



//解析数据
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
        [indicator_load stopAnimation];
        [indicator_reservate stopAnimation];
        [indicator_oper stopAnimation];
        [self removeIndicator_loadWithDate];
        [self.refreshControl endRefreshing];
        
        [LyUtil sessionTimeOut:self];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_load stopAnimation];
        [indicator_reservate stopAnimation];
        [indicator_oper stopAnimation];
        [self removeIndicator_loadWithDate];
        [self.refreshControl endRefreshing];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    
    switch ( curHttpMethod) {
        case myCoachHttpMethod_load: {
            switch ( [strCode integerValue]) {
                case 0: {
                    /*
                     {"code":0,"result":{"coach":{"nickname":"汪汪汪","img":null,"teachedage":"10","masterid":"3B212A08-18F6-87EA-78B1-A4D985715677","driverage":"10","allcount":"10","passedcount":"8","teachablecount":"10","teachingcount":"10","pricetwo":"1000","pricethree":"200","evalutioncount":"100","praisecount":"60","timeflag":"1","piccount":"13","jtype":"0"},"class":null,"flag":0,"mastername":"广源驾校","train":null}}
                     */
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
                    NSString *strDriveLicense = [[NSString alloc] initWithFormat:@"%@", [dicCoachInfo objectForKey:driveLicenseKey]];
                    
                    
                    if (![LyUtil validateString:strCoachId]) {
                        [self handleHttpFailed];
                        return;
                    } else {
                        coach = [[LyUserManager sharedInstance] getCoachWithCoachId:strCoachId];
                        if ( !coach || LyUserType_coach != coach.userType) {
                            coach = [LyCoach coachWithId:strCoachId
                                                 coaName:strCoachName];
                            [[LyUserManager sharedInstance] addUser:coach];
                        }
                        [coach setUserName:strCoachName];
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
                        [coach setUserLicenseType:[LyUtil driveLicenseFromString:strDriveLicense]];
                    }
                    
                    if ([LyUtil validateString:strMasterId]) {
                        driveSchool = [[LyUserManager sharedInstance] getDriveSchoolWithDriveSchoolId:strMasterId];
                        if ( !driveSchool) {
                            driveSchool = [LyDriveSchool driveSchoolWithId:strMasterId
                                                                  dschName:strMasterName];
                            
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
                        if ( !currentTrainBase)
                        {
                            currentTrainBase = [LyTrainBase trainBaseWithTbId:strId
                                                                tbName:strName
                                                             tbAddress:strAddress
                                                          tbCoachCount:[strCoachCount integerValue]
                                                        tbStudentCount:[strStudentCount integerValue]];
                            
                            [[LyTrainBaseManager sharedInstance] addTrainBase:currentTrainBase];
                        }
                    }
                    //基地-end
                    
                    //培训课程-begin
                    NSDictionary *dicTrainClass = [dicResult objectForKey:trainClassKey];
                    if ([LyUtil validateDictionary:dicTrainClass]) {
                        NSString *strTcId = [dicTrainClass objectForKey:trainClassIdKey];
                        if ([LyUtil validateString:strTcId]) {
                            
                            NSString *strTcName = [dicTrainClass objectForKey:myDriveSchoolTrainClassNameKey];
                            NSString *strTcMasterId = [dicTrainClass objectForKey:masterIdKey];
                            NSString *strLicenseType = [[NSString alloc] initWithFormat:@"%@", [dicTrainClass objectForKey:driveLicenseKey]];
                            NSString *strCarName = [dicTrainClass objectForKey:carNameKey];
                            NSString *strClassTime = [dicTrainClass objectForKey:classTimeKey];
                            NSString *strOfficialPrice = [[NSString alloc] initWithFormat:@"%@", [dicTrainClass objectForKey:officialPriceKey]];
                            NSString *strWhole517Price = [[NSString alloc] initWithFormat:@"%@", [dicTrainClass objectForKey:whole517PriceKey]];
                            NSString *strPrepay517Price = [[NSString alloc] initWithFormat:@"%@", [dicTrainClass objectForKey:prepay517priceKey]];
                            NSString *strPrepay517Deposit = [[NSString alloc] initWithFormat:@"%@", [dicTrainClass objectForKey:prepay517depositKey]];
                            
                            
                            currentTrainClass = [[LyTrainClassManager sharedInstance] getTrainClassWithTrainClassId:strTcId];
                            if ( !currentTrainClass) {
                                currentTrainClass  = [LyTrainClass trainClassWithTrainClassId:strTcId
                                                                                       tcName:strTcName
                                                                                   tcMasterId:strTcMasterId
                                                                                  tcTrainTime:strClassTime
                                                                                    tcCarName:strCarName
                                                                                       tcMode:0
                                                                                tcLicenseType:[strLicenseType integerValue]
                                                                              tcOfficialPrice:[strOfficialPrice floatValue]
                                                                              tc517WholePrice:[strWhole517Price floatValue]
                                                                             tc517PrepayPrice:[strPrepay517Price floatValue]
                                                                           tc517PrePayDeposit:[strPrepay517Deposit floatValue]];
                                [[LyTrainClassManager sharedInstance] addTrainClass:currentTrainClass];
                            }
                        }
                    }
                    //培训课程-end
                    

                    //将所的时间段都先置为不可用
                    [self disableDicTimeDisableAllItem];
                    
                    
                    //解析日期信息
//                    NSString *strDate = [dicResult objectForKey:dateKey];
//                    strDate = [LyUtil fixDateTimeString:strDate isExplicit:YES];
//                    
//                    curDate = [[LyUtil dateFormatterForAll] dateFromString:strDate];
                    curDateStrYMD = [[[LyUtil dateFormatterForAll] stringFromDate:curDate] substringToIndex:dateStringLength];
                    curDateStrMD = [curDateStrYMD substringWithRange:NSMakeRange( 5, 5)];
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
                                                                                 pdMasterId:coach.userId
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
        case myCoachHttpMethod_loadWithDate: {
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
                    curDateStrYMD = [[[LyUtil dateFormatterForAll] stringFromDate:curDate] substringToIndex:dateStringLength];
                    curDateStrMD = [curDateStrYMD substringWithRange:NSMakeRange( 5, 5)];
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
                        for (NSDictionary *dicItem in arrReser) {
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
                    
                    [self.dateTimePicker reloadData];
                    
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
        case myCoachHttpMethod_reservate:{
            switch ( [strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if ( !dicResult || [dicResult isKindOfClass:[NSNull class]] || ![dicResult isKindOfClass:[NSDictionary class]] || ![dicResult count])
                    {
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
        case myCoachHttpMethod_attente: {
            switch ( [strCode integerValue]) {
                case 0: {
                    [controlBar setAttentionStatus:YES];
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"关注成功"] show];
                    break;
                }
                case 1: {
                    [self handleHttpFailed];
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
        case myCoachHttpMethod_deattente: {
            curHttpMethod = 0;
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
    if ( bHttpFlag) {
        bHttpFlag = NO;
        curHttpMethod = ahttpRequest.mode;
        [self analysisHttpResult:result];
    }
    
    curHttpMethod = 0;
}



#pragma mark -LyOrderInfoViewControllerdelegate
- (LyOrder *)obtainOrderByOrderInfoViewController:(LyOrderInfoViewController *)aOrderInfoVC
{
    return order;
}








#pragma mark -LyDateTimePickerDelegate
- (void)dateTimePicker:(LyDateTimePicker *)aDateTimePicker didSelectDateItemAtIndex:(NSInteger)index andDate:(NSDate *)date
{
    if (![LyCurrentUser curUser].isLogined) {
        [LyUtil showLoginVc:self];
        return;
    }
    
    curDate = date;
    curDateStrYMD = [[curDate description] substringToIndex:dateStringLength];
    curDateStrMD = [[curDate description] substringWithRange:NSMakeRange( 5, 5)];
 
    [self loadWithDate];
}

- (void)dateTimePicker:(LyDateTimePicker *)aDateTimePicker didSelectTimeItemAtIndex:(NSInteger)index andDate:(NSDate *)date andWeekday:(LyWeekday)weekday {
    
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



//#pragma mark -LyReservationPriceDetailViewControllerDelegate
//- (NSString *)obtainTeacherIdByReservationPriceDetailViewController:(LyReservationPriceDetailViController *)aReservationPriceDetail
- (NSString *)obtainTeacherIdByPriceDetailVC:(LyPriceDetailViewController *)aPriceDetailVC {
    return [coach userId];
}



#pragma mark -LyAddCoachTableViewControllerDelegate
- (LyAddTeacherMode)obtainModeByAddCoachTableViewController:(LyAddCoachTableViewController *)aAddCoach
{
    return LyAddTeacherMode_replace;
}

- (void)addCoachFinishedByAddCoachTableViewController:(LyAddCoachTableViewController *)aAddCoach andCoach:(LyCoach *)aCoach
{
    [aAddCoach.navigationController popViewControllerAnimated:YES];
    
    [[LyCurrentUser curUser] setUserCoachId:aCoach.userId];
    [[LyCurrentUser curUser] setUserCoachName:aCoach.userName];
    [[LyUserManager sharedInstance] addUser:aCoach];
    
    [self loadData];
}




#pragma mark -LyDetailControlBarDelegate
- (void)onClickedButtonAttente {
    if ( [controlBar attentionStatus]) {
        UIAlertController *action = [UIAlertController alertControllerWithTitle:[[NSString alloc] initWithFormat:@"你确定要取消「%@」吗？", coach.userName]
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





#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( myCoachTableViewMode_trainClass == [tableView tag])
    {
        return tcHeight;
    }
    
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    curIdx = indexPath;
}


#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( myCoachTableViewMode_trainClass == [tableView tag])
    {
        return ( currentTrainClass) ? 1 : 0;
    }
    
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( myCoachTableViewMode_trainClass == [tableView tag])
    {
        LyTrainClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyMyCoachTrainClassTableViewCellReuseIdentifier forIndexPath:indexPath];
        
        if ( !cell)
        {
            cell = [[LyTrainClassTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyMyCoachTrainClassTableViewCellReuseIdentifier];
        }
        
        [cell setTrainClass:currentTrainClass];
        [cell setMode:trainClassTableViewCellMode_mySchool];
        
        return cell;
    }
        
    return nil;
}




#pragma mark -UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.ly_offsetY < 0)
    {
        CGFloat newHeight = mcViewInfoHeight - scrollView.ly_offsetY;
        CGFloat newWidth = SCREEN_WIDTH * newHeight / mcViewInfoHeight;
        
        CGFloat newX = (SCREEN_WIDTH - newWidth) / 2.0;
        CGFloat newY = scrollView.ly_offsetY;
        
        ivBack.frame = CGRectMake(newX, newY, newWidth, newHeight);
    }
    else
    {
        ivBack.frame = CGRectMake(0, 0, SCREEN_WIDTH, mcViewInfoHeight);
    }
    
    if ( [svMain contentOffset].y > mcViewInfoHeight-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT)
    {
        self.title = @"我的教练";
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else
    {
        self.title = nil;
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
