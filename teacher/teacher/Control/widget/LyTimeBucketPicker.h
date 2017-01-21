//
//  LyTimeBucketPicker.h
//  teacher
//
//  Created by Junes on 2016/9/24.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "LyUtil.h"

@protocol LyTimeBucketPickerDelegate;

@interface LyTimeBucketPicker : UIView

@property (weak, nonatomic)     id<LyTimeBucketPickerDelegate>      delegate;

@property (assign, nonatomic)   LyTimeBucket        timeBucket;

- (void)show;

- (void)hide;

@end



@protocol LyTimeBucketPickerDelegate <NSObject>

@optional
- (void)onCancelByTimeBucketPicker:(LyTimeBucketPicker *)aPicker;

@required
- (void)onDoneByTimeBucketPicker:(LyTimeBucketPicker *)aPicker timeBucket:(LyTimeBucket)timeBucket;

@end
