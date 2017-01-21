//
//  LyCoachDetailTableViewController.m
//  teacher
//
//  Created by Junes on 16/8/31.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyCoachDetailTableViewController.h"
#import "LyCoachCurrentInfoTableViewCell.h"

#import "LyDriveLicensePicker.h"
#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyUserManager.h"
#import "LyTrainBase.h"
#import "LyCurrentUser.h"

#import "LyUtil.h"


#import "LyUpdateCoachTrainBaseTableViewController.h"
#import "LyStudentInfoViewController.h"
#import "LyOrderInfoViewController.h"



CGFloat const cdViewHeaderHeight = 230.0f;

CGFloat const cdIvAvatarSize = 60.0f;
//CGFloat const lbItemHeight = 20.0f;
//CGFloat const btnTrainBaseNameWidth = 130.0f;

#define cdBtnTimeFlagWidth                 (cdBtnItemWidth*2+cdBtnItemMargin)

#define cdBtnItemWidth                      (SCREEN_WIDTH/3.0f)
#define cdBtnItemMargin                     ((SCREEN_WIDTH-cdBtnItemWidth*2)/3)
CGFloat const cdBtnItemHeight = 30.0f;

int const tvInfosRowNumber = 2;


enum {
    coachDetailBarButtonItemTag_delete = 0,
}LyCoachDetailBarButtonItemTag;

enum {
    coachDetailButtonTag_timeFlag = 20,
    coachDetailButtonTag_trainBase,
    coachDetailButtonTag_license,
}LyCoachDetailButtonTag;

typedef NS_ENUM(NSInteger, LyCoachDetailHttpMethod) {
    coachDetailHttpMethod_load = 100,
    coachDetailHttpMethod_modifyTimeFlag,
    coachDetailHttpMethod_modifyLicense,
    coachDetailHttpMethod_delete,
};


@interface LyCoachDetailTableViewController () <LyRemindViewDelegate, LyHttpRequestDelegate, LyUpdateCoachTrainBaseTableViewControllerDelegate, LyStudentInfoViewControllerDelegate, LyOrderInfoViewControllerDelegate, LyDriveLicensePickerDelegate>
{
    UIView                      *viewError;
    
    //教练信息
    UIView                      *viewInfo;
    //教练信息-头像
    UIImageView                 *ivAvatar;
    //教练信息-姓名
    UILabel                     *lbName;
    //教练信息-计时flag
//    UILabel                     *lbTimeTeach;
    UIButton                    *btnTimeFlag;
    //教练信息-培训基地
    UIButton                    *btnTrainBaseName;
    //教练信息-所教驾照
    UIButton                    *btnLicense;
    //教练信息-当前学员信息
    UILabel                     *lbStudentInfo;
    //教练信息-本月订单数
    UILabel                     *lbOrderInfo;
    
    
    LyCoach                     *coach;
    LyLicenseType               nextLicense;
    
    LyIndicator                 *indicator_oper;
    LyIndicator                 *indicator;
    BOOL                        bHttpFlag;
    LyCoachDetailHttpMethod     curHttpMethod;
}
@end

@implementation LyCoachDetailTableViewController

static NSString *const lyCoachDetailTvInfosCellReuseIdentifier = @"lyCoachDetailTvInfosCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initAndLayoutSubviews];
}



- (void)viewWillAppear:(BOOL)animated {
    
    if (!_coachId) {
        _coachId = [_delegate obtainCoachIdByCoachDetailTVC:self];
        
        if (!_coachId) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        if (![_coachId isEqualToString:[LyCurrentUser curUser].userId]) {
            UIBarButtonItem *bbiDelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                       target:self action:@selector(targetForBarButtonItem:)];
            [bbiDelete setTag:coachDetailBarButtonItemTag_delete];
            [self.navigationItem setRightBarButtonItem:bbiDelete];
        }
        
        coach = [[LyUserManager sharedInstance] getCoachWithCoachId:_coachId];
    
        [self load];
    }
}



- (void)initAndLayoutSubviews {
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    //教练信息
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cdViewHeaderHeight)];
    [self.view addSubview:viewInfo];
    //教练信息-头像
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f-cdIvAvatarSize/2.0f, 20.0f, cdIvAvatarSize, cdIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [ivAvatar.layer setCornerRadius:btnCornerRadius];
    [ivAvatar setClipsToBounds:YES];
    //教练信息-姓名
    lbName = [[UILabel alloc] initWithFrame:CGRectMake(0, ivAvatar.ly_y+CGRectGetHeight(ivAvatar.frame)+verticalSpace, SCREEN_WIDTH, lbItemHeight)];
    [lbName setFont:LyFont(16)];
    [lbName setTextColor:LyBlackColor];
    [lbName setTextAlignment:NSTextAlignmentCenter];
    //教练信息-当前学员信息
    lbStudentInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, lbName.ly_y+CGRectGetHeight(lbName.frame)+verticalSpace, SCREEN_WIDTH, lbItemHeight)];
    [lbStudentInfo setFont:LyFont(14)];
    [lbStudentInfo setTextColor:[UIColor darkGrayColor]];
    [lbStudentInfo setTextAlignment:NSTextAlignmentCenter];
    //教练信息-本月订单数
    lbOrderInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, lbStudentInfo.ly_y+CGRectGetHeight(lbStudentInfo.frame)+verticalSpace, SCREEN_WIDTH, lbItemHeight)];
    [lbOrderInfo setFont:LyFont(14)];
    [lbOrderInfo setTextColor:[UIColor darkGrayColor]];
    [lbOrderInfo setTextAlignment:NSTextAlignmentCenter];
    //教练信息-计时
    btnTimeFlag = [[UIButton alloc] initWithFrame:CGRectMake(cdBtnItemMargin, lbOrderInfo.ly_y+CGRectGetHeight(lbOrderInfo.frame)+verticalSpace, cdBtnTimeFlagWidth, cdBtnItemHeight)];
    [btnTimeFlag setTag:coachDetailButtonTag_timeFlag];
    [btnTimeFlag.titleLabel setFont:LyFont(14)];
    [btnTimeFlag setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [btnTimeFlag setTitleColor:Ly517ThemeColor forState:UIControlStateHighlighted];
    [btnTimeFlag setTitle:@"计时培训：不支持" forState:UIControlStateNormal];
//    [btnTimeFlag setTitle:@"计时培训：支持" forState:UIControlStateHighlighted];
    [btnTimeFlag setBackgroundColor:[UIColor whiteColor]];
    [btnTimeFlag.layer setCornerRadius:btnCornerRadius];
    [btnTimeFlag addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    //教练信息-培训基地
    btnTrainBaseName = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-cdBtnItemWidth*2)/3, btnTimeFlag.ly_y+CGRectGetHeight(btnTimeFlag.frame)+verticalSpace, cdBtnItemWidth, cdBtnItemHeight)];
    [btnTrainBaseName setTag:coachDetailButtonTag_trainBase];
    [btnTrainBaseName.titleLabel setFont:LyFont(14)];
    [btnTrainBaseName setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnTrainBaseName setBackgroundColor:[UIColor whiteColor]];
    [btnTrainBaseName.layer setCornerRadius:btnCornerRadius];
    [btnTrainBaseName addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    //教练信息-所教驾照
    btnLicense = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH-cdBtnItemWidth*2)/3-cdBtnItemWidth, btnTrainBaseName.ly_y, cdBtnItemWidth, cdBtnItemHeight)];
    [btnLicense setTag:coachDetailButtonTag_license];
    [btnLicense.titleLabel setFont:LyFont(14)];
    [btnLicense setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnLicense setBackgroundColor:[UIColor whiteColor]];
    [btnLicense.layer setCornerRadius:btnCornerRadius];
    [btnLicense addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewInfo addSubview:ivAvatar];
    [viewInfo addSubview:lbName];
    [viewInfo addSubview:lbStudentInfo];
    [viewInfo addSubview:lbOrderInfo];
    [viewInfo addSubview:btnTimeFlag];
    [viewInfo addSubview:btnTrainBaseName];
    [viewInfo addSubview:btnLicense];
    
    
    [self.tableView registerClass:[LyCoachCurrentInfoTableViewCell class] forCellReuseIdentifier:lyCoachDetailTvInfosCellReuseIdentifier];
    [self.tableView setTableHeaderView:viewInfo];
    [self.tableView setTableFooterView:[UIView new]];
    self.refreshControl = [LyUtil refreshControlWithTitle:@"正在加载" target:self action:@selector(refresh:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)reloadData {
    [self removeViewError];
    
    if (!coach.userAvatar)
    {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:_coachId]
                    placeholderImage:[LyUtil defaultAvatarForTeacher]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if (image) {
                                   [coach setUserAvatar:image];
                               } else {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:_coachId]
                                               placeholderImage:[LyUtil defaultAvatarForTeacher]
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                          if (image) {
                                                              [coach setUserAvatar:image];
                                                          }
                                                      }];
                               }
                           }];
    }
    else {
        [ivAvatar setImage:coach.userAvatar];
    }
    
    self.title = coach.userName;
    
    [lbName setText:coach.userName];
    [lbStudentInfo setText:[coach teachingCountByString]];
    [lbOrderInfo setText:[coach monthOrderCountByString]];
    
    [self reloadTimeFlag];
    [self reloadTrainBaseName];
    [self reloadLicense];
    
    [self.tableView reloadData];
}


- (void)reloadTimeFlag {
    NSString *str;
    UIColor *color;
    if (coach.timeFlag) {
        str = @"计时培训：支持";
        color = Ly517ThemeColor;
    } else {
        str = @"计时培训：不支持";
        color = [UIColor lightGrayColor];
    }
    
    [btnTimeFlag setTitle:str forState:UIControlStateNormal];
    [btnTimeFlag setTitleColor:color forState:UIControlStateNormal];
}

- (void)reloadTrainBaseName {
    [btnTrainBaseName setTitle:coach.trainBaseName forState:UIControlStateNormal];
}

- (void)reloadLicense {
    [btnLicense setTitle:[LyUtil driveLicenseStringFrom:coach.userLicenseType] forState:UIControlStateNormal];
}

- (void)showViewError {
    if (!viewError)
    {
        viewError = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.2f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewError addSubview:[LyUtil lbErrorWithMode:0]];
    }
    
    [self.tableView addSubview:viewError];
}

- (void)removeViewError {
    [viewError removeFromSuperview];
    viewError = nil;
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    if (coachDetailBarButtonItemTag_delete == bbi.tag) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[[NSString alloc] initWithFormat:@"你确定要删除「%@」吗？", coach.userName]
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"删除"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    [self delete];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (void)targetForButton:(UIButton *)btn {
    
    if (coachDetailButtonTag_timeFlag == btn.tag) {
        if (coach.timeFlag) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:[[NSString alloc] initWithFormat:@"确定「%@」不支持订时培训了吗？", coach.userName]
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"不支持了"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        [self modifyTimeFlag:0];
                                                    }]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [self modifyTimeFlag:1];
        }
    }
    else if (coachDetailButtonTag_trainBase == btn.tag) {
        LyUpdateCoachTrainBaseTableViewController *updateCoachTrainBase = [[LyUpdateCoachTrainBaseTableViewController alloc] init];
        [updateCoachTrainBase setDelegate:self];
        [self.navigationController pushViewController:updateCoachTrainBase animated:YES];
    } else if (coachDetailButtonTag_license == btn.tag) {
        LyDriveLicensePicker *dlPicker = [[LyDriveLicensePicker alloc] init];
        [dlPicker setDelegate:self];
        [dlPicker setInitDriveLicense:coach.userLicenseType];
        [dlPicker show];
    }
}



- (void)refresh:(UIRefreshControl *)rc {
    [self load];
}

- (void)load {
    if (!indicator)
    {
        indicator = [LyIndicator indicatorWithTitle:@"正在加载"];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:coachDetailHttpMethod_load];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:coachDetail_url
                                 body:@{
                                        userIdKey:_coachId,
                                        sessionIdKey:[LyUtil httpSessionId]
                                        }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)modifyTimeFlag:(NSInteger)timeFlag {
    if (!indicator_oper) {
        indicator_oper = [LyIndicator indicatorWithTitle:LyIndicatorTitle_modify];
    } else {
        [indicator_oper setTitle:LyIndicatorTitle_modify];
    }
    [indicator_oper startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:coachDetailHttpMethod_modifyTimeFlag];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:updateTimeTeachFlag_url
                                 body:@{
                                        timeFlagKey:@(timeFlag),
                                        userIdKey:_coachId,
                                        sessionIdKey:[LyUtil httpSessionId],
                                        userTypeKey:userTypeCoachKey
                                        }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)modifyLicense {
    if (!indicator_oper) {
        indicator_oper = [LyIndicator indicatorWithTitle:LyIndicatorTitle_modify];
    } else {
        [indicator_oper setTitle:LyIndicatorTitle_modify];
    }
    [indicator_oper startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:coachDetailHttpMethod_modifyLicense];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:modifyTeacherLicense_url
                                 body:@{
                                       driveLicenseKey:[LyUtil driveLicenseStringFrom:nextLicense],
                                       userIdKey:_coachId,
                                       sessionIdKey:[LyUtil httpSessionId],
                                       userTypeKey:userTypeCoachKey
                                       }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)delete {
    if (!indicator_oper) {
        indicator_oper = [LyIndicator indicatorWithTitle:LyIndicatorTitle_delete];
    } else {
        [indicator_oper setTitle:LyIndicatorTitle_delete];
    }
    
    [indicator_oper startAnimation];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:coach.userId forKey:objectIdKey];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    
    if (LyUserType_school == [LyCurrentUser curUser].userType) {
        [dic setObject:masterIdKey forKey:masterKey];
    }
    else if (LyUserType_coach == [LyCurrentUser curUser].userType) {
        [dic setObject:bossKey forKey:bossKey];
    }
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:coachDetailHttpMethod_delete];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:deleteCoach_url
                                 body:dic
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)handleHttpFailed {
    if (indicator.isAnimating) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        [self showViewError];
    }
    
    if ([indicator_oper isAnimating]) {
        [indicator_oper stopAnimation];
        NSString *str;
        if ([indicator_oper.title isEqualToString:LyIndicatorTitle_delete]) {
            str = @"删除失败";
        } else if ([indicator_oper.title isEqualToString:LyIndicatorTitle_modify]) {
            str =  @"修改失败";
        }
        LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:str];
        [remind show];
        
    }
}


- (void)analysisHttpResult:(NSString *)result {
    NSDictionary *dic = [LyUtil getObjFromJson:result];
    if (!dic || ![LyUtil validateDictionary:dic]) {
        [self handleHttpFailed];
        return;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (!strCode || ![LyUtil validateString:strCode]) {
        [self handleHttpFailed];
        return;
    }
    
    if (codeTimeOut == [strCode integerValue]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch (curHttpMethod) {
        case coachDetailHttpMethod_load: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (!dicResult || ![LyUtil validateDictionary:dicResult])
                    {
                        [indicator stopAnimation];
                        [self.refreshControl endRefreshing];
                        [self showViewError];
                        return;
                    }
                    
                    NSString *strNickName = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:nickNameKey]];
                    NSString *strAllStuCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:studentCountKey]];
                    NSString *strCurStuCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:curStudentCountKey]];
                    NSString *strCurOrderCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:curOrderCountKey]];
                    NSString *strOrderCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:orderCountKey]];
                    NSString *strTimeFlag = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:timeFlagKey]];
                    NSString *strLicense = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:driveLicenseKey]];
                    NSString *strTrainBaseName = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:trainBaseKey]];
                    
                    
                    if (!coach) {
                        coach = [LyCoach coachWithId:_coachId
                                                name:strNickName];
                    }
                    [coach setUserName:strNickName];
                    [coach setTeachingCount:[strCurStuCount intValue]];
                    [coach setStuAllCount:strAllStuCount.intValue];
                    [coach setMonthOrderCount:[strCurOrderCount intValue]];
                    [coach setAllOrderCount:[strOrderCount intValue]];
                    [coach setTimeFlag:[strTimeFlag boolValue]];
                    [coach setUserLicenseType:[LyUtil driveLicenseFromString:strLicense]];
                    [coach setTrainBaseName:strTrainBaseName];
                    
                    
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
        case coachDetailHttpMethod_modifyTimeFlag: {
            switch ([strCode integerValue]) {
                case 0: {
                    
                    [coach setTimeFlag:!coach.timeFlag];
                    [self reloadTimeFlag];
                    
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"修改成功"] show];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case coachDetailHttpMethod_modifyLicense: {
            switch ([strCode integerValue]) {
                case 0: {
                    
                    [coach setUserLicenseType:nextLicense];
                    [self reloadLicense];
                    
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"修改成功"] show];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case coachDetailHttpMethod_delete: {
            switch ([strCode integerValue]) {
                case 0: {
                    [[LyUserManager sharedInstance] removeUser:coach];
                    
                    [indicator_oper stopAnimation];
                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"删除成功"];
                    [remind setDelegate:self];
                    [remind show];
                    
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
    if (bHttpFlag)
    {
        bHttpFlag = NO;
        curHttpMethod = ahttpRequest.mode;
        
        [self analysisHttpResult:result];
    }
    
    curHttpMethod = 0;
}



#pragma mark -LyOrderInfoViewControllerDelegate
- (NSString *)obtainCoachIdByOrderInfoVC:(LyOrderInfoViewController *)aOrderInfoVC {
    return _coachId;
}


#pragma mark -LyStudentInfoViewControllerDelegate
- (NSString *)obtainCoachIdByStudentInfoVC:(LyStudentInfoViewController *)aStudentInfoVC {
    return _coachId;
}


#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(LyRemindView *)aRemind {
    [_delegate onDeleteByCoachDetailTVC:self];
}


#pragma mark -LyDriveLicensePickerDelegate
- (void)onDriveLicensePickerCancel:(LyDriveLicensePicker *)picker {
    [picker hide];
}

- (void)onDriveLicensePickerDone:(LyDriveLicensePicker *)picker license:(LyLicenseType)license {
    [picker hide];
    
    if (license != coach.userLicenseType) {
        nextLicense = license;
        [self modifyLicense];
    }
}


#pragma mark -LyUpdateCoachTrainBaseTableViewControllerDelegate 
- (LyCoach *)obtainCoachByUpdateCoachTrainBaseTVC:(LyUpdateCoachTrainBaseTableViewController *)aUpdateCoachTrainBaseTVC {
    return coach;
}

- (void)onDoneByUpdateCoachTrainBaseTVC:(LyUpdateCoachTrainBaseTableViewController *)aUpdateCoachTrainBaseTVC trainBase:(LyTrainBase *)aTrainBase {
    [aUpdateCoachTrainBaseTVC.navigationController popViewControllerAnimated:YES];
    
    [coach setTrainBaseId:aTrainBase.tbId];
    [coach setTrainBaseName:aTrainBase.tbName];
    
//    [btnTrainBaseName setTitle:coach.trainBaseName forState:UIControlStateNormal];
    [self reloadTrainBaseName];
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ccitcellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([_coachId isEqualToString:[LyCurrentUser curUser].userId]) {
        return;
    }
    
    if (0 == indexPath.row)
    {
        LyStudentInfoViewController *studentInfo = [[LyStudentInfoViewController alloc] init];
        [studentInfo setDelegate:self];
        [self.navigationController pushViewController:studentInfo animated:YES];
    }
    else if (1 == indexPath.row)
    {
        LyOrderInfoViewController *orderInfo = [[LyOrderInfoViewController alloc] init];
        [orderInfo setDelegate:self];
        [self.navigationController pushViewController:orderInfo animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger iCount = tvInfosRowNumber;
    if ([_coachId isEqualToString:[LyCurrentUser curUser].userId]) {
        iCount = 0;
    }
        
    return iCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyCoachCurrentInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyCoachDetailTvInfosCellReuseIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[LyCoachCurrentInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyCoachDetailTvInfosCellReuseIdentifier];
    }
    
    switch (indexPath.row) {
        case 0: {
            [cell setCellInfo:[LyUtil imageForImageName:@"studentInfo" needCache:NO]
                        title:@"学员信息"
                         info:[coach teachAllCountByString]];
            break;
        }
        case 1: {
            [cell setCellInfo:[LyUtil imageForImageName:@"orderInfo" needCache:NO]
                        title:@"订单信息"
                         info:[coach allOrderCountByString]];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
