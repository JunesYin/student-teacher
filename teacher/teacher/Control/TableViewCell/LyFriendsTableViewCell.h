//
//  LyFriendsTabelViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/30.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const fcellHeight;


@class LyUser;

@interface LyFriendsTabelViewCell : UITableViewCell

@property (retain, nonatomic)       LyUser      *user;



@end
