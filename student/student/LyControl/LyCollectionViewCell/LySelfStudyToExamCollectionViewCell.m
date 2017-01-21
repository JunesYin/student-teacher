//
//  LySelfStudyToExamCollectionViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/19.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LySelfStudyToExamCollectionViewCell.h"

#import "LyUtil.h"



#define ivIconWidth                     (CGRectGetWidth(self.frame)/3.0f)
#define ivIconHeight                    ivIconWidth


#define ssteccLbTitleWidth                    CGRectGetWidth(self.frame)
CGFloat const ssteccLbTitleHeight = 20.0f;
#define lbTitleFont                     LyFont(14)

#define ssteccLbDetailWidth                   ssteccLbTitleWidth
CGFloat const ssteccLbDetailHeight = 20.0f;
#define lbDetailFont                    LyFont(12)



@interface LySelfStudyToExamCollectionViewCell ()
{
    UIImageView                 *ivIcon;
    UILabel                     *lbTitle;
    UILabel                     *lbDetail;
}
@end


@implementation LySelfStudyToExamCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        [self initSubviews];
    }
    
    return self;
}


- (void)initSubviews
{
    ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake( CGRectGetWidth(self.frame)/2.0f-ivIconWidth/2.0f, ivIconHeight, ivIconWidth, ivIconHeight)];
    [[ivIcon layer] setCornerRadius:5.0f];
    [ivIcon setClipsToBounds:YES];
    [self addSubview:ivIcon];
    
    
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake( 0, ivIcon.frame.origin.y+CGRectGetHeight(ivIcon.frame)+verticalSpace, ssteccLbTitleWidth, ssteccLbTitleHeight)];
    [lbTitle setFont:lbTitleFont];
    [lbTitle setTextColor:LyBlackColor];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbTitle];
    
    lbDetail = [[UILabel alloc] initWithFrame:CGRectMake( 0, lbTitle.frame.origin.y+CGRectGetHeight(lbTitle.frame)+verticalSpace, ssteccLbDetailWidth, ssteccLbDetailHeight)];
    [lbDetail setFont:lbDetailFont];
    [lbDetail setTextColor:LyDarkgrayColor];
    [lbDetail setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbDetail];

}



- (void)setCellInfo:(UIImage *)icon title:(NSString *)title on:(BOOL)on
{
    _icon = icon;
    _title = title;
    _on = on;
    
    
    [ivIcon setImage:_icon];
    [lbTitle setText:_title];
    
    if ( _on)
    {
        [lbDetail setHidden:YES];
    }
    else
    {
        [lbDetail setHidden:NO];
        [lbDetail setText:@"暂未开通"];
    }
}



@end
