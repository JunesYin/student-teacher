//
//  LyQuestion.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/2.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "LyOption.h"


typedef NS_ENUM( NSInteger, LyQuestionMode)
{
    LyQuestionMode_singleChoice = 0,
    LyQuestionMode_TFNG,
    LyQuestionMode_multiChoice
};


@interface LyQuestion : NSObject

@property ( strong, nonatomic)      NSString            *queId;
@property ( assign, nonatomic)      LyQuestionMode      queMode;
@property ( strong, nonatomic)      NSString            *queContent;
//@property ( strong, nonatomic)      UIImage             *queImage;
@property ( strong, nonatomic)      NSString            *queImgUrl;
//@property ( strong, nonatomic)      NSURL               *queImageUrl NS_DEPRECATED_IOS(2_0, 8_0, "Please use queImgUrl") NS_EXTENSION_UNAVAILABLE_IOS("queImgUrl");
@property ( assign, nonatomic)      NSInteger           queChapterId;
@property ( assign, nonatomic)      NSInteger           queSubjects;

@property ( strong, nonatomic)      NSDictionary        *queOptions;
@property ( strong, nonatomic)      NSString            *queAnwser;

@property (retain, nonatomic)       NSString            *myAnswer;

@property ( strong, nonatomic)      NSString            *queAnalysis;

@property ( assign, nonatomic)      NSInteger           queDegree;


@property (assign, nonatomic)       NSInteger           provinceId;
@property (assign, nonatomic)       NSInteger           bankId;
@property (assign, nonatomic)       NSInteger           mistakeId;


@property ( assign, nonatomic)      NSInteger           index;
@property ( assign, nonatomic)      NSInteger           allTimes;
@property ( assign, nonatomic)      NSInteger           rightTimes;


+ (instancetype)questionWithId:(NSString *)queId
                       queMode:(LyQuestionMode)queMode
                    queContent:(NSString *)queContent
                      queAnser:(NSString *)queAnwser
                   queAnalysis:(NSString *)queAnalysis
                     queDegree:(NSInteger)queDegree;


- (instancetype)initWithId:(NSString *)queId
                   queMode:(LyQuestionMode)queMode
                queContent:(NSString *)queContent
                  queAnser:(NSString *)queAnwser
               queAnalysis:(NSString *)queAnalysis
                 queDegree:(NSInteger)queDegree;

+ (instancetype)questionWithId:(NSString *)queId
                       queMode:(LyQuestionMode)queMode
                    queContent:(NSString *)queContent
                          queA:(NSString *)queA
                          queB:(NSString *)queB
                          queC:(NSString *)queC
                          queD:(NSString *)queD
                     queAnswer:(NSString *)queAnswer
                   queAnalysis:(NSString *)queAnalysis
                     queDegree:(NSInteger)queDegree
                     queImgUrl:(NSString *)queImgUrl;

- (instancetype)initWithId:(NSString *)queId
                   queMode:(LyQuestionMode)queMode
                queContent:(NSString *)queContent
                      queA:(NSString *)queA
                      queB:(NSString *)queB
                      queC:(NSString *)queC
                      queD:(NSString *)queD
                 queAnswer:(NSString *)queAnswer
               queAnalysis:(NSString *)queAnalysis
                 queDegree:(NSInteger)queDegree
                 queImgUrl:(NSString *)queImgUrl;

- (BOOL)judge;


@end
