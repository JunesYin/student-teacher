//
//  LyExamingLocalViewController.m
//  student
//
//  Created by MacMini on 2016/12/16.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyExamingLocalViewController.h"
#import "LyIntensifySettingView.h"
#import "LyTheoryStudyControlBar.h"
#import "LyQuestionOptionTableViewCell.h"

#import "LyQuestion.h"

#import "LyIndicator.h"
#import "LyRemindView.h"
#import "LyTheoryProgressView.h"

#import "LyCurrentUser.h"
#import "LyCurrentExam.h"

#import "LyUtil.h"


typedef NS_ENUM(NSInteger, LyExamingLocalBarButtonItemTag) {
    examingLocalBarButtonItemTag_close = 0,
};

typedef NS_ENUM(NSInteger, LyExamingLocalButtonTag) {
    examingLocalButtonTag_start = 10,
    examingLocalButtonTag_confirm,
};



@interface LyExamingLocalViewController () <UITableViewDelegate, UITableViewDataSource, LyTheoryStudyControlBarDelegate, LyTheoryProgressViewDelegate, LyRemindViewDelegate>
{
    UIScrollView            *svMain;
    
    UIView                  *viewPrepare;
    
    UIView                  *viewQuestion;
    UIImageView             *ivQuestionMode;
    UITextView              *tvQuestion;
    
    UIView                  *viewOption;
    UIButton                *btnConfirm;
    
    NSInteger               curIdx_que;
    LyQuestion              *curQuestion;
    
    NSIndexPath             *curIdx;
}

@property (strong, nonatomic)       UIImageView     *ivPic;

@property (strong, nonatomic)       UITableView     *tableView;

@property (strong, nonatomic)       LyTheoryStudyControlBar     *controlBar;

@property (strong, nonatomic)       LyIndicator     *indicator;

@property (strong, nonatomic)       LyTheoryProgressView   *progressView;

@end

@implementation LyExamingLocalViewController

static NSString *const lyExamingLocalTableViewCellReuseIdentifier = @"lyExamingLocalTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [self load];
}

- (void)initSubviews {
    self.title = @"全真模考";
    self.view.backgroundColor = LyWhiteLightgrayColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    UIBarButtonItem *left_close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                target:self
                                                                                action:@selector(targetForBarButtonItem:)];
    [left_close setTag:examingLocalBarButtonItemTag_close];
    [self.navigationItem setLeftBarButtonItem:left_close];
    
    
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT - tscbHeight)];
    [svMain setBackgroundColor:LyWhiteLightgrayColor];
    
    viewQuestion = [LyUtil viewForThoery];
    
    tvQuestion = [LyUtil tvQuestionForTheory];
    
    ivQuestionMode = [LyUtil ivQuestionModeForTheory];
    
    [viewQuestion addSubview:tvQuestion];
    [viewQuestion addSubview:ivQuestionMode];
    [viewQuestion addSubview:self.ivPic];
    
    
    viewOption = [[UIView alloc] init];
    [viewOption setBackgroundColor:[UIColor whiteColor]];
    
    //self.tableView
    
    btnConfirm = [LyUtil btnConfirmForTheory:examingLocalButtonTag_confirm
                                      target:self
                                      action:@selector(targetForButton:)];
    
    [viewOption addSubview:self.tableView];
    [viewOption addSubview:btnConfirm];
    
    
    [svMain addSubview:viewQuestion];
    [svMain addSubview:viewOption];
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(targetForPanGesture:)];
    [self.view addGestureRecognizer:panGesture];
    
    
    [self.view addSubview:svMain];
    [self.view addSubview:self.controlBar];
    
    _arrQuestion = [[NSMutableArray alloc] initWithCapacity:1];
    curIdx_que = -1;
    
}


- (UIImageView *)ivPic {
    if (!_ivPic) {
        _ivPic = [LyUtil ivPicForTheory];
    }
    
    return _ivPic;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                  style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setScrollEnabled:NO];
        
        [_tableView registerClass:[LyQuestionOptionTableViewCell class] forCellReuseIdentifier:lyExamingLocalTableViewCellReuseIdentifier];
    }
    
    return _tableView;
}

- (LyTheoryStudyControlBar *)controlBar {
    if (!_controlBar) {
        _controlBar = [LyTheoryStudyControlBar theoryStudyControlBarWithMode:theoryStudyControlBar_simulate_normal];
        [_controlBar setDelegate:self];
        
        switch ( [[LyCurrentUser curUser] userSubjectMode]) {
            case LySubjectMode_first: {
                [_controlBar setTotalTime:60 * 45];
                break;
            }
            case LySubjectMode_fourth: {
                [_controlBar setTotalTime:60 * 30];
                break;
            }
        }
    }
    
    return _controlBar;
}

- (LyIndicator *)indicator {
    if (!_indicator) {
        _indicator = [LyIndicator indicatorWithTitle:nil];
    }
    
    return _indicator;
}

- (LyTheoryProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[LyTheoryProgressView alloc] init];
        [_progressView setMode:LyTheoryProgressViewMode_exam];
        [_progressView setDelegate:self];
    }
    
    return _progressView;
}

- (void)reloadData {
    
    curQuestion = _arrQuestion[curIdx_que];
    [self.controlBar setQuestionInfo:_arrQuestion.count currentIndex:curIdx_que + 1];
    
    if ([self.ivPic isAnimating]) {
        [self.ivPic stopAnimating];
    }
    
    [LyUtil setIvQuestionModeForThoery:ivQuestionMode questionMode:curQuestion.queMode];
    
    CGFloat fHeightTvQuestion = [LyUtil setTvContentForTheory:tvQuestion content:curQuestion.queContent isAnalysis:NO];
    [tvQuestion setFrame:CGRectMake(horizontalSpace, 0, tsTvContentWidth, fHeightTvQuestion)];
    
    CGFloat fHeightIvPic = 0;
    if ([LyUtil validateString:curQuestion.queImgUrl]) {
        fHeightIvPic = [LyUtil showPicForTheory:self.ivPic iamgeName:curQuestion.queImgUrl];
    }
    [self.ivPic setFrame:CGRectMake(0, fHeightTvQuestion, SCREEN_WIDTH, fHeightIvPic)];
    if (fHeightIvPic > 0 && [curQuestion.queImgUrl hasSuffix:@".gif"]) {
        [self.ivPic startAnimating];
    }
    
    [viewQuestion setFrame:CGRectMake(0, 0, SCREEN_WIDTH, fHeightTvQuestion + fHeightIvPic)];
    
    
    CGFloat fHeightTableView = 0;
    switch (curQuestion.queMode) {
        case LyQuestionMode_singleChoice: {
            fHeightTableView = qotcellHeight * 4;
            break;
        }
        case LyQuestionMode_TFNG: {
            fHeightTableView = qotcellHeight * 2;
            break;
        }
        case LyQuestionMode_multiChoice: {
            fHeightTableView = qotcellHeight * 4;
            break;
        }
    }
    [self.tableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, fHeightTableView)];
    if (LyQuestionMode_multiChoice == curQuestion.queMode) {
        [btnConfirm setFrame:CGRectMake(SCREEN_WIDTH - horizontalSpace - tsBtnConfirmWidth, fHeightTableView + verticalSpace, tsBtnConfirmWidth, tsBtnConfirmHeight)];
    } else {
        [btnConfirm setFrame:CGRectMake(SCREEN_WIDTH - horizontalSpace - tsBtnConfirmWidth, fHeightTableView, 0, 0)];
    }
    
    [self.tableView reloadData];
    [viewOption setFrame:CGRectMake(0, viewQuestion.frame.origin.y + CGRectGetHeight(viewQuestion.frame) + 2, SCREEN_WIDTH, btnConfirm.frame.origin.y + CGRectGetHeight(btnConfirm.frame))];
    
    
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, viewOption.frame.origin.y + CGRectGetHeight(viewOption.frame) + 50.0f)];
    
    [svMain setContentOffset:CGPointMake(0, 0)];
    
    [self.controlBar setCollectState:curQuestion.bankId > 0];
}

- (void)showViewPrepare {
    if (!viewPrepare) {
        viewPrepare = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [viewPrepare setBackgroundColor:LyWhiteLightgrayColor];
        
        UIImageView *ivBack = [[UIImageView alloc] initWithFrame:viewPrepare.bounds];
        [ivBack setContentMode:UIViewContentModeScaleAspectFill];
        [ivBack setImage:[LyUtil imageForImageName:@"finishLoadQuestion" needCache:NO]];
        
        CGFloat fWidth = SCREEN_WIDTH * 3 / 5.0;
        CGFloat fHeight = 50.0f;
        UIButton *btnStart = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f - fWidth/2.0f, SCREEN_HEIGHT - horizontalSpace * 2 - fHeight, fWidth, fHeight)];
        [btnStart setTag:examingLocalButtonTag_start];
        [btnStart setTitle:@"开始考试" forState:UIControlStateNormal];
        [btnStart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnStart setBackgroundColor:Ly517ThemeColor];
        [btnStart.layer setCornerRadius:btnCornerRadius];
        [btnStart setClipsToBounds:YES];
        [btnStart addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [viewPrepare addSubview:ivBack];
        [viewPrepare addSubview:btnStart];
    }
    
    [self.controlBar setHidden:YES];
    [self.view addSubview:viewPrepare];
}

- (void)removeViewPrepare {
    [viewPrepare removeFromSuperview];
    viewPrepare = nil;
    
    [self.controlBar setHidden:NO];
    [self.controlBar startExam];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    LyExamingLocalBarButtonItemTag bbiTag = bbi.tag;
    switch (bbiTag) {
        case examingLocalBarButtonItemTag_close: {
            UIAlertController *action = [UIAlertController alertControllerWithTitle:@"你还没有交卷，你确定要退出本次考试吗"
                                                                            message:nil
                                                                     preferredStyle:UIAlertControllerStyleActionSheet];
            [action addAction:[UIAlertAction actionWithTitle:@"继续考试"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil]];
            [action addAction:[UIAlertAction actionWithTitle:@"退出考试"
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         if (_delegate && [_delegate respondsToSelector:@selector(onCloseByExamingLocalViewController:)]) {
                                                             [_delegate onCloseByExamingLocalViewController:self];
                                                         } else {
                                                             [self dismissViewControllerAnimated:YES completion:nil];
                                                         }
                                                         
                                                     }]];
            [self presentViewController:action animated:YES completion:nil];
            break;
        }
    }
}

- (void)targetForPanGesture:(UIPanGestureRecognizer *)pan {
    if (UIGestureRecognizerStateEnded == pan.state) {
        NSInteger nextMode;
        
        CGPoint translatedPoint = [pan translationInView:self.view];
        if (translatedPoint.x < 0) {
            if (curIdx_que >= _arrQuestion.count - 1) {
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"已经最后一题"] show];
                return;
            }
            
            nextMode = 1;
        } else if (translatedPoint.x > 0) {
            if (curIdx_que <= 0) {
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"已经是第一题"] show];
                return;
            }
            
            nextMode = 0;
        }
        
        [self loadNextWithMode:@(nextMode)];
    }
}

- (void)targetForButton:(UIButton *)btn {
    LyExamingLocalButtonTag btnTag = btn.tag;
    switch (btnTag) {
        case examingLocalButtonTag_start: {
            [self removeViewPrepare];
            [self loadNextWithMode:@(1)];
            break;
        }
        case examingLocalButtonTag_confirm: {
            
            break;
        }
    }
}

- (void)load {
    [self.indicator startAnimation];
    
    [self performSelector:@selector(load_genuine) withObject:nil afterDelay:LyDelayTime];
}

- (void)load_genuine {
    NSInteger iCarType = [LyCurrentUser curUser].cartype;
    NSString *sqlPre = [[NSString alloc] initWithFormat:@"SELECT id, question, a, b, c, d, degree, ClassId, answer, imgurl, ChapterId FROM %@ WHERE subjects = %@",
                        LyTheoryTableName_question,
                        @([LyCurrentUser curUser].userSubjectMode)
                        ];
    
    NSMutableArray *arrSql = [[NSMutableArray alloc] initWithCapacity:1];
    
    
    if (LySubjectMode_first == [LyCurrentUser curUser].userSubjectMode) {
        NSInteger iProvinceId = 0;
        NSString *sProvince = nil;
        NSArray *arrAddress = [LyUtil separateString:[LyCurrentUser curUser].userExamAddress separator:@" "];
        if (arrAddress && arrAddress.count > 1) {
            sProvince = [arrAddress objectAtIndex:1];
            sProvince = [sProvince substringToIndex:sProvince.length - 1];
        }
        if (LySubjectMode_first == [LyCurrentUser curUser].userSubjectMode && [LyUtil validateString:sProvince]) {
            NSString *sqlPro = [[NSString alloc] initWithFormat:@"SELECT id FROM theory_province WHERE province LIKE '%%%@%%'", sProvince];
            FMResultSet *rsProvince = [[LyUtil dbTheory] executeQuery:sqlPro];
            while ([rsProvince next]) {
                iProvinceId = [rsProvince intForColumnIndex:0];
                break;
            }
        }
        
        
        NSString *sqlCha_1_3 = nil;
        NSString *sqlCha_2 = nil;
        NSString *sqlCha_4 = nil;
        NSString *sqlCha_5 = nil;
        NSString *sqlCha_6 = nil;
        if (iProvinceId > 0 && iCarType > 0) {
            sqlCha_1_3 = [[NSString alloc] initWithFormat:@"%@ AND ClassId != 2 AND AddressId = 0 AND (ChapterId = 1 OR ChapterId = 3) ORDER BY RANDOM() LIMIT 38",
                          sqlPre
                          ];
            sqlCha_2 = [[NSString alloc] initWithFormat:@"%@ AND ClassId != 2 AND AddressId = 0 AND ChapterId = 2 ORDER BY RANDOM() LIMIT 32",
                        sqlPre
                        ];
            sqlCha_4 = [[NSString alloc] initWithFormat:@"%@ AND ClassId != 2 AND AddressId = 0 AND ChapterId = 4 ORDER BY RANDOM() LIMIT 20",
                        sqlPre
                        ];
            sqlCha_5 = [[NSString alloc] initWithFormat:@"%@ AND ClassId != 2 AND AddressId = %@ AND ChapterId = 5 ORDER BY RANDOM() LIMIT 5",
                        sqlPre,
                        @(iProvinceId)
                        ];
            sqlCha_6 = [[NSString alloc] initWithFormat:@"%@ AND ClassId != 2 AND Address = 0 AND ChapterId = 6 ORDER BY RANDOM() LIMIT 5",
                        sqlPre
                        ];
            
            
        } else if (iProvinceId > 0) {
            sqlCha_1_3 = [[NSString alloc] initWithFormat:@"%@ AND ClassId != 2 AND AddressId = 0 AND (ChapterId = 1 OR ChapterId = 3) ORDER BY RANDOM() LIMIT 40",
                          sqlPre
                          ];
            sqlCha_2 = [[NSString alloc] initWithFormat:@"%@ AND ClassId != 2 AND AddressId = 0 AND ChapterId = 2 ORDER BY RANDOM() LIMIT 35",
                        sqlPre
                        ];
            sqlCha_4 = [[NSString alloc] initWithFormat:@"%@ AND ClassId != 2 AND AddressId = 0 AND ChapterId = 4 ORDER BY RANDOM() LIMIT 20",
                        sqlPre
                        ];
            sqlCha_5 = [[NSString alloc] initWithFormat:@"%@ AND ClassId != 2 AND AddressId = %@ AND ChapterId = 5 ORDER BY RANDOM() LIMIT 5",
                        sqlPre,
                        @(iProvinceId)
                        ];
            
            
        } else if (iCarType > 0) {
            sqlCha_1_3 = [[NSString alloc] initWithFormat:@"%@ AND ClassId != 2 AND AddressId = 0 AND (ChapterId = 1 OR ChapterId = 3) ORDER BY RANDOM() LIMIT 38",
                          sqlPre
                          ];
            sqlCha_2 = [[NSString alloc] initWithFormat:@"%@ AND ClassId != 2 AND AddressId = 0 AND ChapterId = 2 ORDER BY RANDOM() LIMIT 32",
                        sqlPre
                        ];
            sqlCha_4 = [[NSString alloc] initWithFormat:@"%@ AND ClassId != 2 AND AddressId = 0 AND ChapterId = 4 ORDER BY RANDOM() LIMIT 25",
                        sqlPre
                        ];
            sqlCha_6 = [[NSString alloc] initWithFormat:@"%@ AND ClassId != 2 AND Address = 0 AND ChapterId = 6 ORDER BY RANDOM() LIMIT 5",
                        sqlPre
                        ];
            
            
        } else {
            sqlCha_1_3 = [[NSString alloc] initWithFormat:@"%@ AND ClassId != 2 AND AddressId = 0 AND (ChapterId = 1 OR ChapterId = 3) ORDER BY RANDOM() LIMIT 40",
                          sqlPre
                          ];
            sqlCha_2 = [[NSString alloc] initWithFormat:@"%@ AND ClassId != 2 AND AddressId = 0 AND ChapterId = 2 ORDER BY RANDOM() LIMIT 35",
                        sqlPre
                        ];
            sqlCha_4 = [[NSString alloc] initWithFormat:@"%@ AND ClassId != 2 AND AddressId = 0 AND ChapterId = 4 ORDER BY RANDOM() LIMIT 25",
                        sqlPre
                        ];
            
            
        }
        
        
        [arrSql addObject:sqlCha_1_3];
        [arrSql addObject:sqlCha_2];
        [arrSql addObject:sqlCha_4];
        
        if (sqlCha_5) {
            [arrSql addObject:sqlCha_5];
        }
        
        if (sqlCha_6) {
            [arrSql addObject:sqlCha_6];
        }
        
    } else {
        NSString *sqlSingle = [sqlPre stringByAppendingString:@" AND ClassId != 2 ORDER BY RANDOM() LIMIT 45"];
        NSString *sqlMulti = [sqlPre stringByAppendingString:@" AND ClassId = 2 ORDER BY RANDOM() LIMIT 5"];
        
        [arrSql addObject:sqlSingle];
        [arrSql addObject:sqlMulti];
    }
    
    
    for (NSString *sqlItem in arrSql) {
        if (!sqlItem) {
            continue;
        }
        
        FMResultSet *rsQue = [[LyUtil dbTheory] executeQuery:sqlItem];
        while ([rsQue next]) {
            NSString *sId = [rsQue stringForColumn:@"id"];
            NSString *sQuestion = [rsQue stringForColumn:@"question"];
            NSString *sA = [rsQue stringForColumn:@"a"];
            NSString *sB = [rsQue stringForColumn:@"b"];
            NSString *sC = [rsQue stringForColumn:@"c"];
            NSString *sD = [rsQue stringForColumn:@"d"];
            NSInteger iDegree = [rsQue intForColumn:@"degree"];
            LyQuestionMode questionMode = [rsQue intForColumn:@"ClassId"];
            NSString *sAnswer = [rsQue stringForColumn:@"answer"];
            NSString *sImgUrl = [rsQue stringForColumn:@"imgurl"];
            NSInteger iChapterId = [rsQue intForColumn:@"ChapterId"];
            
            NSString *sAnalysis = [LyUtil loadQueAnalysisForTheory:sId];
            
            LyQuestion *question = [LyQuestion questionWithId:sId
                                                      queMode:questionMode
                                                   queContent:sQuestion
                                                         queA:sA
                                                         queB:sB
                                                         queC:sC
                                                         queD:sD
                                                    queAnswer:sAnswer
                                                  queAnalysis:sAnalysis
                                                    queDegree:iDegree
                                                    queImgUrl:sImgUrl];
            [question setQueChapterId:iChapterId];
            [LyUtil loadQueBankIdForTheory:question userId:[LyCurrentUser curUser].userIdForTheory];
            
            [_arrQuestion addObject:question];
        }
    }

    
    [self showViewPrepare];
    [self.indicator stopAnimation];
}

- (void)loadNextWithMode:(NSNumber *)mode {
    NSString *subtype = nil;
    switch (mode.integerValue) {
        case 0: {
            curIdx_que--;
            subtype = kCATransitionFromLeft;
            break;
        }
        case 1: {
            curIdx_que++;
            subtype = kCATransitionFromRight;
            break;
        }
    }
    
    if (curIdx_que >= _arrQuestion.count) {
        curIdx_que = _arrQuestion.count - 1;
    }
    
    [self reloadData];
    
    [LyUtil transitionForTheory:self.view subtype:subtype];
}

- (void)commit {
    [_delegate onCommitByExamingLocalViewController:self arrQuestion:_arrQuestion useMinutes:[self.controlBar stop]];
}


#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(UIView *)view
{
    [self commit];
}


#pragma mark -LyTheoryStudyControlBarDelegate
- (void)onClickedButtonProgress:(LyTheoryStudyControlBar *)theoryStudyControlBar
{
    [self.progressView setArrQuestion:_arrQuestion];
    [self.progressView setCurIdx:curIdx_que];
    [self.progressView show];
}

- (void)onClickedButtonClock:(LyTheoryStudyControlBar *)theoryStudyControlBar
{
    
}

- (void)onClickedButtonCommit:(LyTheoryStudyControlBar *)theoryStudyControlBar
{
    UIAlertController *action = [UIAlertController alertControllerWithTitle:@"确定现在交卷吗？"
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    [action addAction:[UIAlertAction actionWithTitle:@"继续答题"
                                               style:UIAlertActionStyleCancel
                                             handler:nil]];
    [action addAction:[UIAlertAction actionWithTitle:@"交卷"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * _Nonnull action) {
                                                 [self commit];
                                             }]];
    [self presentViewController:action animated:YES completion:nil];
}

- (void)onTimeOverByTest:(LyTheoryStudyControlBar *)theoryStudyControlBar
{
    LyRemindView *remindView = [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"考试时间到"];
    [remindView setDelegate:self];
    [remindView show];
}

#pragma mark LyTheoryProgressViewDelegate
- (void)onCloseByTheoryProgressView:(LyTheoryProgressView *)aProgressView
{
    [aProgressView hide];
}

- (void)theoryProgressView:(LyTheoryProgressView *)aProgressView didSelectItemAtIndex:(NSInteger)index
{
    [aProgressView hide];
    
    if ( curIdx_que != index)
    {
        curIdx_que = index - 1;
        [self loadNextWithMode:@(1)];
    }
    
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return qotcellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    curIdx = indexPath;
    
    if (LyQuestionMode_multiChoice == curQuestion.queMode) {
        LyQuestionOptionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setChoosed:!cell.isChoosed];
        
        NSMutableString *myAnswer = [[NSMutableString alloc] initWithCapacity:1];
        for (int i = 0; i < [tableView numberOfRowsInSection:0]; ++i) {
            LyQuestionOptionTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (cell.isChoosed) {
                [myAnswer appendFormat:@"%d", i + 1];
            }
        }
        [curQuestion setMyAnswer:myAnswer];
        
    } else {
        for (int i = 0; i < [tableView numberOfRowsInSection:0]; ++i) {
            LyQuestionOptionTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (i != indexPath.row) {
                [cell setChoosed:NO];
            } else {
                [cell setChoosed:YES];
                [curQuestion setMyAnswer:[[NSString alloc] initWithFormat:@"%ld", indexPath.row + 1]];
            }
        }
        
        
    }
}


#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return curQuestion.queOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyQuestionOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyExamingLocalTableViewCellReuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[LyQuestionOptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyExamingLocalTableViewCellReuseIdentifier];
    }
    
    [cell setOption:curQuestion.queOptions[@(indexPath.row + LyOptionMode_A)]];
    [cell setMode:LyQuestionOptionTableViewCellMode_normal];
    
    BOOL isChoosed = NO;
    if ([LyUtil validateString:curQuestion.myAnswer]) {
        for (int i = 0; i < curQuestion.myAnswer.length; ++i) {
            NSString *item = [curQuestion.myAnswer substringWithRange:NSMakeRange(i, 1)];
            if (indexPath.row == item.integerValue - 1) {
                isChoosed = YES;
                break;
            }
        }
    }
    
    [cell setChoosed:isChoosed];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
