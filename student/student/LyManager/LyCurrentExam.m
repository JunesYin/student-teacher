//
//  LyCurrentExam.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/13.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyCurrentExam.h"

@implementation LyCurrentExam

lySingle_implementation(LyCurrentExam)


- (void)setDicQuestion:(NSDictionary *)dicQuestion
{
    _dicQuestion = dicQuestion;
    
    _index++;
}




@end
