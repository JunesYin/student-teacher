//
//  LyStatusDetailControlBar.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/3.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


#define sdcbWidth                       FULLSCREENWIDTH

UIKIT_EXTERN CGFloat const sdcbHeight;




@class LyStatusDetailControlBar;

@protocol LyStatusDetailControlBarDelegate <NSObject>

- (void)onClickedPraiseByStatusDetailControlBar:(LyStatusDetailControlBar *)aControlBar;
- (void)onClickedEvaluteByStatusDetailControlBar:(LyStatusDetailControlBar *)aControlBar;
- (void)onClickedTransmitByStatusDetailControlBar:(LyStatusDetailControlBar *)aControlBar;

@end


@interface LyStatusDetailControlBar : UIView

@property ( weak, nonatomic)        id<LyStatusDetailControlBarDelegate>        delegate;

- (void)setPraise:(BOOL)isPraise;

@end
