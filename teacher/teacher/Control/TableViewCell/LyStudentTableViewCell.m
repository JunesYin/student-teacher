//
//  LyStudentTableViewCell.m
//  teacher
//
//  Created by Junes on 16/8/17.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyStudentTableViewCell.h"
#import "LyStudent.h"
#import "LyUtil.h"


CGFloat const stutcellHeight = 80.0f;

CGFloat const stcIvAvatarSize = 60.0f;
//CGFloat const lbItemHeight = 20.0f;

CGFloat const btnProgressWidth = 80.0f;
CGFloat const btnProgressHeight = 30.0f;


@interface LyStudentTableViewCell ()
{
    UIImageView                 *ivAvatar;
    
    UILabel                     *lbName;
    UILabel                     *lbPayInfo;
    UILabel                     *lbSchedule;
    
    UIButton                    *btnProgress;
}
@end


@implementation LyStudentTableViewCell

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
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(horizontalSpace, stutcellHeight/2.0f-stcIvAvatarSize/2.0f, stcIvAvatarSize, stcIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [ivAvatar.layer setCornerRadius:stcIvAvatarSize/2.0f];
    [ivAvatar setClipsToBounds:YES];
    [self addSubview:ivAvatar];
    
    lbName = [[UILabel alloc] initWithFrame:CGRectMake(ivAvatar.frame.origin.x+CGRectGetWidth(ivAvatar.frame)+horizontalSpace, ivAvatar.ly_y, SCREEN_WIDTH-horizontalSpace*4-btnProgressWidth, lbItemHeight)];
    [lbName setFont:LyFont(16)];
    [lbName setTextColor:LyBlackColor];
    [lbName setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbName];
    
    lbPayInfo = [[UILabel alloc] initWithFrame:CGRectMake(lbName.frame.origin.x, lbName.ly_y+CGRectGetHeight(lbName.frame), CGRectGetWidth(lbName.frame), lbItemHeight)];
    [lbPayInfo setFont:LyFont(14)];
    [lbPayInfo setTextColor:[UIColor darkGrayColor]];
    [lbPayInfo setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbPayInfo];
    
    lbSchedule = [[UILabel alloc] initWithFrame:CGRectMake(lbPayInfo.frame.origin.x, lbPayInfo.ly_y+CGRectGetHeight(lbPayInfo.frame), CGRectGetWidth(lbName.frame), lbItemHeight)];
    [lbSchedule setFont:LyFont(14)];
    [lbSchedule setTextColor:[UIColor darkGrayColor]];
    [lbSchedule setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbSchedule];
    
    btnProgress = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-btnProgressWidth, stutcellHeight/2.0f-btnProgressHeight/2.0f, btnProgressWidth, btnProgressHeight)];
    [btnProgress.titleLabel setFont:LyFont(14)];
    [btnProgress setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnProgress.layer setCornerRadius:btnProgressHeight/2.0f];
    [btnProgress.layer setBorderWidth:1.0f];
    [btnProgress.layer setBorderColor:[Ly517ThemeColor CGColor]];
    [btnProgress addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnProgress];
}



- (void)setMode:(LyStudentTableViewCellMode)mode {
    switch (mode) {
        case LyStudentTableViewCellMode_home: {
            [btnProgress setHidden:NO];
            [self setSelectionStyle:UITableViewCellSelectionStyleDefault];
            break;
        }
        case LyStudentTableViewCellMode_studentInfo: {
            [btnProgress setHidden:YES];
            [self setSelectionStyle:UITableViewCellSelectionStyleNone];
            break;
        }
    }
}


- (void)setStudent:(LyStudent *)student
{
    _student = student;
    
    
    if (_student.userAvatar)
    {
        [ivAvatar setImage:_student.userAvatar];
    }
    else
    {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:_student.userId]
                    placeholderImage:[LyUtil defaultAvatarForStudent]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if (image) {
                                   [_student setUserAvatar:image];
                               } else {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:_student.userId]
                                                placeholderImage:[LyUtil defaultAvatarForStudent]
                                                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                           if (image) {
                                                               [_student setUserAvatar:image];
                                                           }
                                                       }];
                               }
                           }];
    }
    
    [lbName setText:_student.userName];
    [lbPayInfo setText:[LyUtil payInfoStringFrom:_student.stuPayInfo]];
    [lbSchedule setText:_student.stuNote];
    
    [btnProgress setTitle:[LyUtil subjectModeStringFrom:_student.stuStudyProgress] forState:UIControlStateNormal];
}


- (void)targetForButton:(UIButton *)button
{
    if (button == btnProgress)
    {
        [_delegate onClickBttonProgressByStudentTableViewCell:self];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

