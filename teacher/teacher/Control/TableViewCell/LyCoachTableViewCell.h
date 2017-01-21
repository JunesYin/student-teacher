//
//  LyCoachTableViewCell.h
//  teacher
//
//  Created by Junes on 16/8/12.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const coachtcellHeight;


@class LyCoach;


typedef NS_ENUM(NSInteger, LyCoachTableViewCellMode)
{
    LyCoachTableViewCellMode_coachManage,
    LyCoachTableViewCellMode_trainBaseDetail
};


@interface LyCoachTableViewCell : UITableViewCell

@property (retain, nonatomic)       LyCoach                     *coach;

@property (assign, nonatomic)       LyCoachTableViewCellMode    mode;

- (void)setCoach:(LyCoach *)coach mode:(LyCoachTableViewCellMode)mode;

@end
