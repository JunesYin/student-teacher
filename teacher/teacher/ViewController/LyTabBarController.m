//
//  LyTabBarController.m
//  teacher
//
//  Created by Junes on 16/8/8.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyTabBarController.h"


#import "RESideMenu.h"
#import "LyStudentViewController.h"
#import "LyPublishViewController.h"
#import "LyCommunityViewController.h"

#import "LyLeftMenuViewController.h"



#import "LyUserInfoViewController.h"
#import "LyTeachManageTableViewController.h"
#import "LyOrderCenterViewController.h"
#import "LyMyNewsTableViewController.h"
#import "LyFriendsTableViewController.h"
#import "LyAboutUsViewController.h"
#import "LySettingTableViewController.h"

#import "LySweepViewController.h"
#import "LyMyQRCodeViewController.h"


#import "LyUtil.h"





@interface LyTabBarController () <LyLeftMenuDelegate>
{
    LyStudentViewController             *vcStudent;
    LyPublishViewController             *vcPublish;
    LyCommunityViewController           *vcCommunity;
}
@end

@implementation LyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


- (instancetype)init
{
    if (self = [super init])
    {
        vcStudent = [[LyStudentViewController alloc] init];
        vcPublish = [[LyPublishViewController alloc] init];
        vcCommunity = [[LyCommunityViewController alloc] init];
        
        [self setViewControllers:@[
                                   [[UINavigationController alloc] initWithRootViewController:vcStudent],
                                   [[UINavigationController alloc] initWithRootViewController:vcPublish],
                                   [[UINavigationController alloc] initWithRootViewController:vcCommunity],
                                   ]];
        
        UIView *view;
        for (UINavigationController *vcItem in self.viewControllers)
        {
            view = [[[vcItem viewControllers] objectAtIndex:0] view];
        }
        view = nil;
        [self setSelectedIndex:0];
        
        if ([self respondsToSelector:@selector(targetForUserLogout:)])
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(targetForUserLogout:) name:LyNotificationForLogout object:nil];
        }
    }
    
    return self;
}



#pragma mark -LyLeftMenuDelegate
- (void)pushViewControllerWithIndex:(NSInteger)index
{
    [_sideMenu hideMenuViewController];
    
    switch (index) {
        case 0: {
            LyUserInfoViewController *userInfo = [[LyUserInfoViewController alloc] init];
            [userInfo setHidesBottomBarWhenPushed:YES];
            [self.selectedViewController pushViewController:userInfo animated:YES];
            break;
        }
            
        //左侧菜单栏
        case 10: {
            LyOrderCenterViewController *orderCenter = [[LyOrderCenterViewController alloc] init];
            [orderCenter setHidesBottomBarWhenPushed:YES];
            [self.selectedViewController pushViewController:orderCenter animated:YES];
            break;
        }
        case 11: {
            LyTeachManageTableViewController *teachManage = [[LyTeachManageTableViewController alloc] init];
            [teachManage setHidesBottomBarWhenPushed:YES];
            [self.selectedViewController pushViewController:teachManage animated:YES];
            break;
        }
        case 12: {
            LyMyNewsTableViewController *myNews = [[LyMyNewsTableViewController alloc] init];
            [myNews setHidesBottomBarWhenPushed:YES];
            [self.selectedViewController pushViewController:myNews animated:YES];
            break;
        }
        case 13: {
            LyFriendsTableViewController *friends = [[LyFriendsTableViewController alloc] init];
            [friends setHidesBottomBarWhenPushed:YES];
            [self.selectedViewController pushViewController:friends animated:YES];
            break;
        }
        case 14: {
            LyAboutUsViewController *aboutUs = [[LyAboutUsViewController alloc] init];
            [aboutUs setHidesBottomBarWhenPushed:YES];
            [self.selectedViewController pushViewController:aboutUs animated:YES];
            break;
        }
        case 15: {
            //设置
            LySettingTableViewController *setting = [[LySettingTableViewController alloc] init];
            [setting setHidesBottomBarWhenPushed:YES];
            [self.selectedViewController pushViewController:setting animated:YES];
            break;
        }
            
        //右侧菜单栏
        case 30: {
            //扫一扫
            LySweepViewController *sweep = [[LySweepViewController alloc] init];
            [sweep setHidesBottomBarWhenPushed:YES];
            [self.selectedViewController pushViewController:sweep animated:YES];
            break;
        }
        case 31: {
            LyMyQRCodeViewController *myQRCode = [[LyMyQRCodeViewController alloc] init];
            [myQRCode setHidesBottomBarWhenPushed:YES];
            [self.selectedViewController pushViewController:myQRCode animated:YES];
            break;
        }
            
        default:
            break;
    }
}



#pragma mark LyNotificationForLogout
- (void)targetForUserLogout:(NSNotification *)nitifi
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LyNotificationForLogout object:nil];
    
    _sideMenu = nil;
    vcStudent = nil;
    vcPublish = nil;
    vcCommunity = nil;
    [LyUtil setFinishGetUserIfo:NO];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LyNotificationForLogout object:nil];
    
    vcStudent = nil;
    vcPublish = nil;
    vcCommunity = nil;
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
