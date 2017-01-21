//
//  LyExamHistoryTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/2.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyExamHistoryTableViewCell.h"
#import "LyExamHistory.h"
#import "LyUtil.h"



#define ehcellWidth                     SCREEN_WIDTH
CGFloat const ehcellHeight = 50.0f;

CGFloat const ehHorizontalSpace = 5.0f;
#define ehcellUsefulWidth               (ehcellWidth-ehHorizontalSpace*5)

#define lbFont                          LyFont(14)
#define lbTextColor                     LyBlackColor

#define lbIndexWidth                    (ehcellUsefulWidth*30/295.0f)
CGFloat const lbIndexHeight = ehcellHeight;

#define lbScoreWidth                    (ehcellUsefulWidth*55/295.0f)
CGFloat const lbScoreHeight = ehcellHeight;

#define ehLbTimeWidth                     (ehcellUsefulWidth*50/295.0f)
CGFloat const ehLbTimeHeight = ehcellHeight;

#define lbLevelWidth                    (ehcellUsefulWidth*70/295.0f)
CGFloat const lbLevelHeight = ehcellHeight;

#define lbDateWidth                     (ehcellUsefulWidth*90/295.0f)
CGFloat const lbDateHeight = ehcellHeight;


@interface LyExamHistoryTableViewCell ()
{
    
    UILabel                         *lbIndex;
    UILabel                         *lbScore;
    UILabel                         *lbTime;
    UILabel                         *lbLevel;
    UILabel                         *lbDate;
 
    UIColor                         *color;
}
@end


@implementation LyExamHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initAndLyaoutSubviews];
    }
    
    return self;
}



- (void)initAndLyaoutSubviews
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    lbIndex = [[UILabel alloc] initWithFrame:CGRectMake( ehHorizontalSpace, 0, lbIndexWidth, lbIndexHeight)];
    [lbIndex setFont:lbFont];
    [lbIndex setTextColor:lbTextColor];
    [lbIndex setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbIndex];
    
    lbScore = [[UILabel alloc] initWithFrame:CGRectMake( lbIndex.frame.origin.x+CGRectGetWidth(lbIndex.frame), 0, lbScoreWidth, lbScoreHeight)];
    [lbScore setFont:lbFont];
    [lbScore setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbScore];
    
    lbTime = [[UILabel alloc] initWithFrame:CGRectMake( lbScore.frame.origin.x+CGRectGetWidth(lbScore.frame)+ehHorizontalSpace, 0, ehLbTimeWidth, ehLbTimeHeight)];
    [lbTime setFont:lbFont];
    [lbTime setTextColor:lbTextColor];
    [lbTime setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbTime];
    
    lbLevel = [[UILabel alloc] initWithFrame:CGRectMake( lbTime.frame.origin.x+CGRectGetWidth(lbTime.frame)+ehHorizontalSpace, 0, lbLevelWidth, lbLevelHeight)];
    [lbLevel setFont:lbFont];
    [lbLevel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbLevel];
    
    lbDate = [[UILabel alloc] initWithFrame:CGRectMake( lbLevel.frame.origin.x+CGRectGetWidth(lbLevel.frame)+ehHorizontalSpace, 0, lbDateWidth, lbDateHeight)];
    [lbDate setFont:lbFont];
    [lbDate setTextColor:lbTextColor];
    [lbDate setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbDate];
    
    
    
//    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake( 0, ehcellHeight-LyHorizontalLineHeight, ehcellWidth, LyHorizontalLineHeight)];
//    [horizontalLine setBackgroundColor:LyHorizontalLineColor];
//    [self addSubview:horizontalLine];
    
    
    [self setColor:LyRedColor];
}


- (void)setColor:(UIColor *)aColor
{
    color = aColor;
    [lbScore setTextColor:color];
    [lbLevel setTextColor:color];
}




- (void)setIndex:(NSInteger)index
{
    _index = index;
    [lbIndex setText:[[NSString alloc] initWithFormat:@"%ld、", _index]];
}


- (void)setExamHistory:(LyExamHistory *)examHistory
{
    _examHistory = examHistory;
    [lbScore setText:[[NSString alloc] initWithFormat:@"%ld分", [_examHistory score]]];
    [lbTime setText:[_examHistory time]];
    [lbLevel setText:({
        NSString *strLevel;
        switch ( [_examHistory level]) {
            case LyExamLevel_killer: {
                strLevel = @"马路杀手";
                [self setColor:LyRedColor];
                break;
            }
            case LyExamLevel_newbird: {
                strLevel = @"勉强过关";
                [self setColor:LyOrangeColor];
                break;
            }
            case LyExamLevel_mass: {
                strLevel = @"轻松过关";
                [self setColor:LyBlueColor];
                break;
            }
            case LyExamLevel_superior: {
                strLevel = @"学车达人";
                [self setColor:LyGreenColor];
                break;
            }
        }
        strLevel;
    })];
    
//    [lbDate setText:[_examHistory date]];
    [lbDate setText:[[_examHistory date] substringToIndex:dateStringLength]];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
