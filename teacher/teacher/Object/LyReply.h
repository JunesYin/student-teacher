//
//  LyReply.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/29.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM( NSInteger, LyReplyMode)
{
    LyReplyMode_news,
    LyReplyMode_eva,
    LyReplyMode_con
};



@interface LyReply : NSObject

@property ( strong, nonatomic)          NSString            *oId;
@property ( strong, nonatomic)          NSString            *masterId;
@property ( strong, nonatomic)          NSString            *objectId;
@property ( strong, nonatomic)          NSString            *objectingId;
@property ( strong, nonatomic)          NSString            *content;
@property ( strong, nonatomic)          NSString            *time;

@property ( assign, nonatomic)          LyReplyMode         mode;

@property ( strong, nonatomic)          NSString            *rpObjectRpId;


@property (assign, nonatomic)       CGFloat     height;
@property (assign, nonatomic)       CGFloat     height_m;


+ (instancetype)replyWithId:(NSString *)oId
                   masterId:(NSString *)masterId
                   objectId:(NSString *)objectId
                objectingId:(NSString *)objectingId
                    content:(NSString *)content
                       time:(NSString *)time
                 objectRpId:(NSString *)objectRpId;

- (instancetype)initWithId:(NSString *)oId
                  masterId:(NSString *)masterId
                  objectId:(NSString *)objectId
               objectingId:(NSString *)objectingId
                   content:(NSString *)content
                      time:(NSString *)time
                objectRpId:(NSString *)objectRpId;

@end
