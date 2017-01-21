//
//  LyNewsManager.h
//  teacher
//
//  Created by Junes on 2016/10/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LyNews.h"
#import "LySingleInstance.h"

@interface LyNewsManager : NSObject

lySingle_interface

- (void)addNews:(nonnull LyNews *)news;

- (void)deleteNews:(nonnull LyNews *)news;

- (void)deleteNewsWithNewsId:(nonnull NSString *)newsId;

- (nullable NSArray *)getAllNews;

- (nullable LyNews *)getNewsWithNewsId:(nonnull NSString *)newsId;

- (nullable NSArray *)getNewsWithUserId:(nonnull NSString *)userId;

@end
