//
//  LySimuLateStudyTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/12.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LySimuLateStudyTableViewCell.h"

#import "LyCurrentUser.h"

#import "LyUtil.h"


CGFloat const simuCellHeight = 40.0f;

CGFloat const simuHorizontalSpace = 7.0f;

#define simuCellWidth                               stcellWidth


CGFloat const simuLbTitleWidth = 70.0f;
CGFloat const simuLbTitleHeight = simuCellHeight;
#define lbTitleFont                                 LyFont(16)

#define simuLbDetailWidth                           (simuCellWidth-simuLbTitleWidth-simuHorizontalSpace)
CGFloat const simuLbDetailHeight = simuCellHeight;
#define lbDetailFont                                LyFont(14)




@interface LySimuLateStudyTableViewCell ()
{
    UILabel                                 *lbTitle;
    UILabel                                 *lbDetail;
}
@end


static CGFloat stcellWidth;


@implementation LySimuLateStudyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initAndAddSubview];
    }
    
    return self;
}



- (void)initAndAddSubview
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setBackgroundColor:LyWhiteLightgrayColor];
    
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, simuLbTitleWidth, simuLbTitleHeight)];
    [lbTitle setFont:lbTitleFont];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    [lbTitle setTextColor:LyBlackColor];
    

    lbDetail = [[UILabel alloc] initWithFrame:CGRectMake( lbTitle.frame.origin.x+lbTitle.frame.size.width+simuHorizontalSpace, 0, simuLbDetailWidth, simuLbDetailHeight)];
    [lbDetail setFont:lbDetailFont];
    [lbDetail setTextColor:LyDarkgrayColor];
    [lbDetail setTextAlignment:NSTextAlignmentRight];
    

    [self addSubview:lbTitle];
    [self addSubview:lbDetail];
}


+ (void)setCellWidth:(CGFloat)width
{
    stcellWidth = width;
}


- (void)setCellInfo:(NSString *)title detail:(NSString *)detail
{
    [lbTitle setText:title];
    [lbDetail setText:detail];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
