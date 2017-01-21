//
//  LyAddPriceDetailViewController.h
//  teacher
//
//  Created by Junes on 2016/9/24.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LyPriceDetail;
@protocol LyAddPriceDetailViewControllerDelegate;

@interface LyAddPriceDetailViewController : UIViewController

@property (weak, nonatomic)     id<LyAddPriceDetailViewControllerDelegate>      delegate;

@property (retain, nonatomic)   LyPriceDetail           *priceDetail;

@end


@protocol LyAddPriceDetailViewControllerDelegate <NSObject>

@optional
- (NSInteger)obtainLicenseTypeByAddPriceDetailVC:(LyAddPriceDetailViewController *)aAddPriceDetailVC;

@required
- (void)onDoneByAddPriceDetailVC:(LyAddPriceDetailViewController *)aAddPriceDetailVC priceDetail:(LyPriceDetail *)priceDetail;

@end
