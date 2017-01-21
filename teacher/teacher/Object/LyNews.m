//
//  LyNews.m
//  teacher
//
//  Created by Junes on 2016/10/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyNews.h"
#import "LyUserManager.h"
#import "LyUtil.h"



@implementation LyNews

+ (instancetype)newsWithId:(NSString *)newsId
                  masterId:(NSString *)masterId
                      time:(NSString *)time
                   content:(NSString *)content
             transmitCount:(int)transmitCount
           evaluationCount:(int)evaluationCount
               praiseCount:(int)praiseCount {
    LyNews *news = [[LyNews alloc] initWithId:newsId
                                     masterId:masterId
                                         time:time
                                      content:content
                                transmitCount:transmitCount
                              evaluationCount:evaluationCount
                                  praiseCount:praiseCount];
    
    return news;
}


- (instancetype)initWithId:(NSString *)newsId
                  masterId:(NSString *)masterId
                      time:(NSString *)time
                   content:(NSString *)content
             transmitCount:(int)transmitCount
           evaluationCount:(int)evaluationCount
               praiseCount:(int)praiseCount {
    if (self = [super init]) {
        _newsId = newsId;
        _newsMasterId = masterId;
        _newsTime = time;
        _newsContent = content;
        _newsTransmitCount = transmitCount;
        _newsEvaluationCount = evaluationCount;
        _newsPraiseCount = praiseCount;
    }
    
    return self;
}

- (void)addPic:(UIImage *)image picUrl:(NSString *)picUrl index:(int)index {
    
#ifdef __Ly__HTTPS__FLAG__
    picUrl = [picUrl stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
#endif
    
    if (!_newsPics) {
        _newsPics = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    if (image) {
        [_newsPics setObject:image forKey:@(index)];
    }
    
    if (!_newsPicUrls) {
        _newsPicUrls = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    [_newsPicUrls setObject:picUrl forKey:@(index)];
}

- (void)praise {
    _praise = !_praise;
    
    ( _praise) ? _newsPraiseCount++ : _newsPraiseCount--;
}



- (NSString *)description {
    NSMutableString *str = [[NSMutableString alloc] initWithCapacity:1];
    
    if ([LyUtil validateString:_newsContent]){
        [str appendString:_newsContent];
    }
    
    for ( int i = 0; i < _newsPicUrls.count; ++i) {
        [str appendString:@"[图]"];
    }
    
    if (!str || str.length < 1) {
        [str appendString:@" "];
    }
    
    return [str copy];
}



@end
