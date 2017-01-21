//
//  LyPriceDetailTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>



UIKIT_EXTERN CGFloat const pdcellHeight;

@class LyPriceDetail;
@protocol LyPriceDetailTableViewCellDelegate;

@interface LyPriceDetailTableViewCell : UITableViewCell

@property (weak, nonatomic)     id<LyPriceDetailTableViewCellDelegate>  delegate;

@property (retain, nonatomic)       LyPriceDetail           *priceDetail;

//@property (assign, nonatomic, getter=isEditing)       BOOL  editing;

- (void)setCellInfo:(NSString *)time andPrice:(NSString *)price;

@end



@protocol LyPriceDetailTableViewCellDelegate <NSObject>

@required
//- (void)onClickedBtnModifyByPriceDetailTableViewCell:(LyPriceDetailTableViewCell *)aCell;
- (void)onClickedBtnDeleteByPriceDetailTableViewCell:(LyPriceDetailTableViewCell *)aCell;

@end

