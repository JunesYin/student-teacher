//
//  LyExamMistakeLocalViewController.m
//  student
//
//  Created by MacMini on 2016/12/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyExamMistakeLocalViewController.h"
#import "LyTheoryStudyControlBar.h"
#import "LyQuestionOptionTableViewCell.h"
#import "LyChapter.h"
#import "LyQuestion.h"

#import "LyIndicator.h"
#import "LyRemindView.h"
#import "LyTheoryProgressView.h"

#import "LyCurrentUser.h"

#import "LyUtil.h"


@interface LyExamMistakeLocalViewController () <UITableViewDelegate, UITableViewDataSource, LyTheoryStudyControlBarDelegate, LyTheoryProgressViewDelegate>
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
}

@property (strong, nonatomic)       UIImageView     *ivPic;

@property (strong, nonatomic)       UITableView     *tableView;

@property (strong, nonatomic)       LyTheoryStudyControlBar     *controlBar;

@property (strong, nonatomic)       LyIndicator     *indicator;

@property (strong, nonatomic)       LyTheoryProgressView   *progressView;

@end

@implementation LyExamMistakeLocalViewController

static NSString *const lyExamMistakeTableViewCellReuseIdentifier = @"lyExamMistakeTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [self loadNextWithMode:@(1)];
}

- (void)initSubviews {
    self.title = @"全真模考";
    self.view.backgroundColor = LyWhiteLightgrayColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT - tscbHeight)];
    [svMain setBackgroundColor:LyWhiteLightgrayColor];
    
    viewQuestion = [LyUtil viewForThoery];
    
    tvQuestion = [LyUtil tvQuestionForTheory];
    
    ivQuestionMode = [LyUtil ivQuestionModeForTheory];
    
    [viewQuestion addSubview:tvQuestion];
    [viewQuestion addSubview:ivQuestionMode];
    [viewQuestion addSubview:self.ivPic];
    
    
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
    //    [svMain addSubview:viewOption];
    [svMain addSubview:self.tableView];
    [svMain addSubview:viewSolution];
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(targetForPanGesture:)];
    [self.view addGestureRecognizer:panGesture];
    
    
    [self.view addSubview:svMain];
    [self.view addSubview:self.controlBar];
    
    curIdx_que = -1;
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
        
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        
        [_tableView registerClass:[LyQuestionOptionTableViewCell class] forCellReuseIdentifier:lyExamMistakeTableViewCellReuseIdentifier];
    }
    
    return _tableView;
}

- (LyTheoryStudyControlBar *)controlBar {
    if (!_controlBar) {
        _controlBar = [LyTheoryStudyControlBar theoryStudyControlBarWithMode:theoryStudyControlBar_simulate_mistake];
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
    [self.tableView setFrame:CGRectMake(0, viewQuestion.frame.origin.y + CGRectGetHeight(viewQuestion.frame) + 2, SCREEN_WIDTH, fHeightTableView)];
    [self.tableView reloadData];
    
    
    
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
    
    [viewSolution setFrame:CGRectMake(0, self.tableView.frame.origin.y + CGRectGetHeight(self.tableView.frame) + verticalSpace, SCREEN_WIDTH, tvAnalysis.frame.origin.y + fHeightTvAnalysis)];
    
    
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, viewSolution.frame.origin.y + CGRectGetHeight(viewSolution.frame) + 50.0f)];
    [svMain setContentOffset:CGPointMake(0, 0)];
    [viewSolution setHidden:NO];
    
    [self.controlBar setCollectState:curQuestion.bankId > 0];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                               @(curQuestion.queChapterId),
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


#pragma mark -LyTheoryStudyControlBarDelegate
- (void)onClickedButtonCollect:(LyTheoryStudyControlBar *)theoryStudyControlBar
{
    [self collete];
}

- (void)onClickedButtonRetest:(LyTheoryStudyControlBar *)theoryStudyControlBar
{
    [_delegate onReexamByExamMistakeLocalViewController:self];
}

- (void)onClickedButtonAnalysis:(LyTheoryStudyControlBar *)theoryStudyControlBar
{
    [viewSolution setHidden:!viewSolution.isHidden];
}

- (void)onClickedButtonProgress:(LyTheoryStudyControlBar *)theoryStudyControlBar
{
    [self.progressView setArrQuestion:_arrQuestion];
    [self.progressView setCurIdx:curIdx_que];
    [self.progressView show];
}

#pragma mark LyTheoryProgressViewDelegate
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

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return curQuestion.queOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyQuestionOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyExamMistakeTableViewCellReuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[LyQuestionOptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyExamMistakeTableViewCellReuseIdentifier];
    }
    
    [cell setOption:curQuestion.queOptions[@(indexPath.row + LyOptionMode_A)]];
    [cell setChoosed:NO];
    LyQuestionOptionTableViewCellMode cellMode = LyQuestionOptionTableViewCellMode_normal;
    
    if (LyQuestionMode_multiChoice == curQuestion.queMode) {
        for (int i = 0; i < curQuestion.myAnswer.length; ++i) {
            NSString *item = [curQuestion.myAnswer substringWithRange:NSMakeRange(i, 1)];
            if (indexPath.row == item.integerValue - 1) {
                cellMode = LyQuestionOptionTableViewCellMode_wrong;
                break;
            }
        }
        
    } else {
        if (indexPath.row == curQuestion.queAnwser.integerValue - 1) {
            cellMode = LyQuestionOptionTableViewCellMode_right;
            
        } else if (indexPath.row == curQuestion.myAnswer.integerValue - 1) {
            cellMode = LyQuestionOptionTableViewCellMode_wrong;
            
        }
    }
    [cell setMode:cellMode];
    
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
