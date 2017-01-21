//
//  LyUserInfoTableViewCell.h
//  teacher
//
//  Created by Junes on 16/8/9.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const ucicHeight;

@interface LyUserInfoTableViewCell : UITableViewCell

- (void)setCellInfo:(NSString *)title detail:(NSString *)detail icon:(UIImage *)icon;

@end
