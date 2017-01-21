//
//  LySubjectModeView.h
//  teacher
//
//  Created by Junes on 16/8/13.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyUtil.h"

UIKIT_EXTERN CGFloat const LySubjectModeViewHeight;


@protocol LySubjectModeViewDelegate;


@interface LySubjectModeView : UIView

@property (weak, nonatomic)         id<LySubjectModeViewDelegate>       delegate;

@property (assign, nonatomic)       LySubjectMode                       subjectMode;


@end


@protocol LySubjectModeViewDelegate <NSObject>

@required
- (void)subjectModeView:(LySubjectModeView *)aSubjectModeView didSelectSubject:(LySubjectMode)subjectMode;


@end
