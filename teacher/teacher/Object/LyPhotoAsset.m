//
//  LyPhotoAsset.m
//  teacher
//
//  Created by Junes on 16/8/24.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyPhotoAsset.h"
#import "UIImage+Scale.h"
#import "LyUtil.h"

#import <AssetsLibrary/AssetsLibrary.h>

@implementation LyPhotoAsset

+ (instancetype)assetWithAsset:(ALAsset *)asset
{
    LyPhotoAsset *pAsset = [[LyPhotoAsset alloc] init];
    
    pAsset.thumbnailImage = [UIImage imageWithCGImage:[asset thumbnail]];
    pAsset.fullImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
    
    [pAsset handleImage];
    
    return pAsset;
}


+ (instancetype)assetWithImage:(UIImage *)image
{
    LyPhotoAsset *asset = [[LyPhotoAsset alloc] init];
    
    asset.thumbnailImage = image;
    asset.fullImage = image;
    
    [asset handleImage];
    
    return asset;
}

+ (instancetype)assetWithId:(NSString *)strId smallUrl:(NSURL *)smallUrl bigUrl:(NSURL *)bigUrl
{
    LyPhotoAsset *asset = [[LyPhotoAsset alloc] init];
    
    asset.assetId = strId;
    asset.smallUrl = smallUrl;
    asset.bigUrl = bigUrl;
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(globalQueue, ^{
        asset.thumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:asset.smallUrl]];
        asset.fullImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:asset.bigUrl]];
        
        [asset handleImage];
    });
    
    return asset;
}


+ (instancetype)assetWithUrl:(NSURL *)url isBig:(BOOL)isBig
{
    LyPhotoAsset *asset = [[LyPhotoAsset alloc] init];
    
    if (isBig)
    {
        asset.bigUrl = url;
        asset.smallUrl = url;
    }
    else
    {
        asset.smallUrl = url;
        asset.bigUrl = [NSURL URLWithString:[LyUtil bigPicUrl:url.description]];
    }
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(globalQueue, ^{
        asset.thumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:asset.smallUrl]];
        asset.fullImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:asset.bigUrl]];
        
        [asset handleImage];
    });
    
    return asset;
}


+ (instancetype)assetWithUrl:(NSURL *)url isBig:(BOOL)isBig id:(NSString *)strId
{
    LyPhotoAsset *asset = [[LyPhotoAsset alloc] init];
    
    asset.assetId = strId;
    if (isBig)
    {
        asset.bigUrl = url;
        asset.smallUrl = url;
    }
    else
    {
        asset.smallUrl = url;
        asset.bigUrl = [NSURL URLWithString:[LyUtil bigPicUrl:url.description]];
    }
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(globalQueue, ^{
        asset.thumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:asset.smallUrl]];
        asset.fullImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:asset.bigUrl]];
        
        [asset handleImage];
    });
    
    return asset;
}


- (void)handleImage
{
    dispatch_queue_t globalQueue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(globalQueue, ^{
        

        if (_fullImage)
        {
            
            CGFloat fWidth = _fullImage.size.width;
            CGFloat fHeight = _fullImage.size.height;
            
            CGFloat maxWidth;
            CGFloat maxHeight;
            if (ReachableViaWiFi == [LyUtil currentNetworkStatus])
            {
                maxWidth = maxPicWidth_WiFi;
                maxHeight = maxPicHeight_WiFi;
            }
            else
            {
                maxWidth = maxPicWidth;
                maxHeight = maxPicHeight;
            }
            
            CGFloat timesWidth = fWidth / maxWidth;
            CGFloat timesHeight = fHeight / maxHeight;
            
            if (timesWidth > 1.0f || timesHeight > 1.0f)
            {
                if (timesWidth > timesHeight)
                {
                    _fullImage = [_fullImage scaleToSize:CGSizeMake(maxWidth, fHeight / timesWidth)];
                }
                else
                {
                    _fullImage = [_fullImage scaleToSize:CGSizeMake(fWidth / timesHeight, maxHeight)];
                }
            }
        }
        else
        {
            _fullImage = _thumbnailImage;
        }
    });
}


@end
