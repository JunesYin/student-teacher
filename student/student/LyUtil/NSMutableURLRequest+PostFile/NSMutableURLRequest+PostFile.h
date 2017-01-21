//
//  NSMutableURLRequest+PostFile.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/3.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (PostFile)

+(instancetype)requestWithURL:(NSURL *)url andFilenName:(NSString *)fileName andLocalFilePath:(NSString *)localFilePath;

+ (instancetype)requestWithURL:(NSURL *)url andImage:(UIImage *)image;

@end
