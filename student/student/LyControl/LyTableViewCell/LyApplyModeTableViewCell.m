//
//  LyApplyModeTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/8.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyApplyModeTableViewCell.h"
#import "LyTrainClass.h"


CGFloat const amtcHeight = 70.0f;

#define amtcWidth                               (SCREEN_WIDTH-LyViewItemWidth)



CGFloat const ivFlagWidth = 20.0f;
CGFloat const ivFlagHeight = ivFlagWidth;

CGFloat const amtcLbTitleWidth = 100.0f;
CGFloat const amtcLbTitleHeight = 25.0f;
#define lbTitleFont                              LyFont(16)

CGFloat const lbDepositWidth = 80.0f;
CGFloat const lbDepositHeight = amtcLbTitleHeight;
#define lbDepositFont                           lbTitleFont


CGFloat const amtcLb517PriceWidth = amtcLbTitleWidth;
CGFloat const amtcLb517PriceHeight = 20.0f;
#define lb517PriceFont                          LyFont(12)

CGFloat const amtcLbOfficialPriceWidth = amtcLbTitleWidth;
CGFloat const amtcLbOfficialPriceHeight = amtcLb517PriceHeight;
#define lbOfficialPriceFont                     lb517PriceFont

CGFloat const lbFoldNumWidth = lbDepositWidth;
CGFloat const lbFoldNumHeight = amtcLb517PriceHeight;
#define lbFoldNumFont                           lb517PriceFont



@interface LyApplyModeTableViewCell ()
{
    UIImageView                     *ivSelectFlag;
    UILabel                         *lbTitle;
    UILabel                         *lbDeposit;
    UILabel                         *lb517Price;
    UILabel                         *lbOfficialPrice;
    UILabel                         *lbFoldNum;
}
@end


@implementation LyApplyModeTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [super setFrame:CGRectMake( 0, 0, amtcWidth, amtcHeight)];
        [self initAndAddSubview];
    }
    
    
    return self;
}



- (void)initAndAddSubview
{
    [self setSelectedBackgroundView:({
        UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [backgroudView setBackgroundColor:[UIColor clearColor]];
        backgroudView;
    })];
    
    ivSelectFlag = [[UIImageView alloc] initWithFrame:CGRectMake( 0, verticalSpace*2.0f, ivFlagWidth, ivFlagHeight)];
    [ivSelectFlag setContentMode:UIViewContentModeScaleAspectFit];
    [ivSelectFlag setImage:[LyUtil imageForImageName:@"amtc_deselect" needCache:NO]];
    [self addSubview:ivSelectFlag];
    
    
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake( ivSelectFlag.frame.origin.x+ivSelectFlag.frame.size.width+horizontalSpace, verticalSpace, amtcLbTitleWidth, amtcLbTitleHeight)];
    [lbTitle setTextColor:LyBlackColor];
    [lbTitle setFont:lbTitleFont];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbTitle];
    
    
    lbDeposit = [[UILabel alloc] initWithFrame:CGRectMake( lbTitle.frame.origin.x+CGRectGetWidth(lbTitle.frame)+horizontalSpace*2.0f, lbTitle.frame.origin.y, lbDepositWidth, lbDepositHeight)];
    [lbDeposit setTextColor:LyBlackColor];
    [lbDeposit setFont:lbDepositFont];
    [lbDeposit setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbDeposit];
    
    
    
    lb517Price = [[UILabel alloc] initWithFrame:CGRectMake( lbTitle.frame.origin.x, lbTitle.frame.origin.y+CGRectGetHeight(lbTitle.frame), amtcLb517PriceWidth, amtcLb517PriceHeight)];
    [lb517Price setTextColor:LyBlackColor];
    [lb517Price setFont:lb517PriceFont];
    [lb517Price setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lb517Price];
    
    
    lbFoldNum = [[UILabel alloc] initWithFrame:CGRectMake( lbDeposit.frame.origin.x, lb517Price.frame.origin.y, lbFoldNumWidth, lbFoldNumHeight)];
    [lbFoldNum setTextColor:Ly517ThemeColor];
    [lbFoldNum setFont:lbFoldNumFont];
    [lbFoldNum setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbFoldNum];
    
    
    
    lbOfficialPrice = [[UILabel alloc] initWithFrame:CGRectMake( lb517Price.frame.origin.x, lb517Price.frame.origin.y+CGRectGetHeight(lb517Price.frame), amtcLbOfficialPriceWidth, amtcLbOfficialPriceHeight)];
    [lbOfficialPrice setTextColor:LyBlackColor];
    [lbOfficialPrice setFont:lbOfficialPriceFont];
    [lbOfficialPrice setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbOfficialPrice];
}



- (void)setCellInfo:(LyTrainClass *)trainClass withApplyMode:(LyApplyMode)mode andDeposit:(double)deposit
{
    if ( !trainClass)
    {
        return;
    }
    
    _trainClass = trainClass;
    
//    float fDeposit = (deposit > 0) ? deposit : applyPrepayDeposit;
    
    
    NSString *str517Price;
    NSString *strDeposit;
    
    if ( LyApplyMode_whole == mode)
    {
        [lbTitle setText:lbApplyModeTitleWhole];
        strDeposit = [[NSString alloc] initWithFormat:@"%.0f元",  [_trainClass tc517WholePrice]];
        str517Price = [[NSString alloc] initWithFormat:@"517全包价%.0f元", [_trainClass tc517WholePrice]];
    }
    else if ( LyApplyMode_prepay == mode)
    {
        [lbTitle setText:lbApplyModeTitlePrepay];
        strDeposit = [[NSString alloc] initWithFormat:@"%.0f元", _trainClass.tc517PrePayDeposit];
        str517Price = [[NSString alloc] initWithFormat:@"517全包价%.0f元", [_trainClass tc517PrePayPrice]];
    }
    
    [lbDeposit setText:strDeposit];
    [lb517Price setText:str517Price];
    
    
    NSString *strOfficialPrice = [[NSString alloc] initWithFormat:@"官方价%.0f元", [_trainClass tcOfficialPrice]];
    [lbOfficialPrice setText:strOfficialPrice];
    
    
    switch ( mode) {
        case LyApplyMode_whole: {
            if ( [_trainClass tcOfficialPrice] - [_trainClass tc517WholePrice] > 1.0f)
            {
                NSString *strFoldNum = [[NSString alloc] initWithFormat:@"优惠%.0f元", [_trainClass tcOfficialPrice] - [_trainClass tc517WholePrice]];
                [lbFoldNum setText:strFoldNum];
                [lbFoldNum setHidden:NO];
            }
            else
            {
                [lbFoldNum setHidden:YES];
            }
            break;
        }
        case LyApplyMode_prepay: {
            if ( [_trainClass tcOfficialPrice] - [_trainClass tc517PrePayPrice] > 1.0f)
            {
                NSString *strFoldNum = [[NSString alloc] initWithFormat:@"优惠%.0f元", [_trainClass tcOfficialPrice] - [_trainClass tc517PrePayPrice]];
                [lbFoldNum setText:strFoldNum];
                [lbFoldNum setHidden:NO];
            }
            else
            {
                [lbFoldNum setHidden:YES];
            }
            break;
        }
    }
}







- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    if ( selected)
    {
        [ivSelectFlag setImage:[LyUtil imageForImageName:@"amtc_select" needCache:NO]];
    }
    else
    {
        [ivSelectFlag setImage:[LyUtil imageForImageName:@"amtc_deselect" needCache:NO]];
    }
}

@end
