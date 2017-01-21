//
//  LyMaintainingView.h
//  student
//
//  Created by Junes on 2016/9/28.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LyMaintainingView : UIView

@property (retain, nonatomic)       NSString            *reason;

+ (instancetype)maintainingViewWithReason:(NSString *)reason;

- (instancetype)initWithReason:(NSString *)reason;

- (void)show;

- (void)hide;

@end
