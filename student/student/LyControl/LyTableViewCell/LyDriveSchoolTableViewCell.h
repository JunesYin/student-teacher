//
//  LyDriveSchoolTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/5.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const dschtcellHeight;


@class LyDriveSchool;

@interface LyDriveSchoolTableViewCell : UITableViewCell

@property ( strong, nonatomic)                  LyDriveSchool                       *driveSchool;

@property (nonatomic)       BOOL        isSearching;

@end
