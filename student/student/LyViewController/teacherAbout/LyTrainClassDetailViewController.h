//
//  LyTrainClassDetailViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/21.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyTrainClassManager.h"



@class LyUser;
@class LyTrainClassDetailViewController;



@protocol LyTrainClassDetailViewControllerDelegate <NSObject>

@required
- (NSDictionary *)obtainTrainClassInfoByTrainClassDetailViewController:(LyTrainClassDetailViewController *)aTrainClassDetailVc;

@end


@interface LyTrainClassDetailViewController : UIViewController


@property ( retain, nonatomic)          LyTrainClass                        *trainClass;

@property ( retain, nonatomic)          LyUser                              *teacher;

@property ( weak, nonatomic)            id<LyTrainClassDetailViewControllerDelegate>      delegate;






@end
