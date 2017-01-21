//
//  LyStudentInfoTableViewCell.m
//  teacher
//
//  Created by Junes on 16/8/13.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyStudentInfoTableViewCell.h"
#import "LyUser.h"
#import "LyUtil.h"


CGFloat const sitcellHeight = 80.0f;

CGFloat const sitcIvAvatarSize = 60.0f;

//CGFloat const lbItemHeight = 20.0f;



@interface LyStudentInfoTableViewCell ()
{
    UIImageView             *ivAvatar;
    
    UILabel                 *lbName;
    UILabel                 *lbPayInfo;
    UILabel                 *lbStudentInfo;
}
@end


@implementation LyStudentInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initAndLyaoutSubviews];
    }
    
    return self;
}


- (void)initAndLyaoutSubviews
{
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(horizontalSpace, sitcellHeight/2.0f-sitcIvAvatarSize/2.0f, sitcIvAvatarSize, sitcIvAvatarSize)];
    [ivAvatar.layer setCornerRadius:sitcIvAvatarSize/2.0f];
    [self addSubview:ivAvatar];
    
    
    lbName = [[UILabel alloc] initWithFrame:CGRectMake(ivAvatar.frame.origin.x+CGRectGetWidth(ivAvatar.frame)+horizontalSpace, ivAvatar.ly_y, SCREEN_WIDTH-horizontalSpace*3-sitcIvAvatarSize, lbItemHeight)];
    [lbName setFont:LyFont(16)];
    [lbName setTextColor:LyBlackColor];
    [lbName setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbName];
    
    lbPayInfo = [[UILabel alloc] initWithFrame:CGRectMake(lbName.frame.origin.x, lbName.ly_y+CGRectGetHeight(lbName.frame), CGRectGetWidth(lbName.frame), lbItemHeight)];
    [lbPayInfo setFont:LyFont(14)];
    [lbPayInfo setTextColor:[UIColor darkGrayColor]];
    [lbPayInfo setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbPayInfo];
    
    lbStudentInfo = [[UILabel alloc] initWithFrame:CGRectMake(lbName.frame.origin.x, lbPayInfo.ly_y+CGRectGetHeight(lbPayInfo.frame), CGRectGetWidth(lbName.frame), lbItemHeight)];
    [lbStudentInfo setFont:LyFont(14)];
    [lbStudentInfo setTextColor:[UIColor darkGrayColor]];
    [lbStudentInfo setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbStudentInfo];
}



- (void)setStudent:(LyUser *)student
{
    _student = student;
    
    if (!_student.userAvatar)
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
    } else {
        [ivAvatar setImage:_student.userAvatar];
    }
    
    [lbName setText:_student.userName];
//    [lbPayInfo setText:_student.user]
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
