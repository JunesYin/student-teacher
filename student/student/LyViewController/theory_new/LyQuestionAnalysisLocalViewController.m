//
//  LyQuestionAnalysisLocalViewController.m
//  student
//
//  Created by MacMini on 2016/12/15.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyQuestionAnalysisLocalViewController.h"
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



typedef NS_ENUM(NSInteger, LyQuestionAnalysisBarButtonItemTag) {
    questionAnalysisBarButtonItemTag_clear = 10,
};



@interface LyQuestionAnalysisLocalViewController () <UITableViewDelegate, UITableViewDataSource, LyTheoryStudyControlBarDelegate, LyTheoryProgressViewDelegate>
{
    UIScrollView            *svMain;
    
    UIView                  *viewQuestion;
    UIImageView             *ivQuestionMode;
    UITextView              *tvQuestion;
    
    UIView                  *viewSolution;
    UIImageView             *ivDegree;
    UILabel                 *lbAnswer;
    UITextView              *tvAnalysis;
    
    NSInteger               curIdx_que;
    LyQuestion              *curQuestion;
    NSMutableArray          *arrQuestion;
    NSInteger               iRecordId;

}

@property (strong, nonatomic)       UIImageView     *ivPic;

@property (strong, nonatomic)       UITableView     *tableView;

@property (strong, nonatomic)       LyTheoryStudyControlBar     *controlBar;

@property (strong, nonatomic)       LyIndicator     *indicator;

@property (strong, nonatomic)       LyTheoryProgressView        *progressView;

@end

@implementation LyQuestionAnalysisLocalViewController

static NSString *const lyQuestionAnalysisLocalTableViewCellReuseIdentifier = @"lyQuestionAnalysisLocalTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    self.title = @"试题分析";
    self.view.backgroundColor = LyWhiteLightgrayColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    UIBarButtonItem *bbiClear = [[UIBarButtonItem alloc] initWithTitle:@"重置"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(targetForBarButtonItem:)];
    [bbiClear setTag:questionAnalysisBarButtonItemTag_clear];
    [self.navigationItem setRightBarButtonItem:bbiClear];
    
    
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
    
    arrQuestion = [[NSMutableArray alloc] initWithCapacity:1];
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
        
        [_tableView registerClass:[LyQuestionOptionTableViewCell class] forCellReuseIdentifier:lyQuestionAnalysisLocalTableViewCellReuseIdentifier];
    }
    
    return _tableView;
}

- (LyTheoryStudyControlBar *)controlBar {
    if (!_controlBar) {
        _controlBar = [LyTheoryStudyControlBar theoryStudyControlBarWithMode:theoryStudyControlBar_analysis];
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


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    LyQuestionAnalysisBarButtonItemTag bbiTag = bbi.tag;
    switch (bbiTag) {
        case questionAnalysisBarButtonItemTag_clear: {
            UIAlertController *action = [UIAlertController alertControllerWithTitle:@"确定要重置试题分析的进度吗？"
                                                                            message:nil
                                                                     preferredStyle:UIAlertControllerStyleActionSheet];
            [action addAction:[UIAlertAction actionWithTitle:@"重置"
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self clear];
                                                     }]];
            [action addAction:[UIAlertAction actionWithTitle:@"取消"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil]];
            
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
        
        [self writeSpeed];
    }
    
}


- (void)load {
    [self.indicator setTitle:nil];
    [self.indicator startAnimation];
    
    [self performSelector:@selector(load_genuine) withObject:nil afterDelay:LyDelayTime];
}

- (void)load_genuine {
    NSString *sqlQue = [[NSString alloc] initWithFormat:@"SELECT id, question, a, b, c, d, degree, ClassId, answer, imgurl, ChapterId, AddressId FROM %@ WHERE subjects = %@ AND (cartype = 0 OR cartype = %@)",
                        LyTheoryTableName_question,
                        @([LyCurrentUser curUser].userSubjectMode),
                        @([LyCurrentUser curUser].cartype)
                        ];
    
    NSString *curProvince = nil;
    NSArray *arrAddress = [LyUtil separateString:[LyCurrentUser curUser].userExamAddress separator:@" "];
    if (arrAddress && arrAddress.count > 1) {
        curProvince = [arrAddress objectAtIndex:0];
        curProvince = [curProvince substringToIndex:curProvince.length - 1];
    }
    
    NSInteger iProvinceId = 0;
    if (LySubjectMode_first == [LyCurrentUser curUser].userSubjectMode && [LyUtil validateString:curProvince]) {
        NSString *sqlPro = [[NSString alloc] initWithFormat:@"SELECT id FROM theory_province WHERE province LIKE '%%%@%%'", curProvince];
        FMResultSet *rsProvince = [[LyUtil dbTheory] executeQuery:sqlPro];
        while ([rsProvince next]) {
            iProvinceId = [rsProvince intForColumnIndex:0];
            break;
        }
    }
    
    if (iProvinceId > 0) {
        sqlQue = [sqlQue stringByAppendingFormat:@" AND (AddressId = 0 OR AddressId = %@)",
                  @(iProvinceId)
                  ];
    } else {
        sqlQue = [sqlQue stringByAppendingString:@" AND AddressId = 0"];
    }
    
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
        NSInteger iChapterId = [rsQue intForColumn:@"ChapterId"];
        NSInteger iAddressId = [rsQue intForColumn:@"AddressId"];
        
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
        [question setProvinceId:iAddressId];
        [LyUtil loadQueBankIdForTheory:question userId:[LyCurrentUser curUser].userIdForTheory];
        
        [arrQuestion addObject:question];
    }
    
    [arrQuestion sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 queId].integerValue > [obj2 queId].integerValue;
    }];
    
    
    NSString *sqlAna = [[NSString alloc] initWithFormat:@"SELECT indexs FROM %@ WHERE userid = '%@'",
                        LyRecordTableName_queAnalysis,
                        [LyCurrentUser curUser].userIdForTheory
                        ];
    FMResultSet *rsAna = [[LyUtil dbRecord] executeQuery:sqlAna];
    while ([rsAna next]) {
        curIdx_que = [rsAna intForColumn:@"indexs"];
        break;
    }
    
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


- (void)writeSpeed {
    if (iRecordId < 1) {
        NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT id FROM %@ WHERE userid = '%@' AND subjects = %@ AND jtype = '%@'",
                              LyRecordTableName_queAnalysis,
                              [LyCurrentUser curUser].userIdForTheory,
                              @([LyCurrentUser curUser].userSubjectMode),
                              [[LyCurrentUser curUser] userLicenseTypeByString]
                              ];
        FMResultSet *rsSpe = [[LyUtil dbRecord] executeQuery:sqlQuery];
        while ([rsSpe next]) {
            iRecordId = [rsSpe intForColumn:@"id"];
            break;
        }
    }
    
    if (iRecordId < 1) {
        NSString *sqlInsert = [[NSString alloc] initWithFormat:
                               @"INSERT INTO %@ (userid, tid, indexs, subjects, jtype, dotime)  \
                               VALUES ('%@', %@, %@, %@, '%@', '%@')",
                               LyRecordTableName_queAnalysis,
                               [LyCurrentUser curUser].userIdForTheory,
                               curQuestion.queId,
                               @(curIdx_que - 1),
                               @([LyCurrentUser curUser].userSubjectMode),
                               [[LyCurrentUser curUser] userLicenseTypeByString],
                               [LyUtil stringFromDate:[NSDate date]]
                               ];
        BOOL flag = [[LyUtil dbRecord] executeUpdate:sqlInsert];
        
    } else {
        NSString *sqlUpdate = [[NSString alloc] initWithFormat:@"UPDATE %@ SET tid = %@, indexs = %@, dotime = '%@' WHERE id = %@",
                               LyRecordTableName_queAnalysis,
                               curQuestion.queId,
                               @(curIdx_que - 1),
                               [LyUtil stringFromDate:[NSDate date]],
                               @(iRecordId)
                               ];
        BOOL flag = [[LyUtil dbRecord] executeUpdate:sqlUpdate];
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


- (void)clear {
    [self.indicator setTitle:@"正在重置"];
    [self.indicator startAnimation];
    
    [self performSelector:@selector(clear_genuine) withObject:nil afterDelay:LyDelayTime];
}

- (void)clear_genuine {
    NSString *sqlDel = [[NSString alloc] initWithFormat:@"DELETE FROM %@ WHERE userid = '%@' AND subjects = %@ AND jtype = '%@'",
                        LyRecordTableName_queAnalysis,
                        [LyCurrentUser curUser].userIdForTheory,
                        @([LyCurrentUser curUser].userSubjectMode),
                        [LyCurrentUser curUser].userLicenseTypeByString
                        ];
    
    BOOL flag = [[LyUtil dbRecord] executeUpdate:sqlDel];
    if (flag) {
        iRecordId = 0;
        curIdx_que = -1;
        [self loadNextWithMode:@(1)];
        
        [self.indicator stopAnimation];
    } else {
        [self.indicator stopAnimation];
        
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"重置失败"] show];
    }
}


#pragma mark -LyTheoryStudyControlBarDelegate
- (void)onClickedButtonCollect:(LyTheoryStudyControlBar *)theoryStudyControlBar
{
    [self collete];
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


#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return curQuestion.queOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyQuestionOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyQuestionAnalysisLocalTableViewCellReuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[LyQuestionOptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyQuestionAnalysisLocalTableViewCellReuseIdentifier];
    }
    
    [cell setOption:curQuestion.queOptions[@(indexPath.row + LyOptionMode_A)]];
    [cell setChoosed:NO];
    
    LyQuestionOptionTableViewCellMode cellMode = LyQuestionOptionTableViewCellMode_normal;
    if (LyQuestionMode_multiChoice == curQuestion.queMode) {
        for (int i = 0; i < curQuestion.queAnwser.length; ++i) {
            NSString *item = [curQuestion.queAnwser substringWithRange:NSMakeRange(i, 1)];
            if (indexPath.row == item.integerValue - 1 ) {
                cellMode = LyQuestionOptionTableViewCellMode_right;
                break;
            }
        }
        
    } else {
        if (indexPath.row == curQuestion.queAnwser.integerValue - 1) {
            cellMode = LyQuestionOptionTableViewCellMode_right;
            
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
