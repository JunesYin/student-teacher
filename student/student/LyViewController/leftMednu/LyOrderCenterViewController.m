//
//  LyOrderCenterViewController.m
//  student
//
//  Created by Junes on 2016/12/1.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyOrderCenterViewController.h"
#import "LyOrderModeView.h"
#import "LyOrderStateView.h"
#import "LyTableViewFooterView.h"
#import "LyOrderCenterTableViewCell.h"


#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyUserManager.h"
#import "LyCurrentUser.h"
#import "LyOrderManager.h"

#import "NSString+Validate.h"
#import "LyUtil.h"

#import "LyOrderInfoViewController.h"
#import "LySchoolDetailViewController.h"
#import "LyCoachDetailViewController.h"
#import "LyReservateCoachViewController.h"
#import "LyGuiderDetailViewController.h"
#import "LyReservateGuiderViewController.h"


#import "LyPayViewController.h"

#import "LyEvaluateOrderViewController.h"


typedef NS_ENUM(NSInteger, LyOrderCenterBarButtonItemTag) {
    orderCenterBarButtonItemTag_mode = 10,
};




@interface LyOrderCenterViewController () <UITableViewDelegate, UITableViewDataSource, LyOrderModeViewDelegate, LyOrderStateViewDelegate, LyTableViewFooterViewDelegate, LyOrderCenterTableViewCellDelegate, LySchoolDetailViewControllerDelegate, LyCoachDetailViewControllerDelegate, LyGuiderDetailViewControllerDelegate, LyPayViewControllerDelegate, LyOrderInfoViewControllerdelegate, LyEvaluateOrderViewControllerDelegate, LyReservateCoachViewControllerDelegate, LyReservateGuiderViewControllerDelegate>
{
    NSArray         *arrOrder;
    NSIndexPath     *curIdx;
    
    LyIndicator     *indicator;
    LyIndicator     *indicator_oper;
    
    BOOL        flagPush;
}

@property (strong, nonatomic)       LyOrderModeView     *orderModeView;
@property (strong, nonatomic)       LyOrderStateView    *orderStateView;

@property (strong, nonatomic)       UITableView     *tableView;
@property (strong, nonatomic)       UIRefreshControl        *refreshControl;
@property (strong, nonatomic)       LyTableViewFooterView       *tvFooterView;



@end

@implementation LyOrderCenterViewController

static NSString *const lyOrderCenterTableViewCellReuseIdentifier = @"lyOrderCenterTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.orderModeView setOrderMode:self.orderMode];
    [self.orderStateView setOrderState:self.orderState];
    
    [self reloadData:YES];
}

- (void)initSubviews {
    self.title = @"订单中心";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = LyWhiteLightgrayColor;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    UIBarButtonItem *bbiMode = [[UIBarButtonItem alloc] initWithTitle:@"分类"
                                                                style:UIBarButtonItemStyleDone
                                                               target:self
                                                               action:@selector(targetForBarButtonItem:)];
    bbiMode.tag = orderCenterBarButtonItemTag_mode;
    [self.navigationItem setRightBarButtonItem:bbiMode];
    
    
    [self.view addSubview:self.orderStateView];
    [self.view addSubview:self.tableView];
    
    if (!flagPush) {
        _orderMode = LyOrderMode_driveSchool;
        _orderState = 5;
    }
    
}

- (LyOrderModeView *)orderModeView {
    if (!_orderModeView) {
        _orderModeView = [[LyOrderModeView alloc] init];
        [_orderModeView setDelegate:self];
    }
    
    return _orderModeView;
}

- (LyOrderStateView *)orderStateView {
    if (!_orderStateView) {
        _orderStateView = [[LyOrderStateView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, LyOrderStateViewHeight)];;
        [_orderStateView setDelegate:self];
    }
    
    return _orderStateView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat y = self.orderStateView.frame.origin.y + LyOrderStateViewHeight;
        CGFloat height = SCREEN_HEIGHT - self.orderStateView.frame.origin.y - LyOrderStateViewHeight;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, height)
                                                  style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [_tableView registerClass:[LyOrderCenterTableViewCell class] forCellReuseIdentifier:lyOrderCenterTableViewCellReuseIdentifier];
        
        [_tableView addSubview:self.refreshControl];
        [_tableView setTableFooterView:self.tvFooterView];
    }
    
    return _tableView;
}

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [LyUtil refreshControlWithTitle:nil target:self action:@selector(refresh:)];
    }
    
    return _refreshControl;
}

- (LyTableViewFooterView *)tvFooterView {
    if (!_tvFooterView) {
        _tvFooterView = [LyTableViewFooterView tableViewFooterViewWithDelegate:self];
    }
    return _tvFooterView;
}


- (void)reloadData:(BOOL)needFlag {
    arrOrder = [[LyOrderManager sharedInstance] getOrderWithOrderStatus:self.orderState andOrderMode:self.orderMode];
    [self.tableView reloadData];
    
    if (needFlag) {
        if (!arrOrder || arrOrder.count < 1) {
            [self load];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setOrderMode:(LyOrderMode)orderMode {
    flagPush = YES;
    
    _orderMode = orderMode;
    [self reloadData:YES];
}

- (void)setOrderState:(LyOrderState)orderState {
    flagPush = YES;
    
    _orderState = orderState;
    [self reloadData:YES];
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    LyOrderCenterBarButtonItemTag bbiTag = bbi.tag;
    switch (bbiTag) {
        case orderCenterBarButtonItemTag_mode: {
            [self.orderModeView show];
            break;
        }
    }
}


- (void)refresh:(UIRefreshControl *)refresh {
    [self load];
}


- (void)handleHttpFailed:(BOOL)needRemind {
    if (indicator.isAnimating) {
        [indicator stopAnimation];
        
        [self.refreshControl endRefreshing];
        
        [self.tvFooterView setStatus:LyTableViewFooterViewStatus_error];
    }
    
    if (indicator_oper.isAnimating) {
        [indicator_oper stopAnimation];
        
        if (needRemind) {
            NSString *title = nil;
            if ([indicator_oper.title isEqualToString:LyIndicatorTitle_cancel]) {
                title = @"取消订单失败";
            } else if ([indicator_oper.title isEqualToString:LyIndicatorTitle_delete]) {
                title = @"删除订单失败";
            } else if ([indicator_oper.title isEqualToString:LyIndicatorTitle_confirm]) {
                title = @"确认学车失败";
            }
            
            [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:title];
        }
    }
    
    if (self.tvFooterView.isAnimating) {
        [self.tvFooterView stopAnimation];
        [self.tvFooterView setStatus:LyTableViewFooterViewStatus_error];
    }
}


- (NSDictionary *)analysisHttpResult:(NSString *)reuslt {
    NSDictionary *dic = [LyUtil getObjFromJson:reuslt];
    if (![LyUtil validateDictionary:dic]) {
        return nil;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (![LyUtil validateString:strCode]) {
        return nil;
    }
    
    if (codeTimeOut == strCode.intValue) {
        [self handleHttpFailed:NO];
        
        [LyUtil sessionTimeOut:self];
        return nil;
    }
    
    if (codeMaintaining == strCode.intValue) {
        [self handleHttpFailed:NO];
        
        [LyUtil serverMaintaining];
        return nil;
    }
    
    
    return dic;
}


- (void)load {
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(load) object:nil];
        return;
    }
    
    if (!indicator) {
        indicator = [[LyIndicator alloc] initWithTitle:@""];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:orderCenter_url
                    body:@{
                           masterIdKey:[[LyCurrentUser curUser] userId],
                           startKey:@(0),
                           orderModeKey:@(self.orderMode),
                           orderStateKey:@(self.orderState),
                           sessionIdKey:[LyUtil httpSessionId]
                           }
                    type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
           if (error) {
               [self handleHttpFailed:YES];
           } else {
               NSDictionary *dic = [self analysisHttpResult:resStr];
               if (!dic) {
                   [self handleHttpFailed:YES];
                   return ;
               }
               
               NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
               switch (strCode.integerValue) {
                   case 0: {
                       NSArray *arrResult = [dic objectForKey:resultKey];
                       if (![LyUtil validateArray:arrResult]) {
                           [indicator stopAnimation];
                           [self.refreshControl endRefreshing];
                           
                           [self.tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                           return;
                       }
                       
                       for (NSDictionary *dicItem in arrResult) {
                           if (![LyUtil validateDictionary:dicItem]) {
                               continue;
                           }
                           
                           NSString *strName = [dicItem objectForKey:orderNameKey];
                           NSString *strObjectid = [dicItem objectForKey:objectIdKey];
                           NSString *strPhone = [dicItem objectForKey:phoneKey];
                           NSString *strMasterId = [dicItem objectForKey:masterIdKey];
                           NSString *strStuCount = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:studentCountKey]];
                           NSString *strApplyMode = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:applyModeKey]];
                           NSString *strPrice = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:orderPriceKey]];
                           NSString *strPreferentialPrice = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:orderPreferentialPriceKey]];
                           NSString *strAddress = [dicItem objectForKey:addressKey];
                           NSString *strTrainBaseName = [dicItem objectForKey:trainBaseNameKey];
                           NSString *strRemark = [dicItem objectForKey:remarkKey];
                           NSString *strMode = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:orderModeKey]];
                           NSString *strPaidNum = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:paidNumKey]];
                           NSString *strConsginee = [dicItem objectForKey:consigneeKey];
                           NSString *strCouponMode = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:couponModeKey]];
                           NSString *strOrderId = [dicItem objectForKey:orderIdKey];
                           NSString *strTime = [dicItem objectForKey:orderTimeKey];
                           NSString *strPayTime = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:orderPayTimeKey]];
                           NSString *strOrderState = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:orderStateKey]];
                           NSString *strClassId = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:classIdKey]];
                           NSString *strClassName = [dicItem objectForKey:classNameKey];
                           NSString *strDetail = [dicItem objectForKey:orderDetailKey];
                           NSString *strOrderFlag = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:flagKey]];
                           
                           NSString *strDuration = [dicItem objectForKey:durationKey];
                           
                           if (![LyUtil validateString:strClassId]){
                               strClassId = @"";
                           }
                           
                           
                           if (![LyUtil validateString:strDuration]) {
                               strDuration = @"";
                           }
                           
                           if (strMode.integerValue < LyOrderMode_reservation)
                           {
                               LyTrainClass *tc = [[LyTrainClassManager sharedInstance] getTrainClassWithTrainClassId:strClassId];
                               if ( !tc)
                               {
                                   tc = [LyTrainClass trainClassWithTrainClassId:strClassId
                                                                          tcName:strClassName];
                                   
                                   [[LyTrainClassManager sharedInstance] addTrainClass:tc];
                               }
                           }
                           
                           
                           
                           LyUser *teacher = [[LyUserManager sharedInstance] getUserWithUserId:strObjectid];
                           if (!teacher) {
                               
                               NSString *userName = strName;
                               if (![LyUtil validateString:userName]) {
                                   userName = [LyUtil getUserNameWithUserId:strObjectid];
                               }
                               
                               switch (strMode.integerValue) {
                                   case LyOrderMode_driveSchool: {
                                       LyDriveSchool *school = [LyDriveSchool driveSchoolWithId:strObjectid dschName:userName];
                                       teacher = school;
                                       break;
                                   }
                                   case LyOrderMode_coach: {
                                       LyCoach *coach = [LyCoach coachWithId:strObjectid coaName:userName];
                                       teacher = coach;
                                       break;
                                   }
                                   case LyOrderMode_guider: {
                                       LyGuider *guider = [LyGuider guiderWithGuiderId:strObjectid guiName:userName];
                                       teacher = guider;
                                       break;
                                   }
                                   case LyOrderMode_reservation: {
                                       if ([strName rangeOfString:@"指导员"].length > 0) {
                                           LyGuider *guider = [LyGuider guiderWithGuiderId:strObjectid guiName:userName];
                                           teacher = guider;
                                       } else {
                                           LyCoach *coach = [LyCoach coachWithId:strObjectid coaName:userName];
                                           teacher = coach;
                                       }
                                       break;
                                   }
                                   case LyOrderMode_mall: {
                                       
                                       break;
                                   }
                                   case LyOrderMode_game: {
                                       
                                       break;
                                   }
                               }
                               
                               [[LyUserManager sharedInstance] addUser:teacher];
                           }
                           
                           
                           LyOrder *order = [LyOrder orderWithOrderId:strOrderId
                                                        orderMasterId:strMasterId
                                                            orderName:strName
                                                          orderDetail:strDetail
                                                       orderConsignee:strConsginee
                                                     orderPhoneNumber:strPhone
                                                         orderAddress:strAddress
                                                   orderTrainBaseName:strTrainBaseName
                                                            orderTime:strTime
                                                         orderPayTime:strPayTime
                                                        orderObjectId:strObjectid
                                                         orderClassId:strClassId
                                                          orderRemark:strRemark
                                                          orderStatus:[strOrderState integerValue]
                                                            orderMode:[strMode integerValue]
                                                    orderStudentCount:[strStuCount intValue]
                                                           orderPrice:[strPrice doubleValue]
                                               orderPreferentialPrice:[strPreferentialPrice doubleValue]
                                                         orderPaidNum:[strPaidNum doubleValue]
                                                       orderApplyMode:[strApplyMode integerValue]
                                                            orderFlag:[strOrderFlag intValue]];
                           
                           [order setOrderDuration:strDuration];
                           
                           [[LyOrderManager sharedInstance] addOrder:order];
                       }
                       
                       
                       [self reloadData:NO];
                       
                       [indicator stopAnimation];
                       [self.refreshControl endRefreshing];
                       [self.tvFooterView setStatus:LyTableViewFooterViewStatus_normal];
                       break;
                   }
                   default: {
                       [self handleHttpFailed:YES];
                       break;
                   }
               }
               
           }
       }];
}

- (void)loadMore {
    
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(loadMore) object:nil];
        return;
    }
    
    [self.tvFooterView startAnimation];
    
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:orderCenter_url
                    body:@{
                           masterIdKey:[LyCurrentUser curUser].userId,
                           startKey:@(arrOrder.count),
                           orderModeKey:@(self.orderMode),
                           orderStateKey:@(self.orderState),
                           sessionIdKey:[LyUtil httpSessionId]
                           }
                    type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
           if (error) {
               [self handleHttpFailed:YES];
           } else {
               NSDictionary *dic = [self analysisHttpResult:resStr];
               if (!dic) {
                   [self handleHttpFailed:YES];
                   return ;
               }
               
               NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
               switch (strCode.integerValue) {
                   case 0: {
                       NSArray *arrResult = [dic objectForKey:resultKey];
                       if (![LyUtil validateArray:arrResult]) {
                           [self.tvFooterView stopAnimation];
                           
                           [self.tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                           return;
                       }
                       
                       for (NSDictionary *dicItem in arrResult) {
                           if (![LyUtil validateDictionary:dicItem]) {
                               continue;
                           }
                           
                           NSString *strName = [dicItem objectForKey:orderNameKey];
                           NSString *strObjectid = [dicItem objectForKey:objectIdKey];
                           NSString *strPhone = [dicItem objectForKey:phoneKey];
                           NSString *strMasterId = [dicItem objectForKey:masterIdKey];
                           NSString *strStuCount = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:studentCountKey]];
                           NSString *strApplyMode = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:applyModeKey]];
                           NSString *strPrice = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:orderPriceKey]];
                           NSString *strPreferentialPrice = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:orderPreferentialPriceKey]];
                           NSString *strAddress = [dicItem objectForKey:addressKey];
                           NSString *strTrainBaseName = [dicItem objectForKey:trainBaseNameKey];
                           NSString *strRemark = [dicItem objectForKey:remarkKey];
                           NSString *strMode = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:orderModeKey]];
                           NSString *strPaidNum = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:paidNumKey]];
                           NSString *strConsginee = [dicItem objectForKey:consigneeKey];
                           NSString *strCouponMode = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:couponModeKey]];
                           NSString *strOrderId = [dicItem objectForKey:orderIdKey];
                           NSString *strTime = [dicItem objectForKey:orderTimeKey];
                           NSString *strPayTime = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:orderPayTimeKey]];
                           NSString *strOrderState = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:orderStateKey]];
                           NSString *strClassId = [dicItem objectForKey:classIdKey];
                           NSString *strClassName = [dicItem objectForKey:classNameKey];
                           NSString *strDetail = [dicItem objectForKey:orderDetailKey];
                           NSString *strOrderFlag = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:flagKey]];
                           
                           NSString *strDuration = [dicItem objectForKey:durationKey];
                           
                           if (![LyUtil validateString:strClassId]) {
                               strClassId = @"";
                           }
                           
                           if (![LyUtil validateString:strDuration]) {
                               strDuration = @"";
                           }
                           
                           
                           if ( [strMode integerValue] < LyOrderMode_reservation)
                           {
                               LyTrainClass *tc = [[LyTrainClassManager sharedInstance] getTrainClassWithTrainClassId:strClassId];
                               if ( !tc)
                               {
                                   tc = [LyTrainClass trainClassWithTrainClassId:strClassId
                                                                          tcName:strClassName];
                                   
                                   [[LyTrainClassManager sharedInstance] addTrainClass:tc];
                               }
                               
                           }
                           
                           LyUser *teacher = [[LyUserManager sharedInstance] getUserWithUserId:strObjectid];
                           if (!teacher) {
                               
                               NSString *userName = strName;
                               if (![LyUtil validateString:userName]) {
                                   userName = [LyUtil getUserNameWithUserId:strObjectid];
                               }
                               
                               switch (strMode.integerValue) {
                                   case LyOrderMode_driveSchool: {
                                       LyDriveSchool *school = [LyDriveSchool driveSchoolWithId:strObjectid dschName:userName];
                                       teacher = school;
                                       break;
                                   }
                                   case LyOrderMode_coach: {
                                       LyCoach *coach = [LyCoach coachWithId:strObjectid coaName:userName];
                                       teacher = coach;
                                       break;
                                   }
                                   case LyOrderMode_guider: {
                                       LyGuider *guider = [LyGuider guiderWithGuiderId:strObjectid guiName:userName];
                                       teacher = guider;
                                       break;
                                   }
                                   case LyOrderMode_reservation: {
                                       if ([strName rangeOfString:@"指导员"].length > 0) {
                                           LyGuider *guider = [LyGuider guiderWithGuiderId:strObjectid guiName:userName];
                                           teacher = guider;
                                       } else {
                                           LyCoach *coach = [LyCoach coachWithId:strObjectid coaName:userName];
                                           teacher = coach;
                                       }
                                       break;
                                   }
                                   case LyOrderMode_mall: {
                                       
                                       break;
                                   }
                                   case LyOrderMode_game: {
                                       
                                       break;
                                   }
                               }
                               
                               [[LyUserManager sharedInstance] addUser:teacher];
                           }
                           
                           
                           LyOrder *order = [LyOrder orderWithOrderId:strOrderId
                                                        orderMasterId:strMasterId
                                                            orderName:strName
                                                          orderDetail:strDetail
                                                       orderConsignee:strConsginee
                                                     orderPhoneNumber:strPhone
                                                         orderAddress:strAddress
                                                   orderTrainBaseName:strTrainBaseName
                                                            orderTime:strTime
                                                         orderPayTime:strPayTime
                                                        orderObjectId:strObjectid
                                                         orderClassId:strClassId
                                                          orderRemark:strRemark
                                                          orderStatus:[strOrderState integerValue]
                                                            orderMode:[strMode integerValue]
                                                    orderStudentCount:[strStuCount intValue]
                                                           orderPrice:[strPrice doubleValue]
                                               orderPreferentialPrice:[strPreferentialPrice doubleValue]
                                                         orderPaidNum:[strPaidNum doubleValue]
                                                       orderApplyMode:[strApplyMode integerValue]
                                                            orderFlag:[strOrderFlag intValue]];
                           
                           [order setOrderDuration:strDuration];
                           
                           [[LyOrderManager sharedInstance] addOrder:order];
                       }
                       
                       
                       
                       [self reloadData:YES];
                       [self.tvFooterView stopAnimation];
                       [self.tvFooterView setStatus:LyTableViewFooterViewStatus_normal];
                       break;
                   }
                   default: {
                       [self handleHttpFailed:YES];
                       break;
                   }
               }
           }
       }];
}

- (void)cancel {
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(cancel) object:nil];
        return;
    }
    
    if ( !indicator_oper) {
        indicator_oper = [[LyIndicator alloc] initWithTitle:LyIndicatorTitle_cancel];
    } else {
        [indicator_oper setTitle:LyIndicatorTitle_cancel];
    }
    [indicator_oper startAnimation];
    
    LyOrder *order = [arrOrder objectAtIndex:curIdx.row];
    
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:cancelOrder_url
                    body:@{
                           orderIdKey:order.orderId,
                           modeKey:@(order.orderMode),
                           masterIdKey:[[LyCurrentUser curUser] userId],
                           sessionIdKey:[LyUtil httpSessionId]
                           }
                    type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
           if (error) {
               [self handleHttpFailed:YES];
           } else {
               NSDictionary *dic = [self analysisHttpResult:resStr];
               if (!dic) {
                   [self handleHttpFailed:YES];
                   return ;
               }
               
               NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
               switch (strCode.integerValue) {
                   case 0: {
                       LyOrder *order = [arrOrder objectAtIndex:curIdx.row];
                       [order setOrderState:LyOrderState_cancel];
                       
                       [self reloadData:NO];
                       
                       [indicator_oper stopAnimation];
                       [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"取消订单成功"] show];
                       break;
                   }
                   default: {
                       [self handleHttpFailed:YES];
                       break;
                   }
               }
           }
       }];
}

- (void)delete {
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(delete) object:nil];
        return;
    }
    if ( !indicator_oper) {
        indicator_oper = [[LyIndicator alloc] initWithTitle:LyIndicatorTitle_delete];
    } else {
        [indicator_oper setTitle:LyIndicatorTitle_delete];
    }
    [indicator_oper startAnimation];
    
    LyOrder *order = [arrOrder objectAtIndex:curIdx.row];
    
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:deleteOrder_url
                    body:@{
                           orderIdKey:order.orderId,
                           modeKey:@(order.orderMode),
                           masterIdKey:[[LyCurrentUser curUser] userId],
                           sessionIdKey:[LyUtil httpSessionId]
                           }
                    type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
           if (error) {
               [self handleHttpFailed:YES];
           } else {
               NSDictionary *dic = [self analysisHttpResult:resStr];
               if (!dic) {
                   [self handleHttpFailed:YES];
                   return ;
               }
               
               NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
               switch (strCode.integerValue) {
                   case 0: {
                       LyOrder *order = [arrOrder objectAtIndex:curIdx.row];
                       [[LyOrderManager sharedInstance] removeOrder:order];
                       
                       [self reloadData:NO];
                       
                       [indicator_oper stopAnimation];
                       [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"删除订单成功"] show];
                       break;
                   }
                   default: {
                       [self handleHttpFailed:YES];
                       break;
                   }
               }
           }
       }];
}

- (void)confirm {
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(confirm) object:nil];
        return;
    }
    if ( !indicator_oper) {
        indicator_oper = [[LyIndicator alloc] initWithTitle:LyIndicatorTitle_confirm];
    } else {
        [indicator_oper setTitle:LyIndicatorTitle_confirm];
    }
    [indicator_oper startAnimation];
    
    LyOrder *order = [arrOrder objectAtIndex:curIdx.row];
    
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:confirmOrder_url
                    body:@{
                           orderIdKey:order.orderId,
                           orderModeKey:@(order.orderMode),
                           masterIdKey:[LyCurrentUser curUser].userId,
                           sessionIdKey:[LyUtil httpSessionId]
                           }
                    type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
           if (error) {
               [self handleHttpFailed:YES];
           } else {
               NSDictionary *dic = [self analysisHttpResult:resStr];
               if (!dic) {
                   [self handleHttpFailed:YES];
                   return ;
               }
               
               NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
               switch (strCode.integerValue) {
                   case 0: {
                       LyOrder *order = [arrOrder objectAtIndex:curIdx.row];
                       [order setOrderState:LyOrderState_waitEvalute];
                       
                       [self reloadData:NO];
                       
                       [indicator_oper stopAnimation];
                       [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"确认学车成功"] show];
                       break;
                   }
                   default: {
                       [self handleHttpFailed:YES];
                       break;
                   }
               }
           }
       }];
    
}


#pragma mark -LyOrderModeViewDelegate
- (void)orderModeView:(LyOrderModeView *)aOrderModeView didSelectedOrderMode:(LyOrderMode)aOrderMode {
    [self setOrderMode:aOrderMode];
}


#pragma mark -LyOrderStateViewDelegate
- (void)orderStateView:(LyOrderStateView *)aOrderStateView didSelectItemAtIndex:(LyOrderState)aOrderState {
    [self setOrderState:aOrderState];
}


#pragma mark -LyTableViewFooterViewDelegate
- (void)loadMoreData:(LyTableViewFooterView *)tableViewFooterView {
    [self loadMore];
}


#pragma mark -LySchoolDetailViewControllerDelegate
- (NSString *)schoolIdBySchoolDetailViewController:(LySchoolDetailViewController *)aSchoolDetailVC
{
    return [arrOrder[curIdx.row] orderObjectId];
}



#pragma mark -LyCoachDetailViewControllerDelegate
- (NSString *)coachIdByCoachDetailViewController:(LyCoachDetailViewController *)aCoachDetailVC
{
    return [arrOrder[curIdx.row] orderObjectId];
}

#pragma mark -LyGuiderDetailViewControllerDelegate
- (NSString *)userIdByGuiderDetailViewController:(LyGuiderDetailViewController *)aGuiderDetailVC
{
    return [arrOrder[curIdx.row] orderObjectId];
}



#pragma mark -LyReservateCoachViewControllerDelegate
- (NSDictionary *)obtainCoachObjectByReservateCoachViewController:(LyReservateCoachViewController *)aReservateCoach
{
    return @{
             coachIdKey:[[arrOrder objectAtIndex:curIdx.row] orderObjectId],
             subjectModeKey:@(LySubjectModeprac_second)
             };
}

#pragma mark -LyReservateGuiderViewControllerDelegate
- (NSString *)obtainGuiderIdByReservateGuiderVC:(LyReservateGuiderViewController *)aReservateGuiderVC
{
    return [[arrOrder objectAtIndex:curIdx.row] orderObjectId];
}

#pragma mark -LyPayViewControllerDelegate
- (LyOrder *)orderOfPayViewController:(LyPayViewController *)aPayVC {
    return [arrOrder objectAtIndex:curIdx.row];
}

- (void)payDoneViewControler:(LyPayViewController *)aPayVC order:(LyOrder *)order {
    [aPayVC.navigationController popToViewController:self animated:YES];
    
    [self.tableView reloadRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -LyOrderInfoViewControllerdelegate
- (LyOrder *)obtainOrderByOrderInfoViewController:(LyOrderInfoViewController *)aOrderInfoVC {
    return [arrOrder objectAtIndex:curIdx.row];
}


#pragma mark -LyOrderCenterTableViewCellDelegate
- (void)onClickedCancelByOrderCenterTableViewCell:(LyOrderCenterTableViewCell *)aCell
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(onClickedCancelByOrderCenterTableViewCell:) object:aCell];
        return;
    }
    
    curIdx = [self.tableView indexPathForCell:aCell];
    
    NSString *strTitle = nil;
    NSString *strMessage = nil;
    //    NSString *strCancelTitle = nil;
    
    if (LyOrderMode_reservation == aCell.order.orderMode) {
        if ([LyUtil isAvaiableToCancelReservation:aCell.order]) {
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:[[NSString alloc] initWithFormat:@"取消预约须在前一天「%d:00」前", lastestClickForCancelReser]] show];
            return;
        }
        
        strTitle = @"取消预约";
        strMessage = @"你确定要取消预约吗？";
        
    } else {
        
        strTitle = @"取消订单";
        strMessage = @"你确定要取消订单吗？";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:strTitle
                                                                   message:strMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:strTitle
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self cancel];
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)onClickedDeleteByOrderCenterTableViewCell:(LyOrderCenterTableViewCell *)aCell
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(onClickedDeleteByOrderCenterTableViewCell:) object:aCell];
        return;
    }
    
    curIdx = [self.tableView indexPathForCell:aCell];
    
    NSString *strTitle = nil;
    NSString *strMessage = nil;
    
    if (LyOrderMode_reservation == aCell.order.orderMode) {
        if ([LyUtil isAvaiableToCancelReservation:aCell.order]) {
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:[[NSString alloc] initWithFormat:@"取消预约须在前一天「%d:00」前", lastestClickForCancelReser]] show];
            return;
        }
        
        strTitle = @"取消预约";
        strMessage = @"你确定要取消预约吗？";
        
    } else {
        strTitle = @"删除订单";
        strMessage = @"删除订单之后将无法找回，你确定要删除吗？";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:strTitle
                                                                   message:strMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:strTitle
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self delete];
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)onClickedPayByOrderCenterTableViewCell:(LyOrderCenterTableViewCell *)aCell
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(onClickedPayByOrderCenterTableViewCell:) object:aCell];
        return;
    }
    
    curIdx = [self.tableView indexPathForCell:aCell];

    
    LyPayViewController *payVC = [[LyPayViewController alloc] init];
    [payVC setDelegate:self];
    [self.navigationController pushViewController:payVC animated:YES];
    
}

- (void)onClickedReapplyByOrderCenterTableViewCell:(LyOrderCenterTableViewCell *)aCell
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(onClickedReapplyByOrderCenterTableViewCell:) object:aCell];
        return;
    }
    
    
    curIdx = [self.tableView indexPathForCell:aCell];
    
    LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:[[aCell order] orderObjectId]];
    switch ( [user userType]) {
        case LyUserType_normal: {
            //nothing
            break;
        }
        case LyUserType_coach: {
            if (LyOrderMode_reservation == [[arrOrder objectAtIndex:curIdx.row] orderMode]) {
                LyReservateCoachViewController *reservateCoach = [[LyReservateCoachViewController alloc] init];
                [reservateCoach setDelegate:self];
                [self.navigationController pushViewController:reservateCoach animated:YES];
            } else {
                LyCoachDetailViewController *coachDetail = [[LyCoachDetailViewController alloc] init];
                [coachDetail setDelegate:self];
                [self.navigationController pushViewController:coachDetail animated:YES];
            }
            break;
        }
        case LyUserType_school: {
            LySchoolDetailViewController *sd = [[LySchoolDetailViewController alloc] init];
            [sd setDelegate:self];
            [self.navigationController pushViewController:sd animated:YES];
            break;
        }
        case LyUserType_guider: {
            if (LyOrderMode_reservation == [[arrOrder objectAtIndex:curIdx.row] orderMode]) {
                LyReservateGuiderViewController *reservateGuider = [[LyReservateGuiderViewController alloc] init];
                [reservateGuider setDelegate:self];
                [self.navigationController pushViewController:reservateGuider animated:YES];
            } else {
                LyGuiderDetailViewController *ged = [[LyGuiderDetailViewController alloc] init];
                [ged setDelegate:self];
                [self.navigationController pushViewController:ged animated:YES];
            }
            break;
        }
    }
}

- (void)onClickedConfirmByOrderCenterTableViewCell:(LyOrderCenterTableViewCell *)aCell
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(onClickedConfirmByOrderCenterTableViewCell:) object:aCell];
        return;
    }
    
    
    curIdx = [self.tableView indexPathForCell:aCell];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认学车"
                                                                   message:@"确认学车后系统将自动把钱打给对方， 你确定要确认学车吗？"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"我已学车"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self confirm];
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)onClickedEvaluteByOrderCenterTableViewCell:(LyOrderCenterTableViewCell *)aCell
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(onClickedEvaluteByOrderCenterTableViewCell:) object:aCell];
        return;
    }
    
    curIdx = [self.tableView indexPathForCell:aCell];
    
    LyEvaluateOrderViewController *evaluateOrderVC = [[LyEvaluateOrderViewController alloc] init];
    [evaluateOrderVC setDelegate:self];
    [self.navigationController pushViewController:evaluateOrderVC animated:YES];
}

- (void)onClickedEvaluteAgainByOrderCenterTableViewCell:(LyOrderCenterTableViewCell *)aCell
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(onClickedEvaluteAgainByOrderCenterTableViewCell:) object:aCell];
        return;
    }
    
    curIdx = [self.tableView indexPathForCell:aCell];
    
    LyEvaluateOrderViewController *evaluateOrderVC = [[LyEvaluateOrderViewController alloc] init];
    [evaluateOrderVC setDelegate:self];
    [evaluateOrderVC setMode:LyEvaluateOrderViewControllerMode_evaluateAgain];
    [self.navigationController pushViewController:evaluateOrderVC animated:YES];
}



#pragma mark -LyEvaluateOrderViewControllerDelegate
- (LyOrder *)obtainOrderByEvaluateOrderViewController:(LyEvaluateOrderViewController *)aEvaluateOrderVC
{
    return [arrOrder objectAtIndex:curIdx.row];
}

- (void)onDoneByEvaluateOrderViewController:(LyEvaluateOrderViewController *)aEvaluateOrderVC
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.tableView reloadRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationNone];
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return octcHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    curIdx = indexPath;
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    LyOrderInfoViewController *orderInfo = [[LyOrderInfoViewController alloc] init];
    [orderInfo setDelegate:self];
    [self.navigationController pushViewController:orderInfo animated:YES];
}



#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (arrOrder.count < 1) {
        [self.tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
    } else {
        [self.tvFooterView setStatus:LyTableViewFooterViewStatus_normal];
    }
    
    return arrOrder.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyOrderCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyOrderCenterTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[LyOrderCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyOrderCenterTableViewCellReuseIdentifier];
    }
    [cell setOrder:arrOrder[indexPath.row]];
    [cell setDelegate:self];
    
    return cell;
}


#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.tableView) {
        if ([scrollView contentOffset].y + CGRectGetHeight([scrollView frame]) + tvFooterViewDefaultHeight > [scrollView contentSize].height && scrollView.contentSize.height > scrollView.frame.size.height) {
            [self loadMore];
        }
    }
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
