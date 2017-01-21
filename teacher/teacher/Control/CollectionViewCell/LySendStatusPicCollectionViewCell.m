//
//  LySendStatusPicCollectionViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/30.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LySendStatusPicCollectionViewCell.h"

#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

#import "LyPhotoAsset.h"

CGFloat const sspcellMargin = 2.0f;

//#define ivPicWidth                  sspccellWidth
//#define ivPicHeight                 sspccellHeight


CGFloat const sspccBtnDeleteWidth = 20.0f;
CGFloat const sspccBtnDeleteHeight = sspccBtnDeleteWidth;


@implementation LySendStatusPicCollectionViewCell


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
    
    
    btnDelete = [[UIButton alloc] initWithFrame:CGRectMake( ivPic.frame.origin.x+CGRectGetWidth(ivPic.frame)-sspccBtnDeleteWidth, 0, sspccBtnDeleteWidth, sspccBtnDeleteHeight)];
    [btnDelete addTarget:self action:@selector(targetForBtnDelete) forControlEvents:UIControlEventTouchUpInside];
    [btnDelete setImage:[LyUtil imageForImageName:@"sendStatus_btn_delete" needCache:NO] forState:UIControlStateNormal];
    [self addSubview:btnDelete];
}


- (void)setCellInfo:(UIImage *)image andMode:(LySendStatusPicCollectionViewCellMode)mode andIndex:(NSInteger)index isEditing:(BOOL)isEditing
{
    _mode = mode;
    _index = index;
    
    switch ( _mode) {
        case LySendStatusPicCollectionViewCellMode_pic: {
            
            [ivPic setImage:image];
            [btnDelete setHidden:!isEditing];
            
            break;
        }
        case LySendStatusPicCollectionViewCellMode_add: {
            
            image = [LyUtil imageForImageName:@"ss_btn_AddPic" needCache:NO];
            [ivPic setImage:image];
            [btnDelete setHidden:YES];
            
            break;
        }
    }
}





- (void)targetForBtnDelete
{
    if ( [_delegate respondsToSelector:@selector(onDeleteLySendStatusPicCollectionViewCell:)])
    {
        [_delegate onDeleteLySendStatusPicCollectionViewCell:self];
    }
}

@end
