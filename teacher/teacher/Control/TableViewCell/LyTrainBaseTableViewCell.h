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
@protocol LyTrainBaseTableViewCellDelegate;


@interface LyTrainBaseTableViewCell : UITableViewCell

@property (weak, nonatomic)             id<LyTrainBaseTableViewCellDelegate>        delegate;

@property ( retain, nonatomic)          LyTrainBase             *trainBase;

@end



@protocol LyTrainBaseTableViewCellDelegate <NSObject>

@optional
- (void)onClickedDeleteByTrainBaseTableViewCell:(LyTrainBaseTableViewCell *)aCell;

@end
