//
//  LyPayViewController.m
//  student
//
//  Created by Junes on 2016/11/21.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyPayViewController.h"
#import "LyPayTableViewCell.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyOrder.h"
#import "LyUserManager.h"
#import "LyPayManager.h"

#import "LyUtil.h"


#import <PassKit/PassKit.h>                                 //用户绑定的银行卡信息
#import <PassKit/PKPaymentAuthorizationViewController.h>    //Apple pay的展示控件
#import <AddressBook/AddressBook.h>                         //用户联系信息相关

#import "LyPaySuccessViewController.h"



CGFloat const payViewOrderHeight = 70.0f;
CGFloat const payIvAvatarSize = 50.0f;
CGFloat const payLbPriceHeight = 20.0f;
CGFloat const payLbGoodHeight = 30.0f;


CGFloat const payBtnPayHeight = 50.0f;


#define payTableViewHeightMax       (SCREEN_HEIGHT - viewOrder.frame.origin.y - payViewOrderHeight - payBtnPayHeight)


typedef NS_ENUM(NSInteger, LyPayButtonTag) {
    payButtonTag_pay = 10,
};

typedef NS_ENUM(NSInteger, LyPayHttpMethod) {
    payHttpMethod_pay = 100,
};


@interface LyPayViewController () <UITableViewDelegate, UITableViewDataSource, LyPayManagerDelegate, LyPaySuccessViewControllerDelegate>
{
    UIView              *viewOrder;
    UIImageView         *ivAvatar;
    UILabel             *lbPrice;
    UILabel             *lbGood;
    
    
    UIView              *viewControl;
    UIButton            *btnPay;
    
    
    NSArray             *arrPayMode;
    NSArray             *arrPayAddInfo;
    LyPayMode           curPayMode;
    
    BOOL                isSupportApplePay;
//    BOOL                isBindCardApplePay;
    
}

@property (strong, nonatomic)       UITableView         *tableView;
@end

@implementation LyPayViewController

static NSString *const lyPayTableViewCellReuseIdentifier = @"lyPayTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    _order = [_delegate orderOfPayViewController:self];
    if (!_order) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self reloadData_order];
}



- (void)initSubviews {
    
    self.title = @"支付订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = LyWhiteLightgrayColor;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    

    [self judgeApplePay];
    
    if (isSupportApplePay) {
        arrPayMode = @[
                       @"支付宝",
//                       @"微信支付",
                       @"中国银联",
                       @"Apple Pay",
                       ];
        
        arrPayAddInfo = @[
                      @"支付宝 知付托",
//                      @"微信支付 不只支付",
                      @"安全极速支付 无需开通网银",
                      @"推荐开通Apple Pay的用户使用",
                      ];
        
    } else {
        arrPayMode = @[
                       @"支付宝",
//                       @"微信支付",
                       @"中国银联",
                       ];
        
        arrPayAddInfo = @[
                      @"支付宝 知付托",
//                      @"微信支付 不只支付",
                      @"安全极速支付 无需开通网银",
                      ];
    }
    
    
    //订单信息
    viewOrder = [[UIView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT + verticalSpace, SCREEN_WIDTH, payViewOrderHeight)];
    [viewOrder setBackgroundColor:[UIColor whiteColor]];
    //订单信息-头像
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(horizontalSpace, payViewOrderHeight/2.0f - payIvAvatarSize/2.0f, payIvAvatarSize, payIvAvatarSize)];
    [ivAvatar.layer setCornerRadius:5.0f];
    [ivAvatar setClipsToBounds:YES];
    [ivAvatar setImage:[LyUtil imageForImageName:@"pay_Avatar" needCache:NO]];
    //订单信息-价格
    lbPrice = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace * 2 + payIvAvatarSize, ivAvatar.frame.origin.y, SCREEN_WIDTH - payIvAvatarSize - horizontalSpace * 3, payLbPriceHeight)];
    [lbPrice setFont:LyFont(16)];
    [lbPrice setTextColor:[UIColor blackColor]];
    [lbPrice setTextAlignment:NSTextAlignmentLeft];
    //订单信息-商品
    lbGood = [[UILabel alloc] initWithFrame:CGRectMake(lbPrice.frame.origin.x, lbPrice.frame.origin.y + CGRectGetHeight(lbPrice.frame), CGRectGetWidth(lbPrice.frame), payLbGoodHeight)];
    [lbGood setFont:LyFont(12)];
    [lbGood setTextColor:[UIColor grayColor]];
    [lbGood setTextAlignment:NSTextAlignmentLeft];
    [lbGood setNumberOfLines:0];
    
    [viewOrder addSubview:ivAvatar];
    [viewOrder addSubview:lbPrice];
    [viewOrder addSubview:lbGood];
    
    
    
    //控制台
    btnPay = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - payBtnPayHeight, SCREEN_WIDTH, payBtnPayHeight)];
    [btnPay setTag:payButtonTag_pay];
    [btnPay setTitle:@"立即付款" forState:UIControlStateNormal];
    [btnPay setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnPay setBackgroundColor:[UIColor whiteColor]];
    [btnPay addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:viewOrder];
    [self.view addSubview:self.tableView];
    [self.view addSubview:btnPay];
    
    
    
    curPayMode = LyPayMode_AliPay;
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        
        CGFloat fHeight = ptcHeight * arrPayMode.count;
        fHeight = fHeight > payTableViewHeightMax ? payTableViewHeightMax : fHeight;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, viewOrder.frame.origin.y + CGRectGetHeight(viewOrder.frame) + horizontalSpace, SCREEN_WIDTH, fHeight)
                                                  style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setShowsHorizontalScrollIndicator:NO];
        [_tableView setTableFooterView:[UIView new]];
        
        if (fHeight == ptcHeight * arrPayMode.count) {
            [_tableView setScrollsToTop:NO];
            [_tableView setScrollEnabled:NO];
        }
        [_tableView registerClass:[LyPayTableViewCell class] forCellReuseIdentifier:lyPayTableViewCellReuseIdentifier];
    }
    
    return _tableView;
}

- (void)reloadData_order {
    NSString *strPrice = nil;
    if (_order.orderPrice < 10) {
        strPrice = [[NSString alloc] initWithFormat:@"%.2f元", _order.orderPrice];
    } else {
        strPrice = [[NSString alloc] initWithFormat:@"%.0f元", _order.orderPrice];
    }
    [lbPrice setText:strPrice];
    
    [lbGood setText:[[NSString alloc] initWithFormat:@"%@ %@", _order.orderName, _order.orderDetail]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)judgeApplePay {
    //判断是否支持Apply Pay
    
    if (![PKPaymentAuthorizationViewController class])
    {
        //PKPaymentAuthorizationViewController需iOS8.0以上支持
        NSLog(@"操作系统不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持");
        
        isSupportApplePay = NO;
    }
    else
    {
        //检查当前设备是否可以支付
        if (![PKPaymentAuthorizationViewController canMakePayments]) {
            //支付需iOS9.0以上支持
            NSLog(@"设备不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持");
            
            isSupportApplePay = NO;
        }
        else
        {
//            isSupportApplePay = YES;
            
            //            NSArray *supportNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa, PKPaymentNetworkChinaUnionPay];
            NSArray *supportNetworks = @[PKPaymentNetworkChinaUnionPay];
            PKMerchantCapability merchantCapabilities = PKMerchantCapability3DS | PKMerchantCapabilityEMV | PKMerchantCapabilityDebit | PKMerchantCapabilityCredit;
            if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:supportNetworks capabilities:merchantCapabilities])
            {
                NSLog(@"没有绑定支付卡片");
                
                isSupportApplePay = NO;
//                isBindCardApplePay = NO;
            } else {
                
                isSupportApplePay = YES;
//                isBindCardApplePay = YES;
            }
        }
    }
}


- (void)targetForButton:(UIButton *)btn {
    LyPayButtonTag btnTag = btn.tag;
    switch (btnTag) {
        case payButtonTag_pay: {
            
            [[LyPayManager sharedInstance] payWithMode:curPayMode withOrder:_order andDelegate:self];
            break;
        }
        default: {
            break;
        }
    }
}



#pragma mark -LyPaySuccessViewControllerDelegate
- (void)onCloseByPayViewController:(LyPaySuccessViewController *)aPaySuccessVC {
    [_delegate payDoneViewControler:self order:_order];
}



#pragma mark -LyPayManagerDelegate
- (void)onPayErrorByPayManager:(LyPayManager *)aPayManager withOrder:(LyOrder *)aOrder errInfo:(NSString *)errInfo{
    if (!errInfo || errInfo.length < 1) {
        errInfo = @"支付出错";
    }
    [LyUtil showAlert:errInfo message:nil vc:self];
}

- (void)onPayFailedByPayManager:(LyPayManager *)aPayManager withOrder:(LyOrder *)aOrder errInfo:(NSString *)errInfo {
    if (!errInfo || errInfo.length < 1) {
        errInfo = @"支付失败";
    }
    
    [LyUtil showAlert:errInfo message:nil vc:self];
}

- (void)onPayCanceledByPayManager:(LyPayManager *)aPayManager withOrder:(LyOrder *)aOrder {
    [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"支付取消"] show];
}

- (void)onPaySuccessedByPayManager:(LyPayManager *)aPayManager withOrder:(LyOrder *)aOrder discount:(float)discount {
    
//    [_order setOrderState:LyOrderState_waitConfirm];
//    [_order setOrderPaidNum:_order.orderPrice - _order.orderPreferentialPrice];
    
//    [_delegate payDoneViewControler:self order:_order];
//    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"支付成功"] show];
    
    LyPaySuccessViewController *paySuccess = [[LyPaySuccessViewController alloc] init];
    [paySuccess setOrder:_order];
    [paySuccess setPayMode:curPayMode];
    [paySuccess setDiscount:discount];
    [paySuccess setDelegate:self];
    [self.navigationController pushViewController:paySuccess animated:YES];
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ptcHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    curPayMode = LyPayMode_AliPay + indexPath.row;
    
//    if (!isBindCardApplePay) {
//        [LyUtil showAlert:@"无法支付"
//                  message:@"你还未绑定卡片"
//                       vc:self];
//    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrPayMode.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyPayTableViewCellReuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[LyPayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyPayTableViewCellReuseIdentifier];
    }
    
    UIImage *icon = nil;
    NSString *title = arrPayMode[indexPath.row];
    NSString *detail = arrPayAddInfo[indexPath.row];
    UIImage *additionalimage = nil;
    BOOL isRecommend = NO;
    
    switch (indexPath.row + LyPayMode_AliPay) {
        case LyPayMode_517Pay: {
            icon = [LyUtil imageForImageName:@"payMode_517Pay" needCache:NO];
            isRecommend = YES;
            break;
        }
        case LyPayMode_AliPay: {
            icon = [LyUtil imageForImageName:@"payMode_AliPay" needCache:NO];
            isRecommend = YES;
            break;
        }
//        case LyPayMode_WeChatPay: {
//            icon = [LyUtil imageForImageName:@"payMode_WeChat" needCache:NO];
//            isRecommend = NO;
//            break;
//        }
        case LyPayMode_ChinaUnionPay: {
            icon = [LyUtil imageForImageName:@"payMode_ChinaUnion" needCache:NO];
            isRecommend = NO;
            break;
        }
        case LyPayMode_ApplePay: {
            icon = [LyUtil imageForImageName:@"payMode_ApplePay" needCache:NO];
            additionalimage = [LyUtil imageForImageName:@"payLogo_ChinaUnionPay" needCache:NO];
            isRecommend = NO;
            break;
        }
    }
    
    [cell setCellInfo:icon title:title detail:detail additaionalImage:additionalimage isRecommend:isRecommend];
    
    return cell;
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
