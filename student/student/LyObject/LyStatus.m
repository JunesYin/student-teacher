//
//  LyStatus.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/11.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyStatus.h"
#import "LyUserManager.h"
#import "LyUtil.h"



@implementation LyStatus

+ (instancetype)statusWithStatusId:(NSString *)statusId
                          masterId:(NSString *)masterId
                              time:(NSString *)time
                           content:(NSString *)content
                          picCount:(int)picCount
                       praiseCount:(int)praiseCount
                    evalutionCount:(int)evalutionCount
                     transmitCount:(int)transmitCount
{
    LyStatus *status = [[LyStatus alloc] initWithStatusId:statusId
                                                 masterId:masterId
                                                     time:time
                                                  content:content
                                                 picCount:picCount
                                              praiseCount:praiseCount
                                           evalutionCount:evalutionCount
                                            transmitCount:transmitCount];
    
    return status;
}


- (instancetype)initWithStatusId:(NSString *)statusId
                        masterId:(NSString *)masterId
                            time:(NSString *)time
                         content:(NSString *)content
                        picCount:(int)picCount
                     praiseCount:(int)praiseCount
                  evalutionCount:(int)evalutionCount
                   transmitCount:(int)transmitCount
{
    if ( self = [super init])
    {
        _staId = statusId;
        _staMasterId = masterId;
        _staTime = time;
        _staContent = content;
        _staPicCount = picCount;
        _staPraiseCount = praiseCount;
        _staEvalutionCount = evalutionCount;
        _staTransmitCount = transmitCount;
    }
    
    return self;
}



- (void)setPraise:(BOOL)praise
{
    _praise = praise;
}


- (void)praise
{
    _praise = !_praise;
    
    ( _praise) ? _staPraiseCount++ : _staPraiseCount--;
}


- (void)addPic:(UIImage *)image andBigPicUrl:(NSString *)bigUrl withIndex:(int)index
{
    if ( !pics)
    {
        pics = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    if ( image)
    {
        [pics setObject:image forKey:[[NSString alloc] initWithFormat:@"%d", index]];
    }
    
    if ( !_picUrls)
    {
        _picUrls = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    [_picUrls setObject:bigUrl forKey:[[NSString alloc] initWithFormat:@"%d", index]];
    
    _staPics = [pics copy];
}



- (NSString *)description
{
    NSMutableString *str = [[NSMutableString alloc] initWithCapacity:1];
    
    if (_staContent && [_staContent isKindOfClass:[NSString class]] && [_staContent length] > 0 && [_staContent rangeOfString:@"null"].length < 1)
    {
        [str appendString:_staContent];
    }
    
    for ( int i = 0; i < [_picUrls count]; ++i)
    {
        [str appendString:@"[图]"];
    }
    
    if (!str || str.length < 1)
    {
        [str appendString:@" "];
    }
    
    return [str copy];
}



@end
