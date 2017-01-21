//
//  LyTrainClassDetailTableViewController.h
//  teacher
//
//  Created by Junes on 16/8/25.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LyTrainClass;
@class LyTrainClassDetailTableViewController;

@protocol LyTrainClassDetailTableViewControllerDelegate <NSObject>

@required
- (LyTrainClass *)obtainTrainClassByTrainClassDetailTVC:(LyTrainClassDetailTableViewController *)aTrainClassDetailTVC;

- (void)onDeleteByTrainClassByTrainClassDetailTVC:(LyTrainClassDetailTableViewController *)aTrainClassDetailTVC;

@end


@interface LyTrainClassDetailTableViewController : UITableViewController

@property (retain, nonatomic) LyTrainClass                                  *trainClass;
@property (weak, nonatomic  ) id<LyTrainClassDetailTableViewControllerDelegate> delegate;

@end
