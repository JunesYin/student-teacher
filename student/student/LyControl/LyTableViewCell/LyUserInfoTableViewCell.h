//
//  LyUserCenterInfoTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/31.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const ucicHeight;



@interface LyUserInfoTableViewCell : UITableViewCell

- (void)setCellInfo:(NSString *)title detail:(NSString *)detail isQRCode:(BOOL)isQRCode;

@end
