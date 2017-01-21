//
//  LyConsultManager.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/15.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LyConsult.h"
#import "LySingleInstance.h"



@interface LyConsultManager : NSObject

lySingle_interface


- (void)addConsult:(LyConsult *)consult;

//- (NSArray *)getAllConsult;

- (NSArray *)getConsultWithObjectId:(NSString *)objectId;

- (nullable LyConsult *)getConsultWithConId:(NSString *)conId;




@end
