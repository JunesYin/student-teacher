//
//  LyUserInfoTableViewCell.m
//  teacher
//
//  Created by Junes on 16/8/9.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyUserInfoTableViewCell.h"

#import "UILabel+LyTextAlignmentLeftAndRight.h"

#import "LyUtil.h"

CGFloat const ucicHeight = 50.0f;

CGFloat const uiLbTitleWidth = 90.0f;
#define lbDetailWidth                           (SCREEN_WIDTH-uiLbTitleWidth-ivMoreSize-horizontalSpace*2-verticalSpace*2)

CGFloat const uitcIvIconSize = 30.0f;

#define lbTitleFont                             LyFont(16)
#define lbDetailFont                            LyFont(13)

@interface LyUserInfoTableViewCell ()
{
    UILabel                 *lbTitle;
    
    UILabel                 *lbDetail;
    
    UIImageView             *ivIcon;
    
    UIImageView             *ivMore;
}
@end


@implementation LyUserInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, uiLbTitleWidth, ucicHeight)];
        [lbTitle setFont:lbTitleFont];
        [lbTitle setTextColor:[UIColor blackColor]];
        [lbTitle setTextAlignment:NSTextAlignmentLeft];
        
        lbDetail = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace+uiLbTitleWidth+verticalSpace, 0, lbDetailWidth, ucicHeight)];
        [lbDetail setFont:lbDetailFont];
        [lbDetail setTextColor:LyBlackColor];
        [lbDetail setTextAlignment:NSTextAlignmentRight];
        [lbDetail setNumberOfLines:0];
        
        ivMore = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-ivMoreSize, ucicHeight/2.0f-ivMoreSize/2.0f, ivMoreSize, ivMoreSize)];
        [ivMore setImage:[LyUtil imageForImageName:@"ivMore" needCache:NO]];
        
        [self addSubview:lbTitle];
        [self addSubview:lbDetail];
        [self addSubview:ivMore];
    }
    
    return self;
}


- (void)setCellInfo:(NSString *)title detail:(NSString *)detail icon:(UIImage *)icon
{
    [lbTitle setText:title];
//    [lbTitle justifyTextAlignmentLeftAndRight];
    
    if (!icon)
    {
        [lbDetail setHidden:NO];
        [ivIcon setHidden:YES];
        
        if (![LyUtil validateString:detail])
        {
            detail = @" ";
        }
        
        UIColor *detailColor = LyBlackColor;
        if ([detail isEqualToString:@"这个家伙很懒，什么都没留下"])
        {
            detailColor = [UIColor grayColor];
        }
        
        [lbDetail setTextColor:detailColor];
        [lbDetail setText:detail];
    }
    else
    {
        if (!ivIcon)
        {
            ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace*2-ivMoreSize-uitcIvIconSize, ucicHeight/2.0f-uitcIvIconSize/2.0f, uitcIvIconSize, uitcIvIconSize)];
            [self addSubview:ivIcon];
        }
        
        [lbDetail setHidden:YES];
        [ivIcon setHidden:NO];
        [ivIcon setImage:icon];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
