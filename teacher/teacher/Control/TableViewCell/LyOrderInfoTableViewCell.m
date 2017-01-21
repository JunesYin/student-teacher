//
//  LyOrderInfoTableViewCell.m
//  teacher
//
//  Created by Junes on 16/8/15.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyOrderInfoTableViewCell.h"

#import "LyCurrentUser.h"
#import "LyUserManager.h"
#import "LyOrder.h"

#import "LyUtil.h"


CGFloat const oitcellHeight = 100.0f;

CGFloat const oitcIvAvatarSize = 60.0f;


CGFloat const oitcLbTimeWidth = 70.0f;
CGFloat const oitcLbPayInfoWidth = oitcLbTimeWidth;

#define oitcLbNameWidthMax                  (SCREEN_WIDTH - oitcIvAvatarSize - horizontalSpace * 4 - oitcLbTimeWidth)


@interface LyOrderInfoTableViewCell ()
{
    UIImageView             *ivAvatar;
    UILabel                 *lbName;
    UILabel                 *lbTime;
    UILabel                 *lbApplyInfo;
    UILabel                 *lbPayInfo;
    UILabel                 *lbClassInfo;
    UILabel                 *lbSource;
}
@end


@implementation LyOrderInfoTableViewCell

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
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(horizontalSpace, oitcellHeight/2.0f-oitcIvAvatarSize/2.0f, oitcIvAvatarSize, oitcIvAvatarSize)];
    [ivAvatar.layer setCornerRadius:oitcIvAvatarSize/2.0f];
    [ivAvatar setClipsToBounds:YES];
    [self addSubview:ivAvatar];
    
    lbName = [[UILabel alloc] initWithFrame:CGRectMake(oitcIvAvatarSize + horizontalSpace * 2, ivAvatar.ly_y, oitcLbNameWidthMax, lbItemHeight)];
    [lbName setFont:LyFont(16)];
    [lbName setTextColor:LyBlackColor];
    [lbName setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbName];
    
    lbTime = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - horizontalSpace - oitcLbTimeWidth, lbName.ly_y, oitcLbTimeWidth, lbItemHeight)];
    [lbTime setFont:LyFont(12)];
    [lbTime setTextColor:[UIColor darkGrayColor]];
    [lbTime setTextAlignment:NSTextAlignmentRight];
    [self addSubview:lbTime];
    
    lbApplyInfo = [[UILabel alloc] initWithFrame:CGRectMake(lbName.frame.origin.x, lbName.ly_y + CGRectGetHeight(lbName.frame), oitcLbNameWidthMax, lbItemHeight)];
    [lbApplyInfo setFont:LyFont(14)];
    [lbApplyInfo setTextColor:[UIColor darkGrayColor]];
    [lbApplyInfo setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbApplyInfo];
    
    lbPayInfo = [[UILabel alloc] initWithFrame:CGRectMake(lbTime.frame.origin.x, lbApplyInfo.ly_y, oitcLbTimeWidth, lbItemHeight)];
    [lbPayInfo setFont:LyFont(14)];
    [lbPayInfo setTextColor:Ly517ThemeColor];
    [lbPayInfo setTextAlignment:NSTextAlignmentRight];
    [self addSubview:lbPayInfo];
    
    
//    lbClassInfo = [[UILabel alloc] initWithFrame:CGRectMake(lbApplyInfo.frame.origin.x, lbApplyInfo.ly_y + CGRectGetHeight(lbApplyInfo.frame), oitcLbNameWidthMax, lbItemHeight * 2)];
    lbClassInfo = [UILabel new];
    [lbClassInfo setFont:LyFont(14)];
    [lbClassInfo setTextColor:[UIColor darkGrayColor]];
    [lbClassInfo setTextAlignment:NSTextAlignmentLeft];
    [lbClassInfo setNumberOfLines:0];
    [self addSubview:lbClassInfo];
    
    lbSource = [[UILabel alloc] initWithFrame:CGRectMake(lbPayInfo.frame.origin.x, lbApplyInfo.ly_y + CGRectGetHeight(lbApplyInfo.frame), oitcLbTimeWidth, lbItemHeight)];
    [lbSource setFont:LyFont(10)];
    [lbSource setTextColor:[UIColor darkGrayColor]];
    [lbSource setTextAlignment:NSTextAlignmentRight];
    [self addSubview:lbSource];
}



- (void)setOrder:(LyOrder *)order {
    
    _order = order;
    if (!_order) {
        return;
    }
    
//    LyCoach *coach = [[LyUserManager sharedInstance] getCoachWithCoachId:_order.recipient];
    LyUser *student = [[LyUserManager sharedInstance] getUserWithUserId:_order.orderMasterId];
    if (!student) {
        NSString *strUserName = [LyUtil getUserNameWithUserId:_order.orderMasterId];
        
        student = [LyUser userWithId:_order.orderMasterId userNmae:strUserName];
        
        [[LyUserManager sharedInstance] addUser:student];
    }
    
    if (!student.userAvatar) {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:student.userId]
                    placeholderImage:[LyUtil defaultAvatarForStudent]
                           completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                               if (image) {
                                   [student setUserAvatar:image];
                               } else {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:student.userId]
                                               placeholderImage:[LyUtil defaultAvatarForStudent]
                                                      completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                                          if (image) {
                                                              [student setUserAvatar:image];
                                                          }
                                                      }];
                               }
                           }];
    } else {
        [ivAvatar setImage:student.userAvatar];
    }
    
    
    [lbName setText:student.userName];
    
    [lbTime setText:[LyUtil stringOnlyDateFromDate:_order.orderTime]];
    
    NSString *strApplyInfo = [[NSString alloc] initWithFormat:@"%@%.0f元", (LyApplyMode_whole == _order.orderApplyMode) ? @"付全款" : @"预付费", _order.orderPrice];
    [lbApplyInfo setText:strApplyInfo];
    
    NSString *strPayInfo = nil;
    switch (_order.orderState) {
        case LyOrderState_waitPay: {
            //            break;
        }
        case LyOrderState_waitConfirm: {
            strPayInfo = @"交易中";
            break;
        }
        case LyOrderState_waitEvalute: {
            //            break;
        }
        case LyOrderState_completed: {
            strPayInfo = @"交易成功";
            break;
        }
        case LyOrderState_cancel: {
            strPayInfo = @"交易关闭";
            break;
        }
    }
    [lbPayInfo setText:strPayInfo];
    
    
    CGSize sizeClassInfo = [_order.orderDetail sizeWithAttributes:@{NSFontAttributeName:lbClassInfo.font}];
    if (sizeClassInfo.width > oitcLbNameWidthMax) {
        sizeClassInfo.height = lbItemHeight * 2;
    } else {
        sizeClassInfo.height = lbItemHeight;
    }
    [lbClassInfo setFrame:CGRectMake(lbApplyInfo.frame.origin.x, lbSource.ly_y, oitcLbNameWidthMax, sizeClassInfo.height)];
    [lbClassInfo setText:_order.orderDetail];

    
    
    
    NSString *strSource = nil;
    if ([_order.orderObjectId isEqualToString:_order.recipient]) {
        strSource = @"来自学员";
    } else if (LyUserType_school == [LyCurrentUser curUser].userType) {
        strSource = @"来自驾校";
    } else {
        strSource = @"来自教练";
    }
    [lbSource setText:strSource];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
