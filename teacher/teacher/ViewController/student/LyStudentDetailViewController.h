//
//  LyStudentDetailViewController.h
//  teacher
//
//  Created by Junes on 16/8/17.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>




@protocol LyStudentDetailViewControllerDelegate;

@interface LyStudentDetailViewController : UIViewController

@property (weak, nonatomic)     id<LyStudentDetailViewControllerDelegate>       delegate;

@property (retain, nonatomic)   NSString                                        *stuId;

@end


@protocol LyStudentDetailViewControllerDelegate <NSObject>

@required
- (NSString *)obtainStudentIdByStudentDetailVC:(LyStudentDetailViewController *)aStudentDetailVC;

- (void)onDeleteByStudentDetailVC:(LyStudentDetailViewController *)aStudentDetailVC;

@end
