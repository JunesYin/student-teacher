//
//  LyTeachManageTableViewCell.h
//  teacher
//
//  Created by Junes on 16/8/10.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const tmtcellHeight;

@interface LyTeachManageTableViewCell : UITableViewCell


- (void)setCellInfo:(UIImage *)icon title:(NSString *)title detail:(NSString *)detail;

@end
