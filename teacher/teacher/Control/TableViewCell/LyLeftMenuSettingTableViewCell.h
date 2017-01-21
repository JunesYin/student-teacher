//
//  LyLeftMenuSettingTableViewCell.h
//  student
//
//  Created by Junes on 16/8/29.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const lmstcellHeight;

@interface LyLeftMenuSettingTableViewCell : UITableViewCell

- (void)setCellInfo:(UIImage *)icon title:(NSString *)title detail:(NSString *)detail;

@end
