//
//  LyMyNewsTableViewController.m
//  teacher
//
//  Created by Junes on 16/9/2.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyMyNewsTableViewController.h"
#import "LyNewsTableViewCell.h"
#import "LyTableViewFooterView.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyUserManager.h"
#import "LyNewsManager.h"

#import "LyUtil.h"


#import "LyEvaluateNewsViewController.h"
#import "LySendNewsViewController.h"
#import "LyNewsDetailViewController.h"

typedef NS_ENUM(NSInteger, LyMyNewsBarButtonItemTag) {
    myNewsBarButtonItemTag_add = 0,
};

typedef NS_ENUM(NSInteger, LyMyNewsRemindViewTag) {
    myNewsRemindViewTag_tansmit = 20,
};

typedef NS_ENUM(NSInteger, LyMyNewsHttpMethod) {
    myNewsHttpMethod_load = 100,
    myNewsHttpMethod_loadMore,
    myNewsHttpMethod_delete,
    myNewsHttpMethod_praise,
    myNewsHttpMethod_depraise,
    myNewsHttpMethod_transmit
};


@interface LyMyNewsTableViewController () <LySendNewsViewControllerDelegate, LyNewsTableViewCellDelegate, LyNewsDetailViewControllerDelegate, LyEvaluateNewsViewControllerDelegate, LyTableViewFooterViewDelegate, LyRemindViewDelegate, LyHttpRequestDelegate>
{
    UIView                      *viewError;
    UIView                      *viewNull;
    LyTableViewFooterView       *tvFooterView;
    
    NSArray                     *arrNews;
    NSIndexPath                 *curIdx;
    
    LyIndicator                 *indicator;
    LyIndicator                 *indicator_oper;
    BOOL                        bHttpFlag;
    LyMyNewsHttpMethod          curHttpMethod;
}
@end

@implementation LyMyNewsTableViewController

static NSString *const lyMyNewsTvCellReuseIdentifier = @"lyMyNewsTvCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"我的动态";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                           target:self
                                                                           action:@selector(targetForBarButtonItem:)];
    [self.navigationItem setRightBarButtonItem:right];
    
    self.refreshControl = [LyUtil refreshControlWithTitle:nil target:self action:@selector(refresh:)];
    tvFooterView = [LyTableViewFooterView tableViewFooterViewWithDelegate:self];
    [self.tableView setTableFooterView:tvFooterView];
}



- (void)viewWillAppear:(BOOL)animated {
    if (!arrNews || arrNews.count < 1) {
        [self load];
    } else {
        arrNews = [[LyNewsManager sharedInstance] getNewsWithUserId:[LyCurrentUser curUser].userId];
        [self reloadViewData];
    }
}


- (void)reloadViewData {
    [self removeViewError];
    [self removeViewNull];
    
    [self.tableView reloadData];
}


- (void)showViewError {
    if (!viewError) {
        viewError = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.2f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewError addSubview:[LyUtil lbErrorWithMode:0]];
    }
    
    [self.tableView addSubview:viewError];
    [self.tableView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.05f)];
}

- (void)removeViewError {
    [viewError removeFromSuperview];
    viewError = nil;
}

- (void)showViewNull {
    if (!viewNull) {
        viewNull = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.2f)];
        [viewNull setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewNull addSubview:[LyUtil lbNullWithText:@"还没有动态"]];
    }
    
    [self.tableView addSubview:viewNull];
    [self.tableView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.05f)];
}

- (void)removeViewNull {
    [viewNull removeFromSuperview];
    viewNull = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    if (myNewsBarButtonItemTag_add == bbi.tag) {
        LySendNewsViewController *sendNews = [[LySendNewsViewController alloc] init];
        [sendNews setDelegate:self];
        [self.navigationController pushViewController:sendNews animated:YES];
    }
}


- (void)refresh:(UIRefreshControl *)rc {
    [self load];
}


- (void)load {
    if ( !indicator) {
        indicator = [[LyIndicator alloc] initWithTitle:@""];
    }
    [indicator startAnimation];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:myNewsHttpMethod_load];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:getMyNews_url
                                          body:@{
                                                 startKey:@"0",
                                                 userIdKey:[LyCurrentUser curUser].userId,
                                                 sessionIdKey:[LyUtil httpSessionId]
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}

- (void)loadMore {
    [tvFooterView startAnimation];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:myNewsHttpMethod_loadMore];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:getMyNews_url
                                          body:@{
                                                 startKey:@(arrNews.count),
                                                 userIdKey:[LyCurrentUser curUser].userId,
                                                 sessionIdKey:[LyUtil httpSessionId]
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}

- (void)praise {

    LyNews *news = [arrNews objectAtIndex:curIdx.row];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:myNewsHttpMethod_praise];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:praise_url
                                          body:@{
                                                 objectIdKey:news.newsMasterId,
                                                 objectingIdKey:news.newsId,
                                                 masterIdKey:[LyCurrentUser curUser].userId,
                                                 sessionIdKey:[LyUtil httpSessionId],
                                                 userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
    
    
}


- (void)depraise {
    
    LyNews *news = [arrNews objectAtIndex:curIdx.row];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:myNewsHttpMethod_depraise];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:depraise_url
                                    body:@{
                                                 objectIdKey:news.newsMasterId,
                                                 objectingIdKey:news.newsId,
                                                 userIdKey:[LyCurrentUser curUser].userId,
                                                 masterIdKey:[LyCurrentUser curUser].userId,
                                                 sessionIdKey:[LyUtil httpSessionId],
                                                 userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}

- (void)transmit {
    
    if ( !indicator_oper) {
        indicator_oper = [LyIndicator indicatorWithTitle:LyIndicatorTitle_transmit];
    }
    [indicator_oper setTitle:LyIndicatorTitle_transmit];
    [indicator_oper startAnimation];
    
    LyNews *news = [arrNews objectAtIndex:curIdx.row];
    
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:myNewsHttpMethod_transmit];
    [httpRequest setDelegate:self];
    bHttpFlag = [httpRequest startHttpRequest:statusTransmit_url
                                         body:@{
                                                newsIdKey:news.newsId,
                                                objectIdKey:news.newsMasterId,
                                                userIdKey:[LyCurrentUser curUser].userId,
                                                nickNameKey:[LyCurrentUser curUser].userName,
                                                sessionIdKey:[LyUtil httpSessionId],
                                                objectNameKey:[LyCurrentUser curUser].userName,
                                                userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                                }
                                         type:LyHttpType_asynPost
                                      timeOut:0];
}

- (void)delete {
    
    LyNews *news = [arrNews objectAtIndex:curIdx.row];
    if ( !news) {
        return;
    }
    
    if ( !indicator_oper) {
        indicator_oper = [LyIndicator indicatorWithTitle:LyIndicatorTitle_delete];
    } else {
        [indicator_oper setTitle:LyIndicatorTitle_delete];
    }
    [indicator_oper startAnimation];
    
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:myNewsHttpMethod_delete];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:deleteNews_url
                                          body:@{
                                                 newsIdKey:news.newsId,
                                                 userIdKey:[LyCurrentUser curUser].userId,
                                                 sessionIdKey:[LyUtil httpSessionId],
                                                 userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}


- (void)handleHttpFailed {
    if ([indicator isAnimating]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        [self showViewError];
    }
    
    if ([indicator_oper isAnimating]) {
        [indicator_oper stopAnimation];
        if ( [[indicator_oper title] isEqualToString:LyIndicatorTitle_delete]) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"删除失败"] show];
        }
        else if ( [[indicator_oper title] isEqualToString:LyIndicatorTitle_transmit]) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"转发失败"] show];
        }
    }
    
    if ([tvFooterView isAnimating]) {
        [tvFooterView stopAnimation];
    }
    
    [tvFooterView setStatus:LyTableViewFooterViewStatus_error];
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
        [indicator_oper stopAnimation];
        [self.refreshControl endRefreshing];
        
        [LyUtil sessionTimeOut:self];
        return;
    }
    
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        [indicator_oper stopAnimation];
        [self.refreshControl endRefreshing];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch (curHttpMethod) {
        case myNewsHttpMethod_load: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (!arrResult || ![LyUtil validateArray:arrResult]) {
                        [indicator stopAnimation];
                        [self.refreshControl endRefreshing];
                        [tvFooterView stopAnimation];
                        [tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                        return;
                    }
                    
                    for (NSDictionary *dicItem in arrResult) {
                        
                        if (![LyUtil validateDictionary:dicItem]) {
                            continue;
                        }
                        
                        NSString *strId = [dicItem objectForKey:newsIdKey];
                        NSString *strTime = [dicItem objectForKey:newsTimeKey];
                        NSString *strContent = [dicItem objectForKey:newsContentKey];
                        NSString *strPraiseCount = [dicItem objectForKey:newsPraiseCountKey];
                        NSString *strEvalutionCount = [dicItem objectForKey:newsEvalutionCountKey];
                        NSString *strTransmitCount = [dicItem objectForKey:newsTransmitCountKey];
                        NSString *strPraiseFlag = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:newsPraiseFlagKey]];
                        
                        NSString *strMasterId = [dicItem objectForKey:newsMasterIdKey];
                        NSString *strMasterName = [dicItem objectForKey:nickNameKey];
                        
                        if (![LyUtil validateString:strMasterId]) {
                            continue;
                        }
                        
                        
                        strTime = [LyUtil fixDateTimeString:strTime];
                        
                        if ([strMasterId isEqualToString:[LyCurrentUser curUser].userId]) {
                            //是当前用户，不用做任何操作
                        } else {
                            LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:strMasterId];
                            NSString *strMasterType = [dicItem objectForKey:userTypeKey];
                            LyUserType masterUserType = [LyUtil userTypeFromString:strMasterType];
                            if ( !user || user.userType != masterUserType) {
                                
                                if (![LyUtil validateString:strMasterName]) {
                                    strMasterName = [LyUtil getUserNameWithUserId:strMasterId];
                                }
                                
                                switch (masterUserType) {
                                    case LyUserType_normal: {
                                        user = [LyUser userWithId:strMasterId
                                                         userNmae:strMasterName];
                                        break;
                                    }
                                    case LyUserType_coach: {
                                        LyCoach *coach = [LyCoach coachWithId:strMasterId
                                                                      coaName:strMasterName];
                                        user = coach;
                                        break;
                                    }
                                    case LyUserType_school: {
                                        LyDriveSchool *school = [LyDriveSchool driveSchoolWithId:strMasterId
                                                                                        dschName:strMasterName];
                                        user = school;
                                        break;
                                    }
                                    case LyUserType_guider: {
                                        LyGuider *guider = [LyGuider guiderWithGuiderId:strMasterId
                                                                                guiName:strMasterName];
                                        user = guider;
                                        break;
                                    }
                                    default: {
                                        user = [LyUser userWithId:strMasterId
                                                         userNmae:strMasterName];
                                        break;
                                    }
                                }
                                
                                [[LyUserManager sharedInstance] addUser:user];
                            }
                        }
                        
                        LyNews *news = [[LyNewsManager sharedInstance] getNewsWithNewsId:strId];
                        if (!news) {
                            news = [LyNews newsWithId:strId
                                             masterId:strMasterId
                                                 time:strTime
                                              content:strContent
                                        transmitCount:strTransmitCount.intValue
                                      evaluationCount:strEvalutionCount.intValue
                                          praiseCount:strPraiseCount.intValue];
                            
                            [news setPraise:strPraiseFlag.boolValue];
                            
                            NSArray *arrImageUrl = [dicItem objectForKey:imageUrlKey];
                            if ([LyUtil validateArray:arrImageUrl]) {
                                for (int i = 0; i < arrImageUrl.count; ++i) {
                                    NSString *strImageUrl = nil;
                                    id idImageUrl = [arrImageUrl objectAtIndex:i];
                                    if ([idImageUrl isKindOfClass:[NSString class]]) {
                                        strImageUrl = (NSString *)idImageUrl;
                                    } else if ([idImageUrl isKindOfClass:[NSDictionary class]]) {
                                        NSDictionary *dicImageUrl = (NSDictionary *)idImageUrl;
                                        strImageUrl = [dicImageUrl objectForKey:imageUrlKey];
                                    }
                                    
                                    if ([strImageUrl rangeOfString:@"http://"].length < 1 && [strImageUrl rangeOfString:@"https://"].length < 1) {
                                        strImageUrl = [[NSString alloc] initWithFormat:@"%@%@", httpFix, strImageUrl];
                                    }
                                    
                                    [news addPic:nil picUrl:strImageUrl index:i];
                                }
                            }
                            
                            
                            [[LyNewsManager sharedInstance] addNews:news];
                            
                        } else {
                            [news setPraise:strPraiseFlag.boolValue];
                            [news setNewsTransmitCount:strTransmitCount.intValue];
                            [news setNewsEvaluationCount:strEvalutionCount.intValue];
                            [news setNewsPraiseCount:strEvalutionCount.intValue];
                        }
                        
                    }
                    
                    arrNews = [[LyNewsManager sharedInstance] getNewsWithUserId:[LyCurrentUser curUser].userId];
                    
                    [self reloadViewData];
                    
                    [indicator stopAnimation];
                    [self.refreshControl endRefreshing];
                    if ( [tvFooterView isAnimating]) {
                        [tvFooterView stopAnimation];
                        [tvFooterView setStatus:LyTableViewFooterViewStatus_normal];
                    }
                    
                    [self removeViewNull];
                    [self removeViewError];
                    
                    break;
                }
                    
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case myNewsHttpMethod_loadMore: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (!arrResult || ![LyUtil validateArray:arrResult]) {
                        [indicator stopAnimation];
                        [self.refreshControl endRefreshing];
                        [tvFooterView stopAnimation];
                        [tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                        return;
                    }
                    
                    for (NSDictionary *dicItem in arrResult) {
                        
                        if (![LyUtil validateDictionary:dicItem]) {
                            continue;
                        }
                        
                        NSString *strId = [dicItem objectForKey:newsIdKey];
                        NSString *strTime = [dicItem objectForKey:newsTimeKey];
                        NSString *strContent = [dicItem objectForKey:newsContentKey];
                        NSString *strPraiseCount = [dicItem objectForKey:newsPraiseCountKey];
                        NSString *strEvalutionCount = [dicItem objectForKey:newsEvalutionCountKey];
                        NSString *strTransmitCount = [dicItem objectForKey:newsTransmitCountKey];
                        NSString *strPraiseFlag = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:newsPraiseFlagKey]];
                        
                        NSString *strMasterId = [dicItem objectForKey:newsMasterIdKey];
                        NSString *strMasterName = [dicItem objectForKey:nickNameKey];
                        
                        if (![LyUtil validateString:strMasterId]) {
                            continue;
                        }
                        
                        strTime = [LyUtil fixDateTimeString:strTime];
                        
                        if ([strMasterId isEqualToString:[LyCurrentUser curUser].userId]) {
                            //是当前用户，不用做任何操作
                        } else {
                            LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:strMasterId];
                            NSString *strMasterType = [dicItem objectForKey:userTypeKey];
                            LyUserType masterUserType = [LyUtil userTypeFromString:strMasterType];
                            if ( !user || user.userType != masterUserType) {
                                
                                if (![LyUtil validateString:strMasterName]) {
                                    strMasterName = [LyUtil getUserNameWithUserId:strMasterId];
                                }
                                
                                switch (masterUserType) {
                                    case LyUserType_normal: {
                                        user = [LyUser userWithId:strMasterId
                                                         userNmae:strMasterName];
                                        break;
                                    }
                                    case LyUserType_coach: {
                                        LyCoach *coach = [LyCoach coachWithId:strMasterId
                                                                      coaName:strMasterName];
                                        user = coach;
                                        break;
                                    }
                                    case LyUserType_school: {
                                        LyDriveSchool *school = [LyDriveSchool driveSchoolWithId:strMasterId
                                                                                        dschName:strMasterName];
                                        user = school;
                                        break;
                                    }
                                    case LyUserType_guider: {
                                        LyGuider *guider = [LyGuider guiderWithGuiderId:strMasterId
                                                                                guiName:strMasterName];
                                        user = guider;
                                        break;
                                    }
                                    default: {
                                        user = [LyUser userWithId:strMasterId
                                                         userNmae:strMasterName];
                                        break;
                                    }
                                }
                                
                                [[LyUserManager sharedInstance] addUser:user];
                            }
                        }
                        
                        LyNews *news = [[LyNewsManager sharedInstance] getNewsWithNewsId:strId];
                        if (!news) {
                            news = [LyNews newsWithId:strId
                                             masterId:strMasterId
                                                 time:strTime
                                              content:strContent
                                        transmitCount:strTransmitCount.intValue
                                      evaluationCount:strEvalutionCount.intValue
                                          praiseCount:strPraiseCount.intValue];
                            
                            [news setPraise:strPraiseFlag.boolValue];
                            
                            NSArray *arrImageUrl = [dicItem objectForKey:imageUrlKey];
                            if ([LyUtil validateArray:arrImageUrl]) {
                                for (int i = 0; i < arrImageUrl.count; ++i) {
                                    NSString *strImageUrl = nil;
                                    id idImageUrl = [arrImageUrl objectAtIndex:i];
                                    if ([idImageUrl isKindOfClass:[NSString class]]) {
                                        strImageUrl = (NSString *)idImageUrl;
                                    } else if ([idImageUrl isKindOfClass:[NSDictionary class]]) {
                                        NSDictionary *dicImageUrl = (NSDictionary *)idImageUrl;
                                        strImageUrl = [dicImageUrl objectForKey:imageUrlKey];
                                    }
                                    
                                    if ([strImageUrl rangeOfString:@"http://"].length < 1 && [strImageUrl rangeOfString:@"https://"].length < 1) {
                                        strImageUrl = [[NSString alloc] initWithFormat:@"%@%@", httpFix, strImageUrl];
                                    }
                                    
                                    [news addPic:nil picUrl:strImageUrl index:i];
                                }
                            }
                            
                            
                            [[LyNewsManager sharedInstance] addNews:news];
                            
                        } else {
                            [news setPraise:strPraiseFlag.boolValue];
                            [news setNewsTransmitCount:strTransmitCount.intValue];
                            [news setNewsEvaluationCount:strEvalutionCount.intValue];
                            [news setNewsPraiseCount:strEvalutionCount.intValue];
                        }
                        
                    }
                    
                    arrNews = [[LyNewsManager sharedInstance] getNewsWithUserId:[LyCurrentUser curUser].userId];
                    
                    [self reloadViewData];
                    
                    [indicator stopAnimation];
                    [self.refreshControl endRefreshing];
                    if ( [tvFooterView isAnimating]) {
                        [tvFooterView stopAnimation];
                    }
                    
                    [tvFooterView setStatus:LyTableViewFooterViewStatus_normal];
                    
                    
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case myNewsHttpMethod_delete: {
            switch ( [strCode integerValue]) {
                case 0: {
                    LyNews *news = [arrNews objectAtIndex:curIdx.row];
                    [[LyNewsManager sharedInstance] deleteNews:news];
                    
                    arrNews = [[LyNewsManager sharedInstance] getNewsWithUserId:[LyCurrentUser curUser].userId];
                    [self reloadViewData];
                    
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"删除成功"] show];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case myNewsHttpMethod_praise: {
            switch ( [strCode integerValue]) {
                case 0: {
                    NSLog(@"点赞成功");
                    break;
                }
                default: {
                    NSLog(@"点赞失败");
                    break;
                }
            }
            break;
        }
        case myNewsHttpMethod_depraise: {
            switch ( [strCode integerValue]) {
                case 0: {
                    NSLog(@"取消赞成功");
                    break;
                }
                    
                default: {
                    NSLog(@"取消赞失败");
                    break;
                }
            }
            break;
        }
        case myNewsHttpMethod_transmit: {
            switch ( [strCode integerValue]) {
                case 0: {
                    LyNews *news = [arrNews objectAtIndex:curIdx.row];
                    [news setNewsTransmitCount:news.newsTransmitCount + 1];
                    
                    
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [indicator_oper stopAnimation];
                        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"转发失败"] show];
                        return;
                    }
                    
                    
                    NSString *strId = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:newsIdKey]];
                    NSString *strTime = [dicResult objectForKey:newsTimeKey];
                    NSString *strContent = [dicResult objectForKey:contentKey];
                    NSString *strPicCount = [dicResult objectForKeyedSubscript:picCountKey];
                    
                    
                    if (![LyUtil validateString:strTime]) {
                        strTime = [[LyUtil dateFormatterForAll] stringFromDate:[NSDate date]];
                    }
                    
                    if ( strTime.length < 20) {
                        strTime = [strTime stringByAppendingString:@" +0800"];
                    }
                    
                    LyNews *newNews = [LyNews newsWithId:strId
                                                masterId:[LyCurrentUser curUser].userId
                                                    time:strTime
                                                 content:strContent
                                           transmitCount:0
                                         evaluationCount:0
                                             praiseCount:0];
                    
                    NSArray *arrImageUrl = [dicResult objectForKey:imageUrlKey];
                    if ([LyUtil validateArray:arrImageUrl]) {
                        for (int i = 0; i < arrImageUrl.count; ++i) {
                            NSString *strImageUrl = nil;
                            id idImageUrl = [arrImageUrl objectAtIndex:i];
                            if ([idImageUrl isKindOfClass:[NSString class]]) {
                                strImageUrl = (NSString *)idImageUrl;
                            } else if ([idImageUrl isKindOfClass:[NSDictionary class]]) {
                                NSDictionary *dicImageUrl = (NSDictionary *)idImageUrl;
                                strImageUrl = [dicImageUrl objectForKey:imageUrlKey];
                            }
                            
                            if ([strImageUrl rangeOfString:@"http://"].length < 1 && [strImageUrl rangeOfString:@"https://"].length < 1) {
                                strImageUrl = [[NSString alloc] initWithFormat:@"%@%@", httpFix, strImageUrl];
                            }
                            
                            [news addPic:nil picUrl:strImageUrl index:i];
                        }
                    }
                    
                    [[LyNewsManager sharedInstance] addNews:newNews];
                    
                    arrNews = [[LyNewsManager sharedInstance] getNewsWithUserId:[LyCurrentUser curUser].userId];
                    
                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"转发成功"];
                    [remind setDelegate:self];
                    [remind setTag:myNewsRemindViewTag_tansmit];
                    [remind show];
                    break;
                }
                    
                case 1: {
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"转发失败"] show];
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



#pragma mark -LyTableViewFooterViewDelegate
- (void)loadMoreData:(LyTableViewFooterView *)tableViewFooterView {
    [self loadMore];
}


#pragma mark -LyNewsTableViewCellDelegate
//- (void)onClickedForUserByNewsTVC:(LyNewsTableViewCell *)aCell {
//    curIdx = [self.tableView indexPathForCell:aCell];
//    
//    LyUserDetailViewController *userDetail = [[LyUserDetailViewController alloc] init];
//    [userDetail setHidesBottomBarWhenPushed:YES];
//    [userDetail setDelegate:self];
//    [self.navigationController pushViewController:userDetail animated:YES];
//}

- (void)onClickedForDetailByNewsTVC:(LyNewsTableViewCell *)aCell {
    curIdx = [self.tableView indexPathForCell:aCell];
    
    LyNewsDetailViewController *statusDetail = [[LyNewsDetailViewController alloc] init];
    [statusDetail setHidesBottomBarWhenPushed:YES];
    [statusDetail setDelegate:self];
    [self.navigationController pushViewController:statusDetail animated:YES];
}


- (void)onClickedForPraiseByNewsTVC:(LyNewsTableViewCell *)aCell {
    curIdx = [self.tableView indexPathForCell:aCell];
    
    if (aCell.news.isPraised) {
        [self depraise];
//        [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"你已经赞过该动态"] show];
    } else {
        [self praise];
    }
    
    [aCell.news praise];
    [self.tableView reloadRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)onClickedForEvaluateByNewsTVC:(LyNewsTableViewCell *)aCell {
    curIdx = [self.tableView indexPathForCell:aCell];
    
    LyEvaluateNewsViewController *evaluateNewsVC = [[LyEvaluateNewsViewController alloc] init];
    [evaluateNewsVC setHidesBottomBarWhenPushed:YES];
    [evaluateNewsVC setDelegate:self];
    UINavigationController *evaluateNewsNC = [[UINavigationController alloc] initWithRootViewController:evaluateNewsVC];
    [self presentViewController:evaluateNewsNC animated:YES completion:nil];
}

- (void)onCLickedForTransmitByNewsTVC:(LyNewsTableViewCell *)aCell {
    
    curIdx = [self.tableView indexPathForCell:aCell];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你确定要转发这条动态吗？"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"转发"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self transmit];
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)onClickedForDeleteByNewsTVC:(LyNewsTableViewCell *)aCell {
    curIdx = [self.tableView indexPathForCell:aCell];
    
    if ( [LyCurrentUser curUser].isLogined && [aCell.news.newsMasterId isEqualToString:[LyCurrentUser curUser].userId]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除动态"
                                                                       message:@"你确定要删除这条动态吗？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
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


- (void)needRefresh:(LyNewsTableViewCell *)aCell {
    [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:aCell]] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark -LyremindViewdelegate
- (void)remindViewWillHide:(LyRemindView *)aRemind {
    if ( myNewsRemindViewTag_tansmit == [aRemind tag]) {
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0, 0)];
    }
}



#pragma mark -LySendNewsViewControllerDelegate
- (void)onDoneBySendNewsVC:(LySendNewsViewController *)aSendNewsVC {
    [aSendNewsVC.navigationController popViewControllerAnimated:YES];
    
    arrNews = [[LyNewsManager sharedInstance] getAllNews];
    [self.tableView reloadData];
}



#pragma mark -LyNewsDetailViewControllerDelegate
- (LyNews *)obtainNewsByNewsDetailVC:(LyNewsDetailViewController *)aNewsDetailVC {
    return [arrNews objectAtIndex:curIdx.row];
}


- (void)onDeleteByNewsDetailVC:(LyNewsDetailViewController *)aNewsDetailVC {
    [aNewsDetailVC.navigationController popViewControllerAnimated:YES];
    arrNews = [[LyNewsManager sharedInstance] getAllNews];
    
    [self.tableView reloadData];
}



#pragma mark -LyEvaluateNewsVieControllerDelegate
- (LyNews *)obtainNewsByEvaluateNewsVC:(LyEvaluateNewsViewController *)aEvaluateNewsVC {
    return [arrNews objectAtIndex:curIdx.row];
}

- (void)onDoneByEvaluateNewsVC:(LyEvaluateNewsViewController *)aEvaluateNewsVC {
    [aEvaluateNewsVC dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationNone];
    }];
}


#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyNews *news = [arrNews objectAtIndex:indexPath.row];
    if (news.cellHeight > 0) {
        return news.cellHeight;
    }
    
    LyNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyMyNewsTvCellReuseIdentifier];
    if (!cell) {
        cell = [[LyNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyMyNewsTvCellReuseIdentifier];
        
    }
    [cell setNews:news mode:LyNewsTableViewCellMode_community];
    
    return cell.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    LyNewsDetailViewController *statusDetail = [[LyNewsDetailViewController alloc] init];
//    [statusDetail setDelegate:self];
//    [self.navigationController pushViewController:statusDetail animated:YES];
    
    curIdx = indexPath;
    
    LyNewsDetailViewController *newsDetail = [[LyNewsDetailViewController alloc] init];
    [newsDetail setDelegate:self];
    [self.navigationController pushViewController:newsDetail animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!arrNews || arrNews.count < 1) {
        [self showViewNull];
    } else  {
        [self removeViewNull];
    }
    
    return arrNews.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyMyNewsTvCellReuseIdentifier];
    if ( !cell) {
        cell = [[LyNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyMyNewsTvCellReuseIdentifier];
    }
    [cell setNews:[arrNews objectAtIndex:indexPath.row] mode:LyNewsTableViewCellMode_community];
    [cell setDelegate:self];
    
    return cell;
}


#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ( scrollView == self.tableView) {
        if ([scrollView contentOffset].y + [scrollView frame].size.height + tvFooterViewDefaultHeight> [scrollView contentSize].height && [scrollView contentSize].height > [scrollView frame].size.height) {
            [tvFooterView startAnimation];
            [self loadMore];
        }
        
    }
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
