//
//  LyOrderInfoViewController.m
//  teacher
//
//  Created by Junes on 16/8/15.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyOrderInfoViewController.h"
#import "LyDateView.h"
#import "LyOrderInfoTableViewCell.h"
#import "LyTableViewFooterView.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

//#import "LyCurrentUser.h"
#import "LyOrderManager.h"
#import "LyUserManager.h"

#import "LyUtil.h"



typedef NS_ENUM(NSInteger, LyOrderInfoHttpMethod) {
    orderInfoHttpMethod_load = 100,
    orderInfoHttpMethod_loadMore,
    orderInfoHttpMethod_loadWithDate
};


@interface LyOrderInfoViewController () <UITableViewDelegate, UITableViewDataSource, LyDateViewDelegate, LyTableViewFooterViewDelegate, LyHttpRequestDelegate>
{
    BOOL                    flagLoaded;
    
//    LyDateView              *dateView;
    
    NSArray                 *arrOrders;
    
    LyIndicator             *indicator;
    BOOL                    bHttpFlag;
    LyOrderInfoHttpMethod   curHttpMethod;
}

@property (strong, nonatomic)   LyDateView              *dateView;
@property (strong, nonatomic)   UITableView             *tableView;
@property (strong, nonatomic)   UIRefreshControl        *refreshControl;
@property (strong, nonatomic)   LyTableViewFooterView   *tvFooterView;

@end

@implementation LyOrderInfoViewController

static NSString *const lyOrderInfoTvOrdersCellReuseIdentifer = @"lyOrderInfoTvOrdersCellReuseIdentifer";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}


- (void)viewWillAppear:(BOOL)animated {
    if (!_coachId) {
        _coachId = [_delegate obtainCoachIdByOrderInfoVC:self];
        if (!_coachId) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
//    arrOrders = [[LyOrderManager sharedInstance] getOrderWithOrderStatus:5
//                                                                dtaStart:dateView.dateStart
//                                                                 dataEnd:dateView.dateEnd
//                                                                  userId:_coachId];
    if (!flagLoaded) {
        [self load];
    }
}


- (void)initAndLayoutSubviews {
    self.title = @"订单信息";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    [self.view addSubview:self.dateView];

    [self.view addSubview:self.tableView];
}

- (LyDateView *)dateView
{
    if (!_dateView)
    {
        _dateView = [[LyDateView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, LyDateViewHeight)];
        [_dateView setDelegate:self];
    }
    
    return _dateView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT+LyDateViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-LyDateViewHeight)
                                                  style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView registerClass:[LyOrderInfoTableViewCell class] forCellReuseIdentifier:lyOrderInfoTvOrdersCellReuseIdentifer];
        [_tableView setRowHeight:oitcellHeight];
        
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
    if (!_tvFooterView){
        _tvFooterView = [LyTableViewFooterView tableViewFooterViewWithDelegate:self];
    }
    
    return _tvFooterView;
}


- (void)reloadData {
    
    arrOrders = [[LyOrderManager sharedInstance] getOrderWithOrderStatus:5
                                                                dtaStart:self.dateView.dateStart
                                                                 dataEnd:self.dateView.dateEnd
                                                                  userId:_coachId];
    
    [self.tableView reloadData];
}


- (void)refresh:(UIRefreshControl *)rc {
    [self load];
}

- (void)load {
    
    flagLoaded = YES;
    
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:nil];
    }
    [indicator startAnimation];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_coachId forKey:userIdKey];
    [dic setObject:userTypeCoachKey forKey:userTypeKey];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    [dic setObject:@(0) forKey:startKey];
    [dic setObject:@(5) forKey:orderStateKey];
    
    if (self.dateView.dateStart && self.dateView.dateEnd) {
        [dic setObject:[LyUtil stringOnlyDateFromDate:self.dateView.dateStart] forKey:startDateKey];
        [dic setObject:[LyUtil stringOnlyDateFromDate:[self.dateView.dateEnd dateByAddingTimeInterval:3600 * 24]] forKey:endDateKey];
    }
//    if (LyUserType_coach == [LyCurrentUser curUser].userType) {
//        [dic setObject:@([LyCurrentUser curUser].coachMode) forKey:coachModeKey];
//    }
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:orderInfoHttpMethod_load];
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
    [dic setObject:_coachId forKey:userIdKey];
    [dic setObject:userTypeCoachKey forKey:userTypeKey];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    [dic setObject:@(0) forKey:startKey];
    [dic setObject:@(5) forKey:orderStateKey];
    
    [dic setObject:[LyUtil stringOnlyDateFromDate:self.dateView.dateStart] forKey:startDateKey];
    [dic setObject:[LyUtil stringOnlyDateFromDate:[self.dateView.dateEnd dateByAddingTimeInterval:3600 * 24]] forKey:endDateKey];
    
//    if (LyUserType_coach == [LyCurrentUser curUser].userType) {
//        [dic setObject:@([LyCurrentUser curUser].coachMode) forKey:coachModeKey];
//    }
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:orderInfoHttpMethod_loadWithDate];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:orderCenter_url
                                 body:dic
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)loadMore {
    
    [self.tvFooterView startAnimation];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_coachId forKey:userIdKey];
    [dic setObject:userTypeCoachKey forKey:userTypeKey];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    [dic setObject:@(arrOrders.count) forKey:startKey];
    [dic setObject:@(5) forKey:orderStateKey];
    
    if (self.dateView.dateStart && self.dateView.dateEnd) {
        [dic setObject:[LyUtil stringOnlyDateFromDate:self.dateView.dateStart] forKey:startDateKey];
        [dic setObject:[LyUtil stringOnlyDateFromDate:[self.dateView.dateEnd dateByAddingTimeInterval:3600 * 24]] forKey:endDateKey];
    }
    
//    if (LyUserType_coach == [LyCurrentUser curUser].userType) {
//        [dic setObject:@([LyCurrentUser curUser].coachMode) forKey:coachModeKey];
//    }
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:orderInfoHttpMethod_loadMore];
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
    
    if ([self.tvFooterView isAnimating]) {
        [self.tvFooterView stopAnimation];
    }
    
    [self.tvFooterView setStatus:LyTableViewFooterViewStatus_error];
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
        [self.tvFooterView stopAnimation];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        [self.tvFooterView stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch (curHttpMethod) {
        case orderInfoHttpMethod_load: {
            switch ([strCode integerValue]) {
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
                        
                        
                        LyCoach *coach = [[LyUserManager sharedInstance] getCoachWithCoachId:strOrderObjectId];
                        if (!coach) {
                             coach = [LyCoach coachWithId:strOrderObjectId
                                                     name:strOrderName];
                            [[LyUserManager sharedInstance] addUser:coach];
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
                    
                    [self reloadData];
                    
                    [indicator stopAnimation];
                    [self.refreshControl endRefreshing];
                    [self.tvFooterView setStatus:LyTableViewFooterViewStatus_normal];
                    
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case orderInfoHttpMethod_loadMore: {
            switch ([strCode integerValue]) {
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
                        
                        
                        LyCoach *coach = [[LyUserManager sharedInstance] getCoachWithCoachId:strOrderObjectId];
                        if (!coach) {
                            coach = [LyCoach coachWithId:strOrderObjectId
                                                    name:strOrderName];
                            [[LyUserManager sharedInstance] addUser:coach];
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
                    
                    [self reloadData];
                    
                    [self.tvFooterView stopAnimation];
                    [self.tvFooterView setStatus:LyTableViewFooterViewStatus_normal];
                    
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case orderInfoHttpMethod_loadWithDate: {
            switch ([strCode integerValue]) {
                case 0: {
                    
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateArray:arrResult]) {
                        [indicator stopAnimation];
                        [self.refreshControl endRefreshing];
                        [self.tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                        [self reloadData];
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
                        
                        
                        LyCoach *coach = [[LyUserManager sharedInstance] getCoachWithCoachId:strOrderObjectId];
                        if (!coach) {
                            coach = [LyCoach coachWithId:strOrderObjectId
                                                    name:strOrderName];
                            [[LyUserManager sharedInstance] addUser:coach];
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
                    
                    [self reloadData];
                    
                    [indicator stopAnimation];
                    [self.refreshControl endRefreshing];
                    [self.tvFooterView setStatus:LyTableViewFooterViewStatus_normal];
                    
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
            break;
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


#pragma mark -LyDateViewDelegate
- (void)dateView:(LyDateView *)aDateView dateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd {
    if (dateStart && dateEnd && [dateEnd timeIntervalSinceDate:dateStart] >= 0) {
        [self loadWithDate];
    }
}


#pragma mark -LyTableViewFooterViewDelegate
- (void)loadMoreData:(LyTableViewFooterView *)tableViewFooterView {
    [self loadMore];
}


#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark -UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyOrderInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyOrderInfoTvOrdersCellReuseIdentifer forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[LyOrderInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyOrderInfoTvOrdersCellReuseIdentifer];
    }
    [cell setOrder:[arrOrders objectAtIndex:indexPath.row]];
    
    return cell;
}


#pragma mrak -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ( scrollView == self.tableView && [scrollView contentOffset].y + [scrollView frame].size.height > [scrollView contentSize].height + tvFooterViewDefaultHeight && scrollView.contentSize.height > scrollView.frame.size.height) {
        [self loadMore];
    }
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
