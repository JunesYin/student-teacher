//
//  LyTheoryStudyProgressView.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/24.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>



@class LyTheoryStudyProgressView;

@protocol LyTheoryStudyProgressViewDelegate <NSObject>

@optional
- (void)onCloseByTheoryStudyProgressView:(LyTheoryStudyProgressView *)aprogressView;

- (void)onClickedItemByTheoryStudyProgressView:(LyTheoryStudyProgressView *)aprogressView andItemIndex:(NSInteger)itemIndex;

@end


@interface LyTheoryStudyProgressView : UIView

@property ( assign, nonatomic)          NSInteger               allCount;
@property ( assign, nonatomic)          NSInteger               currentIndex;

@property ( retain, nonatomic)          NSDictionary            *answerInfo;

@property ( assign, nonatomic)          id<LyTheoryStudyProgressViewDelegate>       delegate;


- (void)show;

- (void)hide;

@end
