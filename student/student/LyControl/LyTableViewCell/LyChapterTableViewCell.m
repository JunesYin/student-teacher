//
//  LyChapterTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/11.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyChapterTableViewCell.h"

#import "LyChapter.h"
#import "LyUtil.h"



#define chaptcWidth                                     SCREEN_WIDTH
CGFloat const chaptcHeight = 60.0f;


#define ivIconWidth                                     (chaptcHeight*3/5)
#define ivIconHeight                                    ivIconWidth


#define lbTitleWidth                                    (chaptcWidth-ivIconWidth-horizontalSpace*3)
#define lbTitleHeight                                   chaptcHeight
#define lbTitlFont                                      LyFont(14)

#define lbTitleProgressTextColor                        LyLightgrayColor




@interface LyChapterTableViewCell ()
{
    UIImageView                             *ivIcon;
    UILabel                                 *lbTitle;
}
@end



@implementation LyChapterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}




- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initAndAddSubView];
    }
    
    
    return self;
}




- (void)initAndAddSubView
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake( horizontalSpace, chaptcHeight/2-ivIconHeight/2, ivIconWidth, ivIconHeight)];
    [ivIcon setContentMode:UIViewContentModeScaleAspectFit];
    
    
    
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake( ivIcon.frame.origin.x+ivIcon.frame.size.width, 0, lbTitleWidth, lbTitleHeight)];
    [lbTitle setTextColor:LyBlackColor];
    [lbTitle setNumberOfLines:0];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    [lbTitle setFont:lbTitlFont];
    
    
    [self addSubview:ivIcon];
    [self addSubview:lbTitle];
}




- (void)setCellInfoWithMode:(LyChapterTableViewCellMode)mode chapter:(LyChapter *)chapter
{
    if ( LyChapterTableViewCellMode_chapter != mode)
    {
        return;
    }
    
    if ( !chapter)
    {
        return;
    }
    
    _mode = mode;
    _chapter = chapter;
    
    NSInteger iconIndex = [_chapter chapterMode] % 4;
    
    [ivIcon setImage:[LyUtil imageForImageName:[[NSString alloc] initWithFormat:@"chap_item_%ld", iconIndex] needCache:NO]];
    
    NSString *strProgress = [[NSString alloc] initWithFormat:@"（%ld/%ld）", [_chapter index], [_chapter chapterNum]];
    NSString *strLbTitleTmp = [[NSString alloc] initWithFormat:@"%@%@", [_chapter chapterName], strProgress];
    NSRange rangeProgress = [strLbTitleTmp rangeOfString:strProgress];
    NSMutableAttributedString *strLbTitle = [[NSMutableAttributedString alloc] initWithString:strLbTitleTmp];
    [strLbTitle addAttribute:NSForegroundColorAttributeName value:lbTitleProgressTextColor range:rangeProgress];
    
    [lbTitle setAttributedText:strLbTitle];
    
    
}


- (void)setCellTitleWithMode:(LyChapterTableViewCellMode)mode title:(NSString *)title allCount:(NSInteger)allCount andIndex:(NSInteger)index
{
    if ( LyChapterTableViewCellMode_chapter == mode)
    {
        return;
    }
    
    _mode = mode;
    
    NSInteger iconIndex = index % 4;
    [ivIcon setImage:[LyUtil imageForImageName:[[NSString alloc] initWithFormat:@"chap_item_%ld", iconIndex] needCache:NO]];
    
    
    NSString *strNum;
    if ( LyChapterTableViewCellMode_myMistake == _mode && 1 == index)
    {
        strNum = @"";
    }
    else
    {
        strNum = [[NSString alloc] initWithFormat:@"（%ld）", allCount];
    }
    NSString *strLbTitleTmp = [[NSString alloc] initWithFormat:@"%@%@", title, strNum];
    NSRange rangeNum = [strLbTitleTmp rangeOfString:strNum];
    NSMutableAttributedString *strLbTitle = [[NSMutableAttributedString alloc] initWithString:strLbTitleTmp];
    [strLbTitle addAttribute:NSForegroundColorAttributeName value:lbTitleProgressTextColor range:rangeNum];
    
    [lbTitle setAttributedText:strLbTitle];
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
