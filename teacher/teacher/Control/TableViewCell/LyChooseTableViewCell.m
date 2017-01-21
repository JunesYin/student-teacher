//
//  LyChooseTableViewCell.m
//  teacher
//
//  Created by Junes on 16/8/16.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyChooseTableViewCell.h"

#import "LyUtil.h"



CGFloat const choosetcellHeight = 50.0f;


CGFloat const cLbTitleWidth = 90.0f;



@interface LyChooseTableViewCell ()
{
    UILabel                 *lbTitle;
    UILabel                 *lbDetail;
    
    UIImageView             *ivMore;
}
@end


@implementation LyChooseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, cLbTitleWidth, choosetcellHeight)];
        [lbTitle setFont:LyFont(16)];
        [lbTitle setTextColor:LyBlackColor];
        [lbTitle setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:lbTitle];
        
        lbDetail = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace*2+cLbTitleWidth, 0, SCREEN_WIDTH-cLbTitleWidth-horizontalSpace*4-ivMoreSize, choosetcellHeight)];
        [lbDetail setFont:LyFont(14)];
        [lbDetail setTextColor:[UIColor darkGrayColor]];
        [lbDetail setTextAlignment:NSTextAlignmentRight];
        [lbDetail setNumberOfLines:0];
        [self addSubview:lbDetail];
        
        ivMore = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-ivMoreSize, choosetcellHeight/2.0f-ivMoreSize/2.0f, ivMoreSize, ivMoreSize)];
        [ivMore setImage:[LyUtil imageForImageName:@"ivMore" needCache:NO]];
        [self addSubview:ivMore];
    }
    
    return self;
}



- (void)setCellInfo:(NSString *)title detail:(NSString *)detail
{
    [lbTitle setText:title];
    
    [self setDetail:detail];
}


- (void)setDetail:(NSString *)detail
{
    _detail = detail;
    
    [lbDetail setText:_detail];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
