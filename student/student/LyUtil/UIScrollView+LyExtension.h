//
//  UIScrollView+LyExtension.h
//  pullUp
//
//  Created by MacMini on 2017/1/11.
//  Copyright © 2017年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (LyExtension)

@property (nonatomic)   CGFloat ly_insetTop;
@property (nonatomic)   CGFloat ly_insetLeft;
@property (nonatomic)   CGFloat ly_insetBottom;
@property (nonatomic)   CGFloat ly_insetRight;

@property (nonatomic)   CGFloat ly_offsetX;
@property (nonatomic)   CGFloat ly_offsetY;

@property (nonatomic)   CGFloat ly_contentWidth;
@property (nonatomic)   CGFloat ly_contentHeight;

@end
