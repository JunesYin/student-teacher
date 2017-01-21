//
//  LyEvalutionManager.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/7.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LyEvaluation.h"
#import "LySingleInstance.h"


@interface LyEvalutionManager : NSObject

lySingle_interface

- (void)addEvalutionWithEvaId:(LyEvaluation *)eva;

- (NSArray *)getEvalutionForObjectId:(NSString *)objectId;

- (NSArray *)getEvalutionForObjectingId:(NSString *)objectId;

- (LyEvaluation *)getEvalutionWithId:(NSString *)evaId;


@end
