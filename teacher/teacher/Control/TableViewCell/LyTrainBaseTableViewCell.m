//
//  LyTrainBaseTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/17.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyTrainBaseTableViewCell.h"

#import "LyTrainBase.h"

#import "LyUtil.h"



CGFloat const tbcellHeight = 80.0f;

#define tbtcLbNameWidth                         (SCREEN_WIDTH-horizontalSpace*2.0f)
CGFloat const tbtcLbNameHeight = 20.0f;
#define lbNameFont                          LyFont(14)

CGFloat const tbtcBtnFuncWidth = 60.0f;
CGFloat const btnFuncHeight = tbtcLbNameHeight;


#define lbCoachCountWidth                   ((SCREEN_WIDTH-horizontalSpace*3)/2.0f)
CGFloat const lbCoachCountHeight = tbtcLbNameHeight;
#define lbCoachCountFont                    LyFont(13)

#define lbStudentCountWidth                 lbCoachCountWidth
CGFloat const lbStudentCountHeight = tbtcLbNameHeight;
#define lbStudentCountFont                  lbCoachCountFont

#define lbAddressWidth                      tbtcLbNameWidth
CGFloat const lbAddressHeight = tbtcLbNameHeight;
#define lbAddressFont                       lbCoachCountFont

CGFloat const tbtcBtnDeleteWidth = 60.0f;
CGFloat const tbtcBtnDeleteHeight = 30.0f;


@interface LyTrainBaseTableViewCell ()
{
    UILabel                 *lbName;
    UIButton                *btnFunc;
    
    UILabel                 *lbCoachCount;
//    UILabel                 *lbStudentCount;
    UILabel                 *lbAddress;
    
//    UIButton                *btnDelete;
}
@end



@implementation LyTrainBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initAndLayoutSubviews];
    }
    
    return self;
}


- (void)initAndLayoutSubviews
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setBackgroundColor:[UIColor clearColor]];
    
    
    lbName = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, verticalSpace*2, tbtcLbNameWidth, tbtcLbNameHeight)];
    [lbName setFont:lbNameFont];
    [lbName setTextColor:Ly517ThemeColor];
    [lbName setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbName];
    
    btnFunc = [[UIButton alloc] initWithFrame:CGRectMake(horizontalSpace-horizontalSpace-tbtcBtnFuncWidth, lbName.ly_y, tbtcBtnFuncWidth, btnFuncHeight)];
    [btnFunc setImage:[LyUtil imageForImageName:@"tccell_btn_delete" needCache:NO] forState:UIControlStateNormal];
    [btnFunc addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnFunc];
    
    
    lbCoachCount = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, lbName.ly_y+CGRectGetHeight(lbName.frame), lbCoachCountWidth, lbCoachCountHeight)];
    [lbCoachCount setFont:lbCoachCountFont];
    [lbCoachCount setTextColor:[UIColor darkGrayColor]];
    [lbCoachCount setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbCoachCount];
    
    
//    lbStudentCount = [[UILabel alloc] initWithFrame:CGRectMake( SCREEN_WIDTH-horizontalSpace-lbStudentCountWidth, lbCoachCount.ly_y, lbStudentCountWidth, lbStudentCountHeight)];
//    [lbStudentCount setFont:lbStudentCountFont];
//    [lbStudentCount setTextColor:[UIColor darkGrayColor]];
//    [lbStudentCount setTextAlignment:NSTextAlignmentLeft];
//    [self addSubview:lbStudentCount];
    
    
    lbAddress = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, lbCoachCount.ly_y+CGRectGetHeight(lbCoachCount.frame), lbAddressWidth, lbAddressHeight)];
    [lbAddress setFont:lbAddressFont];
    [lbAddress setTextColor:[UIColor darkGrayColor]];
    [lbAddress setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbAddress];
    
    
//    btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-tbtcBtnDeleteWidth, tbcellHeight/2.0f-tbtcBtnDeleteHeight/2.0f, tbtcBtnDeleteWidth, tbtcBtnDeleteHeight)];
//    [btnDelete setImage:[LyUtil imageForImageName:@"btnDelete_red" needCache:NO] forState:UIControlStateNormal];
//    [btnDelete addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:btnDelete];
    
}



- (void)setTrainBase:(LyTrainBase *)trainBase
{
    if ( !trainBase)
    {
        return;
    }
    
    _trainBase = trainBase;
    
    [lbName setText:_trainBase.tbName];
    [lbCoachCount setText:[[NSString alloc] initWithFormat:@"教练人数：%d", _trainBase.tbCoachCount]];
//    [lbStudentCount setText:[[NSString alloc] initWithFormat:@"学生人数：%d", _trainBase.tbStudentCount]];
    [lbAddress setText:([LyUtil validateString:_trainBase.tbAddress]) ? _trainBase.tbAddress : @"暂无地址"];
}



- (void)targetForButton:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(onClickedDeleteByTrainBaseTableViewCell:)]) {
        [_delegate onClickedDeleteByTrainBaseTableViewCell:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
