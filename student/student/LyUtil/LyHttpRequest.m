//
//  LyHttpRequest.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/1.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "NSString+Emoji.h"
#import "LyHttpRequest.h"
#import "LyMacro.h"
#import "UIImage+ZLPhotoLib.h"

#import "LyUtil.h"


#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"




NSString *const TWITTERFON_FORM_BOUNDARY =  @"AaB03x";
float const LyHttpRequestDefaultTimeOut = 15.0f;

float const LyHttpRequestGetUserNameTimeOunt = 5.0f;


@interface LyHttpRequest () <NSURLSessionTaskDelegate>
{
    NSMutableData           *receiveData;
}
@end


@implementation LyHttpRequest


+ (NSString *)getUserName:(NSString *)userId
{
    LyHttpRequest *httpRequest = [[LyHttpRequest alloc] initWithMode:0];
    
    return [httpRequest startHttpRequest:getUserName_url
                                    body:@{
                                           userIdKey:userId
                                           }
                                    type:LyHttpType_synPost
                                 timeOut:LyHttpRequestGetUserNameTimeOunt];
}


+ (instancetype)httpRequestWithMode:(NSInteger)mode
{
    LyHttpRequest *httpRequest = [[LyHttpRequest alloc] initWithMode:mode];
    
    return httpRequest;
}

- (instancetype)initWithMode:(NSInteger)mode
{
    if ( self = [super init])
    {
        _mode = mode;
    }
    
    return self;
}

- (NSString *)startHttpRequest:(NSString *)strUrl body:(NSDictionary *)dicElements type:(LyHttpType)type timeOut:(NSTimeInterval)timeOut
{
    NSLog(@"httpRequest start--%@", strUrl);
    switch (type) {
        case LyHttpType_synGet: {
            return [self SynchronousGet:strUrl body:dicElements timeOut:timeOut];
            break;
        }
        case LyHttpType_synPost: {
            return [self SynchronousPost:strUrl body:dicElements timeOut:timeOut];
            break;
        }
        case LyHttpType_asynGet: {
            [self AsynchronousGet:strUrl body:dicElements timeOut:timeOut completionHandler:nil];
            return @"YES";
            break;
        }
        case LyHttpType_asynPost: {
            [self LyHttpType_asynPost:strUrl body:dicElements timeOut:timeOut completionHandler:nil];
            return @"YES";
            break;
        }
        default: {
            return @"NO";
            break;
        }
    }
    
    return @"NO";
}

+ (void)startHttpRequest:(NSString *)strUrl body:(NSDictionary *)dicElements type:(LyHttpType)type timeOut:(NSTimeInterval)timeOut completionHandler:(LyHRCompletionHandler)completionHandler
{
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:strUrl
                    body:dicElements
                    type:type
                 timeOut:timeOut
       completionHandler:completionHandler];
}


- (void)startHttpRequest:(NSString *)strUrl body:(NSDictionary *)dicElements type:(LyHttpType)type timeOut:(NSTimeInterval)timeOut completionHandler:(LyHRCompletionHandler)completionHandler {
    
    NSLog(@"httpRequest start--%@", strUrl);
    
    [self LyHttpType_asynPost:strUrl
                      body:dicElements
                   timeOut:timeOut
         completionHandler:completionHandler];
}


- (NSString *)SynchronousGet:(NSString *)strUrl body:(NSDictionary *)dicElements timeOut:(NSTimeInterval)timeOut
{
    ASIFormDataRequest *reqeust = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:strUrl]];
    for (NSString *itemKey in dicElements) {
        [reqeust setPostValue:[dicElements objectForKey:itemKey] forKey:itemKey];
    }
    
    [reqeust setValidatesSecureCertificate:NO]; //https需要设置
    [reqeust setTimeOutSeconds:timeOut];
    
    [reqeust startSynchronous];
    
    
    NSString *strResponese = [reqeust responseString];
    
    NSLog(@"%@", strResponese);
    
    return strResponese ? strResponese : @"";
    
}



- (NSString *)SynchronousPost:(NSString *)strUrl body:(NSDictionary *)dicElements timeOut:(NSTimeInterval)timeOut
{
    
    ASIFormDataRequest *reqeust = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:strUrl]];
    for (NSString *itemKey in dicElements) {
        [reqeust setPostValue:[dicElements objectForKey:itemKey] forKey:itemKey];
    }
    
    [reqeust setValidatesSecureCertificate:NO]; //https需要设置
    [reqeust setTimeOutSeconds:timeOut];
    
    [reqeust startSynchronous];
    
    
    NSString *strResponese = [reqeust responseString];
    
    NSLog(@"%@", strResponese);
    
    return strResponese ? strResponese : @"";
    
}


- (BOOL)AsynchronousGet:(NSString *)url body:(NSDictionary *)dicElements timeOut:(NSTimeInterval)timeOut completionHandler:(LyHRCompletionHandler)completionHandler
{
    if ( timeOut < 1) {
        timeOut = LyHttpRequestDefaultTimeOut;
    }
    
    NSString *strHttpBody;
    if (![LyUtil validateDictionary:dicElements]){
        strHttpBody = @"";
    } else {
//        strHttpBody = [LyHttpRequest getHttpBody:dicElements];
        strHttpBody = [LyUtil getHttpBody:dicElements];
    }
    
    
    NSURL *ultimateUrl = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@?%@", url, strHttpBody]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:ultimateUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeOut];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task =  [session dataTaskWithRequest:request
                                             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     if (completionHandler) {
                                                         if ( error) {
                                                             completionHandler(nil, nil, error);
                                                         } else {
                                                             NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                             strResult = [strResult stringByReplacingEmojiCheatCodesWithUnicode];
                                                             completionHandler(strResult, data, nil);
                                                         };
                                                     } else {
                                                         if ( error) {
                                                             NSLog(@"connection failed---error=%@", error);
                                                             [_delegate onLyHttpRequestAsynchronousFailed:self];
                                                         } else {
                                                             NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                             strResult = [strResult stringByReplacingEmojiCheatCodesWithUnicode];
                                                             NSLog(@"httpSuccessed--%@", strResult);
                                                             [_delegate onLyHttpRequestAsynchronousSuccessed:self andResult:strResult];
                                                         };
                                                     }
                                                 });
                                             }];
    [task resume];
    
    return YES;
}


- (BOOL)LyHttpType_asynPost:(NSString *)url body:(NSDictionary *)dicElements timeOut:(NSTimeInterval)timeOut completionHandler:(LyHRCompletionHandler)completionHandler
{
    if ( timeOut < 1) {
        timeOut = LyHttpRequestDefaultTimeOut;
    }
    
    NSString *strHttpBody;
    if (![LyUtil validateDictionary:dicElements]){
        strHttpBody = @"";
    }
    else{
        strHttpBody = [LyUtil getHttpBody:dicElements];
    }
    
    NSData *dataSour = [strHttpBody dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *requestUrl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeOut];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataSour];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                           delegate:self
                                                      delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     if (completionHandler) {
                                                         if ( error) {
                                                             NSLog(@"connection failed---error=%@", error);
                                                             completionHandler(nil, nil, error);
                                                         } else {
                                                             NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                             strResult = [strResult stringByReplacingEmojiCheatCodesWithUnicode];
                                                             NSLog(@"httpSuccessed--%@", strResult);
                                                             completionHandler(strResult, data, nil);
                                                         };
                                                     } else {
                                                         if ( error) {
                                                             NSLog(@"connection failed---error=%@", error);
                                                             [_delegate onLyHttpRequestAsynchronousFailed:self];
                                                         } else {
                                                             NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                             strResult = [strResult stringByReplacingEmojiCheatCodesWithUnicode];
                                                             NSLog(@"httpSuccessed--%@", strResult);
                                                             [_delegate onLyHttpRequestAsynchronousSuccessed:self andResult:strResult];
                                                         };
                                                     }
                                                 });
                                                                     
                                             }];
    [task resume];
    
    return YES;
}



- (BOOL)sendMultiPics:(NSString *)strUrl image:(NSArray *)arrPic body:(NSDictionary *)dicParameters
{
    if (![LyUtil validateString:strUrl] || ![NSURL URLWithString:strUrl]) {
        return NO;
    }
    
    NSURL *requestUrl = [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
    
    //分界线 --AaB03x
    NSString *MPboundary = [[NSString alloc] initWithFormat:@"--%@", TWITTERFON_FORM_BOUNDARY];
    
    //结束符 AaB03x--
    NSString *endMPboundary = [[NSString alloc] initWithFormat:@"%@--", MPboundary];
    
    NSString *end = @"\r\n";
    
    
    
    
    NSMutableString *strHttpBodyTmp = [[NSMutableString alloc] initWithString:@""];
    NSEnumerator *enumerator = [dicParameters keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject]) {
        NSString *strValue = [[NSString alloc] initWithFormat:@"%@", [dicParameters objectForKey:itemKey]];
        strValue = [strValue stringByReplacingOccurrencesOfString:@"\"" withString:@"”"];
        strValue = [strValue stringByReplacingOccurrencesOfString:@"(" withString:@"（"];
        strValue = [strValue stringByReplacingOccurrencesOfString:@")" withString:@"）"];
        
        //添加分界线，换行
        [strHttpBodyTmp appendFormat:@"%@\r\n", MPboundary];
        //添加字段名称，换2行
        [strHttpBodyTmp appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", itemKey];
        //添加字段的值
        [strHttpBodyTmp appendFormat:@"%@\r\n", strValue];
    }
    
//    NSLog(@"multiPicHttp-%@", strHttpBody);
    
    NSString *strHttpBody = [strHttpBodyTmp stringByReplacingEmojiUnicodeWithCheatCodes];
    
    
    ////添加分界线，换行
    //    [strHttpBody appendFormat:@"%@\r\n", MPboundary];
    //    //声明pic字段，文件名为boris.png
    //    //    [strHttpBody appendFormat:@"Content-Disposition: form-data; name=\"ImageField\"; filename=\"%@.png\"\r\n", [dicParameters objectForKey:accountKey]];
    //    [strHttpBody appendFormat:@"Content-Disposition: form-data; name=\"ImageField\"; filename=\"boris.png\"\r\n"];
    //    //声明上传文件的格式
    //    [strHttpBody appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    NSMutableData *dataPic = [[NSMutableData alloc] initWithCapacity:1];
    
    UIImage *image;
    NSData *data;
    for ( int i = 0; i < [arrPic count]; ++i) {
        image = [arrPic objectAtIndex:i];
        
//        NSData *data = UIImagePNGRepresentation(image);
        data = UIImageJPEGRepresentation(image, 1.0f);
        
        [dataPic appendData:[[[NSString alloc] initWithFormat:@"%@\r\n", MPboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
//        NSString *fileTitle = [[NSString alloc] initWithFormat:@"Content-Disposition: form-data; name=\"file%d\"; filename=\"file%d.png\"\r\nContent-Type: application/octet-stream\r\n\r\n", i, i];
        NSString *fileTitle = [[NSString alloc] initWithFormat:@"Content-Disposition: form-data; name=\"file%d\"; filename=\"file%d.jpg\"\r\nContent-Type: application/octet-stream\r\n\r\n", i, i];
        
        [dataPic appendData:[fileTitle dataUsingEncoding:NSUTF8StringEncoding]];
        [dataPic appendData:data];
        [dataPic appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    //声明结束符：--AaB03x--
    NSString *endddd=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[[NSMutableData alloc] initWithCapacity:1];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[strHttpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (arrPic.count > 0) {
        //将image的data加入
        [myRequestData appendData:dataPic];
        //加入结束符--AaB03x--
        [myRequestData appendData:[endddd dataUsingEncoding:NSUTF8StringEncoding]];
    } else {
        //加入结束符--AaB03x--
        [myRequestData appendData:[endMPboundary dataUsingEncoding:NSUTF8StringEncoding]];
    }
    /*
     如果没有图，直接跟结束符
     */
    
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc] initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[[NSString alloc] initWithFormat:@"%lu", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    NSLog(@"请求长度-- %lu bytes", myRequestData.length);
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                     
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     if ( error)
                                                     {
                                                         NSLog(@"connection failed---error=%@", error);
                                                         [_delegate onLyHttpRequestAsynchronousFailed:self];
                                                     }
                                                     else
                                                     {
                                                         NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                         strResult = [strResult stringByReplacingEmojiCheatCodesWithUnicode];
                                                         NSLog(@"httpSuccessed--%@", strResult);
                                                         [_delegate onLyHttpRequestAsynchronousSuccessed:self andResult:strResult];
                                                     };
                                                 });
                                                                     
                                             }];
    [task resume];
    
    return YES;
}


- (BOOL)sendAvatarByHttp:(NSString *)strUrl image:(UIImage *)image body:(NSDictionary *)dicParameters
{
    if (![LyUtil validateString:strUrl] || ![NSURL URLWithString:strUrl] || !image) {
        return NO;
    }
    
    NSURL *requestUrl = [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:LyHttpRequestDefaultTimeOut];
    
    //分界线 --AaB03x
    NSString *MPboundary = [[NSString alloc] initWithFormat:@"--%@", TWITTERFON_FORM_BOUNDARY];
    
    //结束符 AaB03x--
    NSString *endMPboundary = [[NSString alloc] initWithFormat:@"%@--", MPboundary];
    
    
    if ( image.size.width > avatarSizeMax) {
        image = [image scaleToSize:CGSizeMake(avatarSizeMax, avatarSizeMax)];
    }
    
    NSString *imageMode = [dicParameters objectForKey:pathKey];
    if (![LyUtil validateString:imageMode]) {
        imageMode = pngKey;
    }
    
    //得到图片的data
    NSData *dataImage = nil;
    if ([imageMode isEqualToString:pngKey]) {
        dataImage = UIImagePNGRepresentation(image);
    } else {
        dataImage = UIImageJPEGRepresentation(image, 1);
    }
    
    
    NSMutableString *strHttpBodyTmp = [[NSMutableString alloc] initWithString:@""];
    NSEnumerator *enumerator = [dicParameters keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject]) {
        if ( ![itemKey isEqualToString:@"img"]) {
            NSString *strValue = [[NSString alloc] initWithFormat:@"%@", [dicParameters objectForKey:itemKey]];
            strValue = [strValue stringByReplacingOccurrencesOfString:@"\"" withString:@"”"];
            strValue = [strValue stringByReplacingOccurrencesOfString:@"(" withString:@"（"];
            strValue = [strValue stringByReplacingOccurrencesOfString:@")" withString:@"）"];
            
            //添加分界线，换行
            [strHttpBodyTmp appendFormat:@"%@\r\n", MPboundary];
            //添加字段名称，换2行
            [strHttpBodyTmp appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", itemKey];
            //添加字段的值
            [strHttpBodyTmp appendFormat:@"%@\r\n", strValue];
        }
    }
    
    ////添加分界线，换行
    [strHttpBodyTmp appendFormat:@"%@\r\n", MPboundary];
    //声明pic字段，文件名为boris.png
    //    [strHttpBody appendFormat:@"Content-Disposition: form-data; name=\"ImageField\"; filename=\"%@.png\"\r\n", [dicParameters objectForKey:accountKey]];
    [strHttpBodyTmp appendFormat:@"Content-Disposition: form-data; name=\"ImageField\"; filename=\"boris.%@\"\r\n", imageMode];
    //声明上传文件的格式
    [strHttpBodyTmp appendFormat:@"Content-Type: image/%@\r\n\r\n", imageMode];
    
//    NSString *strHttpBody = [strHttpBodyTmp stringByReplacingEmojiUnicodeWithCheatCodes];
    
    NSString *strHttpBody = [strHttpBodyTmp copy];
    NSLog(@"httpBody=%@", strHttpBody);
    
    
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[[NSMutableData alloc] initWithCapacity:1];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[strHttpBody dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:dataImage];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc] initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[[NSString alloc] initWithFormat:@"%lu", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                           delegate:self
                                                      delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                     
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    if ( error) {
                                                        NSLog(@"connection failed---error=%@", error);
                                                        [_delegate onLyHttpRequestAsynchronousFailed:self];
                                                    } else {
                                                        NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        strResult = [strResult stringByReplacingEmojiCheatCodesWithUnicode];
                                                        NSLog(@"httpSuccessed--%@", strResult);
                                                        [_delegate onLyHttpRequestAsynchronousSuccessed:self andResult:strResult];
                                                    };
                                                });
                                                                     
                                            }];
    [task resume];
    
    return YES;
}



+ (BOOL)sendAvatarByHttp:(NSString *)strUrl image:(UIImage *)image body:(NSDictionary *)dicParameters completionHandler:(LyHRCompletionHandler)completionHandler
{
    LyHttpRequest *hr = [LyHttpRequest new];
    return [hr sendAvatarByHttp:strUrl image:image body:dicParameters completionHandler:completionHandler];
}


- (BOOL)sendAvatarByHttp:(NSString *)strUrl image:(UIImage *)image body:(NSDictionary *)dicParameters completionHandler:(LyHRCompletionHandler)completionHandler
{
    if (![LyUtil validateString:strUrl] || ![NSURL URLWithString:strUrl] || !image) {
        return NO;
    }
    
    NSURL *requestUrl = [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:LyHttpRequestDefaultTimeOut];
    
    //分界线 --AaB03x
    NSString *MPboundary = [[NSString alloc] initWithFormat:@"--%@", TWITTERFON_FORM_BOUNDARY];
    
    //结束符 AaB03x--
    NSString *endMPboundary = [[NSString alloc] initWithFormat:@"%@--", MPboundary];
    
    
    if ( image.size.width > avatarSizeMax) {
        image = [image scaleToSize:CGSizeMake(avatarSizeMax, avatarSizeMax)];
    }
    
    NSString *imageMode = [dicParameters objectForKey:pathKey];
    if (![LyUtil validateString:imageMode]) {
        imageMode = pngKey;
    }
    
    //得到图片的data
    NSData *dataImage = nil;
    if ([imageMode isEqualToString:pngKey]) {
        dataImage = UIImagePNGRepresentation(image);
    } else {
        dataImage = UIImageJPEGRepresentation(image, 1);
    }
    
    
    NSMutableString *strHttpBodyTmp = [[NSMutableString alloc] initWithString:@""];
    NSEnumerator *enumerator = [dicParameters keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject]) {
        if ( ![itemKey isEqualToString:@"img"]) {
            NSString *strValue = [[NSString alloc] initWithFormat:@"%@", [dicParameters objectForKey:itemKey]];
            strValue = [strValue stringByReplacingOccurrencesOfString:@"\"" withString:@"”"];
            strValue = [strValue stringByReplacingOccurrencesOfString:@"(" withString:@"（"];
            strValue = [strValue stringByReplacingOccurrencesOfString:@")" withString:@"）"];
            
            //添加分界线，换行
            [strHttpBodyTmp appendFormat:@"%@\r\n", MPboundary];
            //添加字段名称，换2行
            [strHttpBodyTmp appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", itemKey];
            //添加字段的值
            [strHttpBodyTmp appendFormat:@"%@\r\n", strValue];
        }
    }
    
    ////添加分界线，换行
    [strHttpBodyTmp appendFormat:@"%@\r\n", MPboundary];
    //声明pic字段，文件名为boris.png
    //    [strHttpBody appendFormat:@"Content-Disposition: form-data; name=\"ImageField\"; filename=\"%@.png\"\r\n", [dicParameters objectForKey:accountKey]];
    [strHttpBodyTmp appendFormat:@"Content-Disposition: form-data; name=\"ImageField\"; filename=\"boris.%@\"\r\n", imageMode];
    //声明上传文件的格式
    [strHttpBodyTmp appendFormat:@"Content-Type: image/%@\r\n\r\n", imageMode];
    
    //    NSString *strHttpBody = [strHttpBodyTmp stringByReplacingEmojiUnicodeWithCheatCodes];
    
    NSString *strHttpBody = [strHttpBodyTmp copy];
    NSLog(@"httpBody=%@", strHttpBody);
    
    
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[[NSMutableData alloc] initWithCapacity:1];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[strHttpBody dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:dataImage];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc] initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[[NSString alloc] initWithFormat:@"%lu", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    if ( error) {
                                                        
                                                        NSLog(@"connection failed---error=%@", error);
                                                        
                                                        if (completionHandler) {
                                                            completionHandler(nil, nil, error);
                                                        } else {
                                                            [_delegate onLyHttpRequestAsynchronousFailed:self];
                                                        }
                                                        
                                                    } else {
                                                        NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        strResult = [strResult stringByReplacingEmojiCheatCodesWithUnicode];
                                                        NSLog(@"httpSuccessed--%@", strResult);
                                                        
                                                        if (completionHandler) {
                                                            completionHandler(strResult, data, nil);
                                                        } else {
                                                            [_delegate onLyHttpRequestAsynchronousSuccessed:self andResult:strResult];
                                                        }
                                                        
                                                    };
                                                });
                                                
                                            }];
    [task resume];
    
    return YES;
}





//教练端上传用户认证资料//学员端不需要
- (BOOL)uploadCertification:(NSString *)strUrl image:(NSArray *)arrPic body:(NSDictionary *)dicParameters userType:(NSInteger)userType
{
    if (![LyUtil validateString:strUrl] || ![NSURL URLWithString:strUrl]) {
        return NO;
    }
    
    NSURL *requestUrl = [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
    
    //分界线 --AaB03x
    NSString *MPboundary = [[NSString alloc] initWithFormat:@"--%@", TWITTERFON_FORM_BOUNDARY];
    
    //结束符 AaB03x--
    NSString *endMPboundary = [[NSString alloc] initWithFormat:@"%@--", MPboundary];
    
    NSString *end = @"\r\n";
    
    
    NSMutableString *strHttpBodyTmp = [[NSMutableString alloc] initWithString:@""];
    NSEnumerator *enumerator = [dicParameters keyEnumerator];
    NSString *itemKey;
    while ( itemKey = [enumerator nextObject]) {
        NSString *strValue = [[NSString alloc] initWithFormat:@"%@", [dicParameters objectForKey:itemKey]];
        strValue = [strValue stringByReplacingOccurrencesOfString:@"\"" withString:@"”"];
        strValue = [strValue stringByReplacingOccurrencesOfString:@"(" withString:@"（"];
        strValue = [strValue stringByReplacingOccurrencesOfString:@")" withString:@"）"];
        
        //添加分界线，换行
        [strHttpBodyTmp appendFormat:@"%@\r\n", MPboundary];
        //添加字段名称，换2行
        [strHttpBodyTmp appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", itemKey];
        //添加字段的值
        [strHttpBodyTmp appendFormat:@"%@\r\n", strValue];
    }
    
    //    NSLog(@"multiPicHttp-%@", strHttpBody);
    
    NSString *strHttpBody = [strHttpBodyTmp stringByReplacingEmojiUnicodeWithCheatCodes];
    
    
    ////添加分界线，换行
    //    [strHttpBody appendFormat:@"%@\r\n", MPboundary];
    //    //声明pic字段，文件名为boris.png
    //    //    [strHttpBody appendFormat:@"Content-Disposition: form-data; name=\"ImageField\"; filename=\"%@.png\"\r\n", [dicParameters objectForKey:accountKey]];
    //    [strHttpBody appendFormat:@"Content-Disposition: form-data; name=\"ImageField\"; filename=\"boris.png\"\r\n"];
    //    //声明上传文件的格式
    //    [strHttpBody appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    NSMutableData *dataPic = [[NSMutableData alloc] initWithCapacity:1];
    
    UIImage *image;
    NSData *data;
    NSString *name;
    for ( int i = 0; i < [arrPic count]; ++i) {
        image = [arrPic objectAtIndex:i];
        
        //        NSData *data = UIImagePNGRepresentation(image);
        data = UIImageJPEGRepresentation(image, 1.0f);
        
        [dataPic appendData:[[[NSString alloc] initWithFormat:@"%@\r\n", MPboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //        NSString *fileTitle = [[NSString alloc] initWithFormat:@"Content-Disposition: form-data; name=\"file%d\"; filename=\"file%d.png\"\r\nContent-Type: application/octet-stream\r\n\r\n", i, i];
        
        LyUserType userType__ = (LyUserType)userType;
        switch (userType__) {
            case LyUserType_normal: {
                //nothing
                break;
            }
            case LyUserType_coach: {
                switch (i) {
                    case 0: {
                        name = @"jlz";
                        break;
                    }
                    case 1: {
                        name = @"jsz";
                        break;
                    }
                    case 2: {
                        name = @"sfz";
                    }
                    default: {
                        name = @"";
                        break;
                    }
                }
                break;
            }
            case LyUserType_school: {
                switch (i) {
                    case 0: {
                        name = @"yyzz";
                        break;
                    }
                    default: {
                        name = @"";
                        break;
                    }
                }
                break;
            }
            case LyUserType_guider: {
                switch (i) {
                    case 0: {
                        name = @"jsz";
                        break;
                    }
                    case 1: {
                        name = @"sfz";
                        break;
                    }
                    default: {
                        name = @"";
                        break;
                    }
                }
                break;
            }
        }
        NSString *fileTitle = [[NSString alloc] initWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\nContent-Type: application/octet-stream\r\n\r\n", name, name];
        
        [dataPic appendData:[fileTitle dataUsingEncoding:NSUTF8StringEncoding]];
        [dataPic appendData:data];
        [dataPic appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    //声明结束符：--AaB03x--
    NSString *endddd=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[[NSMutableData alloc] initWithCapacity:1];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[strHttpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (arrPic.count > 0) {
        //将image的data加入
        [myRequestData appendData:dataPic];
        //加入结束符--AaB03x--
        [myRequestData appendData:[endddd dataUsingEncoding:NSUTF8StringEncoding]];
    } else {
        //加入结束符--AaB03x--
        [myRequestData appendData:[endMPboundary dataUsingEncoding:NSUTF8StringEncoding]];
    }
    /*
     如果没有图，直接跟结束符
     */
    
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc] initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[[NSString alloc] initWithFormat:@"%lu", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    NSLog(@"请求长度-- %lu bytes", myRequestData.length);
    
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    if ( error) {
                                                        NSLog(@"connection failed---error=%@", error);
                                                        [_delegate onLyHttpRequestAsynchronousFailed:self];
                                                    } else {
                                                        NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        strResult = [strResult stringByReplacingEmojiCheatCodesWithUnicode];
                                                        NSLog(@"httpSuccessed--%@", strResult);
                                                        [_delegate onLyHttpRequestAsynchronousSuccessed:self andResult:strResult];
                                                    };
                                                });
                                                                     
                                            }];
    
    [task resume];
    
    return YES;
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




#pragma mark -NSURLSessionDelegate





@end
