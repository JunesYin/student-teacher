//
//  LyTabBarViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyTabBarViewController.h"

#import "LyReservateCoachViewController.h"

#import "LyTheoryStudyViewController.h"
#import "LyCoachViewController.h"
#import "LyDriveSchoolViewController.h"
#import "LyGuiderViewController.h"
#import "LyCommunityViewController.h"

#import "LyLoginViewController.h"
#import "LyOrderCenterViewController.h"
#import "LyDriveExamTableViewController.h"
#import "LyMyNewsTableViewController.h"
#import "LyFriendsTableViewController.h"
#import "LyStudyGuidanceTableViewController.h"
#import "LySettingTableViewController.h"


#import "LySendNewsViewController.h"

#import "LyCurrentUser.h"

#import "LySweepViewController.h"
#import "LyMyQRCodeViewController.h"

#import "LyBottomControl.h"
#import "LyUtil.h"


#import "student-Swift.h"
#import <WebKit/WebKit.h>


@interface LyTabBarViewController () <LyBottomControlDelegate>
{
    LyBottomControl                     *tbBottomControl;
    
    NSString                            *pushIndex;
}
@end

@implementation LyTabBarViewController


lySingle_implementation(LyTabBarViewController)


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self tbInitSubViewController];
    [self chAddNotification];
}



- (void)tbInitSubViewController {
    
    
    _theoryStudyNavigationController = [[UINavigationController alloc] initWithRootViewController:[LyTheoryStudyViewController sharedInstance]];
//    _theoryStudyNavigationController.
    
    _coachNavigationController = [[UINavigationController alloc] initWithRootViewController:[LyCoachViewController sharedInstance]];
    
    _driveSchoolNavigationController = [[UINavigationController alloc] initWithRootViewController:[LyDriveSchoolViewController sharedInstance]];
    
    _guiderNavigationController = [[UINavigationController alloc] initWithRootViewController:[LyGuiderViewController sharedInstance]];
    
    _communityNavigationController = [[UINavigationController alloc] initWithRootViewController:[LyCommunityViewController sharedInstance]];
    
    [self setViewControllers:@[
                               _theoryStudyNavigationController,
                               _coachNavigationController,
                               _driveSchoolNavigationController,
                               _guiderNavigationController,
                               _communityNavigationController
                               ]];
    
    UIView *uselessView = [[LyTheoryStudyViewController sharedInstance] view];
    uselessView = [[LyCoachViewController sharedInstance] view];
    uselessView = [[LyDriveSchoolViewController sharedInstance] view];
    uselessView = [[LyGuiderViewController sharedInstance] view];
    uselessView = [[LyCommunityViewController sharedInstance] view];
    
    
    [self setSelectedIndex:BcDriveSchoolCenter];
    
    
    [self.tabBar setHidden:YES];
    tbBottomControl = [LyBottomControl sharedInstance];
    [tbBottomControl setDelegate:self];
    [self.view addSubview:tbBottomControl];
}



- (void)chAddNotification
{
    if ( [self respondsToSelector:@selector(tbTargetForNotificationToUserCenterPush:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tbTargetForNotificationToUserCenterPush:) name:LyNotificationForUserCenterPush object:nil];
    }
}



- (void)tbTargetForNotificationToUserCenterPush:(NSNotification *)notification
{
    NSString *userInfo = [notification object];
    pushIndex = userInfo;
//    [self performSelector:@selector(tbDelayPush:) withObject:userInfo afterDelay:0.02f];
}



- (void)pushSomeViewController
{
    [self tbDelayPush:pushIndex];
    
    pushIndex = @"0";
}



- (void)tbDelayPush:(NSString *)vcIndex
{
    
    UIViewController *nextVc = nil;
    BOOL needLogin = NO;
    
    switch ( [vcIndex intValue]) {
        case 10:
        {
            LyOrderCenterViewController *orderCenter = [[LyOrderCenterViewController alloc] init];
//            [self.selectedViewController pushViewController:orderCenter animated:YES];
            nextVc = orderCenter;
            needLogin = YES;
            break;
        }
            
        case 11:
        {
            LyDriveExamTableViewController *driveExam = [[LyDriveExamTableViewController alloc] init];
//            [self.selectedViewController pushViewController:driveExam animated:YES];
            nextVc = driveExam;
            needLogin = YES;
            break;
        }
            
        case 12:
        {
            LyMyNewsTableViewController *myNewsVC = [[LyMyNewsTableViewController alloc] init];
//            [self.selectedViewController pushViewController:myNewsVC animated:YES];
            nextVc = myNewsVC;
            needLogin = YES;
            break;
        }
            
        case 13:
        {
            LyFriendsTableViewController *friends = [[LyFriendsTableViewController alloc] init];
//           [self.selectedViewController pushViewController:friends animated:YES];
            nextVc = friends;
            needLogin = YES;
            break;
        }
            
        case 14:
        {
            LyStudyGuidanceTableViewController *studyGuidabce = [[LyStudyGuidanceTableViewController alloc] init];
//             [self.selectedViewController pushViewController:studyGuidabce animated:YES];
            nextVc = studyGuidabce;
            needLogin = YES;
            break;
        }
            
        case 15:
        {
            LyAboutUsViewController *aboutUs = [[LyAboutUsViewController alloc] init];
//            [self.selectedViewController pushViewController:aboutUs animated:YES];
            nextVc = aboutUs;
            needLogin = NO;
            break;
        }
            
        case 16:
        {
            LySettingTableViewController *setting = [[LySettingTableViewController alloc] init];
//            [self.selectedViewController pushViewController:setting animated:YES];
            nextVc = setting;
            needLogin = NO;
            break;
        }
            
        case 18:
        {
            
            break;
        }
            
        case 100:
        {
//            UINavigationController *vc = self.selectedViewController;
//            [LyUtil showLoginVc:vc.visibleViewController];
            break;
        }
            
        case 101:
        {
            LyUserInfoTableViewController *userInfo = [[LyUserInfoTableViewController alloc] init];
//            [self.selectedViewController pushViewController:userInfo animated:YES];
            nextVc = userInfo;
            needLogin = YES;
            break;
        }
            
            
        case 200:
        {
            break;
        }
            
            
        case 201:
        {
            break;
        }
            
        case 202:
        {
//#if DEBUG
//            LyScanQRCodeViewController *sweep = [[LyScanQRCodeViewController alloc] init];
//#else
            LySweepViewController *sweep = [[LySweepViewController alloc] init];
//#endif
            
            nextVc = sweep;
            needLogin = NO;
            break;
        }
            
            
        case 203:
        {
            LyMyQRCodeViewController *qrCode = [[LyMyQRCodeViewController alloc] init];
//            [self.selectedViewController pushViewController:qrCode animated:YES];
            nextVc = qrCode;
            needLogin = NO;
            break;
        }
            
        case 204:
        {
            break;
        }
        default:
        {
            break;
        }
    }
    
    if (nextVc) {
        if (needLogin && ![LyCurrentUser curUser].isLogined) {
            if ([nextVc isKindOfClass:[LyUserInfoTableViewController class]]) {
                [LyUtil showLoginVc:[UIViewController currentViewController]];
            } else {
                [LyUtil showLoginVc:[UIViewController currentViewController] nextVC:nextVc showMode:LyShowVcMode_push];
            }
        } else {
            [self.selectedViewController pushViewController:nextVc animated:YES];
        }
    }
}

#pragma mark -LyBottomControlDelegate
- (void)onChangViewContollerSelectedIndex:(NSInteger)selectedIndex
{
    NSLog( @"selectedIndex is %ld", selectedIndex);
    [self setSelectedIndex:selectedIndex];
}


- (void)onSearch:(NSString *)strSearch index:(NSInteger)index
{
    if ( 0 == index)
    {
        [[LyCoachViewController sharedInstance] search:strSearch];
    }
    else if ( 1 == index)
    {
        [[LyDriveSchoolViewController sharedInstance] search:strSearch];
    }
    else if ( 2 == index)
    {
        [[LyGuiderViewController sharedInstance] search:strSearch];
    }
}


- (void)onCLickedByAddressButton:(NSInteger)index
{
    if ( 0 == index)
    {
        [[LyCoachViewController sharedInstance] openAddressPicker];
    }
    else if ( 1 == index)
    {
        [[LyDriveSchoolViewController sharedInstance] openAddressPicker];
    }
    else if ( 2 == index)
    {
        [[LyGuiderViewController sharedInstance] openAddressPicker];
    }
}



- (void)onSearchWillBegin:(NSInteger)index
{
    if ( 0 == index)
    {
        [[LyCoachViewController sharedInstance] searchWillBegin];
    }
    else if ( 1 == index)
    {
        [[LyDriveSchoolViewController sharedInstance] searchWillBegin];
    }
    else if ( 2 == index)
    {
        [[LyGuiderViewController sharedInstance] searchWillBegin];
    }
}



- (void)onBtnExamLocaleClick
{
    if ( BcTheoryStudyCenter == self.selectedIndex)
    {
        [[LyTheoryStudyViewController sharedInstance] showAddressPicker];
    }
}


- (void)onBtnLicenseInfoClick
{
    if ( BcTheoryStudyCenter == self.selectedIndex)
    {
        [[LyTheoryStudyViewController sharedInstance] showLicenseInfoPicker];
    }
}


- (void)onBtnSendStatusClick
{
    if ( BcCommunityCenter == self.selectedIndex)
    {
//        if ( ![[LyCurrentUser curUser] isLogined])
//        {
//            UINavigationController *vc = self.selectedViewController;
//            [LyUtil showLoginVc:vc.visibleViewController];
//        }
//        else
//        {
            [[LyCommunityViewController sharedInstance] openSendNewsViewController];
//        }
    }
}


- (void)onBtnNewsAboutMeClick
{
    if ( BcCommunityCenter == self.selectedIndex)
    {
        if ( ![[LyCurrentUser curUser] isLogined])
        {
            UINavigationController *vc = self.selectedViewController;
            [LyUtil showLoginVc:vc.visibleViewController];
        }
        else
        {
            [[LyCommunityViewController sharedInstance] openOboutMeTableViewController];
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
