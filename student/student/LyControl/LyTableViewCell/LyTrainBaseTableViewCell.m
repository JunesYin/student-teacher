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



#define tbcellWidth                         SCREEN_WIDTH
CGFloat const tbcellHeight = 70.0f;

#define tbtcLbNameWidth                         (tbcellWidth-horizontalSpace*2.0f)
CGFloat const tbtcLbNameHeight = 20.0f;
#define lbNameFont                          LyFont(14)


#define tbtcLbCoachCountWidth                   ((tbcellWidth-horizontalSpace*3)/2.0f)
CGFloat const tbtcLbCoachCountHeight = tbtcLbNameHeight;
#define lbCoachCountFont                    LyFont(13)

#define tbtcLbStudentCountWidth                 ((tbcellWidth-horizontalSpace*3)/2.0f)
CGFloat const tbtcLbStudentCountHeight = tbtcLbNameHeight;
#define lbStudentCountFont                  lbCoachCountFont

#define tbtcLbAddressWidth                      tbtcLbNameWidth
CGFloat const tbtcLbAddressHeight = tbtcLbNameHeight;
#define lbAddressFont                       lbCoachCountFont


@interface LyTrainBaseTableViewCell ()
{
    UILabel                 *lbName;
    UILabel                 *lbCoachCount;
    UILabel                 *lbStudentCount;
    UILabel                 *lbAddress;
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
        [self initSubviews];
    }
    
    return self;
}


- (void)initSubviews
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setBackgroundColor:[UIColor clearColor]];
    
    
    lbName = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, verticalSpace, tbtcLbNameWidth, tbtcLbNameHeight)];
    [lbName setFont:lbNameFont];
    [lbName setTextColor:Ly517ThemeColor];
    [lbName setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbName];
    
    
    lbCoachCount = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, lbName.frame.origin.y+CGRectGetHeight(lbName.frame), tbtcLbCoachCountWidth, tbtcLbCoachCountHeight)];
    [lbCoachCount setFont:lbCoachCountFont];
    [lbCoachCount setTextColor:LyDarkgrayColor];
    [lbCoachCount setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbCoachCount];
    
    
    lbStudentCount = [[UILabel alloc] initWithFrame:CGRectMake( lbCoachCount.frame.origin.x+CGRectGetWidth(lbCoachCount.frame)+horizontalSpace, lbCoachCount.frame.origin.y, tbtcLbStudentCountWidth, tbtcLbStudentCountHeight)];
    [lbStudentCount setFont:lbStudentCountFont];
    [lbStudentCount setTextColor:LyDarkgrayColor];
    [lbStudentCount setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbStudentCount];
    
    
    lbAddress = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, lbCoachCount.frame.origin.y+CGRectGetHeight(lbCoachCount.frame), tbtcLbAddressWidth, tbtcLbAddressHeight)];
    [lbAddress setFont:lbAddressFont];
    [lbAddress setTextColor:LyDarkgrayColor];
    [lbAddress setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbAddress];
}



- (void)setTrainBase:(LyTrainBase *)trainBase
{
    if ( !trainBase)
    {
        return;
    }
    
    _trainBase = trainBase;
    
    [lbName setText:[_trainBase tbName]];
    [lbCoachCount setText:[[NSString alloc] initWithFormat:@"教练人数：%ld", [_trainBase tbCoachCount]]];
    [lbStudentCount setText:[[NSString alloc] initWithFormat:@"学生人数：%ld", [_trainBase tbStudentCount]]];
    [lbAddress setText:({
        NSString *str;
        if ( ![_trainBase tbAddress] || [[_trainBase tbAddress] isKindOfClass:[NSNull class]] || [[_trainBase tbAddress] length] < 1 || [[_trainBase tbAddress] rangeOfString:@"(null)"].length > 0)
        {
            str = @"暂无地址";
        }
        else
        {
            str = [_trainBase tbAddress];
        }
        str;
    })];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
