//
//  LyTabBarViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LySingleInstance.h"

@interface LyTabBarViewController : UITabBarController

@property ( strong, nonatomic)                  UINavigationController                  *theoryStudyNavigationController;
@property ( strong, nonatomic)                  UINavigationController                  *coachNavigationController;
@property ( strong, nonatomic)                  UINavigationController                  *driveSchoolNavigationController;
@property ( strong, nonatomic)                  UINavigationController                  *guiderNavigationController;
@property ( strong, nonatomic)                  UINavigationController                  *communityNavigationController;

lySingle_interface

- (void)pushSomeViewController;


@end
