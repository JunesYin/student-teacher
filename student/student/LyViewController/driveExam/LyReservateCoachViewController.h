//
//  LyReservateCoachViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/19.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyUtil.h"



@class LyCoach;
@class LyReservateCoachViewController;


@protocol LyReservateCoachViewControllerDelegate <NSObject>

@optional
- (NSDictionary *)obtainCoachObjectByReservateCoachViewController:(LyReservateCoachViewController *)aReservateCoach;

@end

@interface LyReservateCoachViewController : UIViewController

@property ( retain, nonatomic, readonly)    NSString                *coachId;

@property ( assign, nonatomic)              id<LyReservateCoachViewControllerDelegate>      delegate;



@end
