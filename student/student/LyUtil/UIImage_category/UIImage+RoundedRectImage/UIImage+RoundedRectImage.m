//
//  UIImage+RoundedRectImage.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/25.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "UIImage+RoundedRectImage.h"

@implementation UIImage (RoundedRectImage)



/**
 *  给上下文添加圆角蒙版
 */
void addRoundedRectToPath(CGContextRef context, CGRect rect, float radius, CGImageRef image)
{
    float width, height;
    if (radius == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    width = CGRectGetWidth(rect);
    height = CGRectGetHeight(rect);
    
    //裁剪路径
    CGContextMoveToPoint(context, width, height / 2);
    CGContextAddArcToPoint(context, width, height, width / 2, height, radius);
    CGContextAddArcToPoint(context, 0, height, 0, height / 2, radius);
    CGContextAddArcToPoint(context, 0, 0, width / 2, 0, radius);
    CGContextAddArcToPoint(context, width, 0, width, height / 2, radius);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    CGContextRestoreGState(context);
}



+ (UIImage *)imageOfRoundRectWithImage:(UIImage *)image size:(CGSize)size radius:(float)radius
{
    if ( !image)
    {
        return nil;
    }
    
    
    
    const CGFloat width = size.width;
    const CGFloat height = size.height;
    
    radius = MAX( 5.0f, radius);
    radius = MIN( 10.0f, radius);
    
    UIImage *tmpImage = image;
    
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef contextRef = CGBitmapContextCreate( NULL, width, height, 8, width * 4, colorSpaceRef, kCGImageAlphaPremultipliedFirst);
    
    CGRect rect = CGRectMake( 0, 0, width, height);
    
    //绘制圆角
    CGContextBeginPath(contextRef);
    
    addRoundedRectToPath( contextRef, rect, radius, tmpImage.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(contextRef);
    
    tmpImage = [UIImage imageWithCGImage:imageMasked];
    
    
    CGColorSpaceRelease(colorSpaceRef);
    CGContextRelease(contextRef);
    CGImageRelease(imageMasked);
    
    
    return  tmpImage;
}


@end
