//
//  LySimuLateStudyTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/12.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>



UIKIT_EXTERN CGFloat const simuCellHeight;


//
//typedef NS_ENUM( NSInteger, LySimulateStudyExamInfoItemMode)
//{
//    simulateStudyExamInfoItemMode_subject,
//    simulateStudyExamInfoItemMode_library,
//    simulateStudyExamInfoItemMode_measure,
//    simulateStudyExamInfoItemMode_accpetLine
//};



@interface LySimuLateStudyTableViewCell : UITableViewCell


+ (void)setCellWidth:(CGFloat)width;

- (void)setCellInfo:(NSString *)title detail:(NSString *)detail;

@end
