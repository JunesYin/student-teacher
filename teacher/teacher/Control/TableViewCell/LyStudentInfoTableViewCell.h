//
//  LyStudentInfoTableViewCell.h
//  teacher
//
//  Created by Junes on 16/8/13.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LyUser;

UIKIT_EXTERN CGFloat const sitcellHeight;

@interface LyStudentInfoTableViewCell : UITableViewCell

@property (retain, nonatomic)       LyUser          *student;

@end
