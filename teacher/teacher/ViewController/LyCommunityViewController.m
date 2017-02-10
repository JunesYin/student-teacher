//
//  LyCommunityViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/11.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyCommunityViewController.h"

#import "UIButton+Num.h"
#import "RESideMenu.h"
#import "LyNewsTableViewCell.h"
#import "LyIndicator.h"
#import "LyTableViewFooterView.h"
#import "LyRemindView.h"


#import "LyNewsManager.h"
#import "LyUserManager.h"
#import "LyCurrentUser.h"



#import "LyUtil.h"



#import "teacher-Swift.h"

#import "LyLoginViewController.h"

#import "LyNewsDetailViewController.h"
#import "LySendNewsViewController.h"
#import "LyEvaluateNewsViewController.h"
#import "LyAboutMeTableViewController.h"

#import "LyUserDetailViewController.h"






#define tvNewsWidth                             comWidth
#define tvNewsHeight                            (SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-TABBAR_HEIGHT)



CGFloat const btnFuncSize = 50.0f;



typedef NS_ENUM(NSInteger, LyCommunityBarButtonItemTag) {
    communityBarButtonItemTag_leftMenu = 10,
    communityBarButtonItemTag_msg,
    communityBarButtonItemTag_rightMenu
};


typedef NS_ENUM( NSInteger, LyCommunityRemindViewTag) {
    communityRemindViewTag_delete = 20,
    communityRemindViewTag_transmit
};


enum {
    communityButtonMode_sendNews = 30,
    communityButtonMode_aboutMe
}LyCommunityButtonMode;


typedef NS_ENUM( NSInteger, LyCommunityHttpMethod) {
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
    
    
    
    UIButton                            *btnSendNews;
    UIButton                            *btnAboutMe;
    
    
    NSArray                             *cyArrNews;
    
    NSIndexPath                         *curIdx;
    
    
//    NSInteger                           currentIndex;
    NSInteger                           countAboutMe;
    
    
    BOOL                                bHttpFlag;
    LyCommunityHttpMethod               curHttpMethod;
}
@end

@implementation LyCommunityViewController

static NSString *const lyCommunityTableViewCellReuseIdentifier = @"lyCommunityTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
    
}




- (void)viewWillAppear:(BOOL)animated
{
    if ( !flagLoad) {
        flagLoad = YES;
        [self refresh:refresher];
    } else {
        cyArrNews = [[LyNewsManager sharedInstance] getAllNews];
        [tvNews reloadData];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [tvNews deselectRowAtIndexPath:curIdx animated:NO];
}





- (void)initSubviews
{
    //navigationBar
    self.title = @"驾考圈";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    UIBarButtonItem *bbiLeftMenu = [LyUtil barButtonItem:communityBarButtonItemTag_leftMenu
                                               imageName:@"navigationBar_left"
                                                  target:self
                                                  action:@selector(presentLeftMenuViewController:)];
    
    UIBarButtonItem *bbiMsg = [LyUtil barButtonItem:communityBarButtonItemTag_msg
                                          imageName:@"navigationBar_msg"
                                             target:self
                                             action:@selector(targetForBarButtonItem:)];
    UIBarButtonItem *bbiRightMenu = [LyUtil barButtonItem:communityBarButtonItemTag_rightMenu
                                                imageName:@"navigationBar_right"
                                                   target:self
                                                   action:@selector(presentRightMenuViewController:)];
    
    self.navigationItem.leftBarButtonItem = bbiLeftMenu;
    self.navigationItem.rightBarButtonItems = @[bbiRightMenu, bbiMsg];
    
    //tabbar
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"驾考圈"
                                                    image:[LyUtil imageForImageName:@"community_n" needCache:NO]
                                            selectedImage:[LyUtil imageForImageName:@"community_h" needCache:NO]];
    

    tvNews = [[UITableView alloc] initWithFrame:CGRectMake( 0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, tvNewsHeight)
                                          style:UITableViewStylePlain];
    [tvNews setDelegate:self];
    [tvNews setDataSource:self];
    [tvNews setScrollsToTop:YES];
    [tvNews setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tvNews];
    
    
    refresher = [LyUtil refreshControlWithTitle:nil
                                         target:self
                                         action:@selector(refresh:)];
    [tvNews addSubview:refresher];
    
    
    tvFooterView = [[LyTableViewFooterView alloc] initWithFrame:CGRectMake( 0, 0, CGRectGetWidth(tvNews.frame), tvFooterViewDefaultHeight)];
    [tvFooterView setDelegate:self];
    [tvNews setTableFooterView:tvFooterView];
    
    
    
    
    
    btnSendNews = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-btnFuncSize, SCREEN_HEIGHT*3/4-verticalSpace-btnFuncSize, btnFuncSize, btnFuncSize)];
    [btnSendNews setImage:[LyUtil imageForImageName:@"cy_btn_sendNews" needCache:NO] forState:UIControlStateNormal];
    [btnSendNews addTarget:self action:@selector(openSendNewsViewController) forControlEvents:UIControlEventTouchUpInside];
    
    btnAboutMe = [[UIButton alloc] initWithFrame:CGRectMake(btnSendNews.frame.origin.x, SCREEN_HEIGHT*3/4+verticalSpace, btnFuncSize, btnFuncSize)];
    [btnAboutMe setImage:[LyUtil imageForImageName:@"cy_btn_aboutMe" needCache:NO] forState:UIControlStateNormal];
    [btnAboutMe addTarget:self action:@selector(openOboutMeTableViewController) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:btnSendNews];
    [self.view addSubview:btnAboutMe];
}





- (void)openSendNewsViewController {
    
    LySendNewsViewController *sendStatus = [[LySendNewsViewController alloc] init];
    [sendStatus setDelegate:self];
    [sendStatus setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:sendStatus animated:YES];
}


- (void)openOboutMeTableViewController {
    LyAboutMeTableViewController *aboutme = [[LyAboutMeTableViewController alloc] init];
    [aboutme setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:aboutme animated:YES];
    
    countAboutMe = 0;
    [self setCountAboutMe];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    LyCommunityBarButtonItemTag bbiTag = bbi.tag;
    switch (bbiTag) {
        case communityBarButtonItemTag_leftMenu: {
            //nothing yet
            break;
        }
        case communityBarButtonItemTag_msg: {
            LyMsgCenterTableViewController *msgCenter = [[LyMsgCenterTableViewController alloc] init];
            msgCenter.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:msgCenter animated:YES];
            break;
        }
        case communityBarButtonItemTag_rightMenu: {
            //nothing yet
            break;
        }
    }
}


- (void)setCountAboutMe {

    if (countAboutMe > 0) {
        NSString *strCount = [[NSString alloc] initWithFormat:@"%ld", countAboutMe];
        [self.tabBarItem setBadgeValue:strCount];
        [btnAboutMe setNum:strCount];
    } else {
        [btnAboutMe setNum:nil];
        [self.tabBarItem setBadgeValue:nil];
    }
}



- (void)refresh:(UIRefreshControl *)refreshControl
{
    [self loadData];
}



- (void)loadData
{
    if ( !indicator_load) {
        indicator_load = [[LyIndicator alloc] initWithTitle:@""];
    }
    [indicator_load startAnimation];

    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:communityHttpMethod_load];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:getAllNews_url
                                          body:@{
                                                 getListStartKey:@"0",
                                                 userIdKey:[LyCurrentUser curUser].userId,
                                                 sessionIdKey:[LyUtil httpSessionId]}
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}



- (void)loadMoreData
{
    [tvFooterView startAnimation];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:communityHttpMethod_loadMore];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:getAllNews_url
                                          body:@{
                                                 userIdKey:[LyCurrentUser curUser].userId,
                                                 getListStartKey:@(cyArrNews.count),
                                                 sessionIdKey:[LyUtil httpSessionId]
                                                 }
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
    bHttpFlag = [[httpRequest startHttpRequest:statusTransmit_url
                                         body:@{
                                                newsIdKey:news.newsId,
                                                objectIdKey:news.newsMasterId,
                                                userIdKey:[LyCurrentUser curUser].userId,
                                                nickNameKey:[LyCurrentUser curUser].userName,
                                                sessionIdKey:[LyUtil httpSessionId],
                                                objectNameKey:user.userName,
                                                userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                                }
                                         type:LyHttpType_asynPost
                                      timeOut:0] boolValue];
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
    }
    
    if ([tvFooterView isAnimating]) {
        [tvFooterView stopAnimation];
    }
    
    if ([indicator_oper isAnimating]) {
        [indicator_oper stopAnimation];
        NSString *str;
        if ([indicator_oper.title isEqualToString:LyIndicatorTitle_delete]) {
            str = @"删除失败";
        } else if ([indicator_oper.title isEqualToString:LyIndicatorTitle_transmit]) {
            str = @"转发失败";
        }
        
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:str] show];
    }
    
    
    [tvFooterView setStatus:LyTableViewFooterViewStatus_error];
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
        [refresher endRefreshing];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_load stopAnimation];
        [indicator_oper stopAnimation];
        [refresher endRefreshing];
        
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
                        if ( [refresher isRefreshing]) {
                            [refresher endRefreshing];
                        }
                        if ( [tvFooterView isAnimating]) {
                            [tvFooterView stopAnimation];
                        }
                        [tvFooterView setStatus:LyTableViewFooterViewStatus_error];
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
                                                                         name:strMasterName];
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
                    if ( [tvFooterView isAnimating])
                    {
                        [tvFooterView stopAnimation];
                    }
                    
                    
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
                                                                         name:strMasterName];
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
                    
                    [tvFooterView stopAnimation];
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
            
        case communityHttpMethod_praise: {
            curHttpMethod = 0;
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
            curHttpMethod = 0;
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
            curHttpMethod = 0;
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
                    
                    [indicator_oper stopAnimation];
                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"删除成功"];
                    [remind setTag:communityRemindViewTag_delete];
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
    if ( bHttpFlag) {
        bHttpFlag = NO;
        [self handleHttpFailed];
    }
    
    curHttpMethod = 0;
}

- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result {
    if ( bHttpFlag) {
        bHttpFlag = NO;
        curHttpMethod = [ahttpRequest mode];
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
    [userDetail setHidesBottomBarWhenPushed:YES];
    [userDetail setDelegate:self];
    [self.navigationController pushViewController:userDetail animated:YES];
}

- (void)onClickedForDetailByNewsTVC:(LyNewsTableViewCell *)aCell {
    curIdx = [tvNews indexPathForCell:aCell];
    
    LyNewsDetailViewController *statusDetail = [[LyNewsDetailViewController alloc] init];
    [statusDetail setHidesBottomBarWhenPushed:YES];
    [statusDetail setDelegate:self];
    [self.navigationController pushViewController:statusDetail animated:YES];
}


- (void)onClickedForPraiseByNewsTVC:(LyNewsTableViewCell *)aCell {
    curIdx = [tvNews indexPathForCell:aCell];
    
    if (aCell.news.isPraised) {
        [self depraise];
    } else {
        [self praise];
    }
    
    [aCell.news praise];
    [tvNews reloadRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)onClickedForEvaluateByNewsTVC:(LyNewsTableViewCell *)aCell {
    curIdx = [tvNews indexPathForCell:aCell];
    
    LyEvaluateNewsViewController *evaluateNewsVC = [[LyEvaluateNewsViewController alloc] init];
    [evaluateNewsVC setHidesBottomBarWhenPushed:YES];
    [evaluateNewsVC setDelegate:self];
    UINavigationController *evaluateNewsNC = [[UINavigationController alloc] initWithRootViewController:evaluateNewsVC];
    [self presentViewController:evaluateNewsNC animated:YES completion:nil];
}

- (void)onCLickedForTransmitByNewsTVC:(LyNewsTableViewCell *)aCell {
    
    curIdx = [tvNews indexPathForCell:aCell];
    
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
    curIdx = [tvNews indexPathForCell:aCell];
    
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


#pragma mark -LyremindViewdelegate
- (void)remindViewWillHide:(LyRemindView *)aRemind {
    if ( communityRemindViewTag_transmit == [aRemind tag]) {
        [tvNews reloadData];
        [tvNews setContentOffset:CGPointMake(0, 0)];
    } else if ( communityRemindViewTag_delete == [aRemind tag]) {
        [tvNews reloadData];
        [tvNews setContentOffset:CGPointMake(0, 0)];
    }
}

- (void)remindViewDidHide:(LyRemindView *)aRemind {
//    if ( communityRemindViewTag_transmit == [aRemind tag]) {
//        [tvNews reloadData];
//        [tvNews setContentOffset:CGPointMake(0, 0)];
//    } else if ( communityRemindViewTag_delete == [aRemind tag]) {
//        [tvNews reloadData];
//        [tvNews setContentOffset:CGPointMake(0, 0)];
//    }
}



#pragma mark -LyTableViewFooterViewDelegate
- (void)loadMoreData:(LyTableViewFooterView *)tableViewFooterView
{
    [tableViewFooterView startAnimation];
    [self loadMoreData];
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    curIdx = indexPath;
    
    LyNewsDetailViewController *statusDetail = [[LyNewsDetailViewController alloc] init];
    [statusDetail setHidesBottomBarWhenPushed:YES];
    [statusDetail setDelegate:self];
    [self.navigationController pushViewController:statusDetail animated:YES];
}




#pragma mark UITableViewDataSource相关
////返回每个分组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cyArrNews count];
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


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ( scrollView == tvNews && [scrollView contentOffset].y + [scrollView frame].size.height + tvFooterViewDefaultHeight > [scrollView contentSize].height && [scrollView contentSize].height > [scrollView frame].size.height)
    {
        [tvFooterView startAnimation];
        [self loadMoreData];
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
