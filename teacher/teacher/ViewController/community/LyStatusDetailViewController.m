//
//  LyStatusDetailViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyStatusDetailViewController.h"
#import "LyStatusTableViewCell.h"
//#import "LyEvalutionForNewsTableViewCell.h"
#import "LyEvaluationForNewsTableViewCell.h"
#import "LyStatusDetailControlBar.h"
#import "LyStatusDetailExtBar.h"
#import "LyTableViewFooterView.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyStatusManager.h"
#import "LyEvalutionManager.h"
#import "LyUserManager.h"
#import "LyReplyManager.h"


#import "LyMacro.h"
#import "LyUtil.h"


#import "LyCommunityViewController.h"

#import "LyStatusEvaluteViewController.h"
#import "LyUserDetailViewController.h"




#define sdWidth                         FULLSCREENWIDTH
#define sdHeight                        FULLSCREENHEIGHT


#define svMainWidth                     sdWidth
#define svMainHeight                    (sdHeight-STATUSBARHEIGHT-NAVIGATIONBARHEIGHT)


#define tvStatusWidth                   svMainWidth
CGFloat const tvStatusHeight = 50.0f;



#define extBarFrame                     CGRectMake( 0, STATUSBARHEIGHT+NAVIGATIONBARHEIGHT, sdebWidth, sdebHeight)



#define svExtWidth                      svMainWidth
CGFloat const svExtHeight = 100.0f;


#define viewInfoItemWidth               svExtWidth
CGFloat const viewInfoItemHeight = svExtHeight;


#define tvInfoItemWidth                 (viewInfoItemWidth-horizontalSpace*2)
#define tvInfoItemHeight                viewInfoItemHeight





typedef NS_ENUM( NSInteger, LyStatusDetailTableViewMode)
{
    statusDetailTableViewMode_status = 1,
    statusDetailTableViewMode_evalution
};



typedef NS_ENUM( NSInteger, LyStatusDetailActionSheetMode)
{
    statusDetailActionSheetMode_delete = 10,
    statusDetailActionSheetMode_transmit
};



typedef NS_ENUM( NSInteger, LyStatusDetailHttpMethod)
{
    statusDetailHttpMethod_load = 20,
    statusDetailHttpMethod_loadMoreEvalution,
//    statusDetailHttpMethod_loadPraiseInfo,
//    statusDetailHttpMethod_loadTransmitInfo,
    
    statusDetailHttpMethod_praise,
    statusDetailHttpMethod_depraise,
    statusDetailHttpMethod_transmit,
    statusDetailHttpMethod_delete
    
};



NSString *const lyStatusDetailStatusTableViewCellReuseIdentifier = @"lyStatusDetailStatusTableViewCellReuseIdentifier";

NSString *const lyStatusDetailEvaluationTableViewCellReuseIdentifier = @"lyStatusDetailEvaluationTableViewCellReuseIdentifier";



@interface LyStatusDetailViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, LyHttpRequestDelegate, LyStatusDetailExtBarDelegate, LyStatusDetailControlBarDelegate, LyStatusEvaluteViewControllerDelegate, LyTableViewFooterViewDelegate, UIActionSheetDelegate, LyUserDetailDelegate, LyStatusTableViewCellDelegate, LyRemindViewDelegate>
{
    BOOL                            flagForSetTvStatus;
    BOOL                            flagForSetTvEvalution;
    CGFloat                         heightForTvEvalution;
    
    BOOL                            flagForDragToLoadMore;
    
    UIRefreshControl                *refresher;
    LyIndicator                     *indicator_load;
    UIView                          *viewError;
    
    
    UIScrollView                    *svMain;
    
    UITableView                     *tvStatus;
    
    
    UIScrollView                    *svExt;
    
    UIView                          *viewTransmit;
    UITextView                      *tvTransmitInfo;
    UILabel                         *lbNull_transmit;
    UIView                          *viewEvalution;
    UITableView                     *tvEvalution;
    UILabel                         *lbNull_evlaution;
    UIView                          *viewPraise;
    UITextView                      *tvPraiseInfo;
    UILabel                         *lbNull_praise;
    
    
    
    
    LyStatusDetailExtBar            *extBar;
    LyStatusDetailControlBar        *controlBar;
    
    
    LyIndicator                     *indicator_delete;
    
    
    NSString                        *praiseInfo;
    NSString                        *transmitInfo;
    NSArray                         *arrEvaluation;
    NSInteger                       currentIndex;
    
    
    BOOL                            flagLoadSuccess;
    BOOL                            bHttpFlag;
    LyStatusDetailHttpMethod        curHttpMethod;
}
@end

@implementation LyStatusDetailViewController

//lySingle_implementation(LyStatusDetailViewController)


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}




- (void)viewWillAppear:(BOOL)animated
{
    [controlBar setHidden:YES];
}



- (void)viewDidAppear:(BOOL)animated
{
    LyStatus *status;
    if ( [_delegate respondsToSelector:@selector(obtainStatusByStatusDetailViewController:)])
    {
        status = [_delegate obtainStatusByStatusDetailViewController:self];
    }
    
    
    if ( !status)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    
    if ( status == _status && flagLoadSuccess)
    {
        return;
    }
    
    _status = status;
    
    [self setControlBarHidden:NO];
    
    
    flagLoadSuccess = NO;
    flagForSetTvStatus = NO;
    flagForSetTvEvalution = NO;
    
    
    [tvStatus reloadData];
}



- (void)viewWillDisappear:(BOOL)animated
{
    
}


- (void)initAndLayoutSubviews
{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.title = @"动态正文";
    
    
    
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, STATUSBARHEIGHT+NAVIGATIONBARHEIGHT, svMainWidth, svMainHeight)];
    [svMain setBackgroundColor:[UIColor whiteColor]];
    [svMain setDelegate:self];
    [svMain setBounces:YES];
    [self.view addSubview:svMain];
    
    [svMain setContentSize:CGSizeMake( svMainWidth, svMainHeight*2)];
    
    refresher = [LyUtil refreshControlWithTitle:nil
                                         target:self
                                         action:@selector(refreshData:)];
    [svMain addSubview:refresher];
    
    
    
    tvStatus = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, tvStatusWidth, tvStatusHeight)
                                            style:UITableViewStylePlain];
    [tvStatus setTag:statusDetailTableViewMode_status];
    [tvStatus setDelegate:self];
    [tvStatus setDataSource:self];
    [tvStatus setScrollEnabled:NO];
    [tvStatus setScrollsToTop:NO];
    [tvStatus setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tvStatus registerClass:[LyStatusTableViewCell class] forCellReuseIdentifier:lyStatusDetailStatusTableViewCellReuseIdentifier];
    
    [svMain addSubview:tvStatus];
    
    
    extBar = [[LyStatusDetailExtBar alloc] initWithFrame:extBarFrame];
    [extBar setOpaque:YES];
    [extBar setDelegate:self];
    [svMain addSubview:extBar];
    
    svExt = [[UIScrollView alloc] init];
    [svExt setBackgroundColor:[UIColor whiteColor]];
    [svExt setBounces:NO];
    [svExt setScrollsToTop:NO];
    [svExt setScrollEnabled:NO];
    [svMain addSubview:svExt];
    
    
    
    viewTransmit = [[UIView alloc] initWithFrame:CGRectMake( svExtWidth*0, 0, viewInfoItemWidth, viewInfoItemHeight)];
    tvTransmitInfo = [[UITextView alloc] initWithFrame:CGRectMake( horizontalSpace, 0, tvInfoItemWidth, tvInfoItemHeight)];
    [tvTransmitInfo setScrollEnabled:NO];
    [tvTransmitInfo setScrollsToTop:NO];
    [tvTransmitInfo setEditable:NO];
    lbNull_transmit = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, 0, tvInfoItemWidth, LyNullItemHeight)];
    [lbNull_transmit setText:@"还没有人转发"];
    [lbNull_transmit setFont:LyNullItemTitleFont];
    [lbNull_transmit setTextColor:LyNullItemTextColor];
    [lbNull_transmit setTextAlignment:NSTextAlignmentCenter];
    [viewTransmit addSubview:tvTransmitInfo];
    [viewTransmit addSubview:lbNull_transmit];
    [lbNull_transmit setHidden:YES];
    
    viewEvalution = [[UIView alloc] initWithFrame:CGRectMake( svExtWidth*1, 0, viewInfoItemWidth, viewInfoItemHeight)];
    tvEvalution = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, viewInfoItemWidth, viewInfoItemHeight)
                                               style:UITableViewStylePlain];
    [tvEvalution setTag:statusDetailTableViewMode_evalution];
    [tvEvalution setDelegate:self];
    [tvEvalution setDataSource:self];
    [tvEvalution setScrollsToTop:NO];
    [tvEvalution setScrollEnabled:NO];
    [tvEvalution registerClass:[LyEvaluationForNewsTableViewCell class] forCellReuseIdentifier:lyStatusDetailEvaluationTableViewCellReuseIdentifier];
    
    lbNull_evlaution = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, tvInfoItemWidth, LyNullItemHeight)];
    [lbNull_evlaution setText:@"还没有评论"];
    [lbNull_evlaution setFont:LyNullItemTitleFont];
    [lbNull_evlaution setTextColor:LyNullItemTextColor];
    [lbNull_evlaution setTextAlignment:NSTextAlignmentCenter];
    [viewEvalution addSubview:tvEvalution];
    [viewEvalution addSubview:lbNull_evlaution];
    [lbNull_evlaution setHidden:YES];
    
    
    
    viewPraise = [[UIView alloc] initWithFrame:CGRectMake( svExtWidth*2, 0, viewInfoItemWidth, viewInfoItemHeight)];
    tvPraiseInfo = [[UITextView alloc] initWithFrame:CGRectMake( horizontalSpace, 0, tvInfoItemWidth, tvInfoItemHeight)];
    [tvPraiseInfo setScrollEnabled:NO];
    [tvPraiseInfo setScrollsToTop:NO];
    [tvPraiseInfo setEditable:NO];
    lbNull_praise = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, tvInfoItemWidth, LyNullItemHeight)];
    [lbNull_praise setText:@"还没有人赞"];
    [lbNull_praise setFont:LyNullItemTitleFont];
    [lbNull_praise setTextColor:LyNullItemTextColor];
    [lbNull_praise setTextAlignment:NSTextAlignmentCenter];
    [viewPraise addSubview:tvPraiseInfo];
    [viewPraise addSubview:lbNull_praise];
    [lbNull_praise setHidden:YES];
    
    
    
    [svExt addSubview:viewPraise];
    [svExt addSubview:viewEvalution];
    [svExt addSubview:viewTransmit];
    
    
    
//    tvFooterView = [[LyTableViewFooterView alloc] initWithFrame:CGRectMake( 0, svMain.contentSize.height, FULLSCREENWIDTH, tvFooterViewDefaultHeight)];
//    [tvFooterView setDelegate:self];
//    [svMain addSubview:tvFooterView];
    
    
    
    controlBar = [[LyStatusDetailControlBar alloc] init];
    [controlBar setDelegate:self];
    [self.view addSubview:controlBar];
    
    
}



- (void)setControlBarHidden:(BOOL)isHidden
{
    if ( [[LyCurrentUser currentUser] isLogined] && [[_status staMasterId] isEqualToString:[[LyCurrentUser currentUser] userId]])
    {
        [controlBar setHidden:YES];
    }
    else
    {
        [controlBar setHidden:isHidden];
    }
}



- (void)showViewError
{
    if ( !viewError)
    {
        viewError = [[UIView alloc] init];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        UILabel *lbError = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, FULLSCREENWIDTH, LyLbErrorHeight)];
        [lbError setFont:LyNullItemTitleFont];
        [lbError setTextColor:LyNullItemTextColor];
        [lbError setTextAlignment:NSTextAlignmentCenter];
        [lbError setBackgroundColor:LyWhiteLightgrayColor];
        [lbError setText:@"加载失败，下拉再次加载"];
        
        [viewError addSubview:lbError];
    }
    
    [svExt setHidden:YES];
    
    if ( CGRectGetHeight(extBar.frame) + LyLbErrorHeight < svMainHeight)
    {
        [svMain setContentSize:CGSizeMake( svMainWidth, svMainHeight*1.1f)];
        [viewError setFrame:CGRectMake( 0, extBar.frame.origin.y+CGRectGetHeight(extBar.frame)+verticalSpace, FULLSCREENWIDTH, svMainHeight*1.1f-(extBar.frame.origin.y+CGRectGetHeight(extBar.frame)))];
        [svMain addSubview:viewError];
        [svMain bringSubviewToFront:viewError];
    }
    else
    {
        [svMain setContentSize:CGSizeMake( svMainWidth, CGRectGetHeight(extBar.frame) + LyLbErrorHeight)];
        [viewError setFrame:CGRectMake( 0, extBar.frame.origin.y+CGRectGetHeight(extBar.frame)+verticalSpace, FULLSCREENWIDTH, LyLbErrorHeight)];
        [svMain addSubview:viewError];
        [svMain bringSubviewToFront:viewError];
    }
    
}


- (void)removeViewError
{
    [viewError removeFromSuperview];
    [svExt setHidden:NO];
}



- (void)reLayoutSubviews
{
    if ( !flagLoadSuccess)
    {
        [self loadData];
    }
    
    
    
    [extBar setFrame:CGRectMake( 0, tvStatus.frame.origin.y+CGRectGetHeight(tvStatus.frame)+verticalSpace, sdebWidth, sdebHeight)];
    
    [extBar setTransmitCount:[_status staTransmitCount]];
    [extBar setEvalutionCount:[_status staEvalutionCount]];
    [extBar setPraiseCount:[_status staPraiseCount]];

    
    if ( CGRectGetHeight([svExt frame]) < svExtHeight)
    {
        [svExt setFrame:CGRectMake( 0, extBar.frame.origin.y+CGRectGetHeight(extBar.frame), svExtWidth, svExtHeight)];
    }
    else
    {
        [svExt setFrame:CGRectMake( 0, extBar.frame.origin.y+CGRectGetHeight(extBar.frame), CGRectGetWidth(svExt.frame), CGRectGetHeight(svExt.frame))];
    }
    if ( [_status staTransmitCount] < 1)
    {
        [tvTransmitInfo setText:@""];
        [tvTransmitInfo setHidden:YES];
        [lbNull_transmit setHidden:NO];
    }
    else
    {
        if ( !transmitInfo || [transmitInfo isKindOfClass:[NSNull class]] || [transmitInfo isEqualToString:@""])
        {
            [tvTransmitInfo setText:@""];
            [tvTransmitInfo setHidden:YES];
            [lbNull_transmit setHidden:NO];
        }
        else
        {
            [tvTransmitInfo setText:transmitInfo];
            [tvTransmitInfo setHidden:NO];
            [lbNull_transmit setHidden:YES];
        }
    }
    
    if ( [_status staEvalutionCount] < 1)
    {
        [tvEvalution setHidden:YES];
        [lbNull_evlaution setHidden:NO];
    }
    else
    {
        [tvEvalution setHidden:NO];
        [lbNull_evlaution setHidden:YES];
    }
    
    if ( [_status staPraiseCount] < 1)
    {
        [tvPraiseInfo setHidden:YES];
        [lbNull_praise setHidden:NO];
    }
    else
    {
        if ( !praiseInfo || [praiseInfo isKindOfClass:[NSNull class]] || [praiseInfo isEqualToString:@""])
        {
            [tvPraiseInfo setText:@""];
            [tvPraiseInfo setHidden:YES];
            [lbNull_praise setHidden:NO];
        }
        else
        {
            [tvPraiseInfo setText:praiseInfo];
            [tvPraiseInfo setHidden:NO];
            [lbNull_praise setHidden:YES];
        }
    }
    
    [controlBar setPraise:[_status isPraised]];
    
    [self setExtBarSelectedItem:[NSIndexPath indexPathForRow:1 inSection:0]];
}



- (void)setExtBarSelectedItem:(NSIndexPath *)indexPath
{
    [extBar setSelectedItem:indexPath];
    if ( 0 == [indexPath section])
    {
        CGPoint x = CGPointMake( svExtWidth*[indexPath row], 0);
        [svExt setContentOffset:x animated:NO];
    }
    else
    {
        [svExt setContentOffset:CGPointMake( svExtWidth*2, 0) animated:NO];
    }
    
    
}


- (void)refreshData:(UIRefreshControl *)refreshControl
{
    [self loadData];
}




- (void)loadData
{
    if ( !indicator_load)
    {
        indicator_load = [[LyIndicator alloc] initWithTitle:@""];
    }
    [indicator_load startInView:self.view];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:statusDetailHttpMethod_load];
    [httpRequest setDelegate:self];
    bHttpFlag = [httpRequest startHttpRequest:statusDetail_url
                                  requestBody:@{
                                                statusIdKey:[_status staId],
                                                objectIdKey:[_status staMasterId],
                                                sessionIdKey:[LyUtil httpSessionId]
                                                }
                                  requestType:AsynchronousPost
                                      timeOut:0];
}


- (void)handleHttpFailed {
    if ([indicator_load isAnimating]) {
        [indicator_load stop];
        [refresher endRefreshing];
        [self showViewError];
    }
    
    if ([indicator_delete isAnimating]) {
        [indicator_delete stop];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"删除失败"] show];
    }
    
    if ( flagForDragToLoadMore)
    {
        flagForDragToLoadMore = NO;
        [svMain setContentSize:CGSizeMake( [svMain contentSize].width, [svMain contentSize].height-tvFooterViewDefaultHeight)];
    }
}



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
        [indicator_load stop];
        [indicator_delete stop];
        [refresher endRefreshing];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_load stop];
        [indicator_delete stop];
        [refresher endRefreshing];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch ( curHttpMethod) {
        case statusDetailHttpMethod_load: {
            curHttpMethod = 0;
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if ( !dicResult || [dicResult isKindOfClass:[NSNull class]] || ![dicResult isKindOfClass:[NSDictionary class]] || ![dicResult count])
                    {
                        [indicator_load stop];
                        [refresher endRefreshing];
                        [self showViewError];
                        return;
                    }
                    
                    NSString *strPraiseCount = [dicResult objectForKey:statusPraiseCountKey];
                    NSString *strEvalutionCount = [dicResult objectForKey:statusEvalutionCountKey];
                    NSString *strTransmitCount = [dicResult objectForKey:statusTransmitCountKey];
                    
                    transmitInfo = [dicResult objectForKey:transmitInfoKey];
                    praiseInfo = [dicResult objectForKey:praiseInfoKey];
                    
                    
                    [_status setStaTransmitCount:[strTransmitCount intValue]];
                    [_status setStaEvalutionCount:[strEvalutionCount intValue]];
                    [_status setStaPraiseCount:[strPraiseCount intValue]];
                    
                    
                    
                    NSArray *arrEva = [dicResult objectForKey:evalutionKey];
                    if ( !arrEva || [arrEva isKindOfClass:[NSNull class]] || ![arrEva isKindOfClass:[NSArray class]] || ![arrEva count])
                    {
                        
                    }
                    else
                    {
                        for ( int i = 0; i < [arrEva count]; ++i) {
                            NSDictionary *dicItem = [arrEva objectAtIndex:i];
                            
                            NSString *strId = [dicItem objectForKey:idKey];
                            NSString *strObjectingId = [dicItem objectForKey:objectStatusIdKey];
                            NSString *strContent = [dicItem objectForKey:contentKey];
                            NSString *strMasterId = [dicItem objectForKey:masterIdKey];
                            NSString *strTime = [dicItem objectForKey:timeKey];
                            NSString *strMasterName = [dicItem objectForKey:nickNameKey];
                            NSString *strAvatarName = [dicItem objectForKey:avatarNameKey];
                            
                            NSString *strObjectId = [dicItem objectForKey:objectIdKey];
                            
                            
                            if ( !strContent || [strContent isKindOfClass:[NSNull class]] || [strContent rangeOfString:@"(null)"].length > 0)
                            {
                                strContent = @"";
                            }
                            
                            strTime = [LyUtil fixDateTimeString:strTime];
                            
                            
                            LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:strMasterId];
                            if ( !user)
                            {
                                user = [LyUser userWithId:strMasterId
                                                 userNmae:strMasterName
                                           userAvatarName:strAvatarName];
                                [[LyUserManager sharedInstance] addUser:user];
                            }
                            
                            
                            LyUser *objectUser = [[LyUserManager sharedInstance] getUserWithUserId:strObjectId];
                            if ( !objectUser)
                            {
                                NSString *strName = [LyUtil getUserNameWithUserId:strObjectId];
                                objectUser = [LyUser userWithId:strObjectId
                                                       userNmae:strName
                                                 userAvatarName:strAvatarName];
                                [[LyUserManager sharedInstance] addUser:objectUser];
                            }
                            
                            NSString *strAddtionalId = [dicItem objectForKey:aboutMeObjectAmIdKey];
                            
                            if ( !strAddtionalId || [strAddtionalId isKindOfClass:[NSNull class]] || ![strAddtionalId isKindOfClass:[NSString class]] || [strAddtionalId length] < 1 || [strAddtionalId rangeOfString:@"(null)"].length > 0)
                            {
                                LyEvalution *eva = [[LyEvalutionManager sharedInstance] getEvalutionWithId:strId];
                                if ( !eva)
                                {
                                    eva = [LyEvalution evalutionWithEvaId:strId
                                                               evaContent:strContent
                                                                  evaTime:strTime
                                                              evaMasterId:strMasterId
                                                            evaMasterName:strMasterName
                                                              evaObjectId:strObjectId
                                                           evaObjectintId:strObjectingId];
                                    
                                    [[LyEvalutionManager sharedInstance] addEvalutionWithEvaId:eva];
                                }
                            }
                            else
                            {
                                LyReply *reply = [[LyReplyManager sharedInstance] getReplyWithId:strId];
                                if ( !reply)
                                {
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
                    
                    arrEvaluation = [[LyEvalutionManager sharedInstance] getEvalutionForObjectingId:[_status staId]];
                    
                    currentIndex = [arrEva count];
                    
                    [indicator_load stop];
                    if ( [refresher isRefreshing])
                    {
                        [refresher endRefreshing];
                    }
                    [self removeViewError];
                    
                    flagLoadSuccess = YES;
                    [self reLayoutSubviews];
                    
                    flagForSetTvEvalution = NO;
                    heightForTvEvalution = 0;
                    
                    [tvEvalution reloadData];
                    break;
                }
                default: {
                   [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case statusDetailHttpMethod_loadMoreEvalution: {
            curHttpMethod = 0;
            
            switch ( [strCode integerValue]) {
                case 0: {
                    
                    NSArray *arrEva = [dic objectForKey:resultKey];
                    if ( !arrEva || [arrEva isKindOfClass:[NSNull class]] || ![arrEva isKindOfClass:[NSArray class]] || ![arrEva count])
                    {
                        if ( flagForDragToLoadMore)
                        {
                            flagForDragToLoadMore = NO;
                            [svMain setContentSize:CGSizeMake( [svMain contentSize].width, svExt.frame.origin.y+CGRectGetHeight(svExt.frame))];
                        }
                        [self setControlBarHidden:NO];
                        
                    }
                    else
                    {
                        for ( int i = 0; i < [arrEva count]; ++i) {
                            NSDictionary *dicItem = [arrEva objectAtIndex:i];
                            
                            NSString *strId = [dicItem objectForKey:idKey];
                            NSString *strObjectId = [dicItem objectForKey:objectStatusIdKey];
                            NSString *strContent = [dicItem objectForKey:contentKey];
                            NSString *strMasterId = [dicItem objectForKey:masterIdKey];
                            NSString *strTime = [dicItem objectForKey:timeKey];
                            NSString *strMasterName = [dicItem objectForKey:nickNameKey];
                            NSString *strAvatarName = [dicItem objectForKey:avatarNameKey];
                            
                            
                            if ( !strContent || [strContent isKindOfClass:[NSNull class]] || [strContent rangeOfString:@"(null)"].length > 0)
                            {
                                strContent = @"";
                            }
                            
                            strTime = [LyUtil fixDateTimeString:strTime];
                            
                            LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:strMasterId];
                            if ( !user)
                            {
                                user = [LyUser userWithId:strMasterId
                                                 userNmae:strMasterName
                                           userAvatarName:strAvatarName];
                                [[LyUserManager sharedInstance] addUser:user];
                            }
                            
                            LyEvalution *eva = [[LyEvalutionManager sharedInstance] getEvalutionWithId:strId];
                            if ( eva)
                            {
                                
                            }
                            else
                            {
                                eva = [LyEvalution evalutionWithEvaId:strId
                                                           evaContent:strContent
                                                              evaTime:strTime
                                                          evaMasterId:strMasterId
                                                        evaMasterName:strMasterName
                                                          evaObjectId:strObjectId];
                                
                                [[LyEvalutionManager sharedInstance] addEvalutionWithEvaId:eva];
                            }
                        }
                        
                    }
                    
                    arrEvaluation = [[LyEvalutionManager sharedInstance] getEvalutionForObjectId:[_status staId]];
                    
                    currentIndex += [arrEva count];
//                    [tvFooterView stopAnimation];
                    
                    heightForTvEvalution = 0;
                    flagForSetTvEvalution = NO;
                    
                    [self setExtBarSelectedItem:[NSIndexPath indexPathForRow:1 inSection:0]];
                    
                    [tvEvalution reloadData];
                    [self setControlBarHidden:NO];
                    break;
                }
                case 1: {
                    [self handleHttpFailed];
                    [self setControlBarHidden:NO];
                    break;
                }
                    
                default: {
                    [self handleHttpFailed];
                    [self setControlBarHidden:NO];
                    break;
                }
            }
            
            
            break;
        }
        case statusDetailHttpMethod_praise: {
            curHttpMethod = 0;
            
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
        case statusDetailHttpMethod_depraise: {
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
        case statusDetailHttpMethod_transmit: {
            curHttpMethod = 0;
            switch ( [strCode integerValue]) {
                case 0: {
                    
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if ( !dicResult || [dicResult isKindOfClass:[NSNull class]] || ![dicResult isKindOfClass:[NSDictionary class]] || ![dicResult count])
                    {
                        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"转发失败"] show];
                        return;
                    }
                    
                    NSString *strId = [dicResult objectForKey:statusIdKey];
                    NSString *strTime = [dicResult objectForKey:statusTimeKey];
                    NSString *strCentent = [dicResult objectForKey:contentKey];
                    NSString *strPicCount = [dicResult objectForKeyedSubscript:picCountKey];
                    
                    
                    strTime = [LyUtil fixDateTimeString:strTime];
                    
                    LyStatus *newStatus = [LyStatus statusWithStatusId:strId
                                                              masterId:[[LyCurrentUser currentUser] userId]
                                                                  time:strTime
                                                               content:strCentent
                                                              picCount:[strPicCount intValue]
                                                           praiseCount:0
                                                        evalutionCount:0
                                                         transmitCount:0];
                    
                    
                    if ( [strPicCount integerValue] > 0)
                    {
                        if ( [strPicCount integerValue] < 2)
                        {
                            NSArray *arrImgeUrl = [dicResult objectForKey:imageUrlKey];
                            if ( !arrImgeUrl || [NSNull null] == (NSNull *)arrImgeUrl || ![arrImgeUrl isKindOfClass:[NSArray class]] || ![arrImgeUrl count])
                            {
                                
                            }
                            else
                            {
                                NSString *strImageUrl = [arrImgeUrl objectAtIndex:0];
                                if ( strImageUrl)
                                {
                                    if ( [strImageUrl rangeOfString:@"http"].length < 1)
                                    {
                                        strImageUrl = [[NSString alloc] initWithFormat:@"%@%@", httpFix, strImageUrl];
                                    }
                                    UIImage *image = [LyUtil getPicFromServerWithUrl:strImageUrl isBig:NO];
                                    [newStatus addPic:image andBigPicUrl:strImageUrl withIndex:0];
                                }
                            }
                        }
                        else
                        {
                            NSArray *arrImgeUrl = [dicResult objectForKey:imageUrlKey];
                            if ( !arrImgeUrl || [NSNull null] == (NSNull *)arrImgeUrl || ![arrImgeUrl isKindOfClass:[NSArray class]] || ![arrImgeUrl count])
                            {
                                
                            }
                            else
                            {
                                for ( int j = 0; j < [arrImgeUrl count] && j < [strPicCount integerValue]; ++j)
                                {
                                    NSString *strImageUrl = [arrImgeUrl objectAtIndex:j];
                                    
                                    if ( strImageUrl)
                                    {
                                        [newStatus addPic:nil andBigPicUrl:strImageUrl withIndex:j];
                                    }
                                    
                                }
                            }
                        }
                        
                    }
                    
                    
                    [[LyStatusManager sharedInstance] addStatus:newStatus];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"转发成功"] show];
                    
                    break;
                }
                    
                case 1: {
                    
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"转发失败"] show];
                    break;
                }
                    
                default: {
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"转发失败"] show];
                    break;
                }
            }
            break;
        }
        case statusDetailHttpMethod_delete: {
            curHttpMethod = 0;
            switch ( [strCode integerValue]) {
                case 0: {
                    [[LyStatusManager sharedInstance] removeStatusWithStatusId:[_status staId]];
                    
                    [indicator_delete stop];
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
            [self setControlBarHidden:NO];
            
            break;
        }
    }
}




#pragma mark -LyHttpRequestHttpDelegate
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
    if ( bHttpFlag)
    {
        bHttpFlag = NO;
        curHttpMethod = [ahttpRequest mode];
        
        [self analysisHttpResult:result];
    }
    curHttpMethod = 0;
}




#pragma mark -LyUserDetailDelegate
- (NSString *)obtainUserId
{
    return [_status staMasterId];
}

#pragma mark -LyDriveSchoolDetailDelegate
- (NSString *)obtainDriveSchoolId
{
    return [_status staMasterId];
}

#pragma mark -LyCoachDetailDelegate
- (NSString *)obtainCoachId
{
    return [_status staMasterId];
}

#pragma mark -LyGuiderDetailDelegate
- (NSString *)obtainGuierId
{
    return [_status staMasterId];
}


#pragma mark -LyStatusTableViewCellDelegate
- (void)onClickedForBtnDelete:(LyStatusTableViewCell *)aCell
{
    if ( [[LyCurrentUser currentUser] isLogined] && [[_status staMasterId] isEqualToString:[[LyCurrentUser currentUser] userId]])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"你确定要删除动态吗？"
                                                                 delegate:self
                                                        cancelButtonTitle:@"否"
                                                   destructiveButtonTitle:@"删除"
                                                        otherButtonTitles:nil, nil];
        [actionSheet setTag:statusDetailActionSheetMode_delete];
        [actionSheet showInView:self.view];
    }
}

- (void)onClickedForUserByStatusTableViewCell:(LyStatusTableViewCell *)aCell
{
    if ( ![_delegate isKindOfClass:[LyCommunityViewController class]])
    {
        return;
    }
    
    LyUserDetailViewController *userDetail = [[LyUserDetailViewController alloc] init];
    [userDetail setDelegate:self];
    [self.navigationController pushViewController:userDetail animated:YES];
    
}


//
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( statusDetailActionSheetMode_delete == [actionSheet tag])
    {
        if ( 0 == buttonIndex)
        {
            if ( !indicator_delete)
            {
                indicator_delete = [LyIndicator indicatorWithTitle:@"正在删除..."];
            }
            [indicator_delete start];
            
            LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:statusDetailHttpMethod_delete];
            [httpRequest setDelegate:self];
            bHttpFlag = [[httpRequest startHttpRequest:deleteNews_url
                                          requestBody:@{
                                                        statusIdKey:[_status staId],
                                                        userIdKey:[[LyCurrentUser currentUser] userId],
                                                        sessionIdKey:[LyUtil httpSessionId],
                                                        userTypeKey:[[LyCurrentUser currentUser] userTypeByString]
                                                        }
                                          requestType:AsynchronousPost
                                               timeOut:0] boolValue];
        }
    }
    else if ( statusDetailActionSheetMode_transmit == [actionSheet tag])
    {
        if ( 0 == buttonIndex)
        {
            LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:_status.staMasterId];
            
            LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:statusDetailHttpMethod_transmit];
            [httpRequest setDelegate:self];
            bHttpFlag = [[httpRequest startHttpRequest:statusTransmit_url
                                          requestBody:@{
                                                        statusIdKey:[_status staId],
                                                        objectIdKey:[_status staMasterId],
                                                        userIdKey:[[LyCurrentUser currentUser] userId],
                                                        nickNameKey:[[LyCurrentUser currentUser] userName],
                                                        sessionIdKey:[LyUtil httpSessionId],
                                                        objectNameKey:user.userName,
                                                        userTypeKey:[[LyCurrentUser currentUser] userTypeByString]
                                                        }
                                          requestType:AsynchronousPost
                                              timeOut:0] boolValue];
        }
    }
}


#pragma mark -LyStatusEvaluteViewControllerDelegate
- (LyStatus *)obtainStatusByStatusEvalute:(LyStatusEvaluteViewController *)aStatusEvaluteViewController
{
    return _status;
}

- (void)onCancelStatusEvalute:(LyStatusEvaluteViewController *)aStatusEvaluteViewController
{
    [aStatusEvaluteViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)onDoneStatusEvalute:(LyStatusEvaluteViewController *)aStatusEvaluteViewController
{
    [aStatusEvaluteViewController dismissViewControllerAnimated:YES completion:^{
        
        [self loadData];
        
    }];
    
}



#pragma mark -LyStatusDetailExtBarDelegate
- (void)onClickedPraiseByStatusDetailExtBar:(LyStatusDetailExtBar *)aStatusDetailExtBar
{
    [svExt setContentOffset:CGPointMake( svExtWidth*2, 0) animated:YES];
    
    [svMain setContentOffset:CGPointMake( 0, 100.0f) animated:YES];
}

- (void)onClickedEvalutionByStatusDetailExtBar:(LyStatusDetailExtBar *)aStatusDetailExtBar
{
    [svExt setContentOffset:CGPointMake( svExtWidth*1, 0) animated:YES];
    
//    [svMain setContentOffset:CGPointMake( 0, CGRectGetHeight(tvStatus.frame))];
}

- (void)onClickedTransmitByStatusDetailExtBar:(LyStatusDetailExtBar *)aStatusDetailExtBar
{
    [svExt setContentOffset:CGPointMake( svExtWidth*0, 0) animated:YES];
    
    [svMain setContentOffset:CGPointMake( 0, 100.0f) animated:YES];
}



#pragma mark -LyTableViewFooterViewDelegate
- (void)loadMoreData:(LyTableViewFooterView *)tableViewFooterView
{
    ;
}




#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(UIView *)view
{
    [_delegate deleteFinishByStatusDetailViewController:self];
}


#pragma mark -LyStatusDetailControlBarDelegate
- (void)onClickedTransmitByStatusDetailControlBar:(LyStatusDetailControlBar *)aControlBar
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"你要转发这条动态吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"转发", nil];
    [actionSheet setDelegate:self];
    [actionSheet setTag:statusDetailActionSheetMode_transmit];
    [actionSheet showInView:self.view];
}

- (void)onClickedEvaluteByStatusDetailControlBar:(LyStatusDetailControlBar *)aControlBar
{
    LyStatusEvaluteViewController *statusEvaluate = [[LyStatusEvaluteViewController alloc] init];
    [statusEvaluate setDelegate:self];
    UINavigationController *statusEvaluteNavigationController = [[UINavigationController alloc] initWithRootViewController:statusEvaluate];
    [self presentViewController:statusEvaluteNavigationController animated:YES completion:nil];
}

- (void)onClickedPraiseByStatusDetailControlBar:(LyStatusDetailControlBar *)aControlBar
{
    if ( [_status isPraised])
    {
        [_status praise];
        [controlBar setPraise:[_status isPraised]];
        
        LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:statusDetailHttpMethod_depraise];
        [httpRequest setDelegate:self];
        bHttpFlag = [[httpRequest startHttpRequest:depraise_url
                                       requestBody:@{
                                                     objectIdKey:[_status staMasterId],
                                                     objectingIdKey:[_status staId],
                                                     userIdKey:[[LyCurrentUser currentUser] userId],
                                                     masterIdKey:[[LyCurrentUser currentUser] userId],
                                                     sessionIdKey:[LyUtil httpSessionId],
                                                     userTypeKey:[[LyCurrentUser currentUser] userTypeByString]
                                                     }
                                       requestType:AsynchronousPost
                                           timeOut:0] boolValue];
    }
    else
    {
        [_status praise];
        [controlBar setPraise:[_status isPraised]];
        
        LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:statusDetailHttpMethod_praise];
        [httpRequest setDelegate:self];
        bHttpFlag = [[httpRequest startHttpRequest:praise_url
                                       requestBody:@{
                                                     objectIdKey:[_status staMasterId],
                                                     objectingIdKey:[_status staId],
                                                     masterIdKey:[[LyCurrentUser currentUser] userId],
                                                     sessionIdKey:[LyUtil httpSessionId],
                                                     userTypeKey:[[LyCurrentUser currentUser] userTypeByString]
                                                     }
                                       requestType:AsynchronousPost
                                           timeOut:0] boolValue];
    }
}


#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( statusDetailTableViewMode_status == [tableView tag])
    {

        LyStatusTableViewCell *cell = [[LyStatusTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyStatusDetailStatusTableViewCellReuseIdentifier];
        [cell setStatus:_status andMode:LyStatusTableViewCellMode_statusDetail];
        if ( !flagForSetTvStatus)
        {
            flagForSetTvStatus = YES;
            [tvStatus setFrame:CGRectMake( 0, 0, tvStatusWidth, [cell stcHeight])];
            
            [self reLayoutSubviews];
        }

        return [cell stcHeight];
    }
    else
    {
        LyEvaluationForNewsTableViewCell *cell = [[LyEvaluationForNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyStatusDetailEvaluationTableViewCellReuseIdentifier];
        [cell setEva:[arrEvaluation objectAtIndex:[indexPath row]]];
        
        if ( !flagForSetTvEvalution)
        {
            if ( [arrEvaluation count] > [indexPath row]+1)
            {
                heightForTvEvalution += [cell height];
            }
            else
            {
                flagForSetTvEvalution = YES;
                heightForTvEvalution += [cell height];
                
                [tvEvalution setFrame:CGRectMake( 0, 0, viewInfoItemWidth, heightForTvEvalution)];
                
                if ( heightForTvEvalution < viewInfoItemHeight)
                {
                    [viewEvalution setFrame:CGRectMake( svExtWidth, 0, svExtWidth, viewInfoItemHeight)];
                }
                else
                {
                    [viewEvalution setFrame:CGRectMake( svExtWidth, 0, svExtWidth, heightForTvEvalution)];
                }
                
                [svExt setFrame:CGRectMake( 0, tvStatus.frame.origin.y+CGRectGetHeight(tvStatus.frame)+verticalSpace+CGRectGetHeight(extBar.frame), svExtWidth, viewEvalution.frame.origin.y+CGRectGetHeight(viewEvalution.frame))];
                [svExt setContentOffset:CGPointMake( svExtWidth, 0)];
                
                if ( svExt.frame.origin.y+CGRectGetHeight(svExt.frame)+sdcbHeight <= [svMain frame].size.height)
                {
                    [svMain setContentSize:CGSizeMake( svMainWidth, [svMain frame].size.height*1.1f)];
                }
                else
                {
                    [svMain setContentSize:CGSizeMake( svMainWidth, svExt.frame.origin.y+CGRectGetHeight(svExt.frame)+sdcbHeight)];
                }
//                [tvFooterView setFrame:CGRectMake( 0, [svMain contentSize].height, tvFooterViewWidth, tvFooterViewDefaultHeight)];
            }
        }
        
        return [cell height];
    }
    
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( statusDetailTableViewMode_status == [tableView tag])
    {
        if ( _status)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return [arrEvaluation count];
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( statusDetailTableViewMode_status == [tableView tag])
    {
        LyStatusTableViewCell *cell = [tvStatus dequeueReusableCellWithIdentifier:lyStatusDetailStatusTableViewCellReuseIdentifier forIndexPath:indexPath];
        if ( !cell)
        {
            cell = [[LyStatusTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyStatusDetailStatusTableViewCellReuseIdentifier];
        }
        [cell setStatus:_status andMode:LyStatusTableViewCellMode_statusDetail];
        [cell setDelegate:self];
        
        return cell;
    }
    else
    {
        LyEvaluationForNewsTableViewCell *cell = [tvEvalution dequeueReusableCellWithIdentifier:lyStatusDetailEvaluationTableViewCellReuseIdentifier forIndexPath:indexPath];
        if ( !cell)
        {
            cell = [[LyEvaluationForNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyStatusDetailEvaluationTableViewCellReuseIdentifier];
        }
        [cell setEva:[arrEvaluation objectAtIndex:[indexPath row]]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    return nil;
}


#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( scrollView == svMain)
    {
        if ( [svMain contentOffset].y > CGRectGetHeight([tvStatus frame]))
        {
            [extBar removeFromSuperview];
            [extBar setFrame:extBarFrame];
            [self.view addSubview:extBar];
        }
        else
        {
            [extBar removeFromSuperview];
            [extBar setFrame:CGRectMake( 0, tvStatus.frame.origin.y+CGRectGetHeight(tvStatus.frame)+verticalSpace, sdebWidth, sdebHeight)];
            [svMain addSubview:extBar];
        }
        
        
        if ( [svMain contentOffset].y > [svMain contentSize].height-svMainHeight)
        {
            [self setControlBarHidden:YES];
        }
        else
        {
            [self setControlBarHidden:NO];
        }
        
        
//        if ( [svMain contentOffset].y > bottomControlHideCerticality)
//        {
//            
//            CGFloat newOffsetY = [svMain contentOffset].y;
//            
//            
//            if ( newOffsetY > FULLSCREENHEIGHT && newOffsetY < oldOffsetY && oldOffsetY < offsetY)
//            {
//                UIView *view = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, FULLSCREENWIDTH, 20.0f)];
//                [view setBackgroundColor:Ly517ThemeColor];
//                UILabel *lbNotification = [[UILabel alloc] initWithFrame:view.bounds];
//                [lbNotification setText:@"点我回顶部"];
//                [lbNotification setFont:LyFont(12)];
//                [lbNotification setTextAlignment:NSTextAlignmentCenter];
//                [view addSubview:lbNotification];
//                [[NSNotificationCenter defaultCenter] postNotificationName:LyNotificationForShowNotification object:view];
//            }
//            
//            
//        }
    }

}


//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    
//    if ( [scrollView contentOffset].y + [scrollView frame].size.height > [scrollView contentSize].height)
//    {
//        if ( !tvFooterView)
//        {
//            tvFooterView = [[LyTableViewFooterView alloc] initWithFrame:CGRectMake( 0, svMain.contentSize.height, FULLSCREENWIDTH, tvFooterViewHeight)];
//            [tvFooterView setDelegate:self];
//        }
//        [tvFooterView setFrame:CGRectMake( 0, svMain.contentSize.height, FULLSCREENWIDTH, tvFooterViewDefaultHeight)];
//        
//        [svMain addSubview:tvFooterView];
//        [svMain setContentSize:CGSizeMake( svMainWidth, svMain.contentSize.height+tvFooterViewDefaultHeight)];
//        
//        [tvFooterView startAnimation];
//        
//        flagForDragToLoadMore = YES;
//        
//        [self loadMoreData];
//    }
//    
//}



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
