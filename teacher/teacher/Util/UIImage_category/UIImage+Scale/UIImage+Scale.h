//
//  UIImage+Scale.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)

- (UIImage *)scaleToSize:(CGSize)size;

+ (UIImage *)fixOrientation:(UIImage *)aImage;

@end
