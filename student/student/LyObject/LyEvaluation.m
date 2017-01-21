//
//  LyEvaluation.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/7.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyEvaluation.h"

@implementation LyEvaluation



+ (instancetype)evaluationWithId:(NSString *)oId
                        content:(NSString *)content
                           time:(NSString *)time
                       masterId:(NSString *)masterId
                       objectId:(NSString *)objectId
                    objectingId:(NSString *)objectingId
{
    LyEvaluation *tmpEva = [[LyEvaluation alloc] initWithId:oId
                                                    content:content
                                                       time:time
                                                   masterId:masterId
                                                   objectId:objectId
                                                objectingId:objectingId];
    
    return tmpEva;
}

- (instancetype)initWithId:(NSString *)oId
                   content:(NSString *)content
                      time:(NSString *)time
                  masterId:(NSString *)masterId
                  objectId:(NSString *)objectId
               objectingId:(NSString *)objectingId
{
    if ( self = [super init])
    {
        _oId       = oId;
        _content  = content;
        _time     = time;
        _masterId = masterId;
        _objectId = objectId;
        _objectingId = objectingId;
    }
    
    return self;
}




+ (instancetype)evaluationWithId:(NSString *)oId
                         content:(NSString *)content
                            time:(NSString *)time
                        masterId:(NSString *)masterId
                        objectId:(NSString *)objectId {
    LyEvaluation *eva = [[LyEvaluation alloc] initWithId:oId
                                                 content:content
                                                    time:time
                                                masterId:masterId
                                                objectId:objectId];
    
    return eva;
}
    
    
- (instancetype)initWithId:(NSString *)oId
                   content:(NSString *)content
                      time:(NSString *)time
                  masterId:(NSString *)masterId
                  objectId:(NSString *)objectId {
    if (self = [super init]) {
        _oId       = oId;
        _content  = content;
        _time     = time;
        _masterId = masterId;
        _objectId = objectId;
    }
    
    return self;
}


@end
