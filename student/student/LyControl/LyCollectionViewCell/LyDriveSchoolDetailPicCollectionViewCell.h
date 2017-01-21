//
//  LyDriveSchoolDetailPicCollectionViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/6.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>



@class LyDriveSchoolDetailPicCollectionViewCell;


@protocol LyDriveSchoolDetailPicCollectionViewCellDelegate <NSObject>

@optional
- (void)picLoadFinish:(UIImage *)image strUrl:(NSString *)strUrl andDriveSchoolDetailPicCell:(LyDriveSchoolDetailPicCollectionViewCell *)aCell;

@end


@interface LyDriveSchoolDetailPicCollectionViewCell : UICollectionViewCell

@property ( weak, nonatomic)    id<LyDriveSchoolDetailPicCollectionViewCellDelegate>        delegate;

@property ( strong, nonatomic)      NSString        *strUrl;


@end
