//
//  LyLandMarkCollectionViewCell.m
//  teacher
//
//  Created by Junes on 16/8/11.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyLandMarkCollectionViewCell.h"

#import "LyLandMark.h"

#import "LyUtil.h"


#define lmccellWidth                        CGRectGetWidth(self.bounds)
#define lmccellHeight                       CGRectGetHeight(self.bounds)


#define lbLandMarkWidth                     (lmccellWidth*9/10.0f)
#define lbLandMarkHeight                    (lmccellHeight*9/10.0f)


CGFloat const ivFuncSize = 15.0f;

@interface LyLandMarkCollectionViewCell ()
{
    UILabel                 *lbLandMark;
    
    UIImageView             *ivFunc;
}
@end


@implementation LyLandMarkCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        lbLandMark = [[UILabel alloc] initWithFrame:CGRectMake(0, lmccellHeight-lbLandMarkHeight, lbLandMarkWidth, lbLandMarkHeight)];
        [lbLandMark setFont:[UIFont systemFontOfSize:12]];
        [lbLandMark setTextColor:[UIColor darkGrayColor]];
        [lbLandMark setTextAlignment:NSTextAlignmentCenter];
        [lbLandMark.layer setCornerRadius:btnCornerRadius];
        [lbLandMark.layer setBorderWidth:1.0f];
        [lbLandMark.layer setBorderColor:[Ly517ThemeColor CGColor]];
        [lbLandMark setClipsToBounds:YES];
        [lbLandMark setNumberOfLines:0];
        [lbLandMark setBackgroundColor:[UIColor colorWithRed:254/255.0f green:233/255.0f blue:203/255.0f alpha:1.0f]];
        
        
        ivFunc = [[UIImageView alloc] initWithImage:[LyUtil imageForImageName:@"landMark_btn_delete_n" needCache:NO]
                                   highlightedImage:[LyUtil imageForImageName:@"landMark_btn_delete_h" needCache:NO]];
        [ivFunc setFrame:CGRectMake(lmccellWidth-ivFuncSize, 0, ivFuncSize, ivFuncSize)];
        [ivFunc.layer setCornerRadius:ivFuncSize/2.0f];
        
        [self addSubview:lbLandMark];
        [self addSubview:ivFunc];
    }
    
    return self;
}


- (void)setLandMark:(LyLandMark *)landMark editing:(BOOL)editing
{
    _landMark = landMark;
    [lbLandMark setText:landMark.lmName];
    
    self.editing = editing;
}


- (void)setLandMark:(NSString *)landMark
{
    [lbLandMark setText:landMark];
    
    [ivFunc setHidden:!_editing];
}


- (void)setEditing:(BOOL)editing
{
    _editing = editing;
    
    [ivFunc setHidden:!_editing];
}



- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [ivFunc setHighlighted:selected];
}


@end
