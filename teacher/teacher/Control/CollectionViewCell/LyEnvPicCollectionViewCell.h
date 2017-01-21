//
//  LyEnvPicCollectionViewCell.h
//  teacher
//
//  Created by Junes on 16/8/24.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const epccellMargin;


enum LyEnvPicCollectionViewCellMode : NSInteger {
    LyEnvPicCollectionViewCellMode_pic,
    LyEnvPicCollectionViewCellMode_add
};
typedef enum LyEnvPicCollectionViewCellMode LyEnvPicCollectionViewCellMode;



@class LyPhotoAsset;
@class LyEnvPicCollectionViewCell;


@protocol LyEnvPicCollectionViewCellDelegate <NSObject>

- (void)onLoadFinishByEnvPicCollectionViewCell:(LyEnvPicCollectionViewCell *)aCell image:(UIImage *)image;

@end


@interface LyEnvPicCollectionViewCell : UICollectionViewCell
{
    UIImageView         *ivPic;
    UIButton            *btnFlag;
}


@property (retain, nonatomic)               LyPhotoAsset                                *asset;
@property (assign, nonatomic)               NSInteger                                   index;
@property (assign, nonatomic, readonly)     LyEnvPicCollectionViewCellMode              mode;
@property (assign, nonatomic, getter=isChoosed) BOOL                                    choosed;
@property (weak, nonatomic)                 id<LyEnvPicCollectionViewCellDelegate>      delegate;


- (void)setCellInfo:(LyPhotoAsset *)asset mode:(LyEnvPicCollectionViewCellMode)mode index:(NSInteger)index isEditing:(BOOL)isEditing;


@end



