//
//  LyStudentTableViewCell.h
//  teacher
//
//  Created by Junes on 16/8/17.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const stutcellHeight;

@class LyStudent;
@protocol LyStudentTableViewCellDelegate;


typedef NS_ENUM(NSInteger, LyStudentTableViewCellMode) {
    LyStudentTableViewCellMode_home,
    LyStudentTableViewCellMode_studentInfo
};


@interface LyStudentTableViewCell : UITableViewCell

@property (weak, nonatomic)         id<LyStudentTableViewCellDelegate>          delegate;

@property (assign, nonatomic)       LyStudentTableViewCellMode                  mode;

@property (retain, nonatomic)       LyStudent                                   *student;

@end



@protocol LyStudentTableViewCellDelegate <NSObject>

@optional
- (void)onClickBttonProgressByStudentTableViewCell:(LyStudentTableViewCell *)aCell;

@end
