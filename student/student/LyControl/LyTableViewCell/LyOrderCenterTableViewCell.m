//
//  LyOrderCenterTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/9.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyOrderCenterTableViewCell.h"
#import "LyOrderManager.h"
#import "LyUserManager.h"
#import "LyUtil.h"


#import "UIImageView+WebCache.h"

#define octcWidth                                   SCREEN_WIDTH
CGFloat const octcHeight = 155.0f;


#define lbTextFont                                  LyFont(14)


//订单状态等信息
#define octcViewOrderStatusWidth                    octcWidth
CGFloat const octcViewOrderStatusHeight = 30.0f;
//订单种类
CGFloat const ivOrderModeHeight = 20.0f;
CGFloat const ivOrderModeWidth = 60.0f;
//订单状态
#define lbOrderStatusWidth
#define lbOrderStatusHeight                         octcViewOrderStatusHeight
#define lbOrderStatusFont                           LyFont(12)


//商品信息
#define octcViewOrderObjectWidth                    octcWidth
CGFloat const octcViewOrderObjectHeight = 80.0f;
//商品图
CGFloat const ivObjectAvatarWidth = 45.0f;
CGFloat const ivObjectAvatarHeight = ivObjectAvatarWidth;
//商品所属
CGFloat const lbObjectMasterHeight = 20.0f;
//商品名
CGFloat const lbObjectNameHeight = lbObjectMasterHeight;
//详情
CGFloat const lbObjectDetailHeigth = lbObjectMasterHeight;
//价格
CGFloat const lbPriceHeigth = lbObjectMasterHeight;
//实付价格
CGFloat const lbPaidNumHeight = lbObjectMasterHeight;

//订单按钮
#define octcViewOrderBarWidth                       octcWidth
CGFloat const octcViewOrderBarHeight = 45.0f;
CGFloat const octcBtnItemWidth = 70.0f;
CGFloat const octcBtnItemHeight = 30.0f;
#define btnItemTitleFont                            LyFont(13)



typedef NS_ENUM(NSInteger, LyOrderCenterTableViewCellButtonMode)
{
    orderCenterTableViewCellButtonMode_left = 10,
    orderCenterTableViewCellButtonMode_right,
};



@interface LyOrderCenterTableViewCell ()
{
    UIView                                      *viewOrderStatus;
    UIView                                      *viewOrderObject;
    UIView                                      *viewOrderBar;
    
    
    UIImageView                                 *ivOrderMode;
    UILabel                                     *lbOrderStatus;
    
    UIImageView                                 *ivObjectAvatar;
    UILabel                                     *lbObjectMaster;
    UILabel                                     *lbObjectName;
    UILabel                                     *lbObjectDetail;
    UILabel                                     *lbPrice;
    UILabel                                     *lbPaidNum;
    
    
    UIButton                                    *btnLeft;
    UIButton                                    *btnRight;
}
@end



@implementation LyOrderCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initAndLayoutSubview];
    }
    
    return self;
}



- (void)initAndLayoutSubview
{
    //订单状态等信息
    viewOrderStatus = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, octcViewOrderStatusWidth, octcViewOrderStatusHeight)];
    //订单种类
    ivOrderMode = [[UIImageView alloc] initWithFrame:CGRectMake( horizontalSpace, octcViewOrderStatusHeight/2-ivOrderModeHeight/2, ivOrderModeWidth, ivOrderModeHeight)];
    [ivOrderMode setContentMode:UIViewContentModeScaleAspectFit];
    //订单状态
    lbOrderStatus = [UILabel new];
    [lbOrderStatus setTextColor:Ly517ThemeColor];
    [lbOrderStatus setTextAlignment:NSTextAlignmentCenter];
    [lbOrderStatus setFont:lbOrderStatusFont];
    
    UIView *horizontalLine_status = [[UIView alloc] initWithFrame:CGRectMake( horizontalSpace, CGRectGetHeight(viewOrderStatus.frame)-1, CGRectGetWidth(viewOrderStatus.frame), 0.5f)];
    [horizontalLine_status setBackgroundColor:LyHighLightgrayColor];
    
    
    
    [viewOrderStatus addSubview:ivOrderMode];
    [viewOrderStatus addSubview:lbOrderStatus];
    [viewOrderStatus addSubview:horizontalLine_status];
    
    
    
    //商品信息
    viewOrderObject = [[UIView alloc] initWithFrame:CGRectMake( 0, viewOrderStatus.frame.origin.y+viewOrderStatus.frame.size.height, octcViewOrderObjectWidth, octcViewOrderObjectHeight)];
    //商品图
    ivObjectAvatar = [[UIImageView alloc] initWithFrame:CGRectMake( horizontalSpace, verticalSpace, ivObjectAvatarWidth, ivObjectAvatarHeight)];
    [ivObjectAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [[ivObjectAvatar layer] setCornerRadius:btnCornerRadius];
    [ivObjectAvatar setClipsToBounds:YES];
    //商品所属
    lbObjectMaster = [UILabel new];
    [lbObjectMaster setTextColor:LyBlackColor];
    [lbObjectMaster setTextAlignment:NSTextAlignmentLeft];
    [lbObjectMaster setFont:lbTextFont];
    //商品名
    lbObjectName = [UILabel new];
    [lbObjectName setTextColor:LyDarkgrayColor];
    [lbObjectName setTextAlignment:NSTextAlignmentLeft];
    [lbObjectName setFont:lbTextFont];
    //报名方式
    lbObjectDetail = [UILabel new];
    [lbObjectDetail setTextColor:LyDarkgrayColor];
    [lbObjectDetail setTextAlignment:NSTextAlignmentLeft];
    [lbObjectDetail setFont:lbTextFont];
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
    
    UIView *horizontalLine_Object = [[UIView alloc] initWithFrame:CGRectMake( horizontalSpace+ivObjectAvatarWidth, CGRectGetHeight(viewOrderObject.frame)-1, CGRectGetWidth(viewOrderObject.frame), 0.5f)];
    [horizontalLine_Object setBackgroundColor:LyHighLightgrayColor];
    
    
    [viewOrderObject addSubview:ivObjectAvatar];
    [viewOrderObject addSubview:lbObjectMaster];
    [viewOrderObject addSubview:lbObjectName];
    [viewOrderObject addSubview:lbObjectDetail];
    [viewOrderObject addSubview:lbPrice];
    [viewOrderObject addSubview:lbPaidNum];
    [viewOrderObject addSubview:horizontalLine_Object];
    
    
    
    //按钮
    viewOrderBar = [[UIView alloc] initWithFrame:CGRectMake( 0, viewOrderObject.frame.origin.y+viewOrderObject.frame.size.height, octcViewOrderBarWidth, octcViewOrderBarHeight)];
    
    btnRight = [[UIButton alloc] initWithFrame:CGRectMake( octcViewOrderBarWidth-horizontalSpace-octcBtnItemWidth, 5, octcBtnItemWidth, octcBtnItemHeight)];
    [btnRight setTag:orderCenterTableViewCellButtonMode_right];
    [[btnRight titleLabel] setFont:btnItemTitleFont];
    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[btnRight layer] setCornerRadius:btnCornerRadius];
    [btnRight setBackgroundColor:Ly517ThemeColor];
    [btnRight addTarget:self action:@selector(onClickButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    btnLeft = [[UIButton alloc] initWithFrame:CGRectMake( btnRight.frame.origin.x-horizontalSpace-octcBtnItemWidth, btnRight.frame.origin.y, octcBtnItemWidth, octcBtnItemHeight)];
    [btnLeft setTag:orderCenterTableViewCellButtonMode_left];
    [[btnLeft titleLabel] setFont:btnItemTitleFont];
    [btnLeft setTitleColor:LyBlackColor forState:UIControlStateNormal];
    [btnLeft setBackgroundColor:[UIColor whiteColor]];
    [[btnLeft layer] setCornerRadius:5.0f];
    [[btnLeft layer] setBorderWidth:1.0f];
    [[btnLeft layer] setBorderColor:[Ly517ThemeColor CGColor]];
    [btnLeft addTarget:self action:@selector(onClickButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    

    
    
    
    UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake( 0, CGRectGetHeight(viewOrderBar.frame)-verticalSpace, CGRectGetWidth(viewOrderBar.frame), verticalSpace)];
    [bottomShadow setBackgroundColor:LyWhiteLightgrayColor];
    
    
    [viewOrderBar addSubview:bottomShadow];
    
    [viewOrderBar addSubview:btnLeft];
    [viewOrderBar addSubview:btnRight];
    
    
    [self addSubview:viewOrderStatus];
    [self addSubview:viewOrderObject];
    [self addSubview:viewOrderBar];
}



- (void)setOrder:(LyOrder *)order
{
    if ( !order)
    {
        return;
    }
    _order = order;
    
    
    NSString *strOrderModeImageName;
    LyUser *teacher;
    NSString *strObjectMaster;
    NSString *strObjectName;
    NSString *strDetail;
    
    switch ( [_order orderMode])
    {
        case LyOrderMode_driveSchool: {
            strOrderModeImageName = @"orderMode_school";

            teacher = [[LyUserManager sharedInstance] getDriveSchoolWithDriveSchoolId:_order.orderObjectId];
            if ( !teacher) {
                NSString *strName = [LyUtil getUserNameWithUserId:_order.orderObjectId];
                teacher = [LyDriveSchool driveSchoolWithId:_order.orderObjectId
                                                      dschName:strName];
                [[LyUserManager sharedInstance] addUser:teacher];
            }
            
            
            strObjectMaster = order.orderName;
            
            strObjectName = [_order orderDetail];
            
            strDetail = [[NSString alloc] initWithFormat:@"%@", ( LyApplyMode_prepay == [_order orderApplyMode]) ? lbApplyModeTitlePrepay : lbApplyModeTitleWhole];
    
            break;
        }
        case LyOrderMode_coach: {
            
            strOrderModeImageName = @"orderMode_coach";
            
            teacher = [[LyUserManager sharedInstance] getCoachWithCoachId:_order.orderObjectId];
            if ( !teacher) {
                NSString *strName = [LyUtil getUserNameWithUserId:_order.orderObjectId];
                teacher = [LyCoach coachWithId:_order.orderObjectId
                                     coaName:strName];
                [[LyUserManager sharedInstance] addUser:teacher];
            }
            
            
            strObjectMaster = order.orderName;
            
            strObjectName = [_order orderDetail];
            
            strDetail = [[NSString alloc] initWithFormat:@"%@", ( LyApplyMode_prepay == [_order orderApplyMode]) ? lbApplyModeTitlePrepay : lbApplyModeTitleWhole];
            
            break;
        }
        case LyOrderMode_guider: {
            
            strOrderModeImageName = @"orderMode_guider";
            
            teacher = [[LyUserManager sharedInstance] getGuiderWithGuiderId:_order.orderObjectId];
            if ( !teacher) {
                NSString *strName = [LyUtil getUserNameWithUserId:_order.orderObjectId];
                teacher = [LyGuider guiderWithGuiderId:_order.orderObjectId
                                              guiName:strName];
                [[LyUserManager sharedInstance] addUser:teacher];
            }
            
            
            strObjectMaster = order.orderName;
            
            strObjectName = [_order orderDetail];
            
            strDetail = [[NSString alloc] initWithFormat:@"%@", ( LyApplyMode_prepay == [_order orderApplyMode]) ? lbApplyModeTitlePrepay : lbApplyModeTitleWhole];
            
            break;
        }
        case LyOrderMode_reservation: {
            
            strOrderModeImageName = @"orderMode_reservation";
    
            
            teacher = [[LyUserManager sharedInstance] getUserWithUserId:_order.orderObjectId];
            if ( !teacher) {
                NSString *strName = [LyUtil getUserNameWithUserId:_order.orderObjectId];
                teacher = [LyUser userWithId:_order.orderObjectId
                                    userNmae:strName];
                [[LyUserManager sharedInstance] addUser:teacher];
            }
            
            
            
            strObjectMaster = order.orderName;
            
            strObjectName = [_order.orderDetail substringToIndex:6];
            
            strDetail = [_order.orderDetail substringFromIndex:7];
            break;
        }
        case LyOrderMode_mall: {
            
            
            break;
        }
        case LyOrderMode_game: {
            
            
            break;
        }
            
        default: {
            break;
        }
    }
    
    
    if (!teacher.userAvatar) {
        [ivObjectAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:teacher.userId]
                          placeholderImage:[LyUtil defaultAvatarForTeacher]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     if (image){
                                         [teacher setUserAvatar:image];
                                     }
                                     else
                                     {
                                         [ivObjectAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:teacher.userId]
                                                           placeholderImage:[LyUtil defaultAvatarForTeacher]
                                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                      if(image) {
                                                                          [teacher setUserAvatar:image];
                                                                      }
                                                                  }];
                                     }
                                 }];
    } else {
        [ivObjectAvatar setImage:teacher.userAvatar];
    }
    
    [ivOrderMode setImage:[LyUtil imageForImageName:strOrderModeImageName needCache:NO]];
    
    //商品所有人
    CGSize sizeLbObjectMaster = [strObjectMaster sizeWithAttributes:@{NSFontAttributeName:lbTextFont}];
    [lbObjectMaster setFrame:CGRectMake( ivObjectAvatar.frame.origin.x+ivObjectAvatar.frame.size.width+horizontalSpace, 0, sizeLbObjectMaster.width, lbObjectMasterHeight)];
    [lbObjectMaster setText:strObjectMaster];
    
    //商品名
    CGSize sizeLbObjectName = [strObjectName sizeWithAttributes:@{NSFontAttributeName:lbTextFont}];
    [lbObjectName setFrame:CGRectMake( lbObjectMaster.frame.origin.x, lbObjectMaster.frame.origin.y+lbObjectMaster.frame.size.height, sizeLbObjectName.width, lbObjectNameHeight)];
    [lbObjectName setText:strObjectName];
    
    //商品详情
    CGSize sizeLbObjectDetail = [strDetail sizeWithAttributes:@{NSFontAttributeName:lbTextFont}];
    [lbObjectDetail setFrame:CGRectMake( lbObjectName.frame.origin.x, lbObjectName.frame.origin.y+lbObjectName.frame.size.height, sizeLbObjectDetail.width, lbObjectDetailHeigth)];
    [lbObjectDetail setText:strDetail];
    
    
    NSString *strLbPrice;
    if (_order.orderPrice < 10) {
        strLbPrice = [[NSString alloc] initWithFormat:@"￥%.2f", [_order orderPrice]];
    } else {
        strLbPrice = [[NSString alloc] initWithFormat:@"￥%.0f", [_order orderPrice]];
    }
    CGFloat fWidthPrice = [strLbPrice sizeWithAttributes:@{NSFontAttributeName:lbTextFont}].width;
    [lbPrice setFrame:CGRectMake( octcViewOrderObjectWidth-horizontalSpace-fWidthPrice, lbObjectMaster.frame.origin.y, fWidthPrice, lbPriceHeigth)];
    [lbPrice setText:strLbPrice];
    
    
    
    if ( [_order orderState] < LyOrderState_waitConfirm) {
        [lbPaidNum setHidden:YES];
    } else {
        [lbPaidNum setHidden:NO];
        NSString *strLbPaidNum;
        if (_order.orderPaidNum < 10)
        {
            strLbPaidNum = [[NSString alloc] initWithFormat:@"实付 ￥%.2f", [_order orderPaidNum]];
        }
        else
        {
            strLbPaidNum = [[NSString alloc] initWithFormat:@"实付 ￥%.0f", [_order orderPaidNum]];
        }
        CGSize sizeLbPaidNum = [strLbPaidNum sizeWithAttributes:@{NSFontAttributeName:lbTextFont}];
        [lbPaidNum setFrame:CGRectMake( octcViewOrderObjectWidth-horizontalSpace-sizeLbPaidNum.width, lbObjectDetail.frame.origin.y+lbObjectDetail.frame.size.height, sizeLbPaidNum.width, lbPaidNumHeight)];
        [lbPaidNum setText:strLbPaidNum];
    }
    
    
    
    NSString *strLbOrderStatus;
    NSString *strBtnLeftTitle;
    NSString *strBtnRightTitle;
    switch ( [_order orderState]) {
        case LyOrderState_waitPay: {
            strLbOrderStatus = @"交易中";
            if (LyOrderMode_reservation == _order.orderMode) {
                strBtnLeftTitle = @"取消预约";
            } else {
                strBtnLeftTitle = @"取消订单";
            }
            strBtnRightTitle = @"立即付款";
            break;
        }
        case LyOrderState_waitConfirm: {
            strLbOrderStatus = @"交易中";if (LyOrderMode_reservation == _order.orderMode) {
                strBtnLeftTitle = @"取消预约";
            } else {
                strBtnLeftTitle = @"删除订单";
            }
            switch (_order.orderMode) {
                case LyOrderMode_driveSchool: {
                    strBtnRightTitle = @"我已学车";
                    break;
                }
                case LyOrderMode_coach: {
                    strBtnRightTitle = @"我已学车";
                    break;
                }
                case LyOrderMode_guider: {
                    strBtnRightTitle = @"我已学车";
                    break;
                }
                case LyOrderMode_reservation: {
                    strBtnRightTitle = @"我已学车";
                    break;
                }
                case LyOrderMode_mall: {
                    strBtnRightTitle = @"我已收货";
                    break;
                }
                case LyOrderMode_game: {
                    strBtnRightTitle = @"我已收货";
                    break;
                }
            }
            break;
        }
        case LyOrderState_waitEvalute: {
            strLbOrderStatus = @"交易成功";
            strBtnLeftTitle = @"删除订单";
            strBtnRightTitle = @"评价";
            break;
        }
        case LyOrderState_completed: {
            strLbOrderStatus = @"交易成功";
            strBtnLeftTitle = @"删除订单";
            strBtnRightTitle = @"再次评价";
            break;
        }
        case LyOrderState_cancel: {
            strLbOrderStatus = @"交易关闭";
            strBtnLeftTitle = @"删除订单";
            switch (_order.orderMode) {
                case LyOrderMode_driveSchool: {
                    strBtnRightTitle = @"重新报名";
                    break;
                }
                case LyOrderMode_coach: {
                    strBtnRightTitle = @"重新报名";
                    break;
                }
                case LyOrderMode_guider: {
                    strBtnRightTitle = @"重新报名";
                    break;
                }
                case LyOrderMode_reservation: {
                    strBtnRightTitle = @"重新预约";
                    break;
                }
                case LyOrderMode_mall: {
                    strBtnRightTitle = @"重新购买";
                    break;
                }
                case LyOrderMode_game: {
                    strBtnRightTitle = @"重新购买";
                    break;
                }
            }
            break;
        }
        default:{
            strLbOrderStatus = @"交易关闭";
            strBtnLeftTitle = @"删除订单";
            switch (_order.orderMode) {
                case LyOrderMode_driveSchool: {
                    strBtnRightTitle = @"重新报名";
                    break;
                }
                case LyOrderMode_coach: {
                    strBtnRightTitle = @"重新报名";
                    break;
                }
                case LyOrderMode_guider: {
                    strBtnRightTitle = @"重新报名";
                    break;
                }
                case LyOrderMode_reservation: {
                    strBtnRightTitle = @"重新预约";
                    break;
                }
                case LyOrderMode_mall: {
                    strBtnRightTitle = @"重新购买";
                    break;
                }
                case LyOrderMode_game: {
                    strBtnRightTitle = @"重新购买";
                    break;
                }
            }
            break;
        }
    }
    [btnLeft setTitle:strBtnLeftTitle forState:UIControlStateNormal];
    [btnRight setTitle:strBtnRightTitle forState:UIControlStateNormal];
    
    
    CGSize sizeLbOrderStatus = [strLbOrderStatus sizeWithAttributes:@{NSFontAttributeName:lbOrderStatusFont}];
    [lbOrderStatus setFrame:CGRectMake( octcViewOrderStatusWidth-horizontalSpace-sizeLbOrderStatus.width, 0, sizeLbOrderStatus.width, octcViewOrderStatusHeight)];
    [lbOrderStatus setText:strLbOrderStatus];
    
}



- (void)onClickButtonItem:(UIButton *)button
{
    if (orderCenterTableViewCellButtonMode_left == button.tag)
    {
        if (LyOrderState_waitPay == _order.orderState)
        {
            [_delegate onClickedCancelByOrderCenterTableViewCell:self];
        }
        else
        {
            [_delegate onClickedDeleteByOrderCenterTableViewCell:self];
        }
    }
    else if (orderCenterTableViewCellButtonMode_right == button.tag)
    {
        switch (_order.orderState) {
            case LyOrderState_waitPay: {
                [_delegate onClickedPayByOrderCenterTableViewCell:self];
                break;
            }
            case LyOrderState_waitConfirm: {
                [_delegate onClickedConfirmByOrderCenterTableViewCell:self];
                break;
            }
            case LyOrderState_waitEvalute: {
                [_delegate onClickedEvaluteByOrderCenterTableViewCell:self];
                break;
            }
            case LyOrderState_completed: {
                [_delegate onClickedEvaluteAgainByOrderCenterTableViewCell:self];
                break;
            }
            case LyOrderState_cancel: {
                [_delegate onClickedReapplyByOrderCenterTableViewCell:self];
                break;
            }
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end



