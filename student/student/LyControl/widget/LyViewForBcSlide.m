//
//  LyViewForBcSlide.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/21.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyViewForBcSlide.h"

#import "LyBottomControl.h"


@implementation LyViewForBcSlide

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[LyBottomControl sharedInstance] touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[LyBottomControl sharedInstance] touchesMoved:touches withEvent:event];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[LyBottomControl sharedInstance] touchesEnded:touches withEvent:event];
}



@end
