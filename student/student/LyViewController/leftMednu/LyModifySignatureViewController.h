//
//  LyModifySignatureViewController.h
//  student
//
//  Created by Junes on 2016/11/18.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LyModifySignatureViewControllerDelegate;

@interface LyModifySignatureViewController : UIViewController

@property (weak, nonatomic)     id<LyModifySignatureViewControllerDelegate>     delegate;

@end


@protocol LyModifySignatureViewControllerDelegate <NSObject>

@required
- (void)modifySignatureViewController:(LyModifySignatureViewController *)aModifySignatureVC done:(NSString *)signature;

@end
