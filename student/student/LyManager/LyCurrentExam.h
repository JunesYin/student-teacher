//
//  LyCurrentExam.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/13.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LySingleInstance.h"


@interface LyCurrentExam : NSObject

@property ( assign, nonatomic)          NSInteger               index;

@property ( strong, nonatomic)          NSDictionary            *dicQuestion;
@property ( strong, nonatomic)          NSDictionary            *dicMyAnswer;
@property ( strong, nonatomic)          NSDictionary            *dicRightOrWrong;

@property ( assign, nonatomic)          NSInteger               score;
@property ( assign, nonatomic)          NSInteger               timeConsume;


lySingle_interface


@end
