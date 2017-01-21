//
//  LyTeachManageTableViewController.m
//  teacher
//
//  Created by Junes on 16/8/10.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyTeachManageTableViewController.h"
#import "LyTeachManageTableViewCell.h"

#import "LyIndicator.h"

#import "LyCurrentUser.h"


#import "LyUtil.h"


#import "LyCoachManageTableViewController.h"
#import "LyTimeTeachManageViewController.h"
#import "LyTrainBaseManageTableViewController.h"
#import "LyLandMarkManageViewController.h"

#import "LyPriceDetailViewController.h"


//个人信息
CGFloat const tmViewInfoHeight = 200.0f;
//头像尺寸
CGFloat const tmIvAvatarSize = 80.0f;
//标签高序
//CGFloat const lbItemHeight = 20.0f;

#define lbNameFont                          LyFont(16)
#define lbItemFont                          LyFont(14)




typedef NS_ENUM(NSInteger, LyTeachManageHttpMethod)
{
    teachManageHttpMethod_load = 100,
    
};







@interface LyTeachManageTableViewController () <LyHttpRequestDelegate>
{
    UIView                      *viewInfo;
    UIImageView                 *ivAvatar;
    UILabel                     *lbName;
    UILabel                     *lbCoachCount;
    UILabel                     *lbStudentCount;
    UILabel                     *lbOrderCount;
    
    
    NSInteger                   iCoachCount;
    NSInteger                   iStudentCount;
    NSInteger                   iOrderCount;
    NSInteger                   iTrainBaseCount;
    NSInteger                   iLandMarkCount;
    
    NSString                    *curCoachCount;
    NSString                    *curTrainBaseCount;
    NSString                    *curLandMarkCount;
    
    
    BOOL                        flagLoad;
    UIView                      *viewError;
    
    
    
    LyIndicator                 *indicator;
    BOOL                        bHttpFlag;
    LyTeachManageHttpMethod     curHttpMethod;
}
@end

@implementation LyTeachManageTableViewController

static NSString *const LyTeacherManageTvInfosCellReuseIdentifier = @"LyTeacherManageTvInfosCellReuseIdentifier";

static NSString *const timeTeachDetailAvailable = @"在这里查看和编辑计时培训信息";
static NSString *const timeTeachDetailUnavailable = @"请前往「发布」开启计时培训";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initAndLayoutSubviews];
}



- (void)viewWillAppear:(BOOL)animated
{
    if (!flagLoad) {
        [self load];
    }
}


- (void)initAndLayoutSubviews
{
    self.title = @"教学管理";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    //个人信息
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tmViewInfoHeight)];
    //个人信息-头像
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f-tmIvAvatarSize/2.0f, tmViewInfoHeight-(tmIvAvatarSize+lbItemHeight*4+verticalSpace*4), tmIvAvatarSize, tmIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [ivAvatar setClipsToBounds:YES];
    [ivAvatar.layer setCornerRadius:btnCornerRadius];
    //个人信息-姓名
    lbName = [[UILabel alloc] initWithFrame:CGRectMake(0, ivAvatar.ly_y+CGRectGetHeight(ivAvatar.frame)+verticalSpace, SCREEN_WIDTH, lbItemHeight)];
    [lbName setFont:lbNameFont];
    [lbName setTextColor:LyBlackColor];
    [lbName setTextAlignment:NSTextAlignmentCenter];
    
    [viewInfo addSubview:ivAvatar];
    [viewInfo addSubview:lbName];
    
    //教练人数
    //累计学员数
    //累计订单数
    if ([LyCurrentUser curUser].isBoss) {
        //教练人数
        lbCoachCount = [[UILabel alloc] initWithFrame:CGRectMake(0, lbName.ly_y+CGRectGetHeight(lbName.frame)+verticalSpace, SCREEN_WIDTH, lbItemHeight)];
        [lbCoachCount setFont:lbItemFont];
        [lbCoachCount setTextColor:[UIColor darkGrayColor]];
        [lbCoachCount setTextAlignment:NSTextAlignmentCenter];
        //累计学员数
        lbStudentCount = [[UILabel alloc] initWithFrame:CGRectMake(0, lbCoachCount.ly_y+CGRectGetHeight(lbCoachCount.frame), SCREEN_WIDTH, lbItemHeight)];
        [lbStudentCount setFont:lbItemFont];
        [lbStudentCount setTextColor:[UIColor darkGrayColor]];
        [lbStudentCount setTextAlignment:NSTextAlignmentCenter];
        //累计订单数
        lbOrderCount = [[UILabel alloc] initWithFrame:CGRectMake(0, lbStudentCount.ly_y+CGRectGetHeight(lbStudentCount.frame), SCREEN_WIDTH, lbItemHeight)];
        [lbOrderCount setFont:lbItemFont];
        [lbOrderCount setTextColor:[UIColor darkGrayColor]];
        [lbOrderCount setTextAlignment:NSTextAlignmentCenter];
        
        [viewInfo addSubview:lbCoachCount];
        [viewInfo addSubview:lbStudentCount];
        [viewInfo addSubview:lbOrderCount];
    }
    else {
        [ivAvatar setFrame:CGRectMake(SCREEN_WIDTH/2.0f-tmIvAvatarSize/2.0f, tmViewInfoHeight-(tmIvAvatarSize+lbItemHeight*3+verticalSpace*4), tmIvAvatarSize, tmIvAvatarSize)];
        [lbName setFrame:CGRectMake(0, ivAvatar.ly_y+CGRectGetHeight(ivAvatar.frame)+verticalSpace, SCREEN_WIDTH, lbItemHeight)];
        
        //累计学员数
        lbStudentCount = [[UILabel alloc] initWithFrame:CGRectMake(0, lbName.ly_y+CGRectGetHeight(lbName.frame), SCREEN_WIDTH, lbItemHeight)];
        [lbStudentCount setFont:lbItemFont];
        [lbStudentCount setTextColor:[UIColor darkGrayColor]];
        [lbStudentCount setTextAlignment:NSTextAlignmentCenter];
        //累计订单数
        lbOrderCount = [[UILabel alloc] initWithFrame:CGRectMake(0, lbStudentCount.ly_y+CGRectGetHeight(lbStudentCount.frame), SCREEN_WIDTH, lbItemHeight)];
        [lbOrderCount setFont:lbItemFont];
        [lbOrderCount setTextColor:[UIColor darkGrayColor]];
        [lbOrderCount setTextAlignment:NSTextAlignmentCenter];
        
        [viewInfo addSubview:lbStudentCount];
        [viewInfo addSubview:lbOrderCount];
    }
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, tmViewInfoHeight-verticalSpace, SCREEN_WIDTH, verticalSpace)];
    [horizontalLine setBackgroundColor:LyWhiteLightgrayColor];
    
    [viewInfo addSubview:horizontalLine];
    
    
    [self.tableView registerClass:[LyTeachManageTableViewCell class] forCellReuseIdentifier:LyTeacherManageTvInfosCellReuseIdentifier];
    [self.tableView setTableHeaderView:viewInfo];
    [self.tableView setTableFooterView:[UIView new]];
    self.refreshControl = [LyUtil refreshControlWithTitle:@"正在加载" target:self action:@selector(refresh:)];
    
}


- (void)reloadData
{
    [self removeViewError];
    
    if ( ![[LyCurrentUser curUser] userAvatar]) {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:[LyCurrentUser curUser].userId]
                    placeholderImage:[LyUtil defaultAvatarForTeacher]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if (image) {
                                   [[LyCurrentUser curUser] setUserAvatar:image];
                               } else {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:[LyCurrentUser curUser].userId]
                                               placeholderImage:[LyUtil defaultAvatarForTeacher]
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                          if (!image) {
                                                              image = [LyUtil defaultAvatarForTeacher];
                                                          }
                                                          
                                                          [[LyCurrentUser curUser] setUserAvatar:image];
                                                      }];
                               }
                           }];
    }
    else {
        [ivAvatar setImage:[[LyCurrentUser curUser] userAvatar]];
    }
    
    
    [lbName setText:[LyCurrentUser curUser].userName];
    
    
    if ([LyCurrentUser curUser].isBoss) {
        //教练人数
        NSString *strLbCoachCountNum = [[NSString alloc] initWithFormat:@"%ld", iCoachCount];
//        NSString *strLbCoachCountNum = @"47";
        NSString *strLbCoachCountTmp = [[NSString alloc] initWithFormat:@"教练人数：%@人", strLbCoachCountNum];
        NSMutableAttributedString *strLbCoachCount = [[NSMutableAttributedString alloc] initWithString:strLbCoachCountTmp];
        [strLbCoachCount addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[strLbCoachCountTmp rangeOfString:strLbCoachCountNum]];
        [lbCoachCount setAttributedText:strLbCoachCount];
    }
    
    //累计学员
    NSString *strLbStudentCountNum = [[NSString alloc] initWithFormat:@"%ld", iStudentCount];
//    NSString *strLbStudentCountNum = @"3533";
    NSString *strLbStudentCountTmp = [[NSString alloc] initWithFormat:@"累计学员：%@人", strLbStudentCountNum];
    NSMutableAttributedString *strLbStudentCount = [[NSMutableAttributedString alloc] initWithString:strLbStudentCountTmp];
    [strLbStudentCount addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[strLbStudentCountTmp rangeOfString:strLbStudentCountNum]];
    [lbStudentCount setAttributedText:strLbStudentCount];
    
    
    //累计订单
    NSString *strLbOrderCountNum = [[NSString alloc] initWithFormat:@"%ld", iOrderCount];
//    NSString *strLbOrderCountNum = @"4684";
    NSString *strLbOrderCountTmp = [[NSString alloc] initWithFormat:@"累计订单：%@单", strLbOrderCountNum];
    NSMutableAttributedString *strLbOrderCount = [[NSMutableAttributedString alloc] initWithString:strLbOrderCountTmp];
    [strLbOrderCount addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[strLbOrderCountTmp rangeOfString:strLbOrderCountNum]];
    [lbOrderCount setAttributedText:strLbOrderCount];
    
    
    [self.tableView reloadData];
    
}


- (void)showViewError
{
    flagLoad = NO;
    if (!viewError) {
        viewError = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewError addSubview:[LyUtil lbErrorWithMode:0]];
    }
    
    [self.tableView addSubview:viewError];
    [self.tableView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
}

- (void)removeViewError
{
    flagLoad = YES;
    [viewError removeFromSuperview];
    [self.tableView layoutSubviews];
}


- (void)showAlertViewForRemindOpenTimeFlag {
    
}


- (void)setCoachCount:(NSInteger)coachCount
{
    iCoachCount = coachCount;
    curCoachCount = [[NSString alloc] initWithFormat:@"共有%ld名教练", iCoachCount];
}
- (void)setTrainBaseCount:(NSInteger)trainBaseCount
{
    iTrainBaseCount = trainBaseCount;
    curTrainBaseCount = [[NSString alloc] initWithFormat:@"共有%ld个基地", iTrainBaseCount];
}
- (void)setLandMarkCount:(NSInteger)landMarkCount
{
    iLandMarkCount = landMarkCount;
    curLandMarkCount = [[NSString alloc] initWithFormat:@"共有%ld处地标", iLandMarkCount];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)refresh:(UIRefreshControl *)rc
{
    [self load];
}



- (void)load
{
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:LyIndicatorTitle_load];
    }
    else {
        [indicator setTitle:LyIndicatorTitle_load];
    }
    
    [indicator startAnimation];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[LyCurrentUser curUser].userId forKey:userIdKey];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    [dic setObject:[[LyCurrentUser curUser] userTypeByString] forKey:userTypeKey];
    if (LyUserType_coach == [LyCurrentUser curUser].userType) {
        [dic setObject:@([LyCurrentUser curUser].coachMode) forKey:coachModeKey];
    }
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:teachManageHttpMethod_load];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:teachManage_url
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
}


- (void)analysisHttpResult:(NSString *)result
{
    NSDictionary *dic = [LyUtil getObjFromJson:result];
    if (!dic ||  ![LyUtil validateDictionary:dic]) {
        [self handleHttpFailed];
        return;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (!strCode || ![LyUtil validateString:strCode]) {
        curHttpMethod = 0;
        [self handleHttpFailed];
        return;
    }
    
    if (codeTimeOut == [strCode integerValue]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        
        [LyUtil sessionTimeOut];
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    switch (curHttpMethod) {
        case teachManageHttpMethod_load: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (!dicResult || ![LyUtil validateDictionary:dicResult]) {
                        [indicator stopAnimation];
                        [self.refreshControl endRefreshing];
                        [self showViewError];
                        return;
                    }
                    
                    NSString *strTimeFlag;
                    NSString *strLicense;
                    NSDictionary *dicTimeFlagAndLicense = [dicResult objectForKey:timeFlagKey];
                    if ([LyUtil validateDictionary:dicTimeFlagAndLicense]) {
                        strTimeFlag = [[NSString alloc] initWithFormat:@"%@", [dicTimeFlagAndLicense objectForKey:timeFlagKey]];
                        strLicense = [[NSString alloc] initWithFormat:@"%@", [dicTimeFlagAndLicense objectForKey:driveLicenseKey]];
                    } else {
                        strTimeFlag = @"NO";
                        strLicense = @"C1";
                    }
                    
                    NSString *strStudentCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:studentCountKey]];
                    NSString *strOrderCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:orderKey]];
                    NSString *strTrainBaseCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:trainBaseKey]];
                    NSString *strLandMarkCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:landKey]];
                    NSString *strCoachCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:coachCountKey]];
                    
                    
                    [self setCoachCount:[strCoachCount integerValue]];
                    [self setTrainBaseCount:[strTrainBaseCount integerValue]];
                    [self setLandMarkCount:[strLandMarkCount integerValue]];
                    
                    iStudentCount = [strStudentCount integerValue];
                    iOrderCount = [strOrderCount integerValue];
                    
                    [[LyCurrentUser curUser] setTimeFlag:[strTimeFlag boolValue]];
                    if (LyUserType_school != [LyCurrentUser curUser].userType) {
                        [[LyCurrentUser curUser] setUserLicense:[LyUtil driveLicenseFromString:strLicense]];
                    }

                    
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
        default: {
            [self handleHttpFailed];
            break;
        }
    }
}


#pragma mark -LyHttpRequestDelegate
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest
{
    if (bHttpFlag) {
        bHttpFlag = NO;
        [self handleHttpFailed];
    }
    
    curHttpMethod = 0;
}

- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result
{
    if (bHttpFlag) {
        bHttpFlag = NO;
        curHttpMethod = ahttpRequest.mode;
        [self analysisHttpResult:result];
    }
    
    curHttpMethod = 0;
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tmtcellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch ([LyCurrentUser curUser].userType) {
        case LyUserType_normal: {
            break;
        }
        case LyUserType_coach: {
            if ([LyCurrentUser curUser].isBoss)
            {
                switch (indexPath.row) {
                    case 0: {
                        LyCoachManageTableViewController *coachManage = [[LyCoachManageTableViewController alloc] init];
                        [self.navigationController pushViewController:coachManage animated:YES];
                        break;
                    }
                    case 1: {
                        if ([LyUtil timeFlag]) {
                            if ([LyCurrentUser curUser].timeFlag) {
                                LyTimeTeachManageViewController *timeTeachManage = [[LyTimeTeachManageViewController alloc] init];
                                [self.navigationController pushViewController:timeTeachManage animated:YES];
                            } else {
                                [self showAlertViewForRemindOpenTimeFlag];
                            }
                        } else {
                            LyLandMarkManageViewController *landMarkManage = [[LyLandMarkManageViewController alloc] init];
                            [self.navigationController pushViewController:landMarkManage animated:YES];
                        }
                        break;
                    }
                    case 2: {
                        LyLandMarkManageViewController *landMarkManage = [[LyLandMarkManageViewController alloc] init];
                        [self.navigationController pushViewController:landMarkManage animated:YES];
                        break;
                    }
                    default:
                        break;
                }
            }
            else
            {
                switch (indexPath.row) {
                    case 0: {
                        if ([LyUtil timeFlag]) {
                            if ([LyCurrentUser curUser].timeFlag) {
                                LyTimeTeachManageViewController *timeTeachManage = [[LyTimeTeachManageViewController alloc] init];
                                [self.navigationController pushViewController:timeTeachManage animated:YES];
                            } else {
                                [self showAlertViewForRemindOpenTimeFlag];
                            }
                        } else {
                            LyLandMarkManageViewController *landMarkManage = [[LyLandMarkManageViewController alloc] init];
                            [self.navigationController pushViewController:landMarkManage animated:YES];
                        }
                        break;
                    }
                    case 1: {
                        LyLandMarkManageViewController *landMarkManage = [[LyLandMarkManageViewController alloc] init];
                        [self.navigationController pushViewController:landMarkManage animated:YES];
                        break;
                    }
                    default:
                        break;
                }
            }
            break;
        }
        case LyUserType_school: {
            switch (indexPath.row) {
                case 0: {
                    LyCoachManageTableViewController *coachManage = [[LyCoachManageTableViewController alloc] init];
                    [self.navigationController pushViewController:coachManage animated:YES];
                    break;
                }
                case 1: {
                    if ([LyUtil timeFlag]) {
                        if ([LyCurrentUser curUser].timeFlag) {
//                            LyTimeTeachManageViewController *timeTeachManage = [[LyTimeTeachManageViewController alloc] init];
//                            [self.navigationController pushViewController:timeTeachManage animated:YES];
                            LyPriceDetailViewController *priceDetail = [[LyPriceDetailViewController alloc] init];
                            [self.navigationController pushViewController:priceDetail animated:YES];
                        } else {
                            [self showAlertViewForRemindOpenTimeFlag];
                        }
                    } else {
                        LyTrainBaseManageTableViewController *trainBaseManage = [[LyTrainBaseManageTableViewController alloc] init];
                        [self.navigationController pushViewController:trainBaseManage animated:YES];
                    }
                    break;
                }
                case 2: {
                    if ([LyUtil timeFlag]) {
                        LyTrainBaseManageTableViewController *trainBaseManage = [[LyTrainBaseManageTableViewController alloc] init];
                        [self.navigationController pushViewController:trainBaseManage animated:YES];
                    } else {
                        LyLandMarkManageViewController *landMarkManage = [[LyLandMarkManageViewController alloc] init];
                        [self.navigationController pushViewController:landMarkManage animated:YES];
                    }
                    break;
                }
                case 3: {
                    LyLandMarkManageViewController *landMarkManage = [[LyLandMarkManageViewController alloc] init];
                    [self.navigationController pushViewController:landMarkManage animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case LyUserType_guider: {
            switch (indexPath.row) {
                case 0: {
                    if ([LyUtil timeFlag]) {
                        LyTimeTeachManageViewController *timeTeachManage = [[LyTimeTeachManageViewController alloc] init];
                        [self.navigationController pushViewController:timeTeachManage animated:YES];
                    } else {
                        LyLandMarkManageViewController *landMarkManage = [[LyLandMarkManageViewController alloc] init];
                        [self.navigationController pushViewController:landMarkManage animated:YES];
                    }
                    break;
                }
                case 1: {
                    LyLandMarkManageViewController *landMarkManage = [[LyLandMarkManageViewController alloc] init];
                    [self.navigationController pushViewController:landMarkManage animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger iCount = 0;
    
    switch ([LyCurrentUser curUser].userType) {
        case LyUserType_normal: {
            break;
        }
        case LyUserType_coach: {
            if ([LyCurrentUser curUser].isBoss) {
                iCount = 2;
            } else {
                iCount = 1;
            }
            break;
        }
        case LyUserType_school: {
            iCount = 3;
            break;
        }
        case LyUserType_guider: {
            iCount = 1;
            break;
        }
    }
    
    if ([LyUtil timeFlag]) {
        iCount++;
    }
    
    return iCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyTeachManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LyTeacherManageTvInfosCellReuseIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[LyTeachManageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LyTeacherManageTvInfosCellReuseIdentifier];
    }
    UIImage  *ivIcon = nil;
    NSString *strTitle = nil;
    NSString *strDetail = nil;
    
    switch ([LyCurrentUser curUser].userType) {
        case LyUserType_normal: {
            break;
        }
        case LyUserType_coach: {
            if ([[LyCurrentUser curUser] isBoss]) {
                switch (indexPath.row) {
                    case 0: {
                        ivIcon = [LyUtil imageForImageName:@"tm_coach" needCache:NO];
                        strTitle = @"教练管理";
                        strDetail = curCoachCount;
                        break;
                    }
                    case 1: {
                        if ([LyUtil timeFlag]) {
                            ivIcon = [LyUtil imageForImageName:@"tm_timeTeach" needCache:NO];
                            strTitle = @"计时培训";
                            if ([LyCurrentUser curUser].timeFlag) {
                                strDetail = timeTeachDetailAvailable;
                            } else {
                                strDetail = timeTeachDetailUnavailable;
                            }
                        } else {
                            ivIcon = [LyUtil imageForImageName:@"tm_landMark" needCache:NO];
                            strTitle = @"地标管理";
                            strDetail = curLandMarkCount;
                        }
                        break;
                    }
                    case 2: {
                        ivIcon = [LyUtil imageForImageName:@"tm_landMark" needCache:NO];
                        strTitle = @"地标管理";
                        strDetail = curLandMarkCount;
                        break;
                    }
                    default: {
                        break;
                    }
                }
            } else {
                switch (indexPath.row) {
                    case 0: {
                        if ([LyUtil timeFlag]) {
                            ivIcon = [LyUtil imageForImageName:@"tm_timeTeach" needCache:NO];
                            strTitle = @"计时培训";
                            if ([LyCurrentUser curUser].timeFlag) {
                                strDetail = timeTeachDetailAvailable;
                            } else {
                                strDetail = timeTeachDetailUnavailable;
                            }
                        } else {
                            ivIcon = [LyUtil imageForImageName:@"tm_landMark" needCache:NO];
                            strTitle = @"地标管理";
                            strDetail = curLandMarkCount;
                        }
                        break;
                    }
                    case 1: {
                        ivIcon = [LyUtil imageForImageName:@"tm_landMark" needCache:NO];
                        strTitle = @"地标管理";
                        strDetail = curLandMarkCount;
                        break;
                    }
                    default:
                        break;
                }
            }
            break;
        }
        case LyUserType_school: {
            switch (indexPath.row) {
                case 0: {
                    ivIcon = [LyUtil imageForImageName:@"tm_coach" needCache:NO];
                    strTitle = @"教练管理";
                    strDetail = curCoachCount;
                    break;
                }
                case 1: {
                    if ([LyUtil timeFlag]) {
                        ivIcon = [LyUtil imageForImageName:@"tm_timeTeach" needCache:NO];
                        strTitle = @"计时培训";
                        if ([LyCurrentUser curUser].timeFlag) {
                            strDetail = timeTeachDetailAvailable;
                        } else {
                            strDetail = timeTeachDetailUnavailable;
                        }
                    } else {
                        ivIcon =  [LyUtil imageForImageName:@"tm_trainBase" needCache:NO];
                        strTitle = @"基地管理";
                        strDetail = curTrainBaseCount;
                    }
                    break;
                }
                case 2: {
                    if ([LyUtil timeFlag]) {
                        ivIcon =  [LyUtil imageForImageName:@"tm_trainBase" needCache:NO];
                        strTitle = @"基地管理";
                        strDetail = curTrainBaseCount;
                    } else {
                        ivIcon = [LyUtil imageForImageName:@"tm_landMark" needCache:NO];
                        strTitle = @"地标管理";
                        strDetail = curLandMarkCount;
                    }
                    
                    break;
                }
                case 3: {
                    ivIcon = [LyUtil imageForImageName:@"tm_landMark" needCache:NO];
                    strTitle = @"地标管理";
                    strDetail = curLandMarkCount;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case LyUserType_guider: {
            switch (indexPath.row) {
                case 0: {
                    if ([LyUtil timeFlag]) {
                        ivIcon = [LyUtil imageForImageName:@"tm_timeTeach" needCache:NO];
                        strTitle = @"计时培训";
                        if ([LyCurrentUser curUser].timeFlag) {
                            strDetail = timeTeachDetailAvailable;
                        } else {
                            strDetail = timeTeachDetailUnavailable;
                        }
                    } else {
                        ivIcon = [LyUtil imageForImageName:@"tm_landMark" needCache:NO];
                        strTitle = @"地标管理";
                        strDetail = curLandMarkCount;
                    }
                    break;
                }
                case 1: {
                    ivIcon = [LyUtil imageForImageName:@"tm_landMark" needCache:NO];
                    strTitle = @"地标管理";
                    strDetail = curLandMarkCount;
                    break;
                }
                default:
                    break;
            }
            break;
        }
    }
    
    [cell setCellInfo:ivIcon
                title:strTitle
               detail:strDetail];
    
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
