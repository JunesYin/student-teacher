//
//  LyModifyNameViewController.h
//  student
//
//  Created by Junes on 2016/11/18.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, LyModifyNameControllerMode) {
    LyModifyNameControllerMode_name,
    LyModifyNameControllerMode_trueName
};

@protocol LyModifyNameViewControllerDelegate;

@interface LyModifyNameViewController : UIViewController

@property (weak, nonatomic)     id<LyModifyNameViewControllerDelegate>      delegate;

@property (assign, nonatomic)   LyModifyNameControllerMode      mode;

@end


@protocol LyModifyNameViewControllerDelegate <NSObject>

@required
- (void)modifyNameViewController:(LyModifyNameViewController *)modifyNameVC modifyDone:(NSString *)name;

@end
