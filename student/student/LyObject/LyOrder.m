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
                    orderPayTime:(NSString *)orderPayTime
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
                                            orderPayTime:orderPayTime
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
                                               orderFlag:orderFlag];
    
    
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
                   orderPayTime:(NSString *)orderPayTime
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
        _orderPayTime      = orderPayTime;
        _orderObjectId     = orderObjectId;
        _orderClassId      = orderClassId;
        _orderRemark       = orderRemark;
        _orderState        = orderState;
        _orderMode         = orderMode;
        _orderStudentCount = orderStudentCount;
        _orderPrice        = orderPrice;
        _orderPreferentialPrice = orderPreferentialPrice;
        _orderPaidNum      = orderPaidNum;
        _orderApplyMode    = orderApplyMode;
        
        _orderFlag = orderFlag;
        
        
        if (LyOrderMode_reservation == _orderMode)
        {
            _orderDuration = _orderDetail;
        }
    }
    
    return self;
    
}




@end
