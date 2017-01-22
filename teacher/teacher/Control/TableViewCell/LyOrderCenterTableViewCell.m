//
//  LyOrderCenterTableViewCell.m
//  teacher
//
//  Created by Junes on 16/8/15.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyOrderCenterTableViewCell.h"
#import "LyOrder.h"

#import "LyCurrentUser.h"
#import "LyUserManager.h"

#import "LyUtil.h"


CGFloat const octcellHeight = 155.0f;
//CGFloat const octcellHeight_guider = 100.0f;

#define lbTextFont                                  LyFont(14)


//订单状态等信息

CGFloat const octcViewStatusHeight = 30.0f;
//订单种类
CGFloat const ivModeWidth = 60.0f;
CGFloat const ivModeHeight = 20.0f;

//订单状态
CGFloat const lbStatusWidth = 60.0f;
CGFloat const octcLbStatusHeight = octcViewStatusHeight;
#define lbStatusFont                           LyFont(12)


//商品信息
CGFloat const octcViewInfoHeight = 80.0f;
//商品图
CGFloat const octcIvAvatarSize = 45.0f;
//商品所属//商品名//详情//价格//实付价格
//CGFloat const lbItemHeight = 20.0f;


//时间
CGFloat const lbTimeWidth = 105.0f;
CGFloat const lbMarkWidth = 150.0f;

//订单按钮
CGFloat const octcViewBarHeight = 45.0f;
CGFloat const octcBtnItemWidth = 70.0f;
CGFloat const octcBtnItemHeight = 30.0f;
#define btnItemTitleFont                            LyFont(13)


@interface LyOrderCenterTableViewCell ()
{
    UIView                      *viewStatus;
    UIView                      *viewInfo;
    UIView                      *viewOrderBar;
    
    UIImageView                 *ivMode;
    UILabel                     *lbStatus;
    
    UIImageView                 *ivAvatar;
    UILabel                     *lbMaster;
    UILabel                     *lbName;
    UILabel                     *lbDetail;
    UILabel                     *lbPrice;
    UILabel                     *lbPaidNum;
    
    UILabel                     *lbTime;
    
    UILabel                     *lbMark;
    UIButton                    *btnDispatch;
}
@end


@implementation LyOrderCenterTableViewCell

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



- (void)initAndLayoutSubviews {
    //订单状态等信息
    viewStatus = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, octcViewStatusHeight)];
    //订单种类
    ivMode = [[UIImageView alloc] initWithFrame:CGRectMake( horizontalSpace, octcViewStatusHeight/2-ivModeHeight/2, ivModeWidth, ivModeHeight)];
    [ivMode setContentMode:UIViewContentModeScaleAspectFill];
    //订单状态
    lbStatus = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-lbStatusWidth, octcViewStatusHeight/2.0f-octcLbStatusHeight/2.0f, lbStatusWidth, octcLbStatusHeight)];
    [lbStatus setTextColor:Ly517ThemeColor];
    [lbStatus setTextAlignment:NSTextAlignmentRight];
    [lbStatus setFont:lbStatusFont];
    
    UIView *horizontalLine_status = [[UIView alloc] initWithFrame:CGRectMake( horizontalSpace, CGRectGetHeight(viewStatus.frame)-1, CGRectGetWidth(viewStatus.frame), 1)];
    [horizontalLine_status setBackgroundColor:LyHighLightgrayColor];
    
    [viewStatus addSubview:ivMode];
    [viewStatus addSubview:lbStatus];
    [viewStatus addSubview:horizontalLine_status];
    
    
    [self addSubview:viewStatus];
    
    
    //商品信息
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake( 0, viewStatus.ly_y+viewStatus.frame.size.height, SCREEN_WIDTH, octcViewInfoHeight)];
    //商品图
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake( horizontalSpace, verticalSpace, octcIvAvatarSize, octcIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [ivAvatar setClipsToBounds:YES];
    [ivAvatar.layer setCornerRadius:octcIvAvatarSize/2.0f];
    //商品所属
    lbMaster = [UILabel new];
    [lbMaster setTextColor:LyBlackColor];
    [lbMaster setTextAlignment:NSTextAlignmentLeft];
    [lbMaster setFont:lbTextFont];
    //商品名
    lbName = [UILabel new];
    [lbName setTextColor:[UIColor darkGrayColor]];
    [lbName setTextAlignment:NSTextAlignmentLeft];
    [lbName setFont:lbTextFont];
    //报名方式
    lbDetail = [UILabel new];
    [lbDetail setTextColor:[UIColor darkGrayColor]];
    [lbDetail setTextAlignment:NSTextAlignmentLeft];
    [lbDetail setFont:lbTextFont];
    //价格
    lbPrice = [UILabel new];
    [lbPrice setTextColor:LyBlackColor];
    [lbPrice setTextAlignment:NSTextAlignmentLeft];
    [lbPrice setFont:lbTextFont];
    //实付价格
    lbPaidNum = [UILabel new];
    [lbPaidNum setTextColor:LyBlackColor];
    [lbPaidNum setTextAlignment:NSTextAlignmentLeft];
    [lbPaidNum setFont:lbTextFont];
    
    UIView *horizontalLine_Object = [[UIView alloc] initWithFrame:CGRectMake( horizontalSpace+octcIvAvatarSize, CGRectGetHeight(viewInfo.frame)-1, CGRectGetWidth(viewInfo.frame), 1)];
    [horizontalLine_Object setBackgroundColor:LyHighLightgrayColor];
    
    
    [viewInfo addSubview:ivAvatar];
    [viewInfo addSubview:lbMaster];
    [viewInfo addSubview:lbName];
    [viewInfo addSubview:lbDetail];
    [viewInfo addSubview:lbPrice];
    [viewInfo addSubview:lbPaidNum];
    [viewInfo addSubview:horizontalLine_Object];
    
    
    [self addSubview:viewInfo];
    
    //按钮
    viewOrderBar = [[UIView alloc] initWithFrame:CGRectMake( 0, viewInfo.ly_y+viewInfo.frame.size.height, SCREEN_WIDTH, octcViewBarHeight)];
    
    lbTime = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, octcViewBarHeight/2.0f-octcBtnItemHeight/2.0f, lbTimeWidth, octcBtnItemHeight)];
    [lbTime setFont:LyFont(12)];
    [lbTime setTextColor:[UIColor darkGrayColor]];
    [lbTime setTextAlignment:NSTextAlignmentLeft];
    
    
    UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake( 0, CGRectGetHeight(viewOrderBar.frame)-verticalSpace, SCREEN_WIDTH, verticalSpace)];
    [bottomShadow setBackgroundColor:LyWhiteLightgrayColor];
    
    [viewOrderBar addSubview:lbTime];
    [viewOrderBar addSubview:bottomShadow];
    
    [self addSubview:viewOrderBar];
}



- (void)setOrder:(LyOrder *)order {
    _order = order;
    
    switch (_order.orderMode) {
        case LyOrderMode_driveSchool: {
            
//            break;
        }
        case LyOrderMode_coach: {
            
//            break;
        }
        case LyOrderMode_guider: {
            [ivMode setImage:[LyUtil imageForImageName:@"orderMode_apply" needCache:NO]];
            break;
        }
        case LyOrderMode_reservation: {
            [ivMode setImage:[LyUtil imageForImageName:@"orderMode_reservation" needCache:NO]];
            break;
        }
        case LyOrderMode_mall: {
            
            break;
        }
        case LyOrderMode_game: {
            
            break;
        }
    }
    
    switch (_order.orderState) {
        case LyOrderState_waitPay: {
//            break;
        }
        case LyOrderState_waitConfirm: {
            [lbStatus setText:@"交易中"];
            break;
        }
        case LyOrderState_waitEvalute: {
//            break;
        }
        case LyOrderState_completed: {
            [lbStatus setText:@"交易成功"];
            break;
        }
        case LyOrderState_cancel: {
            [lbStatus setText:@"交易关闭"];
            break;
        }
    }
    
    LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:_order.orderMasterId];
    if (!user) {
        NSString *strName;
        if (_order.orderStudentCount < 2) {
            strName = _order.orderConsignee;
        } else {
            strName = [LyUtil getUserNameWithUserId:_order.orderMasterId];
        }
        user = [LyUser userWithId:_order.orderMasterId
                         userNmae:strName];
        [[LyUserManager sharedInstance] addUser:user];
    }
    
    if (!user.userAvatar) {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:_order.orderMasterId]
                          placeholderImage:[LyUtil defaultAvatarForStudent]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     if (image) {
                                         [user setUserAvatar:image];
                                     } else {
                                         [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:_order.orderMasterId]
                                                           placeholderImage:[LyUtil defaultAvatarForStudent]
                                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                      if (image) {
                                                                          [user setUserAvatar:image];
                                                                      }
                                                                  }];
                                     }
                                 }];
    } else {
        [ivAvatar setImage:user.userAvatar];
    }
    
    
    switch ([LyCurrentUser curUser].userType) {
        case LyUserType_normal: {
            break;
        }
        case LyUserType_coach: {
            switch ([LyCurrentUser curUser].coachMode) {
                case LyCoachMode_normal: {
                    
                    [btnDispatch setHidden:YES];
                    if (!lbMark) {
                        lbMark = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-lbMarkWidth, octcViewBarHeight/2.0f-octcBtnItemHeight/2.0, lbMarkWidth, octcBtnItemHeight)];
                        [lbMark setFont:LyFont(14)];
                        [lbMark setTextColor:Ly517ThemeColor];
                        [lbMark setTextAlignment:NSTextAlignmentRight];
                        [viewOrderBar addSubview:lbMark];
                        
                    } else {
                        [lbMark setHidden:NO];
                    }
                    
                    if ([_order.orderObjectId isEqualToString:_order.recipient]) {
                        [lbMark setText:@"来自学员"];
                    } else {
                        [lbMark setText:@"来自驾校"];
                    }
                    
                    break;
                }
                case LyCoachMode_alone: {
                    
                    [btnDispatch setHidden:YES];
                    if (!lbMark) {
                        lbMark = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-lbMarkWidth, octcViewBarHeight/2.0f-octcBtnItemHeight/2.0, lbMarkWidth, octcBtnItemHeight)];
                        [lbMark setFont:LyFont(14)];
                        [lbMark setTextColor:Ly517ThemeColor];
                        [lbMark setTextAlignment:NSTextAlignmentRight];
                        [viewOrderBar addSubview:lbMark];
                        
                    } else {
                        [lbMark setHidden:NO];
                    }
                    
                    [lbMark setText:@"来自学员"];
                    
                    break;
                }
                case LyCoachMode_boss: {
                    if (![LyUser validateUserId:_order.recipient] || [_order.orderObjectId isEqualToString:_order.recipient]) {
                        
                        [lbMark setHidden:YES];
                        
                        if (!btnDispatch) {
                            btnDispatch = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-octcBtnItemWidth, octcViewBarHeight/2.0f-octcBtnItemHeight/2.0f, octcBtnItemWidth, octcBtnItemHeight)];
                            [btnDispatch.titleLabel setFont:btnItemTitleFont];
                            [btnDispatch setTitle:@"分配教练" forState:UIControlStateNormal];
                            [btnDispatch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            [btnDispatch setBackgroundColor:Ly517ThemeColor];
                            [btnDispatch.layer setCornerRadius:btnCornerRadius];
                            [btnDispatch setClipsToBounds:YES];
                            [btnDispatch addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
                            
                            [viewOrderBar addSubview:btnDispatch];
                        } else {
                            [btnDispatch setHidden:NO];
                        }
                    } else {
                        
                        [btnDispatch setHidden:YES];
                        
                        if (!lbMark) {
                            lbMark = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-lbMarkWidth, octcViewBarHeight/2.0f-octcBtnItemHeight/2.0, lbMarkWidth, octcBtnItemHeight)];
                            [lbMark setFont:LyFont(14)];
                            [lbMark setTextColor:Ly517ThemeColor];
                            [lbMark setTextAlignment:NSTextAlignmentRight];
                            [viewOrderBar addSubview:lbMark];
                            
                        } else {
                            [lbMark setHidden:NO];
                        }
                        
                        [lbMark setText:[[NSString alloc] initWithFormat:@"分配教练：%@", _order.recipientName]];
                        
                    }
                    break;
                }
                case LyCoachMode_staff: {
                    
                    [btnDispatch setHidden:YES];
                    if (!lbMark) {
                        lbMark = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-lbMarkWidth, octcViewBarHeight/2.0f-octcBtnItemHeight/2.0, lbMarkWidth, octcBtnItemHeight)];
                        [lbMark setFont:LyFont(14)];
                        [lbMark setTextColor:Ly517ThemeColor];
                        [lbMark setTextAlignment:NSTextAlignmentRight];
                        [viewOrderBar addSubview:lbMark];
                        
                    } else {
                        [lbMark setHidden:NO];
                    }
                    
                    if ([_order.orderObjectId isEqualToString:_order.recipient]) {
                        [lbMark setText:@"来自学员"];
                    } else {
                        [lbMark setText:@"来自教练"];
                    }
                    
                    break;
                }
            }
            break;
        }
        case LyUserType_school: {
            if (![LyUser validateUserId:_order.recipient] || [_order.orderObjectId isEqualToString:_order.recipient]) {
                
                [lbMark setHidden:YES];
                
                if (!btnDispatch) {
                    btnDispatch = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-octcBtnItemWidth, octcViewBarHeight/2.0f-octcBtnItemHeight/2.0f, octcBtnItemWidth, octcBtnItemHeight)];
                    [btnDispatch.titleLabel setFont:btnItemTitleFont];
                    [btnDispatch setTitle:@"分配教练" forState:UIControlStateNormal];
                    [btnDispatch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btnDispatch setBackgroundColor:Ly517ThemeColor];
                    [btnDispatch.layer setCornerRadius:btnCornerRadius];
                    [btnDispatch setClipsToBounds:YES];
                    [btnDispatch addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [viewOrderBar addSubview:btnDispatch];
                } else {
                    [btnDispatch setHidden:NO];
                }
            } else {
                
                [btnDispatch setHidden:YES];
                
                if (!lbMark) {
                    lbMark = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-lbMarkWidth, octcViewBarHeight/2.0f-octcBtnItemHeight/2.0, lbMarkWidth, octcBtnItemHeight)];
                    [lbMark setFont:LyFont(14)];
                    [lbMark setTextColor:Ly517ThemeColor];
                    [lbMark setTextAlignment:NSTextAlignmentRight];
                    [viewOrderBar addSubview:lbMark];
                    
                } else {
                    [lbMark setHidden:NO];
                }
                
                [lbMark setText:[[NSString alloc] initWithFormat:@"分配教练：%@", _order.recipientName]];
                
            }
            break;
        }
        case LyUserType_guider: {
            
            
            
            
            
            
            
//            [lbMark setHidden:YES];
            [btnDispatch setHidden:YES];
            break;
        }
    }

    
    
    
    
    
    CGSize sizelbMaster = [user.userName sizeWithAttributes:@{NSFontAttributeName:lbTextFont}];
    [lbMaster setFrame:CGRectMake( ivAvatar.frame.origin.x+ivAvatar.frame.size.width+horizontalSpace, 0, sizelbMaster.width, lbItemHeight)];
    [lbMaster setText:user.userName];
    
    
    NSString *strLbName;
    if (LyOrderMode_reservation != _order.orderMode) {
        strLbName = _order.orderDetail;
    } else {
        strLbName = [_order.orderDetail substringToIndex:6];
    }
    CGSize sizelbName = [strLbName sizeWithAttributes:@{NSFontAttributeName:lbTextFont}];
    [lbName setFrame:CGRectMake( lbMaster.frame.origin.x, lbMaster.ly_y+lbMaster.frame.size.height, sizelbName.width, lbItemHeight)];
    [lbName setText:strLbName];
    
    
    NSString *strlbDetail;
    if (LyOrderMode_reservation != _order.orderMode) {
        strlbDetail = [[NSString alloc] initWithFormat:@"%@", (LyApplyMode_whole == [_order orderApplyMode]) ? lbNameWhole : lbNamePrepay];
    } else {
        strlbDetail = [_order.orderDetail substringFromIndex:6];
    }
    CGSize sizelbDetail = [strlbDetail sizeWithAttributes:@{NSFontAttributeName:lbTextFont}];
    [lbDetail setFrame:CGRectMake( lbName.frame.origin.x, lbName.ly_y+lbName.frame.size.height, sizelbDetail.width, lbItemHeight)];
    [lbDetail setText:strlbDetail];
    
    
    NSString *strLbPrice;
    if (_order.orderPrice < 10) {
        strLbPrice = [[NSString alloc] initWithFormat:@"￥%.2f", _order.orderPrice];
    } else {
        strLbPrice = [[NSString alloc] initWithFormat:@"￥%.0f", _order.orderPrice];
    }
    CGFloat fWidthPrice = [strLbPrice sizeWithAttributes:@{NSFontAttributeName:lbTextFont}].width;
    [lbPrice setFrame:CGRectMake( SCREEN_WIDTH-horizontalSpace-fWidthPrice, lbMaster.ly_y, fWidthPrice, lbItemHeight)];
    [lbPrice setText:strLbPrice];
    
    
    if (_order.orderState < LyOrderState_waitConfirm || LyOrderState_cancel == _order.orderState ) {
        [lbPaidNum setHidden:YES];
    } else {
        [lbPaidNum setHidden:NO];
        NSString *strLbPaidNum;
        if (_order.orderPaidNum < 10) {
            strLbPaidNum = [[NSString alloc] initWithFormat:@"实付 ￥%.2f", [_order orderPaidNum]];
        }  else {
            strLbPaidNum = [[NSString alloc] initWithFormat:@"实付 ￥%.0f", [_order orderPaidNum]];
        }
        CGSize sizeLbPaidNum = [strLbPaidNum sizeWithAttributes:@{NSFontAttributeName:lbTextFont}];
        [lbPaidNum setFrame:CGRectMake( SCREEN_WIDTH-horizontalSpace-sizeLbPaidNum.width, lbDetail.ly_y+lbDetail.frame.size.height, sizeLbPaidNum.width, lbItemHeight)];
        [lbPaidNum setText:strLbPaidNum];
    }
    
    
    [lbTime setText:[LyUtil cutTimeString:_order.orderTime]];
    
    
    
    
}


- (void)targetForButton:(UIButton *)btn {
    if (btn == btnDispatch) {
        [_delegate onClickButtonDisptachByOrderCenterTableViewCell:self];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
