//
//  LyToolBar.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/27.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


//@class LyToolBar;
//
//@protocol LyToolBarDelegate <NSObject>
//
//@optional
//- (void)onClickedDoneByToolBar:(LyToolBar *)aToolBar;
//
//@end


@interface LyToolBar : UIView


@property ( retain, nonatomic)          UIView                          *inputControl;


+ (instancetype)toolBarWithInputControl:(UIView *)input;

- (instancetype)initWithInputControl:(UIView *)input;

@end
