//
//  LyTrainClassTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/13.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const tcHeight;


typedef NS_ENUM( NSInteger, LyTrainClassTableViewCellMode)
{
    trainClassTableViewCellMode_detail,
    trainClassTableViewCellMode_mySchool
};


@class LyTrainClass;
@protocol LyTrainClassTableViewCellDelegate;

@interface LyTrainClassTableViewCell : UITableViewCell




@property ( strong, nonatomic)                  LyTrainClass                        *trainClass;
@property ( assign, nonatomic)                  LyTrainClassTableViewCellMode       mode;
@property (assign, nonatomic)                   BOOL                                showDeleteButton;

@property ( weak, nonatomic)                    id<LyTrainClassTableViewCellDelegate>         delegate;

- (void)hideRedunantView:(BOOL)flag;



@end




@protocol LyTrainClassTableViewCellDelegate <NSObject>

@optional
//- (void)onClickBtnApply:(LyTrainClassTableViewCell *)aTrainClassCell;
- (void)onClickBtnDelete:(LyTrainClassTableViewCell *)aTrainClassCell;


@end
