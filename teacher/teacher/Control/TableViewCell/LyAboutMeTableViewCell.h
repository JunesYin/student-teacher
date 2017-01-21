//
//  LyAboutMeTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LyAboutMe;
@class LyAboutMeTableViewCell;


@protocol LyAboutMeTableViewCellDelegate <NSObject>

@optional
- (void)onClickedButtonReplyByAboutMeTableViewCell:(LyAboutMeTableViewCell *)aCell;

- (void)onClickedUserByAboutMeTableViewCell:(LyAboutMeTableViewCell *)aCell;

- (void)onClickedNewsByAboutMeTableViewCell:(LyAboutMeTableViewCell *)aCell;

@end


@interface LyAboutMeTableViewCell : UITableViewCell

@property ( retain, nonatomic)          LyAboutMe               *aboutMe;

@property ( assign, nonatomic)          CGFloat                 height;

@property ( weak, nonatomic)            id<LyAboutMeTableViewCellDelegate>      delegate;


@end
