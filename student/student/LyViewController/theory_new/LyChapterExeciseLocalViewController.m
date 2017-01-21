//
//  LyChapterExeciseLocalViewController.m
//  student
//
//  Created by MacMini on 2016/12/9.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyChapterExeciseLocalViewController.h"
#import "LyIntensifySettingView.h"
#import "LyTheoryStudyControlBar.h"
#import "LyQuestionOptionTableViewCell.h"
#import "LyChapter.h"
#import "LyQuestion.h"

#import "LyIndicator.h"
#import "LyRemindView.h"
#import "LyTheoryProgressView.h"

#import "LyBottomControl.h"
#import "LyCurrentUser.h"

#import "LyUtil.h"


typedef NS_ENUM(NSInteger, LyChapterExeciseLocalBarButtonItemTag) {
    chapterExeciseLocalBarButtonItemTag_setting = 0
};

typedef NS_ENUM(NSInteger, LyChapterExeciseLocalButtonTag) {
    chapterExeciseLocalButtonTag_confirm = 10,
};




@interface LyChapterExeciseLocalViewController () <UITableViewDelegate, UITableViewDataSource, LyTheoryStudyControlBarDelegate, LyIntensifySettingViewDelegate, LyTheoryProgressViewDelegate>
{
    UIScrollView            *svMain;
    
    UIView                  *viewQuestion;
    UIImageView             *ivQuestionMode;
    UITextView              *tvQuestion;
    
    UIView                  *viewOption;
    UIButton                *btnConfirm;
    
    UIView                  *viewSolution;
    UIImageView             *ivDegree;
    UILabel                 *lbAnswer;
    UITextView              *tvAnalysis;
    
    NSInteger               curIdx_que;
    LyQuestion              *curQuestion;
    NSMutableArray          *arrQuestion;
    NSInteger               iRecordId;
    
    NSIndexPath             *curIdx;
    
    BOOL                    flagAutoJumpNex;
}

@property (strong, nonatomic)       UIImageView     *ivPic;

@property (strong, nonatomic)       UITableView     *tableView;

@property (strong, nonatomic)       LyTheoryStudyControlBar     *controlBar;

@property (strong, nonatomic)       LyIndicator     *indicator;

@property (strong, nonatomic)       LyTheoryProgressView   *progressView;

@end

@implementation LyChapterExeciseLocalViewController

static NSString *lyChapterExeciseLocalTableViewCellReuseIdentifier = @"lyChapterExeciseLocalTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _chapter = [_delegate chapterOfChapterExeciseLocalViewController:self];
    if (!_chapter) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    self.title = _chapter.chapterName;
    curIdx_que = _chapter.index - 1;
    
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    
    if (!curQuestion || !arrQuestion || arrQuestion.count < 1) {
        [self load];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}

- (void)initSubviews {
    
    self.view.backgroundColor = LyWhiteLightgrayColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    UIBarButtonItem *bbiRight = [[UIBarButtonItem alloc] initWithImage:[LyUtil imageForImageName:@"ts_settings" needCache:NO]
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(targetForBarButtonItem:)];
    [self.navigationItem setRightBarButtonItem:bbiRight];
    
    
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
    
    btnConfirm = [LyUtil btnConfirmForTheory:chapterExeciseLocalButtonTag_confirm
                                      target:self
                                      action:@selector(targetForButton:)];
    
    [viewOption addSubview:self.tableView];
    [viewOption addSubview:btnConfirm];
    
    
    
    
    viewSolution = [LyUtil viewForThoery];
    
    UILabel *lbTitle_solution = [LyUtil lbTitleForTheory];
    UILabel *lbDegree = [LyUtil lbDegreeForTheory];
    ivDegree = [LyUtil ivDegreeForTheory];
    lbAnswer = [LyUtil lbAnswerForTheory];
    tvAnalysis = [LyUtil tvSolutionForTheory];
    
    [viewSolution addSubview:lbTitle_solution];
    [viewSolution addSubview:lbDegree];
    [viewSolution addSubview:ivDegree];
    [viewSolution addSubview:lbAnswer];
    [viewSolution addSubview:tvAnalysis];
    
    
    
    [svMain addSubview:viewQuestion];
    [svMain addSubview:viewOption];
    [svMain addSubview:viewSolution];
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(targetForPanGesture:)];
    [self.view addGestureRecognizer:panGesture];
    
    
    [self.view addSubview:svMain];
    [self.view addSubview:self.controlBar];
    
    arrQuestion = [[NSMutableArray alloc] initWithCapacity:1];
    curIdx_que = -1;
    flagAutoJumpNex = [LyUtil loadTheoryStudyAutoFlagWithMode:0];
    [viewSolution setHidden:YES];
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
        
        [_tableView registerClass:[LyQuestionOptionTableViewCell class] forCellReuseIdentifier:lyChapterExeciseLocalTableViewCellReuseIdentifier];
    }
    
    return _tableView;
}

- (LyTheoryStudyControlBar *)controlBar {
    if (!_controlBar) {
        _controlBar = [LyTheoryStudyControlBar theoryStudyControlBarWithMode:theoryStudyControlBar_execise];
        [_controlBar setDelegate:self];
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
        [_progressView setMode:LyTheoryProgressViewMode_execise];
        [_progressView setDelegate:self];
    }
    
    return _progressView;
}

- (void)reloadData {
    
    curQuestion = arrQuestion[curIdx_que];
    [self.controlBar setQuestionInfo:arrQuestion.count currentIndex:curIdx_que + 1];
    
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
    
    
    
    [LyUtil setDegreeImageView:ivDegree withDegree:curQuestion.queDegree];
    [lbAnswer setText:[[NSString alloc] initWithFormat:@"答案：%@", ({
        NSMutableString *str = [[NSMutableString alloc] initWithCapacity:1];
        NSArray *arrAnwer = [LyUtil separateAnswerString:[curQuestion queAnwser]];
        for ( NSString *item in arrAnwer) {
            switch ( [item integerValue]) {
                case LyOptionMode_A: {
                    [str appendString:@"A"];
                    break;
                }
                case LyOptionMode_B: {
                    [str appendString:@"B"];
                    break;
                }
                case LyOptionMode_C: {
                    [str appendString:@"C"];
                    break;
                }
                case LyOptionMode_D: {
                    [str appendString:@"D"];
                    break;
                }
                    
            }
        }
        str;
    })]];
    NSString *sAnalysis = curQuestion.queAnalysis;
    if (![LyUtil validateString:sAnalysis]) {
        sAnalysis = @"我要去学车";
    } 
    CGFloat fHeightTvAnalysis = [LyUtil setTvContentForTheory:tvAnalysis content:sAnalysis isAnalysis:YES];
    [tvAnalysis setFrame:CGRectMake(horizontalSpace, lbAnswer.frame.origin.y + CGRectGetHeight(lbAnswer.frame), tsTvContentWidth, fHeightTvAnalysis)];
    
    [viewSolution setFrame:CGRectMake(0, viewOption.frame.origin.y + CGRectGetHeight(viewOption.frame) + verticalSpace, SCREEN_WIDTH, tvAnalysis.frame.origin.y + fHeightTvAnalysis)];
    
    
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, viewSolution.frame.origin.y + CGRectGetHeight(viewSolution.frame) + 50.0f)];
    
    
    
    [svMain setContentOffset:CGPointMake(0, 0)];
    [viewSolution setHidden:YES];
    
    [self.controlBar setCollectState:curQuestion.bankId > 0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    LyChapterExeciseLocalBarButtonItemTag bbiTag = bbi.tag;
    switch (bbiTag) {
        case chapterExeciseLocalBarButtonItemTag_setting: {
            LyIntensifySettingView *setting = [LyIntensifySettingView settingViewWithMode:LyIntensifySettingViewMode_intensify];
            [setting setDelegate:self];
            [setting show];
            break;
        }
    }
}

- (void)targetForPanGesture:(UIPanGestureRecognizer *)pan {
    
    if (UIGestureRecognizerStateEnded == pan.state) {
        NSInteger nextMode;
        
        CGPoint translatedPoint = [pan translationInView:self.view];
        if (translatedPoint.x < 0) {
            if (curIdx_que >= arrQuestion.count - 1) {
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
        if (![LyUtil validateString:curQuestion.myAnswer]) {
            [self writeSpeed:NO];
        }
    }
    
}

- (void)targetForButton:(UIButton *)btn {
    LyChapterExeciseLocalButtonTag btnTag = btn.tag;
    switch (btnTag) {
        case chapterExeciseLocalButtonTag_confirm: {
            [self checkAnswer];
            break;
        }
    }
}


- (void)changeOptionMode:(NSString *)strAnswer isWrong:(BOOL)isWrong {
    for (int i = 0; i < strAnswer.length; ++i) {
        NSString *item = [strAnswer substringWithRange:NSMakeRange(i, 1)];
        LyQuestionOptionTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:item.integerValue - 1 inSection:0]];
        [cell setChoosed:NO];
        [cell setMode:isWrong ? LyQuestionOptionTableViewCellMode_wrong : LyQuestionOptionTableViewCellMode_right];
    }
}


- (void)checkAnswer {
    
    BOOL wrong = NO;
    
    if (LyQuestionMode_multiChoice == curQuestion.queMode) {
        
        NSMutableString *strAnswer = [[NSMutableString alloc] initWithCapacity:1];
        for (int i = 0; i < [self.tableView numberOfRowsInSection:0]; ++i) {
            LyQuestionOptionTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (cell.isChoosed) {
                [strAnswer appendFormat:@"%d", i + 1];
            }
        }
        
        if (strAnswer.length < 1) {
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没有选择答案"] show];
            return;
        }
        
        [curQuestion setMyAnswer:strAnswer];
        
        if ([curQuestion judge]) {
            [self changeOptionMode:curQuestion.myAnswer isWrong:NO];
            
            if (flagAutoJumpNex && curIdx_que < arrQuestion.count) {
                [self performSelector:@selector(loadNextWithMode:) withObject:@(1) afterDelay:LyDelayTime];
            }
            
        } else {
            wrong = YES;
            [self changeOptionMode:curQuestion.myAnswer isWrong:YES];
        }
        
        
    } else {
        if ([curQuestion judge]) {
            [self changeOptionMode:curQuestion.myAnswer isWrong:NO];
            
            if (flagAutoJumpNex && curIdx_que < arrQuestion.count) {
                [self performSelector:@selector(loadNextWithMode:) withObject:@(1) afterDelay:LyDelayTime];
            }
            
        } else {
            wrong = YES;
            [self changeOptionMode:curQuestion.myAnswer isWrong:YES];
            [self changeOptionMode:curQuestion.queAnwser isWrong:NO];

        }
    }
    
    [viewSolution setHidden:NO];
    
    [self writeSpeed:YES];
    
    if (wrong) {
        [self writeMistake];
    }
}


- (void)load {
    [self.indicator startAnimation];
    
    [self performSelector:@selector(load_genuine) withObject:nil afterDelay:LyDelayTime];
}

- (void)load_genuine {
    NSInteger iCarType = [LyCurrentUser curUser].cartype;
    NSString *sqlQue = [[NSString alloc] initWithFormat:@"SELECT id, question, a, b, c, d, degree, ClassId, answer, imgurl FROM %@ WHERE subjects = %@ AND ChapterId = %@ AND AddressId = %@ AND cartype = %@",
                        LyTheoryTableName_question,
                        @([LyCurrentUser curUser].userSubjectMode),
                        @(_chapter.chapterMode),
                        @(_chapter.provinceId),
                        @(iCarType)
                        ];
    
    FMResultSet *rsQue = [[LyUtil dbTheory] executeQuery:sqlQue];
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

        
        [LyUtil loadQueBankIdForTheory:question userId:[LyCurrentUser curUser].userIdForTheory];
        
        [arrQuestion addObject:question];
    }
    
    [arrQuestion sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 queId].integerValue > [obj2 queId].integerValue;
    }];
    
    [self.indicator stopAnimation];
    [self loadNextWithMode:@(1)];
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
    
    if (curIdx_que >= arrQuestion.count) {
        curIdx_que = arrQuestion.count - 1;
    }
    
    [self reloadData];
    
    [LyUtil transitionForTheory:self.view subtype:subtype];
}


- (void)writeSpeed:(BOOL)isWrong {
    if (iRecordId < 1) {
        NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT id FROM %@ WHERE userid = '%@' AND subjects = %@ AND ChapterId = %@",
                              LyRecordTableName_exeSpeed,
                              [LyCurrentUser curUser].userIdForTheory,
                              @([LyCurrentUser curUser].userSubjectMode),
                              @(_chapter.chapterMode)
                              ];
        FMResultSet *rsSpe = [[LyUtil dbRecord] executeQuery:sqlQuery];
        while ([rsSpe next]) {
            iRecordId = [rsSpe intForColumn:@"id"];
            break;
        }

    }
    
    NSString *sqlOper = nil;
    if (iRecordId < 1) {
        sqlOper = [[NSString alloc] initWithFormat:@"INSERT INTO %@ (userid, tid, subjects, ChapterId, indexs, dotime)  \
                   VALUES ('%@', %@, %@, %@ , %@, '%@')",
                   LyRecordTableName_exeSpeed,
                   [LyCurrentUser curUser].userIdForTheory,
                   curQuestion.queId,
                   @([LyCurrentUser curUser].userSubjectMode),
                   @(_chapter.chapterMode),
                   @(isWrong ? curIdx_que+1 : curIdx_que),
                   [LyUtil stringFromDate:[NSDate date]]
                   ];
    } else {
        sqlOper = [[NSString alloc] initWithFormat:@"UPDATE %@ SET tid = %@, indexs = %@, dotime = '%@' WHERE id = %@",
                   LyRecordTableName_exeSpeed,
                   curQuestion.queId,
                   @(isWrong ? curIdx_que+1 : curIdx_que),
                   [LyUtil stringFromDate:[NSDate date]],
                   @(iRecordId)
                   ];
    }
    BOOL flag = [[LyUtil dbRecord] executeUpdate:sqlOper];
    
    [_chapter setIndex:isWrong ? curIdx_que+1 : curIdx_que];
}

- (void)writeMistake {
    NSString *sId = nil;
    NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT id FROM %@ WHERE userid = '%@' AND tid = %@",
                          LyRecordTableName_exeMistake,
                          [LyCurrentUser curUser].userIdForTheory,
                          curQuestion.queId
                          ];
    FMResultSet *rsMistake = [[LyUtil dbRecord] executeQuery:sqlQuery];
    while ([rsMistake next]) {
        sId = [rsMistake stringForColumn:@"id"];
        break;
    }
    
    if (sId) {
        NSString *sqlUpdate = [[NSString alloc] initWithFormat:@"UPDATE %@ SET errors = errors + 1, myanswer = '%@' WHERE id = %@",
                               LyRecordTableName_exeMistake,
                               curQuestion.myAnswer,
                               sId];
        BOOL flag = [[LyUtil dbRecord] executeUpdate:sqlUpdate];
        
    } else {
        NSString *sqlInsert = [[NSString alloc] initWithFormat:
                               @"INSERT INTO %@ (subjects, ChpaterId, tid, myanswer , userid, errors, jtype)   \
                               VALUES (%@, %@, %@, '%@', '%@', %@, '%@')",
                               LyRecordTableName_exeMistake,
                               @([LyCurrentUser curUser].userSubjectMode),
                               @(_chapter.chapterMode),
                               curQuestion.queId,
                               curQuestion.myAnswer,
                               [LyCurrentUser curUser].userIdForTheory,
                               @(1),
                               [[LyCurrentUser curUser] userLicenseTypeByString]
                               ];
        BOOL flag = [[LyUtil dbRecord] executeUpdate:sqlInsert];
        
    }
}

- (void)collete {
    if (curQuestion.bankId > 0) {
        UIAlertController *action = [UIAlertController alertControllerWithTitle:@"确定从我的题库移除这道题吗？"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
        [action addAction:[UIAlertAction actionWithTitle:@"移除"
                                                   style:UIAlertActionStyleDestructive
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     NSString *sqlDel = [[NSString alloc] initWithFormat:@"DELETE FROM %@ WHERE id = %@",
                                                                         LyRecordTableName_queBank,
                                                                         @(curQuestion.bankId)
                                                                         ];
                                                     BOOL flag = [[LyUtil dbRecord] executeUpdate:sqlDel];
                                                     if (flag) {
                                                         [curQuestion setBankId:0];
                                                         [self.controlBar setCollectState:curQuestion.bankId > 0];
                                                     }
                                                 }]];
        [action addAction:[UIAlertAction actionWithTitle:@"取消"
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
        [self presentViewController:action animated:YES completion:nil];
    } else {
        NSString *sqlInsert = [[NSString alloc] initWithFormat:@"INSERT INTO %@ (userid, subjects, Chapterid, qtime, tid, jtype) VALUES ('%@', %@, %@, '%@', %@, '%@')",
                               LyRecordTableName_queBank,
                               [LyCurrentUser curUser].userIdForTheory,
                               @([LyCurrentUser curUser].userSubjectMode),
                               @(_chapter.chapterMode),
                               [LyUtil stringFromDate:[NSDate date]],
                               curQuestion.queId,
                               [[LyCurrentUser curUser] userLicenseTypeByString]
                               ];
        BOOL flag = [[LyUtil dbRecord] executeUpdate:sqlInsert];
        
        if (flag) {
            [LyUtil loadQueBankIdForTheory:curQuestion userId:[LyCurrentUser curUser].userIdForTheory];
            [self.controlBar setCollectState:curQuestion.bankId > 0];
        }
    }
}

#pragma mark -LyIntensifySettingViewDelegate
- (void)onDoneIntensifySettingView:(LyIntensifySettingView *)settingview andFlagAuto:(BOOL)flagAuto
{
    flagAutoJumpNex = flagAuto;
    [settingview hide];
}


#pragma mark -LyTheoryStudyControlBarDelegate
- (void)onClickedButtonCollect:(LyTheoryStudyControlBar *)theoryStudyControlBar
{
    [self collete];
}

- (void)onClickedButtonAnalysis:(LyTheoryStudyControlBar *)theoryStudyControlBar
{
    [viewSolution setHidden:![viewSolution isHidden]];
}

- (void)onClickedButtonProgress:(LyTheoryStudyControlBar *)theoryStudyControlBar
{
    [self.progressView setArrQuestion:arrQuestion];
    [self.progressView setCurIdx:curIdx_que];
    [self.progressView show];
}



#pragma mark -LyTheoryProgressViewDelegate
- (void)onCloseByTheoryProgressView:(LyTheoryProgressView *)aProgressView
{
    [aProgressView hide];
}

- (void)theoryProgressView:(LyTheoryProgressView *)aProgressView didSelectItemAtIndex:(NSInteger)index
{
    [aProgressView hide];
    
    if ( curIdx_que != index - 1)
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
        for (int i = 0; i < [tableView numberOfRowsInSection:0]; ++i) {
            LyQuestionOptionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell setMode:LyQuestionOptionTableViewCellMode_normal];
        }
        
        LyQuestionOptionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setChoosed:!cell.isChoosed];
        
    } else {
        [curQuestion setMyAnswer:[[NSString alloc] initWithFormat:@"%ld", indexPath.row + 1]];
        [self checkAnswer];
    }
}


#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return curQuestion.queOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyQuestionOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyChapterExeciseLocalTableViewCellReuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[LyQuestionOptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyChapterExeciseLocalTableViewCellReuseIdentifier];
    }
    
    [cell setOption:curQuestion.queOptions[@(indexPath.row + LyOptionMode_A)]];
    [cell setMode:LyQuestionOptionTableViewCellMode_normal];
    [cell setChoosed:NO];
    
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
