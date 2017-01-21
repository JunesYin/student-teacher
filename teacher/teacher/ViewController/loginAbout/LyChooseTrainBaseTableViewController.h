//
//  LyChooseTrainBaseTableViewController.h
//  teacher
//
//  Created by Junes on 16/7/27.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LyTrainBase;
@protocol LyChooseTrainBaseTableViewControllerDelegate;




typedef NS_ENUM(NSInteger, LyChooseTrainBaseTableViewControllerMode) {
    LyChooseTrainBaseTableViewControllerMode_all,
    LyChooseTrainBaseTableViewControllerMode_school
};


@interface LyChooseTrainBaseTableViewController : UITableViewController

@property (assign, nonatomic)     LyChooseTrainBaseTableViewControllerMode          mode;

@property (weak, nonatomic)     id<LyChooseTrainBaseTableViewControllerDelegate>       delegate;

@property (retain, nonatomic)   LyTrainBase                         *trainBase;


+ (instancetype)chooseTrainBaseViewControllerWithMode:(LyChooseTrainBaseTableViewControllerMode)mode;
- (instancetype)initWithMode:(LyChooseTrainBaseTableViewControllerMode)mode;

@end



@protocol LyChooseTrainBaseTableViewControllerDelegate <NSObject>

@optional
- (NSString *)obtainAddressByChooseTrainBaseTVC:(LyChooseTrainBaseTableViewController *)aChooseTrainBaseTVC;

- (NSString *)obtainSchoolIdByChooseTrainBaseTVC:(LyChooseTrainBaseTableViewController *)aChooseTrainBaseTVC;

- (void)onDoneByChooseTrainBase:(LyChooseTrainBaseTableViewController *)aChooseTrainBaseVC trainBase:(LyTrainBase *)aTrainBase;

@end
