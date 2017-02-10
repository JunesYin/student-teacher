//
//  LyNewsDetailViewController.m
//  teacher
//
//  Created by Junes on 2016/10/18.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyNewsDetailViewController.h"
#import "LyNewsTableViewCell.h"
#import "LyEvaluationForNewsTableViewCell.h"
#import "LyNewsDetailControlBar.h"
#import "LyNewsDetailExtBar.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyNewsManager.h"
#import "LyEvaluationManager.h"
#import "LyUserManager.h"
#import "LyReplyManager.h"

#import "LyUtil.h"

#import "LyEvaluateNewsViewController.h"
#import "LyUserDetailViewController.h"

#import "LyCommunityViewController.h"


CGFloat const ndViewItemHeight = 250.0f;


#define extBarFrame_let                 CGRectMake( 0, STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, ndebHeight)
#define extBarFrame_var                 CGRectMake(0, self.tvNews.frame.origin.y + CGRectGetHeight(self.tvNews.frame) + verticalSpace, SCREEN_WIDTH, ndebHeight)



typedef NS_ENUM(NSInteger, LyNewsDetailShowIndex) {
    newsDetailShowIndex_evaluation = 0,
    newsDetailShowIndex_transmit,
    newsDetailShowIndex_praise
};



typedef NS_ENUM(NSInteger, LyNewsDetailHttpMethod) {
    newsDetailHttpMethod_load = 100,
    newsDetailHttpMethod_praise,
    newsDetailHttpMethod_depraise,
    newsDetailHttpMethod_transmit,
    newsDetailHttpMethod_delete,
};




@interface LyNewsDetailViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, LyHttpRequestDelegate, LyNewsDetailExtBarDelegate, LyNewsDetailControlBarDelegate, LyEvaluateNewsViewControllerDelegate, LyUserDetailDelegate, LyNewsTableViewCellDelegate, LyRemindViewDelegate>
{
    UIView                      *viewHeader;
    
    UIView                      *viewNull_evaluation;
    
    UITextView                  *tvTransmitInfo;
    UITextView                  *tvPraiseInfo;
    
    UIView                      *viewError;
    
    
    NSString                    *curTransmitInfo;
    NSArray                     *arrEvaluation;
    NSString                    *curPraiseInfo;
    
    BOOL                        flagHideEvaluation;
    
    BOOL                        flagLoadSuccess;
    LyNewsDetailShowIndex       curShowIdx;
    
    
    LyIndicator                 *indicator_oper;
    LyIndicator                 *indicator;
    BOOL                        bHttpFlag;
    LyNewsDetailHttpMethod      curHttpMethod;
}

@property (nonatomic, strong)       UITableView                 *tableView;
@property (nonatomic, strong)       UIRefreshControl            *refreshControl;

@property (nonatomic, strong)       UITableView                 *tvNews;

@property (nonatomic, strong)       LyNewsDetailExtBar        *extBar;
@property (nonatomic, strong)       LyNewsDetailControlBar    *controlBar;

@end

@implementation LyNewsDetailViewController

static NSString *const lyNewsDetailTvNewsCellReuseIdentifier = @"lyNewsDetailTvNewsCellReuseIdentifier";

static NSString *const lyNewsDetailTableViewCellResueIdentifier = @"lyNewsDetailTableViewCellResueIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (!_news) {
        _news = [_delegate obtainNewsByNewsDetailVC:self];
        
        [self reloadData];
    }
    
}

- (void)initSubviews {
    
    self.title = @"动态正文";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = LyWhiteLightgrayColor;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    //动态
    viewHeader = [[UIView alloc] init];
    
    //self.tvNews
    
    
    [viewHeader addSubview:self.tvNews];
    [viewHeader addSubview:self.extBar];
    
    
    //转发
//    viewTransmitInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ndViewItemHeight)];
//    [viewTransmitInfo setBackgroundColor:[UIColor whiteColor]];
    
    tvTransmitInfo = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ndViewItemHeight)];
    [tvTransmitInfo setBackgroundColor:[UIColor whiteColor]];
    [tvTransmitInfo setScrollEnabled:NO];
    [tvTransmitInfo setScrollsToTop:NO];
    [tvTransmitInfo setEditable:NO];
    
//    lbNull_transmit = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, LyNullItemHeight)];
//    [lbNull_transmit setText:@"还没有人转发"];
//    [lbNull_transmit setFont:LyNullItemTitleFont];
//    [lbNull_transmit setTextColor:LyNullItemTextColor];
//    [lbNull_transmit setTextAlignment:NSTextAlignmentCenter];
//    [lbNull_transmit setHidden:YES];
    
//    [viewTransmitInfo addSubview:tvTransmitInfo];
//    [viewTransmitInfo addSubview:lbNull_transmit];
    
    
    //评论
    
    
    //赞
//    viewPraiseInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ndViewItemHeight)];
//    [viewPraiseInfo setBackgroundColor:[UIColor whiteColor]];
    
    tvPraiseInfo = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ndViewItemHeight)];
    [tvPraiseInfo setBackgroundColor:[UIColor whiteColor]];
    [tvPraiseInfo setScrollEnabled:NO];
    [tvPraiseInfo setScrollsToTop:NO];
    [tvPraiseInfo setEditable:NO];
    
//    lbNull_praise = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, LyNullItemHeight)];
//    [lbNull_praise setText:@"还没有人赞"];
//    [lbNull_praise setFont:LyNullItemTitleFont];
//    [lbNull_praise setTextColor:LyNullItemTextColor];
//    [lbNull_praise setTextAlignment:NSTextAlignmentCenter];
//    [lbNull_praise setHidden:YES];
    
//    [viewPraiseInfo addSubview:tvPraiseInfo];
//    [viewPraiseInfo addSubview:lbNull_praise];
    
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.controlBar];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT - ndcbHeight)
                                                  style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setShowsHorizontalScrollIndicator:NO];
        [_tableView registerClass:[LyEvaluationForNewsTableViewCell class] forCellReuseIdentifier:lyNewsDetailTableViewCellResueIdentifier];
        [_tableView setTableFooterView:[UIView new]];
        
        [_tableView addSubview:self.refreshControl];
    }
    
    return _tableView;
}

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [LyUtil refreshControlWithTitle:nil target:self action:@selector(refresh:)];
    }
    
    return _refreshControl;
}


- (UITableView *)tvNews {
    if (!_tvNews) {
        _tvNews = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50.0f)];
        [_tvNews setDelegate:self];
        [_tvNews setDataSource:self];
        [_tvNews setScrollEnabled:NO];
        [_tvNews setScrollsToTop:NO];
        [_tvNews setShowsVerticalScrollIndicator:NO];
        [_tvNews setShowsHorizontalScrollIndicator:NO];
        [_tvNews setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        
        [_tvNews registerClass:[LyNewsTableViewCell class] forCellReuseIdentifier:lyNewsDetailTvNewsCellReuseIdentifier];
    }
    
    return _tvNews;
}


- (LyNewsDetailExtBar *)extBar {
    if (!_extBar) {
        _extBar = [[LyNewsDetailExtBar alloc] initWithFrame:extBarFrame_let];
        [_extBar setDelegate:self];
    }
    
    return _extBar;
}


- (LyNewsDetailControlBar *)controlBar {
    if (!_controlBar) {
        _controlBar = [[LyNewsDetailControlBar alloc] init];
        [_controlBar setDelegate:self];
    }
    
    return _controlBar;
}

- (void)reloadData {
    
    [self removeViewError];
    
    [self reloadViewHeaderData];
    
    if (!flagLoadSuccess) {
        [self load];
        return;
    }
    
    //转发
    [tvTransmitInfo setText:curTransmitInfo];
    CGFloat fHeighttvTransmitInfo = [tvTransmitInfo sizeThatFits:CGSizeMake(SCREEN_WIDTH, ndViewItemHeight)].height;
    if (fHeighttvTransmitInfo < ndViewItemHeight) {
        fHeighttvTransmitInfo = ndViewItemHeight;
    }
//    [viewTransmitInfo setFrame:CGRectMake(0, viewHeader.frame.origin.y + CGRectGetHeight(viewHeader.frame), SCREEN_WIDTH, fHeighttvTransmitInfo)];
    [tvTransmitInfo setFrame:CGRectMake(0, viewHeader.frame.origin.y + CGRectGetHeight(viewHeader.frame), SCREEN_WIDTH, fHeighttvTransmitInfo)];
    
    //赞
    [tvPraiseInfo setText:curPraiseInfo];
    CGFloat fHeighttvPraiseInfo = [tvPraiseInfo sizeThatFits:CGSizeMake(SCREEN_WIDTH, ndViewItemHeight)].height;
    if (fHeighttvPraiseInfo < ndViewItemHeight) {
        fHeighttvPraiseInfo = ndViewItemHeight;
    }
//    [viewPraiseInfo setFrame:CGRectMake(0, viewHeader.frame.origin.y + CGRectGetHeight(viewHeader.frame), SCREEN_WIDTH, fHeighttvPraiseInfo)];
    [tvPraiseInfo setFrame:CGRectMake(0, viewHeader.frame.origin.y + CGRectGetHeight(viewHeader.frame), SCREEN_WIDTH, fHeighttvPraiseInfo)];
    
    
    [self reloadTableViewData:NO];
}


- (void)reloadViewHeaderData {
    
    [self.tvNews reloadData];
    
    [self.extBar setFrame:extBarFrame_var];
    [self.extBar setTransmitCount:_news.newsTransmitCount];
    [self.extBar setEvalutionCount:_news.newsEvaluationCount];
    [self.extBar setPraiseCount:_news.newsPraiseCount];
    
    [viewHeader setFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.extBar.frame.origin.y + ndebHeight + verticalSpace)];
    
    [self.tableView setTableHeaderView:viewHeader];
}

- (void)reloadTableViewData:(BOOL)flagClick {
    
    CGFloat fOldOffSetY = self.tableView.contentOffset.y;
    
    [self.tableView reloadData];
    
    if ((!arrEvaluation || arrEvaluation.count < 1 ) && newsDetailShowIndex_evaluation == curShowIdx) {
        [self showViewNull_evaluation];
    } else {
        [self removeViewNull_evaluation];
    }
    
    
    if (self.tableView.contentSize.height < CGRectGetHeight(viewHeader.frame) + ndViewItemHeight) {
        [self.tableView setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetHeight(viewHeader.frame) + ndViewItemHeight)];
    }
    
    CGFloat fNewOffsetY;
    switch (curShowIdx) {
        case newsDetailShowIndex_evaluation: {
            fNewOffsetY = fOldOffSetY;
            break;
        }
        case newsDetailShowIndex_transmit: {
            fNewOffsetY = self.tableView.contentSize.height - CGRectGetHeight(self.tableView.frame);
            if (fNewOffsetY > fOldOffSetY) {
                fNewOffsetY = fOldOffSetY;
            }
            break;
        }
        case newsDetailShowIndex_praise: {
            fNewOffsetY = self.tableView.contentSize.height - CGRectGetHeight(self.tableView.frame);
            if (fNewOffsetY > fOldOffSetY) {
                fNewOffsetY = fOldOffSetY;
            }
            break;
        }
    }
    
    if (fNewOffsetY < 0) {
        fNewOffsetY = 0;
    }
    
    [self.tableView setContentOffset:CGPointMake(0, fNewOffsetY)];
}


- (void)showViewError {
    if (!viewError) {
        viewError = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.1f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewError addSubview:[LyUtil lbErrorWithMode:0]];
    }
    
    [self.tableView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.05f)];
    [self.tableView addSubview:viewError];
}

- (void)removeViewError {
    [viewError removeFromSuperview];
    viewError = nil;
}


- (void)showViewNull_evaluation {
    if (!viewNull_evaluation) {
        viewNull_evaluation = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeader.frame.origin.y+CGRectGetHeight(viewHeader.frame), SCREEN_WIDTH, SCREEN_HEIGHT)];
        [viewNull_evaluation setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewNull_evaluation addSubview:[LyUtil lbNullWithText:@"还没有评论"]];
    }
    
    [self.tableView addSubview:viewNull_evaluation];
}

- (void)removeViewNull_evaluation {
    [viewNull_evaluation removeFromSuperview];
    viewNull_evaluation = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setShowIndex:(LyNewsDetailShowIndex)index {
    
    curShowIdx = index;
    BOOL flagNeedReload = NO;
    
    switch (curShowIdx) {
        case newsDetailShowIndex_evaluation: {
            if (tvPraiseInfo.superview) {
                flagNeedReload = YES;
                [tvPraiseInfo removeFromSuperview];
            }
            if (tvTransmitInfo.superview) {
                flagNeedReload = YES;
                [tvTransmitInfo removeFromSuperview];
            }
            
            flagHideEvaluation = NO;
            
            break;
        }
        case newsDetailShowIndex_transmit: {
            
            if (tvPraiseInfo.superview) {
                [tvPraiseInfo removeFromSuperview];
            }
            
            if (!tvTransmitInfo.superview) {
                [self.tableView addSubview:tvTransmitInfo];
                
                flagNeedReload = YES;
                flagHideEvaluation = YES;
            }
            
            break;
        }
        case newsDetailShowIndex_praise: {
            
            if (tvTransmitInfo.superview) {
                [tvTransmitInfo removeFromSuperview];
            }
            
            if (!tvPraiseInfo.superview) {
                [self.tableView addSubview:tvPraiseInfo];

                flagNeedReload = YES;
                flagHideEvaluation = YES;
            }
        }
    }
    
    if (flagNeedReload) {
        [self reloadTableViewData:YES];
    }
    
}


- (void)refresh:(UIRefreshControl *)refreshControl {
    [self load];
}

- (void)load {
    if ( !indicator) {
        indicator = [[LyIndicator alloc] initWithTitle:@""];
    }
    [indicator startAnimation];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:newsDetailHttpMethod_load];
    [httpRequest setDelegate:self];
    bHttpFlag = [httpRequest startHttpRequest:statusDetail_url
                                         body:@{
                                                newsIdKey:_news.newsId,
                                                objectIdKey:_news.newsMasterId,
                                                sessionIdKey:[LyUtil httpSessionId]
                                                }
                                         type:LyHttpType_asynPost
                                      timeOut:0];
}

- (void)praise {
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:newsDetailHttpMethod_praise];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:depraise_url
                                          body:@{
                                                 objectIdKey:_news.newsMasterId,
                                                 objectingIdKey:_news.newsId,
                                                 userIdKey:[LyCurrentUser curUser].userId,
                                                 masterIdKey:[LyCurrentUser curUser].userId,
                                                 sessionIdKey:[LyUtil httpSessionId],
                                                 userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}

- (void)depraise {
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:newsDetailHttpMethod_depraise];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:praise_url
                                          body:@{
                                                 objectIdKey:_news.newsMasterId,
                                                 objectingIdKey:_news.newsId,
                                                 masterIdKey:[LyCurrentUser curUser].userId,
                                                 sessionIdKey:[LyUtil httpSessionId],
                                                 userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}

- (void)transmit {
    
    LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:_news.newsMasterId];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:newsDetailHttpMethod_transmit];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:statusTransmit_url
                                          body:@{
                                                 newsIdKey:_news.newsId,
                                                 objectIdKey:_news.newsMasterId,
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
    [indicator_oper startAnimation];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:newsDetailHttpMethod_delete];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:deleteNews_url
                                          body:@{
                                                 newsIdKey:_news.newsId,
                                                 userIdKey:[LyCurrentUser curUser].userId,
                                                 sessionIdKey:[LyUtil httpSessionId],
                                                 userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}

- (void)handleHttpFailed {
    if (indicator.isAnimating) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        [self showViewError];
    }
    
    if (indicator_oper.isAnimating) {
        [indicator_oper stopAnimation];
        
        NSString *strTitle = nil;
        if ([indicator_oper.title isEqualToString:LyIndicatorTitle_delete]) {
            strTitle = @"删除失败";
        }
        
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:strTitle] show];
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
    
    if (codeTimeOut == strCode.integerValue) {
        
        [LyUtil sessionTimeOut:self];
        return;
    }
    
    if (codeMaintaining == strCode.integerValue) {
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch (curHttpMethod) {
        case newsDetailHttpMethod_load: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [indicator stopAnimation];
                        [self showViewError];
                        return;
                    }
                    
                    NSString *strTransmitCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:newsTransmitCountKey]];
                    NSString *strEvaluationCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:newsEvalutionCountKey]];
                    NSString *strPraiseCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:newsPraiseCountKey]];
                    
                    if (strTransmitCount.intValue < 1) {
                        curTransmitInfo = @"还没有人转发";
                    } else {
                        curTransmitInfo = [dicResult objectForKey:transmitInfoKey];
                        if (![LyUtil validateString:curTransmitInfo]) {
                            curTransmitInfo = [[NSString alloc] initWithFormat:@"已有%d人转发", strTransmitCount.intValue];
                        }
                    }
                    
                    if (strPraiseCount.intValue < 1) {
                        curPraiseInfo = @"还没有人点赞";
                    } else {
                        curPraiseInfo = [dicResult objectForKey:praiseInfoKey];
                        if (![LyUtil validateString:curPraiseInfo]) {
                            curPraiseInfo = [[NSString alloc] initWithFormat:@"已有%d人点赞", strPraiseCount.intValue];
                        }
                    }
                    
                    NSArray *arrEva = [dicResult objectForKey:evaluationKey];
                    if ([LyUtil validateArray:arrEva]) {
                        
                        for (NSDictionary *dicItem in arrEva) {
                            
                            if (![LyUtil validateDictionary:dicItem]) {
                                continue;
                            }
                            
                            NSString *strId = [dicItem objectForKey:idKey];
                            NSString *strObjectingId = [dicItem objectForKey:objectingIdKey];
                            NSString *strContent = [dicItem objectForKey:contentKey];
                            NSString *strMasterId = [dicItem objectForKey:masterIdKey];
                            NSString *strMasterName = [dicItem objectForKey:nickNameKey];
                            NSString *strTime = [dicItem objectForKey:timeKey];
                            NSString *strObjectId = [dicItem objectForKey:objectIdKey];
                            
                            strTime = [LyUtil fixDateTimeString:strTime];
                            
                            if (![LyUtil validateString:strContent]) {
                                strContent = @" ";
                            }
                            
                            if (![LyUtil validateString:strId] || ![LyUtil validateString:strMasterId]) {
                                continue;
                            }
                            
                            LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:strMasterId];
                            if (!user) {
                                
                                if (![LyUtil validateString:strMasterName]) {
                                    strMasterName = [LyUtil getUserNameWithUserId:strMasterId];
                                }
                                
                                user = [LyUser userWithId:strMasterId
                                                 userName:strMasterName];
                                
                                [[LyUserManager sharedInstance] addUser:user];
                            }
                            
                            LyUser *objectUser = [[LyUserManager sharedInstance] getUserWithUserId:strObjectId];
                            if (!objectUser) {
                                NSString *strObjectName = [LyUtil getUserNameWithUserId:strObjectId];
                                objectUser = [LyUser userWithId:strObjectId
                                                       userName:strObjectName];
                                
                                [[LyUserManager sharedInstance] addUser:objectUser];
                            }
                            
                            NSString *strAddtionalId = [dicItem objectForKey:aboutMeObjectAmIdKey];
                            if (![LyUtil validateString:strAddtionalId]) {
                                //没有附加id为评价
                                LyEvaluation *eva = [[LyEvalutionManager sharedInstance] getEvalutionWithId:strId];
                                if (!eva) {
                                    eva = [LyEvaluation evaluationWithId:strId
                                                                 content:strContent
                                                                    time:strTime
                                                                masterId:strMasterId
                                                                objectId:strObjectId];
                                    eva.objectingId = strObjectingId;
                                    
                                    [[LyEvalutionManager sharedInstance] addEvalutionWithEvaId:eva];
                                }
                            } else {
                                //有附加id为回复
                                LyReply *reply = [[LyReplyManager sharedInstance] getReplyWithId:strId];
                                if (!reply) {
                                    reply = [LyReply replyWithId:strId
                                                        masterId:strMasterId
                                                        objectId:strObjectId
                                                     objectingId:strObjectingId
                                                         content:strContent
                                                            time:strTime
                                                      objectRpId:strAddtionalId];
                                    
                                    [[LyReplyManager sharedInstance] addReply:reply];
                                }
                            }
                        }
                    }
                    
                    arrEvaluation = [[LyEvalutionManager sharedInstance] getEvalutionForObjectingId:_news.newsId];
                    
                    [_news setNewsTransmitCount:strTransmitCount.intValue];
                    [_news setNewsEvaluationCount:strEvaluationCount.intValue];
                    [_news setNewsPraiseCount:strPraiseCount.intValue];
                    
                    
                    [self reloadData];
                    
                    [indicator stopAnimation];
                    [self.refreshControl endRefreshing];
                    
                    flagLoadSuccess = YES;
                    
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case newsDetailHttpMethod_praise: {
            switch ( [strCode integerValue]) {
                case 0: {
                    NSLog(@"赞成功");
                    break;
                }
                default: {
                    NSLog(@"赞失败");
                    break;
                }
            }
            break;
        }
        case newsDetailHttpMethod_depraise: {
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
        case newsDetailHttpMethod_transmit: {
            switch ( [strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"转发失败"] show];
                        return;
                    }
                    
                    NSString *strId = [dicResult objectForKey:newsIdKey];
                    NSString *strTime = [dicResult objectForKey:newsTimeKey];
                    NSString *strContent = [dicResult objectForKey:contentKey];
//                    NSString *strPicCount = [dicResult objectForKeyedSubscript:picCountKey];
                    
                    
                    strTime = [LyUtil fixDateTimeString:strTime];
                    
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
                            
                            [newNews addPic:nil picUrl:strImageUrl index:i];
                        }
                    }
                    
                    [[LyNewsManager sharedInstance] addNews:newNews];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"转发成功"] show];
                    
                    break;
                }
                default: {
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"转发失败"] show];
                    break;
                }
            }
            break;
        }
        case newsDetailHttpMethod_delete: {
            switch ( [strCode integerValue]) {
                case 0: {
                    [[LyNewsManager sharedInstance] deleteNews:_news];
                    
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
    if (bHttpFlag) {
        bHttpFlag = NO;
        curHttpMethod = ahttpRequest.mode;
        [self analysisHttpResult:result];
    }
    
    curHttpMethod = 0;
}


#pragma mark -LyNewsTableViewCellDelegate
- (void)onClickedForDeleteByNewsTVC:(LyNewsTableViewCell *)aCell {
    if ( [[LyCurrentUser curUser] isLogined] && [_news.newsMasterId isEqualToString:[LyCurrentUser curUser].userId]) {
        
        UIAlertController *action = [UIAlertController alertControllerWithTitle:@"你确定要删除动态吗？"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        [action addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
        [action addAction:[UIAlertAction actionWithTitle:@"删除"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    [self delete];
                                                }]];
        
        [self presentViewController:action animated:YES completion:nil];
    }
}

- (void)onClickedForUserByNewsTVC:(LyNewsTableViewCell *)aCell {
    if ( ![_delegate isKindOfClass:[LyCommunityViewController class]]) {
        return;
    }
    
    LyUserDetailViewController *userDetail = [[LyUserDetailViewController alloc] init];
    [userDetail setDelegate:self];
    [self.navigationController pushViewController:userDetail animated:YES];

}


- (void)needRefresh:(LyNewsTableViewCell *)aCell {
//    [_tvNews reloadRowsAtIndexPaths:@[[_tvNews indexPathForCell:aCell]] withRowAnimation:UITableViewRowAnimationNone];
//    NSIndexPath *indexPath = [_tvNews indexPathForCell:aCell];
//    if (indexPath) {
//        [_tvNews reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    }
    
    [_tvNews reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                  withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark -LyUserDetailDelegate
- (NSString *)obtainUserId {
    return _news.newsMasterId;
}



#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(LyRemindView *)aRemind {
    [_delegate onDeleteByNewsDetailVC:self];
}



#pragma mark -LyNewsDetailExtBarDelegate
- (void)onClickedTransmitByNewsDetailExtBar:(LyNewsDetailExtBar *)aExtBar {
    [self setShowIndex:newsDetailShowIndex_transmit];
}

- (void)onClickedEvalutionByNewsDetailExtBar:(LyNewsDetailExtBar *)aExtBar {
    [self setShowIndex:newsDetailShowIndex_evaluation];
}

- (void)onClickedPraiseByNewsDetailExtBar:(LyNewsDetailExtBar *)aExtBar {
    [self setShowIndex:newsDetailShowIndex_praise];
}


#pragma mark -LyNewsDetailControlBarDelegate
- (void)onClickedForPraiseByNewsDetailControlBar:(LyNewsDetailControlBar *)aControlBar {
    
    [_news praise];
    [self.controlBar setPraise:_news.isPraised];
    
    if ( [_news isPraised]) {
        [self praise];
    } else {
        [self depraise];
    }
}

- (void)onClickedForEvaluteByNewsDetailControlBar:(LyNewsDetailControlBar *)aControlBar {
    LyEvaluateNewsViewController *evaluateNews = [[LyEvaluateNewsViewController alloc] init];
    [evaluateNews setDelegate:self];
    UINavigationController *evaluateNewsNC = [[UINavigationController alloc] initWithRootViewController:evaluateNews];
    [self presentViewController:evaluateNewsNC animated:YES completion:nil];
}


- (void)onClickedForTransmitByNewsDetailControlBar:(LyNewsDetailControlBar *)aControlBar {
    UIAlertController *action = [UIAlertController alertControllerWithTitle:@"你要转发这条动态吗？"
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

}


#pragma mark -LyEvaluatteNewsViewControllerDelegate
- (LyNews *)obtainNewsByEvaluateNewsVC:(LyEvaluateNewsViewController *)aEvaluateNewsVC {
    return _news;
}

- (void)onDoneByEvaluateNewsVC:(LyEvaluateNewsViewController *)aEvaluateNewsVC {
    [aEvaluateNewsVC dismissViewControllerAnimated:YES completion:^{
        [self load];
    }];

}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tvNews) {

        if (_news.cellHeight < 10) {
            LyNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyNewsDetailTvNewsCellReuseIdentifier];
            if (!cell) {
                cell = [[LyNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyNewsDetailTvNewsCellReuseIdentifier];
            }
            
            [cell setNews:_news mode:LyNewsTableViewCellMode_community];
        }
        
        
        CGFloat hegiht = _news.cellHeight - ntcBtnFuncHeight - ntcVerticalSpace;
        
        if (CGRectGetHeight(self.tvNews.frame) != hegiht) {
            [self.tvNews setFrame:CGRectMake( 0, 0, SCREEN_WIDTH, hegiht)];
        }
        
        return hegiht;
    } else {
        LyEvaluationForNewsTableViewCell *cell = [[LyEvaluationForNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyNewsDetailTableViewCellResueIdentifier];
        [cell setEva:[arrEvaluation objectAtIndex:indexPath.row]];
        
        return cell.height;
    }
    
    return 0;
}


#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tvNews) {
        return _news ? 1 : 0;
    } else {
        return flagHideEvaluation ? 0 : arrEvaluation.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tvNews) {
        LyNewsTableViewCell *cell = [self.tvNews dequeueReusableCellWithIdentifier:lyNewsDetailTvNewsCellReuseIdentifier forIndexPath:indexPath];
        if ( !cell) {
            cell = [[LyNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyNewsDetailTvNewsCellReuseIdentifier];
        }
        
        [cell setNews:_news mode:LyNewsTableViewCellMode_detail];
        [cell setDelegate:self];
        
        return cell;
    } else {
        LyEvaluationForNewsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:lyNewsDetailTableViewCellResueIdentifier forIndexPath:indexPath];
        if ( !cell) {
            cell = [[LyEvaluationForNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyNewsDetailTableViewCellResueIdentifier];
        }
        [cell setEva:[arrEvaluation objectAtIndex:indexPath.row]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    return nil;
}


#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        
        if (scrollView.contentOffset.y > CGRectGetHeight(self.tvNews.frame)) {
            [self.extBar setFrame:extBarFrame_let];
            [self.view addSubview:self.extBar];
        } else {
            [self.extBar setFrame:extBarFrame_var];
            [viewHeader addSubview:self.extBar];
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
