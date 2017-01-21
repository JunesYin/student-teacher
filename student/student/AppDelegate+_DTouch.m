//
//  AppDelegate+_DTouch.m
//  student
//
//  Created by MacMini on 2017/1/16.
//  Copyright © 2017年 517xueche. All rights reserved.
//

#import "AppDelegate+_DTouch.h"

#import "UIViewController+Utils.h"
#import "LyUtil.h"

#import "LyBottomControl.h"
#import "LySimulateLocalViewController.h"
#import "LySweepViewController.h"
#import "LyMyQRCodeViewController.h"


@implementation AppDelegate (_DTouch)

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    self.lastShortcutItem = shortcutItem;
    
    if ([LyUtil isReady]) {
        [self actionForNotification_LyNotificationForJumpReady_3DTouch:nil];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionForNotification_LyNotificationForJumpReady_3DTouch:) name:LyNotificationForJumpReady object:nil];
    }
}


- (void)actionForNotification_LyNotificationForJumpReady_3DTouch:(NSNotification *)notifi {

    UIViewController *target = (UIViewController *)notifi.object;
    if (!target) {
        target = [UIViewController currentViewController];
    }
    UIViewController *desVC = nil;
    if ([self.lastShortcutItem.localizedTitle isEqualToString:@"全真模考"]) {
        desVC = [[LySimulateLocalViewController alloc] init];
    } else if ([self.lastShortcutItem.localizedTitle isEqualToString:@"扫一扫"]) {
        desVC = [[LySweepViewController alloc] init];
    } else if ([self.lastShortcutItem.localizedTitle isEqualToString:@"我的二维码"]) {
        desVC = [[LyMyQRCodeViewController alloc] init];
    }
    
    if (desVC) {
        [target.navigationController pushViewController:desVC animated:YES];
    }
    
    self.lastShortcutItem = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LyNotificationForJumpReady object:nil];
}



@end
