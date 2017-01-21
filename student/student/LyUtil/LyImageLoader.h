//
//  LyImageLoader.h
//  student
//
//  Created by Junes on 2016/11/3.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM( NSInteger, LyImageMode)
{
    LyImageMode_Unknown = 0,
    LyImageMode_PNG,
    LyImageMode_JPG,
};


NS_ASSUME_NONNULL_BEGIN


typedef void(^LyLoadAvatarCompleteHandler)(UIImage * _Nullable image, NSError * _Nullable error, NSString * _Nullable userId);

typedef void(^LyLoadImageCompleteHandler)(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable url);

@interface LyImageLoader : NSObject

+ (void)loadAvatarWithUserId:(nullable NSString *)userId
                    complete:(nullable LyLoadAvatarCompleteHandler)completeHandler;


+ (void)loadAvatarWithUserId:(nullable NSString *)userId
                   imageMode:(LyImageMode)imageMode
                    complete:(nullable LyLoadAvatarCompleteHandler)completeHandler;


+ (void)loadImageWithUrl:(NSURL *)url
                complete:(nullable LyLoadImageCompleteHandler)completeHandler;



@end


NS_ASSUME_NONNULL_END
