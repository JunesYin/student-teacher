//
//  LyOrderInfoTableViewCell.h
//  teacher
//
//  Created by Junes on 16/8/15.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const oitcellHeight;

@class LyOrder;

@interface LyOrderInfoTableViewCell : UITableViewCell

@property (retain, nonatomic)   LyOrder         *order;

@end
