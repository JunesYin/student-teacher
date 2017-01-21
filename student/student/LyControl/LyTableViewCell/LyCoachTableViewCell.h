//
//  LyCoachTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/16.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>



UIKIT_EXTERN CGFloat const COACHCELLHEIGHT;


@class LyCoach;



typedef NS_ENUM( NSInteger, LyCoachTableViewCellMode)
{
    coachTableViewCellMode_home,
    coachTableViewCellMode_mySchool
};



@interface LyCoachTableViewCell : UITableViewCell

@property ( strong, nonatomic)          LyCoach             *coach;

@property ( assign, nonatomic)          LyCoachTableViewCellMode    mode;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@end
