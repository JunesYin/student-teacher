//
//  LyOrderInfoTableViewCell.m
//  student
//
//  Created by Junes on 2016/11/24.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyOrderInfoTableViewCell.h"

#import "LyUtil.h"



CGFloat const oitcHeight = 50.0f;


@interface LyOrderInfoTableViewCell ()
{
    UILabel                 *lbTitle;
    
    UILabel                 *lbDetail;
}
@end



@implementation LyOrderInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, LyLbTitleItemWidth, oitcHeight)];
    [lbTitle setFont:LyFont(16)];
    [lbTitle setTextColor:[UIColor blackColor]];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    
    lbDetail = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace * 2 + LyLbTitleItemWidth, 0, SCREEN_WIDTH - LyLbTitleItemWidth - horizontalSpace * 3, oitcHeight)];
    [lbDetail setFont:LyFont(14)];
    [lbDetail setTextColor:[UIColor darkGrayColor]];
    [lbDetail setNumberOfLines:0];
    [self setMode:LyOrderInfoTableViewCellMode_orderInfo];
    
    [self addSubview:lbTitle];
    [self addSubview:lbDetail];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellInfo:(NSString *)title detail:(NSString *)detail {
    [lbTitle setText:title];
    [lbDetail setText:detail];
}

- (void)setMode:(LyOrderInfoTableViewCellMode)mode
{
    _mode = mode;
    
    switch (_mode) {
        case LyOrderInfoTableViewCellMode_orderInfo:{
            [lbDetail setTextAlignment:NSTextAlignmentLeft];
            break;
        }
        case LyOrderInfoTableViewCellMode_paySuccess: {
            [lbDetail setTextAlignment:NSTextAlignmentRight];
            break;
        }
    }
}

@end
