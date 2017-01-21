//
//  LyTimeTeachManageViewController.m
//  teacher
//
//  Created by Junes on 2016/9/22.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyTimeTeachManageViewController.h"
#import "LyDateTimePicker.h"

#import "LyCurrentUser.h"
#import "LyPriceDetailManager.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyUtil.h"

#import "LyPriceDetailViewController.h"
#import "LyReservationDetailTableViewController.h"




CGFloat const ttmViewPriceDetailHeight = 80.0f;
#define ttmLbPriceDetailWidth              (SCREEN_WIDTH-horizontalSpace*2)
CGFloat const ttmLbPriceDetailHeight = 50.0f;
#define lbPriceDetailFont               LyFont(13)


enum {
    timeTeachManageButtonTag_priceDetail = 10,
}LyTimeTeachManageButtonTag;


typedef NS_ENUM(NSInteger, LyTimeTeachManageHttpMethod) {
    timeTeachManageHttpMethod_load = 100,
    timeTeachManageHttpMethod_loadWithDate,
};




@interface LyTimeTeachManageViewController () <LyHttpRequestDelegate, LyDateTimePickerDelegate, LyDateTimePickerDataSource, LyReservationDetailTableViewControllerDelegate>
{
    UIScrollView            *svMain;
    UIView                  *viewError;
    
    UIView                  *viewPriceDetail;
    UIButton                *btnFunc_priceDetail;
    UILabel                 *lbPriceDetail;
    
    UIView                  *viewReservationInfo;
    UILabel                 *lbTitle_reservation;
    UIView                  *viewError_info;
    
    
    NSDictionary            *dicPriceDetail;
    
    float                   price_second;
    float                   price_third;
    
    NSString                *curDateStrYMD;
    NSString                *curDateStrMD;
    NSDate                  *curDate;
//    NSInteger               curTime;
    LyWeekday               curWeekday;
    BOOL                    flagAutoSelect;
    
    NSMutableDictionary     *dicTimeDisable;
    NSMutableDictionary     *dicDateTimeInfo;
    
    NSInteger               curIdx;
    LyDateTimeInfo          *curDateTimeInfo;
    
    UIActivityIndicatorView *indicator_reser;
    LyIndicator             *indicator;
    BOOL                    bHttpFlag;
    LyTimeTeachManageHttpMethod curHttpMethod;
}

@property (strong, nonatomic)   UIRefreshControl        *refreshControl;
@property (strong, nonatomic)   LyDateTimePicker        *dateTimePicker;

@end

@implementation LyTimeTeachManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!dicDateTimeInfo || dicDateTimeInfo.count < 1) {
        [self load];
    }
}

- (void)initAndLayoutSubviews {
    self.title = @"计时预约";
    self.view.backgroundColor = LyWhiteLightgrayColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT)];
    [self.view addSubview:svMain];
    
    
    //提示
    UILabel *lbRemind = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LyViewItemHeight)];
    [lbRemind setBackgroundColor:LyWhiteLightgrayColor];
    [lbRemind setTextColor:[UIColor grayColor]];
    [lbRemind setFont:LyFont(14)];
    [lbRemind setTextAlignment:NSTextAlignmentCenter];
    [lbRemind setText:@"你可以通过“下拉刷新”获取最新的学员预约信息"];
    [svMain addSubview:lbRemind];
    
    
    //价格详情
    viewPriceDetail = [[UIView alloc] initWithFrame:CGRectMake(0, lbRemind.ly_y+CGRectGetHeight(lbRemind.frame)+verticalSpace, SCREEN_WIDTH, ttmViewPriceDetailHeight)];
    [viewPriceDetail setBackgroundColor:[UIColor whiteColor]];
    //价格详情-标题
    UILabel *lbTitle_priceDetail = [LyUtil lbItemTitleWithText:@"培训价格"];
    [lbTitle_priceDetail setBackgroundColor:[UIColor whiteColor]];
    //价格详情-按钮
    btnFunc_priceDetail = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH-LyBtnMoreWidth, 0, LyBtnMoreWidth, LyBtnMoreHeight)];
    [btnFunc_priceDetail setTag:timeTeachManageButtonTag_priceDetail];
    [btnFunc_priceDetail.titleLabel setFont:LyFont(14)];
    [btnFunc_priceDetail setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnFunc_priceDetail setTitle:@"详情" forState:UIControlStateNormal];
    [btnFunc_priceDetail addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    //价格详情-内容
    lbPriceDetail = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, lbTitle_priceDetail.ly_y+CGRectGetHeight(lbTitle_priceDetail.frame), ttmLbPriceDetailWidth, ttmLbPriceDetailHeight)];
    [lbPriceDetail setFont:LyFont(14)];
    [lbPriceDetail setTextColor:[UIColor blackColor]];
    [lbPriceDetail setNumberOfLines:0];
    [lbPriceDetail setTextAlignment:NSTextAlignmentLeft];
    
    [viewPriceDetail addSubview:lbTitle_priceDetail];
    [viewPriceDetail addSubview:btnFunc_priceDetail];
    [viewPriceDetail addSubview:lbPriceDetail];
    
    
    
    //当前预约信息
    viewReservationInfo = [[UIView alloc] initWithFrame:CGRectMake(0, viewPriceDetail.ly_y+CGRectGetHeight(viewPriceDetail.frame)+verticalSpace, SCREEN_WIDTH, dateTimePickerDefaultHeight+30+verticalSpace)];
    [viewReservationInfo setBackgroundColor:[UIColor whiteColor]];
    //当前预约信息-标题
    UILabel *lbTitle_reservationInfo = [LyUtil lbItemTitleWithText:@"学员预约信息"];
    [lbTitle_reservationInfo setBackgroundColor:[UIColor whiteColor]];
    //当前预约信息内容
    //self.dateTimePicker
    
    [viewReservationInfo addSubview:lbTitle_reservationInfo];
    [viewReservationInfo addSubview:self.dateTimePicker];
    
    
    [svMain addSubview:self.refreshControl];
    [svMain addSubview:viewPriceDetail];
    [svMain addSubview:viewReservationInfo];
    
    CGFloat fCZHeight = viewReservationInfo.ly_y + CGRectGetHeight(viewReservationInfo.frame) + 50.0f;
    if (fCZHeight <= CGRectGetHeight(svMain.frame)) {
        fCZHeight = CGRectGetHeight(svMain.frame) * 1.05f;
    }
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, fCZHeight)];
    
    
    dicTimeDisable = [NSMutableDictionary dictionary];
    dicDateTimeInfo = [NSMutableDictionary dictionary];
    
}


- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [LyUtil refreshControlWithTitle:nil target:self action:@selector(refresh:)];
    }
    
    return _refreshControl;
}


- (LyDateTimePicker *)dateTimePicker {
    if (!_dateTimePicker) {
        _dateTimePicker = [[LyDateTimePicker alloc] initWithFrame:CGRectMake( 0, 30+verticalSpace, dateTimePickerDefaultWidth, dateTimePickerDefaultHeight)];
        [_dateTimePicker setDelegate:self];
        [_dateTimePicker setDataSource:self];
    }
    
    return _dateTimePicker;
}

- (void)reloadData {
    [self removeViewError];
    [self removeViewError_info];
    
    [lbPriceDetail setText:[[NSString alloc] initWithFormat:@"科目二：%.0f元/小时起\n科目三：%.0f元/小时起", price_second, price_third]];

    [self.dateTimePicker reloadData];
//    if (!flagAutoSelect) {
//        flagAutoSelect = YES;
//        [self.dateTimePicker setSelectIndex:0];
//    }

    CGFloat fCZHeight = viewReservationInfo.ly_y + CGRectGetHeight(viewReservationInfo.frame) + 50.0f;
    if (fCZHeight <= CGRectGetHeight(svMain.frame)) {
        fCZHeight = CGRectGetHeight(svMain.frame) * 1.05f;
    }
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, fCZHeight)];
}


- (void)showViewError {
    if (!viewError) {
        viewError = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.2f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewError addSubview:[LyUtil lbErrorWithMode:0]];
    }
    
    [svMain addSubview:viewError];
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.05f)];
    [svMain setContentOffset:CGPointMake(0, 0)];
}

- (void)removeViewError {
    [viewError removeFromSuperview];
    viewError = nil;
}


- (void)showViewError_info {
    if (!viewError_info) {
        viewError_info = [[UIView alloc] initWithFrame:self.dateTimePicker.frame];
        [viewError_info setBackgroundColor:LyWhiteLightgrayColor];
        
        UILabel *lbError = [LyUtil lbErrorWithMode:1];
        [lbError setUserInteractionEnabled:YES];
        
        [viewError_info addSubview:lbError];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForTapGestuerFromViewError_info)];
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        [viewError_info addGestureRecognizer:tap];
    }
    
    [viewReservationInfo addSubview:viewError_info];
}

- (void)removeViewError_info {
    [viewError_info removeFromSuperview];
    viewError_info = nil;
}


- (void)showIndicator_reser {
    if ( !indicator_reser) {
        indicator_reser = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [indicator_reser setColor:LyBlackColor];
        [indicator_reser setFrame:CGRectMake( SCREEN_WIDTH/2.0f-30/2.0f, 125, 30, 30)];
    }
    [viewReservationInfo addSubview:indicator_reser];
    [indicator_reser startAnimating];
}

- (void)removeIndicator_reser {
    [indicator_reser stopAnimating];
    [indicator_reser removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (timeTeachManageButtonTag_priceDetail == button.tag) {
        LyPriceDetailViewController *priceDetail = [[LyPriceDetailViewController alloc] init];
        [self.navigationController pushViewController:priceDetail animated:YES];
    }
}

- (void)targetForTapGestuerFromViewError_info {
    [self loadWithDate];
}

- (void)refresh:(UIRefreshControl *)rc {
    [self load];
}


- (void)load {
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:nil];
    }
    [indicator startAnimation];
    
    if (!curDate) {
        curDate = [NSDate date];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"1" forKey:indexKey];
    [dic setObject:[LyUtil driveLicenseStringFrom:[LyCurrentUser curUser].userLicense] forKey:driveLicenseKey];
    [dic setObject:[LyUtil stringOnlyDateFromDate:curDate] forKey:dateKey];
    [dic setObject:[LyCurrentUser curUser].userId forKey:userIdKey];
    [dic setObject:[[LyCurrentUser curUser] userTypeByString] forKey:userTypeKey];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    
    NSString *valueForMasterKey = @"";
    
    if (LyUserType_coach == [LyCurrentUser curUser].userType) {
        
        if (LyCoachMode_normal == [LyCurrentUser curUser].coachMode) {
            valueForMasterKey = masterIdKey;
            
        } else if (LyCoachMode_staff == [LyCurrentUser curUser].coachMode) {
            valueForMasterKey = bossKey;
        }
    }
    
    [dic setObject:valueForMasterKey forKey:masterKey];
    
    LyHttpRequest *hr= [LyHttpRequest httpRequestWithMode:timeTeachManageHttpMethod_load];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:timeTeachManage_url
                                 body:dic
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)loadWithDate {
    [self showIndicator_reser];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"0" forKey:indexKey];
    [dic setObject:[LyUtil driveLicenseStringFrom:[LyCurrentUser curUser].userLicense] forKey:driveLicenseKey];
    [dic setObject:[LyUtil stringOnlyDateFromDate:curDate] forKey:dateKey];
    [dic setObject:[LyCurrentUser curUser].userId forKey:userIdKey];
    [dic setObject:[[LyCurrentUser curUser] userTypeByString] forKey:userTypeKey];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    
    NSString *valueForMasterKey = @"";
    if (LyUserType_coach == [LyCurrentUser curUser].userType) {
        
        if (LyCoachMode_normal == [LyCurrentUser curUser].coachMode) {
            valueForMasterKey = masterIdKey;
            
        } else if (LyCoachMode_staff == [LyCurrentUser curUser].coachMode) {
            valueForMasterKey = bossKey;
        }
    }
    [dic setObject:valueForMasterKey forKey:masterKey];
    
    
    LyHttpRequest *hr= [LyHttpRequest httpRequestWithMode:timeTeachManageHttpMethod_loadWithDate];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:timeTeachManage_url
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
    
    if (indicator_reser.superview && [indicator_reser isAnimating]) {
        [self removeIndicator_reser];
        [self showViewError_info];
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
        [self removeIndicator_reser];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        [self removeIndicator_reser];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch (curHttpMethod) {
        case timeTeachManageHttpMethod_load: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [self handleHttpFailed];
                        return;
                    }
                    
                    //将所的时间段都先置为不可用
                    [self disableDicTimeDisableAllItem];
                    
                    
                    //解析日期信息
                    NSString *strDate = [dicResult objectForKey:dateKey];
                    strDate = [LyUtil fixDateTimeString:strDate isExplicit:YES];
                    
                    curDate = [[LyUtil dateFormatterForAll] dateFromString:strDate];
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
                                                                                 pdMasterId:[LyCurrentUser curUser].userId
                                                                                  pdWeekday:strWeekdays
                                                                                     pdTime:strTimeBucket
                                                                                    pdPrice:[strPrice floatValue]];
                            
                            if (LySubjectModeprac_second == [strSubject integerValue]) {
                                if (price_second < 1 || [strPrice floatValue] < price_second ) {
                                    price_second = [strPrice floatValue];
                                }
                            } else if (LySubjectModeprac_third == [strSubject integerValue]) {
                                if (price_third < 1 || [strPrice floatValue] < price_third ) {
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
                    
                    
                    //当前预约情况-begin
                    //先将所有时间段信息置为空
                    [dicDateTimeInfo removeAllObjects];
                    
                    NSArray *arrReser = [dicResult objectForKey:reservationInfoKey];
                    if ([LyUtil validateArray:arrReser]) {
                        for (NSDictionary *dicItem in arrReser) {
                            if (![LyUtil validateDictionary:dicItem]) {
                                continue;
                            }
                            
                            NSString *strMasterId = [dicItem objectForKey:masterIdKey];
                            NSString *strMasterName = [dicItem objectForKey:nickNameKey];
                            NSString *strMasterPhone = [dicItem objectForKey:phoneKey];
                            NSString *strTime = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:numKey]];
                            
                            NSString *strLicense = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:driveLicenseKey]];
                            NSString *strSubject = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:subjectModeKey]];
                            
                            NSInteger iTime = [strTime integerValue] / 2;
                            
                            NSString *strStatuss = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:statussKey]];
                            LyDateTimeInfoState dateTimeInfoState = LyDateTimeInfoState_used;
                            if ([strStatuss integerValue] >= 2) {
                                dateTimeInfoState = LyDateTimeInfoState_finish;
                            }
                            
                            LyDateTimeInfo *dti = [LyDateTimeInfo dateTimeInfoWithMode:iTime
                                                                                  date:curDate
                                                                                 state:dateTimeInfoState
                                                                               license:[LyUtil driveLicenseFromString:strLicense]
                                                                               subject:[strSubject integerValue]
                                                                              objectId:[LyCurrentUser curUser].userId
                                                                              masterId:strMasterId
                                                                            masterName:strMasterName
                                                                           masterPhone:strMasterPhone];
                            [dicDateTimeInfo setObject:dti forKey:@(iTime)];
                        }
                    }
                    //当前预约情况-end
                    
                    //完善当前日期所有时间段情况-begin
                    for ( int i = 0; i < 24; ++i) {
                        LyDateTimeInfo *dti = [dicDateTimeInfo objectForKey:@(i)];
                        
                        if ( !dti) {
                            if ([dicTimeDisable objectForKey:@(i)]) {
                                dti = [LyDateTimeInfo dateTimeInfoWithMode:i
                                                                      date:curDate
                                                                     state:LyDateTimeInfoState_disable
                                                                   license:LyLicenseType_C1
                                                                   subject:LySubjectModeprac_second
                                                                  objectId:[LyCurrentUser curUser].userId
                                                                  masterId:nil
                                                                masterName:nil
                                                               masterPhone:nil];
                            } else {
                                dti = [LyDateTimeInfo dateTimeInfoWithMode:i
                                                                      date:curDate
                                                                     state:LyDateTimeInfoState_useable
                                                                   license:LyLicenseType_C1
                                                                   subject:LySubjectModeprac_second
                                                                  objectId:[LyCurrentUser curUser].userId
                                                                  masterId:nil
                                                                masterName:nil
                                                               masterPhone:nil];
                            }
                            
                            [dicDateTimeInfo setObject:dti forKey:@(i)];
                        }
                    }
                    //完善当前日期所有时间段情况-end
                    
                    [self reloadData];
                    
                    [indicator stopAnimation];
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
        case timeTeachManageHttpMethod_loadWithDate: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [self removeIndicator_reser];
                        [self showViewError_info];
                        return;
                    }
                    
                    
                    //解析日期信息
                    NSString *strDate = [dicResult objectForKey:dateKey];
                    strDate = [LyUtil fixDateTimeString:strDate isExplicit:YES];
                    
                    curDate = [[LyUtil dateFormatterForAll] dateFromString:strDate];
                    curDateStrYMD = [[[LyUtil dateFormatterForAll] stringFromDate:curDate] substringToIndex:dateStringLength];
                    curDateStrMD = [curDateStrYMD substringWithRange:NSMakeRange( 5, 5)];
                    curWeekday = [LyUtil weekdayWithDate:curDate];
                    
                    
                    //将所的时间段都先置为不可用
                    [self disableDicTimeDisableAllItem];
                    
                    NSArray *arr = [[LyPriceDetailManager sharedInstance] priceDetailWithUserId:[LyCurrentUser curUser].userId];
                    for (LyPriceDetail *priceDetail in arr) {
                        if (priceDetail.pdWeekdaySpan.begin <= curWeekday && curWeekday <= priceDetail.pdWeekdaySpan.end) {
                            [self enableDicTimeDisable:priceDetail];
                        }
                    }
                    
                    //当前预约情况-begin
                    //先将所有时间段信息置为空
                    [dicDateTimeInfo removeAllObjects];

                    NSArray *arrReser = [dicResult objectForKey:reservationInfoKey];
                    if ([LyUtil validateArray:arrReser]) {
                        for (NSDictionary *dicItem in arrReser ) {

                            if (![LyUtil validateDictionary:dicItem]) {
                                continue;
                            }
                            
                            NSString *strMasterId = [dicItem objectForKey:masterIdKey];
                            NSString *strMasterName = [dicItem objectForKey:nickNameKey];
                            NSString *strMasterPhone = [dicItem objectForKey:phoneKey];
                            NSString *strTime = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:numKey]];
                            
                            NSString *strLicense = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:driveLicenseKey]];
                            NSString *strSubject = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:subjectModeKey]];
                            
                            NSInteger iTime = [strTime integerValue] / 2;
                            
                            NSString *strStatuss = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:statussKey]];
                            LyDateTimeInfoState dateTimeInfoState = LyDateTimeInfoState_used;
                            if ([strStatuss integerValue] >= 2) {
                                dateTimeInfoState = LyDateTimeInfoState_finish;
                            }
                            
                            LyDateTimeInfo *dti = [LyDateTimeInfo dateTimeInfoWithMode:iTime
                                                                                  date:curDate
                                                                                 state:dateTimeInfoState
                                                                               license:[LyUtil driveLicenseFromString:strLicense]
                                                                               subject:[strSubject integerValue]
                                                                              objectId:[LyCurrentUser curUser].userId
                                                                              masterId:strMasterId
                                                                            masterName:strMasterName
                                                                           masterPhone:strMasterPhone];
                            [dicDateTimeInfo setObject:dti forKey:@(iTime)];
                        }
                    }
                    //当前预约情况-end
                    
                    
                    
                    //完善当前日期所有时间段情况-begin
                    for ( int i = 0; i < 24; ++i) {
                        LyDateTimeInfo *dti = [dicDateTimeInfo objectForKey:@(i)];
                        if ( !dti) {
                            if ([dicTimeDisable objectForKey:@(i)]) {
                                dti = [LyDateTimeInfo dateTimeInfoWithMode:i
                                                                      date:curDate
                                                                     state:LyDateTimeInfoState_disable
                                                                   license:LyLicenseType_C1
                                                                   subject:LySubjectModeprac_second
                                                                  objectId:[LyCurrentUser curUser].userId
                                                                  masterId:nil
                                                                masterName:nil
                                                               masterPhone:nil];
                            } else {
                                dti = [LyDateTimeInfo dateTimeInfoWithMode:i
                                                                      date:curDate
                                                                     state:LyDateTimeInfoState_useable
                                                                   license:LyLicenseType_C1
                                                                   subject:LySubjectModeprac_second
                                                                  objectId:[LyCurrentUser curUser].userId
                                                                  masterId:nil
                                                                masterName:nil
                                                               masterPhone:nil];
                            }
                            
                            [dicDateTimeInfo setObject:dti forKey:@(i)];
                        }
                    }
                    //完善当前日期所有时间段情况-end
                    
                    [self reloadData];
                    
                    [self removeIndicator_reser];
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


#pragma mark -LyReservationDetailTableViewControllerDelegate
- (LyDateTimeInfo *)obtainDateTimeInfoByReservationDetailTVC:(LyReservationDetailTableViewController *)aReservationDetailTVC {
    return curDateTimeInfo;
}


#pragma mark -LyDateTimePickerDelegate
- (void)dateTimePicker:(LyDateTimePicker *)aDateTimePicker didSelectDateItemAtIndex:(NSInteger)index andDate:(NSDate *)date {
    curDate = date;
    curDateStrYMD = [[curDate description] substringToIndex:dateStringLength];
    curDateStrMD = [[curDate description] substringWithRange:NSMakeRange( 5, 5)];
    
//    if (flagAutoSelect) {
//        return;
//    }
    
    [self loadWithDate];
}

- (void)dateTimePicker:(LyDateTimePicker *)aDateTimePicker didSelectTimeItemAtIndex:(NSInteger)index andDate:(NSDate *)date andWeekday:(LyWeekday)weekday {
    curIdx = index;
    curDateTimeInfo = [dicDateTimeInfo objectForKey:@(curIdx)];
    
    if (LyDateTimeInfoState_used == curDateTimeInfo.state || LyDateTimeInfoState_finish == curDateTimeInfo.state) {
        LyReservationDetailTableViewController *reservationDetail = [[LyReservationDetailTableViewController alloc] init];
        [reservationDetail setDelegate:self];
        [self.navigationController pushViewController:reservationDetail animated:YES];
    }
}


#pragma mark -LyDateTimePickerDataSource
- (NSDate *)dateInDateTimePicker:(LyDateTimePicker *)aDateTimePicker {
    return curDate;
}


- (LyDateTimeInfo *)dateTimePicker:(LyDateTimePicker *)aDateTimePicker forItemIndex:(NSInteger)index {
    return [dicDateTimeInfo objectForKey:@(index)];
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
