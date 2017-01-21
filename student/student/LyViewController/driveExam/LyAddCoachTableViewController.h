//
//  LyAddCoachTableViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/17.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LySingleInstance.h"
#import "LyUtil.h"


@class LyCoach;
@class LyAddCoachTableViewController;



@protocol LyAddCoachTableViewControllerDelegate <NSObject>

- (LyAddTeacherMode)obtainModeByAddCoachTableViewController:(LyAddCoachTableViewController *)aAddCoach;

- (void)addCoachFinishedByAddCoachTableViewController:(LyAddCoachTableViewController *)aAddCoach andCoach:(LyCoach *)coach;

@end



@interface LyAddCoachTableViewController : UITableViewController

@property ( assign, nonatomic)      LyAddTeacherMode        mode;

@property ( weak, nonatomic)    id<LyAddCoachTableViewControllerDelegate>       delegate;



@end
