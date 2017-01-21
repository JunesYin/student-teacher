//
//  LyOrderCenterTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/9.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>



UIKIT_EXTERN CGFloat const octcHeight;

@class LyOrder;
@class LyOrderCenterTableViewCell;


@protocol LyOrderCenterTableViewCellDelegate <NSObject>

@optional
- (void)onClickedCancelByOrderCenterTableViewCell:(LyOrderCenterTableViewCell *)aCell;
- (void)onClickedDeleteByOrderCenterTableViewCell:(LyOrderCenterTableViewCell *)aCell;
//- (void)onClickedRefundByOrderCenterTableViewCell:(LyOrderCenterTableViewCell *)aCell;

- (void)onClickedPayByOrderCenterTableViewCell:(LyOrderCenterTableViewCell *)aCell;
- (void)onClickedReapplyByOrderCenterTableViewCell:(LyOrderCenterTableViewCell *)aCell;
- (void)onClickedConfirmByOrderCenterTableViewCell:(LyOrderCenterTableViewCell *)aCell;
- (void)onClickedEvaluteByOrderCenterTableViewCell:(LyOrderCenterTableViewCell *)aCell;
- (void)onClickedEvaluteAgainByOrderCenterTableViewCell:(LyOrderCenterTableViewCell *)aCell;

@end


@interface LyOrderCenterTableViewCell : UITableViewCell

@property ( retain, nonatomic)                  LyOrder                 *order;

@property ( weak, nonatomic)        id<LyOrderCenterTableViewCellDelegate>      delegate;


@end
