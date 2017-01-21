//
//  LyCurrentNews.h
//  LyStudyDrive
//
//  Created by Junes on 16/8/3.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LySingleInstance.h"

@interface LyCurrentNews : NSObject

@property (retain, nonatomic, nullable)         NSString            *newsContent;
@property (retain, nonatomic, nullable)         NSMutableArray      *newsPics;

lySingle_interface

- (BOOL)hasNews;

- (void)clear;

@end
