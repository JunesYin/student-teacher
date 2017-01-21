//
//  LyAddLandMarkTableViewCell.h
//  teacher
//
//  Created by Junes on 16/8/11.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const almtcellHeight;


@class LyLandMark;

@interface LyAddLandMarkTableViewCell : UITableViewCell

@property (retain, nonatomic)                       LyLandMark          *landMark;

@property (assign, nonatomic, getter=isAdded)       BOOL                added;

@property (assign, nonatomic, getter=isChoosed)     BOOL                choosed;

- (void)setLandMark:(LyLandMark *)landMark added:(BOOL)added choosed:(BOOL)choosed;

@end
