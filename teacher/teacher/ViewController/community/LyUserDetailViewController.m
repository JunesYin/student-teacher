//
//  LyUserDetailViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/15.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyUserDetailViewController.h"
#import "LyNewsTableViewCell.h"
#import "LyTableViewFooterView.h"
#import "LyDetailControlBar.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyUserManager.h"
#import "LyNewsManager.h"


#import "LyUtil.h"


#import "LyLoginViewController.h"
#import "LyNewsDetailViewController.h"
#import "LyEvaluateNewsViewController.h"


#import "LySweepViewController.h"

#import "UIViewController+backButtonHandler.h"


//用户信息
#define usdViewInfoWidth                                    SCREEN_WIDTH
CGFloat const usdViewInfoHeight = 200.0f;
CGFloat const infoHorizontalSpace = 7.0f;
CGFloat const infoVerticalSpace = 5.0f;
//用户信息-头像
CGFloat const infoIvAvatarWidth = 60.0f;
CGFloat const infoIvAvatarHeight = infoIvAvatarWidth;
//用户信息-姓名
#define infoLbNameWidth
CGFloat const infoLbNameHeight = 20.0f;
#define infoLbNameFont                                      LyFont(18)
//用户信息-姓别
CGFloat const infoIvSexWidth = 15.0f;
CGFloat const infoIvSexHeight = infoIvSexWidth;
//用户信息-年龄
#define infoLbAgeWidth
CGFloat const infoLbAgeHeight = infoLbNameHeight;
#define infoLbAgeFont                                       LyFont(14)
//用户信息-级别
#define infoIvLevelWidth                                    (infoIvLevelHeight*3.0f)
CGFloat const infoIvLevelHeight = infoLbNameHeight;
//用户信息-签名
#define infoTvSignatureWidth                                (SCREEN_WIDTH-horizontalSpace*2)
CGFloat const infoTvSignatureHeight = 40.0f;
#define infoTvSignatureFont                                 LyFont(13)


//动态


#define statusTvListWidth                                   usdViewStatusWidth
#define statusTvListHeight                                  usdViewStatusHeight

#define statusTvNullWidth                                   usdViewStatusWidth
#define statusTvNullHeight                                  (CGRectGetHeight(self.view.frame)-usdViewInfoHeight-usdViewControlHeight)

//控制台
#define usdViewControlWidth                                 SCREEN_WIDTH
CGFloat const usdViewControlHeight = 50.0f;
#define controlBtnAttenteWidth                              (usdViewControlWidth/2.0f)
#define controlBtnAttenteHeight                             usdViewControlHeight
#define controlBtnMessageWidth                              (usdViewControlWidth/2.0f)
#define controlBtnMessageHeight                             usdViewControlHeight




typedef NS_ENUM( NSInteger, LyUserDetailActionSheetMode)
{
    userDetailActionSheetMode_transmit = 10,
};



typedef NS_ENUM( NSInteger, LyUserDetailHttpMethod)
{
    userDetailHttpMethod_laod = 1,
    userDetailHttpMethod_loadMore,
    userDetailHttpMethod_attente,
    userDetailHttpMethod_deattente,
    userDetailHttpMethod_depraise,
    userDetailHttpMethod_praise,
    userDetailHttpMethod_transmit,
};



NSString *const lyUserDetailStatusTableViewCellReuseIdentifier = @"lyUserDetailStatusTableViewCellReuseIdentifier";


@interface LyUserDetailViewController () < UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, LyTableViewFooterViewDelegate, LyHttpRequestDelegate, LyDetailControlBarDelegate, LyNewsDetailViewControllerDelegate, LyEvaluateNewsViewControllerDelegate, BackButtonHandlerProtocol, LyNewsTableViewCellDelegate>
{
    UILabel                         *lbNavTitle;
    
    UIView                          *viewError;
    
    //用户信息
    UIView                          *usdViewInfo;
    UIImageView                     *usdIvBack;
    UIImageView                     *usdIvAvatar;
    UILabel                         *usdLbName;
    UIImageView                     *usdIvSex;
    UILabel                         *usdLbAge;
    UIImageView                     *usdIvLevel;
    UITextView                      *usdTvSignature;
    
    
    //动态列表
    UITableView                     *tvNews;
    
    UIView                          *viewNull;
    
    NSArray                         *arrNews;
    NSInteger                       currentIndex;
    
    LyTableViewFooterView           *tvFooterView;
    LyDetailControlBar              *controlBar;
    
    
    LyUser                          *user;
    
    
    NSIndexPath                     *curIdx;
    LyIndicator                     *indicator_oper;
    
    BOOL                            flagForDragToLoadMore;
    
    BOOL                            flagLoadSuccess;
    UIRefreshControl                *refresher;
    LyIndicator                     *indicator_load;
    BOOL                            bHttpFlag;
    LyUserDetailHttpMethod          curHttpMethod;
    
}
@end

@implementation LyUserDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndAddSubView];
}


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[LyUtil imageForImageName:@"uci_navigatinBar" needCache:NO] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController navigationBar].shadowImage = [LyUtil imageForImageName:@"uci_navigatinBar" needCache:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    NSString *strUserId = [_delegate obtainUserId];
    if ( !_userId || [_userId isEqualToString:strUserId] || !flagLoadSuccess) {
        _userId = strUserId;
        
        user = [[LyUserManager sharedInstance] getUserWithUserId:_userId];
        if (LyUserType_normal == user.userType) {
            [usdIvBack setImage:[LyUtil imageForImageName:@"viewInfo_background_s" needCache:NO]];
        } else {
            [usdIvBack setImage:[LyUtil imageForImageName:@"viewInfo_background_t" needCache:NO]];
        }
        [self refresh:refresher];
    }
}



- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [[self.navigationController navigationBar] setShadowImage:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


- (void)initAndAddSubView {
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    //动态表格
    tvNews = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-dcbHeight)
                                          style:UITableViewStylePlain];
    [tvNews setDelegate:self];
    [tvNews setDataSource:self];
    [tvNews setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tvNews setHidden:NO];
    [self.view addSubview:tvNews];
    
    
    
    
    refresher = [LyUtil refreshControlWithTitle:nil
                                         target:self
                                         action:@selector(refresh:)];
    [tvNews addSubview:refresher];
    
    
    tvFooterView = [LyTableViewFooterView tableViewFooterViewWithDelegate:self];
    [tvNews setTableFooterView:tvFooterView];
    
    
    
    //用户信息
    usdViewInfo = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, usdViewInfoWidth, usdViewInfoHeight)];
    [tvNews setTableHeaderView:usdViewInfo];
    //用户信息-背景
    usdIvBack = [[UIImageView alloc] initWithFrame:usdViewInfo.bounds];
    [usdIvBack setContentMode:UIViewContentModeScaleToFill];
    [usdViewInfo addSubview:usdIvBack];
    //用户信息-头像
    usdIvAvatar = [UIImageView new];
    [usdIvAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [[usdIvAvatar layer] setCornerRadius:infoIvAvatarWidth/2.0f];
    [usdIvAvatar setClipsToBounds:YES];
    [usdViewInfo addSubview:usdIvAvatar];
    
    
    //用户信息-姓名
    usdLbName = [UILabel new];
    [usdLbName setFont:infoLbNameFont];
    [usdLbName setTextColor:[UIColor whiteColor]];
    [usdLbName setTextAlignment:NSTextAlignmentCenter];
    [usdViewInfo addSubview:usdLbName];
    
    //用户信息-姓别
    usdIvSex = [UIImageView new];
    [usdIvSex setContentMode:UIViewContentModeScaleAspectFill];
    [[usdIvSex layer] setCornerRadius:infoIvSexWidth/2.0f];
    [usdIvSex setClipsToBounds:YES];
    [usdViewInfo addSubview:usdIvSex];
    
    //用户信息-年龄
    usdLbAge = [UILabel new];
    [usdLbAge setFont:infoLbAgeFont];
    [usdLbAge setTextColor:[UIColor whiteColor]];
    [usdLbAge setTextAlignment:NSTextAlignmentCenter];
    [usdViewInfo addSubview:usdLbAge];
    
    //用户信息-级别
    usdIvLevel = [UIImageView new];
    [usdIvLevel setContentMode:UIViewContentModeScaleAspectFill];
    [usdViewInfo addSubview:usdIvLevel];
    
    //用户信息-签名
    usdTvSignature = [UITextView new];
    [usdTvSignature setFont:infoTvSignatureFont];
    [usdTvSignature setTextColor:[UIColor whiteColor]];
    [usdTvSignature setBackgroundColor:[UIColor clearColor]];
    [usdTvSignature setScrollEnabled:NO];
    [usdTvSignature setEditable:NO];
    [usdTvSignature setTextAlignment:NSTextAlignmentCenter];
    [usdViewInfo addSubview:usdTvSignature];
    
    
    
    controlBar = [LyDetailControlBar controlBarWidthMode:LyDetailControlBarMode_user];
    [controlBar setDelegate:self];
    
    [self.view addSubview:controlBar];
    
}




- (void)reloadViewInfo
{
    //用户信息-头像
    NSString *strAvatarName;
    if (LyUserType_normal == user.userType)
    {
        [usdIvAvatar.layer setCornerRadius:infoIvAvatarWidth/2.0f];
        strAvatarName = @"ct_avatar";
    }
    else
    {
        [usdIvAvatar.layer setCornerRadius:btnCornerRadius];
        strAvatarName = @"ds_avatar";
    }
    
    if (!user.userAvatar)
    {
        [usdIvAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:[user userId]]
                    placeholderImage:[LyUtil imageForImageName:strAvatarName needCache:NO]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if (image) {
                                   [user setUserAvatar:image];
                               } else {
                                   [usdIvAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:[user userId]]
                                                       placeholderImage:[LyUtil imageForImageName:strAvatarName needCache:NO]
                                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                  if (image) {
                                                                      [user setUserAvatar:image];
                                                                  }
                                                              }];
                               }
                           }];
    } else {
        [usdIvAvatar setImage:[user userAvatar]];
    }
    
    //用户信息-姓名
    [usdLbName setText:[user userName]];
    
    if (LyUserType_school == user.userType)
    {
        [usdIvAvatar setFrame:CGRectMake( usdViewInfoWidth/2-infoIvAvatarWidth/2, 60.0f, infoIvAvatarWidth, infoIvAvatarHeight)];
        
        [usdIvSex setHidden:YES];
        [usdLbAge setHidden:YES];
        
        [usdLbName setFrame:CGRectMake(0, usdIvAvatar.ly_y+CGRectGetHeight(usdIvAvatar.frame)+infoVerticalSpace, SCREEN_WIDTH, infoLbNameHeight)];
        
        [usdLbAge setFrame:CGRectMake(0, usdLbName.ly_y+CGRectGetHeight(usdLbName.frame)+infoVerticalSpace, SCREEN_WIDTH, 0)];
    }
    else
    {
        [usdIvAvatar setFrame:CGRectMake( usdViewInfoWidth/2-infoIvAvatarWidth/2, 50.0f, infoIvAvatarWidth, infoIvAvatarHeight)];
        
        [usdIvSex setHidden:NO];
        
        CGSize sizeLbName = [[user userName] sizeWithAttributes:@{NSFontAttributeName:infoLbNameFont}];
        [usdLbName setFrame:CGRectMake( usdViewInfoWidth/2-(sizeLbName.width+infoIvSexWidth+infoHorizontalSpace)/2, usdIvAvatar.ly_y+usdIvAvatar.frame.size.height+infoVerticalSpace, sizeLbName.width, infoLbNameHeight)];
        
        //用户信息-姓别
        [usdIvSex setFrame:CGRectMake( usdLbName.frame.origin.x+usdLbName.frame.size.width+infoHorizontalSpace, usdLbName.ly_y+usdLbName.frame.size.height/2-infoIvSexHeight/2, infoIvSexWidth, infoIvSexHeight)];
        [LyUtil setSexImageView:usdIvSex withUserSex:[user userSex]];
        
        
        //用户信息-年龄
        NSString *strLbAge = [[NSString alloc] initWithFormat:@"%d岁", [user userAge]];
        [usdLbAge setFrame:CGRectMake( 0, usdLbName.ly_y+usdLbName.frame.size.height+infoVerticalSpace, SCREEN_WIDTH, infoLbAgeHeight)];
        [usdLbAge setText:strLbAge];
    }
    
    
    //用户信息-签名
    NSString *strSignature = [user userSignature];
    if ( !strSignature || [strSignature isKindOfClass:[NSNull class]] || [strSignature isEqualToString:@""])
    {
        strSignature = @"这个家伙很懒，什么都没留下";
    }
    [usdTvSignature setText:strSignature];
    [usdTvSignature setFrame:CGRectMake( horizontalSpace, usdLbAge.ly_y+usdLbAge.frame.size.height+infoVerticalSpace, infoTvSignatureWidth, infoTvSignatureHeight)];
    

    if ( [arrNews count] > 0)
    {
        [self removeViewNull];
        [tvNews reloadData];
    }
    else
    {
        [self showViewNull];
    }
    
    [self removeViewError];
}




- (void)showViewError
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    flagLoadSuccess = NO;
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
    
    [tvNews setContentSize:CGSizeMake( SCREEN_WIDTH, SCREEN_HEIGHT*1.1f)];
    [tvNews addSubview:viewError];
    [tvNews bringSubviewToFront:viewError];
}


- (void)removeViewError
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    flagLoadSuccess = YES;
    [viewError removeFromSuperview];
}


- (void)showViewNull
{
    if ( !viewNull) {
        viewNull = [[UIView alloc] initWithFrame:CGRectMake( 0, usdViewInfoHeight, SCREEN_WIDTH, SCREEN_HEIGHT-usdViewInfoHeight)];
        [viewNull setBackgroundColor:[UIColor whiteColor]];
        
        [viewNull addSubview:[LyUtil lbNullWithText:@"该好友暂无动态"]];
    }
    [tvNews setContentSize:CGSizeMake( SCREEN_WIDTH, SCREEN_HEIGHT*1.1f)];
    [tvNews addSubview:viewNull];
    [tvNews bringSubviewToFront:viewNull];
}


- (void)removeViewNull
{
    [viewNull removeFromSuperview];
}


- (void)refresh:(UIRefreshControl *)refreshControl
{
    [self loadData];
}


- (void)loadData {
    if ( !indicator_load) {
        indicator_load = [LyIndicator indicatorWithTitle:@""];
    }
    [indicator_load startAnimation];
    
   
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:_userId forKey:objectIdKey];
    [dic setObject:@(currentIndex) forKey:startKey];
    [dic setObject:[LyCurrentUser curUser].userId forKey:userIdKey];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    if (user) {
        [dic setObject:[user userTypeByString] forKey:userTypeKey];
    }
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:userDetailHttpMethod_laod];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:userDetail_url
                                          body:dic
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}







- (void)loadMoreData
{
    [tvFooterView startAnimation];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:_userId forKey:objectIdKey];
    [dic setObject:@(currentIndex) forKey:startKey];
    [dic setObject:[LyCurrentUser curUser].userId forKey:userIdKey];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    if (user) {
        [dic setObject:[user userTypeByString] forKey:userTypeKey];
    }
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:userDetailHttpMethod_loadMore];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:userDetail_url
                                          body:dic
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}




- (void)attente
{
    if ( ![[LyCurrentUser curUser] isLogined])
    {
        LyLoginViewController *login = [[LyLoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    if ( !indicator_oper) {
        indicator_oper = [[LyIndicator alloc] initWithTitle:LyIndicatorTitle_attente];
    }
    [indicator_oper setTitle:LyIndicatorTitle_attente];
    [indicator_oper startAnimation];
    
    NSString *strUserMode;
    switch ( [user userType]) {
        case LyUserType_normal: {
            strUserMode = @"xy";
            break;
        }
        case LyUserType_school: {
            strUserMode = @"jx";
            break;
        }
        case LyUserType_coach: {
            strUserMode = @"jl";
            break;
        }
        case LyUserType_guider: {
            strUserMode = @"zdy";
            break;
        }
    }
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:userDetailHttpMethod_attente];
    [httpRequest setDelegate:self];
    bHttpFlag =[[httpRequest startHttpRequest:attente_url
                                         body:@{
                                                userIdKey:[LyCurrentUser curUser].userId,
                                                objectIdKey:_userId,
                                                sessionIdKey:[LyUtil httpSessionId],
                                                userTypeKey:[user userTypeByString]
                                                }
                                         type:LyHttpType_asynPost
                                      timeOut:0] boolValue];
    
    
}



- (void)deattente
{
    if ( !indicator_oper)
    {
        indicator_oper = [[LyIndicator alloc] initWithTitle:LyIndicatorTitle_deattente];
    }
    [indicator_oper setTitle:LyIndicatorTitle_deattente];
    [indicator_oper startAnimation];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:userDetailHttpMethod_deattente];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:removeAttention_url
                                          body:@{
                                                 userIdKey:[LyCurrentUser curUser].userId,
                                                 objectIdKey:_userId,
                                                 sessionIdKey:[LyUtil httpSessionId]
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}


- (void)praise {
    
    LyNews *news = [arrNews objectAtIndex:curIdx.row];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:userDetailHttpMethod_praise];
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
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:userDetailHttpMethod_depraise];
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
    
    LyNews *news = [arrNews objectAtIndex:curIdx.row];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:userDetailHttpMethod_transmit];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:statusTransmit_url
                                          body:@{
                                                newsIdKey:news.newsId,
                                                objectIdKey:news.newsMasterId,
                                                userIdKey:[LyCurrentUser curUser].userId,
                                                nickNameKey:[[LyCurrentUser curUser] userName],
                                                sessionIdKey:[LyUtil httpSessionId],
                                                objectNameKey:user.userName,
                                                userTypeKey:[[LyCurrentUser curUser] userTypeByString],
                                                }
                                          type:LyHttpType_asynPost
                                      timeOut:0] boolValue];
}



- (void)handleHttpFailed {
    if ( [indicator_load isAnimating]) {
        [indicator_load stopAnimation];
        [refresher endRefreshing];
        [self showViewError];
    }
    
    if ( [tvFooterView isAnimating]) {
        [tvFooterView stopAnimation];
    }
    
    if ( [indicator_oper isAnimating]) {
        [indicator_oper stopAnimation];
        NSString *str;
        if ( [[indicator_oper title] isEqualToString:LyIndicatorTitle_attente]) {
            str = @"关注失败";
        } else if ( [[indicator_oper title] isEqualToString:LyIndicatorTitle_deattente]) {
            str = @"取关失败";
        }
        
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:str] show];
    }
    
    [tvFooterView setStatus:LyTableViewFooterViewStatus_error];
    
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
        [indicator_load stopAnimation];
        [indicator_oper stopAnimation];
        [refresher endRefreshing];
        [tvFooterView stopAnimation];
        
        [LyUtil sessionTimeOut];
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
        case userDetailHttpMethod_laod: {
            curHttpMethod = 0;
            switch ( [strCode integerValue]) {
                case 0: {
                    
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [indicator_load stopAnimation];
                        [refresher endRefreshing];
                        [self showViewError];
                        
                        return;
                    }
                    
                    NSString *strNickName = [dicResult objectForKey:nickNameKey];
                    NSString *strBirthday = [dicResult objectForKey:birthdayKey];
                    NSString *strSignature = [dicResult objectForKey:signatureKey];
                    NSString *strSex = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:sexKey]];
                    
                    NSString *strFlag = [dicResult objectForKey:flagKey];
                    [controlBar setAttentionStatus:[strFlag boolValue]];
                    
                    if (!user) {
                        if (![LyUtil validateString:strNickName]) {
                            strNickName = [LyUtil getUserNameWithUserId:_userId];
                        }
                        
                        user = [LyUser userWithId:_userId
                                         userNmae:strNickName];
                        
                        [[LyUserManager sharedInstance] addUser:user];
                    }
                    [user setUserBirthday:strBirthday];
                    [user setUserSignature:strSignature];
                    [user setUserSex:[strSex integerValue]];
                    
                    
                    NSArray *arrNewsss = [dicResult objectForKey:newsKey];
                    if ([LyUtil validateArray:arrNewsss]) {
                        currentIndex = [arrNewsss count];
                        
                        for ( NSDictionary *dicItem in arrNewsss) {
                            if (![LyUtil validateDictionary:dicItem]) {
                                continue;
                            }
                            
                            NSString *strNewsId = [dicItem objectForKey:newsIdKey];
                            NSString *strNewsTime = [dicItem objectForKey:newsTimeKey];
                            NSString *strNewsContent = [dicItem objectForKey:newsContentKey];
                            NSString *strPraiseCount = [dicItem objectForKey:newsPraiseCountKey];
                            NSString *strEvalutionCount = [dicItem objectForKey:newsEvalutionCountKey];
                            NSString *strTransmitCount = [dicItem objectForKey:newsTransmitCountKey];
                            
                            NSString *strPraiseFlag = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:newsPraiseFlagKey]];
                            
                            
                            strNewsTime = [LyUtil fixDateTimeString:strNewsTime];

                            
                            LyNews *news = [[LyNewsManager sharedInstance] getNewsWithNewsId:strNewsId];
                            if (!news) {
                                news = [LyNews newsWithId:strNewsId
                                                 masterId:_userId
                                                     time:strNewsTime
                                                  content:strNewsContent
                                            transmitCount:strTransmitCount.intValue
                                          evaluationCount:strEvalutionCount.intValue
                                              praiseCount:strPraiseCount.intValue];
                                
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
//                                    for ( int j = 0; j < arrImageUrl.count; ++j)
//                                    {
//                                        NSDictionary *dicImageUrl = [arrImageUrl objectAtIndex:j];
//                                        if ([LyUtil validateDictionary:dicImageUrl]) {
//                                            NSString *strImageUrl = [dicImageUrl objectForKey:imageUrlKey];
//                                            
//                                            [news addPic:nil picUrl:strImageUrl index:j];
//                                        }
//                                    }
                                }
                                
                                [[LyNewsManager sharedInstance] addNews:news];
                                
                            } else {
                                [news setPraise:strPraiseFlag.boolValue];
                                [news setNewsTransmitCount:strTransmitCount.intValue];
                                [news setNewsEvaluationCount:strEvalutionCount.intValue];
                                [news setNewsPraiseCount:strPraiseCount.intValue];
                            }
                        }
                    }
                    
                    
                    arrNews = [[LyNewsManager sharedInstance] getNewsWithUserId:_userId];
                    [self reloadViewInfo];
                    
                    
                    
                    [indicator_load stopAnimation];
                    [refresher endRefreshing];
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
        case userDetailHttpMethod_loadMore: {
            switch ( [strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if ( !dicResult || [dicResult isKindOfClass:[NSNull class]] || ![dicResult count])
                    {
                        [tvFooterView stopAnimation];
                        [tvFooterView setStatus:LyTableViewFooterViewStatus_error];
                        
                        return;
                    }
                    
                    NSArray *arrNewsss = [dicResult objectForKey:newsKey];
                    if (![LyUtil validateArray:arrNewsss]) {
                        [tvFooterView stopAnimation];
                        [tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                        return;
                    }
                    
                    for ( NSDictionary *dicItem in arrNewsss) {
                        if (![LyUtil validateDictionary:dicItem]) {
                            continue;
                        }
                        
                        NSString *strNewsId = [dicItem objectForKey:newsIdKey];
                        NSString *strNewsTime = [dicItem objectForKey:newsTimeKey];
                        NSString *strNewsContent = [dicItem objectForKey:newsContentKey];
                        NSString *strPraiseCount = [dicItem objectForKey:newsPraiseCountKey];
                        NSString *strEvalutionCount = [dicItem objectForKey:newsEvalutionCountKey];
                        NSString *strTransmitCount = [dicItem objectForKey:newsTransmitCountKey];
                        
                        NSString *strPraiseFlag = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:newsPraiseFlagKey]];
                        
                        
                        strNewsTime = [LyUtil fixDateTimeString:strNewsTime];
                        
                        
                        LyNews *news = [[LyNewsManager sharedInstance] getNewsWithNewsId:strNewsId];
                        if (!news) {
                            news = [LyNews newsWithId:strNewsId
                                             masterId:_userId
                                                 time:strNewsTime
                                              content:strNewsContent
                                        transmitCount:strTransmitCount.intValue
                                      evaluationCount:strEvalutionCount.intValue
                                          praiseCount:strPraiseCount.intValue];
                            
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
//                                for ( int j = 0; j < arrImageUrl.count; ++j)
//                                {
//                                    NSDictionary *dicImageUrl = [arrImageUrl objectAtIndex:j];
//                                    if ([LyUtil validateDictionary:dicImageUrl]) {
//                                        NSString *strImageUrl = [dicImageUrl objectForKey:imageUrlKey];
//                                        
//                                        [news addPic:nil picUrl:strImageUrl index:j];
//                                    }
//                                }
                            }
                            
                            [[LyNewsManager sharedInstance] addNews:news];
                            
                        } else {
                            [news setPraise:strPraiseFlag.boolValue];
                            [news setNewsTransmitCount:strTransmitCount.intValue];
                            [news setNewsEvaluationCount:strEvalutionCount.intValue];
                            [news setNewsPraiseCount:strPraiseCount.intValue];
                        }
                    }
                    
                    arrNews = [[LyNewsManager sharedInstance] getNewsWithUserId:_userId];
                    [self reloadViewInfo];
                    
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
        case userDetailHttpMethod_attente: {
            switch ( [strCode integerValue]) {
                case 0: {
                    [controlBar setAttentionStatus:YES];
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"关注成功"] show];
                    break;
                }
                case 1: {
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"关注失败"] show];
                    break;
                }
                case 2: {
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"关注已达上限"] show];
                    break;
                }
                case 3: {
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"你已关注过该用户"] show];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case userDetailHttpMethod_deattente: {
            curHttpMethod = 0;
            switch ( [strCode integerValue]) {
                case 0: {
                    [controlBar setAttentionStatus:NO];
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"取关成功"] show];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case userDetailHttpMethod_praise: {
            curHttpMethod = 0;
            switch ( [strCode integerValue]) {
                case 0: {
                    NSLog(@"点赞成功");
                    break;
                }
                    
                default: {
                    //                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"点赞失败"] showInView:self.view time:0.5f];
                    NSLog(@"点赞失败");
                    break;
                }
            }
            break;
        }
        case  userDetailHttpMethod_depraise: {
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
        case userDetailHttpMethod_transmit: {
            curHttpMethod = 0;
            switch ( [strCode integerValue]) {
                case 0: {
                    
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"转发成功"] show];
                    
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


#pragma mark -LyTableViewFooterViewDelegate
- (void)loadMoreData:(LyTableViewFooterView *)tableViewFooterView
{
    [self loadMoreData];
}



#pragma mark -LyDetailControlBarDelegate
- (void)onClickedButtonAttente
{
    if ([controlBar attentionStatus]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"取消关注"
                                                                       message:[[NSString alloc] initWithFormat:@"你确定要取消「%@」吗？", user.userName]
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"不再关注"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    [self deattente];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];

    } else {
        [self attente];
    }
}


#pragma mark -LyNewsDetailViewControllerDelegate
- (LyNews *)obtainNewsByNewsDetailVC:(LyNewsDetailViewController *)aNewsDetailVC {
    LyNewsTableViewCell *cell = [tvNews cellForRowAtIndexPath:curIdx];
    if ( !cell) {
        return nil;
    }
    
    return cell.news;
}

- (void)onDeleteByNewsDetailVC:(LyNewsDetailViewController *)aNewsDetailVC {
    
    arrNews = [[LyNewsManager sharedInstance] getNewsWithUserId:_userId];
    
    [tvNews reloadData];
}



#pragma mark -LyNewsTableViewCellDelegate
- (void)onClickedForDetailByNewsTVC:(LyNewsTableViewCell *)aCell {
    
    curIdx = [tvNews indexPathForCell:aCell];
    
    if (![LyCurrentUser curUser].isLogined) {
        LyLoginViewController *login = [[LyLoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    } else {
        LyNewsDetailViewController *statusDetail = [[LyNewsDetailViewController alloc] init];
        [statusDetail setDelegate:self];
        [self.navigationController pushViewController:statusDetail animated:YES];
    }
}

- (void)onClickedForPraiseByNewsTVC:(LyNewsTableViewCell *)aCell {
    
    curIdx = [tvNews indexPathForCell:aCell];
    
    if (![LyCurrentUser curUser].isLogined) {
        LyLoginViewController *login = [[LyLoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    } else {
        
        if (aCell.news.isPraised) {
            [self depraise];
        } else {
            [self praise];
        }
        
        
        [aCell.news praise];
        [tvNews reloadRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
}

- (void)onClickedForEvaluateByNewsTVC:(LyNewsTableViewCell *)aCell {
    curIdx = [tvNews indexPathForCell:aCell];
    
    if (![LyCurrentUser curUser].isLogined) {
        LyLoginViewController *login = [[LyLoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    } else {
        LyEvaluateNewsViewController *evaluateNews = [[LyEvaluateNewsViewController alloc] init];
        [evaluateNews setDelegate:self];
        UINavigationController *evaluateNewsNC = [[UINavigationController alloc] initWithRootViewController:evaluateNews];
        [self presentViewController:evaluateNewsNC animated:YES completion:nil];
    }
}

- (void)onCLickedForTransmitByNewsTVC:(LyNewsTableViewCell *)aCell {
    curIdx = [tvNews indexPathForCell:aCell];
    
    if (![LyCurrentUser curUser].isLogined) {
        LyLoginViewController *login = [[LyLoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你要转发这条动态吗？"
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
}


#pragma mark -LyEvaluateNewsViewControllerDelegate
- (LyNews *)obtainNewsByEvaluateNewsVC:(LyEvaluateNewsViewController *)aEvaluateNewsVC {
    return [arrNews objectAtIndex:curIdx.row];
}

- (void)onDoneByEvaluateNewsVC:(LyEvaluateNewsViewController *)aEvaluateNewsVC {
    [aEvaluateNewsVC dismissViewControllerAnimated:YES
                                        completion:^{
                                            [tvNews reloadRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationNone];
                                        }];
}




#pragma mark -BackButtonHandlerProtocol
- (BOOL)navigationShouldPopOnBackButton
{
    if ( [_delegate isKindOfClass:[LySweepViewController class]])
    {
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [[self.navigationController navigationBar] setShadowImage:nil];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
    return YES;
}


#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyUserDetailStatusTableViewCellReuseIdentifier];
    if ( !cell) {
        cell = [[LyNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyUserDetailStatusTableViewCellReuseIdentifier];
    }
    
    [cell setNews:[arrNews objectAtIndex:indexPath.row] mode:LyNewsTableViewCellMode_community];
    
    return cell.cellHeight;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    curIdx = indexPath;
    LyNewsDetailViewController *statusDetail = [[LyNewsDetailViewController alloc] init];
    [statusDetail setDelegate:self];
    [self.navigationController pushViewController:statusDetail animated:YES];
}





#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrNews count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    LyNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyUserDetailStatusTableViewCellReuseIdentifier];
    if ( !cell) {
        cell = [[LyNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyUserDetailStatusTableViewCellReuseIdentifier];
    }
    
    [cell setNews:[arrNews objectAtIndex:indexPath.row] mode:LyNewsTableViewCellMode_community];
    [cell setDelegate:self];
    
    return cell;
}


#pragma mark -UISCrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
   
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( tvNews == scrollView)
    {
        if ( [tvNews contentOffset].y >= CGRectGetHeight([usdViewInfo frame])-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT)
        {
            self.title = user.userName;
            
            [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            [[self.navigationController navigationBar] setShadowImage:nil];
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
        else
        {
            self.title = nil;
            
            [self.navigationController.navigationBar setBackgroundImage:[LyUtil imageForImageName:@"uci_navigatinBar" needCache:NO] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController navigationBar].shadowImage = [LyUtil imageForImageName:@"uci_navigatinBar" needCache:NO];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }
    }
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ( scrollView == tvNews) {
        if ( [scrollView contentOffset].y + [scrollView frame].size.height + tvFooterViewDefaultHeight > [scrollView contentSize].height) {
            [self loadMoreData];
        }
    }
}



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
