//
//  LyReservationDetailTableViewController.h
//  teacher
//
//  Created by Junes on 2016/9/23.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LyDateTimeInfo;
@protocol LyReservationDetailTableViewControllerDelegate;

@interface LyReservationDetailTableViewController : UITableViewController

@property (weak, nonatomic)     id<LyReservationDetailTableViewControllerDelegate>      delegate;

@property (retain, nonatomic)   LyDateTimeInfo          *dateTimeInfo;

@end


@protocol LyReservationDetailTableViewControllerDelegate <NSObject>

@required
- (LyDateTimeInfo *)obtainDateTimeInfoByReservationDetailTVC:(LyReservationDetailTableViewController *)aReservationDetailTVC;

@end
