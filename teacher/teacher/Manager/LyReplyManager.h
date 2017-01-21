//
//  LyReplyManager.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/29.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LySingleInstance.h"

#import "LyReply.h"


@class LyEvaluation;




@interface LyReplyManager : NSObject

lySingle_interface

- (void)addReply:(LyReply *)reply;

- (LyReply *)getReplyWithId:(NSString *)oId;

- (NSArray *)addtionalReplyWithEvaluation:(LyEvaluation *)eva;

- (NSArray *)addtionalReplyWithReply:(LyReply *)reply;

@end
