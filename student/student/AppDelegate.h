//
//  AppDelegate.h
//  student
//
//  Created by Junes on 16/8/15.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (retain, nonatomic) UIApplicationShortcutItem   *lastShortcutItem;

@property (weak, nonatomic) NSDictionary    *lastUserInfo;

@end

