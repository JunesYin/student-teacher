//
//  UIView+LyExtension.m
//  pullUp
//
//  Created by MacMini on 2017/1/11.
//  Copyright © 2017年 517xueche. All rights reserved.
//

#import "UIView+LyExtension.h"

@implementation UIView (LyExtension)

- (CGPoint)ly_origin
{
    return self.frame.origin;
}

- (void)setLy_origin:(CGPoint)ly_origin
{
    CGRect frame = self.frame;
    frame.origin = ly_origin;
    self.frame = frame;
}

- (CGFloat)ly_x
{
    return self.ly_origin.x;
}

- (void)setLy_x:(CGFloat)ly_x
{
    CGPoint origin = self.ly_origin;
    origin.x = ly_x;
    self.ly_origin = origin;
}

- (CGFloat)ly_y
{
    return self.ly_origin.y;
}

- (void)setLy_y:(CGFloat)ly_y
{
    CGPoint origin = self.ly_origin;
    origin.y = ly_y;
    self.ly_origin = origin;
}



- (CGSize)ly_size
{
    return self.bounds.size;
}

- (void)setLy_size:(CGSize)ly_size
{
    CGRect frame = self.frame;
    frame.size = ly_size;
    self.frame = frame;
}

- (CGFloat)ly_width
{
    return self.ly_size.width;
}

- (void)setLy_width:(CGFloat)ly_width
{
    CGSize size = self.ly_size;
    size.width = ly_width;
    self.ly_size = size;
}

- (CGFloat)ly_height
{
    return self.ly_size.height;
}

- (void)setLy_height:(CGFloat)ly_height
{
    CGSize size = self.ly_size;
    size.height = ly_height;
    self.ly_size = size;
}



- (CGFloat)ly_centerX
{
    return self.center.x;
}

- (void)setLy_centerX:(CGFloat)ly_centerX
{
    CGPoint center = self.center;
    center.x = ly_centerX;
    self.center = center;
}

- (CGFloat)ly_centerY
{
    return self.center.y;
}

- (void)setLy_centerY:(CGFloat)ly_centerY
{
    CGPoint center = self.center;
    center.y = ly_centerY;
    self.center = center;
}

@end
