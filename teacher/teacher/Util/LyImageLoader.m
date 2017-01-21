//
//  LyImageLoader.m
//  student
//
//  Created by Junes on 2016/11/3.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyImageLoader.h"
#import "LyUtil.h"




@interface LyImageLoader () <NSURLSessionTaskDelegate>
{
    
}
@end


@implementation LyImageLoader

static const NSTimeInterval timeOut = 600.0f;


+ (void)loadAvatarWithUserId:(nullable NSString *)userId
                    complete:(nullable LyLoadAvatarCompleteHandler)completeHandler
{
    LyImageLoader *loader = [[LyImageLoader alloc] init];
    [loader loadAvatarWithUserId:userId
                        complete:completeHandler];
}


- (void)loadAvatarWithUserId:(nullable NSString *)userId
                complete:(nullable LyLoadAvatarCompleteHandler)completeHandler
{
    if (!userId) {
        NSError *error = [[NSError alloc] initWithDomain:@"100" code:100 userInfo:@{
                                                                                    @"userinfo" : @"userid invalid"
                                                                                    }];
        completeHandler(nil, error, userId);
        return;
    }
    
    [self loadAvatarWithUserId:userId
                     imageMode:LyImageMode_Unknown
                      complete:completeHandler];
}




+ (void)loadAvatarWithUserId:(nullable NSString *)userId
                   imageMode:(LyImageMode)imageMode
                    complete:(nullable LyLoadAvatarCompleteHandler)completeHandler
{
    LyImageLoader *loader = [[LyImageLoader alloc] init];
    [loader loadAvatarWithUserId:userId
                       imageMode:imageMode
                        complete:completeHandler];
}


- (void)loadAvatarWithUserId:(nullable NSString *)userId
                   imageMode:(LyImageMode)imageMode
                    complete:(nullable LyLoadAvatarCompleteHandler)completeHandler
{
    NSURL *url = nil;
    switch (imageMode) {
        case LyImageMode_Unknown: {
            url = [LyUtil getUserAvatarUrlWithUserId:userId];
            [self loadImageWithUrl:url
                          complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable url) {
                              if (image) {
                                  completeHandler(image, error, userId);
                                  
                              } else {
                                  url = [LyUtil getJpgUserAvatarUrlWithUserId:userId];
                                  [self loadImageWithUrl:url
                                                complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable url) {
                                                    completeHandler(image, error, userId);
                                                }];
                                  
                              }
                          }];
            break;
        }
        case LyImageMode_PNG: {
            url = [LyUtil getUserAvatarUrlWithUserId:userId];
            [self loadImageWithUrl:url
                          complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable url) {
                              completeHandler(image, error, userId);
                          }];
            break;
        }
        case LyImageMode_JPG: {
            url = [LyUtil getJpgUserAvatarUrlWithUserId:userId];
            [self loadImageWithUrl:url
                          complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable url) {
                              completeHandler(image, error, userId);
                          }];
            break;
        }
    }
    
}




+ (void)loadImageWithUrl:(NSURL *)url
                complete:(nullable LyLoadImageCompleteHandler)completeHandler
{
    LyImageLoader *loader = [[LyImageLoader alloc] init];
    [loader loadImageWithUrl:url
                    complete:completeHandler];
}


- (void)loadImageWithUrl:(NSURL *)url
                complete:(nullable LyLoadImageCompleteHandler)completeHandler
{
    NSLog(@"loadImageWithUrl: %@", url);
    
    if (!url) {
        NSError *error = [[NSError alloc] initWithDomain:@"100" code:100 userInfo:@{
                                                                                    @"userinfo" : @"invalid url"
                                                                                    }];
        completeHandler(nil, error, url);
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:timeOut];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:nil];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                if (error || !data) {
                                                    completeHandler(nil, error, url);
                                                    
                                                } else {
                                                    UIImage *image = [UIImage imageWithData:data];
                                                    completeHandler(image, nil, url);
                                                    
                                                };
                                            }];
    [task resume];
}






#pragma mark -NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        disposition = NSURLSessionAuthChallengeUseCredential;
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }
    
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
    
}




@end
