//
//  LyOrderInfoTableViewCell.h
//  student
//
//  Created by Junes on 2016/11/24.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const oitcHeight;


typedef NS_ENUM(NSInteger, LyOrderInfoTableViewCellMode)
{
    LyOrderInfoTableViewCellMode_orderInfo,
    LyOrderInfoTableViewCellMode_paySuccess
};

@interface LyOrderInfoTableViewCell : UITableViewCell

@property (assign, nonatomic)       LyOrderInfoTableViewCellMode    mode;

- (void)setCellInfo:(NSString *)title detail:(NSString *)detail;

@end
