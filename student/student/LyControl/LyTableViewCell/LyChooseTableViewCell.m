//
//  LyChooseTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/16.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyChooseTableViewCell.h"
#import "LyUtil.h"


const CGFloat ivMoreWidth = 20.0f;
const CGFloat ivMoreHeight = ivMoreWidth;


#define chsecellWidth                   SCREEN_WIDTH
CGFloat const chsecellHeight = 50.0f;


#define lbTitleWidth                    (chsecellWidth/3.0f)
CGFloat const ctlLbTitleHeight = chsecellHeight;
#define lbTitleFont                     LyFont(14)

#define lbDetailWidth                   (chsecellWidth-lbTitleWidth-ivMoreWidth-horizontalSpace*3)
CGFloat const ctcLbDetailHeight = chsecellHeight;
#define lbDetailFont                    LyFont(14)



@interface LyChooseTableViewCell ()
{
    UILabel             *lbTitle;
    UILabel             *lbDetail;
}
@end


@implementation LyChooseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initSubviews];
    }
    
    return self;
}



- (void)initSubviews
{
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, 0, lbTitleWidth, ctlLbTitleHeight)];
    [lbTitle setFont:lbTitleFont];
    [lbTitle setTextColor:LyBlackColor];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    
    lbDetail = [[UILabel alloc] initWithFrame:CGRectMake( lbTitle.frame.origin.x+CGRectGetWidth(lbTitle.frame), 0, lbDetailWidth, ctcLbDetailHeight)];
    [lbDetail setFont:lbDetailFont];
    [lbDetail setTextColor:LyDarkgrayColor];
    [lbDetail setTextAlignment:NSTextAlignmentRight];
    
    [self addSubview:lbTitle];
    [self addSubview:lbDetail];
    
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
}


- (void)setCellInfo:(NSString *)title detail:(NSString *)detail {
    [lbTitle setText:title];
    [lbDetail setText:detail];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
