//
//  LyEvaluationForTeacherManager.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/7.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LyEvaluationForTeacher.h"
#import "LySingleInstance.h"



@interface LyEvaluationForTeacherManager : NSObject

lySingle_interface


- (void)addEvalution:(LyEvaluationForTeacher *)eva;

- (NSArray *)getEvalutionWithChDsId:(NSString *)chdsId;

- (LyEvaluationForTeacher *)getEvaluatoinWithEvaId:(NSString *)evaId;


@end

