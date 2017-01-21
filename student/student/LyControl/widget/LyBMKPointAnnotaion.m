//
//  LyBMKPointAnnotaion.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/27.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyBMKPointAnnotaion.h"

@implementation LyBMKPointAnnotaion

- (instancetype)init
{
    if ( self = [super init])
    {
        NSTimeInterval secondsFrom1970 = [[NSDate date] timeIntervalSince1970];
        int iRandom = arc4random() % 100;
        
        _annoId = [[NSString alloc] initWithFormat:@"%.0f%02d", secondsFrom1970, iRandom];
    }
    
    return self;
}


- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
}


- (void)setSubtitle:(NSString *)subtitle
{
    [super setSubtitle:subtitle];
}

@end
