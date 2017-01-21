//
//  LyPaySuccessViewController.m
//  student
//
//  Created by Junes on 2016/11/24.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyPaySuccessViewController.h"
#import "LyOrderInfoTableViewCell.h"

#import "LyOrder.h"

#import "UIViewController+backButtonHandler.h"
#import "LyUtil.h"

#import "LyOrderCenterViewController.h"
#import "LyOrderInfoViewController.h"
#import "LyDriveExamTableViewController.h"


#define psViewPayInfoHeight             (SCREEN_WIDTH * 4 / 7.0f)
CGFloat const psIvFlagSize = 60.0f;
CGFloat const psLbPaidNumHeight = 40.0f;
CGFloat const psIvLogoHeight = psLbPaidNumHeight;
CGFloat const psIvLogoWidth = psIvLogoHeight * 3;
#define psLbPaidNumFont                 LyFont(16)


//优惠信息
CGFloat const psViewHeaderHeight = 70.0f;
#define psHeaderLbWidth                 ((SCREEN_WIDTH - horizontalSpace * 5) / 2.0f)
CGFloat const psHeaderLbHeight = 30.0f;
#define psHeaderLbFont                  LyFont(16)
#define psHeaderLbTextColor             [UIColor redColor]


typedef NS_ENUM(NSInteger, LyPaySUccessButtonTag) 
{
    paySuccessButtonTag_home = 20,
//    paySuccessButtonTag_order,
    paySuccessButtonTag_driveExam
};



@interface LyPaySuccessViewController () <UITableViewDelegate, UITableViewDataSource, LyOrderInfoViewControllerdelegate>
{
    UIView                  *viewPayInfo;
    UIImageView             *ivLogo;
    UILabel                 *lbPaidNum;
    
    UIView                  *viewHeader;
    UILabel                 *lbPayType;
    UILabel                 *lbDiscount;
    
    UIView                  *viewFooter;
    UILabel                 *lbFooter;
    
    UIView                  *controlBar;
}

@property (strong, nonatomic)       UITableView         *tableView;

@end

@implementation LyPaySuccessViewController


static NSString *const lyPaySuccessTableViewCellReuseIdentifier = @"lyPaySuccessTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];

    [self reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}

- (void)initSubviews {
    
    self.title = @"支付成功";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = LyWhiteLightgrayColor;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    viewPayInfo = [[UIView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, psViewPayInfoHeight)];
    [viewPayInfo setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *ivFlag = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f - psIvFlagSize/2.0f, psViewPayInfoHeight / 4.0f, psIvFlagSize, psIvFlagSize)];
    [ivFlag setImage:[LyUtil imageForImageName:@"paySuccess" needCache:NO]];
    
    lbPaidNum = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f + verticalSpace, ivFlag.frame.origin.y + psIvFlagSize + horizontalSpace, SCREEN_WIDTH / 2.0f - verticalSpace * 2, psLbPaidNumHeight)];
    [lbPaidNum setFont:psLbPaidNumFont];
    [lbPaidNum setTextColor:[UIColor blackColor]];
    [lbPaidNum setTextAlignment:NSTextAlignmentLeft];
    
    ivLogo = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f - verticalSpace - psIvLogoWidth, lbPaidNum.frame.origin.y + psLbPaidNumHeight/2.0f - psIvLogoHeight/2.0f, psIvLogoWidth, psIvLogoHeight)];
    [ivLogo setContentMode:UIViewContentModeScaleAspectFit];
    
    
    [viewPayInfo addSubview:ivFlag];
    [viewPayInfo addSubview:lbPaidNum];
    [viewPayInfo addSubview:ivLogo];
    
    
    
    viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, psViewHeaderHeight)];
    [viewHeader setBackgroundColor:[UIColor whiteColor]];

    NSString *strTitle = @"优惠明细";
    CGFloat fWidthLbTitle = [strTitle sizeWithAttributes:@{NSFontAttributeName : psHeaderLbFont}].width + horizontalSpace;
    UILabel *lbTitle = [[UILabel alloc]initWithFrame:CGRectMake(horizontalSpace * 2, verticalSpace, fWidthLbTitle, psHeaderLbHeight)];
    [lbTitle setFont:psHeaderLbFont];
    [lbTitle setTextColor:[UIColor whiteColor]];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    [lbTitle setBackgroundColor:psHeaderLbTextColor];
    [lbTitle.layer setCornerRadius:2.0f];
    [lbTitle setClipsToBounds:YES];
    [lbTitle setText:strTitle];
    
    lbPayType = [[UILabel alloc] initWithFrame:CGRectMake(lbTitle.frame.origin.x, lbTitle.frame.origin.y + CGRectGetHeight(lbTitle.frame), psHeaderLbWidth, psHeaderLbHeight)];
    [lbPayType setFont:psHeaderLbFont];
    [lbPayType setTextColor:psHeaderLbTextColor];
    [lbPayType setTextAlignment:NSTextAlignmentLeft];
    
    lbDiscount = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - horizontalSpace * 2 - psHeaderLbWidth, psViewHeaderHeight/2.0f - psHeaderLbHeight / 2.0f, psHeaderLbWidth, psHeaderLbHeight)];
    [lbDiscount setFont:psHeaderLbFont];
    [lbDiscount setTextColor:psHeaderLbTextColor];
    [lbDiscount setTextAlignment:NSTextAlignmentRight];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, psViewHeaderHeight - verticalSpace, SCREEN_WIDTH, verticalSpace)];
    [horizontalLine setBackgroundColor:LyWhiteLightgrayColor];
    
    [viewHeader addSubview:lbTitle];
    [viewHeader addSubview:lbPayType];
    [viewHeader addSubview:lbDiscount];
    [viewHeader addSubview:horizontalLine];
    
    viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LyControlBarHeight)];
    [viewFooter setBackgroundColor:[UIColor whiteColor]];
    
    lbFooter = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace * 2, 0, SCREEN_WIDTH - horizontalSpace * 4, 30)];
    [lbFooter setFont:LyFont(14)];
    [lbFooter setTextColor:[UIColor darkGrayColor]];
    [lbFooter setTextAlignment:NSTextAlignmentCenter];
    [lbFooter setNumberOfLines:0];
    
    [viewFooter addSubview:lbFooter];
    
    

    controlBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - LyControlBarHeight, SCREEN_WIDTH, LyControlBarHeight)];
    [controlBar setBackgroundColor:LyWhiteLightgrayColor];

    UIButton *btnFunc_home = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - (LyControlBarButtonWidth * 2)) / 3.0f, LyControlBarHeight/2.0f - LyControlBarButtonHeight/2.0f, LyControlBarButtonWidth, LyControlBarButtonHeight)];
    [btnFunc_home setTag:paySuccessButtonTag_home];
    [btnFunc_home setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnFunc_home setTitle:@"回到首页" forState:UIControlStateNormal];
    [btnFunc_home setBackgroundColor:[UIColor whiteColor]];
    [[btnFunc_home layer] setCornerRadius:btnCornerRadius];
    [[btnFunc_home layer] setBorderWidth:1.0f];
    [[btnFunc_home layer] setBorderColor:[Ly517ThemeColor CGColor]];
    [btnFunc_home addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *btnFunc_driveExam = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH-LyControlBarButtonWidth-(SCREEN_WIDTH-LyControlBarButtonWidth*2)*2/5, LyControlBarHeight/2-LyControlBarButtonHeight/2, LyControlBarButtonWidth, LyControlBarButtonHeight)];
    [btnFunc_driveExam setTag:paySuccessButtonTag_driveExam];
    [btnFunc_driveExam setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnFunc_driveExam setTitle:@"预约学车" forState:UIControlStateNormal];
    [[btnFunc_driveExam layer] setCornerRadius:btnCornerRadius];
    [btnFunc_driveExam setBackgroundColor:Ly517ThemeColor];
    [btnFunc_driveExam addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];

    
    
    
    [controlBar addSubview:btnFunc_home];
    [controlBar addSubview:btnFunc_driveExam];
    
    [self.view addSubview:viewPayInfo];
    [self.view addSubview:self.tableView];
    [self.view addSubview:controlBar];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, viewPayInfo.frame.origin.y + psViewPayInfoHeight + verticalSpace, SCREEN_WIDTH, SCREEN_HEIGHT - viewPayInfo.frame.origin.y - psViewPayInfoHeight)
                                                  style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setShowsVerticalScrollIndicator:NO];
        
        [_tableView registerClass:[LyOrderInfoTableViewCell class] forCellReuseIdentifier:lyPaySuccessTableViewCellReuseIdentifier];
        
        [_tableView setTableHeaderView:viewHeader];
        [_tableView setTableFooterView:viewFooter];
    }
    
    return _tableView;
}


- (void)reloadData {
    [self reloadData_logo];
    [self reloadData_header];
    [self.tableView reloadData];
}

- (void)reloadData_logo {
    NSString *strLogoName = nil;
    switch (_payMode) {
        case LyPayMode_517Pay:{
            strLogoName = @"payLogo_517Pay";
            break;
        }
        case LyPayMode_AliPay: {
            strLogoName = @"payLogo_AliPay";
            break;
        }
//        case LyPayMode_WeChatPay: {
//            strLogoName = @"payLogo_WeChatPay";
//            break;
//        }
        case LyPayMode_ChinaUnionPay: {
            //            strPayMode = @"payLogo_ChinaUnionPay";
            //            break;
        }
        case LyPayMode_ApplePay: {
            strLogoName = @"payLogo_ChinaUnionPay";
            break;
        }
    }

    [ivLogo setImage:[LyUtil imageForImageName:strLogoName needCache:NO]];
    
    [lbPaidNum setText:[[NSString alloc] initWithFormat:@"支付金额：%.2f元", _order.orderPaidNum]];
    
}

- (void)reloadData_header {
    NSString *strPayMode = nil;
    switch (_payMode) {
        case LyPayMode_517Pay:{
            strPayMode = @"517支付";
            break;
        }
        case LyPayMode_AliPay: {
            strPayMode = @"支付宝";
            break;
        }
//        case LyPayMode_WeChatPay: {
//            strPayMode = @"微信支付";
//            break;
//        }
        case LyPayMode_ChinaUnionPay: {
//            strPayMode = @"云闪付";
//            break;
        }
        case LyPayMode_ApplePay: {
            strPayMode = @"云闪付";
            break;
        }
    }
    [lbPayType setText:[[NSString alloc] initWithFormat:@"%@立减优惠", strPayMode]];
    
    [lbDiscount setText:[[NSString alloc] initWithFormat:@"-￥%.2f", _discount]];
    
    [lbFooter setAttributedText:({
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"若还需要预约，请点击“预约学车”"];
        [str addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[@"若还需要预约，请点击“预约学车”" rangeOfString:@"预约学车"]];
        str;
    })];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)targetForButton:(UIButton *)btn {
    LyPaySUccessButtonTag btnTag = btn.tag;
    switch (btnTag) {
        case paySuccessButtonTag_home: {
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        }
//        case paySuccessButtonTag_order: {
//            NSInteger index = 0;
//            NSArray *viewControllers = self.navigationController.viewControllers;
//            for (UIViewController *viewController in viewControllers) {
//                if ([viewController isKindOfClass:[LyOrderInfoViewController class]]) {
//                    index = [viewControllers indexOfObject:viewController];
//                    break;
//                }
//            }
//
//            if (0 < index && index < viewControllers.count) {
//                UIViewController *viewController = [viewControllers objectAtIndex:index];
//                [self.navigationController popToViewController:viewController animated:YES];
//            } else {
//                LyOrderInfoViewController *orderInfo = [[LyOrderInfoViewController alloc] init];
//                [orderInfo setDelegate:self];
//                [self.navigationController pushViewController:orderInfo animated:YES];
//            }
//
//            break;
//        }
        case paySuccessButtonTag_driveExam: {
            NSInteger index = 0;
            NSArray *viewControllers = self.navigationController.viewControllers;
            for (UIViewController *viewController in viewControllers) {
                if ([viewController isKindOfClass:[LyDriveExamTableViewController class]]) {
                    index = [viewControllers indexOfObject:viewController];
                    break;
                }
            }
            
            if (0 < index && index < viewControllers.count) {
                UIViewController *viewController = [viewControllers objectAtIndex:index];
                [self.navigationController popToViewController:viewController animated:YES];
            } else {
                LyDriveExamTableViewController *driveExam = [[LyDriveExamTableViewController alloc] init];
                [self.navigationController pushViewController:driveExam animated:YES];
            }
            
        }
    }
}


#pragma mark -LyOrderInfoViewControllerDelegate
- (LyOrder *)obtainOrderByOrderInfoViewController:(LyOrderInfoViewController *)aOrderInfoVC {
    return _order;
}


- (BOOL)navigationShouldPopOnBackButton {
    if (_delegate && [_delegate respondsToSelector:@selector(onCloseByPayViewController:)]) {
        [_delegate onCloseByPayViewController:self];
    } else {
        NSArray *viewControllers = self.navigationController.viewControllers;
        UIViewController *viewController = viewControllers[[viewControllers indexOfObject:self] - 2];
        [self.navigationController popToViewController:viewController animated:YES];
    }
    
    return NO;
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return oitcHeight;
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyOrderInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyPaySuccessTableViewCellReuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[LyOrderInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyPaySuccessTableViewCellReuseIdentifier];
    }

    NSString *title = nil;
    NSString *detail = nil;
    switch (indexPath.row) {
        case 0: {
            title = @"商户名称";
            detail = @"我要去学车";
            break;
        }
        case 1: {
            title = @"交易时间";
            detail = [LyUtil validateString:_order.orderPayTime] ? _order.orderPayTime : [LyUtil stringFromDate:[NSDate date]];
            break;
        }
        case 2: {
            title = @"交易单号";
//            detail = [LyUtil validateString:_order.tradeNo] ? _order.tradeNo : _order.orderId;
            detail = _order.orderId;
            break;
        }
        default: {
            break;
        }
    }
    
    [cell setCellInfo:title detail:detail];
    [cell setMode:LyOrderInfoTableViewCellMode_paySuccess];
    
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
