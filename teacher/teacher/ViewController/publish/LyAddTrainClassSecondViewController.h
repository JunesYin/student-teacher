//
//  LyAddTrainClassSecondViewController.h
//  teacher
//
//  Created by Junes on 16/8/5.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


//UIKIT_EXTERN NSString *const tcNameKey;
//UIKIT_EXTERN NSString *const tcDriveLicenseKey;
//UIKIT_EXTERN NSString *const tcCarKey;
//UIKIT_EXTERN NSString *const tcTimeKey;
//UIKIT_EXTERN NSString *const tcOfficailPriceKey;
//UIKIT_EXTERN NSString *const tc517WholePriceKey;

@class LyAddTrainClassSecondViewController;


@protocol AddTrainClassSecondDelegate <NSObject>

@optional
- (NSDictionary *)obtainTrainClassInfoByLyAddTrainClassSecondViewController:(LyAddTrainClassSecondViewController *)aAddTrainClassVC;

- (void)onDoneAddTrainClassByLyAddTrainClassSecondViewController:(LyAddTrainClassSecondViewController *)aAddTrainClassVC;

@end


@interface LyAddTrainClassSecondViewController : UIViewController

@property (retain, nonatomic)           NSDictionary                            *dicTcInfo;

@property (weak, nonatomic)             id<AddTrainClassSecondDelegate>         delegate;

@end
