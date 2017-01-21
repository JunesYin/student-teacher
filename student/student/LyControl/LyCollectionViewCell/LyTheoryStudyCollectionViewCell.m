//
//  LyTheoryStudyCollectionViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/24.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyTheoryStudyCollectionViewCell.h"
#import "LyUtil.h"






#define tscellWidth                     CGRectGetWidth(self.frame)
#define tscellHeight                    CGRectGetHeight(self.frame)

#define ivIconWidth                     (tscellWidth*7/10.0f)
#define ivIconHeight                    ivIconWidth

#define lbTitleWidth                    tscellWidth
#define lbTitleHeight                   (tscellHeight-ivIconHeight)
#define lbTitleFont                     LyFont(12)


@interface LyTheoryStudyCollectionViewCell ()
{
    UIImageView     *ivIcon;
    UILabel         *lbTitle;
}
@end


@implementation LyTheoryStudyCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        //[self setBackgroundColor:[UIColor yellowColor]];
        
        ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake( tscellWidth/2.0f-ivIconWidth/2.0f, 0, ivIconWidth, ivIconHeight)];
        [ivIcon setContentMode:UIViewContentModeScaleAspectFit];
        
        lbTitle = [[UILabel alloc] initWithFrame:CGRectMake( 0, ivIconHeight, lbTitleWidth, lbTitleHeight)];
        [lbTitle setFont:lbTitleFont];
        [lbTitle setTextColor:LyBlackColor];
        [lbTitle setTextAlignment:NSTextAlignmentCenter];
        
        
        [self addSubview:ivIcon];
        [self addSubview:lbTitle];
    }
    
    
    return self;
}


- (void)setCellInfo:(UIImage *)image withTitle:(NSString *)title 
{
    _icon = image;
    _title = title;
    
    [ivIcon setImage:_icon];
    [lbTitle setText:_title];
}



- (void)setFont:(UIFont *)font
{
    [lbTitle setFont:font];
}


@end
