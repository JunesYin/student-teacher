//
//  LyApplyModeTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/8.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyUtil.h"

UIKIT_EXTERN CGFloat const amtcHeight;




@class LyTrainClass;


@interface LyApplyModeTableViewCell : UITableViewCell

@property ( strong, nonatomic)                      LyTrainClass                    *trainClass;
@property ( assign, nonatomic)                      LyApplyMode                     mode;


//- (void)setCellInfo:(LyTrainClass *)trainClass withApplyMode:(LyApplyMode)mode;

- (void)setCellInfo:(LyTrainClass *)trainClass withApplyMode:(LyApplyMode)mode andDeposit:(double)deposit;

//- (void)sel

@end
