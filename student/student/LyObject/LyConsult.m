//
//  LyConsult.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/15.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyConsult.h"

#import "LyReply.h"

#import "LyUtil.h"

@implementation LyConsult

+ (instancetype)consultWithId:(NSString *)oId
                         time:(NSString *)time
                     masterId:(NSString *)masterId
                     objectId:(NSString *)objectId
                      content:(NSString *)content
{
    LyConsult *tmpConsult = [[LyConsult alloc] initWithId:oId
                                                     time:time
                                                 masterId:masterId
                                                 objectId:objectId
                                                  content:content];
    return tmpConsult;
}

- (instancetype)initWithId:(NSString *)oId
                      time:(NSString *)time
                  masterId:(NSString *)masterId
                  objectId:(NSString *)objectId
                   content:(NSString *)content
{
    if ( self = [super init])
    {
        _oId = oId;
        _time = time;
        _masterId = masterId;
        _objectId = objectId;
        _content = content;
    }
    
    
    return self;
}



- (void)addReply:(LyReply *)reply {
    if (!_arrReply) {
        _arrReply = [[NSMutableArray alloc] initWithCapacity:1];
    }
    
    [_arrReply addObject:reply];
    
    
    if ([reply.masterId isEqualToString:_masterId] && [LyUtil compareDateByString:reply.time with:_time]) {
        _time = reply.time;
    }
}


- (void)uniquifyAndSortReply {
    if (!_arrReply || _arrReply.count < 1) {
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    for (LyReply *reply in _arrReply) {
        [dic setObject:reply forKey:reply.oId];
    }
    
    _arrReply = [[NSMutableArray alloc] initWithArray:[dic allValues]];
    
    _arrReply = [LyUtil sortArrByDate:_arrReply andKey:@"time" asc:NO];
}

@end
