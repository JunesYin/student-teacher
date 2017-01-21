//
//  UIImage+RoundedRectImage.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/25.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RoundedRectImage)


+ (UIImage *)imageOfRoundRectWithImage:(UIImage *)image size:(CGSize)size radius:(float)radius;

@end
