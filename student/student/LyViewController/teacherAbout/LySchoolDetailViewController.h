//
//  LySchoolDetailViewController.h
//  student
//
//  Created by MacMini on 2016/12/22.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LySchoolDetailViewControllerDelegate;

@interface LySchoolDetailViewController : UIViewController

@property (weak, nonatomic)     id<LySchoolDetailViewControllerDelegate>        delegate;

@property (copy, nonatomic)     NSString        *schoolId;

@end


@protocol LySchoolDetailViewControllerDelegate <NSObject>

@required
- (NSString *)schoolIdBySchoolDetailViewController:(LySchoolDetailViewController *)aSchoolDetailVC;

@end
