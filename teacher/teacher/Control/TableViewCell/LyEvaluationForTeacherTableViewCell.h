//
//  LyEvaluationForTeacherTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/7.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, LyEvaluationForTeacherTableViewCellMode) {
    LyEvaluationForTeacherTableViewCellMode_list,
    LyEvaluationForTeacherTableViewCellMode_detail
    
};


@class LyEvaluationForTeacher;

@interface LyEvaluationForTeacherTableViewCell : UITableViewCell

@property (strong, nonatomic)       LyEvaluationForTeacher      *eva;

@property (assign, nonatomic)       LyEvaluationForTeacherTableViewCellMode      mode;

@property (assign, nonatomic)       CGFloat       height;

@end
