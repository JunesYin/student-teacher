//
//  LyPopupMenuTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/24.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyPopupMenuTableViewCell.h"
#import "LyUtil.h"

#define pmCellWidth                     (CGRectGetWidth(self.frame)/2.0f)
CGFloat const pmCellHeight = 40.0f;

CGFloat const pmtcIvIconSize = 30.0f;


CGFloat const pmtcLbTitleWidth = 150.0f;
CGFloat const pmtcLbTitleHeight = pmCellHeight;
#define lbTitleFont                     LyFont(16)


@interface LyPopupMenuTableViewCell ()
{
    UIImageView                 *ivIcon;
    
    UILabel                     *lbTitle;
}
@end


@implementation LyPopupMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initAndLayoutSubview];
    }
    
    
    return self;
}




- (void)initAndLayoutSubview
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self setSelectedBackgroundView:({
        UIView *viewSelectedBackgroud = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        
        [viewSelectedBackgroud setBackgroundColor:LyCellSelectedBackgroundColor];
        
        viewSelectedBackgroud;
    })];
    
    ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake( pmCellWidth-horizontalSpace-pmtcIvIconSize, pmCellHeight/2.0f-pmtcIvIconSize/2.0f, pmtcIvIconSize, pmtcIvIconSize)];
    [ivIcon setContentMode:UIViewContentModeScaleAspectFit];
    
    
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake( ivIcon.frame.origin.x-horizontalSpace-pmtcLbTitleWidth, 0, pmtcLbTitleWidth, pmtcLbTitleHeight)];
    [lbTitle setTextColor:[UIColor whiteColor]];
    [lbTitle setFont:lbTitleFont];
    [lbTitle setTextAlignment:NSTextAlignmentRight];
    
    
    
    [self addSubview:ivIcon];
    [self addSubview:lbTitle];
}



- (void)setCellInfo:(NSString *)title withImageName:(NSString *)imageName
{
    [lbTitle setText:title];
    
    [ivIcon setImage:[LyUtil imageForImageName:imageName needCache:NO]];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
