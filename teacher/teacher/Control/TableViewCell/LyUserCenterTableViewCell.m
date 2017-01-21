//
//  LyUserCenterTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/24.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyUserCenterTableViewCell.h"
#import "LyCurrentUser.h"
#import "UIImage+Scale.h"



CGFloat const UCENTERCELLHEIGHT = 40.0f;

//图标
CGFloat const uctcIvIconSize = 30;

//文字
#define lbTitleWidth                        ([[UIScreen mainScreen] bounds].size.width/2.0f)
CGFloat const uctcLbTitleHeight = UCENTERCELLHEIGHT;


#define lbTitleFont                     LyFont(16)


@interface LyUserCenterTableViewCell ()
{
    
    UIImageView                 *ivIcon;
    UILabel                     *lbTitle;
}

@end


@implementation LyUserCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initAndLayoutSubView];
        
        
    }
    
    return self;
}



- (void)initAndLayoutSubView
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self setSelectedBackgroundView:({
        UIView *viewSelectedBackgroud = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        
        [viewSelectedBackgroud setBackgroundColor:LyUserCenterCellSelectedBackgroundColor];
        
        viewSelectedBackgroud;
    })];
    
    
    //图标
    ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake( horizontalSpace, UCENTERCELLHEIGHT/2-uctcIvIconSize/2, uctcIvIconSize, uctcIvIconSize)];
    [ivIcon setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:ivIcon];
    
    //标题
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake( ivIcon.frame.origin.x+ivIcon.frame.size.width+horizontalSpace, 0, lbTitleWidth, uctcLbTitleHeight)];
    [lbTitle setFont:lbTitleFont];
    [lbTitle setTextColor:[UIColor whiteColor]];
//    [_lbTitleText setHighlightedTextColor:LyLightgrayColor];
    [self addSubview:lbTitle];
    
}



- (void)setCellInfo:(NSString *)title withImage:(UIImage *)image
{
    [ivIcon setImage:image];
    
    
    [lbTitle setText:title];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
