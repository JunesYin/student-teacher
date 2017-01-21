//
//  GIFLoader.m
//  AnimatedGifExample
//
//  Created by Andrei on 10/15/12.
//  Copyright (c) 2012 Whatevra. All rights reserved.
//

#import "GIFLoader.h"
#import <ImageIO/ImageIO.h>

@implementation GIFLoader

+ (void)loadGIFFrom:(NSString *)url to:(UIImageView *)imageView {
    NSData *gifData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    [self loadGIFData:gifData to:imageView];
}

+ (void)loadGIFData:(NSData *)data to:(UIImageView *)imageView {
    NSMutableArray *frames = nil;
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    CGFloat animationTime = 0.f;
    if (src) {
        size_t l = CGImageSourceGetCount(src);
        frames = [NSMutableArray arrayWithCapacity:l];
        for (size_t i = 0; i < l; i++) {
            CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
//            NSDictionary *properties = (NSDictionary *)CGImageSourceCopyPropertiesAtIndex(src, i, NULL);
            NSDictionary *properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, i, NULL));
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            if (img) {
                [frames addObject:[UIImage imageWithCGImage:img]];
                CGImageRelease(img);
            }
        }   
        CFRelease(src);
    }
    [imageView setImage:[frames objectAtIndex:0]];
    [imageView setAnimationImages:frames];
    [imageView setAnimationDuration:animationTime];
//    [imageView startAnimating];
}


@end
