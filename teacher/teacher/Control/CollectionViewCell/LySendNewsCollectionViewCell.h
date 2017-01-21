//
//  LySendNewsCollectionViewCell.h
//  teacher
//
//  Created by Junes on 2016/10/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>



UIKIT_EXTERN CGFloat const snccellMargin;





typedef NS_ENUM( NSInteger, LySendNewsPicCollectionViewCellMode) {
    LySendNewsPicCollectionViewCellMode_pic,
    LySendNewsPicCollectionViewCellMode_add
};


@class ALAsset;
@protocol LySendNewsCollectionViewCellDelegate;



@interface LySendNewsCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak)     id<LySendNewsCollectionViewCellDelegate>            delegate;

@property (assign, nonatomic)      NSInteger                                        index;

@property (assign, nonatomic, readonly)     LySendNewsPicCollectionViewCellMode     mode;


- (void)setCellInfo:(UIImage *)image andMode:(LySendNewsPicCollectionViewCellMode)mode andIndex:(NSInteger)index isEditing:(BOOL)isEditing;

@end


@protocol LySendNewsCollectionViewCellDelegate <NSObject>

- (void)onDeleteBySendNewsCollectionViewCell:(LySendNewsCollectionViewCell *)acell;

@end
