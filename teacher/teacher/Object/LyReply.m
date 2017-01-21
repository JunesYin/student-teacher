//
//  LyReply.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/29.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyReply.h"

@implementation LyReply


+ (instancetype)replyWithId:(NSString *)oId
                   masterId:(NSString *)masterId
                   objectId:(NSString *)objectId
                objectingId:(NSString *)objectingId
                    content:(NSString *)content
                       time:(NSString *)time
                 objectRpId:(NSString *)objectRpId
{
    LyReply *reply = [[LyReply alloc] initWithId:oId
                                        masterId:masterId
                                        objectId:objectId
                                     objectingId:objectingId
                                         content:content
                                            time:time
                                      objectRpId:objectRpId];
    
    return reply;
}

- (instancetype)initWithId:(NSString *)oId
                  masterId:(NSString *)masterId
                  objectId:(NSString *)objectId
               objectingId:(NSString *)objectingId
                   content:(NSString *)content
                      time:(NSString *)time
                objectRpId:(NSString *)objectRpId
{
    if ( self = [super init])
    {
        _oId = oId;
        _masterId = masterId;
        _objectId = objectId;
        _objectingId = objectingId;
        _content = content;
        _time = time;
        _rpObjectRpId = objectRpId;
    }
    
    return self;
}




@end
