//
//  LyAddStudentManuallyViewController.h
//  teacher
//
//  Created by Junes on 16/8/18.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>




UIKIT_EXTERN NSString *const asmNameKey;
UIKIT_EXTERN NSString *const asmPhoneKey;


typedef NS_ENUM(NSInteger, LyAddStudentManuallyViewControllerMode) {
    LyAddStudentManuallyViewControllerMode_manually,
    LyAddStudentManuallyViewControllerMode_addressBook
};


@protocol LyAddStudentManuallyViewControllerDelegate;

@interface LyAddStudentManuallyViewController : UIViewController

@property (weak, nonatomic)     id<LyAddStudentManuallyViewControllerDelegate>      delegate;

@property (assign, nonatomic)   LyAddStudentManuallyViewControllerMode              mode;

@end


@protocol LyAddStudentManuallyViewControllerDelegate <NSObject>

@optional
- (NSDictionary *)obtainStudentInfoByAddStudentManuallyViewController:(LyAddStudentManuallyViewController *)aAddStudentManuallyVC;

- (void)onAddDoneByAddStudentManuallyViewController:(LyAddStudentManuallyViewController *)aAddStudentManuallyVC;

@end
