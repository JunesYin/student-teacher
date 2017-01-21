//
//  LySelfStudyToExamCollectionViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/19.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LySelfStudyToExamCollectionViewCell : UICollectionViewCell

@property ( strong, nonatomic, readonly)        UIImage                 *icon;
@property ( strong, nonatomic, readonly)        NSString                *title;

@property ( assign, nonatomic, readonly, getter=isOn)        BOOL                    on;

- (void)setCellInfo:(UIImage *)icon title:(NSString *)title on:(BOOL)on;

@end
