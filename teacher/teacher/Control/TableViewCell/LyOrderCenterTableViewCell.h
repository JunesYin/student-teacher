//
//  LyOrderCenterTableViewCell.h
//  teacher
//
//  Created by Junes on 16/8/15.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const octcellHeight;

//UIKIT_EXTERN CGFloat const octcellHeight_guider;


@class LyOrder;
@protocol LyOrderCenterTableViewCellDelegate;


@interface LyOrderCenterTableViewCell : UITableViewCell

@property (retain, nonatomic)           LyOrder         *order;

@property (weak, nonatomic)             id<LyOrderCenterTableViewCellDelegate>      delegate;

@end


@protocol LyOrderCenterTableViewCellDelegate <NSObject>

@required
- (void)onClickButtonDisptachByOrderCenterTableViewCell:(LyOrderCenterTableViewCell *)aCell;

@end
