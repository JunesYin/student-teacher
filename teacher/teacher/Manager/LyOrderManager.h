//
//  LyOrderManager.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/30.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LySingleInstance.h"
#import "LyOrder.h"

@interface LyOrderManager : NSObject


lySingle_interface

- (void)removeAllOrder;

- (void)addOrder:(LyOrder *)order;

- (void)removeOrder:(LyOrder *)order;

- (void)removeOrderWithOrderId:(NSString *)orderId;

- (LyOrder *)getOrderWithOrderId:(NSString *)orderId;

- (NSArray *)getOrderWithOrderStatus:(LyOrderPayStatus)payStatus dtaStart:(NSDate *)dateStart dataEnd:(NSDate *)dateEnd userId:(NSString *)userId;



@end
