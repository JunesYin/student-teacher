//
//  LyStudentDetailTableViewCell.h
//  teacher
//
//  Created by Junes on 16/8/17.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const sdtcellHeight;

UIKIT_EXTERN NSString *const sdCensusTitle;
UIKIT_EXTERN NSString *const sdAddressTitle;
UIKIT_EXTERN NSString *const sdTrainClassNameTitle;
UIKIT_EXTERN NSString *const sdPayInfoTitle;
UIKIT_EXTERN NSString *const sdStudyProgressTitle;
UIKIT_EXTERN NSString *const sdRemarkTitle;





typedef NS_ENUM(NSInteger, LyStudentDetailTableViewCellMode)
{
    LyStudentDetailTableViewCellMode_census,
    LyStudentDetailTableViewCellMode_address,
    
    LyStudentDetailTableViewCellMode_trainClassName,
    LyStudentDetailTableViewCellMode_payInfo,
    LyStudentDetailTableViewCellMode_studyProgress,
    
    LyStudentDetailTableViewCellMode_remark
};


@class LyStudent;


@interface LyStudentDetailTableViewCell : UITableViewCell

@property (assign, nonatomic)       LyStudentDetailTableViewCellMode    mode;
@property (retain, nonatomic)       NSString                            *content;

- (void)setCellInfo:(LyStudentDetailTableViewCellMode)mode content:(LyStudent *)student;

@end
