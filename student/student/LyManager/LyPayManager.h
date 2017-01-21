//
//  LyPayManager.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/4.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LySingleInstance.h"
#import "LyUtil.h"


typedef NS_ENUM( NSInteger, LyPayMode)
{
    LyPayMode_517Pay,
    LyPayMode_AliPay,
//    LyPayMode_WeChatPay,
    LyPayMode_ChinaUnionPay,
    LyPayMode_ApplePay,
};



UIKIT_EXTERN int const LyPayErrorCode_orderAbsent;      //订单为nil
UIKIT_EXTERN int const LyPayErrorCode_verifyFail;       //验证失败
UIKIT_EXTERN int const LyPayErrorCode_authFail;         //验证得到的结果为订单未支付

UIKIT_EXTERN int const LyPayErrorCode_aliPaySignFail;   //支付宝签名失败

UIKIT_EXTERN int const LyPayErrorCode_weChatPayPayFial;

UIKIT_EXTERN int const LyPayErrorCode_chinaUnionTnAbsent;//银联获取tn失败
UIKIT_EXTERN int const LyPayErrorCode_chinaUnionCallFail;//调用银联支付失败

UIKIT_EXTERN int const LyPayErrorCode_applePayTnAbsent; //Apple pay获取tn失败
UIKIT_EXTERN int const LyPayErrorCode_applePayCallFail; //Apple pay调用失败
UIKIT_EXTERN int const LyPayErrorCode_applePayCannotPay;//Apple pay无法支付
UIKIT_EXTERN int const LyPayErrorCode_applePayPayFail;  //Apple pay支付失败




NS_ASSUME_NONNULL_BEGIN


@class LyOrder;
@class LyPayManager;

@protocol LyPayManagerDelegate <NSObject>

- (void)onPayErrorByPayManager:(LyPayManager *)aPayManager withOrder:(LyOrder *)aOrder errInfo:(NSString *)errInfo;
- (void)onPayCanceledByPayManager:(LyPayManager *)aPayManager withOrder:(LyOrder *)aOrder;
- (void)onPayFailedByPayManager:(LyPayManager *)aPayManager withOrder:(LyOrder *)aOrder  errInfo:(NSString *)errInfo;
- (void)onPaySuccessedByPayManager:(LyPayManager *)aPayManager withOrder:(LyOrder *)aOrder discount:(float)discount ;

@end


@interface LyPayManager : NSObject

@property (retain, nonatomic, readonly)     LyOrder     *order;
@property (assign, nonatomic, readonly)     float       discount;
@property (weak, nonatomic)     id<LyPayManagerDelegate>    delegate;

lySingle_interface

+ (void)payWithMode:(LyPayMode)payMode withOrder:(LyOrder *)lyOrder andDelegate:(id<LyPayManagerDelegate>)delegate;

- (void)payWithMode:(LyPayMode)payMode withOrder:(LyOrder *)lyOrder andDelegate:(id<LyPayManagerDelegate>)delegate;

- (void)payFinished:(LyPayMode)aPayMode andResult:(id)result;

#if DEBUG
- (void)authOrderStateWithOrderId:(NSString *)orderId;
#endif


@end


NS_ASSUME_NONNULL_END
