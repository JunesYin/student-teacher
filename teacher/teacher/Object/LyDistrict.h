//
//  LyDistrict.h
//  teacher
//
//  Created by Junes on 16/9/1.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LyLandMark.h"

@interface LyDistrict : NSObject

@property (retain, nonatomic)       NSString        *dId;

@property (retain, nonatomic)       NSString        *dName;

@property (retain, nonatomic)       NSMutableArray  *dArrLandMark;

@property (retain, nonatomic)       NSString        *cityName;


+ (instancetype)distirctWithId:(NSString *)dId
                          name:(NSString *)name;

- (instancetype)initWithId:(NSString *)dId
                      name:(NSString *)name;

- (void)addLandMark:(LyLandMark *)landMark;

- (void)addLandMarksFromArray:(NSArray *)arrLandMark;

- (void)removeLandMark:(LyLandMark *)landMark;

- (void)removeLandMarkById:(NSString *)lId;

- (void)removelandMarkByName:(NSString *)lName;

@end
