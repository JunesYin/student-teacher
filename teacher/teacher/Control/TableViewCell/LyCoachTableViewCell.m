//
//  LyCoachTableViewCell.m
//  teacher
//
//  Created by Junes on 16/8/12.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyCoachTableViewCell.h"

#import "LyCoach.h"

#import "LyUtil.h"

CGFloat const coachtcellHeight = 100.0f;


CGFloat const coatcIvAvatarSize = 60.0f;
#define lbTrainBaseWidth                    (SCREEN_WIDTH/2.0f)
//CGFloat const lbItemHeight = 20.0f;


@interface LyCoachTableViewCell ()
{
    UIImageView                 *ivAvatar;
    UILabel                     *lbName;
    
    UILabel                     *lbStudentInfo;
    UILabel                     *lbOrderInfo;
    
    UILabel                     *lbTrainBase;
}
@end



@implementation LyCoachTableViewCell

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
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(horizontalSpace, coachtcellHeight/2.0f-coatcIvAvatarSize/2.0f, coatcIvAvatarSize, coatcIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [ivAvatar setClipsToBounds:YES];
    [ivAvatar.layer setCornerRadius:btnCornerRadius];
    [self addSubview:ivAvatar];
    
    lbName = [[UILabel alloc] initWithFrame:CGRectMake(ivAvatar.frame.origin.x+CGRectGetWidth(ivAvatar.frame)+horizontalSpace, ivAvatar.ly_y, SCREEN_WIDTH-horizontalSpace*3-CGRectGetWidth(ivAvatar.frame), lbItemHeight)];
    [lbName setFont:LyFont(16)];
    [lbName setTextColor:LyBlackColor];
    [lbName setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbName];
    
    lbStudentInfo = [[UILabel alloc] initWithFrame:CGRectMake(lbName.frame.origin.x, lbName.ly_y+CGRectGetHeight(lbName.frame), CGRectGetWidth(lbName.frame), lbItemHeight)];
    [lbStudentInfo setFont:LyFont(14)];
    [lbStudentInfo setTextColor:[UIColor darkGrayColor]];
    [lbStudentInfo setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbStudentInfo];
    
    lbOrderInfo = [[UILabel alloc] initWithFrame:CGRectMake(lbName.frame.origin.x, lbStudentInfo.ly_y+CGRectGetHeight(lbStudentInfo.frame), CGRectGetWidth(lbName.frame), lbItemHeight)];
    [lbOrderInfo setFont:LyFont(14)];
    [lbOrderInfo setTextColor:[UIColor darkGrayColor]];
    [lbOrderInfo setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbOrderInfo];
    
    lbTrainBase = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-lbTrainBaseWidth, lbStudentInfo.ly_y, lbTrainBaseWidth, lbItemHeight)];
    [lbTrainBase setFont:LyFont(14)];
    [lbTrainBase setTextColor:Ly517ThemeColor];
    [lbTrainBase setTextAlignment:NSTextAlignmentRight];
    [self addSubview:lbTrainBase];
}



- (void)setCoach:(LyCoach *)coach mode:(LyCoachTableViewCellMode)mode
{
    if (!coach)
    {
        return;
    }
    
    
    _coach = coach;
    
    
    if (!_coach.userAvatar)
    {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:_coach.userId]
                    placeholderImage:[LyUtil defaultAvatarForTeacher]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if (image)
                               {
                                   [_coach setUserAvatar:image];
                               }
                               else
                               {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:_coach.userId]
                                               placeholderImage:[LyUtil defaultAvatarForTeacher]
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                          if (image) {
                                                              [_coach setUserAvatar:image];
                                                          }
                                                      }];
                               }
                           }];
    }
    else
    {
        [ivAvatar setImage:_coach.userAvatar];
    }
    
    
    [lbName setText:_coach.userName];
//    [lbStudentInfo setText:[_coach teachingCountByString]];
//    [lbOrderInfo setText:[_coach monthOrderCountByString]];
    [lbStudentInfo setText:[_coach teachAllCountByString]];
    [lbOrderInfo setText:[_coach allOrderCountByString]];
    
    if (LyCoachTableViewCellMode_trainBaseDetail == _mode)
    {
        [lbTrainBase setHidden:YES];
    }
    else
    {
        [lbTrainBase setHidden:NO];
        [lbTrainBase setText:_coach.trainBaseName];
    }
}


- (void)setEditing:(BOOL)editing
{
    [super setEditing:editing];
    
    [self setCoach:_coach];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
