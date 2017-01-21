//
//  NSString+HantHansTranslate.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/8.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HantHansTranslate)

//简体转繁体
+ (NSString*)big5ToGbk:(NSString*)origString;

//繁体转简体
+ (NSString*)gbkToBig5:(NSString*)origString;

@end
