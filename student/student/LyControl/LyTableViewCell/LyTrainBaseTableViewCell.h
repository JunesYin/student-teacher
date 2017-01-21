//
//  LyTrainBaseTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/17.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>



UIKIT_EXTERN CGFloat const tbcellHeight;



@class LyTrainBase;

@interface LyTrainBaseTableViewCell : UITableViewCell

@property ( retain, nonatomic)          LyTrainBase             *trainBase;

@end
