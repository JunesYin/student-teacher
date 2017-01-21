//
//  LyAddGuiderTableViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/17.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyUtil.h"



@class LyGuider;
@class LyAddGuiderTableViewController;



@protocol LyAddGuiderTableViewControllerDelegate <NSObject>

- (LyAddTeacherMode)obtainModeByAddGuiderTableViewController:(LyAddGuiderTableViewController *)aAddGuider;

- (void)addGuiderFinishedByAddGuiderTableViewController:(LyAddGuiderTableViewController *)aAddGuider andGuider:(LyGuider *)guider;

@end



@interface LyAddGuiderTableViewController : UITableViewController

@property ( assign, nonatomic)  LyAddTeacherMode        mode;

@property ( weak, nonatomic)    id<LyAddGuiderTableViewControllerDelegate>      delegate;




@end
