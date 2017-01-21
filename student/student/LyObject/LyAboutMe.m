//
//  LyAboutMe.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyAboutMe.h"

@implementation LyAboutMe



+ (instancetype)aboutMeWithId:(NSString *)amId
                     masterId:(NSString *)masterId
                     objectId:(NSString *)objectId
                     newsId:(NSString *)newsId
                      content:(NSString *)content
                         time:(NSString *)time
                         mode:(LyAboutMeMode)mode
                 amObjectAmId:(NSString *)amObjectAmId
{
    LyAboutMe *aboutMe = [[LyAboutMe alloc] initWithId:amId
                                              masterId:masterId
                                              objectId:objectId
                                              newsId:newsId
                                               content:content
                                                  time:time
                                                  mode:mode
                                          amObjectAmId:amObjectAmId];
    
    return aboutMe;
}


- (instancetype)initWithId:(NSString *)amId
                  masterId:(NSString *)masterId
                  objectId:(NSString *)objectId
                  newsId:(NSString *)newsId
                   content:(NSString *)content
                      time:(NSString *)time
                      mode:(LyAboutMeMode)mode
              amObjectAmId:(NSString *)amObjectAmId
{
    if ( self = [super init])
    {
        _amId = amId;
        _amMasterId = masterId;
        _amObjectId = objectId;
        _amNewsId = newsId;
        _amContent = content;
        _amTime = time;
        _amMode = mode;
        _amobjectAmId = amObjectAmId;
    }
    
    return self;
}


+ (instancetype)aboutMeWithEvaluation:(LyEvaluation *)eva
{
    LyAboutMe *aboutMe = [[LyAboutMe alloc] initWithEvaluation:eva];
    
    return aboutMe;
}

- (instancetype)initWithEvaluation:(LyEvaluation *)eva
{
    if ( self = [super init])
    {
        
    }
    
    return self;
}


@end
