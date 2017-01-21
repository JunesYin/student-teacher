//
//  LyOrderCenterViewController.m
//  teacher
//
//  Created by Junes on 16/8/15.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyOrderCenterViewController.h"
#import "LyDateView.h"
#import "LyOrderStateView.h"
#import "LyOrderCenterTableViewCell.h"
#import "LyTableViewFooterView.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyUserManager.h"
#import "LyOrderManager.h"

#import "LyUtil.h"


#import "LyOrderDetailViewController.h"
#import "LyOrderDispatchTableViewController.h"


typedef NS_ENUM(NSInteger, LyOrderCenterHttpMethod) {
    orderCenterHttpMethod_load = 100,
    orderCenterHttpMethod_loadMore,
    orderCenterHttpMethod_loadWithDate,
};


@interface LyOrderCenterViewController () <UITableViewDelegate, UITableViewDataSource, LyDateViewDelegate, LyOrderStateViewDelegate, LyHttpRequestDelegate, LyTableViewFooterViewDelegate, LyOrderDetailViewControllerDelegate, LyOrderDispatchTableViewControllerDelegate, LyOrderCenterTableViewCellDelegate>
{
    LyDateView                  *dateView;
//    LyOrderStateView            *orderStateView;
    
    NSArray                     *arrOrder;
    LyOrderPayStatus            curOrderPayStatus;
    NSIndexPath                 *curIdx;
    
    LyIndicator                 *indicator;
    BOOL                        bHttpFlag;
    LyOrderCenterHttpMethod     curHttpMethod;
    
    
    BOOL        flagPush;
}

@property (strong, nonatomic)       LyOrderStateView        *orderStateView;

@property (strong, nonatomic)   UIRefreshControl        *refreshControl;
@property (strong, nonatomic)   UITableView             *tableView;
@property (strong, nonatomic)   LyTableViewFooterView   *tvFooter;
@end


@implementation LyOrderCenterViewController

static NSString *lyOrderCenterTvOrdersCellReuseIdentifier = @"lyOrderCenterTvOrdersCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}


- (void)viewWillAppear:(BOOL)animated {
    [self.orderStateView setOrderState:self.orderState];
    
    [self load];
}


- (void)initSubviews
{
    self.title = @"订单中心";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    dateView = [[LyDateView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, LyDateViewHeight)];
    [dateView setDelegate:self];
    [self.view addSubview:dateView];
    
    
    [self.view addSubview:self.orderStateView];
    
    [self.view addSubview:self.tableView];
    
    
    if (!flagPush) {
        _orderState = 5;
    }
}


- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [LyUtil refreshControlWithTitle:nil
                                                   target:self
                                                   action:@selector(refresh:)];
        [self.tableView addSubview:_refreshControl];
    }
    
    return _refreshControl;
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
        CGFloat y = self.orderStateView.ly_y+CGRectGetHeight(self.orderStateView.frame);
        CGFloat height = SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-LyDateViewHeight-LyOrderStateViewHeight;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, height)
                                                style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:[LyOrderCenterTableViewCell class] forCellReuseIdentifier:lyOrderCenterTvOrdersCellReuseIdentifier];
        
        
        [_tableView setTableFooterView:self.tvFooter];
    }
    
    return _tableView;
}

- (LyTableViewFooterView *)tvFooter {
    if (!_tvFooter) {
        _tvFooter = [LyTableViewFooterView tableViewFooterViewWithDelegate:self];
    }
    
    return _tvFooter;
}


- (void)reloadData:(BOOL)needFlag {
    
    arrOrder = [[LyOrderManager sharedInstance] getOrderWithOrderStatus:curOrderPayStatus
                                                                dtaStart:dateView.dateStart
                                                                 dataEnd:dateView.dateEnd
                                                                  userId:[LyCurrentUser curUser].userId];
    
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


- (void)setOrderState:(LyOrderState)orderState {
    flagPush = YES;
    
    _orderState = orderState;
    [self reloadData:YES];
}


- (void)refresh:(UIRefreshControl *)rc {
    [self load];
}


- (void)load {
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:nil];
    }
    [indicator startAnimation];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[LyCurrentUser curUser].userId forKey:userIdKey];
//    [dic setObject:[[LyCurrentUser curUser] userTypeByString] forKey:userTypeKey];
    [dic setObject:({
        NSString *strUserType = [[LyCurrentUser curUser] userTypeByString];
        if ([strUserType isEqualToString:teacherCoachKey]) {
            if (LyCoachMode_alone == [LyCurrentUser curUser].coachMode || LyCoachMode_boss == [LyCurrentUser curUser].coachMode) {
                strUserType = @"sjl";
            }
        }
        strUserType;
    }) forKey:userTypeKey];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    [dic setObject:@(0) forKey:startKey];
    [dic setObject:@(curOrderPayStatus) forKey:orderStateKey];
    
    if (dateView.dateStart && dateView.dateEnd) {
        [dic setObject:[LyUtil stringOnlyDateFromDate:dateView.dateStart] forKey:startDateKey];
        [dic setObject:[LyUtil stringOnlyDateFromDate:[dateView.dateEnd dateByAddingTimeInterval:3600 * 24]] forKey:endDateKey];
    }
    
//    if (LyUserType_coach == [LyCurrentUser curUser].userType) {
//        [dic setObject:@([LyCurrentUser curUser].coachMode) forKey:coachModeKey];
//    }
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:orderCenterHttpMethod_load];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:orderCenter_url
                                 body:dic
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)loadWithDate {
    
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:nil];
    }
    [indicator startAnimation];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[LyCurrentUser curUser].userId forKey:userIdKey];
    [dic setObject:({
        NSString *strUserType = [[LyCurrentUser curUser] userTypeByString];
        if ([strUserType isEqualToString:teacherCoachKey]) {
            if (LyCoachMode_alone == [LyCurrentUser curUser].coachMode || LyCoachMode_boss == [LyCurrentUser curUser].coachMode) {
                strUserType = @"sjl";
            }
        }
        strUserType;
    }) forKey:userTypeKey];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    [dic setObject:@(0) forKey:startKey];
    [dic setObject:@(curOrderPayStatus) forKey:orderStateKey];
    
    [dic setObject:[LyUtil stringOnlyDateFromDate:dateView.dateStart] forKey:startDateKey];
    [dic setObject:[LyUtil stringOnlyDateFromDate:[dateView.dateEnd dateByAddingTimeInterval:3600 * 24]] forKey:endDateKey];
    
//    if (LyUserType_coach == [LyCurrentUser curUser].userType) {
//        [dic setObject:@([LyCurrentUser curUser].coachMode) forKey:coachModeKey];
//    }
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:orderCenterHttpMethod_loadWithDate];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:orderCenter_url
                                 body:dic
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)loadMore {
    [self.tvFooter startAnimation];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[LyCurrentUser curUser].userId forKey:userIdKey];
    [dic setObject:({
        NSString *strUserType = [[LyCurrentUser curUser] userTypeByString];
        if ([strUserType isEqualToString:teacherCoachKey]) {
            if (LyCoachMode_alone == [LyCurrentUser curUser].coachMode || LyCoachMode_boss == [LyCurrentUser curUser].coachMode) {
                strUserType = @"sjl";
            }
        }
        strUserType;
    }) forKey:userTypeKey];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    [dic setObject:@(arrOrder.count) forKey:startKey];
    [dic setObject:@(curOrderPayStatus) forKey:orderStateKey];

    if (dateView.dateStart && dateView.dateEnd) {
        [dic setObject:[LyUtil stringOnlyDateFromDate:dateView.dateStart] forKey:startDateKey];
        [dic setObject:[LyUtil stringOnlyDateFromDate:dateView.dateEnd] forKey:endDateKey];
    }
    
//    if (LyUserType_coach == [LyCurrentUser curUser].userType) {
//        [dic setObject:@([LyCurrentUser curUser].coachMode) forKey:coachModeKey];
//    }
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:orderCenterHttpMethod_loadMore];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:orderCenter_url
                                 body:dic
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
    
}


- (void)handleHttpFailed {
    if ([indicator isAnimating]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
    }
    
    if ([self.tvFooter isAnimating]) {
        [self.tvFooter stopAnimation];
    }
    
    [self.tvFooter setStatus:LyTableViewFooterViewStatus_error];
}


- (void)analysisHttpResult:(NSString *)result {
    NSDictionary *dic = [LyUtil getObjFromJson:result];
    if (![LyUtil validateDictionary:dic]) {
        [self handleHttpFailed];
        return;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (![LyUtil validateString:strCode]) {
        [self handleHttpFailed];
        return;
    }
    
    if (codeTimeOut == [strCode integerValue]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        [self.tvFooter stopAnimation];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        [self.tvFooter stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch (curHttpMethod) {
        case orderCenterHttpMethod_load: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateArray:arrResult]) {
                        [indicator stopAnimation];
                        [self.refreshControl endRefreshing];
                        [self.tvFooter setStatus:LyTableViewFooterViewStatus_disable];
                        return;
                    }
                    
                    for (NSDictionary *dicItem in arrResult) {
                        if (![LyUtil validateDictionary:dicItem]) {
                            continue;
                        }
                        
                        NSString *strOrderId = [dicItem objectForKey:orderIdKey];
                        NSString *strOrderName = [dicItem objectForKey:orderNameKey];
                        NSString *strOrderDetail = [dicItem objectForKey:orderDetailKey];
                        NSString *strOrderTime = [dicItem objectForKey:orderTimeKey];
                        strOrderTime = [LyUtil fixDateTimeString:strOrderTime isExplicit:NO];
                        
                        NSString *strOrderMode = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:orderModeKey]];
                        NSString *strOrderState = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:orderStateKey]];
                        
                        NSString *strOrderClassId = [dicItem objectForKey:classIdKey];
                        NSString *strOrderObjectId = [dicItem objectForKey:objectIdKey];
                        NSString *strTrainBase = [dicItem objectForKey:trainBaseNameKey];
                        
                        NSString *strPrices = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:orderPriceKey]];
                        NSString *strPaidNum = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:paidNumKey]];
                        
                        NSString *strOrderMasterId = [dicItem objectForKey:masterIdKey];
                        NSString *strOrderMasterName = [dicItem objectForKey:nickNameKey];
                        NSString *strConsignee = [dicItem objectForKey:consigneeKey];
                        NSString *strOrderPhone = [dicItem objectForKey:phoneKey];
                        NSString *strOrderAddress = [dicItem objectForKey:addressKey];
                        NSString *strOrderRemark = [dicItem objectForKey:remarkKey];
                        NSString *strOrderStuCount = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:studentCountKey]];
                        NSString *strApplyMode = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:applyModeKey]];
                        
                        NSString *strRecipient = [dicItem objectForKey:recipientKey];
                        NSString *strRecipientName = [dicItem objectForKey:recipientNameKey];
                        
                        LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:strOrderMasterId];
                        if (!user) {
                            if (![LyUtil validateString:strOrderMasterName]) {
                                if ([strOrderStuCount intValue] < 2) {
                                    strOrderMasterName = strConsignee;
                                } else {
                                    strOrderMasterName = [LyUtil getUserNameWithUserId:strOrderMasterId];
                                }
                            }
                            
                            user = [LyUser userWithId:strOrderMasterId
                                             userNmae:strOrderMasterName];
                            [[LyUserManager sharedInstance] addUser:user];
                        }
                        
                        LyUser *userObject = [[LyUserManager sharedInstance] getUserWithUserId:strOrderObjectId];
                        if (!userObject) {
                            
                            LyOrderMode orderMode = [strOrderMode integerValue];
                            switch (orderMode) {
                                case LyOrderMode_driveSchool: {
                                    
                                    LyDriveSchool *school = [LyDriveSchool driveSchoolWithId:strOrderObjectId
                                                                                    dschName:strOrderName];
                                    userObject = school;
                                    
                                    if (![strOrderObjectId isEqualToString:strRecipient]) {
                                        LyCoach *recipient = [[LyUserManager sharedInstance] getCoachWithCoachId:strRecipient];
                                        if (!recipient) {
                                            recipient = [LyCoach coachWithId:strRecipient
                                                                        name:strRecipientName];
                                            [[LyUserManager sharedInstance] addUser:recipient];
                                        }
                                    }
                                    break;
                                }
                                case LyOrderMode_coach: {
                                    LyCoach *coach = [LyCoach coachWithId:strOrderObjectId
                                                                     name:strOrderName];
                                    userObject = coach;
                                    
                                    if (![strOrderObjectId isEqualToString:strRecipient]) {
                                        LyCoach *recipient = [[LyUserManager sharedInstance] getCoachWithCoachId:strRecipient];
                                        if (!recipient) {
                                            recipient = [LyCoach coachWithId:strRecipient
                                                                        name:strRecipientName];
                                            [[LyUserManager sharedInstance] addUser:recipient];
                                        }
                                    }
                                    break;
                                }
                                case LyOrderMode_guider: {
                                    LyGuider *guider = [[LyGuider alloc] initWithGuiderId:strOrderObjectId
                                                                                  guiName:strOrderName];
                                    userObject = guider;
                                    break;
                                }
                                case LyOrderMode_reservation: {
                                    if (LyUserType_guider == [LyCurrentUser curUser].userType) {
                                        LyGuider *guider = [[LyGuider alloc] initWithGuiderId:strOrderObjectId
                                                                                      guiName:strOrderName];
                                        userObject = guider;
                                    } else {
                                        LyCoach *coach = [LyCoach coachWithId:strOrderObjectId
                                                                         name:strOrderName];
                                        userObject = coach;
                                        
                                        if (![strOrderObjectId isEqualToString:strRecipient]) {
                                            LyCoach *recipient = [[LyUserManager sharedInstance] getCoachWithCoachId:strRecipient];
                                            if (!recipient) {
                                                recipient = [LyCoach coachWithId:strRecipient
                                                                            name:strRecipientName];
                                                [[LyUserManager sharedInstance] addUser:recipient];
                                            }
                                        }
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
                            
                            [[LyUserManager sharedInstance] addUser:userObject];
                        }
                    
                        
                        LyOrder *order = [[LyOrderManager sharedInstance] getOrderWithOrderId:strOrderId];
                        if (!order) {
                            
                            order = [LyOrder orderWithOrderId:strOrderId
                                                orderMasterId:strOrderMasterId
                                                    orderName:strOrderName
                                                  orderDetail:strOrderDetail
                                               orderConsignee:strConsignee
                                             orderPhoneNumber:strOrderPhone
                                                 orderAddress:strOrderAddress
                                           orderTrainBaseName:strTrainBase
                                                    orderTime:strOrderTime
                                                orderObjectId:strOrderObjectId
                                                 orderClassId:strOrderClassId
                                                  orderRemark:strOrderRemark
                                                  orderStatus:[strOrderState integerValue]
                                                    orderMode:[strOrderMode integerValue]
                                            orderStudentCount:[strOrderStuCount intValue]
                                                   orderPrice:[strPrices floatValue]
                                       orderPreferentialPrice:0.0f
                                                 orderPaidNum:[strPaidNum floatValue]
                                               orderApplyMode:[strApplyMode integerValue]
                                                    orderFlag:1
                                                    recipient:strRecipient
                                                recipientName:strRecipientName];
                            
                            [[LyOrderManager sharedInstance] addOrder:order];
                        } else {
                            [order setOrderState:[strOrderState integerValue]];
                            [order setOrderPrice:[strPrices floatValue]];
                            [order setOrderPaidNum:[strPaidNum floatValue]];
                            [order setRecipient:strRecipient];
                            [order setRecipientName:strRecipientName];
                        }
                    }
                    
                    [self reloadData:NO];
                    
                    [indicator stopAnimation];
                    [self.refreshControl endRefreshing];
                    [self.tvFooter setStatus:LyTableViewFooterViewStatus_normal];
                    
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case orderCenterHttpMethod_loadWithDate: {
            switch ([strCode integerValue]) {
                case 0: {
                    
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateArray:arrResult]) {
                        [indicator stopAnimation];
                        [self.tvFooter setStatus:LyTableViewFooterViewStatus_disable];
                        [self reloadData:NO];
                        return;
                    }
                    
                    for (NSDictionary *dicItem in arrResult) {
                        if (![LyUtil validateDictionary:dicItem]) {
                            continue;
                        }
                        
                        NSString *strOrderId = [dicItem objectForKey:orderIdKey];
                        NSString *strOrderName = [dicItem objectForKey:orderNameKey];
                        NSString *strOrderDetail = [dicItem objectForKey:orderDetailKey];
                        NSString *strOrderTime = [dicItem objectForKey:orderTimeKey];
                        strOrderTime = [LyUtil fixDateTimeString:strOrderTime isExplicit:NO];
                        
                        NSString *strOrderMode = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:orderModeKey]];
                        NSString *strOrderState = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:orderStateKey]];
                        
                        NSString *strOrderClassId = [dicItem objectForKey:classIdKey];
                        NSString *strOrderObjectId = [dicItem objectForKey:objectIdKey];
                        NSString *strTrainBase = [dicItem objectForKey:trainBaseNameKey];
                        
                        NSString *strPrices = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:orderPriceKey]];
                        NSString *strPaidNum = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:paidNumKey]];
                        
                        NSString *strOrderMasterId = [dicItem objectForKey:masterIdKey];
                        NSString *strOrderMasterName = [dicItem objectForKey:nickNameKey];
                        NSString *strConsignee = [dicItem objectForKey:consigneeKey];
                        NSString *strOrderPhone = [dicItem objectForKey:phoneKey];
                        NSString *strOrderAddress = [dicItem objectForKey:addressKey];
                        NSString *strOrderRemark = [dicItem objectForKey:remarkKey];
                        NSString *strOrderStuCount = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:studentCountKey]];
                        NSString *strApplyMode = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:applyModeKey]];
                        
                        NSString *strRecipient = [dicItem objectForKey:recipientKey];
                        NSString *strRecipientName = [dicItem objectForKey:recipientNameKey];
                        
                        LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:strOrderMasterId];
                        if (!user) {
                            if (![LyUtil validateString:strOrderMasterName]) {
                                if ([strOrderStuCount intValue] < 2) {
                                    strOrderMasterName = strConsignee;
                                } else {
                                    strOrderMasterName = [LyUtil getUserNameWithUserId:strOrderMasterId];
                                }
                            }
                            
                            user = [LyUser userWithId:strOrderMasterId
                                             userNmae:strOrderMasterName];
                            [[LyUserManager sharedInstance] addUser:user];
                        }
                        
                        LyUser *userObject = [[LyUserManager sharedInstance] getUserWithUserId:strOrderObjectId];
                        if (!userObject) {
                            
                            LyOrderMode orderMode = [strOrderMode integerValue];
                            switch (orderMode) {
                                case LyOrderMode_driveSchool: {
                                    
                                    LyDriveSchool *school = [LyDriveSchool driveSchoolWithId:strOrderObjectId
                                                                                    dschName:strOrderName];
                                    userObject = school;
                                    
                                    if (![strOrderObjectId isEqualToString:strRecipient]) {
                                        LyCoach *recipient = [[LyUserManager sharedInstance] getCoachWithCoachId:strRecipient];
                                        if (!recipient) {
                                            recipient = [LyCoach coachWithId:strRecipient
                                                                        name:strRecipientName];
                                            [[LyUserManager sharedInstance] addUser:recipient];
                                        }
                                    }
                                    break;
                                }
                                case LyOrderMode_coach: {
                                    LyCoach *coach = [LyCoach coachWithId:strOrderObjectId
                                                                     name:strOrderName];
                                    userObject = coach;
                                    
                                    if (![strOrderObjectId isEqualToString:strRecipient]) {
                                        LyCoach *recipient = [[LyUserManager sharedInstance] getCoachWithCoachId:strRecipient];
                                        if (!recipient) {
                                            recipient = [LyCoach coachWithId:strRecipient
                                                                        name:strRecipientName];
                                            [[LyUserManager sharedInstance] addUser:recipient];
                                        }
                                    }
                                    break;
                                }
                                case LyOrderMode_guider: {
                                    LyGuider *guider = [LyGuider guiderWithGuiderId:strOrderObjectId
                                                                            guiName:strOrderName];
                                    userObject = guider;
                                    break;
                                }
                                case LyOrderMode_reservation: {
                                    LyCoach *coach = [LyCoach coachWithId:strOrderObjectId
                                                                     name:strOrderName];
                                    userObject = coach;
                                    break;
                                }
                                case LyOrderMode_mall: {
                                    
                                    break;
                                }
                                case LyOrderMode_game: {
                                    
                                    break;
                                }
                            }
                            
                            [[LyUserManager sharedInstance] addUser:userObject];
                        }
                        
                        
                        LyOrder *order = [[LyOrderManager sharedInstance] getOrderWithOrderId:strOrderId];
                        if (!order) {
                            
                            order = [LyOrder orderWithOrderId:strOrderId
                                                orderMasterId:strOrderMasterId
                                                    orderName:strOrderName
                                                  orderDetail:strOrderDetail
                                               orderConsignee:strConsignee
                                             orderPhoneNumber:strOrderPhone
                                                 orderAddress:strOrderAddress
                                           orderTrainBaseName:strTrainBase
                                                    orderTime:strOrderTime
                                                orderObjectId:strOrderObjectId
                                                 orderClassId:strOrderClassId
                                                  orderRemark:strOrderRemark
                                                  orderStatus:[strOrderState integerValue]
                                                    orderMode:[strOrderMode integerValue]
                                            orderStudentCount:[strOrderStuCount intValue]
                                                   orderPrice:[strPrices floatValue]
                                       orderPreferentialPrice:0.0f
                                                 orderPaidNum:[strPaidNum floatValue]
                                               orderApplyMode:[strApplyMode integerValue]
                                                    orderFlag:1
                                                    recipient:strRecipient
                                                recipientName:strRecipientName];
                            
                            [[LyOrderManager sharedInstance] addOrder:order];
                        } else {
                            [order setOrderState:[strOrderState integerValue]];
                            [order setOrderPrice:[strPrices floatValue]];
                            [order setOrderPaidNum:[strPaidNum floatValue]];
                            [order setRecipient:strRecipient];
                            [order setRecipientName:strRecipientName];
                        }
                    }
                    
                    [self reloadData:NO];
                    
                    [indicator stopAnimation];
                    [self.refreshControl endRefreshing];
                    [self.tvFooter setStatus:LyTableViewFooterViewStatus_normal];
                    
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
        }
        case orderCenterHttpMethod_loadMore: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateArray:arrResult]) {
                        [self.tvFooter stopAnimation];
                        [self.tvFooter setStatus:LyTableViewFooterViewStatus_disable];
                        return;
                    }
                    
                    for (NSDictionary *dicItem in arrResult) {
                        if (![LyUtil validateDictionary:dicItem]) {
                            continue;
                        }
                        
                        NSString *strOrderId = [dicItem objectForKey:orderIdKey];
                        NSString *strOrderName = [dicItem objectForKey:orderNameKey];
                        NSString *strOrderDetail = [dicItem objectForKey:orderDetailKey];
                        NSString *strOrderTime = [dicItem objectForKey:orderTimeKey];
                        
                        strOrderTime = [LyUtil fixDateTimeString:strOrderTime isExplicit:NO];
                        
                        NSString *strOrderMode = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:orderModeKey]];
                        NSString *strOrderState = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:orderStateKey]];
                        
                        NSString *strOrderClassId = [dicItem objectForKey:classIdKey];
                        NSString *strOrderObjectId = [dicItem objectForKey:objectIdKey];
                        NSString *strTrainBase = [dicItem objectForKey:trainBaseNameKey];
                        
                        NSString *strPrices = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:orderPriceKey]];
                        NSString *strPaidNum = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:paidNumKey]];
                        
                        NSString *strOrderMasterId = [dicItem objectForKey:masterIdKey];
                        NSString *strOrderMasterName = [dicItem objectForKey:nickNameKey];
                        NSString *strConsignee = [dicItem objectForKey:consigneeKey];
                        NSString *strOrderPhone = [dicItem objectForKey:phoneKey];
                        NSString *strOrderAddress = [dicItem objectForKey:addressKey];
                        NSString *strOrderRemark = [dicItem objectForKey:remarkKey];
                        NSString *strOrderStuCount = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:studentCountKey]];
                        NSString *strApplyMode = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:applyModeKey]];
                        
                        NSString *strRecipient = [dicItem objectForKey:recipientKey];
                        NSString *strRecipientName = [dicItem objectForKey:recipientNameKey];
                        
                        LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:strOrderMasterId];
                        if (!user) {
                            if (![LyUtil validateString:strOrderMasterName]) {
                                if ([strOrderStuCount intValue] < 2) {
                                    strOrderMasterName = strConsignee;
                                } else {
                                    strOrderMasterName = [LyUtil getUserNameWithUserId:strOrderMasterId];
                                }
                            }
                            
                            user = [LyUser userWithId:strOrderMasterId
                                             userNmae:strOrderMasterName];
                            [[LyUserManager sharedInstance] addUser:user];
                        }
                        
                        LyUser *userObject = [[LyUserManager sharedInstance] getUserWithUserId:strOrderObjectId];
                        if (!userObject) {
                            
                            LyOrderMode orderMode = [strOrderMode integerValue];
                            switch (orderMode) {
                                case LyOrderMode_driveSchool: {
                                    
                                    LyDriveSchool *school = [LyDriveSchool driveSchoolWithId:strOrderObjectId
                                                                                    dschName:strOrderName];
                                    userObject = school;
                                    
                                    if (![strOrderObjectId isEqualToString:strRecipient]) {
                                        LyCoach *recipient = [[LyUserManager sharedInstance] getCoachWithCoachId:strRecipient];
                                        if (!recipient) {
                                            recipient = [LyCoach coachWithId:strRecipient
                                                                        name:strRecipientName];
                                            [[LyUserManager sharedInstance] addUser:recipient];
                                        }
                                    }
                                    break;
                                }
                                case LyOrderMode_coach: {
                                    LyCoach *coach = [LyCoach coachWithId:strOrderObjectId
                                                                     name:strOrderName];
                                    userObject = coach;
                                    
                                    if (![strOrderObjectId isEqualToString:strRecipient]) {
                                        LyCoach *recipient = [[LyUserManager sharedInstance] getCoachWithCoachId:strRecipient];
                                        if (!recipient) {
                                            recipient = [LyCoach coachWithId:strRecipient
                                                                        name:strRecipientName];
                                            [[LyUserManager sharedInstance] addUser:recipient];
                                        }
                                    }
                                    break;
                                }
                                case LyOrderMode_guider: {
                                    LyGuider *guider = [LyGuider guiderWithGuiderId:strOrderObjectId
                                                                            guiName:strOrderName];
                                    userObject = guider;
                                    break;
                                }
                                case LyOrderMode_reservation: {
                                    LyCoach *coach = [LyCoach coachWithId:strOrderObjectId
                                                                     name:strOrderName];
                                    userObject = coach;
                                    break;
                                }
                                case LyOrderMode_mall: {
                                    
                                    break;
                                }
                                case LyOrderMode_game: {
                                    
                                    break;
                                }
                            }
                            
                            [[LyUserManager sharedInstance] addUser:userObject];
                        }
                        
                        
                        LyOrder *order = [[LyOrderManager sharedInstance] getOrderWithOrderId:strOrderId];
                        if (!order) {
                            
                            order = [LyOrder orderWithOrderId:strOrderId
                                                orderMasterId:strOrderMasterId
                                                    orderName:strOrderName
                                                  orderDetail:strOrderDetail
                                               orderConsignee:strConsignee
                                             orderPhoneNumber:strOrderPhone
                                                 orderAddress:strOrderAddress
                                           orderTrainBaseName:strTrainBase
                                                    orderTime:strOrderTime
                                                orderObjectId:strOrderObjectId
                                                 orderClassId:strOrderClassId
                                                  orderRemark:strOrderRemark
                                                  orderStatus:[strOrderState integerValue]
                                                    orderMode:[strOrderMode integerValue]
                                            orderStudentCount:[strOrderStuCount intValue]
                                                   orderPrice:[strPrices floatValue]
                                       orderPreferentialPrice:0.0f
                                                 orderPaidNum:[strPaidNum floatValue]
                                               orderApplyMode:[strApplyMode integerValue]
                                                    orderFlag:1
                                                    recipient:strRecipient
                                                recipientName:strRecipientName];
                            
                            [[LyOrderManager sharedInstance] addOrder:order];
                        } else {
                            [order setOrderState:[strOrderState integerValue]];
                            [order setOrderPaidNum:[strPaidNum floatValue]];
                            [order setRecipient:strRecipient];
                        }
                    }
                    
                    [self reloadData:NO];
                    
                    [self.tvFooter stopAnimation];
                    [self.tvFooter setStatus:LyTableViewFooterViewStatus_normal];
                    
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
            
        default: {
            [self handleHttpFailed];
        }
    }
}


#pragma mark -LyHttpRequestDelegate
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest {
    if (bHttpFlag) {
        bHttpFlag = NO;
        
        [self handleHttpFailed];
    }
    
    curHttpMethod = 0;
}


- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result {
    if (bHttpFlag) {
        bHttpFlag = NO;
        curHttpMethod = ahttpRequest.mode;
        [self analysisHttpResult:result];
    }
    
    curHttpMethod = 0;
}



#pragma mark -LyOrderDetailViewControllerDelegate 
- (NSString *)obtainOrderByOrderDetailVC:(LyOrderDetailViewController *)aOrderDetailVC {
    return [arrOrder objectAtIndex:curIdx.row];
}



#pragma mark -LyOrderDispatchTableViewControllerDelegate
- (NSString *)obtainOrderIdByOrderDispatchTVC:(LyOrderDispatchTableViewController *)aOrderDispatchTVC {
    return [[arrOrder objectAtIndex:curIdx.row] orderId];
}


- (void)onDisptachByOrderDispatchTVC:(LyOrderDispatchTableViewController *)aOrderDispatchTVC coach:(LyCoach *)coach {
    [aOrderDispatchTVC.navigationController popViewControllerAnimated:YES];
    
    LyOrder *order = [arrOrder objectAtIndex:curIdx.row];
    [order setRecipient:coach.userId];
    [order setRecipientName:coach.userName];
    
    [self.tableView reloadRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark -LyOrderCenterTableViewCellDelegate
- (void)onClickButtonDisptachByOrderCenterTableViewCell:(LyOrderCenterTableViewCell *)aCell {
    curIdx = [self.tableView indexPathForCell:aCell];
    
    LyOrderDispatchTableViewController *orderDispatch = [[LyOrderDispatchTableViewController alloc] init];
    [orderDispatch setDelegate:self];
    [self.navigationController pushViewController:orderDispatch animated:YES];
}



#pragma mark -LyTableViewFooterViewDelegate
- (void)loadMoreData:(LyTableViewFooterView *)tableViewFooterView {
    [self loadMore];
}



#pragma mark -LyDateViewDelegate
- (void)dateView:(LyDateView *)aDateView dateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd {
    if (dateStart && dateEnd && [dateEnd timeIntervalSinceDate:dateStart] >= 0) {
        [self loadWithDate];
    }
}


#pragma mark -LyOrderStateViewDelegate
- (void)orderStateView:(LyOrderStateView *)aOrderStateView didSelectItemAtIndex:(LyOrderState)aOrderState {
    [self setOrderState:aOrderState];
}


#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return octcellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    curIdx = indexPath;
    
    [tableView deselectRowAtIndexPath:curIdx animated:NO];
    
    LyOrderDetailViewController *orderDetail = [[LyOrderDetailViewController alloc] init];
    [orderDetail setDelegate:self];
    [self.navigationController pushViewController:orderDetail animated:YES];
}



#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (arrOrder.count < 1) {
        [self.tvFooter setStatus:LyTableViewFooterViewStatus_disable];
    } else {
        [self.tvFooter setStatus:LyTableViewFooterViewStatus_normal];
    }
    return arrOrder.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyOrderCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyOrderCenterTvOrdersCellReuseIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[LyOrderCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyOrderCenterTvOrdersCellReuseIdentifier];
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
