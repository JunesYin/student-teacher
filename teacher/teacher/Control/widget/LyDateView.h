//
//  LyDateView.h
//  teacher
//
//  Created by Junes on 16/8/15.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const LyDateViewHeight;


@protocol LyDateViewDelegate;

@interface LyDateView : UIView

@property (weak, nonatomic)         id<LyDateViewDelegate>          delegate;
@property (retain, nonatomic)       NSDate                          *dateStart;
@property (retain, nonatomic)       NSDate                          *dateEnd;

@end


@protocol LyDateViewDelegate <NSObject>

@optional
//- (void)dateView:(LyDateView *)aDateView dateStart:(NSString *)dateStart dateEnd:(NSString *)dateEnd;
- (void)dateView:(LyDateView *)aDateView dateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd;

@end
