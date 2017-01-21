//
//  LyLeftMenuSettingTableViewCell.m
//  student
//
//  Created by Junes on 16/8/29.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyLeftMenuSettingTableViewCell.h"

#import "LyUtil.h"


CGFloat const lmstcellHeight = 50.0f;


CGFloat const lmstcIvIconSize = 30.0f;
CGFloat const lmstcLbTitleWidth = 90.0f;
#define lbDetailWidth                   (SCREEN_WIDTH-lmstcIvIconSize-lmstcLbTitleWidth-lmstcIvMoreSize-horizontalSpace*5)
CGFloat const lmstcIvMoreSize = 20.0f;



@interface LyLeftMenuSettingTableViewCell ()
{
    UIImageView             *ivIcon;
    UILabel                 *lbTitle;
    UILabel                 *lbDetail;
}
@end


@implementation LyLeftMenuSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake( horizontalSpace, lmstcellHeight/2.0f-lmstcIvIconSize/2.0f, lmstcIvIconSize, lmstcIvIconSize)];
        [self addSubview:ivIcon];
        
        lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(ivIcon.frame.origin.x+CGRectGetWidth(ivIcon.frame)+horizontalSpace, 0, lmstcLbTitleWidth, lmstcellHeight)];
        [lbTitle setTextColor:LyBlackColor];
        [lbTitle setTextAlignment:NSTextAlignmentLeft];
        [lbTitle setFont:LyFont(16)];
        [self addSubview:lbTitle];
        
        lbDetail = [[UILabel alloc] initWithFrame:CGRectMake(lbTitle.frame.origin.x+CGRectGetWidth(lbTitle.frame)+horizontalSpace, 0, lbDetailWidth, lmstcellHeight)];
        [lbDetail setTextColor:[UIColor darkGrayColor]];
        [lbDetail setTextAlignment:NSTextAlignmentRight];
        [lbDetail setNumberOfLines:0];
        [lbDetail setFont:LyFont(14)];
        [self addSubview:lbDetail];
        
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    return self;
}


- (void)setCellInfo:(UIImage *)icon title:(NSString *)title detail:(NSString *)detail
{
    [ivIcon setImage:icon];
    [lbTitle setText:title];
    
    if ([title isEqualToString:@"联系我们"])
    {
        NSMutableAttributedString *strTitle = [[NSMutableAttributedString alloc] initWithString:detail];
        [strTitle addAttribute:NSForegroundColorAttributeName
                         value:Ly517ThemeColor
                         range:NSMakeRange(detail.length-3, 3)];
        [lbDetail setAttributedText:strTitle];
    }
    else
    {
        [lbDetail setText:detail];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
