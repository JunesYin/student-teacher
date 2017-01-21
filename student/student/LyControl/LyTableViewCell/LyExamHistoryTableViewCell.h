//
//  LyExamHistoryTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/2.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>




UIKIT_EXTERN CGFloat const ehcellHeight;

@class LyExamHistory;

@interface LyExamHistoryTableViewCell : UITableViewCell

@property ( assign, nonatomic)      NSInteger               index;

@property ( retain, nonatomic)      LyExamHistory           *examHistory;

@end
