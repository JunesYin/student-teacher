//；
//  LyCommunityViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/11.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyCommunityViewController.h"

#import "RESideMenu.h"
#import "LyNewsTableViewCell.h"
#import "LyBottomControl.h"
#import "LyIndicator.h"
#import "LyTableViewFooterView.h"
#import "LyRemindView.h"


#import "LyNewsManager.h"
#import "LyUserManager.h"
#import "LyCurrentUser.h"



#import "LyUtil.h"


#import "student-Swift.h"
#import <WebKit/WebKit.h>


#import "LyLoginViewController.h"

#import "LyNewsDetailViewController.h"
#import "LySendNewsViewController.h"
#import "LyEvaluateNewsViewController.h"
#import "LyAboutMeTableViewController.h"

#import "LyUserDetailViewController.h"



#define comWidth                                SCREEN_WIDTH
#define comHeight                               SCREEN_HEIGHT


#define tvNewsWidth                             comWidth
#define tvNewsHeight                            (comHeight-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT)


typedef NS_ENUM(NSInteger, LyCommunityBarButtonItemTag) {
    communityBarButtonItemTag_msg = 10,
};


typedef NS_ENUM( NSInteger, LyCommunityRemindViewTag)
{
    communityRemindViewTag_transmit = 20,
};



typedef NS_ENUM( NSInteger, LyCommunityHttpMethod)
{
    communityHttpMethod_load = 100,
    communityHttpMethod_loadMore,
    
    communityHttpMethod_praise,
    communityHttpMethod_depraise,
    communityHttpMethod_transmit,
    communityHttpMethod_delete,
};


@interface LyCommunityViewController () < UITableViewDelegate, UITableViewDataSource, LyNewsTableViewCellDelegate, LyHttpRequestDelegate, LyTableViewFooterViewDelegate, LyEvaluateNewsViewControllerDelegate, LySendNewsViewControllerDelegate, LyNewsDetailViewControllerDelegate, LyUserDetailDelegate, LyRemindViewDelegate>
{
    BOOL                                flagLoad;
    
    UITableView                         *tvNews;
    UIRefreshControl                    *refresher;
    LyIndicator                         *indicator_load;
    LyIndicator                         *indicator_oper;
    LyTableViewFooterView               *tvFooterView;
    
    
//    CGFloat                             oldOffsetY;
//    CGFloat                             offsetY;
    
    
    NSArray                             *cyArrNews;
    
    NSIndexPath                         *curIdx;
//    NSString                            *lastStatusId;
    
    
//    NSInteger                           currentIndex;
    NSInteger                           countAboutMe;
    
    
    BOOL                                bHttpFlag;
    LyCommunityHttpMethod               curHttpMethod;
}
@end

@implementation LyCommunityViewController

static NSString *lyCommunityTableViewCellReuseIdentifier = @"lyCommunityTableViewCellReuseIdentifier";


lySingle_implementation(LyCommunityViewController)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initSubviews];
    
}




- (void)viewWillAppear:(BOOL)animated {
    if ( !flagLoad) {
        flagLoad = YES;
        [self refreshData:refresher];
    } else {
        cyArrNews = [[LyNewsManager sharedInstance] getAllNews];
        [tvNews reloadData];
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [[LyBottomControl sharedInstance] setHidden:NO];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}



- (void)viewWillDisappear:(BOOL)animated {
    [tvNews deselectRowAtIndexPath:curIdx animated:NO];
    
    [[LyBottomControl sharedInstance] setHidden:YES];
}


- (void)viewDidDisAppear:(BOOL)animated {
    [[LyBottomControl sharedInstance] setHidden:YES];
}




- (void)initSubviews {
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //    [[self.navigationController.navigationBar layer] setShadowColor:[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f] CGColor]];
//    [[self.navigationController.navigationBar layer] setShadowOffset:CGSizeMake( 0, 3.0f)];
//    [[self.navigationController.navigationBar layer] setShadowOpacity:0.5f];
//    [[self.navigationController.navigationBar layer] setShadowRadius:3.0f];

    
    
    self.title = @"驾考圈";
    
    UIBarButtonItem *bbiLeft_Menu = [LyUtil barButtonItem:0
                                                imageName:@"navigationBar_left"
                                                   target:self
                                                   action:@selector(presentLeftMenuViewController:)];
    UIBarButtonItem *bbiLeft_hyaline = [LyUtil barButtonItem:0
                                                   imageName:@"navigationBar_hyaline"
                                                      target:nil
                                                      action:nil];
    UIBarButtonItem *bbiRight_menu = [LyUtil barButtonItem:0
                                                 imageName:@"navigationBar_right"
                                                    target:self
                                                    action:@selector(presentRightMenuViewController:)];
    UIBarButtonItem *bbiRight_msg = [LyUtil barButtonItem:communityBarButtonItemTag_msg
                                                imageName:@"navigationBar_msg"
                                                   target:self
                                                   action:@selector(targetForBarButtonItem:)];
    
    
    [self.navigationItem setLeftBarButtonItems:@[bbiLeft_Menu, bbiLeft_hyaline]];
    [self.navigationItem setRightBarButtonItems:@[bbiRight_menu, bbiRight_msg]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];

    
    
    CGRect rectCyStatusList = CGRectMake( 0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, tvNewsWidth, tvNewsHeight);
    tvNews = [[UITableView alloc] initWithFrame:rectCyStatusList style:UITableViewStylePlain];
    [tvNews setDelegate:self];
    [tvNews setDataSource:self];
    [tvNews setScrollsToTop:YES];
    [tvNews setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    refresher = [[UIRefreshControl alloc] init];
    [refresher setTintColor:LyRefresherColor];
    NSMutableAttributedString *strRefresherTitle = [[NSMutableAttributedString alloc] initWithString:@"正在加载"];
    [strRefresherTitle addAttribute:NSForegroundColorAttributeName value:LyRefresherColor range:NSMakeRange( 0, [@"正在加载" length])];
    [refresher setAttributedTitle:strRefresherTitle];
    [refresher addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [tvNews addSubview:refresher];
    
    
    tvFooterView = [[LyTableViewFooterView alloc] initWithFrame:CGRectMake( 0, 0, CGRectGetWidth(tvNews.frame), tvFooterViewHeight)];
    [tvFooterView setDelegate:self];
    [tvNews setTableFooterView:tvFooterView];
    
    
    [self.view addSubview:tvNews];
    
    [[LyCurrentUser curUser] addObserver:self forKeyPath:@"userId" options:NSKeyValueObservingOptionNew context:nil];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"userId"]) {
        cyArrNews = [[LyNewsManager sharedInstance] getAllNews];
        
        [tvNews performSelector:@selector(reloadData) withObject:nil afterDelay:0.1f];
    }
}




- (void)openSendNewsViewController {
    LySendNewsViewController *sendNewsVC = [[LySendNewsViewController alloc] init];
    [sendNewsVC setDelegate:self];
    
    if ([LyCurrentUser curUser].isLogined) {
        [self.navigationController pushViewController:sendNewsVC animated:YES];
    } else {
        [LyUtil showLoginVc:self nextVC:sendNewsVC showMode:LyShowVcMode_push];
    }
    
}


- (void)openOboutMeTableViewController {
    LyAboutMeTableViewController *aboutme = [[LyAboutMeTableViewController alloc] init];
    
    if ([LyCurrentUser curUser].isLogined) {
        [self.navigationController pushViewController:aboutme animated:YES];
    } else {
        [LyUtil showLoginVc:self nextVC:aboutme showMode:LyShowVcMode_push];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(targetForBarButtonItem:) object:bbi];
        
        return;
    }
    
    LyCommunityBarButtonItemTag bbiTag = (LyCommunityBarButtonItemTag)bbi.tag;
    switch (bbiTag) {
        case communityBarButtonItemTag_msg: {
            LyMsgCenterTableViewController *msgCenter = [[LyMsgCenterTableViewController alloc] init];
            [self.navigationController pushViewController:msgCenter animated:YES];
            break;
        }
    }
}


- (void)setCountAboutMe {
    [[LyBottomControl sharedInstance] setCountAboutMe:countAboutMe];
}



- (void)refreshData:(UIRefreshControl *)refreshControl {
    [self loadData];
}



- (void)loadData {
    if ( !indicator_load) {
        indicator_load = [[LyIndicator alloc] initWithTitle:@""];
    }
    [indicator_load startAnimation];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(0) forKey:startKey];
    
    if ([LyCurrentUser curUser].isLogined) {
        [dic setObject:[LyCurrentUser curUser].userId forKey:userIdKey];
        [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    }
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:communityHttpMethod_load];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:getAllNews_url
                                  body:dic
                                  type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}



- (void)loadMoreData {
    
    [tvFooterView startAnimation];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(cyArrNews.count) forKey:startKey];
    
    if ([LyCurrentUser curUser].isLogined) {
        [dic setObject:[LyCurrentUser curUser].userId forKey:userIdKey];
        [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    }
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:communityHttpMethod_loadMore];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:getAllNews_url
                                   body:dic
                                   type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}




- (void)praise {
    
    LyNews *news = [cyArrNews objectAtIndex:curIdx.row];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:communityHttpMethod_praise];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:praise_url
                                          body:@{
                                                 objectIdKey:news.newsMasterId,
                                                 objectMasterIdKey:news.newsId,
                                                 masterIdKey:[LyCurrentUser curUser].userId,
                                                 sessionIdKey:[LyUtil httpSessionId],
                                                 userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}

- (void)depraise {
    LyNews *news = [cyArrNews objectAtIndex:curIdx.row];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:communityHttpMethod_depraise];
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
    
    
    LyNews *news = [cyArrNews objectAtIndex:curIdx.row];
    LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:news.newsMasterId];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:communityHttpMethod_transmit];
    [httpRequest setDelegate:self];
    bHttpFlag = [httpRequest startHttpRequest:statusTransmit_url
                                         body:@{
                                                newsIdKey:news.newsId,
                                                objectIdKey:news.newsMasterId,
                                                userIdKey:[LyCurrentUser curUser].userId,
                                                nickNameKey:[LyCurrentUser curUser].userName,
                                                sessionIdKey:[LyUtil httpSessionId],
                                                objectNameKey:user.userName,
                                                userTypeKey:userTypeStudentKey
                                                }
                                         type:LyHttpType_asynPost
                                      timeOut:0];
}


- (void)delete {
    if ( !indicator_oper) {
        indicator_oper = [LyIndicator indicatorWithTitle:LyIndicatorTitle_delete];
    }
    [indicator_oper setTitle:LyIndicatorTitle_delete];
    [indicator_oper startAnimation];
    
    LyNews *news = [cyArrNews objectAtIndex:curIdx.row];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:communityHttpMethod_delete];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:deleteNews_url
                                          body:@{
                                                 newsIdKey:news.newsId,
                                                 userIdKey:[LyCurrentUser curUser].userId,
                                                 sessionIdKey:[LyUtil httpSessionId],
                                                 userTypeKey:userTypeStudentKey
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}




- (void)handleHttpFailed {
    
    if ([indicator_load isAnimating]) {
        [indicator_load stopAnimation];
        [refresher endRefreshing];
        [tvFooterView setStatus:LyTableViewFooterViewStatus_error];
    }
    
    if ( [tvFooterView isAnimating]) {
        [tvFooterView stopAnimation];
        [tvFooterView setStatus:LyTableViewFooterViewStatus_error];
    }
    
    if ( [indicator_oper isAnimating]) {
        [indicator_oper stopAnimation];
        if ( [[indicator_oper title] isEqualToString:LyIndicatorTitle_delete]) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"删除失败"] show];
        } else if ( [[indicator_oper title] isEqualToString:LyIndicatorTitle_transmit]) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"转发失败"] show];
        }
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
    
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_load stopAnimation];
        [indicator_oper stopAnimation];
        [refresher endRefreshing];
        [tvFooterView stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch ( curHttpMethod) {
        case communityHttpMethod_load: {
            switch ( [strCode integerValue]) {
                case 0: {
                    
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [indicator_load stopAnimation];
                        [refresher endRefreshing];
                        [tvFooterView stopAnimation];
                        [tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                        return;
                    }
                    
                    NSDictionary *dicAbout = [dicResult objectForKey:aboutKey];
                    if (![LyUtil validateDictionary:dicAbout]) {
                        countAboutMe = 0;
                    } else {
                        NSString *strCountAboutMe = [dicAbout objectForKey:aboutMeKey];
                        countAboutMe = [strCountAboutMe integerValue];
                    }
                    
                    
                    NSArray *arrNewsss = [dicResult objectForKey:newsKey];
                    if (![LyUtil validateArray:arrNewsss]) {
                        [indicator_load stopAnimation];
                        if ( [refresher isRefreshing]) {
                            [refresher endRefreshing];
                        }
                        if ( [tvFooterView isAnimating]) {
                            [tvFooterView stopAnimation];
                            [tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                        }
                        return;
                    }
                    
                    
                    for (NSDictionary *dicItem in arrNewsss) {
                        
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
                    
                    
                    cyArrNews = [[LyNewsManager sharedInstance] getAllNews];
                    
                    
                    
                    [tvNews reloadData];
                    [self setCountAboutMe];
                    
                    [indicator_load stopAnimation];
                    [refresher endRefreshing];
                    if ( [tvFooterView isAnimating]) {
                        [tvFooterView stopAnimation];
                    }
                    [tvFooterView setStatus:LyTableViewFooterViewStatus_normal];
                    
                    break;
                }
                case 1: {
                    [self handleHttpFailed];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case communityHttpMethod_loadMore: {
            switch ( [strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [indicator_load stopAnimation];
                        if ( [refresher isRefreshing]) {
                            [refresher endRefreshing];
                        }
                        if ( [tvFooterView isAnimating]) {
                            [tvFooterView stopAnimation];
                        }
                        [tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                        
                        return;
                    }
                    
                    NSDictionary *dicAbout = [dicResult objectForKey:aboutKey];
                    if (![LyUtil validateDictionary:dicAbout]) {
                        countAboutMe = 0;
                    } else {
                        NSString *strCountAboutMe = [dicAbout objectForKey:aboutMeKey];
                        countAboutMe = [strCountAboutMe integerValue];
                    }
                    
                    NSArray *arrNewsss = [dicResult objectForKey:newsKey];
                    if (![LyUtil validateArray:arrNewsss]) {
                        if ( [tvFooterView isAnimating]) {
                            [tvFooterView stopAnimation];
                        }
                        if ( [indicator_oper isAnimating]) {
                            [indicator_oper stopAnimation];
                        }
                        [tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                        return;
                    }
                    
                    
                    for (NSDictionary *dicItem in arrNewsss) {
                        
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
                    
                    
                    cyArrNews = [[LyNewsManager sharedInstance] getAllNews];
                    
                    
                    [tvNews reloadData];
                    [self setCountAboutMe];
                    
                    if ( [refresher isRefreshing]) {
                        [refresher endRefreshing];
                    }
                    if ( [indicator_load isAnimating]) {
                        [indicator_load stopAnimation];
                    }
                    if ( [tvFooterView isAnimating]) {
                        [tvFooterView stopAnimation];
                    }
                    if ( [indicator_oper isAnimating]) {
                        [indicator_oper stopAnimation];
                    }
                    
                    [tvFooterView setStatus:LyTableViewFooterViewStatus_normal];
                    
                    break;
                }
                    
                default: {
                    
                    if ( [indicator_load isAnimating])
                    {
                        [indicator_load stopAnimation];
                    }
                    
                    if ( [refresher isRefreshing])
                    {
                        [refresher endRefreshing];
                    }
                    
                    if ( [indicator_oper isAnimating])
                    {
                        [indicator_oper stopAnimation];
                    }
                    if ( [tvFooterView isAnimating])
                    {
                        [tvFooterView stopAnimation];
                    }
                    
                    break;
                }
            }
            
            break;
        }
            
        case communityHttpMethod_praise: {
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
            
        case communityHttpMethod_depraise: {
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
            
        case communityHttpMethod_transmit: {
            switch ( [strCode integerValue]) {
                case 0: {
                    LyNews *news = [cyArrNews objectAtIndex:curIdx.row];
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
                    //                    NSString *strPicCount = [dicResult objectForKeyedSubscript:picCountKey];
                    
                    
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
                    
                    cyArrNews = [[LyNewsManager sharedInstance] getAllNews];
                    
                    [indicator_oper stopAnimation];
                    
                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"转发成功"];
                    [remind setDelegate:self];
                    [remind setTag:communityRemindViewTag_transmit];
                    [remind show];
                    break;
                }
                    
                case 1: {
                    [self handleHttpFailed];
                    break;
                }
                    
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case communityHttpMethod_delete: {
            curHttpMethod = 0;
            switch ( [strCode integerValue]) {
                case 0: {
                    LyNews *news = [cyArrNews objectAtIndex:curIdx.row];
                    [[LyNewsManager sharedInstance] deleteNews:news];
                    
                    cyArrNews = [[LyNewsManager sharedInstance] getAllNews];
                    
                    [tvNews reloadData];
                    
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



#pragma mark -LyNewsDetailViewControllerDelegate
- (LyNews *)obtainNewsByNewsDetailVC:(LyNewsDetailViewController *)aNewsDetailVC {
    return [cyArrNews objectAtIndex:curIdx.row];
}


- (void)onDeleteByNewsDetailVC:(LyNewsDetailViewController *)aNewsDetailVC {
    [aNewsDetailVC.navigationController popViewControllerAnimated:YES];
    cyArrNews = [[LyNewsManager sharedInstance] getAllNews];
    
    [tvNews reloadData];
}



#pragma mark -LySendNewsViewControllerDelegate
- (void)onDoneBySendNewsVC:(LySendNewsViewController *)aSendNewsVC {
    [aSendNewsVC.navigationController popViewControllerAnimated:YES];
    
    cyArrNews = [[LyNewsManager sharedInstance] getAllNews];
    [tvNews reloadData];
}


#pragma mark -LyEvaluateNewsVieControllerDelegate
- (LyNews *)obtainNewsByEvaluateNewsVC:(LyEvaluateNewsViewController *)aEvaluateNewsVC {
    return [cyArrNews objectAtIndex:curIdx.row];
}

- (void)onDoneByEvaluateNewsVC:(LyEvaluateNewsViewController *)aEvaluateNewsVC {
    [aEvaluateNewsVC dismissViewControllerAnimated:YES completion:^{
        [tvNews reloadRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationNone];
    }];
}



#pragma mark -LyUserDetailDelegate
- (NSString *)obtainUserId {
    return [[cyArrNews objectAtIndex:curIdx.row] newsMasterId];
}



#pragma mark -LyNewsTableViewCellDelegate
- (void)onClickedForUserByNewsTVC:(LyNewsTableViewCell *)aCell {
    curIdx = [tvNews indexPathForCell:aCell];
    
    LyUserDetailViewController *userDetail = [[LyUserDetailViewController alloc] init];
    [userDetail setDelegate:self];
    
    if ([LyCurrentUser curUser].isLogined) {
        [self.navigationController pushViewController:userDetail animated:YES];
    } else {
        [LyUtil showLoginVc:self nextVC:userDetail showMode:LyShowVcMode_push];
    }
}

- (void)onClickedForDetailByNewsTVC:(LyNewsTableViewCell *)aCell {
    curIdx = [tvNews indexPathForCell:aCell];
    
    LyNewsDetailViewController *statusDetail = [[LyNewsDetailViewController alloc] init];
    [statusDetail setDelegate:self];
    
    if ([LyCurrentUser curUser].isLogined) {
        [self.navigationController pushViewController:statusDetail animated:YES];
    } else {
        [LyUtil showLoginVc:self nextVC:statusDetail showMode:LyShowVcMode_push];
    }
}


- (void)onClickedForPraiseByNewsTVC:(LyNewsTableViewCell *)aCell {
    curIdx = [tvNews indexPathForCell:aCell];
    
    if ([LyCurrentUser curUser].isLogined) {
        if (aCell.news.isPraised) {
            [self depraise];
//            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"你已经赞过该动态"] show];
        } else {
            [self praise];
        }
        
        [aCell.news praise];
        [tvNews reloadRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationNone];
    } else {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(onClickedForPraiseByNewsTVC:) object:aCell];
    }
    
}

- (void)onClickedForEvaluateByNewsTVC:(LyNewsTableViewCell *)aCell {
    curIdx = [tvNews indexPathForCell:aCell];
    
    LyEvaluateNewsViewController *evaluateNewsVC = [[LyEvaluateNewsViewController alloc] init];
    [evaluateNewsVC setDelegate:self];
    UINavigationController *evaluateNewsNC = [[UINavigationController alloc] initWithRootViewController:evaluateNewsVC];
    if ([LyCurrentUser curUser].isLogined) {
        [self presentViewController:evaluateNewsNC animated:YES completion:nil];
    } else {
        [LyUtil showLoginVc:self nextVC:evaluateNewsNC showMode:LyShowVcMode_present];
    }
}

- (void)onCLickedForTransmitByNewsTVC:(LyNewsTableViewCell *)aCell {
    
    curIdx = [tvNews indexPathForCell:aCell];
    
    if ([LyCurrentUser curUser].isLogined) {
        UIAlertController *action = [UIAlertController alertControllerWithTitle:@"你确定要转发这条动态吗？"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
        [action addAction:[UIAlertAction actionWithTitle:@"取消"
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
        [action addAction:[UIAlertAction actionWithTitle:@"转发"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     [self transmit];
                                                 }]];
        [self presentViewController:action animated:YES completion:nil];
        
    } else {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(onCLickedForTransmitByNewsTVC:) object:aCell];
    }
    
}

- (void)onClickedForDeleteByNewsTVC:(LyNewsTableViewCell *)aCell {
    curIdx = [tvNews indexPathForCell:aCell];
    
    if ([LyCurrentUser curUser].isLogined) {
        if ([aCell.news.newsMasterId isEqualToString:[LyCurrentUser curUser].userId]) {
            
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
    } else {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(onClickedForDeleteByNewsTVC:) object:aCell];
    }
    
    
}


- (void)needRefresh:(LyNewsTableViewCell *)aCell {
    [tvNews reloadRowsAtIndexPaths:@[[tvNews indexPathForCell:aCell]] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark -LyRemindViewdelegate
- (void)remindViewDidHide:(LyRemindView *)aRemind {
    if ( communityRemindViewTag_transmit == aRemind.tag) {
        [tvNews reloadData];
        [tvNews setContentOffset:CGPointMake(0, 0)];
    }
}


#pragma mark -LyTableViewFooterViewDelegate
- (void)loadMoreData:(LyTableViewFooterView *)tableViewFooterView {
    [self loadMoreData];
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyNews *status = [cyArrNews objectAtIndex:indexPath.row];
    if (status.cellHeight > 0) {
        return status.cellHeight;
    }
    
    LyNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyCommunityTableViewCellReuseIdentifier];
    if (!cell) {
        cell = [[LyNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyCommunityTableViewCellReuseIdentifier];
    }
    
    [cell setNews:[cyArrNews objectAtIndex:indexPath.row] mode:LyNewsTableViewCellMode_community];
    
    return cell.cellHeight;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    curIdx = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    LyNewsDetailViewController *statusDetail = [[LyNewsDetailViewController alloc] init];
    [statusDetail setDelegate:self];
    
    if ([[LyCurrentUser curUser] isLogined]) {
        [self.navigationController pushViewController:statusDetail animated:YES];
    } else {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self nextVC:statusDetail showMode:LyShowVcMode_push];
    }
    
}




#pragma mark UITableViewDataSource相关
////返回每个分组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cyArrNews.count;
}


////生成每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LyNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyCommunityTableViewCellReuseIdentifier];
    if ( !cell) {
        cell = [[LyNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyCommunityTableViewCellReuseIdentifier];
    }
    
    [cell setNews:[cyArrNews objectAtIndex:indexPath.row] mode:LyNewsTableViewCellMode_community];
    [cell setDelegate:self];
    
    return cell;
}



#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ( scrollView == tvNews) {
        if ( [tvNews contentOffset].y > bottomControlHideCerticality) {
            [[LyBottomControl sharedInstance] setHidden:YES];
        } else {
            [[LyBottomControl sharedInstance] setHidden:NO];
        }
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == tvNews) {// && !decelerate) {
        if ( [scrollView contentOffset].y + [scrollView frame].size.height > [scrollView contentSize].height && [scrollView contentSize].height > [scrollView frame].size.height) {
            [self loadMoreData];
        }
    }
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
