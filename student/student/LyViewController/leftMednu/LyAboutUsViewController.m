//
//  LyAboutUsViewController.m
//  teacher
//
//  Created by Junes on 14/10/2016.
//  Copyright © 2016 517xueche. All rights reserved.
//

#import "LyAboutUsViewController.h"
#import "LyLeftMenuSettingTableViewCell.h"

#import "LyRemindView.h"
#import "LyShareView.h"
#import "LyShareManager.h"


#import "LyUtil.h"


#import "student-Swift.h"


//#import "LyTxtViewController.h"
#import "LyFeedbackViewController.h"


//公司信息
#define auViewLogoWidth                           SCREEN_WIDTH
CGFloat const auViewLogoHeight = 200.0f;
//公司信息-图片
CGFloat const auIvLogoSize = 100.0f;
//CGFloat const auIvLogoHeight = 100.0f;
//公司信息-版本
CGFloat const auLbVersionHeight = 40.0f;
#define auLbVersionFont                           LyFont(14)

#define auTvItemsHeightMax                      (SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-auViewLogoHeight-auLbCopyRightHeight-verticalSpace*2)

CGFloat const auLbCopyRightHeight = 50.0f;
#define auLbCopyRightFont                       LyFont(12)




typedef NS_ENUM( NSInteger, LyAboutUsShareAlertViewMode)
{
    aboutusShareAlertViewMode_qqFriend = 1,
    aboutusShareAlertViewMode_qqZone,
    aboutusShareAlertViewMode_weiBo,
    aboutusShareAlertViewMode_weChatFriend,
    aboutusShareAlertViewMode_weChatMoments
};

@interface LyAboutUsViewController ()<UITableViewDelegate, UITableViewDataSource, LyShareViewDelegate>
{
    NSArray             *arrItems;
    NSArray             *arrDetails;
    NSIndexPath         *curIdx;
}

@property (strong, nonatomic)       UITableView         *tableView;

@end

@implementation LyAboutUsViewController

static NSString *lyUserCenterAboutUsTableViewCellReuseIdentifier = @"lyUserCenterAboutUsViewTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLaoutSubviews];
}


- (void)initAndLaoutSubviews {
    self.title = @"关于我们";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    //公司信息
    UIView *viewLogo = [[UIView alloc] initWithFrame: CGRectMake( 0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, auViewLogoHeight)];
    
    //公司信息图片
    UIImageView *ivLogo = [[UIImageView alloc] initWithFrame:CGRectMake( SCREEN_WIDTH/2.0f-auIvLogoSize/2.0f, auIvLogoSize/2.0f-auIvLogoSize/2.0f-auLbVersionHeight/2.0f+STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, auIvLogoSize, auIvLogoSize)];
    [[ivLogo layer] setCornerRadius:20.0f];
    [ivLogo setImage:[LyUtil imageForImageName:@"aboutUs_logo" needCache:NO]];
    [ivLogo setContentMode:UIViewContentModeScaleAspectFill];
    [ivLogo setClipsToBounds:YES];
    
    UILabel *lbVersion = [[UILabel alloc] initWithFrame:CGRectMake(0, ivLogo.frame.origin.y+auIvLogoSize, SCREEN_WIDTH, auLbVersionHeight)];
    [lbVersion setFont:auLbVersionFont];
    [lbVersion setTextColor:[UIColor grayColor]];
    [lbVersion setText:[[NSString alloc] initWithFormat:@"我要去教车 v%@", [LyUtil getApplicationVersion]]];
    [lbVersion setTextAlignment:NSTextAlignmentCenter];
    
    [viewLogo addSubview:ivLogo];
    [viewLogo addSubview:lbVersion];
    

    arrItems = @[
                 @"常见问题",
                 @"联系我们",
                 @"意见反馈",
                 @"用户评分",
                 @"分享应用"
                 ];
    
    arrDetails = @[
                   @"",
                   phoneNum_517,
                   @"",
                   @"用得如何呢？给点意见呗",
                   @"邀请朋友们一起来学车吧",
                   ];

    
    //版权
    UILabel * lbCopyRight = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-auLbCopyRightHeight, SCREEN_WIDTH, auLbCopyRightHeight)];
    [lbCopyRight setFont:auLbCopyRightFont];
    [lbCopyRight setTextColor:[UIColor grayColor]];
    [lbCopyRight setTextAlignment:NSTextAlignmentCenter];
    [lbCopyRight setNumberOfLines:0];
    [lbCopyRight setText:@"我要去学车 版权所有\nCopyright © 2013-2016 517xueche.All Rights Reserved."];
    
    
    [self.view addSubview:viewLogo];
    [self.view addSubview:self.tableView];
    [self.view addSubview:lbCopyRight];
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat height = lmstcellHeight * arrItems.count;
        height = (height > auTvItemsHeightMax) ? auTvItemsHeightMax : height;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT+auViewLogoHeight, SCREEN_WIDTH, height)
                                                  style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setShowsHorizontalScrollIndicator:NO];
        [self.tableView registerClass:[LyLeftMenuSettingTableViewCell class] forCellReuseIdentifier:lyUserCenterAboutUsTableViewCellReuseIdentifier];
    }
    
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -LyShareViewDelegate
- (void)onClickButtonClose:(LyShareView *)aShareView {
    [aShareView hide];
}

- (void)onSharedByQQFriend:(LyShareView *)aShareView {
    [aShareView hide];
    
    [LyShareManager share:SSDKPlatformSubTypeQQFriend
               alertTitle:@"分享给QQ好友"
                  content:shareContent
                   images:@[
                            [LyUtil imageForImageName:@"icon_517" needCache:NO]
                           ]
                    title:shareTitle
                      url:[NSURL URLWithString:share_url]
           viewController:self];
}

- (void)onSharedByQQZone:(LyShareView *)aShareView {
    [aShareView hide];
    
    [LyShareManager share:SSDKPlatformSubTypeQZone
               alertTitle:@"分享到QQ空间"
                  content:shareContent
                   images:@[
                            [LyUtil imageForImageName:@"icon_517" needCache:NO]
                            ]
                    title:shareTitle
                      url:[NSURL URLWithString:share_url]
           viewController:self];
}

- (void)onSharedByWeiBo:(LyShareView *)aShareView {
    [aShareView hide];
    
    [LyShareManager share:SSDKPlatformTypeSinaWeibo
               alertTitle:@"分享到微博"
                  content:shareContent_sinaWeibo
                   images:@[
                            [LyUtil imageForImageName:@"icon_517" needCache:NO]
                            ]
                    title:shareTitle
                      url:[NSURL URLWithString:share_url]
           viewController:self];
    
}

- (void)onSharedByWeChatFriend:(LyShareView *)aShareView {
    [aShareView hide];
    
    [LyShareManager share:SSDKPlatformSubTypeWechatSession
               alertTitle:@"分享给微信好友"
                  content:shareContent
                   images:@[
                            [LyUtil imageForImageName:@"icon_517" needCache:NO]
                            ]
                    title:shareTitle
                      url:[NSURL URLWithString:share_url]
           viewController:self];
}

- (void)onSharedByWeChatMoments:(LyShareView *)aShareView
{
    [aShareView hide];
    
    [LyShareManager share:SSDKPlatformSubTypeWechatTimeline
               alertTitle:@"分享到朋友圈"
                  content:shareContent
                   images:@[
                            [LyUtil imageForImageName:@"icon_517" needCache:NO]
                            ]
                    title:shareTitle
                      url:[NSURL URLWithString:share_url]
           viewController:self];
}



#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return lmstcellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    curIdx = indexPath;
    [tableView deselectRowAtIndexPath:curIdx animated:NO];
    
    switch (curIdx.row) {
        case 0: {
            [LyUtil showWebViewController:LyWebMode_FAQ target:self];
            break;
        }
        case 1: {
            UIWebView *callWebView = [[UIWebView alloc] init];
            NSString *strContact = [[NSString alloc] initWithFormat:@"tel:%@", phoneNum_517];
            [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strContact]]];
            [self.view addSubview:callWebView];
            break;
        }
        case 2: {
            LyFeedbackViewController *feedback = [[LyFeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedback animated:YES];
            break;
        }
        case 3: {
            [LyUtil openUrl:[NSURL URLWithString:appStore_url]];
            break;
        }
        case 4: {
            LyShareView *shareView = [[LyShareView alloc] init];
            [shareView setDelegate:self];
            [shareView show];
            break;
        }
    }
}




#pragma mark UITableViewDataSource相关
////返回分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


////返回每个分组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrItems.count;
}


////生成每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LyLeftMenuSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyUserCenterAboutUsTableViewCellReuseIdentifier];
    if ( !cell) {
        cell = [[LyLeftMenuSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyUserCenterAboutUsTableViewCellReuseIdentifier];
    }
    
    [cell setCellInfo:[LyUtil imageForImageName:[[NSString alloc] initWithFormat:@"aboutUs_item_%ld", indexPath.row] needCache:NO]
                title:[arrItems objectAtIndex:indexPath.row]
               detail:[arrDetails objectAtIndex:indexPath.row]];
    
    
    return cell;
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
