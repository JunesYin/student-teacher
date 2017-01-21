//
//  LyTheoryProgressCollectionViewCell.h
//  student
//
//  Created by MacMini on 2016/12/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM( NSInteger, LyTheoryProgressCollectionViewCellMode)
{
    LyTheoryProgressCollectionViewCellMode_normal,
    LyTheoryProgressCollectionViewCellMode_right,
    LyTheoryProgressCollectionViewCellMode_wrong,
    LyTheoryProgressCollectionViewCellMode_choosed,
    LyTheoryProgressCollectionViewCellMode_focus
    
};

@interface LyTheoryProgressCollectionViewCell : UICollectionViewCell

@property ( assign, nonatomic)      LyTheoryProgressCollectionViewCellMode     mode;
@property ( assign, nonatomic)      NSInteger               text;

@end
