//
//  LyShareManager.m
//  teacher
//
//  Created by Junes on 2016/11/2.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyShareManager.h"

#import "LyRemindView.h"

#import "LyUtil.h"

@implementation LyShareManager

lySingle_implementation(LyShareManager)


+ (void)share:(SSDKPlatformType)platformType
   alertTitle:(NSString *)alertTitle
      content:(NSString *)content
       images:(NSArray *)images
        title:(NSString *)title
          url:(NSURL *)url
viewController:(UIViewController *)viewController
{
    [[LyShareManager sharedInstance] share:platformType
                                alertTitle:alertTitle
                                   content:content
                                    images:images
                                     title:title
                                       url:url
                            viewController:viewController];
}


- (void)share:(SSDKPlatformType)platformType
   alertTitle:(NSString *)alertTitle
      content:(NSString *)content
       images:(NSArray *)images
        title:(NSString *)title
          url:(NSURL *)url
viewController:(UIViewController *)viewController
{
    //分享内容
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupShareParamsByText:content
                                     images:images
                                        url:url
                                      title:title
                                       type:SSDKContentTypeAuto];
    
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle
                                                                   message:content
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                ;
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"分享"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [ShareSDK share:platformType
                                                     parameters:shareParams
                                                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                                                     switch (state) {
                                                         case SSDKResponseStateSuccess: {
                                                             NSLog(@"分享成功");
                                                             if (SSDKPlatformTypeSinaWeibo == platformType) {
                                                                 dispatch_sync(dispatch_get_main_queue(), ^{
                                                                     [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"分享成功"] show];
                                                                 });
                                                             } else {
                                                                 [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"分享成功"] show];
                                                             }
                                                             
                                                             break;
                                                         }
                                                         case SSDKResponseStateFail: {
                                                             NSLog(@"分享失败");
                                                             if (SSDKPlatformTypeSinaWeibo == platformType) {
                                                                 dispatch_sync(dispatch_get_main_queue(), ^{
                                                                     [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"分享失败"] show];
                                                                 });
                                                             } else {
                                                                 [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"分享失败"] show];
                                                             }
                                                             
                                                             break;
                                                         }
                                                         case SSDKResponseStateCancel: {
                                                             NSLog(@"分享取消");
                                                             if (SSDKPlatformTypeSinaWeibo == platformType) {
                                                                 dispatch_sync(dispatch_get_main_queue(), ^{
                                                                     [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"分享取消"] show];
                                                                 });
                                                             } else {
                                                                 [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"分享取消"] show];
                                                             }
                                                             
                                                             break;
                                                         }
                                                         default: {
                                                             //nothing
                                                             break;
                                                         }
                                                     }
                                                 }];
                                            }]];
    
    [viewController presentViewController:alert animated:YES completion:nil];
    
}

@end
