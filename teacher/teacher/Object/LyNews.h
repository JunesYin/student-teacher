//
//  LyNews.h
//  teacher
//
//  Created by Junes on 2016/10/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyNews : NSObject

@property (nonatomic, strong)       NSString            *newsId;
@property (nonatomic, strong)       NSString            *newsMasterId;
@property (nonatomic, strong)       NSString            *newsTime;
@property (nonatomic, strong)       NSString            *newsContent;

@property (nonatomic, strong)       NSMutableDictionary *newsPics;
@property (nonatomic, strong)       NSMutableDictionary *newsPicUrls;

@property (nonatomic, assign)       int                 newsTransmitCount;
@property (nonatomic, assign)       int                 newsEvaluationCount;
@property (nonatomic, assign)       int                 newsPraiseCount;

@property (nonatomic, assign, getter=isPraised)    BOOL    praise;

@property (nonatomic, assign)       CGFloat             cellHeight;


+ (instancetype)newsWithId:(NSString *)newsId
                  masterId:(NSString *)masterId
                      time:(NSString *)time
                   content:(NSString *)content
             transmitCount:(int)transmitCount
           evaluationCount:(int)evaluationCount
               praiseCount:(int)praiseCount;


- (instancetype)initWithId:(NSString *)newsId
                  masterId:(NSString *)masterId
                      time:(NSString *)time
                   content:(NSString *)content
             transmitCount:(int)transmitCount
           evaluationCount:(int)evaluationCount
               praiseCount:(int)praiseCount;

- (void)addPic:(UIImage *)image picUrl:(NSString *)picUrl index:(int)index;

- (void)praise;



@end
