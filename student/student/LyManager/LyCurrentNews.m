//
//  LyCurrentNews.m
//  LyStudyDrive
//
//  Created by Junes on 16/8/3.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyCurrentNews.h"
#import "LyCurrentUser.h"

@implementation LyCurrentNews

lySingle_implementation(LyCurrentNews)

- (instancetype)init
{
    if (self = [super init])
    {
        [[LyCurrentUser curUser] addObserver:self forKeyPath:@"userId" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"userId"])
    {
        [self clear];
    }
}


- (BOOL)hasNews
{
    if (_newsContent || (_newsPics && _newsPics.count > 0))
    {
        return YES;
    }
    
    return NO;
}

- (void)clear
{
    _newsContent = nil;
    _newsPics = nil;
}

- (void)dealloc
{
    [[LyCurrentUser curUser] removeObserver:self forKeyPath:@"userId"];
}

@end
