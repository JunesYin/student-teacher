//
//  UIViewController+backButtonHandler.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/25.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol BackButtonHandlerProtocol <NSObject>
@optional
// Override this method in UIViewController derived class to handle 'Back' button click
- (BOOL)navigationShouldPopOnBackButton;
@end


@interface UIViewController (backButtonHandler) <BackButtonHandlerProtocol>

@end
