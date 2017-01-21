//
//  LyChapter.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/21.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyChapter : NSObject

/**
 *  //我的题库中chapterMode为100+x
 *  //科目四中的题chapterMode为50+x
 */
@property ( assign, nonatomic)          NSInteger               chapterMode;
@property ( copy, nonatomic)            NSString                *chapterName;
@property ( assign, nonatomic)          NSInteger               chapterNum;
@property ( assign, nonatomic)          NSInteger               tid;
@property ( assign, nonatomic)          NSInteger               index;

@property (assign, nonatomic)       NSInteger       provinceId;

+ (instancetype)chapterWithMode:(NSInteger)mode
                    chapterName:(NSString *)name
                     chapterNum:(NSInteger)num
                            tid:(NSInteger)tid
                          index:(NSInteger)index;

- (instancetype)initWithMode:(NSInteger)mode
                 chapterName:(NSString *)name
                  chapterNum:(NSInteger)num
                         tid:(NSInteger)tid
                       index:(NSInteger)index;

@end
