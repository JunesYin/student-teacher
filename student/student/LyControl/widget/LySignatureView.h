//
//  LySignatureView.h
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


@class LySignatureView;

@protocol LySignatureDelegate <NSObject>

@required
- (void)onDoneBySignature:(LySignatureView *)aSignatureView content:(NSString *)content;


- (void)onCancelBySignature:(LySignatureView *)aSignatureView;

@end



@interface LySignatureView : UIView

@property ( weak, nonatomic)            id<LySignatureDelegate>                 delegate;

@property ( copy, nonatomic)            NSString                *text;


- (void)show;

- (void)hide;


@end
