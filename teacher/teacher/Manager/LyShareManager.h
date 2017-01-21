//
//  LyShareManager.h
//  teacher
//
//  Created by Junes on 2016/11/2.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "LySingleInstance.h"

//分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>


NS_ASSUME_NONNULL_BEGIN

@interface LyShareManager : NSObject

lySingle_interface

+ (void)share:(SSDKPlatformType)platformType
   alertTitle:(NSString *)alertTitle
      content:(NSString *)content
       images:(NSArray *)images
        title:(NSString *)title
          url:(NSURL *)url
viewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END

