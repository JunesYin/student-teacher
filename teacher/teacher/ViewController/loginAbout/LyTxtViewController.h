//
//  Ly517ProtocolViewController.h
//  517Xueche_teacher
//
//  Created by Junes on 16/5/7.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM( NSInteger, LyTxtViewControllerMode) {
    LyTxtViewControllerMode_517UserProtocol = 517,              //517用户协议
    LyTxtViewControllerMode_517InfoServiceProtocol,             //517信息服务协议-教练、指导员
    LyTxtViewControllerMode_517CooperationProtocol,             //517合作协议-驾校
    LyTxtViewControllerMode_FAQ
};


@class LyTxtViewController;


@protocol LyTxtDelegate <NSObject>

- (NSString *)obtainStudyCostByLyTxtViewController:(LyTxtViewController *)aTxtVc;

@end



@interface LyTxtViewController : UIViewController

@property ( assign, nonatomic)      LyTxtViewControllerMode     mode;

@property ( weak, nonatomic)        id<LyTxtDelegate>           delegate;




@end
