//
//  LyImageView.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/2.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyImageView.h"
#import "LyUtil.h"


CGFloat const livBtnDeleteWidth = 20.0f;
CGFloat const livBtnDeleteHeight = livBtnDeleteWidth;


@interface LyImageView ()
{
    UIImageView                         *imageView;
}
@end


@implementation LyImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        //[self initAndLayoutSubview];
    }
    
    
    return self;
}



- (instancetype)init
{
    if ( self = [super init])
    {
        [self initAndAddSubview];
    }
    
    
    return self;
}



- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [imageView setFrame:CGRectMake( 0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    
    [_btnDelete setFrame:CGRectMake( CGRectGetWidth(self.frame)-livBtnDeleteWidth, 0, livBtnDeleteWidth, livBtnDeleteHeight)];
}



- (void)initAndAddSubview
{
    [self setBackgroundColor:[UIColor purpleColor]];
    
    imageView = [[UIImageView alloc] init];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    
    
    _btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnDelete setBackgroundColor:Ly517ThemeColor];
    [_btnDelete addTarget:self action:@selector(onBtnDeleteClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:imageView];
    [self addSubview:_btnDelete];
}



- (void)initAndLayoutSubview
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    
    
    
    
    
    _btnDelete = [[UIButton alloc] initWithFrame:CGRectMake( CGRectGetWidth(self.frame)-livBtnDeleteWidth, 0, livBtnDeleteWidth, livBtnDeleteHeight)];
    [_btnDelete setBackgroundColor:[UIColor blueColor]];
    [_btnDelete addTarget:self action:@selector(onBtnDeleteClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [self addSubview:imageView];
    [self addSubview:_btnDelete];
}



- (void)setImage:(UIImage *)image
{
    _image = image;
    [imageView setImage:_image];
}



- (void)onBtnDeleteClick
{
    if ( [_delegate respondsToSelector:@selector(onClickForBtnDelete:)])
    {
        [_delegate onClickForBtnDelete:_lineIndex];
    }
}




@end
