//
//  LyNotificationTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/6.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const ncellHeight;


typedef NS_ENUM( NSInteger, LyNotificationTableViewCellType)
{
    notificationTableViewCellMode_notification = 32,
    notificationTableViewCellMode_driveExam
};


@interface LyNotificationTableViewCell : UITableViewCell

@property ( copy, nonatomic)            NSString                                    *title;
@property ( copy, nonatomic)            NSString                                    *detail;
@property ( assign, nonatomic)          NSInteger                                   nCount;

- (void)setCellInfo:(UIImage *)icon title:(NSString *)title detail:(NSString *)detail count:(NSInteger)count;


@end
