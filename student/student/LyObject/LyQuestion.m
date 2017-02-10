//
//  LyQuestion.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/2.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyQuestion.h"
#import "LyUtil.h"

@implementation LyQuestion


+ (instancetype)questionWithId:(NSString *)queId
                       queMode:(LyQuestionMode)queMode
                    queContent:(NSString *)queContent
                      queAnser:(NSString *)queAnwser
                   queAnalysis:(NSString *)queAnalysis
                     queDegree:(NSInteger)queDegree
{
    LyQuestion *question = [[LyQuestion alloc] initWithId:queId
                                                  queMode:queMode
                                               queContent:queContent
                                                 queAnser:queAnwser
                                              queAnalysis:queAnalysis
                                                queDegree:queDegree];
    
    return question;
}



- (instancetype)initWithId:(NSString *)queId
                   queMode:(LyQuestionMode)queMode
                queContent:(NSString *)queContent
                  queAnser:(NSString *)queAnwser
               queAnalysis:(NSString *)queAnalysis
                 queDegree:(NSInteger)queDegree
{
    if ( self = [super init])
    {
        _queId = queId;
        _queMode = queMode;
        _queContent = queContent;
        _queAnwser = queAnwser;
        _queAnalysis = queAnalysis;
        _queDegree = queDegree;
    }
    
    return self;
}

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
                     queImgUrl:(NSString *)queImgUrl
{
    LyQuestion *question = [[LyQuestion alloc] initWithId:queId
                                                  queMode:queMode
                                               queContent:queContent
                                                     queA:queA
                                                     queB:queB
                                                     queC:queC
                                                     queD:queD
                                                queAnswer:queAnswer
                                              queAnalysis:queAnalysis
                                                queDegree:queDegree
                                                queImgUrl:queImgUrl];
    
    return question;
}

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
                 queImgUrl:(NSString *)queImgUrl
{
    if (self = [super init])
    {
        _queId = queId;
        _queMode = queMode;
        _queContent = queContent;
        _queAnalysis = queAnalysis;
        _queDegree = queDegree;
//        _queImgUrl = queImgUrl;
        self.queImgUrl = queImgUrl;
        
        LyOption *optionA = [LyOption optionWithMode:1 content:queA];
        LyOption *optionB = [LyOption optionWithMode:2 content:queB];
        if ([LyUtil validateString:queC] && [LyUtil validateString:queD])
        {
            LyOption *optionC = [LyOption optionWithMode:3 content:queC];
            LyOption *optionD = [LyOption optionWithMode:4 content:queD];
            
            _queOptions = @{
                            @(1) : optionA,
                            @(2) : optionB,
                            @(3) : optionC,
                            @(4) : optionD
                            };
        }
        else
        {
            _queOptions = @{
                            @(1) : optionA,
                            @(2) : optionB
                            };
        }

        
        NSMutableString *tAnswer = [[NSMutableString alloc] initWithCapacity:1];
        queAnswer = [queAnswer lowercaseString];
        for (NSInteger i = 0; i < queAnswer.length; ++i) {
            NSString *si = [queAnswer substringWithRange:NSMakeRange(i, 1)];
            if ([si isEqualToString:@"a"]) {
                [tAnswer appendString:@"1"];
            } else if ([si isEqualToString:@"b"]) {
                [tAnswer appendString:@"2"];
            } else if ([si isEqualToString:@"c"]) {
                [tAnswer appendString:@"3"];
            } else if ([si isEqualToString:@"d"]) {
                [tAnswer appendString:@"4"];
            }
        }
        
        _queAnwser = tAnswer.copy;
    }
    
    return self;
}


- (void)setQueImgUrl:(NSString *)queImgUrl {
    if (!queImgUrl || ![queImgUrl isKindOfClass:[NSString class]] || queImgUrl.length < 1 || [[queImgUrl lowercaseString] rangeOfString:@"null"].length > 0)
    {
        return;
    }
    
    _queImgUrl = queImgUrl;
}


//- (void)setImage:(UIImage *)image andImageUrl:(NSString *)imageUrl
//{
//    if ( image) {
//        _queImage = image;
//    }
//    
//    if (![LyUtil validateString:imageUrl]) {
//        return;
//    }
//    
//    NSString *imageUrl_big = [LyUtil bigPicUrl:imageUrl];
//    imageUrl_big = [imageUrl_big stringByReplacingOccurrencesOfString:@" " withString:@""];
//    
//#ifdef __Ly__HTTPS__FLAG__
//    imageUrl_big = [imageUrl_big stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
//#endif
//    
////    imageUrl_big = [imageUrl_big stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    _queImgUrl = imageUrl_big;
//    _queImageUrl = [NSURL URLWithString:[imageUrl_big stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//}

- (BOOL)judge
{
    BOOL result = NO;
    if (LyQuestionMode_multiChoice == _queMode)
    {
        if (_myAnswer.length != _queAnwser.length)
        {
            result = NO;
        }
        else
        {
            result = YES;
            
            for (int i = 0; i < _queAnwser.length; ++i) {
                NSString *item = [_queAnwser substringWithRange:NSMakeRange(i, 1)];
                if ([_myAnswer rangeOfString:item].length < 1) {
                    result = NO;
                    break;
                }
            }
        }
    }
    else
    {
        if ([_myAnswer isEqualToString:_queAnwser])
        {
            result = YES;
        }
        else
        {
            result = NO;
        }
    }
    
    return result;
}

@end
