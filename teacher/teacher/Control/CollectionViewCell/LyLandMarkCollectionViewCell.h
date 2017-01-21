//
//  LyLandMarkCollectionViewCell.h
//  teacher
//
//  Created by Junes on 16/8/11.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LyLandMark;

@interface LyLandMarkCollectionViewCell : UICollectionViewCell

@property (retain, nonatomic)           LyLandMark              *landMark;

@property (assign, nonatomic, getter=isEditing) BOOL            editing;

- (void)setLandMark:(NSString *)landMark editing:(BOOL)editing;

@end
