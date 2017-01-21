//
//  LyTheoryStudyControlBar.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyTheoryStudyControlBar.h"

#import "LyUtil.h"


CGFloat const tscbHeight = 50.0f;

#define ivIconWidth                 CGRectGetWidth(self.frame)
#define ivIconHeight                (CGRectGetWidth(self.frame)*3/5.0f)

#define lbTextWidth                 CGRectGetWidth(self.frame)
#define lbTextHeight                (CGRectGetWidth(self.frame)*2/5.0f)
#define lbTextFont                  LyFont(10)

typedef NS_ENUM( NSInteger, LyProgressButtonMode)
{
    progressButtonMode_progress,
    progressButtonMode_clock
};


@class LyProgressButton;

@protocol LyProgressButtonDelegate <NSObject>

@optional
- (void)onTimeOver:(LyProgressButton *)progressButton;

@end


@interface LyProgressButton : UIButton
{
    UILabel             *lbText;
    NSTimer             *timerForClock;
}

@property ( assign, nonatomic)          LyProgressButtonMode            mode;

@property ( assign, nonatomic)          NSInteger                       allCount;
@property ( assign, nonatomic)          NSInteger                       currentIndex;

@property ( assign, nonatomic)          NSInteger                       totalTime;
@property ( assign, nonatomic, readonly)    NSInteger                   curTime;

@property ( assign, nonatomic)          id<LyProgressButtonDelegate>    delegate;



- (void)fire;
- (void)stop;


@end

@implementation LyProgressButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        [self initSubviews];
    }
    
    return self;
}


- (void)initSubviews
{
    
    lbText = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetHeight(self.frame)*2.0f/5.0f, lbTextWidth, lbTextHeight)];
    [lbText setFont:lbTextFont];
    [lbText setTextColor:LyBlackColor];
    [lbText setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbText];
}



- (void)setMode:(LyProgressButtonMode)mode
{
    _mode = mode;
    
    switch ( _mode) {
        case progressButtonMode_progress: {
            
            [lbText setText:[[NSString alloc] initWithFormat:@"%ld/%ld", _currentIndex, _allCount]];
            
            break;
        }
        case progressButtonMode_clock: {
            
            break;
        }
    }
}


- (void)fire
{
    [lbText setText:[self translateSecondsToClock:_totalTime]];
    _curTime = _totalTime;
    timerForClock = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                     target:self
                                                   selector:@selector(targetForTimer:)
                                                   userInfo:nil
                                                    repeats:YES];//[NSTimer timerWithTimeInterval:1 target:self selector:@selector(targetForTimer:) userInfo:self repeats:YES];
    [timerForClock fire];
}

- (void)stop
{
    [timerForClock invalidate];
}

- (void)setTotalTime:(NSInteger)totalTime
{
    _totalTime = totalTime;
    _curTime = totalTime;
    
    [lbText setText:[self translateSecondsToClock:_curTime]];
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    [lbText setText:[[NSString alloc] initWithFormat:@"%ld/%ld", _currentIndex, _allCount]];
}


- (void)setAllCount:(NSInteger)allCount
{
    _allCount = allCount;
    [lbText setText:[[NSString alloc] initWithFormat:@"%ld/%ld", _currentIndex, _allCount]];
}



- (void)targetForTimer:(NSTimer *)timer
{
    _curTime--;
    
    [lbText setText:[self translateSecondsToClock:_curTime]];
    
    if ( 1 > _curTime)
    {
        [timerForClock invalidate];
        
        [_delegate onTimeOver:self];
    }
}


- (NSString *)translateSecondsToClock:(NSInteger)seconds
{
    NSInteger minute = seconds / 60;
    NSInteger second = seconds % 60;
    
    return [[NSString alloc] initWithFormat:@"%02ld:%02ld", minute, second];
}

@end


#define btnItemheight                               (tscbHeight*4.0/5.0f)
#define btnItemWidth                                (btnItemheight*1.5f)

#define theoryStudyControlBarVerticalMargin         ((tscbHeight-btnItemheight)/2.0f)


#define btnItemSpace_four                           ((CGRectGetWidth(self.frame)-btnItemWidth*4)/(4+1))
#define btnItemSpace_three                          ((CGRectGetWidth(self.frame)-btnItemWidth*3)/(3+1))
#define btnItemSpace_two                            ((CGRectGetWidth(self.frame)-btnItemWidth*2)/(2+1))
#define btnItemSpace_one                            ((CGRectGetWidth(self.frame)-btnItemWidth*1)/(1+1))

typedef NS_ENUM( NSInteger, LyTheoryStudyControlBarButtonItemMode)
{
    theoryStudyControlBarButtonItemMode_collect = 54,
//    theoryStudyControlBarButtonItemMode_exclude,
    theoryStudyControlBarButtonItemMode_analysis,
    theoryStudyControlBarButtonItemMode_progress,
    
    theoryStudyControlBarButtonItemMode_clock,
    theoryStudyControlBarButtonItemMode_commit,
    theoryStudyControlBarButtonItemMode_retest,
    
    theoryStudyControlBarButtonItemMode_viewMistake,
    theoryStudyControlBarButtonItemMode_share,
    
    theoryStudyControlBarButtonItemMode_decollect
    
};


@interface LyTheoryStudyControlBar () <LyProgressButtonDelegate>
{
    UIButton                *btnCollect;
//    UIButton                *btnExclude;
    UIButton                *btnAnalysis;
    LyProgressButton        *btnProgress;
    
    LyProgressButton        *btnClock;
    UIButton                *btnCommit;
    UIButton                *btnRetest;
    
    UIButton                *btnViewMistake;
    UIButton                *btnShare;
    
    UIButton                *btnDecollecte;
}
@end


@implementation LyTheoryStudyControlBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



+ (instancetype)theoryStudyControlBarWithMode:(LyTheoryStudyControlBarMode)mode
{
    LyTheoryStudyControlBar *instance = [[LyTheoryStudyControlBar alloc] initWithMode:mode];
    
    return instance;
}


- (instancetype)initWithMode:(LyTheoryStudyControlBarMode)mode
{
    if ( self = [super initWithFrame:CGRectMake( 0, SCREEN_HEIGHT-tscbHeight, tscbWidth, tscbHeight)])
    {
        _mode = mode;
        [self initSubviews];
    }
    
    return self;
}



- (void)initSubviews
{
    [self setBackgroundColor:LyWhiteLightgrayColor];
    [self setAlpha:0.9f];
    
    switch ( _mode) {
        case theoryStudyControlBar_execise: {
            [self initSubviews_execise];
            break;
        }
        case theoryStudyControlBar_analysis: {
            [self initSubviews_analysis];
            break;
        }

        case theoryStudyControlBar_simulate_normal: {
            [self initSubviews_simulate_normal];
            break;
        }
        case theoryStudyControlBar_simulate_commited: {
            [self initSubviews_simulate_commited];
            break;
        }
        case theoryStudyControlBar_simulate_mistake: {
            [self initSubviews_simulate_mistake];
            break;
        }
        case theoryStudyControlBar_myLibrary: {
            [self initSubviews_myLibrary];
            break;
        }
    }
}



- (void)initSubviews_execise
{
    
    btnCollect = [[UIButton alloc] initWithFrame:CGRectMake( btnItemSpace_three, theoryStudyControlBarVerticalMargin, btnItemWidth, btnItemheight)];
    [btnCollect setTag:theoryStudyControlBarButtonItemMode_collect];
    [btnCollect setImage:[LyUtil imageForImageName:@"ts_controlBar_collect_n" needCache:NO] forState:UIControlStateNormal];
//    [btnCollect setImage:[LyUtil imageForImageName:@"ts_controlBar_collect_h" needCache:NO] forState:UIControlStateSelected];
    [btnCollect addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
//    btnExclude = [[UIButton alloc] initWithFrame:CGRectMake( btnCollect.frame.origin.x+CGRectGetWidth(btnCollect.frame)+btnItemSpace_four, theoryStudyControlBarVerticalMargin, btnItemWidth, btnItemheight)];
//    [btnExclude setTag:theoryStudyControlBarButtonItemMode_exclude];
//    [btnExclude setImage:[LyUtil imageForImageName:@"ts_controlBar_exclude" needCache:NO] forState:UIControlStateNormal];
//    [btnExclude addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    btnAnalysis = [[UIButton alloc] initWithFrame:CGRectMake( btnCollect.frame.origin.x+CGRectGetWidth(btnCollect.frame)+btnItemSpace_three, theoryStudyControlBarVerticalMargin, btnItemWidth, btnItemheight)];
    [btnAnalysis setTag:theoryStudyControlBarButtonItemMode_analysis];
    [btnAnalysis setImage:[LyUtil imageForImageName:@"ts_controlBar_analysis" needCache:NO] forState:UIControlStateNormal];
    [btnAnalysis addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    btnProgress = [[LyProgressButton alloc] initWithFrame:CGRectMake( btnAnalysis.frame.origin.x+CGRectGetWidth(btnAnalysis.frame)+btnItemSpace_three, theoryStudyControlBarVerticalMargin, btnItemWidth, btnItemheight)];
    [btnProgress setTag:theoryStudyControlBarButtonItemMode_progress];
    [btnProgress setImage:[LyUtil imageForImageName:@"ts_controlBar_progress" needCache:NO] forState:UIControlStateNormal];
    [btnProgress addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [btnProgress setMode:progressButtonMode_progress];
    
    
    
    [self addSubview:btnCollect];
//    [self addSubview:btnExclude];
    [self addSubview:btnAnalysis];
    [self addSubview:btnProgress];
    
}



- (void)initSubviews_analysis
{
    btnCollect = [[UIButton alloc] initWithFrame:CGRectMake( btnItemSpace_two, theoryStudyControlBarVerticalMargin, btnItemWidth, btnItemheight)];
    [btnCollect setTag:theoryStudyControlBarButtonItemMode_collect];
    [btnCollect setImage:[LyUtil imageForImageName:@"ts_controlBar_collect_n" needCache:NO] forState:UIControlStateNormal];
//    [btnCollect setImage:[LyUtil imageForImageName:@"ts_controlBar_collect_h" needCache:NO] forState:UIControlStateSelected];
    [btnCollect addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
//    btnExclude = [[UIButton alloc] initWithFrame:CGRectMake( btnCollect.frame.origin.x+CGRectGetWidth(btnCollect.frame)+btnItemSpace_three, theoryStudyControlBarVerticalMargin, btnItemWidth, btnItemheight)];
//    [btnExclude setTag:theoryStudyControlBarButtonItemMode_exclude];
//    [btnExclude setImage:[LyUtil imageForImageName::@"ts_controlBar_exclude" ] forState:UIControlStateNormal];
//    [btnExclude addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    btnProgress = [[LyProgressButton alloc] initWithFrame:CGRectMake( btnCollect.frame.origin.x+CGRectGetWidth(btnCollect.frame)+btnItemSpace_two, theoryStudyControlBarVerticalMargin, btnItemWidth, btnItemheight)];
    [btnProgress setTag:theoryStudyControlBarButtonItemMode_progress];
    [btnProgress setImage:[LyUtil imageForImageName:@"ts_controlBar_progress" needCache:NO] forState:UIControlStateNormal];
    [btnProgress addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [btnProgress setMode:progressButtonMode_progress];
    
    
    [self addSubview:btnCollect];
//    [self addSubview:btnExclude];
    [self addSubview:btnProgress];
}


- (void)initSubviews_simulate_normal
{
    
    btnClock = [[LyProgressButton alloc] initWithFrame:CGRectMake( btnItemSpace_three, theoryStudyControlBarVerticalMargin, btnItemWidth, btnItemheight)];
    [btnClock setTag:theoryStudyControlBarButtonItemMode_clock];
    [btnClock setImage:[LyUtil imageForImageName:@"ts_controlBar_clock" needCache:NO] forState:UIControlStateNormal];
    [btnClock addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [btnClock setMode:progressButtonMode_clock];
    [btnClock setDelegate:self];
//    [btnClock setTotalTime:60*45];
    
    btnCommit = [[UIButton alloc] initWithFrame:CGRectMake( btnClock.frame.origin.x+CGRectGetWidth(btnClock.frame)+btnItemSpace_three, theoryStudyControlBarVerticalMargin, btnItemWidth, btnItemheight)];
    [btnCommit setTag:theoryStudyControlBarButtonItemMode_commit];
    [btnCommit setImage:[LyUtil imageForImageName:@"ts_controlBar_commit" needCache:NO] forState:UIControlStateNormal];
    [btnCommit addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    btnProgress = [[LyProgressButton alloc] initWithFrame:CGRectMake( btnCommit.frame.origin.x+CGRectGetWidth(btnCommit.frame)+btnItemSpace_three, theoryStudyControlBarVerticalMargin, btnItemWidth, btnItemheight)];
    [btnProgress setTag:theoryStudyControlBarButtonItemMode_progress];
    [btnProgress setImage:[LyUtil imageForImageName:@"ts_controlBar_progress" needCache:NO] forState:UIControlStateNormal];
    [btnProgress addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [btnProgress setMode:progressButtonMode_progress];
    
    
    
    [self addSubview:btnCollect];
    [self addSubview:btnClock];
    [self addSubview:btnCommit];
    [self addSubview:btnProgress];
}



- (void)initSubviews_simulate_commited
{
    btnViewMistake = [[UIButton alloc] initWithFrame:CGRectMake( btnItemSpace_three, theoryStudyControlBarVerticalMargin, btnItemWidth, btnItemheight)];
    [btnViewMistake setTag:theoryStudyControlBarButtonItemMode_viewMistake];
    [btnViewMistake setImage:[LyUtil imageForImageName:@"ts_controlBar_viewMistake" needCache:NO] forState:UIControlStateNormal];
    [btnViewMistake addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    
    btnShare = [[UIButton alloc] initWithFrame:CGRectMake( btnViewMistake.frame.origin.x+CGRectGetWidth(btnViewMistake.frame)+btnItemSpace_three, theoryStudyControlBarVerticalMargin, btnItemWidth, btnItemheight)];
    [btnShare setTag:theoryStudyControlBarButtonItemMode_share];
    [btnShare setImage:[LyUtil imageForImageName:@"ts_controlBar_share" needCache:NO] forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    btnRetest = [[UIButton alloc] initWithFrame:CGRectMake( btnShare.frame.origin.x+CGRectGetWidth(btnShare.frame)+btnItemSpace_three, theoryStudyControlBarVerticalMargin, btnItemWidth, btnItemheight)];
    [btnRetest setTag:theoryStudyControlBarButtonItemMode_retest];
    [btnRetest setImage:[LyUtil imageForImageName:@"ts_controlBar_reTest" needCache:NO] forState:UIControlStateNormal];
    [btnRetest addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:btnViewMistake];
    [self addSubview:btnShare];
    [self addSubview:btnRetest];
}



- (void)initSubviews_simulate_mistake
{
    btnCollect = [[UIButton alloc] initWithFrame:CGRectMake( btnItemSpace_four, theoryStudyControlBarVerticalMargin, btnItemWidth, btnItemheight)];
    [btnCollect setTag:theoryStudyControlBarButtonItemMode_collect];
    [btnCollect setImage:[LyUtil imageForImageName:@"ts_controlBar_collect_n" needCache:NO] forState:UIControlStateNormal];
//    [btnCollect setImage:[LyUtil imageForImageName:@"ts_controlBar_collect_h" needCache:NO] forState:UIControlStateSelected];
    [btnCollect addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    btnRetest = [[UIButton alloc] initWithFrame:CGRectMake( btnCollect.frame.origin.x+CGRectGetWidth(btnCollect.frame)+btnItemSpace_four, theoryStudyControlBarVerticalMargin, btnItemWidth, btnItemheight)];
    [btnRetest setTag:theoryStudyControlBarButtonItemMode_retest];
    [btnRetest setImage:[LyUtil imageForImageName:@"ts_controlBar_reTest" needCache:NO] forState:UIControlStateNormal];
    [btnRetest addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    btnAnalysis = [[UIButton alloc] initWithFrame:CGRectMake( btnRetest.frame.origin.x+CGRectGetWidth(btnRetest.frame)+btnItemSpace_four, theoryStudyControlBarVerticalMargin, btnItemWidth, btnItemheight)];
    [btnAnalysis setTag:theoryStudyControlBarButtonItemMode_analysis];
    [btnAnalysis setImage:[LyUtil imageForImageName:@"ts_controlBar_analysis" needCache:NO] forState:UIControlStateNormal];
    [btnAnalysis addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    btnProgress = [[LyProgressButton alloc] initWithFrame:CGRectMake( btnAnalysis.frame.origin.x+CGRectGetWidth(btnAnalysis.frame)+btnItemSpace_four, theoryStudyControlBarVerticalMargin, btnItemWidth, btnItemheight)];
    [btnProgress setTag:theoryStudyControlBarButtonItemMode_progress];
    [btnProgress setImage:[LyUtil imageForImageName:@"ts_controlBar_progress" needCache:NO] forState:UIControlStateNormal];
    [btnProgress addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [btnProgress setMode:progressButtonMode_progress];
    
    
    [self addSubview:btnCollect];
    [self addSubview:btnRetest];
    [self addSubview:btnAnalysis];
    [self addSubview:btnProgress];
}


- (void)initSubviews_myLibrary
{
    btnDecollecte = [[UIButton alloc] initWithFrame:CGRectMake( btnItemSpace_two, theoryStudyControlBarVerticalMargin, btnItemWidth, btnItemheight)];
    [btnDecollecte setTag:theoryStudyControlBarButtonItemMode_decollect];
    [btnDecollecte setImage:[LyUtil imageForImageName:@"ts_controlBar_decollecte" needCache:NO] forState:UIControlStateNormal];
    [btnDecollecte addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    
    btnProgress = [[LyProgressButton alloc] initWithFrame:CGRectMake( btnDecollecte.frame.origin.x+CGRectGetWidth(btnDecollecte.frame)+btnItemSpace_two, theoryStudyControlBarVerticalMargin, btnItemWidth, btnItemheight)];
    [btnProgress setTag:theoryStudyControlBarButtonItemMode_progress];
    [btnProgress setImage:[LyUtil imageForImageName:@"ts_controlBar_progress" needCache:NO] forState:UIControlStateNormal];
    [btnProgress addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [btnProgress setMode:progressButtonMode_progress];
    
    
    [self addSubview:btnDecollecte];
    [self addSubview:btnProgress];
}



- (void)setQuestionInfo:(NSInteger)questionCount currentIndex:(NSInteger)currenIndex
{
    _questionCount = questionCount;
    _currentIndex = currenIndex;
    
    [btnProgress setAllCount:questionCount];
    [btnProgress setCurrentIndex:_currentIndex];
}



- (void)setTotalTime:(NSInteger)totalSeconds
{
    [btnClock setTotalTime:totalSeconds];
}

- (void)startExam
{
    [btnClock fire];
}


- (NSInteger)stop
{
    [btnClock stop];
    
    return [btnClock totalTime]-[btnClock curTime];
}


- (void)setCollectState:(BOOL)isCollect
{
    NSString *imageName = isCollect ? @"ts_controlBar_collect_h" : @"ts_controlBar_collect_n";
    [btnCollect setImage:[LyUtil imageForImageName:imageName needCache:NO] forState:UIControlStateNormal];
}


- (void)targetForButtonItem:(UIButton *)button
{
    
    switch ( [button tag]) {
        case theoryStudyControlBarButtonItemMode_collect: {
            [_delegate onClickedButtonCollect:self];
            break;
        }
//        case theoryStudyControlBarButtonItemMode_exclude: {
//            
//            break;
//        }
        case theoryStudyControlBarButtonItemMode_analysis: {
            [_delegate onClickedButtonAnalysis:self];
            break;
        }
        case theoryStudyControlBarButtonItemMode_progress: {
            [_delegate onClickedButtonProgress:self];
            break;
        }
        case theoryStudyControlBarButtonItemMode_clock: {
//            [_delegate onClickedButtonClock:self];
            break;
        }
        case theoryStudyControlBarButtonItemMode_commit: {
            [_delegate onClickedButtonCommit:self];
            break;
        }
        case theoryStudyControlBarButtonItemMode_retest: {
            [_delegate onClickedButtonRetest:self];
            break;
        }
        case theoryStudyControlBarButtonItemMode_viewMistake: {
            [_delegate onClickedButtonViewMistake:self];
            break;
        }
        case theoryStudyControlBarButtonItemMode_share: {
            [_delegate onClickedButtonShare:self];
            break;
        }
        case theoryStudyControlBarButtonItemMode_decollect: {
            [_delegate onCLickedButtonDecollect:self];
            break;
        }
    }
}


#pragma mark -LyProgressButtonDelegate
- (void)onTimeOver:(LyProgressButton *)progressButton
{
    if ( theoryStudyControlBarButtonItemMode_clock == [progressButton tag])
    {
        if ( [_delegate respondsToSelector:@selector(onTimeOverByTest:)])
        {
            [_delegate onTimeOverByTest:self];
        }
    }
}


@end
