//
//  LyToolBar.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/27.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface LyToolBar : UIView


@property ( retain, nonatomic)          UIView                          *inputControl;


+ (instancetype)toolBarWithInputControl:(UIView *)input;

- (instancetype)initWithInputControl:(UIView *)input;

@end
