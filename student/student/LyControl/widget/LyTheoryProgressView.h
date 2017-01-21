//
//  LyTheoryProgressView.h
//  student
//
//  Created by MacMini on 2016/12/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, LyTheoryProgressViewMode) {
    LyTheoryProgressViewMode_execise = 0,
    LyTheoryProgressViewMode_exam
};



@protocol LyTheoryProgressViewDelegate;

@interface LyTheoryProgressView : UIView

@property (weak, nonatomic)     id<LyTheoryProgressViewDelegate>        delegate;
@property (assign, nonatomic)       LyTheoryProgressViewMode        mode;
@property (retain, nonatomic)       NSArray     *arrQuestion;
@property (assign, nonatomic)       NSInteger       curIdx;

- (void)show;

- (void)hide;

@end




@protocol LyTheoryProgressViewDelegate <NSObject>

@optional
- (void)onCloseByTheoryProgressView:(LyTheoryProgressView *)aProgressView;

- (void)theoryProgressView:(LyTheoryProgressView *)aProgressView didSelectItemAtIndex:(NSInteger)index;

@end
