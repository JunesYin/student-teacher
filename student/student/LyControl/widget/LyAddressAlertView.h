//
//  LyAddressAlertView.h
//  teacher
//
//  Created by Junes on 16/8/10.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LyAddressAlertViewDelegate;


@interface LyAddressAlertView : UIView

@property (weak, nonatomic)         id<LyAddressAlertViewDelegate>          delegate;

@property (retain, nonatomic)       NSString                                *address;

@property (retain, nonatomic)       NSString                                *city;

+ (instancetype)addressAlertViewWithAddress:(NSString *)address;

- (instancetype)initWithAddress:(NSString *)address;

- (void)show;

- (void)hide;

@end




@protocol LyAddressAlertViewDelegate <NSObject>

@optional
- (void)addressAlertView:(LyAddressAlertView *)aAddressAlertView onClickButtonDone:(BOOL)isDone;

@end
