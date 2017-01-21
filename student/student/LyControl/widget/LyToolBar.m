//
//  LyToolBar.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/27.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyToolBar.h"

#import "LyUtil.h"



typedef NS_ENUM( NSInteger, LyToolBarBarButtonItemMode)
{
    toolBarBarButtonItemMode_done = 1,
};


@interface LyToolBar ()
{
    UIToolbar                   *toolBar;
    
    UIBarButtonItem             *barBtnSpace;
    UIBarButtonItem             *barBtnDone;
}
@end


@implementation LyToolBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+ (instancetype)toolBarWithInputControl:(UIView *)input
{
    LyToolBar *toolBar = [[LyToolBar alloc] initWithInputControl:input];
    
    return toolBar;
}


- (instancetype)initWithInputControl:(UIView *)input
{
    if ( self = [super initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, 35)])
    {
        _inputControl = input;
        [self initSubviews];
    }
    
    return self;
}


- (instancetype)init
{
    if ( self = [super initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, 35)])
    {
        [self initSubviews];
    }
    
    return self;
}



- (void)initSubviews
{
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, CGRectGetHeight(self.frame))];
    
    barBtnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    barBtnDone = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(targetForBarButotnItem:)];
    [barBtnDone setTag:toolBarBarButtonItemMode_done];
    
    [toolBar setItems:@[barBtnSpace, barBtnDone]];
    
    [self addSubview:toolBar];
}

- (void)targetForBarButotnItem:(UIBarButtonItem *)barBtnItem
{
    switch ( [barBtnDone tag]) {
        case toolBarBarButtonItemMode_done: {
            
            if ( _inputControl)
            {
                [_inputControl resignFirstResponder];
            }

            break;
        }
        default:
            break;
    }
}


@end
