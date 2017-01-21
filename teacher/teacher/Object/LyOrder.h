//
//  LyOrder.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/30.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "LyTrainClassManager.h"
#import "LyUtil.h"


typedef NS_ENUM( NSInteger, LyOrderState)
{
    LyOrderState_waitPay,
    LyOrderState_waitConfirm,
    LyOrderState_waitEvalute,
    LyOrderState_completed,
    LyOrderState_cancel
};



typedef NS_ENUM(NSInteger, LyOrderPayStatus) {
    LyOrderPayStatus_ing = LyOrderState_waitPay,
    LyOrderPayStatus_done,
    LyOrderPayStatus_close = LyOrderState_cancel
};



typedef NS_ENUM( NSInteger, LyOrderMode)
{
    LyOrderMode_driveSchool = 1,
    LyOrderMode_coach,
    LyOrderMode_guider,
    LyOrderMode_reservation,
    LyOrderMode_mall,
    LyOrderMode_game
};



@interface LyOrder : NSObject


@property ( strong, nonatomic)                      NSString                        *orderId;
@property ( strong, nonatomic)                      NSString                        *orderMasterId;
@property ( strong, nonatomic)                      NSString                        *orderName;
@property ( strong, nonatomic)                      NSString                        *orderDetail;
@property ( strong, nonatomic)                      NSString                        *orderConsignee;
@property ( strong, nonatomic)                      NSString                        *orderPhoneNumber;
@property ( strong, nonatomic)                      NSString                        *orderAddress;
@property ( strong, nonatomic)                      NSString                        *orderTrainBaseName;
@property ( strong, nonatomic)                      NSString                        *orderTime;
@property ( strong, nonatomic)                      NSString                        *orderObjectId;
@property ( strong, nonatomic)                      NSString                        *orderClassId;
@property ( strong, nonatomic)                      NSString                        *orderRemark;
@property ( assign, nonatomic)                      LyOrderMode                     orderMode;
@property ( assign, nonatomic)                      LyOrderState                    orderState;
@property ( assign, nonatomic, readonly)            LyOrderPayStatus                orderPayStatus;
@property ( assign, nonatomic)                      double                          orderPrice;
@property ( assign, nonatomic)                      double                          orderPreferentialPrice;
@property ( assign, nonatomic)                      double                          orderPaidNum;


@property ( strong, nonatomic)                      NSString                        *recipient;
@property ( strong, nonatomic)                      NSString                        *recipientName;

@property ( assign, nonatomic)                      int                             orderFlag;


@property ( assign, nonatomic)                      int                             orderStudentCount;
@property ( assign, nonatomic)                      LyApplyMode                     orderApplyMode;




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
                   recipientName:(NSString *)recipientName;



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
                  recipientName:(NSString *)recipientName;


- (NSString *)recipientName;

@end



