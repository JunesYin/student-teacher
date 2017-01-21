//
//  LyOption.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/24.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM( NSInteger, LyOptionMode)
{
    LyOptionMode_A = 1,
    LyOptionMode_B,
    LyOptionMode_C,
    LyOptionMode_D,
};


@interface LyOption : NSObject

@property ( assign, nonatomic)          LyOptionMode        mode;

@property ( strong, nonatomic)          NSString            *content;


+ (instancetype)optionWithMode:(LyOptionMode)mode
                       content:(NSString *)content;

- (instancetype)initWithMode:(LyOptionMode)mode
                     content:(NSString *)content;

@end
