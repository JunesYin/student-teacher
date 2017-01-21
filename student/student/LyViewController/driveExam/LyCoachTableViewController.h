//
//  LyCoachTableViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/17.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyUtil.h"


@class LyCoachTableViewController;


@protocol LyCoachTableViewControllerDelegate <NSObject>

- (NSDictionary *)obtainCoachInfoByCoachTableViewController:(LyCoachTableViewController *)aCoach;

@end



@interface LyCoachTableViewController : UITableViewController

@property ( retain, nonatomic)      NSString            *driveSchoolId;
@property ( retain, nonatomic)      NSString            *trainBaseId;
@property ( assign, nonatomic)      LySubjectModeprac  subject;
@property ( weak, nonatomic)    id<LyCoachTableViewControllerDelegate>      delegate;



@end
