//
//  LyChooseTrainClassTableViewController.h
//  teacher
//
//  Created by Junes on 16/8/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LyTrainClass;

@protocol LyChooseTrainClassTableViewControllerDelegate;

@interface LyChooseTrainClassTableViewController : UITableViewController

@property (weak, nonatomic)     id<LyChooseTrainClassTableViewControllerDelegate>       delegate;

@property (retain, nonatomic)   LyTrainClass                                            *trainClass;

@end



@protocol LyChooseTrainClassTableViewControllerDelegate <NSObject>

- (void)onCancelByChooseTrainClassTVC:(LyChooseTrainClassTableViewController *)aChooseTrainClassTVC;

- (void)onDoneByChooseTrainClassTVC:(LyChooseTrainClassTableViewController *)aChooseTrainClassTVC trainClass:(LyTrainClass *)aTrainClass;

@end