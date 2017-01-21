//
//  LyNotificationTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/6.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyNotificationTableViewCell.h"
#import "LyUtil.h"


#define ncellWidth                                      SCREEN_WIDTH
CGFloat const ncellHeight = 80.0f;


CGFloat const nIvIconSize = 60.0f;


#define ntcLbTitleWidth                                    (ncellWidth-horizontalSpace*4)
CGFloat const ntcLbTitleHeight = 30.0f;
#define lbTitleFont                                     LyFont(16)

#define lbDetailWidth                                   ntcLbTitleWidth
CGFloat const lbDetailHeight = 25.0f;
#define lbDetailFont                                    LyFont(14)


CGFloat const lbCountWidth = 20.0f;
CGFloat const lbCountHeight = lbCountWidth;
#define lbCOuntFont                                     LyFont(10)


@interface LyNotificationTableViewCell ()
{
    UIImageView                         *ivIcon;
    
    UILabel                             *lbTitle;
    UILabel                             *lbDetail;
    
    
    UILabel                             *lbCount;
    
    
}
@end


@implementation LyNotificationTableViewCell

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
    
    ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake( horizontalSpace, ncellHeight/2.0f-nIvIconSize/2.0f, nIvIconSize, nIvIconSize)];
    [ivIcon setContentMode:UIViewContentModeScaleAspectFit];
    [[ivIcon layer] setCornerRadius:5.0f];
    [ivIcon setClipsToBounds:YES];
    
    
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake( ivIcon.frame.origin.x+CGRectGetWidth(ivIcon.frame)+horizontalSpace, ivIcon.frame.origin.y, ntcLbTitleWidth, ntcLbTitleHeight)];
    [lbTitle setFont:lbTitleFont];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    [lbTitle setTextColor:LyBlackColor];
    
    
    lbDetail = [[UILabel alloc] initWithFrame:CGRectMake( lbTitle.frame.origin.x, ivIcon.frame.origin.y+CGRectGetHeight(ivIcon.frame)-lbDetailHeight, lbDetailWidth, lbDetailHeight)];
    [lbDetail setFont:lbDetailFont];
    [lbDetail setTextAlignment:NSTextAlignmentLeft];
    [lbDetail setTextColor:LyDarkgrayColor];
    
    
    lbCount = [[UILabel alloc] initWithFrame:CGRectMake( ivIcon.frame.origin.x+CGRectGetWidth(ivIcon.frame)-lbCountWidth, ivIcon.frame.origin.y-lbCountHeight/3.0f, lbCountWidth, lbCountHeight)];
    [lbCount setBackgroundColor:LyNotificationColor];
    [lbCount setFont:lbCOuntFont];
    [lbCount setTextAlignment:NSTextAlignmentCenter];
    [lbCount setTextColor:[UIColor whiteColor]];
    [[lbCount layer] setCornerRadius:lbCountWidth/2.0f];
    [lbCount setClipsToBounds:YES];
    [lbCount setHidden:YES];
    
    [self addSubview:ivIcon];
    [self addSubview:lbTitle];
    [self addSubview:lbDetail];
    [self addSubview:lbCount];
    
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
}



- (void)setCellInfo:(UIImage *)icon title:(NSString *)title detail:(NSString *)detail count:(NSInteger)count {
    [ivIcon setImage:icon];
    [lbTitle setText:title];
    if (![LyUtil validateString:detail]) {
        detail = @" ";
    }
    [lbDetail setText:detail];
    
    [self setNCount:count];
}





- (void)setNCount:(NSInteger)nCount
{
    if ( nCount > 99)
    {
        _nCount = 99;
    }
    else
    {
        _nCount = nCount;
    }
    
    
    if ( _nCount > 0)
    {
        [lbCount setHidden:NO];
        [lbCount setText:[[NSString alloc] initWithFormat:@"%d", (int)_nCount]];
    }
    else
    {
        [lbCount setHidden:YES];
    }
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
