//
//  LyTheoryStudyControlBar.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>

#define tscbWidth                       SCREEN_WIDTH

UIKIT_EXTERN CGFloat const tscbHeight;



typedef NS_ENUM( NSInteger, LyTheoryStudyControlBarMode)
{
    theoryStudyControlBar_execise,
    theoryStudyControlBar_analysis,
    theoryStudyControlBar_simulate_normal,
    theoryStudyControlBar_simulate_commited,
    theoryStudyControlBar_simulate_mistake,
    theoryStudyControlBar_myLibrary
};


@protocol LyTheoryStudyControlBarDelegate;




@interface LyTheoryStudyControlBar : UIView

@property ( assign, nonatomic)          LyTheoryStudyControlBarMode         mode;

@property ( assign, nonatomic, readonly)          NSInteger                           questionCount;
@property ( assign, nonatomic, readonly)          NSInteger                           currentIndex;

@property ( assign, nonatomic, readonly)          NSInteger                           totalTime;
@property ( assign, nonatomic, readonly)          NSInteger                           curTime;

@property ( assign, nonatomic)      id<LyTheoryStudyControlBarDelegate>     delegate;

+ (instancetype)theoryStudyControlBarWithMode:(LyTheoryStudyControlBarMode)mode;

- (instancetype)initWithMode:(LyTheoryStudyControlBarMode)mode;

- (void)setQuestionInfo:(NSInteger)questionCount currentIndex:(NSInteger)currenIndex;

- (void)setTotalTime:(NSInteger)totalSeconds;

- (void)startExam;

- (NSInteger)stop;

- (void)setCollectState:(BOOL)isCollect;

@end


@protocol LyTheoryStudyControlBarDelegate <NSObject>

@optional
- (void)onClickedButtonCollect:(LyTheoryStudyControlBar *)theoryStudyControlBar;
- (void)onClickedButtonExclude:(LyTheoryStudyControlBar *)theoryStudyControlBar;
- (void)onClickedButtonAnalysis:(LyTheoryStudyControlBar *)theoryStudyControlBar;
- (void)onClickedButtonProgress:(LyTheoryStudyControlBar *)theoryStudyControlBar;
- (void)onClickedButtonClock:(LyTheoryStudyControlBar *)theoryStudyControlBar;
- (void)onClickedButtonCommit:(LyTheoryStudyControlBar *)theoryStudyControlBar;
- (void)onClickedButtonViewMistake:(LyTheoryStudyControlBar *)theoryStudyControlBar;
- (void)onClickedButtonShare:(LyTheoryStudyControlBar *)theoryStudyControlBar;
- (void)onClickedButtonRetest:(LyTheoryStudyControlBar *)theoryStudyControlBar;
- (void)onCLickedButtonDecollect:(LyTheoryStudyControlBar *)theoryStudyControlBar;

- (void)onTimeOverByTest:(LyTheoryStudyControlBar *)theoryStudyControlBar;


@end
