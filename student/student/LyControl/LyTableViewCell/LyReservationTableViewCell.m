//
//  LyReservationTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/18.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyReservationTableViewCell.h"


#import "LyReservation.h"
#import "LyOrderManager.h"
#import "LyUserManager.h"

#import "LyUtil.h"



#define rescellWidth                            SCREEN_WIDTH
CGFloat const rescellHeight = 80.0f;

//教练头像
CGFloat const rtcIvAvatarSize = 50.0f;

//教练名
#define rtcLbNameWidth                             (rescellWidth-horizontalSpace-rtcIvAvatarSize-rtcLbTimeWidth-horizontalSpace*1.5f)
CGFloat const rtcLbNameHeight = 20.0f;
#define lbNameFont                              LyFont(14)
#define lbNameTextColor                         LyBlackColor

//预约时间
#define rtcLbTimeWidth                             [@"2016年03月22日 15:33" sizeWithAttributes:@{NSFontAttributeName:lbTimeFont}].width
CGFloat const rtcLbTimeHeight = rtcLbNameHeight;
#define lbTimeFont                              LyFont(11)
#define lbTimeTextColor                         LyLightgrayColor


//学车时间
#define lbDurationWidth                         (rescellWidth-horizontalSpace-rtcIvAvatarSize-lbStateWidth-horizontalSpace*2.0f)
CGFloat const lbDurationHeight = 30.0f;
#define lbDurationFont                          LyFont(12)
#define lbDurationTextColor                     LyGrayColor

//状态
#define lbStateWidth                            rtcLbTimeWidth
CGFloat const lbStateHeight = rtcLbNameHeight;
#define lbStateFont                             LyFont(13)

//提示
#define rtcLbRemindWidth                           (rescellWidth-horizontalSpace*2.0f)
CGFloat const rtcLbRemindHeight = 15.0f;
#define lbRemindFont                            LyFont(12)


@interface LyReservationTableViewCell ()
{
    UIImageView                         *ivAvatar;
    
    UILabel                             *lbName;
    
    UILabel                             *lbTime;
    
    UILabel                             *lbDuration;
    
    UILabel                             *lbState;
    
//    UILabel                             *lbPrice;
    
    UILabel                             *lbRemind;
}
@end


@implementation LyReservationTableViewCell

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
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake( horizontalSpace, verticalSpace, rtcIvAvatarSize, rtcIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [[ivAvatar layer] setCornerRadius:rtcIvAvatarSize/2.0f];
    [ivAvatar setClipsToBounds:YES];
    [self addSubview:ivAvatar];
    
    
    
    lbName = [[UILabel alloc] initWithFrame:CGRectMake( ivAvatar.frame.origin.x+CGRectGetWidth(ivAvatar.frame)+horizontalSpace*0.5f, ivAvatar.frame.origin.y, rtcLbNameWidth, rtcLbNameHeight)];
    [lbName setFont:lbNameFont];
    [lbName setTextColor:lbNameTextColor];
    [lbName setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbName];
    
    
    lbTime = [[UILabel alloc] initWithFrame:CGRectMake( rescellWidth-horizontalSpace*0.5f-rtcLbTimeWidth, ivAvatar.frame.origin.y, rtcLbTimeWidth, rtcLbTimeHeight)];
    [lbTime setFont:lbTimeFont];
    [lbTime setTextColor:lbTimeTextColor];
    [lbTime setTextAlignment:NSTextAlignmentRight];
    [self addSubview:lbTime];
    
    
    lbDuration = [[UILabel alloc] initWithFrame:CGRectMake( lbName.frame.origin.x, ivAvatar.frame.origin.y+CGRectGetHeight(ivAvatar.frame)-lbDurationHeight, lbDurationWidth, lbDurationHeight)];
    [lbDuration setFont:lbDurationFont];
    [lbDuration setTextColor:lbDurationTextColor];
    [lbDuration setTextAlignment:NSTextAlignmentLeft];
    [lbDuration setNumberOfLines:0];
    [self addSubview:lbDuration];
    
    
    lbState = [[UILabel alloc] initWithFrame:CGRectMake( rescellWidth-horizontalSpace-lbStateWidth, lbDuration.frame.origin.y, lbDurationWidth, lbDurationHeight)];
    [lbState setFont:lbStateFont];
    [lbState setTextColor:LyGrayColor];
    [lbState setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbState];
    
    
    UIView *horizontalLineCenter = [[UIView alloc] initWithFrame:CGRectMake( lbName.frame.origin.x, lbDuration.frame.origin.y+CGRectGetHeight(lbDuration.frame)+verticalSpace-LyHorizontalLineHeight, rescellWidth-lbName.frame.origin.x, LyHorizontalLineHeight)];
    [horizontalLineCenter setBackgroundColor:LyHorizontalLineColor];
    [self addSubview:horizontalLineCenter];
    
    
    lbRemind = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, horizontalLineCenter.frame.origin.y+CGRectGetHeight(horizontalLineCenter.frame)+verticalSpace, rtcLbRemindWidth, rtcLbRemindHeight)];
    [lbRemind setFont:lbRemindFont];
    [lbRemind setTextColor:LyLightgrayColor];
    [lbRemind setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbRemind];
    
    
    
    UIView *horizontalLineLower = [[UIView alloc] initWithFrame:CGRectMake( 0, rescellHeight-LyHorizontalLineHeight, rescellWidth, LyHorizontalLineHeight)];
    [horizontalLineLower setBackgroundColor:LyHorizontalLineColor];
    [self addSubview:lbRemind];
    
}




- (void)setReservation:(LyReservation *)reservation
{
    if ( !reservation || [NSNull null] == (NSNull *)reservation)
    {
        return;
    }
    
    _reservation = reservation;
    
    LyCoach *coach = [[LyUserManager sharedInstance] getCoachWithCoachId:[_reservation resObjectId]];
    LyOrder *order = [[LyOrderManager sharedInstance] getOrderWidthOrderId:[_reservation resOrderId]];
    
    if ( ![coach userAvatar])
    {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:[_reservation resObjectId]]
                    placeholderImage:[LyUtil defaultAvatarForStudent]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if (image)
                               {
                                   [coach setUserAvatar:image];
                               }
                               else
                               {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:[_reservation resObjectId]]
                                                       placeholderImage:[LyUtil defaultAvatarForTeacher]
                                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                  if (image)
                                                                  {
                                                                      [coach setUserAvatar:image];
                                                                  }
                                                              }];
                               }
                           }];
    }
    else
    {
        [ivAvatar setImage:[coach userAvatar]];
    }
    
    
    [lbName setText:[coach userName]];
    
    [lbTime setText:[LyUtil cutTimeString:[order orderTime]]];
    
    [lbDuration setText:[_reservation resDuration]];
    
    
    NSString *strLbState;
    NSString *strLbRemind;
    switch ( [order orderState]) {
        case LyOrderState_waitPay: {
            strLbState = @"预约失效";
            [lbState setTextColor:LyLightgrayColor];
            
            strLbRemind = @"对不起，你示按时学车，本次预约已失效";
            [lbRemind setTextColor:LyLightgrayColor];
            break;
        }
        case LyOrderState_waitConfirm: {
            strLbState = @"预约成功";
            [lbState setTextColor:Ly517ThemeColor];
            
            strLbRemind = @"记得按时学车哦";
            [lbRemind setTextColor:Ly517ThemeColor];
            break;
        }
        case LyOrderState_waitEvalute: {
            strLbState = @"学车完成";
            [lbState setTextColor:LyBlackColor];
            
            strLbRemind = @"学车完成了，赶紧预约下次学车吧";
            [lbRemind setTextColor:Ly517ThemeColor];
            break;
        }
        case LyOrderState_completed: {
            strLbState = @"学车完成";
            [lbState setTextColor:LyBlackColor];
            
            strLbRemind = @"学车完成了，赶紧预约下次学车吧";
            [lbRemind setTextColor:Ly517ThemeColor];
            break;
        }
        case LyOrderState_cancel: {
            strLbState = @"预约失效";
            [lbState setTextColor:LyLightgrayColor];
            
            strLbRemind = @"对不起，你示按时学车，本次预约已失效";
            [lbRemind setTextColor:LyLightgrayColor];
            break;
        }
        default: {
            strLbState = @"预约失效";
            [lbState setTextColor:LyLightgrayColor];
            
            strLbRemind = @"对不起，你示按时学车，本次预约已失效";
            [lbRemind setTextColor:LyLightgrayColor];
            break;
        }
    }
    [lbState setText:strLbState];
    
    
    [lbRemind setText:strLbRemind];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
