//
//  LyReservationDetailTableViewCell.m
//  teacher
//
//  Created by Junes on 2016/9/26.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyReservationDetailTableViewCell.h"

#import "LyUtil.h"


CGFloat const rdtcellHeight = 50.0f;



@interface LyReservationDetailTableViewCell ()
{
    UILabel     *lbTitle;
    UILabel     *lbDetail;
}
@end


@implementation LyReservationDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, LyLbTitleItemWidth, rdtcellHeight)];
        [lbTitle setFont:LyFont(16)];
        [lbTitle setTextColor:[UIColor blackColor]];
        [lbTitle setTextAlignment:NSTextAlignmentCenter];
        
        
        lbDetail = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace*2+LyLbTitleItemWidth, 0, SCREEN_WIDTH-horizontalSpace*2-LyLbTitleItemWidth, rdtcellHeight)];
        [lbDetail setFont:LyFont(14)];
        [lbDetail setTextColor:LyBlackColor];
        [lbDetail setTextAlignment:NSTextAlignmentLeft];
        [lbDetail setNumberOfLines:0];
        
        [self addSubview:lbTitle];
        [self addSubview:lbDetail];
    }
    
    return self;
}


- (void)setTitle:(NSString *)title {
    _title = title;
    if (![LyUtil validateString:_title]) {
        _title = @"";
    }
    
    [lbTitle setText:_title];
}

- (void)setDetail:(NSString *)detail {
    _detail = detail;
    if (![LyUtil validateString:_detail]) {
        _detail = @"";
    }
    
    [lbDetail setText:_detail];
}


- (void)setCellInfo:(NSString *)title detail:(NSString *)detail {
    [self setTitle:title];
    [self setDetail:detail];
}


@end
