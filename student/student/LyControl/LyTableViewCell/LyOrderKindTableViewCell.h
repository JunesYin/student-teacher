//
//  LyOrderKindTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/7.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const oktcellWidth;
UIKIT_EXTERN CGFloat const oktcellHeight;



typedef NS_ENUM( NSInteger, LyOrderKindTableViewCellMode)
{
    LyOrderKindTableViewCellMode_driveSchool = 1,
    LyOrderKindTableViewCellMode_coach,
    LyOrderKindTableViewCellMode_guider,
    LyOrderKindTableViewCellMode_reservation,
    LyOrderKindTableViewCellMode_mall,
    LyOrderKindTableViewCellMode_game
};


@interface LyOrderKindTableViewCell : UITableViewCell

@property ( assign, nonatomic)      LyOrderKindTableViewCellMode            mode;

@end
