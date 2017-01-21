//
//  LyStatusDetailViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LySingleInstance.h"


@class LyStatus;
@class LyStatusDetailViewController;

@protocol LyStatusDetailViewControllerDelegate <NSObject>

- (void)deleteFinishByStatusDetailViewController:(LyStatusDetailViewController *)sdvc;

- (LyStatus *)obtainStatusByStatusDetailViewController:(LyStatusDetailViewController *)sdvc;

@end


@interface LyStatusDetailViewController : UIViewController

@property ( retain, nonatomic)      LyStatus                *status;

@property ( weak, nonatomic)        id<LyStatusDetailViewControllerDelegate>        delegate;



@end
