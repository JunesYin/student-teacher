//
//  LySlefStudyToExamViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/19.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LySelfStudyToExamViewController.h"
#import "LySelfStudyToExamCollectionViewCell.h"

#import "LyDetailControlBar.h"
#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyUserManager.h"
#import "LyCurrentUser.h"


#import "UIImageView+WebCache.h"
#import "NSString+Validate.h"
#import "LyUtil.h"


#import "LyAddGuiderTableViewController.h"
#import "LyReservateGuiderViewController.h"

#import <MessageUI/MessageUI.h>



#define svMainWidth                     SCREEN_WIDTH
#define svMainHeight                    (SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT)


#define tvRemindWidth                   (svMainWidth-horizontalSpace*2.0f)
CGFloat const tvRemindHeight = 40.0f;
#define tvRemindFont                    LyFont(13)


#define viewInfoWidth                   svMainWidth
CGFloat const ssteViewInfoHeight = 200.0f;

CGFloat const ssteIvAvatarSize = 50.0f;

#define lbNameDetailWidth               (viewInfoWidth-horizontalSpace*2.0f)
CGFloat const lbNameDetailHeight = 20.0f;
#define lbNameDetailFont                LyFont(13)


int const cvFuncsItemsCountSingleRow = 2;
#define cvFuncsItemWidth                (cvFuncsWidth/3.0f)
#define cvFuncsItemHeight               cvFuncsItemWidth
#define cvFuncsWidth                    svMainWidth
#define cvFuncsHeight                   (cvFuncsItemHeight*cvFuncsItemsCountSingleRow)




typedef NS_ENUM( NSInteger, LySelfStudyToExamHttpMethod)
{
    selfStudyToExamHttpMethod_load = 100,
    selfStudyToExamHttpMethod_attente,
    selfStudyToExamHttpMethod_deattente
};


@interface LySelfStudyToExamViewController () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, LyHttpRequestDelegate, LyDetailControlBarDelegate, LyAddGuiderTableViewControllerDelegate, MFMessageComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, LyReservateGuiderViewControllerDelegate>
{
    UIBarButtonItem             *barbtnItemRight;
    
    UIScrollView                *svMain;
    
    UIView                      *viewError;
    
    UIView                      *viewInfo;
    UIImageView                 *ivAvatar;
    UILabel                     *lbNameDetail;
    
    
    
//    UIView                      *viewFunc;
    UICollectionView            *cvFuncs;
    NSArray                     *arrFuncsItems;
    
    
    LyDetailControlBar          *controlBar;
    
    
    UIRefreshControl            *refresher;
    LyIndicator                 *indicator_load;
    LyIndicator                 *indicator_oper;
    
    LyGuider                    *guider;
    
    
    BOOL                        flagLoadSuccess;
    LySelfStudyToExamHttpMethod curHttpMethod;
    BOOL                        bHttpFlag;
}
@end

@implementation LySelfStudyToExamViewController




static NSString *lySelfStudyToExamFuncsCollectionViewCellReuseIdentifier = @"lySelfStudyToExamFuncsCollectionViewCellReuseIdentifier";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
    
    arrFuncsItems = @[
                      @"计时预约",
                      @"考试预约",
                      @"考试预约查询",
                      @"考场考量查询",
                      @"自学直考资讯"
                      ];
}




- (void)viewWillAppear:(BOOL)animated
{
    if ( !flagLoadSuccess)
    {
        [self refreshData:refresher];
    }
}




- (void)initSubviews
{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.title = @"自学直考";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    barbtnItemRight = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(targetForBarButtonItem:)];
    [self.navigationItem setRightBarButtonItem:barbtnItemRight];
    
    
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, svMainWidth, svMainHeight)];
    [svMain setBackgroundColor:[UIColor whiteColor]];
    [svMain setDelegate:self];
    [svMain setShowsVerticalScrollIndicator:NO];
    [svMain setBounces:YES];
    
    refresher = [[UIRefreshControl alloc] init];
    [refresher setTintColor:LyRefresherColor];
    NSMutableAttributedString *strRefresherTitle = [[NSMutableAttributedString alloc] initWithString:@"正在加载"];
    [strRefresherTitle addAttribute:NSForegroundColorAttributeName value:LyRefresherColor range:NSMakeRange( 0, [@"正在加载" length])];
    [refresher setAttributedTitle:strRefresherTitle];
    [refresher addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [svMain addSubview:refresher];
    
//    
//    viewContent = [UIView new];
//    [viewContent setBackgroundColor:LyWhiteLightgrayColor];
    
    
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, viewInfoWidth, ssteViewInfoHeight)];
    [viewInfo setBackgroundColor:[UIColor whiteColor]];
    
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake( viewInfoWidth/2.0f-ssteIvAvatarSize/2.0f, ssteViewInfoHeight/2.0f-ssteIvAvatarSize, ssteIvAvatarSize, ssteIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [ivAvatar setClipsToBounds:YES];
    [[ivAvatar layer] setCornerRadius:btnCornerRadius];
    
    lbNameDetail = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, ivAvatar.frame.origin.y+CGRectGetHeight(ivAvatar.frame)+verticalSpace*3.0f, lbNameDetailWidth, lbNameDetailHeight)];
    [lbNameDetail setFont:lbNameDetailFont];
    [lbNameDetail setTextColor:LyBlackColor];
    [lbNameDetail setTextAlignment:NSTextAlignmentCenter];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, ssteViewInfoHeight-verticalSpace, SCREEN_WIDTH, verticalSpace)];
    [horizontalLine setBackgroundColor:LyWhiteLightgrayColor];
    
    [viewInfo addSubview:ivAvatar];
    [viewInfo addSubview:lbNameDetail];
    [viewInfo addSubview:horizontalLine];
    
    
    UICollectionViewFlowLayout *ssteCollectionVIewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [ssteCollectionVIewFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [ssteCollectionVIewFlowLayout setMinimumInteritemSpacing:0];
    [ssteCollectionVIewFlowLayout setMinimumLineSpacing:0];
    cvFuncs = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, viewInfo.frame.origin.y+CGRectGetHeight(viewInfo.frame)+verticalSpace, cvFuncsWidth, cvFuncsHeight)
                                 collectionViewLayout:ssteCollectionVIewFlowLayout];
    [cvFuncs setDelegate:self];
    [cvFuncs setDataSource:self];
    [cvFuncs setBackgroundColor:[UIColor whiteColor]];
    [cvFuncs registerClass:[LySelfStudyToExamCollectionViewCell class] forCellWithReuseIdentifier:lySelfStudyToExamFuncsCollectionViewCellReuseIdentifier];
    

    
    
    [svMain addSubview:viewInfo];
    [svMain addSubview:cvFuncs];
    
    [svMain setContentSize:CGSizeMake( svMainWidth, cvFuncs.frame.origin.y+CGRectGetHeight(cvFuncs.frame)+dcbHeight+verticalSpace)];
    
    
    
    controlBar = [LyDetailControlBar controlBarWidthMode:LyDetailControlBarMode_myCDG];
    [controlBar setDelegate:self];
    
    
    [self.view addSubview:svMain];
    [self.view addSubview:controlBar];
    
    
}



- (void)showViewError
{
    flagLoadSuccess = NO;
    [controlBar setHidden:YES];
    if ( !viewError)
    {
        viewError = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, svMainWidth, svMainHeight*1.1f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        UILabel *lbError = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, LyLbErrorHeight)];
        [lbError setBackgroundColor:LyWhiteLightgrayColor];
        [lbError setTextAlignment:NSTextAlignmentCenter];
        [lbError setFont:LyNullItemTitleFont];
        [lbError setTextColor:LyNullItemTextColor];
        [lbError setText:@"加载失败，下拉再次加载"];
        
        [viewError addSubview:lbError];
    }
    [svMain setContentSize:CGSizeMake( svMainWidth, SCREEN_HEIGHT*1.1f)];
    [svMain addSubview:viewError];
    [svMain bringSubviewToFront:viewError];
}


- (void)removeViewError
{
    flagLoadSuccess = YES;
    [controlBar setHidden:NO];
    [viewError removeFromSuperview];
}




- (void)reloadViweData
{
    [self removeViewError];
    
    if ( !guider)
    {
        [controlBar setHidden:YES];
        [lbNameDetail setText:@"你当前的指导员为：无"];
        
        [barbtnItemRight setTitle:@"添加"];
    }
    else
    {
        [controlBar setHidden:NO];
        if ( ![guider userAvatar])
        {
            [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:[guider userId]]
                        placeholderImage:[LyUtil defaultAvatarForTeacher]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   if (image)
                                   {
                                       [guider setUserAvatar:image];
                                   }
                                   else
                                   {
                                       [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:[guider userId]]
                                                           placeholderImage:[LyUtil defaultAvatarForTeacher]
                                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                      if (image) {
                                                                          [guider setUserAvatar:image];
                                                                      }
                                                                  }];
                                   }
                               }];
        }
        else
        {
            [ivAvatar setImage:[guider userAvatar]];
        }
        
        
        [lbNameDetail setText:[[NSString alloc] initWithFormat:@"你当前的指导员为：%@", [guider userName]]];
        [barbtnItemRight setTitle:@"更换"];
    }
}



- (void)targetForBarButtonItem:(UIBarButtonItem *)barBtnItem
{
    LyAddGuiderTableViewController *addGuider = [[LyAddGuiderTableViewController alloc] init];
    [addGuider setDelegate:self];
    [self.navigationController pushViewController:addGuider animated:YES];
}




- (void)refreshData:(UIRefreshControl *)refreshControl
{
    [self loadData];
}


- (void)loadData
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(loadData) object:nil];
        return;
    }
    
    if ( !indicator_load)
    {
        indicator_load = [LyIndicator indicatorWithTitle:@""];
    }
    [indicator_load startAnimation];
    
    
    LyHttpRequest *httpReqeust = [LyHttpRequest httpRequestWithMode:selfStudyToExamHttpMethod_load];
    [httpReqeust setDelegate:self];
    bHttpFlag = [[httpReqeust startHttpRequest:myGuider_url
                                          body:@{
                                                myGuiderIdKey:([LyCurrentUser curUser].userGuiderId) ? [LyCurrentUser curUser].userGuiderId : @"0",
                                                userIdKey:[[LyCurrentUser curUser] userId],
                                                sessionIdKey:[LyUtil httpSessionId]
                                                }
                                          type:LyHttpType_asynPost
                                      timeOut:0] boolValue];
}


- (void)attente
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(attente) object:nil];
        return;
    }
    
    if ( !indicator_oper)
    {
        indicator_oper = [[LyIndicator alloc] initWithTitle:LyIndicatorTitle_attente];
    }
    [indicator_oper setTitle:LyIndicatorTitle_attente];
    [indicator_oper startAnimation];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:selfStudyToExamHttpMethod_attente];
    [httpRequest setDelegate:self];
    bHttpFlag =[[httpRequest startHttpRequest:addAttention_url
                                         body:@{
                                                userIdKey:[[LyCurrentUser curUser] userId],
                                                objectIdKey:[guider userId],
                                                sessionIdKey:[LyUtil httpSessionId],
                                                userTypeKey:userTypeGuiderKey
                                                }
                                         type:LyHttpType_asynPost
                                      timeOut:0] boolValue];
    
}



- (void)deattente
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(deattente) object:nil];
        return;
    }
    
    if ( !indicator_oper)
    {
        indicator_oper = [[LyIndicator alloc] initWithTitle:LyIndicatorTitle_deattente];
    }
    [indicator_oper startAnimation];
    
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:selfStudyToExamHttpMethod_deattente];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:removeAttention_url
                                          body:@{
                                                 userIdKey:[[LyCurrentUser curUser] userId],
                                                 objectIdKey:[guider userId],
                                                 sessionIdKey:[LyUtil httpSessionId]
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}



- (void)handleHttpFailed {
    if ([indicator_load isAnimating]) {
        [indicator_load stopAnimation];
        [refresher endRefreshing];
        [self.navigationController.navigationBar setHidden:NO];
        [self showViewError];
    }
    
    if ( [indicator_oper isAnimating]) {
        [indicator_oper stopAnimation];
        NSString *str;
        if ( [[indicator_oper title] isEqualToString:LyIndicatorTitle_attente]) {
            str = @"关注失败";
        } else if ( [[indicator_oper title] isEqualToString:LyIndicatorTitle_deattente]) {
            str = @"取消失败";
        }
        
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:str] show];
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
        [indicator_load stopAnimation];
        [indicator_oper stopAnimation];
        [refresher endRefreshing];
        
        [LyUtil sessionTimeOut:self];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_load stopAnimation];
        [refresher endRefreshing];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    
    switch ( curHttpMethod) {
        case selfStudyToExamHttpMethod_load: {
            switch ( [strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [indicator_load stopAnimation];
                        [self showViewError];
                        if ( [refresher isRefreshing]) {
                            [refresher endRefreshing];
                        }
                        if ( [indicator_oper isAnimating]) {
                            [indicator_oper stopAnimation];
                        }
                        return;
                    }
                    
                    NSString *strId = [dicResult objectForKey:userIdKey];
                    NSString *strName = [dicResult objectForKey:nickNameKey];
                    NSString *strFlag = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:flagKey]];
                    NSString *strDriveLicense = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:driveLicenseKey]];
                    
                    if ([LyUtil validateString:strId]) {
                        guider = [[LyUserManager sharedInstance] getGuiderWithGuiderId:strId];
                        if ( !guider || LyUserType_guider != guider.userType) {
                            guider = [LyGuider userWithId:strId
                                                          userName:strName];
                            
                            [[LyUserManager sharedInstance] addUser: guider];
                        }
                        [guider setUserLicenseType:[LyUtil driveLicenseFromString:strDriveLicense]];
                        
                        [controlBar setAttentionStatus:[strFlag boolValue]];
                    }
                    
                    
                    [self reloadViweData];
                    [indicator_load stopAnimation];
                    if ( [refresher isRefreshing])
                    {
                        [refresher endRefreshing];
                    }
                    if ( [indicator_oper isAnimating])
                    {
                        [indicator_oper stopAnimation];
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
        case selfStudyToExamHttpMethod_attente: {
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
        case selfStudyToExamHttpMethod_deattente: {
            switch ( [strCode integerValue]) {
                case 0: {
                    [controlBar setAttentionStatus:NO];
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"取消成功"] show];
                    break;
                }
                case 1: {
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"取消失败"] show];
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




- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result
{
    if ( bHttpFlag)
    {
        bHttpFlag = NO;
        curHttpMethod = ahttpRequest.mode;
        [self analysisHttpResult:result];
    }
    
    curHttpMethod = 0;
}



#pragma mark -LyReservateGuiderViewControllerDelegate
- (NSString *)obtainGuiderIdByReservateGuiderVC:(LyReservateGuiderViewController *)aReservateGuiderVC {
    return guider.userId;
}



#pragma mark -LyAddGuiderTableViewControllerDelegate
- (LyAddTeacherMode)obtainModeByAddGuiderTableViewController:(LyAddGuiderTableViewController *)aAddGuider
{
    if ( !guider)
    {
        return LyAddTeacherMode_add;
    }
    else
    {
        return LyAddTeacherMode_replace;
    }
}


- (void)addGuiderFinishedByAddGuiderTableViewController:(LyAddGuiderTableViewController *)aAddGuider andGuider:(LyGuider *)aGuider
{
    [aAddGuider.navigationController popViewControllerAnimated:YES];
    guider = aGuider;
    [[LyUserManager sharedInstance] addUser:guider];
    [[LyCurrentUser curUser] setUserGuiderId:[guider userId]];
    [[LyCurrentUser curUser] setUserGuiderName:[guider userName]];
    
    [self loadData];
}




#pragma mark -LyDetailControlBarDelegate
- (void)onClickedButtonAttente
{
    if ( [controlBar attentionStatus]) {
        UIAlertController *action = [UIAlertController alertControllerWithTitle:[[NSString alloc] initWithFormat:@"你确定不再关注「%@」吗？", guider.userName]
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
        [action addAction:[UIAlertAction actionWithTitle:@"取消"
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
        [action addAction:[UIAlertAction actionWithTitle:@"不再关注"
                                                   style:UIAlertActionStyleDestructive
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     [self deattente];
                                                 }]];
        [self presentViewController:action animated:YES completion:nil];
    } else {
        [self attente];
    }
}

- (void)onClickedButtonPhone {
    NSString *strContact;
    if ( [guider userPhoneNum] && [[guider userPhoneNum] isKindOfClass:[NSString class]] && [[guider userPhoneNum] validatePhoneNumber]) {
        strContact = [guider userPhoneNum];
    } else {
        strContact = phoneNum_517;
    }
    
    [LyUtil call:strContact];
}


- (void)onClickedButtonMessage {
    
    NSString *strPhone;
    if ( [guider userPhoneNum] && [[guider userPhoneNum] isKindOfClass:[NSString class]] && [[guider userPhoneNum] validatePhoneNumber]) {
        strPhone = guider.userPhoneNum;
    } else {
        strPhone = messageNum_517;
    }
    
    [LyUtil sendSMS:nil
         recipients:@[strPhone]
             target:self];
}


#pragma mark -MFMessageComposeViewControllerDelegate
// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    [NSThread sleepForTimeInterval:sleepTime];
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled) {
        [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"短信发送取消"] show];
    } else if (result == MessageComposeResultSent) {
        [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"短信发送成功"] show];
    } else {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"短信发送失败"] show];
    }
}





#pragma UICollectionViewDelegate
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![LyCurrentUser curUser].isLogined) {
        [LyUtil showLoginVc:self];
        return;
    }
    
    if (0 == indexPath.row) {
        
        if (!guider) {
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没指导员"] show];
        } else {
            LyReservateGuiderViewController *reservateGuider = [[LyReservateGuiderViewController alloc] init];
            [reservateGuider setDelegate:self];
            [self.navigationController pushViewController:reservateGuider animated:YES];
        }
    } else if ( 4 == [indexPath row]) {
        NSURL *url = [NSURL URLWithString:@"http://m.517xueche.com"];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [LyUtil openUrl:url];
        }
    } else {
        NSURL *url = [NSURL URLWithString:@"http://www.122.gov.cn/m/map/select"];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [LyUtil openUrl:url];
        }
    }
}


#pragma UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (LySelfStudyToExamCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LySelfStudyToExamCollectionViewCell *tmpCell = (LySelfStudyToExamCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:lySelfStudyToExamFuncsCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    if ( tmpCell)
    {
        [tmpCell setCellInfo:[LyUtil imageForImageName:[[NSString alloc] initWithFormat:@"sste_func_item_%d", (int)[indexPath row]] needCache:NO] title:[arrFuncsItems objectAtIndex:indexPath.row] on:YES];
    }
    
    return tmpCell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake( cvFuncsItemWidth, cvFuncsItemHeight);
}



//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
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
