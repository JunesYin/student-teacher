//
//  LyQuestionOptionTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const qotcellHeight;



typedef NS_ENUM( NSInteger, LyQuestionOptionTableViewCellMode)
{
    LyQuestionOptionTableViewCellMode_normal,
    LyQuestionOptionTableViewCellMode_right,
    LyQuestionOptionTableViewCellMode_wrong,
};


@class LyOption;

@interface LyQuestionOptionTableViewCell : UITableViewCell

@property ( assign, nonatomic)      LyQuestionOptionTableViewCellMode   mode;

@property ( assign, nonatomic)      LyOption                            *option;

@property ( assign, nonatomic, getter=isChoosed)      BOOL              choosed;


@end
