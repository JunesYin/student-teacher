//
//  LyHttpRequest.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/1.
//  Copyright © 2016年 Junes. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//分界线的标识符
//#define TWITTERFON_FORM_BOUNDARY                        @"AaB03x"
UIKIT_EXTERN NSString *const TWITTERFON_FORM_BOUNDARY;

UIKIT_EXTERN float const LyHttpRequestDefaultTimeOut;
//#define LyHttpRequestDefaultTimeOut                     15.0f



typedef NS_ENUM(NSInteger, LyHttpType)
{
    LyHttpType_synGet,
    LyHttpType_synPost,
    LyHttpType_asynGet,
    LyHttpType_asynPost
};


typedef void(^LyHRCompletionHandler)(NSString *resStr, NSData *resData, NSError *error);

@class LyHttpRequest;


@protocol LyHttpRequestDelegate <NSObject>

@optional
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest;

- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result;

@end

@interface LyHttpRequest : NSObject

@property ( assign, nonatomic)              NSInteger                   mode;

@property ( strong, nonatomic, readonly)    NSURL                       *url;

@property ( strong, nonatomic)              NSString                    *strUrl;

@property ( strong, nonatomic)              NSDictionary                *dicParaments;

@property ( assign, nonatomic)              LyHttpType                  type;

@property ( assign, nonatomic)              float                       timeOut;

@property ( weak, nonatomic)                id<LyHttpRequestDelegate>   delegate;

+ (NSString *)getUserName:(NSString *)userId;

+ (instancetype)httpRequestWithMode:(NSInteger)mode;

- (instancetype)initWithMode:(NSInteger)mode;

- (NSString *)startHttpRequest:(NSString *)strUrl body:(NSDictionary *)dicElements type:(LyHttpType)type timeOut:(NSTimeInterval)timeOut;

+ (void)startHttpRequest:(NSString *)strUrl body:(NSDictionary *)dicElements type:(LyHttpType)type timeOut:(NSTimeInterval)timeOut completionHandler:(LyHRCompletionHandler)completionHandler;

- (void)startHttpRequest:(NSString *)strUrl body:(NSDictionary *)dicElements type:(LyHttpType)type timeOut:(NSTimeInterval)timeOut completionHandler:(LyHRCompletionHandler)completionHandler;

- (BOOL)sendMultiPics:(NSString *)strUrl image:(NSArray *)arrPic body:(NSDictionary *)dicParameters;

+ (BOOL)sendAvatarByHttp:(NSString *)strUrl image:(UIImage *)image body:(NSDictionary *)dicParameters completionHandler:(LyHRCompletionHandler)completionHandler;

- (BOOL)sendAvatarByHttp:(NSString *)strUrl image:(UIImage *)image body:(NSDictionary *)dicParameters;

//教练端上传用户认证资料//学员端不需要
- (BOOL)uploadCertification:(NSString *)strUrl image:(NSArray *)arrPic body:(NSDictionary *)dicParameters userType:(NSInteger)userType;

@end
