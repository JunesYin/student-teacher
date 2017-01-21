//
//  LyUserCenterViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyUserCenterViewController.h"
#import "LyUserCenterTableViewCell.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"


#import "RESideMenu.h"




//主视图
#define UCVIEWWIDTH                                 SCREEN_WIDTH
#define UCVIEWHEIGHT                                SCREEN_HEIGHT
#define UCVIEWFRAME                                 CGRectMake( 0, 0, UCVIEWWIDTH, UCVIEWHEIGHT)

//有效视图
#define UCVIEWUSEWIDTH                              (UCVIEWWIDTH*15/20)
#define UCVIEWUSEHEIGHT                             UCVIEWHEIGHT


//头像视图
#define UCAVATARVIEWWIDTH                           UCVIEWUSEWIDTH
CGFloat const UCAVATARVIEWHEIGHT = 60.0f;
#define UCAVATARVIEWFRAME                           CGRectMake( 0, STATUSBAR_HEIGHT+44, UCVIEWUSEWIDTH, UCAVATARVIEWHEIGHT)
//头像-头像框
#define UCAVATARVIEWAVATARWIDHT                     (UCAVATARVIEWHEIGHT*5/6)
#define UCAVATARVIEWAVATARHEIGHT                    UCAVATARVIEWAVATARWIDHT
//头像-姓名
#define UCAVATARVIEWNAMEWIDHT                       (UCAVATARVIEWWIDTH-UCAVATARVIEWAVATARWIDHT-horizontalSpace*2)
#define UCAVATARVIEWNAMEHEIGHT                      (UCAVATARVIEWHEIGHT/2)
//头像-电话
#define UCAVATARVIEWPHONENUMBERWIDHT                UCAVATARVIEWNAMEWIDHT
#define UCAVATARVIEWPHONENUMBERHEIGHT               UCAVATARVIEWNAMEHEIGHT
//头像-更多


#define UCFUNCLISTWIDHT                             UCVIEWUSEWIDTH
#define UCFUNCLISTHEIGHT                            UCVIEWUSEHEIGHT-UCAVATARVIEWFRAME.origin.y-UCAVATARVIEWFRAME.size.height+horizontalSpace



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


@interface LyUserCenterViewController () < UITableViewDelegate, UITableViewDataSource, LyHttpRequestDelegate, LyRemindViewDelegate>
{
    UIView                      *ucViewUse;
    
    UIView                      *ucViewForAvatar;
    
    UIView                      *ucViewHorizontalLine;
    
    NSArray                     *ucArrFuncList;
    
    
    UIButton                    *btnLogout;
    
    
    LyIndicator                 *indicator_logout;
    BOOL                        bHttpFlag;
    LyLeftMenuHttpMethod        curHttpMethod;
}

@end

@implementation LyUserCenterViewController


lySingle_implementation(LyUserCenterViewController)


static NSString *const lyCoachTableViewCellReuseIdentifier = @"lyCoachTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self ucLayoutUI];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [self reloadUserInfo];
    
    [btnLogout setHidden:![[LyCurrentUser curUser] isLogined]];
}


- (void)ucLayoutUI
{
    
    ucArrFuncList = @[
                      @"订单中心",
                      @"驾考学堂",
                      @"我的动态",
                      @"我的关注",
                      @"学车指南",
                      @"关于我们",
                      @"设置"
                      ];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    //有效视图
    CGRect rectUcViewUse = CGRectMake( 0, 0, UCVIEWUSEWIDTH, UCVIEWUSEHEIGHT);
    ucViewUse = [[UIView alloc] initWithFrame:rectUcViewUse];
    [self.view addSubview:ucViewUse];
    
    //头像视图
    CGRect rectUcAvatarView = UCAVATARVIEWFRAME;
    ucViewForAvatar = [[UIView alloc] initWithFrame:rectUcAvatarView];
    [ucViewForAvatar setUserInteractionEnabled:YES];
    UITapGestureRecognizer *ucGestureForAvatarView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ucTargetForAvatarView:)];
    [ucGestureForAvatarView setNumberOfTapsRequired:1];
    [ucGestureForAvatarView setNumberOfTouchesRequired:1];
    [ucViewForAvatar addGestureRecognizer:ucGestureForAvatarView];
    //头像-头像框
    CGRect rectUcAvatarViewAvatar = CGRectMake( horizontalSpace, UCAVATARVIEWHEIGHT/2-UCAVATARVIEWAVATARHEIGHT/2, UCAVATARVIEWAVATARWIDHT, UCAVATARVIEWAVATARHEIGHT);
    _ucIvAvatar = [[UIImageView alloc] initWithFrame:rectUcAvatarViewAvatar];
    [_ucIvAvatar setContentMode:UIViewContentModeScaleAspectFit];
    [[_ucIvAvatar layer] setCornerRadius:CGRectGetWidth(_ucIvAvatar.frame)/2];
    [_ucIvAvatar setClipsToBounds:YES];
    [self ucSetAvatarViewAvatarImage];
    //头像-姓名
    CGRect rectUcAvatarViewName = CGRectMake( rectUcAvatarViewAvatar.origin.x+rectUcAvatarViewAvatar.size.width+horizontalSpace, 0, UCAVATARVIEWNAMEWIDHT, UCAVATARVIEWNAMEHEIGHT);
    _ucLbName = [[UILabel alloc] initWithFrame:rectUcAvatarViewName];
    [_ucLbName setTextAlignment:NSTextAlignmentLeft];
    [_ucLbName setTextColor:[UIColor whiteColor]];
    [self ucSetAvatarViewNameText];
    //头像-电话
    CGRect rectUcAvatarViewPhoneNumber = CGRectMake( rectUcAvatarViewName.origin.x, rectUcAvatarViewName.origin.y+rectUcAvatarViewName.size.height, UCAVATARVIEWPHONENUMBERWIDHT, UCAVATARVIEWPHONENUMBERHEIGHT);
    _ucLbPhoneNumber = [[UILabel alloc] initWithFrame:rectUcAvatarViewPhoneNumber];
    [_ucLbPhoneNumber setTextAlignment:NSTextAlignmentLeft];
    [_ucLbPhoneNumber setTextColor:[UIColor whiteColor]];
    [self ucSetAvatarViewPhoneNumberText];
    
    
    UIImageView *ivMore = [[UIImageView alloc] initWithFrame:CGRectMake( CGRectGetWidth(ucViewForAvatar.frame)-ivMoreSize*2, _ucIvAvatar.frame.origin.y+CGRectGetHeight(_ucIvAvatar.frame)/2.0f-ivMoreSize/2.0f, ivMoreSize, ivMoreSize)];
    [ivMore setContentMode:UIViewContentModeScaleAspectFit];
    [ivMore setImage:[LyUtil imageForImageName:@"ivMore" needCache:NO]];
    
    
    [ucViewForAvatar addSubview:_ucIvAvatar];
    [ucViewForAvatar addSubview:_ucLbName];
    [ucViewForAvatar addSubview:_ucLbPhoneNumber];
    [ucViewForAvatar addSubview:ivMore];
    
    
    CGRect rectUcHorizontal = CGRectMake( 0, rectUcAvatarView.origin.y+rectUcAvatarView.size.height+horizontalSpace, rectUcViewUse.size.width, 1);
    ucViewHorizontalLine = [[UIView alloc] initWithFrame:rectUcHorizontal];
    [ucViewHorizontalLine setBackgroundColor:[UIColor grayColor]];
    [ucViewUse addSubview:ucViewHorizontalLine];
    
    
    CGRect rectUcFuncList = CGRectMake( 0, rectUcHorizontal.origin.y+rectUcHorizontal.size.height+horizontalSpace, UCVIEWUSEWIDTH, UCFUNCLISTHEIGHT);
    _ucTvFuncList = [[UITableView alloc] initWithFrame:rectUcFuncList style:UITableViewStylePlain];//UITableViewStyleGrouped  UITableViewStylePlain;
    [_ucTvFuncList setDelegate:self];
    [_ucTvFuncList setDataSource:self];
    [_ucTvFuncList setBackgroundColor:[UIColor clearColor]];
    [_ucTvFuncList setBackgroundView:nil];
    [_ucTvFuncList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_ucTvFuncList setBounces:YES];
    //_ucTvFuncList.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [ucViewUse addSubview:ucViewForAvatar];
    [ucViewUse addSubview:_ucTvFuncList];
    
    
    
    btnLogout = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-btnLogoutHeight, btnLogoutWidth, btnLogoutHeight)];
    [btnLogout setBackgroundImage:[LyUtil imageForImageName:@"btn_logout" needCache:NO] forState:UIControlStateNormal];
    [btnLogout setTag:leftMenuButtonMode_logout];
    [btnLogout addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnLogout];
}



- (void)reloadUserInfo
{
    [self ucSetAvatarViewNameText];
    [self ucSetAvatarViewAvatarImage];
    [self ucSetAvatarViewPhoneNumberText];
}



- (void)ucSetAvatarViewAvatarImage
{
    if ( ![[LyCurrentUser curUser] isLogined]) {
        [_ucIvAvatar setImage:[LyUtil defaultAvatarForStudent]];
    } else {
        if ( ![[LyCurrentUser curUser] userAvatar]) {
            [_ucIvAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:[LyCurrentUser curUser].userId]
                           placeholderImage:[LyUtil defaultAvatarForStudent]
                                  completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                      if (image) {
                                          [[LyCurrentUser curUser] setUserAvatar:image];
                                      } else {
                                          [_ucIvAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:[LyCurrentUser curUser].userId]
                                                         placeholderImage:[LyUtil defaultAvatarForStudent]
                                                                completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                                                    if (image) {
                                                                        [[LyCurrentUser curUser] setUserAvatar:image];
                                                                    }
                                                                }];
                                      }
                                  }];
        } else {
            [_ucIvAvatar setImage:[[LyCurrentUser curUser] userAvatar]];
        }
    }
}



- (void)ucSetAvatarViewNameText
{
    if ( [[[LyCurrentUser curUser] userName] isEqualToString:@""] || ![[LyCurrentUser curUser] userName])
    {
        [_ucLbName setText:@"请登录"];
    }
    else
    {
        [_ucLbName setText:[[LyCurrentUser curUser] userName]];
    }
    
}


- (void)ucSetAvatarViewPhoneNumberText
{
    if ( [[[LyCurrentUser curUser] userPhoneNum] isEqualToString:@""] || ![[LyCurrentUser curUser] userPhoneNum])
    {
        [_ucLbPhoneNumber setText:@""];
    }
    else
    {
        [_ucLbPhoneNumber setText:[LyUtil hidePhoneNumber:[[LyCurrentUser curUser] userPhoneNum]]];
    }
    
}



- (void)ucTargetForAvatarView:(UIGestureRecognizer *)gesture
{
    int pushIndex = 101;
//    if ( ![[LyCurrentUser curUser] isLogined])
//    {
//        pushIndex = 100;
//    }
//    else
//    {
//        pushIndex = 101;
//    }
    
    [self ucPostNotificationForPush:pushIndex];
}



- (void)ucPostNotificationForPush:(int)index
{
//    if ( index < 15)
//    {
//        if ( ![[LyCurrentUser curUser] isLogined])
//        {
//            index = 100;
//        }
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LyNotificationForUserCenterPush object:[[NSString alloc] initWithFormat:@"%d", index]];
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
                                                     userIdKey:[[LyCurrentUser curUser] userId],
                                                     sessionIdKey:[LyUtil httpSessionId]
                                                     }
                                              type:LyHttpType_asynPost
                                           timeOut:3.0f] boolValue];
    }
}



- (void)logout
{
    [[LyCurrentUser curUser] logout];
    
    if ( [indicator_logout isAnimating]) {
        [indicator_logout stopAnimation];
    }
    [LyUtil setAutoLoginFlag:NO];
    
    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"退出登录成功"];
    [remind setDelegate:self];
    [remind show];
}





#pragma mark -LyHttpRequestDelegate
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest
{
    if ( bHttpFlag)
    {
        bHttpFlag = NO;
        curHttpMethod = ahttpRequest.mode;
        
        switch ( curHttpMethod) {
            case leftMenuHttpMethod_logout: {
                curHttpMethod = 0;
                [self logout];
                break;
            }
        }
    }
}


- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result
{
    if ( bHttpFlag)
    {
        bHttpFlag = NO;
        curHttpMethod = ahttpRequest.mode;
        
        switch ( curHttpMethod) {
            case leftMenuHttpMethod_logout: {
                curHttpMethod = 0;
                [self logout];
                break;
            }
        }
        
    }
}



#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(LyRemindView *)aRemind
{
    [[RESideMenu sharedInstance] hideMenuViewController];
}



#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return uctcellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (0 == indexPath.row)
    {
        [self ucPostNotificationForPush:(int)(indexPath.row+10)];
    }
    else
    {
        if ([LyUtil driveExamOpenFlag])
        {
            [self ucPostNotificationForPush:(int)(indexPath.row+10)];
        }
        else
        {
             [self ucPostNotificationForPush:(int)(indexPath.row+10+1)];
        }
    }

}


#pragma mark UITableViewDataSource相关
////返回每个分组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([LyUtil driveExamOpenFlag])
    {
        return [ucArrFuncList count];
    }
    else
    {
        return ucArrFuncList.count-1;
    }
}


////生成每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyUserCenterTableViewCell *tmpCell = [tableView dequeueReusableCellWithIdentifier:lyCoachTableViewCellReuseIdentifier];
    
    if ( !tmpCell)
    {
        tmpCell = [[LyUserCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyCoachTableViewCellReuseIdentifier];
    }
    
    if (0 == indexPath.row)
    {
        [tmpCell setCellInfo:[ucArrFuncList objectAtIndex:[indexPath row]] withImage:[LyUtil imageForImageName:[[NSString alloc] initWithFormat:@"uc_item_%ld", (long)[indexPath row]] needCache:NO]];
    }
    else
    {
        if ([LyUtil driveExamOpenFlag])
        {
            [tmpCell setCellInfo:[ucArrFuncList objectAtIndex:indexPath.row] withImage:[LyUtil imageForImageName:[[NSString alloc] initWithFormat:@"uc_item_%ld", (long)indexPath.row] needCache:NO]];
        }
        else
        {
            [tmpCell setCellInfo:[ucArrFuncList objectAtIndex:indexPath.row+1] withImage:[LyUtil imageForImageName:[[NSString alloc] initWithFormat:@"uc_item_%ld", (long)indexPath.row+1] needCache:NO]];
        }
    }
    
    
    
    
    return tmpCell;
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
