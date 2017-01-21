//
//  LyFragmentCollectionViewCell.m
//  teacher
//
//  Created by Junes on 16/8/17.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyFragmentCollectionViewCell.h"

#import "LyUtil.h"


@interface LyFragmentCollectionViewCell ()
{
    UILabel             *lbTitle;
    
    UIImageView         *ivFlag;
}
@end


@implementation LyFragmentCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        lbTitle = [[UILabel alloc] initWithFrame:self.bounds];
        [lbTitle setFont:[UIFont systemFontOfSize:14]];
        [lbTitle setTextColor:LyBlackColor];
        [lbTitle setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:lbTitle];
        
        
        ivFlag = [[UIImageView alloc] initWithImage:[LyUtil imageWithColor:[UIColor lightGrayColor] withSize:CGSizeMake(CGRectGetWidth(self.bounds), 2)]
                                   highlightedImage:[LyUtil imageWithColor:Ly517ThemeColor withSize:CGSizeMake(CGRectGetWidth(self.bounds), 2)]];
        [ivFlag setFrame:CGRectMake(0, CGRectGetHeight(self.bounds)-2, CGRectGetWidth(self.bounds), 2)];
        [self addSubview:ivFlag];
    }
    
    return self;
}


- (void)setTitle:(NSString *)title
{
    _title = title;
    [lbTitle setText:title];
}


- (void)setSelected:(BOOL)selected
{
    [lbTitle setTextColor:(selected) ? Ly517ThemeColor : LyBlackColor];
    
    [ivFlag setHighlighted:selected];
}



@end
