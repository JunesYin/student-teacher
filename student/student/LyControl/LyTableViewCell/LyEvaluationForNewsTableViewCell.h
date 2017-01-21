//
//  LyEvaluationForNewsTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/7.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const ecdtcHeight;


@class LyEvaluation;

@interface LyEvaluationForNewsTableViewCell : UITableViewCell

@property ( strong, nonatomic)                      LyEvaluation                             *eva;

@property ( assign, nonatomic)                      NSInteger                               height;


@end
