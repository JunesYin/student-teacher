//
//  LyPicLocalCollectionViewCell.m
//  student
//
//  Created by Junes on 2016/11/29.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyPicLocalCollectionViewCell.h"


@interface LyPicLocalCollectionViewCell ()
{
    UIImageView         *ivPic;
}
@end

@implementation LyPicLocalCollectionViewCell

- (instancetype)init
{
    if (self = [super init])
    {
        [self initSubviews];
    }
    
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initSubviews];
    }
    
    return self;
}


- (void)initSubviews
{
    
    ivPic = [[UIImageView alloc] initWithFrame:self.bounds];
    [ivPic setContentMode:UIViewContentModeScaleAspectFill];
    
    [self addSubview:ivPic];
}


@end
