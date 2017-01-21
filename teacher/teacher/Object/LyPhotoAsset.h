//
//  LyPhotoAsset.h
//  teacher
//
//  Created by Junes on 16/8/24.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAsset;


NS_ASSUME_NONNULL_BEGIN

@interface LyPhotoAsset : NSObject

@property (assign, nonatomic)       NSInteger           index;

@property (strong, nonatomic)       NSString            *assetId;

@property (strong, nonatomic)       NSURL               *smallUrl;

@property (strong, nonatomic)       NSURL               *bigUrl;

@property (strong, nonatomic)       UIImage             *thumbnailImage;

@property (strong, nonatomic)       UIImage             *fullImage;

+ (instancetype)assetWithAsset:(ALAsset *)asset;

+ (instancetype)assetWithImage:(UIImage *)image;

+ (instancetype)assetWithId:(NSString *)strId smallUrl:(NSURL *)smallUrl bigUrl:(NSURL *)bigUrl;

+ (instancetype)assetWithUrl:(NSURL *)url isBig:(BOOL)isBig;


@end

NS_ASSUME_NONNULL_END

