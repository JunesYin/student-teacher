//
//  LyUserCenterInfoTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/31.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyUserInfoTableViewCell.h"
#import "LyCurrentUser.h"
#import "LyUtil.h"


CGFloat const ucicHeight = 50.0f;


CGFloat const uitcLbTitleWidth = 90.0f;
#define lbDetailWidth                           (SCREEN_WIDTH-uitcLbTitleWidth-ivMoreSize-horizontalSpace*4)

CGFloat const uitcIvDetailSize = 30.0f;


@interface LyUserInfoTableViewCell ()
{
    UILabel                                 *lbTitle;
    UILabel                                 *lbDetail;
    UIImageView                             *ivDetail;
}

@end

@implementation LyUserInfoTableViewCell

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
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, 0, uitcLbTitleWidth, ucicHeight)];
    [lbTitle setTextColor:LyBlackColor];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    [lbTitle setFont:LyFont(16)];
    
    
    lbDetail = [[UILabel alloc] initWithFrame:CGRectMake( lbTitle.frame.origin.x+lbTitle.frame.size.width+horizontalSpace, 0, lbDetailWidth, ucicHeight)];
    [lbDetail setTextColor:[UIColor darkGrayColor]];
    [lbDetail setTextAlignment:NSTextAlignmentRight];
    [lbDetail setNumberOfLines:0];
    [lbDetail setFont:LyFont(14)];
    

    [self addSubview:lbTitle];
    [self addSubview:lbDetail];
    
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
}



- (void)setCellInfo:(NSString *)title detail:(NSString *)detail isQRCode:(BOOL)isQRCode {
    [lbTitle setText:title];
    
    if (isQRCode) {
        ivDetail = [[UIImageView alloc] initWithFrame:CGRectMake( SCREEN_WIDTH - ivMoreSize - horizontalSpace - uitcIvDetailSize, ucicHeight/2.0f-uitcIvDetailSize/2.0f, uitcIvDetailSize, uitcIvDetailSize)];
        [ivDetail setContentMode:UIViewContentModeScaleAspectFit];
        [ivDetail setImage:[LyUtil imageForImageName:@"userInfo_QRCode" needCache:NO]];
        [ivDetail setClipsToBounds:YES];
        
        [lbDetail removeFromSuperview];
        [self addSubview:ivDetail];
    } else {
        [ivDetail removeFromSuperview];
        [self addSubview:lbDetail];
        [lbDetail setText:detail];
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
