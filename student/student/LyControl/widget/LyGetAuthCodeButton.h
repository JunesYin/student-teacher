//
//  LyGetAuthCodeButton.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/26.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const btnGetAuthCodeWidth;
UIKIT_EXTERN CGFloat const btnGetAuthCodeHeight;


@class LyGetAuthCodeButton;

@protocol LyGetAuthCodeButtonDelegate <NSObject>

@optional
- (NSString *)obtainPhoneNum:(LyGetAuthCodeButton *)button;
- (NSString *)obtainUrl:(LyGetAuthCodeButton *)button;

- (void)sendSuccessByGetAuthCodeButton:(LyGetAuthCodeButton *)aGetAuthCodeButton time:(NSString *)aTime trueAuth:(NSString *)trueAuth;

@end


@interface LyGetAuthCodeButton : UIButton

@property (assign, nonatomic)                       int                     timeInterval;
@property (assign, nonatomic)                       int                     timeTotal;
@property (assign, nonatomic)                       int                     curTime;
@property (weak, nonatomic)                         NSTimer                 *timer;

@property (strong, nonatomic)                       NSString                *phoneNumber;
@property (strong, nonatomic)                       NSString                *url;

@property (strong, nonatomic)                       NSString                *time;
@property (strong, nonatomic)                       NSString                *trueAuthCode;

@property (assign, nonatomic)                       id<LyGetAuthCodeButtonDelegate>         delegate;





@end
