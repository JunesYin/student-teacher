//
//  LyGuiderTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/14.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const guiderCellHeight;


@class LyGuider;

@interface LyGuiderTableViewCell : UITableViewCell

@property ( retain, nonatomic)                  LyGuider                    *guider;


@end
