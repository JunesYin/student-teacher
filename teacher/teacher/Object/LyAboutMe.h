//
//  LyAboutMe.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "LyEvaluation.h"

typedef NS_ENUM( NSInteger, LyAboutMeMode)
{
    LyAboutMeMode_praise = 1,
    LyAboutMeMode_transmit,
    LyAboutMeMode_evaluate,
    LyAboutMeMode_reply
};



@interface LyAboutMe : NSObject

@property ( strong, nonatomic)          NSString                *amId;
@property ( strong, nonatomic)          NSString                *amMasterId;
@property ( strong, nonatomic)          NSString                *amObjectId;
@property ( strong, nonatomic)          NSString                *amNewsId;
@property ( strong, nonatomic)          NSString                *amContent;
@property ( strong, nonatomic)          NSString                *amTime;

@property ( assign, nonatomic)          LyAboutMeMode           amMode;
@property ( strong, nonatomic)          NSString                *amobjectAmId;


+ (instancetype)aboutMeWithId:(NSString *)amId
                     masterId:(NSString *)masterId
                     objectId:(NSString *)objectId
                     newsId:(NSString *)newsId
                      content:(NSString *)content
                         time:(NSString *)time
                         mode:(LyAboutMeMode)mode
                 amObjectAmId:(NSString *)amObjectAmId;

- (instancetype)initWithId:(NSString *)amId
                  masterId:(NSString *)masterId
                  objectId:(NSString *)objectId
                  newsId:(NSString *)newsId
                   content:(NSString *)content
                      time:(NSString *)time
                      mode:(LyAboutMeMode)mode
              amObjectAmId:(NSString *)amObjectAmId;

+ (instancetype)aboutMeWithEvaluation:(LyEvaluation *)eva;

- (instancetype)initWithEvaluation:(LyEvaluation *)eva;

@end
