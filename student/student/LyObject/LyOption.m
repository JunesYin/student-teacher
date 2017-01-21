//
//  LyOption.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/24.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyOption.h"

@implementation LyOption

+ (instancetype)optionWithMode:(LyOptionMode)mode
                       content:(NSString *)content
{
    LyOption *option = [[LyOption alloc] initWithMode:mode
                                              content:content];
    
    return option;
}

- (instancetype)initWithMode:(LyOptionMode)mode
                     content:(NSString *)content
{
    if ( self = [super init])
    {
        _mode = mode;
        _content = content;
    }
    
    
    return self;
}

@end
