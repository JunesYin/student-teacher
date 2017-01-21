//
//  LyReservationDetailTableViewCell.h
//  teacher
//
//  Created by Junes on 2016/9/26.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const rdtcellHeight;

@interface LyReservationDetailTableViewCell : UITableViewCell

@property (retain, nonatomic)           NSString            *title;
@property (retain, nonatomic)           NSString            *detail;

- (void)setCellInfo:(NSString *)title detail:(NSString *)detail;

@end
