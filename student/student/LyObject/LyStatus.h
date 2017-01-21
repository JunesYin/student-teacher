//
//  LyStatus.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/11.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class LyUser;

@interface LyStatus : NSObject
{
    NSMutableDictionary         *pics;
}

@property ( strong, nonatomic)              NSString                *staId;
@property ( strong, nonatomic)              NSString                *staMasterId;
@property ( strong, nonatomic)              NSString                *staTime;
@property ( strong, nonatomic)              NSString                *staContent;
@property ( assign, nonatomic)              int                     staPicCount;

@property ( strong, nonatomic, readonly)    NSDictionary            *staPics;
@property ( strong, nonatomic, readonly)    NSMutableDictionary     *picUrls;

@property ( assign, nonatomic)              int                     staPraiseCount;
@property ( assign, nonatomic)              int                     staEvalutionCount;
@property ( assign, nonatomic)              int                     staTransmitCount;


@property ( assign, nonatomic, getter=isPraised)              BOOL                   praise;


@property ( assign, nonatomic)              CGFloat                 cellHeight;


+ (instancetype)statusWithStatusId:(NSString *)statusId
                          masterId:(NSString *)masterId
                              time:(NSString *)time
                           content:(NSString *)content
                          picCount:(int)picCount
                       praiseCount:(int)praiseCount
                    evalutionCount:(int)evalutionCount
                     transmitCount:(int)transmitCount;


- (instancetype)initWithStatusId:(NSString *)statusId
                        masterId:(NSString *)masterId
                            time:(NSString *)time
                         content:(NSString *)content
                        picCount:(int)picCount
                     praiseCount:(int)praiseCount
                  evalutionCount:(int)evalutionCount
                   transmitCount:(int)transmitCount;


- (void)addPic:(UIImage *)image andBigPicUrl:(NSString *)bigUrl withIndex:(int)index;


- (void)praise;



@end
