//
//  LyUserCenterTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/24.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const uctcellHeight;


@interface LyUserCenterTableViewCell : UITableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setCellInfo:(NSString *)title withImage:(UIImage *)image;

@end
