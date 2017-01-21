//
//  UIViewController+CloseSelf.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/28.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "UIViewController+CloseSelf.h"

@implementation UIViewController (CloseSelf)




- (void)closeSelf
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    
    if ( [viewControllers count] > 1)
    {
        if ( [viewControllers objectAtIndex:[viewControllers count]-1] == self)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            ;
        }];
    }
}



- (BOOL)isVisiable
{
    if (self.isViewLoaded && self.view.window) {
        return YES;
    }
    
    return NO;
}


@end
