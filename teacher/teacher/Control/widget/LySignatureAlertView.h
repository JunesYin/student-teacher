//
//  LySignatureAlertView.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/26.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM( NSInteger, LySignatureButtonItemMode)
{
    signatureButtonItemMode_cancel = 21,
    signatureButtonItemMode_done
};


@class LySignatureAlertView;

@protocol LySignatureAlertViewDelegate <NSObject>

@optional
- (void)signatureAlertView:(LySignatureAlertView *)aSignatureView isClickButtonDone:(BOOL)isDone;

@end



@interface LySignatureAlertView : UIView

@property ( weak, nonatomic)            id<LySignatureAlertViewDelegate>                 delegate;

@property ( copy, nonatomic)            NSString                *signature;

+ (instancetype)signatureAlertViewWithSignature:(NSString *)signature;

- (instancetype)initWithSignature:(NSString *)signature;

- (void)setPlaceholder:(NSString *)placeholder;

- (void)show;

- (void)hide;


@end
