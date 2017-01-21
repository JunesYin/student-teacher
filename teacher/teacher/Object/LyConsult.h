//
//  LyConsult.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/15.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LyReply;

@interface LyConsult : NSObject

@property ( strong, nonatomic)                      NSString                            *oId;
@property ( strong, nonatomic)                      NSString                            *time;
@property ( strong, nonatomic)                      NSString                            *masterId;
@property ( strong, nonatomic)                      NSString                            *objectId;
@property ( strong, nonatomic)                      NSString                            *content;

@property (assign, nonatomic)       NSInteger       replyCount;
@property (strong, nonatomic)       NSMutableArray<LyReply *>       *arrReply;

@property (assign, nonatomic)       CGFloat height;


+ (instancetype)consultWithId:(NSString *)oId
                         time:(NSString *)time
                     masterId:(NSString *)masterId
                     objectId:(NSString *)objectId
                      content:(NSString *)content;

- (instancetype)initWithId:(NSString *)oId
                      time:(NSString *)time
                  masterId:(NSString *)masterId
                  objectId:(NSString *)objectId
                   content:(NSString *)content;

- (void)addReply:(LyReply *)reply;

- (void)uniquifyAndSortReply;

@end
