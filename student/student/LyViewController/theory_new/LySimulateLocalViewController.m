//
//  LySimulateLocalViewController.m
//  student
//
//  Created by MacMini on 2016/12/16.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LySimulateLocalViewController.h"
#import "LySimuLateStudyTableViewCell.h"

#import "LyCurrentUser.h"
#import "LyExamHistoryManager.h"

#import "LyIndicator.h"

#import "LyUtil.h"


#import "LyExamHistoryLocalTableViewController.h"
#import "LyExamingLocalViewController.h"
#import "LyExamResultLocalViewController.h"



CGFloat const slViewUserHeight = 150.0f;
CGFloat const slIvAvatarSize = 70.0f;
CGFloat const slLbNameHeight = 30.0f;
CGFloat const slLbExamHistoryHeight = 20.0f;

CGFloat const slBtnExamHistoryWidth = 100.0f;
CGFloat const slBtnExamHistoryHeight = 30.0f;

#define slBtnStartExamWidth                 (SCREEN_WIDTH * 3 / 5.0f)
CGFloat const slBtnStartExamHeight = 50.0f;


typedef NS_ENUM(NSInteger, LySimulateLocalButtonTag) {
    simulateLocalButtonTag_examHistory = 10,
    simulateLocalButtonTag_startExam,
};


@interface LySimulateLocalViewController () <UITableViewDelegate, UITableViewDataSource, LyExamingLocalViewControllerDelegate, LyExamResultLocalViewControllerDelegate>
{
    UIView          *viewUser;
    UIImageView     *ivAvatar;
    UILabel         *lbName;
    UILabel         *lbExamHistory;
    
    UIButton        *btnExamHistory;
    
    UIButton        *btnStartExam;
    
    
    
    NSArray         *arrExamInfoItems;
    NSInteger       examCount;
    NSInteger       averScore;
}

@property (strong, nonatomic)       UITableView     *tableView;

@property (strong, nonatomic)       LyIndicator     *indicator;

@end

@implementation LySimulateLocalViewController

static NSString *const lySimulateLocalTableViewCellIdentifier = @"lySimulateLocalTableViewCellIdentifier";

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
    
    
    arrExamInfoItems = @[
                         @"考试科目",
                         @"考试题库",
                         @"考试标准",
                         @"合格标准"
                         ];
    
    
    viewUser = [[UIView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT + verticalSpace, SCREEN_WIDTH, slViewUserHeight)];
    
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f - slIvAvatarSize/2.0f, verticalSpace, slIvAvatarSize, slIvAvatarSize)];
    [ivAvatar.layer setCornerRadius:slIvAvatarSize/2.0f];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFit];
    [ivAvatar setClipsToBounds:YES];
    [ivAvatar setImage:[LyUtil defaultAvatarForStudent]];
    
    lbName = [[UILabel alloc] initWithFrame:CGRectMake(0, ivAvatar.frame.origin.y + slIvAvatarSize + verticalSpace, SCREEN_WIDTH, slLbNameHeight)];
    [lbName setFont:LyFont(18)];
    [lbName setTextColor:[UIColor blackColor]];
    [lbName setTextAlignment:NSTextAlignmentCenter];
    [lbName setNumberOfLines:0];
    [lbName setText:@"尊敬的517用户"];
    
    lbExamHistory = [[UILabel alloc] initWithFrame:CGRectMake(0, lbName.frame.origin.y + slLbNameHeight, SCREEN_WIDTH, slLbExamHistoryHeight)];
    [lbExamHistory setFont:LyFont(12)];
    [lbExamHistory setTextColor:[UIColor darkGrayColor]];
    [lbExamHistory setTextAlignment:NSTextAlignmentCenter];
    [lbExamHistory setText:@"你还没有考过试"];
    
    [viewUser addSubview:ivAvatar];
    [viewUser addSubview:lbName];
    [viewUser addSubview:lbExamHistory];
    
    
    btnExamHistory = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - slBtnExamHistoryWidth, self.tableView.frame.origin.y + CGRectGetHeight(self.tableView.frame) + verticalSpace, slBtnExamHistoryWidth, slBtnExamHistoryHeight)];
    [btnExamHistory setTag:simulateLocalButtonTag_examHistory];
    [btnExamHistory.titleLabel setFont:LyFont(14)];
    [btnExamHistory setTitle:@"考试记录" forState:UIControlStateNormal];
    [btnExamHistory setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnExamHistory addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    btnStartExam = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f- slBtnStartExamWidth/2.0f, SCREEN_HEIGHT - horizontalSpace * 2 - slBtnStartExamHeight, slBtnStartExamWidth, slBtnStartExamHeight)];
    [btnStartExam setTag:simulateLocalButtonTag_startExam];
    [btnStartExam setTitle:@"全真模似考试" forState:UIControlStateNormal];
    [btnStartExam setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnStartExam setBackgroundColor:Ly517ThemeColor];
    [btnStartExam.layer setCornerRadius:btnCornerRadius];
    [btnStartExam setClipsToBounds:YES];
    [btnStartExam addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:viewUser];
    [self.view addSubview:self.tableView];
    [self.view addSubview:btnExamHistory];
    [self.view addSubview:btnStartExam];
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat fWidth = SCREEN_WIDTH * 4 / 5.0f;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f - fWidth/2.0f, viewUser.frame.origin.y + slViewUserHeight, fWidth, simuCellHeight * arrExamInfoItems.count)
                                                  style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setScrollEnabled:NO];
        
        [_tableView registerClass:[LySimuLateStudyTableViewCell class] forCellReuseIdentifier:lySimulateLocalTableViewCellIdentifier];
        [LySimuLateStudyTableViewCell setCellWidth:fWidth];
    }
    
    return _tableView;
}

- (LyIndicator *)indicator {
    if (!_indicator) {
        _indicator = [LyIndicator indicatorWithTitle:nil];
    }
    
    return _indicator;
}

- (void)reloadData {
    if ([LyCurrentUser curUser].isLogined) {
        if ([LyCurrentUser curUser].userAvatar) {
            [ivAvatar setImage:[LyCurrentUser curUser].userAvatar];
            
        } else {
            [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:[LyCurrentUser curUser].userId]
                        placeholderImage:[LyUtil defaultAvatarForStudent]
                               completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                   if (image) {
                                       [[LyCurrentUser curUser] setUserAvatar:image];
                                   } else {
                                       [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:[LyCurrentUser curUser].userId]
                                                   placeholderImage:[LyUtil defaultAvatarForStudent]
                                                          completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                                              if (image) {
                                                                  [[LyCurrentUser curUser] setUserAvatar:image];
                                                              }
                                                          }];
                                   }
                               }];
        }
        [lbName setText:[LyCurrentUser curUser].userName];
        
    } else {
        [ivAvatar setImage:[LyUtil defaultAvatarForStudent]];
        [lbName setText:@"尊敬的517用户"];
    }
    
    
    NSString *sLbExamHistory = nil;
    if (examCount < 1) {
        sLbExamHistory = @"你还没有考过试";
    } else {
        sLbExamHistory = [[NSString alloc] initWithFormat:@"你共考过%ld次试，平均分为%ld分", examCount, averScore];
    }
    [lbExamHistory setText:sLbExamHistory];
    
    
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)targetForButton:(UIButton *)btn {
    LySimulateLocalButtonTag btnTag = btn.tag;
    switch (btnTag) {
        case simulateLocalButtonTag_examHistory: {
            LyExamHistoryLocalTableViewController *examHistory = [[LyExamHistoryLocalTableViewController alloc] init];
            [self.navigationController pushViewController:examHistory animated:YES];
            break;
        }
        case simulateLocalButtonTag_startExam: {
            [self startExam];
            break;
        }
    }
}

- (void)startExam {
    LyExamingLocalViewController *examing = [[LyExamingLocalViewController alloc] init];
    [examing setDelegate:self];
    UINavigationController *navExaming = [[UINavigationController alloc] initWithRootViewController:examing];
    [self presentViewController:navExaming animated:YES completion:nil];
}

- (void)load {
    [self.indicator startAnimation];
    
    [self performSelector:@selector(load_genuine) withObject:nil afterDelay:LyDelayTime];
}

- (void)load_genuine {
    NSString *sqlQue = [[NSString alloc] initWithFormat:@"SELECT count(id) AS count, avg(score) AS score FROM %@ WHERE userid = '%@' AND jtype = '%@'",
                        LyRecordTableName_examScore,
                        [LyCurrentUser curUser].userIdForTheory,
                        [[LyCurrentUser curUser] userLicenseTypeByString]
                        ];
    FMResultSet *rsQue = [[LyUtil dbRecord] executeQuery:sqlQue];
    while ([rsQue next]) {
        examCount = [rsQue intForColumn:@"count"];
        averScore = [rsQue intForColumn:@"score"];
        break;
    }
    
    [self reloadData];
    [self.indicator stopAnimation];
}


#pragma mark -LyExamingLocalViewControllerDelegate
- (void)onCommitByExamingLocalViewController:(LyExamingLocalViewController *)aExamingLocalVC arrQuestion:(NSArray *)arrQuestion useMinutes:(NSInteger)useMinutes
{
    [aExamingLocalVC dismissViewControllerAnimated:YES completion:^{
        LyExamResultLocalViewController *examResult = [[LyExamResultLocalViewController alloc] init];
        [examResult setArrQuestion:arrQuestion];
        [examResult setUseMinutes:useMinutes];
        [examResult setDelegate:self];
        [self.navigationController pushViewController:examResult animated:YES];
    }];
    
}

- (void)onCloseByExamingLocalViewController:(LyExamingLocalViewController *)aExamingLocalVC
{
    [aExamingLocalVC dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -LyExamResultLocalViewControllerDelegate
- (void)onReexamByExamResultLocalViewController:(LyExamResultLocalViewController *)aExamResultVC {
    [aExamResultVC.navigationController popToViewController:self animated:YES];
    
    [self performSelector:@selector(startExam) withObject:nil afterDelay:LyAnimationDuration];
}


#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return simuCellHeight;
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrExamInfoItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LySimuLateStudyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lySimulateLocalTableViewCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[LySimuLateStudyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lySimulateLocalTableViewCellIdentifier];
    }
    
    NSString *sTitle = arrExamInfoItems[indexPath.row];
    NSString *sDetail = nil;
    switch (indexPath.row) {
        case 0: {
            sDetail = [LyUtil subjectStringForm:[[LyCurrentUser curUser] userSubjectMode]];
            break;
        }
        case 1: {
            NSString *sProvince = nil;
            NSArray *arrAddress = [[LyCurrentUser curUser].userExamAddress componentsSeparatedByString:@" "];
            if ([LyUtil validateArray:arrAddress]) {
                sProvince = arrAddress[0];
            }
            
            if ([LyUtil validateString:sProvince]) {
                sDetail = [[NSString alloc] initWithFormat:@"%@ %@", sProvince, [LyCurrentUser curUser].userLicenseTypeByString];
            } else {
                sDetail = [LyCurrentUser curUser].userLicenseTypeByString;
            }
            break;
        }
        case 2: {
            sDetail = (LySubjectMode_first == [LyCurrentUser curUser].userSubjectMode) ? @"100题，45分钟" : @"50题，30分钟";
            break;
        }
        case 3: {
            sDetail = @"满分100分，90分及格";
            break;
        }
        default: {
            break;
        }
    }
    [cell setCellInfo:sTitle detail:sDetail];
    
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
