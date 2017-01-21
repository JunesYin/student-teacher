//
//  LyConsultTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/15.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, LyConsultTableViewCellMode) {
    LyConsultTableViewCellMode_list,
    LyConsultTableViewCellMode_detail
};


@class LyConsult;

@interface LyConsultTableViewCell : UITableViewCell

@property (retain, nonatomic)       LyConsult       *consult;

@property (assign, nonatomic)       LyConsultTableViewCellMode      mode;

@property (assign, nonatomic, readonly)     float       height;

@end
