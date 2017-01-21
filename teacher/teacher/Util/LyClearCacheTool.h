//
//  LyClearCacheTool.h
//  teacher
//
//  Created by Junes on 09/10/2016.
//  Copyright © 2016 517xueche. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define appFilePath     [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#define appFilePath     NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

@interface LyClearCacheTool : NSObject

+ (NSString *)cacheSize:(NSArray *)arrPath;

+ (BOOL)clearCache:(NSArray *)arrPath;

@end
