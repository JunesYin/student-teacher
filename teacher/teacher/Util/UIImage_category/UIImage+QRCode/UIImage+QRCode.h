//
//  UIImage+QRCode.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/25.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QRCode)

/*生成二维码*/
+ (UIImage *)imageForQRCodeFromUrl:(NSString *)strUrl codeSize:(CGFloat)size red:(int)red green:(int)green blue:(int)blue;

/* 生成小头像二维码 */
+ (UIImage *)imageForQRCodeFromUrl:(NSString *)strUrl codeSize:(CGFloat)size red:(float)red green:(float)green blue:(float)blue insertImage:(UIImage *)insertImage cornerRadius:(float)radius;

@end
