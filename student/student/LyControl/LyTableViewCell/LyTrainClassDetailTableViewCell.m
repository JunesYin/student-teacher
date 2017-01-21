//
//  LyTrainClassDetailTableViewCell.m
//  teacher
//
//  Created by Junes on 16/8/25.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyTrainClassDetailTableViewCell.h"

#import "LyUtil.h"

CGFloat const tcdcellHeight = 50.0f;


CGFloat const tcdtcLbTitleWidth = 90.0f;


@implementation LyTrainClassDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self ininAndLayoutSubviews];
    }
    
    return self;
}


- (void)ininAndLayoutSubviews
{
    [self setBackgroundColor:LyWhiteLightgrayColor];
    
    lbTitle = [UILabel new];
    [lbTitle setFont:LyFont(14)];
    [lbTitle setTextColor:LyBlackColor];
    [lbTitle setBackgroundColor:[UIColor whiteColor]];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbTitle];
    
    lbContent = [UILabel new];
    [lbContent setFont:LyFont(14)];
    [lbContent setTextColor:LyBlackColor];
    [lbContent setBackgroundColor:[UIColor whiteColor]];
    [lbContent setNumberOfLines:0];
    [self addSubview:lbContent];
}


- (void)setCellInfo:(NSString *)title content:(NSString *)content
{
    [self setBackgroundColor:LyWhiteLightgrayColor];
    
    [lbTitle setFrame:CGRectMake(0, 1, tcdtcLbTitleWidth, CGRectGetHeight(self.bounds)-2)];
    
    [lbTitle setText:title];
    
    
    [lbContent setFrame:CGRectMake(tcdtcLbTitleWidth+2, 1, SCREEN_WIDTH-tcdtcLbTitleWidth-2, CGRectGetHeight(self.bounds)-2)];
    if (![LyUtil validateString:content])
    {
        content = @"无";
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = horizontalSpace;//缩进
    style.firstLineHeadIndent = horizontalSpace;
    
    NSAttributedString *uContent = [[NSMutableAttributedString alloc] initWithString:content
                                                                          attributes:@{
                                                                                       NSParagraphStyleAttributeName:style
                                                                                       }];
    [lbContent setAttributedText:uContent];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
