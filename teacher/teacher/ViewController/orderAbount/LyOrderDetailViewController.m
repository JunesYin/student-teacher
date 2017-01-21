//
//  LyOrderDetailViewController.m
//  teacher
//
//  Created by Junes on 16/8/16.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyOrderDetailViewController.h"

#import "LyUserManager.h"
#import "LyOrderManager.h"

#import "LyCurrentUser.h"

#import "UILabel+LyTextAlignmentLeftAndRight.h"

#import "LyUtil.h"


#import "LyOrderDispatchTableViewController.h"


//商品信息
CGFloat const viewGoodsInfoHeight = 100.0f;
CGFloat const odIvAvatarSize = 80.0f;
CGFloat const lbGoodsNameHeight = 20.0f;
CGFloat const lbGoodsDetailHeight = 40.0f;
CGFloat const lbCreateTimeHeight = lbGoodsNameHeight;



//订单信息
CGFloat const lbRemarkHeight = 80.0f;




typedef NS_ENUM(NSInteger, LyOrderDetailButtonMode)
{
    orderDetailButtonMode_dispatch = 10,
};


@interface LyOrderDetailViewController () <UIScrollViewDelegate, LyOrderDispatchTableViewControllerDelegate>
{
    UIScrollView                *svMain;
    
    //商品信息
    UIView                      *viewGoodsInfo;
    UIImageView                 *ivAvatar;
    UILabel                     *lbGoodsName;
    UILabel                     *lbGoodsDetail;
    UILabel                     *lbCreateTime;
    
    //订单信息
    UIView                      *viewOrderInfo;

    UIView                      *viewStuCount;
    UILabel                     *lbTitle_stuCount;
    UILabel                     *lbStuCount;
    
    UIView                      *viewPhone;
    UILabel                     *lbTitle_phone;
    UILabel                     *lbPhone;
    
    UIView                      *viewAddress;
    UILabel                     *lbTitle_address;
    UILabel                     *lbAddress;
    
    UIView                      *viewApplyMode;
    UILabel                     *lbTitle_applyMode;
    UILabel                     *lbApplyMode;
    
    UIView                      *viewPaidNum;
    UILabel                     *lbTitle_paidNum;
    UILabel                     *lbPaidNum;
    
    UIView                      *viewRemark;
    UILabel                     *lbTitle_remark;
    UILabel                     *lbRemark;
    
    
    UIButton                    *btnDispatch;
    
    
}
@end

@implementation LyOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}


- (void)viewWillAppear:(BOOL)animated {
    _order = [_delegate obtainOrderByOrderDetailVC:self];
    
    if (!_order) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self reloadData];
}


- (void)initAndLayoutSubviews
{
    self.title = @"订单详情";
//    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    svMain = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [svMain setDelegate:self];
    [svMain setBackgroundColor:LyWhiteLightgrayColor];
    [self.view addSubview:svMain];
    
    //商品信息
    viewGoodsInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, viewGoodsInfoHeight)];
    [viewGoodsInfo setBackgroundColor:[UIColor whiteColor]];
    //商品信息-图片
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(horizontalSpace, viewGoodsInfoHeight/2.0f-odIvAvatarSize/2.0f, odIvAvatarSize, odIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [ivAvatar.layer setCornerRadius:odIvAvatarSize/2.0f];
    [ivAvatar setClipsToBounds:YES];
    //商品信息-姓名
    lbGoodsName = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace+odIvAvatarSize+verticalSpace, ivAvatar.ly_y, SCREEN_WIDTH-odIvAvatarSize-horizontalSpace*2-verticalSpace, lbGoodsNameHeight)];
    [lbGoodsName setFont:LyFont(16)];
    [lbGoodsName setTextColor:[UIColor blackColor]];
    [lbGoodsName setTextAlignment:NSTextAlignmentLeft];
    //商品信息-课程
    lbGoodsDetail = [[UILabel alloc] initWithFrame:CGRectMake(lbGoodsName.frame.origin.x, lbGoodsName.ly_y+CGRectGetHeight(lbGoodsName.frame)+verticalSpace, CGRectGetWidth(lbGoodsName.frame), lbGoodsDetailHeight)];
    [lbGoodsDetail setFont:LyFont(14)];
    [lbGoodsDetail setTextColor:LyBlackColor];
    [lbGoodsDetail setTextAlignment:NSTextAlignmentLeft];
    [lbGoodsDetail setNumberOfLines:0];
    //商品信息-时间
    lbCreateTime = [[UILabel alloc] initWithFrame:CGRectMake(lbGoodsName.frame.origin.x, lbGoodsDetail.ly_y+CGRectGetHeight(lbGoodsDetail.frame)+verticalSpace, CGRectGetWidth(lbGoodsDetail.frame), lbCreateTimeHeight)];
    [lbCreateTime setFont:LyFont(14)];
    [lbCreateTime setTextColor:[UIColor darkGrayColor]];
    [lbCreateTime setTextAlignment:NSTextAlignmentLeft];
    
    [viewGoodsInfo addSubview:ivAvatar];
    [viewGoodsInfo addSubview:lbGoodsName];
    [viewGoodsInfo addSubview:lbGoodsDetail];
    [viewGoodsInfo addSubview:lbCreateTime];
    
    
    //订单信息
    viewOrderInfo = [[UIView alloc] initWithFrame:CGRectMake(0, viewGoodsInfo.ly_y+CGRectGetHeight(viewGoodsInfo.frame)+verticalSpace, SCREEN_WIDTH, LyViewItemHeight*5+LyHorizontalLineHeight*5+lbRemarkHeight)];
    //订单信息-学员人数
    viewStuCount = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LyViewItemHeight)];
    [viewStuCount setBackgroundColor:[UIColor whiteColor]];
    
    lbTitle_stuCount = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, LyLbTitleItemWidth, LyViewItemHeight)];
    [lbTitle_stuCount setFont:LyFont(15)];
    [lbTitle_stuCount setTextColor:[UIColor blackColor]];
    [lbTitle_stuCount setText:@"学员人数"];
//    [lbTitle_stuCount justifyTextAlignmentLeftAndRight];
    [lbTitle_stuCount setTextAlignment:NSTextAlignmentLeft];
    
    lbStuCount = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace*2+LyLbTitleItemWidth, 0, SCREEN_WIDTH-LyLbTitleItemWidth-horizontalSpace*3, LyViewItemHeight)];
    [lbStuCount setFont:LyFont(14)];
    [lbStuCount setTextColor:LyBlackColor];
    [lbStuCount setTextAlignment:NSTextAlignmentLeft];
    
    [viewStuCount addSubview:lbTitle_stuCount];
    [viewStuCount addSubview:lbStuCount];
    
    
    //订单信息-联系电话
    viewPhone = [[UIView alloc] initWithFrame:CGRectMake(0, viewStuCount.ly_y+CGRectGetHeight(viewStuCount.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewPhone setBackgroundColor:[UIColor whiteColor]];
    
    lbTitle_phone = [[UILabel alloc] initWithFrame:lbTitle_stuCount.frame];
    [lbTitle_phone setFont:lbTitle_stuCount.font];
    [lbTitle_phone setTextColor:lbTitle_stuCount.textColor];
    [lbTitle_phone setText:@"联系电话"];
//    [lbTitle_phone justifyTextAlignmentLeftAndRight];
    [lbTitle_phone setTextAlignment:NSTextAlignmentLeft];
    
    lbPhone = [[UILabel alloc] initWithFrame:lbStuCount.frame];
    [lbPhone setFont:lbStuCount.font];
    [lbPhone setTextColor:lbStuCount.textColor];
    [lbPhone setTextAlignment:lbStuCount.textAlignment];
    
    [viewPhone addSubview:lbTitle_phone];
    [viewPhone addSubview:lbPhone];
    
    
    //订单信息-地址
    viewAddress = [[UIView alloc] initWithFrame:CGRectMake(0, viewPhone.ly_y+CGRectGetHeight(viewPhone.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewAddress setBackgroundColor:[UIColor whiteColor]];
    lbTitle_address = [[UILabel alloc] initWithFrame:lbTitle_stuCount.frame];
    [lbTitle_address setFont:lbTitle_stuCount.font];
    [lbTitle_address setTextColor:lbTitle_stuCount.textColor];
    [lbTitle_address setText:({
        NSString *str;
        if (LyUserType_guider == [LyCurrentUser curUser].userType) {
            str = @"详细地址";
        } else {
            str = @"接送地址";
        }
        str;
    })];
        //    [lbTitle_address justifyTextAlignmentLeftAndRight];
    [lbTitle_address setTextAlignment:NSTextAlignmentLeft];
    
    lbAddress = [[UILabel alloc] initWithFrame:lbStuCount.frame];
    [lbAddress setFont:lbStuCount.font];
    [lbAddress setTextColor:lbStuCount.textColor];
    [lbAddress setTextAlignment:lbStuCount.textAlignment];
    [lbAddress setNumberOfLines:0];
    
    [viewAddress addSubview:lbTitle_address];
    [viewAddress addSubview:lbAddress];
    
    

    //订单信息-报名方式
    viewApplyMode = [[UIView alloc] initWithFrame:CGRectMake(0, viewAddress.ly_y+CGRectGetHeight(viewAddress.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewApplyMode setBackgroundColor:[UIColor whiteColor]];
    
    lbTitle_applyMode = [[UILabel alloc] initWithFrame:lbTitle_stuCount.frame];
    [lbTitle_applyMode setFont:lbTitle_stuCount.font];
    [lbTitle_applyMode setTextColor:lbTitle_stuCount.textColor];
    [lbTitle_applyMode setText:@"报名方式"];
//    [lbTitle_applyMode justifyTextAlignmentLeftAndRight];
    [lbTitle_applyMode setTextAlignment:NSTextAlignmentLeft];
    
    lbApplyMode = [[UILabel alloc] initWithFrame:lbStuCount.frame];
    [lbApplyMode setFont:lbStuCount.font];
    [lbApplyMode setTextColor:lbStuCount.textColor];
    [lbApplyMode setTextAlignment:lbStuCount.textAlignment];
    
    [viewApplyMode addSubview:lbTitle_applyMode];
    [viewApplyMode addSubview:lbApplyMode];
    
    
    //订单信息-实收金额
    viewPaidNum = [[UIView alloc] initWithFrame:CGRectMake(0, viewApplyMode.ly_y+CGRectGetHeight(viewApplyMode.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewPaidNum setBackgroundColor:[UIColor whiteColor]];
    
    lbTitle_paidNum = [[UILabel alloc] initWithFrame:lbTitle_stuCount.frame];
    [lbTitle_paidNum setFont:lbTitle_stuCount.font];
    [lbTitle_paidNum setTextColor:lbTitle_stuCount.textColor];
    [lbTitle_paidNum setText:@"实收金额"];
//    [lbTitle_paidNum justifyTextAlignmentLeftAndRight];
    [lbTitle_paidNum setTextAlignment:NSTextAlignmentLeft];
    
    lbPaidNum = [[UILabel alloc] initWithFrame:lbStuCount.frame];
    [lbPaidNum setFont:lbStuCount.font];
    [lbPaidNum setTextColor:lbStuCount.textColor];
    [lbPaidNum setTextAlignment:lbStuCount.textAlignment];
    
    [viewPaidNum addSubview:lbTitle_paidNum];
    [viewPaidNum addSubview:lbPaidNum];
    
    
    //订单信息-备注
    viewRemark = [[UIView alloc] initWithFrame:CGRectMake(0, viewPaidNum.ly_y+CGRectGetHeight(viewPaidNum.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, lbRemarkHeight)];
    [viewRemark setBackgroundColor:[UIColor whiteColor]];
    
    lbTitle_remark = [[UILabel alloc] initWithFrame:lbTitle_stuCount.frame];
    [lbTitle_remark setFont:lbTitle_stuCount.font];
    [lbTitle_remark setTextColor:lbTitle_stuCount.textColor];
    [lbTitle_remark setText:@"备注"];
//    [lbTitle_remark justifyTextAlignmentLeftAndRight];
    [lbTitle_remark setTextAlignment:NSTextAlignmentLeft];
    
    lbRemark = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace*2+LyLbTitleItemWidth, 0, SCREEN_WIDTH-LyLbTitleItemWidth-horizontalSpace*3, lbRemarkHeight)];
    [lbRemark setFont:lbStuCount.font];
    [lbRemark setTextColor:lbStuCount.textColor];
    [lbRemark setTextAlignment:lbStuCount.textAlignment];
    [lbRemark setNumberOfLines:0];
    
    [viewRemark addSubview:lbTitle_remark];
    [viewRemark addSubview:lbRemark];
    
    
    [viewOrderInfo addSubview:viewStuCount];
    [viewOrderInfo addSubview:viewPhone];
    [viewOrderInfo addSubview:viewAddress];
    [viewOrderInfo addSubview:viewApplyMode];
    [viewOrderInfo addSubview:viewPaidNum];
    [viewOrderInfo addSubview:viewRemark];

    
    [svMain addSubview:viewGoodsInfo];
    [svMain addSubview:viewOrderInfo];
    
    
    if ([LyCurrentUser curUser].isBoss) {
        
        UIView *viewAlloc = [[UIView alloc] initWithFrame:CGRectMake(0, viewOrderInfo.ly_y+CGRectGetHeight(viewOrderInfo.frame)+verticalSpace, SCREEN_WIDTH, LyViewItemHeight)];
        [viewAlloc setBackgroundColor:[UIColor whiteColor]];
        UILabel *lbTitle_alloc = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, LyLbTitleItemWidth, LyViewItemHeight)];
        [lbTitle_alloc setFont:LyFont(15)];
        [lbTitle_alloc setTextColor:LyBlackColor];
        [lbTitle_alloc setText:@"分配教练"];
//        [lbTitle_alloc justifyTextAlignmentLeftAndRight];
        [lbTitle_alloc setTextAlignment:NSTextAlignmentLeft];
        
        btnDispatch = [[UIButton alloc] initWithFrame:CGRectMake(lbTitle_alloc.frame.origin.x+CGRectGetWidth(lbTitle_alloc.frame)+horizontalSpace, 0, SCREEN_WIDTH-horizontalSpace*4-LyLbTitleItemWidth-ivMoreSize, LyViewItemHeight)];
        [btnDispatch setTag:orderDetailButtonMode_dispatch];
        [btnDispatch.titleLabel setFont:LyFont(14)];
        [btnDispatch setTitle:@"请选择教练" forState:UIControlStateNormal];
        [btnDispatch setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
        [btnDispatch setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [btnDispatch addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *ivMore = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-ivMoreSize, LyViewItemHeight/2.0f-ivMoreSize/2.0f, ivMoreSize, ivMoreSize)];
        [ivMore setImage:[LyUtil imageForImageName:@"ivMore" needCache:NO]];
        
        
        [viewAlloc addSubview:lbTitle_alloc];
        [viewAlloc addSubview:btnDispatch];
        [viewAlloc addSubview:ivMore];
        
        
        
        [svMain addSubview:viewAlloc];
        
        CGFloat fCZHeight = viewAlloc.ly_y + CGRectGetHeight(viewAlloc.frame) + 50.0f;
        if (fCZHeight <= CGRectGetHeight(svMain.frame)) {
            fCZHeight = CGRectGetHeight(svMain.frame) * 1.05f;
        }
        [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, fCZHeight)];
        
    } else {
        
        CGFloat fCZHeight = viewOrderInfo.ly_y + CGRectGetHeight(viewOrderInfo.frame) + 50.0f;
        if (fCZHeight <= CGRectGetHeight(svMain.frame)) {
            fCZHeight = CGRectGetHeight(svMain.frame) * 1.05f;
        }
        [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, fCZHeight)];
        
    }
    
    
    
}




- (void)reloadData
{
    LyUser *student = [[LyUserManager sharedInstance] getUserWithUserId:_order.orderMasterId];
    if (!student)
    {
        NSString *studentName = [LyUtil getUserNameWithUserId:_order.orderMasterId];
        
        student = [LyUser userWithId:_order.orderMasterId
                            userNmae:studentName];
    }
    [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:student.userId]
                placeholderImage:[LyUtil defaultAvatarForStudent]
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                           if (image) {
                               [student setUserAvatar:image];
                           } else {
                               [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:student.userId]
                                           placeholderImage:[LyUtil defaultAvatarForStudent]
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                      if (image) {
                                                          [student setUserAvatar:image];
                                                      }
                                                  }];
                           }
                       }];
    [lbGoodsName setText:student.userName];
    [lbGoodsDetail setText:_order.orderDetail];
    [lbCreateTime setText:([LyUtil validateString:_order.orderTime] && _order.orderTime.length > 20) ? [_order.orderTime substringToIndex:20] : _order.orderTime];
    
    
    if (LyOrderMode_reservation == _order.orderMode) {
        if (LyUserType_guider == [LyCurrentUser curUser].userType) {
            
        } else {
            [lbTitle_address setText:@"培训场地"];
        }
    }

    
    [lbStuCount setText:[[NSString alloc] initWithFormat:@"%d人", _order.orderStudentCount]];
    [lbPhone setText:_order.orderPhoneNumber];
    [lbAddress setText:_order.orderAddress];
    [lbApplyMode setText:({
        NSString *strLbApplyMode;
        if ( LyApplyMode_prepay == _order.orderApplyMode) {
            strLbApplyMode = [[NSString alloc] initWithFormat:@"%@%.0f元" , lbNamePrepay, _order.orderPrice/_order.orderStudentCount];
        } else {
            strLbApplyMode = [[NSString alloc] initWithFormat:@"%@%.0f元" , lbNameWhole, _order.orderPrice/_order.orderStudentCount];
        }
        
        strLbApplyMode;
    })];
    [lbPaidNum setText:({
        NSString *strLbPaidNum;
        if (_order.orderPaidNum < 10) {
            strLbPaidNum = [[NSString alloc] initWithFormat:@"¥%.2f", _order.orderPaidNum];
        } else {
            strLbPaidNum = [[NSString alloc] initWithFormat:@"¥%.0f", _order.orderPaidNum];
        }
        strLbPaidNum;
    })];
    [lbRemark setText:_order.orderRemark];
    

    if (![_order.orderObjectId isEqualToString:_order.recipient]) {
        [btnDispatch setTitle:_order.recipientName forState:UIControlStateNormal];
    }
    
    

}


- (void)targetForButton:(UIButton *)button {
    if (orderDetailButtonMode_dispatch == button.tag) {
        LyOrderDispatchTableViewController *orderDispatch = [[LyOrderDispatchTableViewController alloc] init];
        [orderDispatch setDelegate:self];
        [self.navigationController pushViewController:orderDispatch animated:YES];
    }
}



#pragma mark -LyOrderDispatchTableViewControllerDelegate 
- (NSString *)obtainOrderIdByOrderDispatchTVC:(LyOrderDispatchTableViewController *)aOrderDispatchTVC {
    return _order.orderId;
}


- (void)onDisptachByOrderDispatchTVC:(LyOrderDispatchTableViewController *)aOrderDispatchTVC coach:(LyCoach *)coach {
    
    [aOrderDispatchTVC.navigationController popViewControllerAnimated:YES];
    
    [_order setRecipient:coach.userId];
    [_order setRecipientName:coach.userName];
    
    [self reloadData];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
