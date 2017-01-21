//
//  LyChooseTableViewCell.h
//  teacher
//
//  Created by Junes on 16/8/16.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const choosetcellHeight;

@interface LyChooseTableViewCell : UITableViewCell

@property (retain, nonatomic)       NSString            *detail;


- (void)setCellInfo:(NSString *)title detail:(NSString *)detail;


@end
