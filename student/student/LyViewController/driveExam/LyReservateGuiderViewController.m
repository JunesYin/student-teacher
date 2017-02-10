//
//  LyReservateGuiderViewController.m
//  student
//
//  Created by Junes on 16/9/13.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyReservateGuiderViewController.h"
#import "LyDateTimePicker.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyPriceDetailManager.h"
#import "LyOrderManager.h"
#import "LyUserManager.h"
#import "LyCurrentUser.h"

#import "LyUtil.h"

#import "LyPriceDetailViewController.h"
#import "LyOrderInfoViewController.h"


CGFloat const rgViewPriceDetailHeight = 80.0f;
CGFloat const rgLbPriceDetailHeight = 50.0f;
#define lbPriceDetailFont               LyFont(13)



enum {
    reservateGuiderButtonTag_priceDetail = 0,
}LyReservateGuiderButtonTag;


typedef NS_ENUM(NSInteger, LyReservateGuiderHttpMethod) {
    reservateGuiderHttpMethod_load = 100,
    reservateGuiderHttpMethod_loadWithDate,
    reservateGuiderHttpMethod_reservate
};


@interface LyReservateGuiderViewController () <UIScrollViewDelegate, LyPriceDetailViewControllerDelegate, LyHttpRequestDelegate, LyOrderInfoViewControllerdelegate, LyDateTimePickerDelegate, LyDateTimePickerDataSource>
{
    UIScrollView                *svMain;
    
    UIView                      *viewError;
    
    UIView                      *viewPriceDetail;
    UILabel                     *lbTitle_priceDetail;
    UIButton                    *btnFunc_priceDetail;
    UILabel                     *lbPriceDetail;
    
    UIView                      *viewReservationInfo;
    UIView                      *viewError_reservationInfo;
    
    NSDictionary                *dicPriceDetail;
    
    
    LyGuider                    *guider;
    float                       price_second;
    float                       price_third;
    
    NSDate                      *curDate;
    NSString                    *curDateStrYMD;
    NSString                    *curDateStrMD;
    NSInteger                   curTime;
//    NSString                    *curWeekday;
    LyWeekday                   curWeekday;
    LySubjectModeSupportMode    curMode;
    LySubjectModeprac          curSubject;
    float                       curPrice;

    
    NSMutableDictionary         *dicTimeDisable;
    NSMutableDictionary         *dicDateTimeInfo;
    
    
    LyOrder                     *curOrder;
    
    LyIndicator                 *indicator;
    UIActivityIndicatorView     *indicator_loadWithDate;
    LyIndicator                 *indicator_reservate;
    BOOL                        bHttpFlag;
    LyReservateGuiderHttpMethod curHttpMethod;
}


@property (strong, nonatomic)       UIRefreshControl        *refreshControl;
@property (strong, nonatomic)       LyDateTimePicker        *dateTimePicker;

@end

@implementation LyReservateGuiderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    
    _guiderId = [_delegate obtainGuiderIdByReservateGuiderVC:self];
    
    if (!_guiderId) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    guider = [[LyUserManager sharedInstance] getGuiderWithGuiderId:_guiderId];
    if (!guider) {
        NSString *strGuiderName;
        if ([_guiderId isEqualToString:[LyCurrentUser curUser].userGuiderId]) {
            strGuiderName = [LyCurrentUser curUser].userGuiderName;
        } else {
            strGuiderName = [LyUtil getUserNameWithUserId:_guiderId];
        }
        guider = [LyGuider userWithId:_guiderId
                                      userName:strGuiderName];
        
        [[LyUserManager sharedInstance] addUser:guider];
    }
    
    if (!dicDateTimeInfo || dicDateTimeInfo.count < 1) {
        [self load];
    }
}

- (void)initSubviews {
    self.title = @"计时预约";
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT)];
    [svMain setBackgroundColor:LyWhiteLightgrayColor];
    [svMain setDelegate:self];
    [self.view addSubview:svMain];
    
    
    [svMain addSubview:self.refreshControl];
    
    viewPriceDetail = [[UIView alloc] initWithFrame:CGRectMake( 0, verticalSpace, SCREEN_WIDTH, rgViewPriceDetailHeight)];
    [viewPriceDetail setBackgroundColor:[UIColor whiteColor]];
    lbTitle_priceDetail = [LyUtil lbItemTitleWithText:@"培训价格"];
    btnFunc_priceDetail = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH-LyBtnMoreWidth, 0, LyBtnMoreWidth, LyBtnMoreHeight)];
    [btnFunc_priceDetail setTag:reservateGuiderButtonTag_priceDetail];
    [[btnFunc_priceDetail titleLabel] setFont:LyFont(12)];
    [btnFunc_priceDetail setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnFunc_priceDetail setTitle:@"详情" forState:UIControlStateNormal];
    [btnFunc_priceDetail addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    lbPriceDetail = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, lbTitle_priceDetail.frame.origin.y+CGRectGetHeight(lbTitle_priceDetail.frame), SCREEN_WIDTH-horizontalSpace*2, rgLbPriceDetailHeight)];
    [lbPriceDetail setFont:lbPriceDetailFont];
    [lbPriceDetail setTextColor:LyBlackColor];
    [lbPriceDetail setNumberOfLines:0];
    [lbPriceDetail setTextAlignment:NSTextAlignmentLeft];
    
    [viewPriceDetail addSubview:lbTitle_priceDetail];
    [viewPriceDetail addSubview:btnFunc_priceDetail];
    [viewPriceDetail addSubview:lbPriceDetail];
    
    
    viewReservationInfo = [[UIView alloc] initWithFrame:CGRectMake( 0, viewPriceDetail.frame.origin.y+CGRectGetHeight(viewPriceDetail.frame)+verticalSpace, dateTimePickerDefaultWidth, dateTimePickerDefaultHeight+30.0f)];
    [viewReservationInfo setBackgroundColor:[UIColor whiteColor]];
    UILabel *lbTitle_reservation = [LyUtil lbItemTitleWithText:@"预约时间"];
    [viewReservationInfo addSubview:lbTitle_reservation];
    [viewReservationInfo addSubview:self.dateTimePicker];

    
    [svMain addSubview:viewPriceDetail];
    [svMain addSubview:viewReservationInfo];
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, viewReservationInfo.frame.origin.y+CGRectGetHeight(viewReservationInfo.frame)+50.0f)];
    
    curDate = [NSDate dateWithTimeIntervalSinceNow:24*3600];
    dicDateTimeInfo = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    dicTimeDisable = [NSMutableDictionary dictionary];
    dicDateTimeInfo = [NSMutableDictionary dictionary];
}


- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [LyUtil refreshControlWithTitle:nil
                                                   target:self
                                                   action:@selector(refresh:)];
    }
    
    return _refreshControl;
}


- (LyDateTimePicker *)dateTimePicker {
    if (!_dateTimePicker) {
        _dateTimePicker = [[LyDateTimePicker alloc] initWithFrame:CGRectMake( 0, 30.0f, dateTimePickerDefaultWidth, dateTimePickerDefaultHeight)];
        [_dateTimePicker setDelegate:self];
        [_dateTimePicker setDataSource:self];
    }
    
    return _dateTimePicker;
}


- (void)reloadData {
    [self removeViewError];
    
    [lbTitle_priceDetail setText:[[NSString alloc] initWithFormat:@"培训价格（%@）", [guider userLicenseTypeByString]]];
    [lbPriceDetail setText:[[NSString alloc] initWithFormat:@"科目二：%.0f元/小时起\n科目三：%.0f元/小时起", price_second, price_third]];
    
    [self.dateTimePicker reloadData];
    
}



- (void)showViewError {
    
    if ( !viewError) {
        viewError = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.2f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewError addSubview:[LyUtil lbErrorWithMode:0]];
    }
    
    [svMain addSubview:viewError];
    [svMain setContentSize:CGSizeMake( SCREEN_WIDTH, SCREEN_HEIGHT*1.05f)];
}


- (void)removeViewError {
    [viewError removeFromSuperview];
    viewError = nil;
}


- (void)showIndicator_loadWithDate {
    if (!indicator_loadWithDate) {
        indicator_loadWithDate = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [indicator_loadWithDate setColor:LyBlackColor];
        [indicator_loadWithDate setFrame:CGRectMake( SCREEN_WIDTH/2.0f-30/2.0f, 125, 30, 30)];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)refresh:(UIRefreshControl *)refreshControl {
    [self load];
}


- (void)targetForButton:(UIButton *)button {
    if ( reservateGuiderButtonTag_priceDetail == button.tag) {
        LyPriceDetailViewController *priceDetail = [[LyPriceDetailViewController alloc] init];
        [priceDetail setDelegate:self];
        [self.navigationController pushViewController:priceDetail animated:YES];
    }
}



- (void)load {
    if ( !indicator) {
        indicator = [LyIndicator indicatorWithTitle:nil];
    }
    [indicator startAnimation];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:reservateGuiderHttpMethod_load];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:reservateGuider_url
                                          body:@{
                                                 guiderIdKey:_guiderId,
                                                 driveLicenseKey:[guider userLicenseTypeByString],
                                                 dateKey:[LyUtil stringOnlyYMDFromDate:curDate],
                                                 sessionIdKey:[LyUtil httpSessionId]
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}



- (void)loadWithDate
{
    [self showIndicator_loadWithDate];
    
    LyHttpRequest *httpReqeust = [LyHttpRequest httpRequestWithMode:reservateGuiderHttpMethod_loadWithDate];
    [httpReqeust setDelegate:self];
    bHttpFlag = [[httpReqeust startHttpRequest:reservateGuider_url
                                          body:@{
                                                 guiderIdKey:_guiderId,
                                                 driveLicenseKey:[guider userLicenseTypeByString],
                                                 dateKey:[LyUtil stringOnlyYMDFromDate:curDate],
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
                                                                userId:_guiderId];
    
    NSString *message = [[NSString alloc] initWithFormat:@"%@/%@/%@\n%@/%@/%@\n价格：%.0f元", guider.userName, [guider userLicenseTypeByString], [LyUtil subjectModePracStringForm:curSubject], curDateStrMD, [LyUtil weekdayStringFrom:curWeekday], [[NSString alloc] initWithFormat:@"%ld:00-%ld:00", curTime/2, curTime/2+1], curPrice];
    
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


- (void)reservate {
    if ( !indicator_reservate) {
        indicator_reservate = [LyIndicator indicatorWithTitle:@"正在预约..."];
    }
    
    [indicator_reservate startAnimation];
    
    
//    LyDriveSchool *driveSchool = [[LyUserManager sharedInstance] getDriveSchoolWithDriveSchoolId:[coach coaMasterId]];
    
    NSString *strDescription = [[NSString alloc] initWithFormat:@"%@/%@ %@/%@ %ld:00-%ld:00", [guider userLicenseTypeByString], [LyUtil subjectModePracStringForm:curSubject], curDateStrYMD, [LyUtil weekdayStringFrom:curWeekday], curTime/2, curTime/2+1];
    
    NSDictionary *dic = @{
                          masterIdKey:[[LyCurrentUser curUser] userId],
                          phoneKey:[[LyCurrentUser curUser] userPhoneNum],
                          masNameKey:[[LyCurrentUser curUser] userName],
                          objectIdKey:_guiderId,
                          classIdKey:@"0",
                          orderModeKey:@"4",
                          studentCountKey:@"1",
                          applyModeKey:@"0",
                          couponModeKey:@"0",
                          orderNameKey:guider.userName,
                          orderDetailKey:strDescription,
                          remarkKey:@"空",
//                          addressKey:([LyCurrentUser curUser].location.province && [LyCurrentUser curUser].location.city) ? [[NSString alloc] initWithFormat:@"%@%@", [LyCurrentUser curUser].location.province, [LyCurrentUser curUser].location.city] : @"无",
                          addressKey:@"无",
                          trainBaseNameKey:@"无",
                          stampKey:curDateStrYMD,
                          numKey:[[NSString alloc] initWithFormat:@"%d", (int)curTime],
                          driveLicenseKey:[guider userLicenseTypeByString],
                          subjectModeKey:@(curSubject),
                          durationKey:strDescription,
                          orderPriceKey:[[NSString alloc] initWithFormat:@"%.0f", curPrice],
                          userTypeKey:userTypeGuiderKey,
                          sessionIdKey:[LyUtil httpSessionId]
                          };
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:reservateGuiderHttpMethod_reservate];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:reservate_url
                                   body:dic
                                   type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}



- (void)handleHttpFailed {
    if ([indicator isAnimating]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        [self showViewError];
    }
    
    if ([indicator_loadWithDate isAnimating]) {
        [self removeIndicator_loadWithDate];
        [self showViewError_reservationInfo];
    }
    
    if ([indicator_reservate isAnimating]) {
        [indicator_reservate stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"预约失败"] show];
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
        [indicator stopAnimation];
        [indicator_reservate stopAnimation];
        [self removeIndicator_loadWithDate];
        [self.refreshControl endRefreshing];
        
        [LyUtil sessionTimeOut:self];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        [indicator_reservate stopAnimation];
        [self removeIndicator_loadWithDate];
        [self.refreshControl endRefreshing];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    
    switch (curHttpMethod) {
        case reservateGuiderHttpMethod_load: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [indicator stopAnimation];
                        [self.refreshControl endRefreshing];
                        [self showViewError];
                        return;
                    }
                    
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
                                                                                 pdMasterId:_guiderId
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
                        for ( int i = 0; i < [arrReser count]; ++i)
                        {
                            NSDictionary *dicItem = [arrReser objectAtIndex:i];
                            if (![LyUtil validateDictionary:dicItem]){
                                continue;
                            }
                    
                            NSString *strMasterId = [dicItem objectForKey:masterIdKey];
                            NSString *strTime = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:numKey]];
                            NSString *strMasterName = [dicItem objectForKey:nickNameKey];
                            
                            NSInteger iTime = [strTime integerValue] / 2;
                            
                            LyDateTimeInfo *dti = [LyDateTimeInfo dateTimeInfoWithMode:iTime
                                                                                  date:curDate
                                                                                 state:LyDateTimeInfoState_used
                                                                              objectId:_guiderId
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
                                                                  objectId:_guiderId
                                                                  masterId:nil
                                                                masterName:nil];
                            } else {
                                dti = [LyDateTimeInfo dateTimeInfoWithMode:i
                                                                      date:curDate
                                                                     state:LyDateTimeInfoState_useable
                                                                  objectId:_guiderId
                                                                  masterId:nil
                                                                masterName:nil];
                            }
                            
                            [dicDateTimeInfo setObject:dti forKey:@(i)];
                        }
                    }
                    //完善今日所有时段的情况-end
                    
                    
                    [indicator stopAnimation];
                    [self.refreshControl endRefreshing];
                    [self reloadData];
                    
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case reservateGuiderHttpMethod_loadWithDate: {
            switch ([strCode integerValue]) {
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
                    
                    NSArray *arr = [[LyPriceDetailManager sharedInstance] priceDetailWithUserId:_guiderId];
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
                                                                              objectId:_guiderId
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
                                                                  objectId:_guiderId
                                                                  masterId:nil
                                                                masterName:nil];
                            } else {
                                dti = [LyDateTimeInfo dateTimeInfoWithMode:i
                                                                      date:curDate
                                                                     state:LyDateTimeInfoState_useable
                                                                  objectId:_guiderId
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
        case reservateGuiderHttpMethod_reservate: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]){
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
                    
                    curOrder = [LyOrder orderWithOrderId:strOrderId
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
                    
                    [curOrder setOrderDuration:strDuration];
                    
                    [[LyOrderManager sharedInstance] addOrder:curOrder];
                    
                    
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
        default: {
            [self handleHttpFailed];
            break;
        }
    }
}


#pragma mark -LyHttpReqeustDelegate
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest {
    if (bHttpFlag) {
        bHttpFlag = 0;
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




#pragma mark -LyOrderInfoViewControllerdelegate
- (LyOrder *)obtainOrderByOrderInfoViewController:(LyOrderInfoViewController *)aOrderInfoVC
{
    return curOrder;
}



#pragma mark -LyDateTimePickerDelegate
- (void)dateTimePicker:(LyDateTimePicker *)aDateTimePicker didSelectDateItemAtIndex:(NSInteger)index andDate:(NSDate *)date
{
    curDate = date;
    curDateStrYMD = [[curDate description] substringToIndex:dateStringLength];
    curDateStrMD = [[curDate description] substringWithRange:NSMakeRange( 5, 5)];
    
    
    [self loadWithDate];
}

- (void)dateTimePicker:(LyDateTimePicker *)aDateTimePicker didSelectTimeItemAtIndex:(NSInteger)index andDate:(NSDate *)date andWeekday:(LyWeekday)weekday
{
    curDate = date;
    curWeekday = weekday;
    curTime = index*2;
    
    
    curDateStrYMD = [[curDate description] substringToIndex:dateStringLength];
    curDateStrMD = [[curDate description] substringWithRange:NSMakeRange( 5, 5)];
    
    //判断支持的科目
    curMode = [[LyPriceDetailManager sharedInstance] getSubjectSupportModeWith:curWeekday andTimeStart:curTime userId:guider.userId];
    
    UIAlertController *action = [UIAlertController alertControllerWithTitle:@"请选择预约科目"
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
- (NSDate *)dateInDateTimePicker:(LyDateTimePicker *)aDateTimePicker {
    return curDate;
}


- (LyDateTimeInfo *)dateTimePicker:(LyDateTimePicker *)aDateTimePicker forItemIndex:(NSInteger)index {
    return [dicDateTimeInfo objectForKey:@(index)];
}



#pragma mark -LyPriceDetailViewControllerDelegate
- (NSString *)obtainTeacherIdByPriceDetailVC:(LyPriceDetailViewController *)aPriceDetailVC {
    return _guiderId;
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
