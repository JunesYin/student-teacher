//
//  LyTheoryStudyCollectionViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/24.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LyTheoryStudyCollectionViewCell : UICollectionViewCell

@property ( strong, nonatomic)              UIImage                     *icon;
@property ( strong, nonatomic)              NSString                    *title;


- (void)setCellInfo:(UIImage *)image withTitle:(NSString *)title;

- (void)setFont:(UIFont *)font;

@end
