//
//  LyStudentInfoViewController.h
//  teacher
//
//  Created by Junes on 2016/11/11.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LyStudentInfoViewControllerDelegate;

@interface LyStudentInfoViewController : UIViewController

@property (weak, nonatomic)     id<LyStudentInfoViewControllerDelegate>     delegate;

@property (retain, nonatomic)   NSString        *coachId;

@end




@protocol LyStudentInfoViewControllerDelegate <NSObject>

- (NSString *)obtainCoachIdByStudentInfoVC:(LyStudentInfoViewController *)aStudentInfoVC;

@end
