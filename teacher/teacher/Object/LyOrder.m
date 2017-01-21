//
//  LyOrder.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/30.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyOrder.h"

@implementation LyOrder




+ (instancetype)orderWithOrderId:(NSString *)orderId
                   orderMasterId:(NSString *)orderMasterId
                       orderName:(NSString *)orderName
                     orderDetail:(NSString *)orderDetail
                  orderConsignee:(NSString *)orderConsignee
                orderPhoneNumber:(NSString *)orderPhoneNumber
                    orderAddress:(NSString *)orderAddress
              orderTrainBaseName:(NSString *)orderTrainBaseName
                       orderTime:(NSString *)orderTime
                   orderObjectId:(NSString *)orderObjectId
                    orderClassId:(NSString *)orderClassId
                     orderRemark:(NSString *)orderRemark
                     orderStatus:(LyOrderState)orderState
                       orderMode:(LyOrderMode)orderMode
               orderStudentCount:(LyOrderMode)orderStudentCount
                      orderPrice:(double)orderPrice
          orderPreferentialPrice:(double)orderPreferentialPrice
                    orderPaidNum:(double)orderPaidNum
                  orderApplyMode:(LyApplyMode)orderApplyMode
                       orderFlag:(int)orderFlag
                  recipient:(NSString *)recipient
                   recipientName:(NSString *)recipientName
{
    LyOrder *tmpOrder = [[LyOrder alloc] initWithOrderId:orderId
                                           orderMasterId:orderMasterId
                                               orderName:orderName
                                             orderDetail:orderDetail
                                          orderConsignee:orderConsignee
                                        orderPhoneNumber:orderPhoneNumber
                                            orderAddress:orderAddress
                                      orderTrainBaseName:orderTrainBaseName
                                               orderTime:orderTime
                                           orderObjectId:orderObjectId
                                            orderClassId:orderClassId
                                             orderRemark:orderRemark
                                             orderStatus:orderState
                                               orderMode:orderMode
                                       orderStudentCount:orderStudentCount
                                              orderPrice:orderPrice
                                  orderPreferentialPrice:orderPreferentialPrice
                                            orderPaidNum:orderPaidNum
                                          orderApplyMode:orderApplyMode
                                               orderFlag:orderFlag
                                               recipient:recipient
                                           recipientName:recipientName];
    
    
    return tmpOrder;
    
}



- (instancetype)initWithOrderId:(NSString *)orderId
                  orderMasterId:(NSString *)orderMasterId
                      orderName:(NSString *)orderName
                    orderDetail:(NSString *)orderDetail
                 orderConsignee:(NSString *)orderConsignee
               orderPhoneNumber:(NSString *)orderPhoneNumber
                   orderAddress:(NSString *)orderAddress
             orderTrainBaseName:(NSString *)orderTrainBaseName
                      orderTime:(NSString *)orderTime
                  orderObjectId:(NSString *)orderObjectId
                   orderClassId:(NSString *)orderClassId
                    orderRemark:(NSString *)orderRemark
                    orderStatus:(LyOrderState)orderState
                      orderMode:(LyOrderMode)orderMode
              orderStudentCount:(LyOrderMode)orderStudentCount
                     orderPrice:(double)orderPrice
         orderPreferentialPrice:(double)orderPreferentialPrice
                   orderPaidNum:(double)orderPaidNum
                 orderApplyMode:(LyApplyMode)orderApplyMode
                      orderFlag:(int)orderFlag
                 recipient:(NSString *)recipient
                  recipientName:(NSString *)recipientName
{
    
    if ( self = [super init])
    {
        _orderId           = orderId;
        _orderMasterId     = orderMasterId;
        _orderName         = orderName;
        _orderDetail       = orderDetail;
        _orderConsignee    = orderConsignee;
        _orderPhoneNumber  = orderPhoneNumber;
        _orderAddress      = orderAddress;
        _orderTrainBaseName = orderTrainBaseName;
        _orderTime         = orderTime;
        _orderObjectId     = orderObjectId;
        _orderClassId      = orderClassId;
        _orderRemark       = orderRemark;
        [self setOrderState:orderState];
        _orderMode         = orderMode;
        _orderStudentCount = orderStudentCount;
        _orderPrice        = orderPrice;
        _orderPreferentialPrice = orderPreferentialPrice;
        _orderPaidNum      = orderPaidNum;
        _orderApplyMode    = orderApplyMode;
        
        _orderFlag = orderFlag;
        
        _recipient = recipient;
        _recipientName = recipientName;
        
    }
    
    return self;
    
}


- (void)setOrderState:(LyOrderState)orderState {
    _orderState = orderState;
    
    switch (_orderState) {
        case LyOrderState_waitPay: {
            _orderPayStatus = LyOrderPayStatus_ing;
            break;
        }
        case LyOrderState_waitConfirm: {
            
        }
        case LyOrderState_waitEvalute: {
            
        }
        case LyOrderState_completed: {
            _orderPayStatus = LyOrderPayStatus_done;
            break;
        }
        case LyOrderState_cancel: {
            _orderPayStatus = LyOrderPayStatus_close;
            break;
        }
    }
}


- (NSString *)orderAddress {
    if (![LyUtil validateString:_orderAddress]) {
        return @"";
    }
    
    return _orderAddress;
}

- (NSString *)orderRemark {
    if (![LyUtil validateString:_orderRemark]) {
        return @"";
    }
    
    return _orderRemark;
}



@end
