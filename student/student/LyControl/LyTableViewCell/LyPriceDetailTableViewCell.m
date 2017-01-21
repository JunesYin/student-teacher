//
//  LyPriceDetailTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyPriceDetailTableViewCell.h"
#import "LyPriceDetail.h"

#import "LyUtil.h"


CGFloat const pdcellHeight = 30.0f;


#define lbItemFont                              LyFont(12)


CGFloat const pdLbTimeWidth = 100.0f;
CGFloat const pdLbTimeHeight = pdcellHeight;


CGFloat const pdLbPriceWidth = pdLbTimeWidth;
CGFloat const pdLbPriceHeight = pdLbTimeHeight;


CGFloat const pdBtnItemWidth = 50.0f;
CGFloat const pdBtnItemHeight = pdcellHeight;


enum {
    priceDetailTableViewCellButtonTag_modify,
    priceDetailTableViewCellButtonTag_delete
}LyPriceDetailTableViewCellButtonTag;


@interface LyPriceDetailTableViewCell ()
{
    UILabel                     *lbTime;
    UILabel                     *lbPrice;
    
    UIButton                    *btnDelete;
}
@end


@implementation LyPriceDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}




- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initSubviews];
    }
    
    return self;
}



- (void)initSubviews
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];

    lbTime = [[UILabel alloc] initWithFrame:CGRectMake( SCREEN_WIDTH/2.0f/3.0f, 0, SCREEN_WIDTH/2.0f*2.0f/3.0f, pdLbTimeHeight)];
    [lbTime setFont:lbItemFont];
    [lbTime setTextColor:[UIColor darkGrayColor]];
    [lbTime setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbTime];
    
    lbPrice = [[UILabel alloc] initWithFrame:CGRectMake( SCREEN_WIDTH/2.0f+SCREEN_WIDTH/2.0f/3.0f, 0, SCREEN_WIDTH/2.0f*2.0f/3.0f, pdLbTimeHeight)];
    [lbPrice setFont:lbItemFont];
    [lbPrice setTextColor:[UIColor darkGrayColor]];
    [lbPrice setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbPrice];
    
    
//    lbTime = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace*2, 0, pdLbTimeWidth, pdLbTimeHeight)];
//    [lbTime setFont:lbItemFont];
//    [lbTime setTextColor:[UIColor darkGrayColor]];
//    [lbTime setTextAlignment:NSTextAlignmentLeft];
//    [self addSubview:lbTime];
//    
//    lbPrice = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace*3+pdLbTimeWidth, 0, pdLbPriceWidth, pdLbPriceHeight)];
//    [lbPrice setFont:lbItemFont];
//    [lbPrice setTextColor:[UIColor darkGrayColor]];
//    [lbPrice setTextAlignment:NSTextAlignmentLeft];
//    [self addSubview:lbPrice];
    
}



- (void)setCellInfo:(NSString *)time andPrice:(NSString *)price {
    [lbTime setText:time];
    [lbPrice setText:price];
}


- (void)setEditing:(BOOL)editing {
    [super setEditing:editing];
    
    if (editing) {
        
        [lbTime setFrame:CGRectMake(horizontalSpace*2, 0, pdLbTimeWidth, pdLbTimeHeight)];
        [lbPrice setFrame:CGRectMake(horizontalSpace*3+pdLbTimeWidth, 0, pdLbPriceWidth, pdLbPriceHeight)];
        
        
        if (!btnDelete) {
            btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-pdBtnItemWidth, 0, pdBtnItemWidth, pdBtnItemHeight)];
            [btnDelete setTag:priceDetailTableViewCellButtonTag_delete];
            [btnDelete.titleLabel setFont:LyFont(12)];
            [btnDelete setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [btnDelete setTitle:@"删除" forState:UIControlStateNormal];
            [btnDelete addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
        }


        [self addSubview:btnDelete];
    } else {
        
        [lbTime setFrame:CGRectMake( SCREEN_WIDTH/2.0f/3.0f, 0, SCREEN_WIDTH/2.0f*2.0f/3.0f, pdLbTimeHeight)];
        [lbPrice setFrame:CGRectMake( SCREEN_WIDTH/2.0f+SCREEN_WIDTH/2.0f/3.0f, 0, SCREEN_WIDTH/2.0f*2.0f/3.0f, pdLbTimeHeight)];
        
        [btnDelete removeFromSuperview];
        btnDelete = nil;
    }
}


- (void)setPriceDetail:(LyPriceDetail *)priceDetail {// isEditing:(BOOL)isEditing {
    
    if ( !priceDetail) {
        return;
    }
    
    _priceDetail = priceDetail;
    
    NSString *strTimeBegin = [[NSString alloc] initWithFormat:@"%d:%@",
                               [_priceDetail pdTimeBucket].begin/2,
                              (0 == ([_priceDetail pdTimeBucket].begin)%2) ? @"00" : @"30"];
    
    NSString *strTimeEnd = [[NSString alloc] initWithFormat:@"%d:%@",
                            [_priceDetail pdTimeBucket].end/2,
                            (0 == ([_priceDetail pdTimeBucket].end)%2) ? @"00" : @"30"];
    
    NSString *strTime = [[NSString alloc] initWithFormat:@"%@-%@", strTimeBegin, strTimeEnd];
    
    [lbTime setText:strTime];
    [lbPrice setText:[[NSString alloc] initWithFormat:@"%.0f元/小时", [_priceDetail pdPrice]]];
    


}


- (void)targetForButton:(UIButton *)button {
    if (priceDetailTableViewCellButtonTag_delete == button.tag) {
        [_delegate onClickedBtnDeleteByPriceDetailTableViewCell:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
