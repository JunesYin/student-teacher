//
//  LyStatusDetailExtToolBar.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/3.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>

#define sdebWidth             FULLSCREENWIDTH


UIKIT_EXTERN CGFloat const sdebHeight;



@class LyStatusDetailExtBar;

@protocol LyStatusDetailExtBarDelegate <NSObject>

@optional
- (void)onClickedTransmitByStatusDetailExtBar:(LyStatusDetailExtBar *)aStatusDetailExtBar;

- (void)onClickedEvalutionByStatusDetailExtBar:(LyStatusDetailExtBar *)aStatusDetailExtBar;

- (void)onClickedPraiseByStatusDetailExtBar:(LyStatusDetailExtBar *)aStatusDetailExtBar;

@end



@interface LyStatusDetailExtBar : UIView

@property ( assign, nonatomic)          NSInteger           transmitCount;
@property ( assign, nonatomic)          NSInteger           evalutionCount;
@property ( assign, nonatomic)          NSInteger           praiseCount;

@property ( weak, nonatomic)        id<LyStatusDetailExtBarDelegate>        delegate;


- (void)setSelectedItem:(NSIndexPath *)indexPath;

@end
