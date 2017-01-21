//
//  UIImage+QRCode.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/25.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "UIImage+QRCode.h"
#import "UIImage+RoundedRectImage.h"

@implementation UIImage (QRCode)

+ (UIImage *)imageForQRCodeFromUrl:(NSString *)strUrl codeSize:(CGFloat)size red:(int)red green:(int)green blue:(int)blue
{
    if ( !strUrl || [NSNull null] == (NSNull *)strUrl || [strUrl isEqualToString:@""])
    {
        return nil;
    }
    
    
    size = [self validateCodeSize:size];
    
    CIImage *orginalImage = [self createQRCodeFromUrl:strUrl];
    
    UIImage *progressImage = [self excludeFuzzyImageFormCIImage:orginalImage size:size];
    
    UIImage *effectiveImage = [self imageFillImageBackColor:progressImage red:red green:green blue:blue];
    
    return effectiveImage;
}



+ (CGFloat)validateCodeSize:(CGFloat)size
{
//    size = MAX( 160, size);
    
//    size = MIN( CGRectGetWidth([[UIScreen mainScreen] bounds])-20, size);
    
    size = MAX( 2048, size);
    size = MIN( 2048, size);
    return size;
}



+ (CIImage *)createQRCodeFromUrl:(NSString *)strUrl
{
    NSData *qrData = [strUrl dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [qrFilter setValue:qrData forKey:@"inputMessage"];
    
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    return [qrFilter outputImage];
}



+ (UIImage *)excludeFuzzyImageFormCIImage:(CIImage *)image size:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN( size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    //创建灰度色调空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate( nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality( bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM( bitmapRef, scale, scale);
    
    CGContextDrawImage( bitmapRef, extent, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    CGColorSpaceRelease(colorSpaceRef);
    
    
    
    return [UIImage imageWithCGImage:scaledImage];
}


+ (UIImage *)imageFillImageBackColor:(UIImage *)image red:(int)red green:(int)green blue:(int)blue
{
    const float width = image.size.width;
    const float height = image.size.height;
    
    
    size_t bytesByRow = width * 4;
    uint32_t *rgbImageBuff = (uint32_t *)malloc(bytesByRow * height);
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef contextRef = CGBitmapContextCreate( rgbImageBuff, width, height, 8, bytesByRow, colorSpaceRef, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage( contextRef, (CGRect){CGPointZero, image.size}, image.CGImage);

    
    //遍历像素
    int pixeINumber = width * height;
    
    [self imageFillWhiteToTransparentOnPixel:rgbImageBuff pixelNum:pixeINumber red:red green:green blue:blue];
    
    CGDataProviderRef dataProviderRef = CGDataProviderCreateWithData( NULL, rgbImageBuff, bytesByRow, ProviderReleaseData);
    
    CGImageRef imageRef = CGImageCreate( width, height, 8, 32, bytesByRow, colorSpaceRef, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProviderRef, NULL, true, kCGRenderingIntentDefault);
    
    UIImage *resultImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGDataProviderRelease(dataProviderRef);
    CGColorSpaceRelease(colorSpaceRef);
    
    
    return resultImage;
}



+ (void)imageFillWhiteToTransparentOnPixel:(uint32_t *)rgbImageBuff pixelNum:(int)pixelNum red:(int)red green:(int)green blue:(int)blue
{
    uint32_t *pCurPtr = rgbImageBuff;
    
    for ( int i = 0; i < pixelNum; ++i,++pCurPtr)
    {
        
        
        if ( (*pCurPtr & 0xffffff00) < 0xd0d0d000)
        {
            uint8_t *ptr = (uint8_t *)pCurPtr;
            ptr[3] = red;
            ptr[2] = green;
            ptr[1] = blue;
        }
        else
        {
            //将白色变成透明色
            uint8_t *ptr = (uint8_t *)pCurPtr;
            ptr[0] = 0;
        }
    }
    
}


void ProviderReleaseData(void * info, const void * data, size_t size) {
    
    free((void *)data);
    
}








#pragma mark -小头像二维码
+ (UIImage *)imageForQRCodeFromUrl:(NSString *)strUrl codeSize:(CGFloat)size red:(float)red green:(float)green blue:(float)blue insertImage:(UIImage *)insertImage cornerRadius:(float)radius
{
    if ( !strUrl || [NSNull null] == (NSNull *)strUrl || [strUrl isEqualToString:@""])
    {
        return nil;
    }
    
    
    size = [self validateCodeSize:size];
    
    CIImage *orginalImage = [self createQRCodeFromUrl:strUrl];
    
    UIImage *progressImage = [self excludeFuzzyImageFormCIImage:orginalImage size:size];
    
    UIImage *effectiveImage = [self imageFillImageBackColor:progressImage red:red green:green blue:blue];
    
    UIImage *roundedRectImage = [self imageInsertedImage:effectiveImage insertImage:insertImage radius:radius];
    
    
    return roundedRectImage;
    
}


+ (UIImage *)imageInsertedImage:(UIImage *)originImage insertImage:(UIImage *)insertImage radius:(float)radius
{
    if ( !insertImage)
    {
        return originImage;
    }
    
    insertImage = [UIImage imageOfRoundRectWithImage:insertImage size:insertImage.size radius:radius];
    
    if (!insertImage) {
        return originImage;
    }
    
    UIImage *whiteMask = [UIImage imageNamed:@"whiteMask"];
    whiteMask = [UIImage imageOfRoundRectWithImage:whiteMask size:whiteMask.size radius:radius];
    
    //白色边缘
    const CGFloat whiteSize = 2.0f;
    
    CGSize brinkSize = CGSizeMake( originImage.size.width/4, originImage.size.height/4);
    
    CGFloat brinkX = ( originImage.size.width - brinkSize.width) /2.0f;
    CGFloat brinkY = ( originImage.size.height - brinkSize.height) / 2.0f;
    
    CGSize sizeImage = CGSizeMake( brinkSize.width-whiteSize*2.0f, brinkSize.height-whiteSize*2.0f);
    
    CGFloat imageX = brinkX + whiteSize;
    CGFloat imageY = brinkY + whiteSize;
    
    
    UIGraphicsBeginImageContext( originImage.size);
    
    [originImage drawInRect:(CGRect){ 0, 0, (originImage.size)}];
    [whiteMask drawInRect:(CGRect){ brinkX, brinkY, (brinkSize)}];
    [insertImage drawInRect:(CGRect){ imageX, imageY, (sizeImage)}];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}











@end




