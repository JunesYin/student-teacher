//
//  LyOrderCenterBarCollectionViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/4.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyOrderCenterBarCollectionViewCell.h"
#import "LyUtil.h"



#define lbTitleFont                 LyFont(14)

CGFloat const viewLineHeight = 2.0f;


@interface LyOrderCenterBarCollectionViewCell ()
{
    UILabel                     *lbTitle;
    
    UIView                      *viewLine;
}
@end


@implementation LyOrderCenterBarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbTitle = [[UILabel alloc] initWithFrame:self.bounds];
        [lbTitle setFont:lbTitleFont];
        [lbTitle setTextColor:LyBlackColor];
        [lbTitle setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:lbTitle];
        
        
        
        viewLine = [[UIView alloc] initWithFrame:CGRectMake( 0, CGRectGetHeight(self.frame)-viewLineHeight, CGRectGetWidth(self.frame), viewLineHeight)];
        [viewLine setBackgroundColor:Ly517ThemeColor];
        [self addSubview:viewLine];
        
        
        [viewLine setHidden:YES];
    }
    
    return self;
}


- (void)setTitle:(NSString *)title
{
    _title = title;
    
    [lbTitle setText:_title];
}


- (void)setSelected:(BOOL)selected
{
    if ( selected)
    {
        [lbTitle setTextColor:Ly517ThemeColor];
        [viewLine setHidden:NO];
    }
    else
    {
        [lbTitle setTextColor:LyBlackColor];
        [viewLine setHidden:YES];
    }
}



@end
