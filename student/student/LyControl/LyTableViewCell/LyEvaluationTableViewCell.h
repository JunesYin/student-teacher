//
//  LyEvaluationTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/7.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>




@class LyEvaluation;

@interface LyEvaluationTableViewCell : UITableViewCell

@property ( retain, nonatomic)                  LyEvaluation                 *evalution;

@property ( assign, nonatomic)                  float                       height;


@end
