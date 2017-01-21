//
//  LyLeftMenuViewController.m
//  teacher
//
//  Created by Junes on 16/7/30.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyLeftMenuViewController.h"
#import "LyUserCenterTableViewCell.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"

#import "LyUtil.h"



//有效视图
#define lmUsefulWidth                             (SCREEN_WIDTH*15/20.0f)

//头像视图
#define lmViewAvatarWidth                         lmUsefulWidth
CGFloat const lmViewAvatarHeight = 60.0f;
//头像
//#define lmIvAvatarSize                            (lmViewAvatarWidth*5/6.0f)
CGFloat const lmIvAvatarSize = 50.0f;
//姓名//电话
#define lbItemWidth                             (lmViewAvatarWidth-lmIvAvatarSize-horizontalSpace)
CGFloat const lmLbItemHeight = 30.0f;
#define lbItemFont                              LyFont(16)


//功能列表
#define tvListHeight                            (SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-50-horizontalSpace*2)


//退出登录
CGFloat const btnLogoutWidth = 100.0f;
CGFloat const btnLogoutHeight = 40.0f;




typedef NS_ENUM(NSInteger, LyLeftMenuButtonMode)
{
    leftMenuButtonMode_logout = 10,
};


typedef NS_ENUM(NSInteger, LyLeftMenuHttpMethod)
{
    leftMenuHttpMethod_logout = 100,
};


NSString *const leftMenuTvListCellReuseIdentifier = @"leftMenuTvListCellReuseIdentifier";

@interface LyLeftMenuViewController () <UITableViewDelegate, UITableViewDataSource, LyRemindViewDelegate, LyHttpRequestDelegate>
{
    UIView                      *viewAvatar;
    UIImageView                 *ivAvatar;
    UILabel                     *lbName;
    UILabel                     *lbPhone;
    
    UITableView                 *tvList;
    NSArray                     *arrList;
    
    UIButton                    *btnLogout;
    
    
    LyIndicator                 *indicator_logout;
    BOOL                        bHttpFlag;
    LyLeftMenuHttpMethod        curHttpMethod;
}
@end

@implementation LyLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}


- (void)viewWillAppear:(BOOL)animated {
    [self reloadUserInfo];
}

- (void)initAndLayoutSubviews
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
//    if ([[LyCurrentUser curUser] isMaster]) {
    
        arrList = @[
                    @"订单中心",
                    @"教学管理",
                    @"我的动态",
                    @"我的关注",
                    @"关于我们",
                    @"设置"
                    ];
//    } else {
//        arrList = @[
//                    @"订单中心",
//                    @"我的动态",
//                    @"我的关注",
//                    @"关于我们",
//                    @"设置"
//                    ];
//    }
    
    
    
    //头像视图
    viewAvatar = [[UIView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, lmViewAvatarWidth, lmViewAvatarHeight)];
    [viewAvatar setUserInteractionEnabled:YES];
    //头像视图-头像
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(horizontalSpace, lmViewAvatarHeight/2.0f-lmIvAvatarSize/2.0f, lmIvAvatarSize, lmIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [ivAvatar setClipsToBounds:YES];
    [[ivAvatar layer] setCornerRadius:btnCornerRadius];
    [ivAvatar setUserInteractionEnabled:YES];
    [self updateIvAvatar];
    //头像视图-姓名
    lbName = [[UILabel alloc] initWithFrame:CGRectMake(ivAvatar.frame.origin.x+CGRectGetWidth(ivAvatar.frame)+horizontalSpace, 0, lbItemWidth, lmLbItemHeight)];
    [lbName setFont:lbItemFont];
    [lbName setTextColor:[UIColor whiteColor]];
    [lbName setTextAlignment:NSTextAlignmentLeft];
    [lbName setNumberOfLines:0];
    [lbName setUserInteractionEnabled:YES];
    [self updateLbName];
    //头像视图-电话
    lbPhone = [[UILabel alloc] initWithFrame:CGRectMake(lbName.frame.origin.x, lbName.ly_y+CGRectGetHeight(lbName.frame), lbItemWidth, lmLbItemHeight)];
    [lbPhone setFont:lbItemFont];
    [lbPhone setTextColor:[UIColor whiteColor]];
    [lbPhone setTextAlignment:NSTextAlignmentLeft];
    [lbPhone setUserInteractionEnabled:YES];
    [self updateLbPhone];
    //头像视图-右箭头
    UIImageView *ivMore = [[UIImageView alloc] initWithFrame:CGRectMake( lmViewAvatarWidth-ivMoreSize*2, lmViewAvatarHeight/2.0f-ivMoreSize/2.0f, ivMoreSize, ivMoreSize)];
    [ivMore setContentMode:UIViewContentModeScaleAspectFit];
    [ivMore setImage:[LyUtil imageForImageName:@"ivMore" needCache:NO]];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForTapGestureFromViewAvatar)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    
    [viewAvatar addGestureRecognizer:tap];
    [viewAvatar addSubview:ivAvatar];
    [viewAvatar addSubview:lbName];
    [viewAvatar addSubview:lbPhone];
    [viewAvatar addSubview:ivMore];
    
    [self.view addSubview:viewAvatar];
    
    
    
    UIView *viewHorinzontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, viewAvatar.ly_y+CGRectGetHeight(viewAvatar.frame)+verticalSpace, SCREEN_WIDTH, LyHorizontalLineHeight)];
    [viewHorinzontalLine setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:viewHorinzontalLine];
    
    
    
    
    //功能列表
    tvList = [[UITableView alloc] initWithFrame:CGRectMake(0, viewAvatar.ly_y+CGRectGetHeight(viewAvatar.frame)+horizontalSpace, lmUsefulWidth, tvListHeight)
                                          style:UITableViewStylePlain];
    [tvList setDelegate:self];
    [tvList setDataSource:self];
    [tvList setBackgroundColor:[UIColor clearColor]];
    [tvList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tvList registerClass:[LyUserCenterTableViewCell class] forCellReuseIdentifier:leftMenuTvListCellReuseIdentifier];
    
    [self.view addSubview:tvList];
    
    
    
    btnLogout = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-btnLogoutHeight, btnLogoutWidth, btnLogoutHeight)];
    [btnLogout setBackgroundImage:[LyUtil imageForImageName:@"btn_logout" needCache:NO] forState:UIControlStateNormal];
    [btnLogout setTag:leftMenuButtonMode_logout];
    [btnLogout addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnLogout];

}




- (void)reloadUserInfo
{
    [self updateIvAvatar];
    [self updateLbName];
    [self updateLbPhone];
}


//更新头像
- (void)updateIvAvatar {
    if ( ![[LyCurrentUser curUser] userAvatar]) {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:[LyCurrentUser curUser].userId]
                    placeholderImage:[LyUtil defaultAvatarForTeacher]
                           completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                               if (image) {
                                   [[LyCurrentUser curUser] setUserAvatar:image];
                               } else {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:[LyCurrentUser curUser].userId]
                                               placeholderImage:[LyUtil defaultAvatarForTeacher]
                                                      completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                                          if (!image) {
                                                              image = [LyUtil defaultAvatarForTeacher];
                                                          }
                                                          
                                                          [[LyCurrentUser curUser] setUserAvatar:image];
                                                      }];
                               }
                           }];
    } else {
        [ivAvatar setImage:[[LyCurrentUser curUser] userAvatar]];
    }
    
}

//更新姓名
- (void)updateLbName {

    [lbName setText:[LyCurrentUser curUser].userName];
}

//更新电话
- (void)updateLbPhone {
    
    [lbPhone setText:[LyUtil hidePhoneNumber:[[LyCurrentUser curUser] userPhoneNum]]];
}



- (void)targetForTapGestureFromViewAvatar {
    [_delegate pushViewControllerWithIndex:0];
}



- (void)targetForButton:(UIButton *)button
{
    if (leftMenuButtonMode_logout == button.tag)
    {
        if ( !indicator_logout)
        {
            indicator_logout = [[LyIndicator alloc] initWithTitle:@"正在退出..."];
        }
        [indicator_logout startAnimation];
        
        LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:leftMenuHttpMethod_logout];
        [httpRequest setDelegate:self];
        bHttpFlag = [[httpRequest startHttpRequest:logout_url
                                              body:@{
                                                     userIdKey:[LyCurrentUser curUser].userId,
                                                     sessionIdKey:[LyUtil httpSessionId]
                                                     }
                                              type:LyHttpType_asynPost
                                           timeOut:0] boolValue];
    }
}


- (void)handleHttpFailed {
    [self logout];
}


- (void)logout {
    [indicator_logout stopAnimation];
    [LyUtil logout:nil];
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
        
        switch ( curHttpMethod) {
            case leftMenuHttpMethod_logout: {
                [self logout];
                break;
            }
            default: {
                [self handleHttpFailed];
            }
        }
    }
    
    curHttpMethod = 0;
}


#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(LyRemindView *)aRemind {
    [LyUtil logout:nil];
}



#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    //从10开始
    if (0 == indexPath.row) {
        [_delegate pushViewControllerWithIndex:indexPath.row+10];
    } else {
//        if ([[LyCurrentUser curUser] isMaster]) {
            [_delegate pushViewControllerWithIndex:indexPath.row+10];
//        } else {
//            [_delegate pushViewControllerWithIndex:indexPath.row+11];
//        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UCENTERCELLHEIGHT;
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyUserCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftMenuTvListCellReuseIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[LyUserCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftMenuTvListCellReuseIdentifier];
    }
    
    if (0 == indexPath.row)
    {
        [cell setCellInfo:[arrList objectAtIndex:indexPath.row]
                withImage:[LyUtil imageForImageName:[[NSString alloc] initWithFormat:@"lm_item_%d", (int)indexPath.row] needCache:NO]];
    }
    else
    {
//        if ([[LyCurrentUser curUser] isMaster])
//        {
            [cell setCellInfo:[arrList objectAtIndex:indexPath.row]
                    withImage:[LyUtil imageForImageName:[[NSString alloc] initWithFormat:@"lm_item_%d", (int)indexPath.row] needCache:NO]];
//        }
//        else
//        {
//            [cell setCellInfo:[arrList objectAtIndex:indexPath.row]
//                    withImage:[LyUtil imageForImageName:[[NSString alloc] initWithFormat:@"lm_item_%d", (int)indexPath.row+1] needCache:NO]];
//        }
    }
    
    
    return cell;
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
