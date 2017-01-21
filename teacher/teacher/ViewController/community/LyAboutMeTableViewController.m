//
//  LyAboutMeTableViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyAboutMeTableViewController.h"
#import "LyAboutMeTableViewCell.h"
#import "LyTableViewFooterView.h"


#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyAboutMeManager.h"
#import "LyUserManager.h"
#import "LyNewsManager.h"
#import "LyCurrentUser.h"

#import "LyUtil.h"

#import "UITextView+textCount.h"
#import "NSString+Validate.h"


#import "LyUserDetailViewController.h"
#import "LyNewsDetailViewController.h"


#define viewReplyWidth              SCREEN_WIDTH
CGFloat const viewReplyHeight = 70.0f;

#define tvReplyWidth                (viewReplyWidth-horizontalSpace*2)
#define tvReplyHeight               (viewReplyHeight-verticalSpace*2)
#define tvReplyFont                 LyFont(12)



typedef NS_ENUM( NSInteger, LyAboutMeHttpMethod)
{
    aboutMeHttpMethod_load = 1,
    aboutMeHttpMethod_loadMore,
    aboutMeHttpMethod_reply
};




 NSString *const lyAboutMeTableViewCellReuseIdentifier = @"lyAboutMeTableViewCellReuseIdentifier";

@interface LyAboutMeTableViewController ()<LyHttpRequestDelegate, LyTableViewFooterViewDelegate, UITextViewDelegate, LyRemindViewDelegate, LyAboutMeTableViewCellDelegate, LyUserDetailDelegate, LyNewsDetailViewControllerDelegate>
{
    UIView                  *viewError;
    UIView                  *viewNull;
    
    NSArray                 *arrAboutMe;
    
    NSIndexPath             *lastIp;
    
    UIView                  *viewReply;
    UITextView              *tvReply;
    
    LyIndicator             *indicator_load;
    LyTableViewFooterView   *tvFooterView;
    LyIndicator             *indicator_reply;
    
    
    BOOL                    flagLoadSuccess;
    BOOL                    bHttpFlag;
    LyAboutMeHttpMethod     curHttpMethod;
}
@end

@implementation LyAboutMeTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"与我相关";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [self.tableView registerClass:[LyAboutMeTableViewCell class] forCellReuseIdentifier:lyAboutMeTableViewCellReuseIdentifier];
    
    
    
    self.refreshControl = [LyUtil refreshControlWithTitle:nil target:self action:@selector(refresh:)];
    
    
    tvFooterView = [[LyTableViewFooterView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, tvFooterViewDefaultHeight)];
    [tvFooterView setDelegate:self];
    [self.tableView setTableFooterView:tvFooterView];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    if ( !flagLoadSuccess)
    {
        [self refresh:self.refreshControl];
    }
    
    [self addKeyboardEventNotification];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self removeKeyboardEventNotification];
}


- (void)addKeyboardEventNotification
{
    //增加监听，当键盘出现或改变时收出消息
    if ( [self respondsToSelector:@selector(targetForNotificationToKeyboardWillShow:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(targetForNotificationToKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    
    //增加监听，当键退出时收出消息
    if ( [self respondsToSelector:@selector(targetForNotificationToKeyboardWillHide:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(targetForNotificationToKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}


- (void)removeKeyboardEventNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}


- (void)targetForNotificationToKeyboardWillShow:(NSNotification *)notifi
{
    CGFloat fHeightKeyboard = [[[notifi userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [viewReply setFrame:CGRectMake( 0, SCREEN_HEIGHT-viewReplyHeight-fHeightKeyboard+self.tableView.contentOffset.y, viewReplyWidth, viewReplyHeight)];
}

- (void)targetForNotificationToKeyboardWillHide:(NSNotification *)notifi
{
    [viewReply removeFromSuperview];
}


- (void)showViewError
{
    flagLoadSuccess = YES;
    if ( !viewError)
    {
        viewError = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.1f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        UILabel *lbError = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, LyLbErrorHeight)];
        [lbError setBackgroundColor:LyWhiteLightgrayColor];
        [lbError setTextAlignment:NSTextAlignmentCenter];
        [lbError setFont:LyNullItemTitleFont];
        [lbError setTextColor:LyNullItemTextColor];
        [lbError setText:@"加载失败，下拉再次加载"];
        
        [viewError addSubview:lbError];
    }
    
    [self.tableView setContentSize:CGSizeMake( SCREEN_WIDTH, SCREEN_HEIGHT*1.1f)];
    [self.tableView addSubview:viewError];
    [self.tableView bringSubviewToFront:viewError];
}


- (void)removeViewError
{
    flagLoadSuccess = YES;
    [viewError removeFromSuperview];
}

- (void)showViewNull
{
    if ( !viewNull)
    {
        viewNull = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.1f)];
        [viewNull setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *lbNull = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, LyLbNullHeight)];
        [lbNull setBackgroundColor:[UIColor whiteColor]];
        [lbNull setTextAlignment:NSTextAlignmentCenter];
        [lbNull setFont:LyNullItemTitleFont];
        [lbNull setTextColor:LyNullItemTextColor];
        [lbNull setText:@"还没有相关消息"];
        
        [viewNull addSubview:lbNull];
    }
    
    [self.tableView setContentSize:CGSizeMake( SCREEN_WIDTH, SCREEN_HEIGHT*1.1f)];
    [self.tableView addSubview:viewNull];
    [self.tableView bringSubviewToFront:viewNull];
}

- (void)removeViewNull
{
    [viewNull removeFromSuperview];
}


- (void)refresh:(UIRefreshControl *)refresher
{
    [self loadData];
}



- (void)loadData
{
    if ( !indicator_load)
    {
        indicator_load = [LyIndicator indicatorWithTitle:@""];
    }
    [indicator_load startAnimation];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:aboutMeHttpMethod_load];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:aboutMe_url
                                          body:@{
                                                userIdKey:[LyCurrentUser curUser].userId,
                                                sessionIdKey:[LyUtil httpSessionId]
                                                }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}




- (void)loadMoreData
{
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:aboutMeHttpMethod_loadMore];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:aboutMe_url
                                          body:@{
                                                 startKey:@(arrAboutMe.count),
                                                 userIdKey:[LyCurrentUser curUser].userId,
                                                 sessionIdKey:[LyUtil httpSessionId]
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}



- (void)repaly
{
    if ( !indicator_reply)
    {
        indicator_reply = [LyIndicator indicatorWithTitle:@"正在回复..."];
    }
    [indicator_reply startAnimation];
    
    LyAboutMe *aboutMe = [[self.tableView cellForRowAtIndexPath:lastIp] aboutMe];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:aboutMeHttpMethod_reply];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:communityReply_url
                                          body:@{
                                                 aboutMeObjectAmIdKey:[aboutMe amId],
                                                 objectIdKey:[aboutMe amMasterId],
                                                 masterIdKey:[LyCurrentUser curUser].userId,
                                                 objectingIdKey:[aboutMe amNewsId],
                                                 contentKey:[tvReply text],
                                                 sessionIdKey:[LyUtil httpSessionId],
                                                 userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}


- (void)handleHttpFailed {
    if ( [indicator_load isAnimating]) {
        [indicator_load stopAnimation];
        [self.refreshControl endRefreshing];
        
        [self showViewError];
    }
    if ( [tvFooterView isAnimating])
    {
        [tvFooterView stopAnimation];
    }
    if ( [indicator_reply isAnimating])
    {
        [indicator_reply stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"回复失败"] show];
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
        [indicator_reply stopAnimation];
        [tvFooterView stopAnimation];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_load stopAnimation];
        [indicator_reply stopAnimation];
        [tvFooterView stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    switch ( curHttpMethod) {
        case aboutMeHttpMethod_load: {
            switch ( [strCode integerValue]) {
                case 0: {
                    
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateArray:arrResult]) {
                        [indicator_load stopAnimation];
                        [self showViewNull];
                        if ( [self.refreshControl isRefreshing]) {
                            [self.refreshControl endRefreshing];
                        }
                        return;
                    }
                    
                    for (NSDictionary *dicItem in arrResult) {
                        
//                        NSDictionary *dicItem = [arrResult objectAtIndex:i];
                        if (![LyUtil validateDictionary:dicItem]) {
                            continue;
                        }
                        
                        NSString *strId = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:idKey]];

                        
                        NSString *strMasterId = [dicItem objectForKey:masterIdKey];
                        NSString *strObjectId = [dicItem objectForKey:objectIdKey];
                        NSString *strNewsId = [dicItem objectForKey:objectingIdKey];
                        NSString *strContent = [dicItem objectForKey:contentKey];
                        NSString *strTime = [dicItem objectForKey:timeKey];
                        NSString *strMode = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:modeKey]];
                        NSString *strObjectAmId = [dicItem objectForKey:aboutMeObjectAmIdKey];
                        
                        NSDictionary *dicNews = [dicItem objectForKey:newsKey];
                        if (![LyUtil validateDictionary:dicNews]) {
                            continue;
                        }
                
                        
                        NSString *strNewsMasterId = [dicNews objectForKey:userIdKey];
                        NSString *strNewsTime = [dicNews objectForKey:newsTimeKey];
                        NSString *strNewsContent = [dicNews objectForKey:newsContentKey];
                        NSString *strPraiseCount = [dicNews objectForKey:newsPraiseCountKey];
                        NSString *strEvalutionCount = [dicNews objectForKey:newsEvalutionCountKey];
                        NSString *strTransmitCount = [dicNews objectForKey:newsTransmitCountKey];
                        
                        NSString *strPraiseFlag = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:newsPraiseFlagKey]];
                        
                        if ( !strNewsTime || [strNewsTime isKindOfClass:[NSNull class]] || [strNewsTime rangeOfString:@"(null)"].length > 0) {
                            strNewsTime = [[NSDate date] description];
                        }
                        
                        if ( strNewsTime.length < 20) {
                            strNewsTime = [strNewsTime stringByAppendingString:@" +0800"];
                        }
                        
//                        NSString *strNewsMasterId = [dicNews objectForKey:newsMasterIdKey];
                        if ( [strNewsMasterId isEqualToString:[LyCurrentUser curUser].userId]) {
                            
                        } else {
                            LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:strNewsMasterId];
                            if ( !user) {
                                NSString *strNewsMasterName = [LyUtil getUserNameWithUserId:strNewsMasterId];
                                
                                user = [LyUser userWithId:strNewsMasterId
                                                 userNmae:strNewsMasterName];
                                [[LyUserManager sharedInstance] addUser:user];
                            }
                        }
                        
                        
                        LyNews *news = [[LyNewsManager sharedInstance] getNewsWithNewsId:strNewsId];
                        if (!news) {
                            news = [LyNews newsWithId:strNewsId
                                             masterId:strNewsMasterId
                                                 time:strNewsTime
                                              content:strNewsContent
                                        transmitCount:strTransmitCount.intValue
                                      evaluationCount:strEvalutionCount.intValue
                                          praiseCount:strPraiseCount.intValue];
                            
                            [news setPraise:strPraiseFlag.boolValue];
                            
                            NSArray *arrImageUrl = [dicNews objectForKey:imageUrlKey];
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
                        
                        
                        
                        LyUser *master = [[LyUserManager sharedInstance] getUserWithUserId:strMasterId];
                        if ( !master) {
                            NSString *strName = [LyUtil getUserNameWithUserId:strMasterId];
                            master = [LyUser userWithId:strMasterId
                                               userNmae:strName];
                            [[LyUserManager sharedInstance] addUser:master];
                        }
                        
                        LyUser *objectUser = [[LyUserManager sharedInstance] getUserWithUserId:strObjectId];
                        if ( !objectUser) {
                            NSString *strName = [LyUtil getUserNameWithUserId:strObjectId];
                            objectUser = [LyUser userWithId:strObjectId
                                                   userNmae:strName];
                            [[LyUserManager sharedInstance] addUser:objectUser];
                        }
                        
                        
                        if (![LyUtil validateString:strContent]) {
                            strContent = @" ";
                        }
                        
                        strTime = [LyUtil fixDateTimeString:strTime];
                        
                        LyAboutMe *aboutMe = [[LyAboutMeManager sharedInstance] getAboutMeWithId:strId];
                        if ( !aboutMe) {
                            aboutMe = [LyAboutMe aboutMeWithId:strId
                                                      masterId:strMasterId
                                                      objectId:strObjectId
                                                        newsId:strNewsId
                                                       content:strContent
                                                          time:strTime
                                                          mode:[strMode integerValue]
                                                  amObjectAmId:strObjectAmId];
                            [[LyAboutMeManager sharedInstance] addAboutMe:aboutMe];
                        }
                        
                    }
                    
                    
                    arrAboutMe = [[LyAboutMeManager sharedInstance] aboutMeWithUserId:[LyCurrentUser curUser].userId];
                    
                    [self removeViewError];
                    if (!arrAboutMe || ![arrAboutMe count]) {
                        [self showViewNull];
                    } else {
                        [self removeViewNull];
                        [self.tableView reloadData];
                    }
                    
                    [indicator_load stopAnimation];
                    if ( [self.refreshControl isRefreshing])
                    {
                        [self.refreshControl endRefreshing];
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
        case aboutMeHttpMethod_loadMore: {
            switch ( [strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateArray:arrResult]) {
                        [tvFooterView stopAnimation];
                        [tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                        return;
                    }
                    
                    for (NSDictionary *dicItem in arrResult) {
                        
                        if (![LyUtil validateDictionary:dicItem]) {
                            continue;
                        }
                        
                        NSString *strId = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:idKey]];
                        
                        
                        NSString *strMasterId = [dicItem objectForKey:masterIdKey];
                        NSString *strObjectId = [dicItem objectForKey:objectIdKey];
                        NSString *strNewsId = [dicItem objectForKey:objectingIdKey];
                        NSString *strContent = [dicItem objectForKey:contentKey];
                        NSString *strTime = [dicItem objectForKey:timeKey];
                        NSString *strMode = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:modeKey]];
                        NSString *strObjectAmId = [dicItem objectForKey:aboutMeObjectAmIdKey];
                        
                        NSDictionary *dicNews = [dicItem objectForKey:newsKey];
                        if (![LyUtil validateDictionary:dicNews]) {
                            continue;
                        }
                        
                        
                        NSString *strNewsMasterId = [dicNews objectForKey:userIdKey];
                        NSString *strNewsTime = [dicNews objectForKey:newsTimeKey];
                        NSString *strNewsContent = [dicNews objectForKey:newsContentKey];
                        NSString *strPraiseCount = [dicNews objectForKey:newsPraiseCountKey];
                        NSString *strEvalutionCount = [dicNews objectForKey:newsEvalutionCountKey];
                        NSString *strTransmitCount = [dicNews objectForKey:newsTransmitCountKey];
                        
                        NSString *strPraiseFlag = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:newsPraiseFlagKey]];
                        
                        if ( !strNewsTime || [strNewsTime isKindOfClass:[NSNull class]] || [strNewsTime rangeOfString:@"(null)"].length > 0) {
                            strNewsTime = [[NSDate date] description];
                        }
                        
                        if ( strNewsTime.length < 20) {
                            strNewsTime = [strNewsTime stringByAppendingString:@" +0800"];
                        }
                        
                        //                        NSString *strNewsMasterId = [dicNews objectForKey:newsMasterIdKey];
                        if ( [strNewsMasterId isEqualToString:[LyCurrentUser curUser].userId]) {
                            
                        } else {
                            LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:strNewsMasterId];
                            if ( !user) {
                                NSString *strNewsMasterName = [LyUtil getUserNameWithUserId:strNewsMasterId];
                                
                                user = [LyUser userWithId:strNewsMasterId
                                                 userNmae:strNewsMasterName];
                                [[LyUserManager sharedInstance] addUser:user];
                            }
                        }
                        
                        
                        LyNews *news = [[LyNewsManager sharedInstance] getNewsWithNewsId:strNewsId];
                        if (!news) {
                            news = [LyNews newsWithId:strNewsId
                                             masterId:strNewsMasterId
                                                 time:strNewsTime
                                              content:strNewsContent
                                        transmitCount:strTransmitCount.intValue
                                      evaluationCount:strEvalutionCount.intValue
                                          praiseCount:strPraiseCount.intValue];
                            
                            [news setPraise:strPraiseFlag.boolValue];
                            
                            NSArray *arrImageUrl = [dicNews objectForKey:imageUrlKey];
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
                        
                        
                        
                        LyUser *master = [[LyUserManager sharedInstance] getUserWithUserId:strMasterId];
                        if ( !master) {
                            NSString *strName = [LyUtil getUserNameWithUserId:strMasterId];
                            master = [LyUser userWithId:strMasterId
                                               userNmae:strName];
                            [[LyUserManager sharedInstance] addUser:master];
                        }
                        
                        LyUser *objectUser = [[LyUserManager sharedInstance] getUserWithUserId:strObjectId];
                        if ( !objectUser) {
                            NSString *strName = [LyUtil getUserNameWithUserId:strObjectId];
                            objectUser = [LyUser userWithId:strObjectId
                                                   userNmae:strName];
                            [[LyUserManager sharedInstance] addUser:objectUser];
                        }
                        
                        
                        if (![LyUtil validateString:strContent]) {
                            strContent = @" ";
                        }
                        
                        strTime = [LyUtil fixDateTimeString:strTime];
                        
                        LyAboutMe *aboutMe = [[LyAboutMeManager sharedInstance] getAboutMeWithId:strId];
                        if ( !aboutMe) {
                            aboutMe = [LyAboutMe aboutMeWithId:strId
                                                      masterId:strMasterId
                                                      objectId:strObjectId
                                                        newsId:strNewsId
                                                       content:strContent
                                                          time:strTime
                                                          mode:[strMode integerValue]
                                                  amObjectAmId:strObjectAmId];
                            [[LyAboutMeManager sharedInstance] addAboutMe:aboutMe];
                        }
                        
                    }
                    
                    [self removeViewError];
                    
                    arrAboutMe = [[LyAboutMeManager sharedInstance] aboutMeWithUserId:[LyCurrentUser curUser].userId];
                    
                    [self.tableView reloadData];
                    if (!arrAboutMe || ![arrAboutMe count]) {
                        [self showViewNull];
                    }
                    else {
                        [self removeViewNull];
                        [self.tableView reloadData];
                    }
                    [tvFooterView stopAnimation];
                    [tvFooterView setStatus:LyTableViewFooterViewStatus_normal];

                    break;
                }
                default:
                    [self handleHttpFailed];
                    break;
            }
            break;
        }
        case aboutMeHttpMethod_reply: {
            switch ( [strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [indicator_reply stopAnimation];
                        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"回复失败"] show];
                        return;
                    }
                    
                    NSString *strId = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:idKey]];
                    
                    NSString *strMasterId = [dicResult objectForKey:masterIdKey];
                    NSString *strObjectId = [dicResult objectForKey:objectIdKey];
                    NSString *strNewsId = [dicResult objectForKey:objectingIdKey];
                    NSString *strContent = [dicResult objectForKey:contentKey];
                    NSString *strTime = [dicResult objectForKey:timeKey];
                    NSString *strMode = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:modeKey]];
                    NSString *strObjectAmId = [dicResult objectForKey:aboutMeObjectAmIdKey];
                    
                    LyUser *master = [[LyUserManager sharedInstance] getUserWithUserId:strMasterId];
                    if ( !master)
                    {
                        NSString *strName = [LyUtil getUserNameWithUserId:strMasterId];
                        master = [LyUser userWithId:strMasterId
                                           userNmae:strName];
                        [[LyUserManager sharedInstance] addUser:master];
                    }
                    
                    LyUser *objectUser = [[LyUserManager sharedInstance] getUserWithUserId:strObjectId];
                    if ( !objectUser) {
                        NSString *strName = [LyUtil getUserNameWithUserId:strObjectId];
                        objectUser = [LyUser userWithId:strObjectId
                                               userNmae:strName];
                        [[LyUserManager sharedInstance] addUser:objectUser];
                    }
                    
                    
                    if (![LyUtil validateString:strContent]) {
                        strContent = @"";
                    }
                    
                    strTime = [LyUtil fixDateTimeString:strTime];
                    
                    LyAboutMe *aboutMe = [[LyAboutMeManager sharedInstance] getAboutMeWithId:strId];
                    if ( !aboutMe)
                    {
                        aboutMe = [LyAboutMe aboutMeWithId:strId
                                                  masterId:strMasterId
                                                  objectId:strObjectId
                                                    newsId:strNewsId
                                                   content:strContent
                                                      time:strTime
                                                      mode:[strMode integerValue]
                                              amObjectAmId:strObjectAmId];
                        [[LyAboutMeManager sharedInstance] addAboutMe:aboutMe];
                    }
                    arrAboutMe = [[LyAboutMeManager sharedInstance] aboutMeWithUserId:[LyCurrentUser curUser].userId];
                    
                    
                    [self.tableView reloadData];
                    [tvReply setText:@""];
                    
                    [indicator_reply stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"回复成功"] show];
                    
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -LyHttpRequestDelegate
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest {
    if ( bHttpFlag) {
        bHttpFlag = NO;
        [self handleHttpFailed];
    }
    
    curHttpMethod = 0;
}


- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result
{
    if ( bHttpFlag)
    {
        bHttpFlag = NO;
        curHttpMethod = [ahttpRequest mode];
        [self analysisHttpResult:result];
    }
    
    curHttpMethod = 0;
}


#pragma mark -UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        
        if ( [tvReply text].length < 1)
        {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"内容太短"] show];
        }
        else
        {
            if (textView.text.length > textView.textCount)
            {
                textView.text = [textView.text substringToIndex:textView.textCount];
            }
            [self repaly];
            [textView resignFirstResponder];
        }
        
        
        return NO;
    }
    return YES;
}



#pragma mark -LyTableViewFooterViewDelegate
- (void)loadMoreData:(LyTableViewFooterView *)tableViewFooterView
{
    [tableViewFooterView startAnimation];
    [self loadMoreData];
}




#pragma mark -LyAboutMeTableViewCellDelegate
- (void)onClickedButtonReplyByAboutMeTableViewCell:(LyAboutMeTableViewCell *)aCell
{
    lastIp = [self.tableView indexPathForCell:aCell];
    
    if ( !viewReply)
    {
        viewReply = [[UIView alloc] initWithFrame:CGRectMake( 0, SCREEN_HEIGHT-viewReplyHeight, viewReplyWidth, viewReplyHeight)];
        [viewReply setBackgroundColor:LyWhiteLightgrayColor];
        
        tvReply = [[UITextView alloc] initWithFrame:CGRectMake( viewReplyWidth/2.0f-tvReplyWidth/2.0f, viewReplyHeight/2.0f-tvReplyHeight/2.0f, tvReplyWidth, tvReplyHeight)];
        [tvReply setDelegate:self];
        [tvReply setFont:tvReplyFont];
        [tvReply setReturnKeyType:UIReturnKeySend];
        [tvReply setBackgroundColor:LyWhiteLightgrayColor];
        [[tvReply layer] setCornerRadius:3.0f];
        [[tvReply layer] setBorderWidth:1.0f];
        [[tvReply layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
        [tvReply setTextCount:LyEvaluationLengthMax];
        
        [viewReply addSubview:tvReply];
    }
    
    [self.view addSubview:viewReply];
    [self.view bringSubviewToFront:viewReply];
    [tvReply becomeFirstResponder];
}


- (void)onClickedUserByAboutMeTableViewCell:(LyAboutMeTableViewCell *)aCell
{
    lastIp = [self.tableView indexPathForCell:aCell];
    
    LyUserDetailViewController *userDetail = [[LyUserDetailViewController alloc] init];
    [userDetail setDelegate:self];
    [self.navigationController pushViewController:userDetail animated:YES];
}

- (void)onClickedNewsByAboutMeTableViewCell:(LyAboutMeTableViewCell *)aCell
{
    lastIp = [self.tableView indexPathForCell:aCell];
    
    LyNewsDetailViewController *statusDetail = [[LyNewsDetailViewController alloc] init];
    [statusDetail setDelegate:self];
    [self.navigationController pushViewController:statusDetail animated:YES];
}


#pragma mark -LyNewsDetailViewControllerDelegate
- (LyNews *)obtainNewsByNewsDetailVC:(LyNewsDetailViewController *)aNewsDetailVC {
    LyNews *news = [[LyNewsManager sharedInstance] getNewsWithNewsId:[[[self.tableView cellForRowAtIndexPath:lastIp] aboutMe] amNewsId]];
    
    return news;
}

- (void)onDeleteByNewsDetailVC:(LyNewsDetailViewController *)aNewsDetailVC {
    [aNewsDetailVC.navigationController popViewControllerAnimated:YES];
}




#pragma mark -LyUserDetailDelegate
- (NSString *)obtainUserId
{
    return [[[self.tableView cellForRowAtIndexPath:lastIp] aboutMe] amMasterId];
}


#pragma mark -TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyAboutMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyAboutMeTableViewCellReuseIdentifier];
    if ( !cell)
    {
        cell = [[LyAboutMeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyAboutMeTableViewCellReuseIdentifier];
    }
    [cell setAboutMe:[arrAboutMe objectAtIndex:[indexPath row]]];
 
    return [cell height];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrAboutMe count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyAboutMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyAboutMeTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    if ( !cell)
    {
        cell = [[LyAboutMeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyAboutMeTableViewCellReuseIdentifier];
    }
    [cell setAboutMe:[arrAboutMe objectAtIndex:[indexPath row]]];
    [cell setDelegate:self];
    
    return cell;
}



#pragma mark -UIScrollView
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ( scrollView == self.tableView)
    {
        if ( scrollView == self.tableView && [scrollView contentOffset].y + [scrollView frame].size.height + tvFooterViewDefaultHeight > [scrollView contentSize].height && [scrollView contentSize].height > scrollView.frame.size.height)
        {
            [tvFooterView startAnimation];
            [self loadMoreData];
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
