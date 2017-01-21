//
//  LyStudentProgressView.h
//  teacher
//
//  Created by Junes on 16/8/17.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LyUtil.h"

UIKIT_EXTERN CGFloat const LyStudentProgressViewHeight;

@protocol LyStudentProgressViewDelegate;


@interface LyStudentProgressView : UIView

@property (weak, nonatomic)     id<LyStudentProgressViewDelegate>       delegate;

@property (assign, nonatomic)   LySubjectMode                           subjects;

@end


@protocol LyStudentProgressViewDelegate <NSObject>

@optional
- (void)studentProgressView:(LyStudentProgressView *)aStudentProgressView didSelectedItemAtIndex:(LySubjectMode)index;

@end
