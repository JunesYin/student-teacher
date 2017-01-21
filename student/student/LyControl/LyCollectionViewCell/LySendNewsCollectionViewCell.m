//
//  LySendNewsCollectionViewCell.m
//  teacher
//
//  Created by Junes on 2016/10/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LySendNewsCollectionViewCell.h"

#import "LyPhotoAsset.h"
#import "LyUtil.h"

#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

CGFloat const snccellMargin = 2.0f;


CGFloat const snccBtnDeleteSize = 20.0f;

@interface LySendNewsCollectionViewCell ()
{
    UIImageView         *ivPic;
    UIButton            *btnDelete;
}
@end


@implementation LySendNewsCollectionViewCell



- (instancetype)initWithFrame:(CGRect)frame {
    if ( self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    
    return self;
}


- (void)initSubviews {
    ivPic = [[UIImageView alloc] initWithFrame:self.bounds];
    [ivPic setContentMode:UIViewContentModeScaleAspectFill];
    [ivPic setClipsToBounds:YES];
    [self addSubview:ivPic];
    
    
    btnDelete = [[UIButton alloc] initWithFrame:CGRectMake( ivPic.frame.origin.x+CGRectGetWidth(ivPic.frame)-snccBtnDeleteSize, 0, snccBtnDeleteSize, snccBtnDeleteSize)];
    [btnDelete addTarget:self action:@selector(targetForBtnDelete) forControlEvents:UIControlEventTouchUpInside];
    [btnDelete setImage:[LyUtil imageForImageName:@"sendStatus_btn_delete" needCache:NO] forState:UIControlStateNormal];
    [self addSubview:btnDelete];
}


- (void)setCellInfo:(UIImage *)image andMode:(LySendNewsPicCollectionViewCellMode)mode andIndex:(NSInteger)index isEditing:(BOOL)isEditing {
    
    _mode = mode;
    _index = index;
    
    switch ( _mode) {
        case LySendNewsPicCollectionViewCellMode_pic: {
            
            [ivPic setImage:image];
            [btnDelete setHidden:!isEditing];
            
            break;
        }
        case LySendNewsPicCollectionViewCellMode_add: {
            
            image = [LyUtil imageForImageName:@"ss_btn_AddPic" needCache:NO];
            [ivPic setImage:image];
            [btnDelete setHidden:YES];
            
            break;
        }
    }
}





- (void)targetForBtnDelete {
    if ( [_delegate respondsToSelector:@selector(onDeleteBySendNewsCollectionViewCell:)]) {
        [_delegate onDeleteBySendNewsCollectionViewCell:self];
    }
}


@end
