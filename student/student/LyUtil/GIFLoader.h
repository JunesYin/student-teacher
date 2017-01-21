//
//  GIFLoader.h
//  AnimatedGifExample
//
//  Created by Andrei on 10/15/12.
//  Copyright (c) 2012 Whatevra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIFLoader : NSObject

+ (void)loadGIFFrom:(NSString *)url to:(UIImageView *)imageView;
+ (void)loadGIFData:(NSData *)data to:(UIImageView *)imageView;

@end
