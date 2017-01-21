//
//  LyAddStudentTableViewCell.h
//  teacher
//
//  Created by Junes on 16/8/17.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const astcellHeight;

@interface LyAddStudentTableViewCell : UITableViewCell

@property (retain, nonatomic)       NSString            *title;

- (void)setCellInfo:(UIImage *)icon title:(NSString *)title;

@end
