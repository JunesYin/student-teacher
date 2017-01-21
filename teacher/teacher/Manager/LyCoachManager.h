//
//  LyCoachManager.h
//  teacher
//
//  Created by Junes on 16/8/26.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LySingleInstance.h"
#import "LyCoach.h"


@interface LyCoachManager : NSObject
{
    NSMutableDictionary         *container;
}

lySingle_interface


- (void)addCoach:(nullable LyCoach *)coach;

- (void)removeCoach:(nonnull LyCoach *)coach;

- (void)removeCoachWithCoachId:(nonnull NSString *)coachId;

- (nullable NSArray *)getAllCoach;

@end
