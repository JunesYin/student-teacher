//
//  LyStatusTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/16.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM( NSInteger, LyStatusTableViewCellMode)
{
    LyStatusTableViewCellMode_community,
    LyStatusTableViewCellMode_statusDetail,
};

@class LyStatus;
@protocol LyStatusTableViewCellDelegate;


@interface LyStatusTableViewCell : UITableViewCell

@property ( assign, nonatomic)                  LyStatusTableViewCellMode           mode;

@property ( retain, nonatomic)                  LyStatus                            *status;
@property ( assign, nonatomic)                  CGFloat                             stcHeight;

@property ( weak, nonatomic)                    id<LyStatusTableViewCellDelegate>   delegate;



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setStatus:(LyStatus *)status andMode:(LyStatusTableViewCellMode)mode;

- (void)loadImage;

@end



@protocol LyStatusTableViewCellDelegate <NSObject>

@optional
- (void)onClickedForUserByStatusTableViewCell:(LyStatusTableViewCell *)aCell;

- (void)onClickedForDetailByStatusTableViewCell:(LyStatusTableViewCell *)aCell;

- (void)onClickedForBtnDelete:(LyStatusTableViewCell *)aCell;

- (void)onClickForBtnPraise:(LyStatusTableViewCell *)statusCell;

- (void)onClickForBtnEvalution:(LyStatusTableViewCell *)statusCell;

- (void)onClickForBtnTransmit:(LyStatusTableViewCell *)statusCell;

@end