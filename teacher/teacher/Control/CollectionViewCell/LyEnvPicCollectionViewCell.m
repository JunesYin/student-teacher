//
//  LyEnvPicCollectionViewCell.m
//  teacher
//
//  Created by Junes on 16/8/24.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyEnvPicCollectionViewCell.h"
#import "LyUtil.h"
#import "LyPhotoAsset.h"

#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>



CGFloat const epccellMargin = 2;


CGFloat const btnFlagSize = 20.0f;


@implementation LyEnvPicCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        [self initAndLayoutSubviews];
    }
    
    return self;
}


- (void)initAndLayoutSubviews
{
    ivPic = [[UIImageView alloc] initWithFrame:self.bounds];
    [ivPic setContentMode:UIViewContentModeScaleAspectFill];
    [ivPic setClipsToBounds:YES];
    [self addSubview:ivPic];
    
    btnFlag = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)-btnFlagSize, 0, btnFlagSize, btnFlagSize)];
    [btnFlag setImage:[LyUtil imageForImageName:@"ivFlag_n" needCache:NO] forState:UIControlStateNormal];
    [btnFlag setImage:[LyUtil imageForImageName:@"ivFlag_h" needCache:NO] forState:UIControlStateSelected];
    [btnFlag addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnFlag];
}


- (void)setCellInfo:(LyPhotoAsset *)asset mode:(LyEnvPicCollectionViewCellMode)mode index:(NSInteger)index isEditing:(BOOL)isEditing
{
    _mode = mode;
    _index = index;
    
    switch ( _mode) {
        case LyEnvPicCollectionViewCellMode_pic: {
            
//            if ([imageSource isKindOfClass:[ALAsset class]])
//            {
//                ALAsset *asset = (ALAsset *)imageSource;
//                UIImage *image = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
//                [ivPic setImage:image];
//            }
//            else if ([imageSource isKindOfClass:[LyPhotoAsset class]])
//            {
                _asset = asset;
                if (_asset.thumbnailImage)
                {
                    [ivPic setImage:_asset.thumbnailImage];
                }
                else
                {
                    [ivPic sd_setImageWithURL:_asset.smallUrl
                             placeholderImage:[LyUtil imageForImageName:@"status_pic_default" needCache:NO]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        
                                        [_asset setThumbnailImage:image];
                                    }];
                }
//            }
//            else
//            {
//                [ivPic sd_setImageWithURL:[NSURL URLWithString:imageSource]
//                         placeholderImage:[LyUtil imageForImageName:@"status_pic_default" needCache:NO]
//                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                    [_delegate onLoadFinishByEnvPicCollectionViewCell:self image:image];
//                                }];
//            }
            
            [btnFlag setHidden:!isEditing];
            
            break;
        }
        case LyEnvPicCollectionViewCellMode_add: {
            
            UIImage *image = [LyUtil imageForImageName:@"ss_btn_AddPic" needCache:NO];
            [ivPic setImage:image];
            [btnFlag setHidden:YES];
            
            break;
        }
    }
}


- (void)setChoosed:(BOOL)choosed
{
    _choosed = choosed;
    [btnFlag setSelected:_choosed];
}


- (void)targetForButton:(UIButton *)button
{
    btnFlag.selected = !btnFlag.isSelected;
    _choosed = btnFlag.isSelected;
}



@end
