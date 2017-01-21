//
//  LyWalletButton.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/12.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM( NSInteger, LyWalletButtonMode)
{
    walletButtonMode_balance = 280,
    walletButtonMode_5Coin,
    walletButtonMode_coupon
};


@interface LyWalletButton : UIButton

@property ( assign, nonatomic)                  LyWalletButtonMode                  itemMode;
@property ( assign, nonatomic)                  float                               num;
@property ( strong, nonatomic, readonly)        NSString                            *title;



@end
