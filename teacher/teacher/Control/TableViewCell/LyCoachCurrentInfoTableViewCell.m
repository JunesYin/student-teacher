//
//  LyCoachCurrentInfoTableViewCell.m
//  teacher
//
//  Created by Junes on 16/8/13.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyCoachCurrentInfoTableViewCell.h"

#import "LyUtil.h"


CGFloat const ccitcellHeight = 70.0f;

CGFloat const ccitcIvIconSize = 50.0f;

#define lbItemWidth                         (SCREEN_WIDTH-horizontalSpace*2-verticalSpace*2)
//CGFloat const lbItemHeight = 20.0f;


@interface LyCoachCurrentInfoTableViewCell ()
{
    UIImageView                 *ivIcon;
    UILabel                     *lbTitle;
    UILabel                     *lbInfo;
    
    UIImageView                 *ivMore;
}
@end


@implementation LyCoachCurrentInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initAndLayoutSubviews];
    }
    
    return self;
}


- (void)initAndLayoutSubviews
{
    ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake(horizontalSpace, ccitcellHeight/2.0f-ccitcIvIconSize/2.0f, ccitcIvIconSize, ccitcIvIconSize)];
    [self addSubview:ivIcon];
    
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(ivIcon.frame.origin.x+CGRectGetWidth(ivIcon.frame)+verticalSpace, ivIcon.ly_y, lbItemWidth, lbItemHeight)];
    [lbTitle setFont:LyFont(15)];
    [lbTitle setTextColor:LyBlackColor];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbTitle];
    
    lbInfo = [[UILabel alloc] initWithFrame:CGRectMake(lbTitle.frame.origin.x, ivIcon.ly_y+CGRectGetHeight(ivIcon.frame)-lbItemHeight, lbItemWidth, lbItemHeight)];
    [lbInfo setFont:LyFont(14)];
    [lbInfo setTextColor:[UIColor darkGrayColor]];
    [lbInfo setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbInfo];
    
    ivMore = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-ivMoreSize, ccitcellHeight/2.0f-ivMoreSize/2.0f, ivMoreSize, ivMoreSize)];
    [ivMore setImage:[LyUtil imageForImageName:@"ivMore" needCache:NO]];
    [self addSubview:ivMore];
}



- (void)setCellInfo:(UIImage *)icon title:(NSString *)title info:(NSString *)info
{
    [ivIcon setImage:icon];
    [lbTitle setText:title];
    [lbInfo setText:info];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
