//
//  LyDistrict.m
//  teacher
//
//  Created by Junes on 16/9/1.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyDistrict.h"
#import "NSMutableArray+SingleElement.h"
#import "LyLandMark.h"
#import "LyUtil.h"

@implementation LyDistrict

+ (instancetype)distirctWithId:(NSString *)dId name:(NSString *)name
{
    LyDistrict *district = [[LyDistrict alloc] initWithId:dId
                                                     name:name];
    
    return district;
}


- (instancetype)initWithId:(NSString *)dId name:(NSString *)name
{
    if (self = [super init]) {
        _dId = dId;
        _dName = name;
        
        _dArrLandMark = [NSMutableArray arrayWithCapacity:1];
    }
 
    return self;
}


- (void)addLandMark:(LyLandMark *)landMark {
    [_dArrLandMark addObject:landMark];
    [self singleElementAndSort];
}

- (void)addLandMarksFromArray:(NSArray *)arrLandMark {
    [_dArrLandMark addObjectsFromArray:arrLandMark];
    
    [self singleElementAndSort];
}

- (void)removeLandMark:(LyLandMark *)landMark
{
    [_dArrLandMark removeObject:landMark];
}

- (void)removeLandMarkById:(NSString *)lId
{
    for (LyLandMark *lm in _dArrLandMark) {
        if ([lm.lmId isEqualToString:lId])
        {
            [_dArrLandMark removeObject:lm];
            break;
        }
    }
}

- (void)removelandMarkByName:(NSString *)lName
{
    for (LyLandMark *lm in _dArrLandMark) {
        if ([lm.lmName isEqualToString:lName])
        {
            [_dArrLandMark removeObject:lm];
            break;
        }
    }
}



- (void)singleElementAndSort {
    
    [_dArrLandMark singleElementByKey:@"lmId"];
    [_dArrLandMark sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {

        return [[LyUtil getPinyinFromHanzi:[obj1 lmName]] compare:[LyUtil getPinyinFromHanzi:[obj2 lmName]]];
    }];
}



@end
