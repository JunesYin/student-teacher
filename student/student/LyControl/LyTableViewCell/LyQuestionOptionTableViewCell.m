//
//  LyQuestionOptionTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyQuestionOptionTableViewCell.h"

#import "LyOption.h"
#import "LyUtil.h"


#define qotcellWidth                SCREEN_WIDTH
CGFloat const qotcellHeight = 50.0f;


CGFloat const qotcellHorizontalSpace = 20.0f;

CGFloat const qotcellHorizontalMargin = 5.0f;

CGFloat const qotcIvIconSize = 20.0f;

#define lbContentWidth              (qotcellWidth-qotcIvIconSize-qotcellHorizontalMargin-qotcellHorizontalSpace*2.0f)
#define lbContentHeight             qotcellHeight
#define lbContentFont               LyFont(13)


#define normalTextColor             LyBlackColor
#define rightTextColor              LyRightColor
#define errorTextColor              LyWrongColor

@interface LyQuestionOptionTableViewCell ()
{
    UIImageView             *ivIcon;
    
    UILabel                 *lbContent;
}
@end

@implementation LyQuestionOptionTableViewCell

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
    
    ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake( qotcellHorizontalSpace, qotcellHeight/2.0f-qotcIvIconSize/2.0f, qotcIvIconSize, qotcIvIconSize)];
    [self addSubview:ivIcon];
    
    lbContent = [[UILabel alloc] initWithFrame:CGRectMake( ivIcon.frame.origin.x+CGRectGetWidth(ivIcon.frame)+qotcellHorizontalMargin, 0, lbContentWidth, lbContentHeight)];
    [lbContent setTextAlignment:NSTextAlignmentLeft];
    [lbContent setFont:lbContentFont];
    [lbContent setTextColor:LyBlackColor];
    [lbContent setNumberOfLines:0];
    [self addSubview:lbContent];
    
    UIView *horizontalLineLowwer = [[UIView alloc] initWithFrame:CGRectMake( 0, qotcellHeight-LyHorizontalLineHeight, SCREEN_WIDTH, LyHorizontalLineHeight)];
    [horizontalLineLowwer setBackgroundColor:LyHorizontalLineColor];;
    [self addSubview:horizontalLineLowwer];
}


- (void)setOption:(LyOption *)option
{
    if ( !option)
    {
        return;
    }
    
    _option = option;
    
    [self setOptionIvIcon];
    
    [lbContent setText:[_option content]];

}



- (void)setOptionIvIcon
{
    NSString *strImageName = nil;
    
    switch ( [_option mode]) {
        case LyOptionMode_A: {
            strImageName = @"option_A";
            break;
        }
        case LyOptionMode_B: {
            strImageName = @"option_B";
            break;
        }
        case LyOptionMode_C: {
            strImageName = @"option_C";
            break;
        }
        case LyOptionMode_D: {
            strImageName = @"option_D";
            break;
        }
    }
    
    [ivIcon setImage:[LyUtil imageForImageName:strImageName needCache:NO]];
}


- (void)setMode:(LyQuestionOptionTableViewCellMode)mode
{
    _mode = mode;
    
    switch ( _mode) {
        case LyQuestionOptionTableViewCellMode_normal: {
            [lbContent setTextColor:normalTextColor];
            [self setOptionIvIcon];
            break;
        }
        case LyQuestionOptionTableViewCellMode_right: {
            [lbContent setTextColor:rightTextColor];
            [ivIcon setImage:[LyUtil imageForImageName:@"option_right" needCache:NO]];
            break;
        }
        case LyQuestionOptionTableViewCellMode_wrong: {
            [lbContent setTextColor:errorTextColor];
            [ivIcon setImage:[LyUtil imageForImageName:@"option_wrong" needCache:NO]];
            break;
        }
        default: {
            [lbContent setTextColor:normalTextColor];
            [self setOptionIvIcon];
            break;
        }
    }
}



- (void)setChoosed:(BOOL)choosed
{
    _choosed = choosed;
    if ( _choosed)
    {
        [lbContent setTextColor:Ly517ThemeColor];
        [ivIcon setImage:[LyUtil imageForImageName:@"option_choosed" needCache:NO]];
    }
    else
    {
        [lbContent setTextColor:normalTextColor];
        [self setOptionIvIcon];
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
