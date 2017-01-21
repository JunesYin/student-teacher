//
//  LyAddStudentTableViewCell.m
//  teacher
//
//  Created by Junes on 16/8/17.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyAddStudentTableViewCell.h"

#import "LyUtil.h"

CGFloat const astcellHeight = 80.0f;

CGFloat const astcIvIconSize = 50.0f;


@interface LyAddStudentTableViewCell ()
{
    UIImageView             *ivIcon;
    
    UILabel                 *lbTitle;
    
    UIImageView             *ivMore;
}
@end

@implementation LyAddStudentTableViewCell

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
    ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake(horizontalSpace, astcellHeight/2.0f-astcIvIconSize/2.0f, astcIvIconSize, astcIvIconSize)];
    [self addSubview:ivIcon];
    
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace*2+astcIvIconSize, 0, SCREEN_WIDTH-astcIvIconSize-ivMoreSize-horizontalSpace*4, astcellHeight)];
    [lbTitle setFont:LyFont(16)];
    [lbTitle setTextColor:LyBlackColor];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbTitle];
    
    ivMore = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-ivMoreSize, astcellHeight/2.0f-ivMoreSize/2.0f, ivMoreSize, ivMoreSize)];
    [ivMore setImage:[LyUtil imageForImageName:@"ivMore" needCache:NO]];
    [self addSubview:ivMore];
}


- (void)setCellInfo:(UIImage *)icon title:(NSString *)title
{
    [ivIcon setImage:icon];
    
    [lbTitle setText:title];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
