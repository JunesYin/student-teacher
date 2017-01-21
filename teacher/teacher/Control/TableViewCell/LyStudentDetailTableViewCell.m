//
//  LyStudentDetailTableViewCell.m
//  teacher
//
//  Created by Junes on 16/8/17.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyStudentDetailTableViewCell.h"

#import "UILabel+LyTextAlignmentLeftAndRight.h"

#import "LyStudent.h"

#import "LyUtil.h"


CGFloat const sdtcellHeight = 50.0f;
NSString *const sdCensusTitle = @"户籍地区";
NSString *const sdAddressTitle = @"地址";
NSString *const sdTrainClassNameTitle = @"培训课程";
NSString *const sdPayInfoTitle = @"付款情况";
NSString *const sdStudyProgressTitle = @"学车进度";
NSString *const sdRemarkTitle = @"备注";


#define lbDetailWidth                   (SCREEN_WIDTH-horizontalSpace*3-LyLbTitleItemWidth)

@interface LyStudentDetailTableViewCell ()
{
    UILabel             *lbTitle;
    
    UILabel             *lbContent;
}
@end

@implementation LyStudentDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initAndLayoutSubviews];
    }
    
    return self;
}


- (void)initAndLayoutSubviews
{
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, LyLbTitleItemWidth, sdtcellHeight)];
    [lbTitle setFont:LyFont(16)];
    [lbTitle setTextColor:LyBlackColor];
    [self addSubview:lbTitle];
    
    lbContent = [[UILabel alloc] initWithFrame:CGRectMake(lbTitle.frame.origin.x+CGRectGetWidth(lbTitle.frame)+horizontalSpace, 0, lbDetailWidth, sdtcellHeight)];
    [lbContent setFont:LyFont(14)];
    [lbContent setTextColor:[UIColor darkGrayColor]];
    [lbContent setTextAlignment:NSTextAlignmentRight];
    [lbContent setNumberOfLines:0];
    [self addSubview:lbContent];
}


- (void)setCellInfo:(LyStudentDetailTableViewCellMode)mode content:(LyStudent *)student
{
    switch (mode) {
        case LyStudentDetailTableViewCellMode_census: {
            [lbTitle setText:sdCensusTitle];
            [lbContent setText:student.stuCensus];
            break;
        }
        case LyStudentDetailTableViewCellMode_address: {
            [lbTitle setText:sdAddressTitle];
            [lbContent setText:student.stuPickAddress];
            break;
        }
        case LyStudentDetailTableViewCellMode_trainClassName: {
            [lbTitle setText:sdTrainClassNameTitle];
            [lbContent setText:student.stuTrainClassName];
            break;
        }
        case LyStudentDetailTableViewCellMode_payInfo: {
            [lbTitle setText:sdPayInfoTitle];
            [lbContent setText:[LyUtil payInfoStringFrom:student.stuPayInfo]];
            break;
        }
        case LyStudentDetailTableViewCellMode_studyProgress: {
            [lbTitle setText:sdStudyProgressTitle];
            [lbContent setText:[LyUtil subjectModeStringFrom:student.stuStudyProgress]];
            break;
        }
        case LyStudentDetailTableViewCellMode_remark: {
            [lbTitle setText:sdRemarkTitle];
            [lbContent setText:student.stuNote];
            break;
        }
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
