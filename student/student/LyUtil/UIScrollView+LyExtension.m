//
//  UIScrollView+LyExtension.m
//  pullUp
//
//  Created by MacMini on 2017/1/11.
//  Copyright © 2017年 517xueche. All rights reserved.
//

#import "UIScrollView+LyExtension.h"

@implementation UIScrollView (LyExtension)

- (CGFloat)ly_insetTop
{
    return self.contentInset.top;
}

- (void)setLy_insetTop:(CGFloat)ly_insetTop
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = ly_insetTop;
    self.contentInset = inset;
}


- (CGFloat)ly_insetLeft
{
    return self.contentInset.left;
}

- (void)setLy_insetLeft:(CGFloat)ly_insetLeft
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = ly_insetLeft;
    self.contentInset = inset;
}


- (CGFloat)ly_insetBottom
{
    return self.contentInset.bottom;
}

- (void)setLy_insetBottom:(CGFloat)ly_insetBottom
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = ly_insetBottom;
    self.contentInset = inset;
}


- (CGFloat)ly_insetRight
{
    return self.contentInset.right;
}

- (void)setLy_insetRight:(CGFloat)ly_insetRight
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = ly_insetRight;
    self.contentInset = inset;
}



- (CGFloat)ly_offsetX
{
    return self.contentOffset.x;
}

- (void)setLy_offsetX:(CGFloat)ly_offsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = ly_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)ly_offsetY
{
    return self.contentOffset.y;
}

- (void)setLy_offsetY:(CGFloat)ly_offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = ly_offsetY;
    self.contentOffset = offset;
}



- (CGFloat)ly_contentWidth
{
    return self.contentSize.width;
}

- (void)setLy_contentWidth:(CGFloat)ly_contentWidth
{
    CGSize size = self.contentSize;
    size.width = ly_contentWidth;
    self.contentSize = size;
}

- (CGFloat)ly_contentHeight
{
    return self.contentSize.height;
}

- (void)setLy_contentHeight:(CGFloat)ly_contentHeight
{
    CGSize size = self.contentSize;
    size.height = ly_contentHeight;
    self.contentSize = size;
}



@end
