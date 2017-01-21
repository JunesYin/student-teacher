//
//  LyCoachCurrentInfoTableViewCell.h
//  teacher
//
//  Created by Junes on 16/8/13.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const ccitcellHeight;

@interface LyCoachCurrentInfoTableViewCell : UITableViewCell

- (void)setCellInfo:(UIImage *)icon title:(NSString *)title info:(NSString *)info;

@end
