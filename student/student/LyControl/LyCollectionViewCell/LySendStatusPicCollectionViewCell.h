//
//  LySendStatusPicCollectionViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/30.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyUtil.h"


UIKIT_EXTERN CGFloat const sspcellMargin;


@class ALAsset;



typedef NS_ENUM( NSInteger, LySendStatusPicCollectionViewCellMode)
{
    LySendStatusPicCollectionViewCellMode_pic,
    LySendStatusPicCollectionViewCellMode_add
};



@protocol LySendStatusPicCollectionViewCellDelegate;


@interface LySendStatusPicCollectionViewCell : UICollectionViewCell
{
    UIImageView         *ivPic;
    UIButton            *btnDelete;
}

//@property ( retain, nonatomic)      UIImage                                     *image;
@property ( assign, nonatomic)      NSInteger                                   index;
@property ( assign, nonatomic, readonly)      LySendStatusPicCollectionViewCellMode       mode;
@property ( weak, nonatomic)        id<LySendStatusPicCollectionViewCellDelegate>       delegate;


- (void)setCellInfo:(UIImage *)image andMode:(LySendStatusPicCollectionViewCellMode)mode andIndex:(NSInteger)index isEditing:(BOOL)isEditing;


@end



@protocol LySendStatusPicCollectionViewCellDelegate <NSObject>

- (void)onDeleteLySendStatusPicCollectionViewCell:(LySendStatusPicCollectionViewCell *)ycell;


@end
