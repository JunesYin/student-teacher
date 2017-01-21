//
//  LyDateTimeInfoManager.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/20.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LyDateTimeInfo.h"
#import "LySingleInstance.h"

@interface LyDateTimeInfoManager : NSObject

lySingle_interface

- (void)addDateTimeInfo:(LyDateTimeInfo *)dateTimeInfo;

- (NSDictionary *)getDateTimeInfoWithObjectId:(NSString *)objectId;

- (LyDateTimeInfo *)getDateTimeInfoWithId:(NSString *)dateTimeInfoId;


@end
