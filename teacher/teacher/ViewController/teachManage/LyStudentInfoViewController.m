//
//  LyStudentInfoViewController.m
//  teacher
//
//  Created by Junes on 2016/11/11.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyStudentInfoViewController.h"
#import "LyStudentProgressView.h"
#import "LyStudentTableViewCell.h"
#import "LyTableViewFooterView.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyStudentManager.h"

#import "LyUtil.h"


typedef NS_ENUM(NSInteger, LyStudentInfoHttpMethod) {
    studentInfoHttpMethod_load = 100,
    studentInfoHttpMethod_loadMore,
};


@interface LyStudentInfoViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, LyStudentProgressViewDelegate, LyStudentTableViewCellDelegate, LyTableViewFooterViewDelegate, LyHttpRequestDelegate>
{
    NSMutableDictionary         *dicStudents;
    
    NSMutableArray              *arrStudents;
    
    LySubjectMode               curSubjects;
    
    NSIndexPath                 *curIdx;
    
    LyIndicator                 *indicator;
    BOOL                        bHttpFlag;
    LyStudentInfoHttpMethod     curHttpMethod;
}

@property (strong, nonatomic)       LyStudentProgressView       *progressView;
@property (strong, nonatomic)       UITableView                 *tableView;
@property (strong, nonatomic)       UIRefreshControl            *refreshControl;
@property (strong, nonatomic)       LyTableViewFooterView       *tvFooterView;

@end

@implementation LyStudentInfoViewController

static NSString *const lySutdentInfoTvCellReuseIdentifier = @"lySutdentInfoTvCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}


- (void)viewWillAppear:(BOOL)animated {
    if (!_coachId) {
        _coachId = [_delegate obtainCoachIdByStudentInfoVC:self];
        
        if (!_coachId) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    if (!dicStudents || dicStudents.count < 1) {
        [self load];
    }
}


- (void)initAndLayoutSubviews {
    self.title = @"学员信息";
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.tableView];
    
    curSubjects = LySubjectMode_first;
    
    dicStudents = [[NSMutableDictionary alloc] initWithCapacity:1];
    arrStudents = [[NSMutableArray alloc] initWithCapacity:1];
    
}

- (LyStudentProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[LyStudentProgressView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, LyStudentProgressViewHeight)];
        [_progressView setDelegate:self];
    }
    
    return _progressView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.progressView.ly_y + CGRectGetHeight(self.progressView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - self.progressView.ly_y - CGRectGetHeight(self.progressView.frame))
                                                  style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView registerClass:[LyStudentTableViewCell class] forCellReuseIdentifier:lySutdentInfoTvCellReuseIdentifier];
        
        [_tableView addSubview:self.refreshControl];
        [_tableView setTableFooterView:self.tvFooterView];
    }
    
    
    return _tableView;
}

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [LyUtil refreshControlWithTitle:nil
                                                   target:self
                                                   action:@selector(refresh:)];
    }
    
    return _refreshControl;
}

- (LyTableViewFooterView *)tvFooterView {
    if (!_tvFooterView) {
        _tvFooterView = [LyTableViewFooterView tableViewFooterViewWithDelegate:self];
    }
    
    return _tvFooterView;
}

- (void)reloadData {
    [arrStudents removeAllObjects];
    
    for (LyStudent *student in [dicStudents allValues]) {
        if (curSubjects == student.stuStudyProgress) {
            [arrStudents addObject:student];
        }
    }
    
    [arrStudents sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [[LyUtil getPinyinFromHanzi:[obj1 userName]] compare:[LyUtil getPinyinFromHanzi:[obj2 userName]]];
    }];
    
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh:(UIRefreshControl *)rc {
    [self load];
}


- (void)load {
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:nil];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:studentInfoHttpMethod_load];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:getStudent_url
                                 body:@{
                                        startKey:@(0),
                                        subjectModeKey:@(curSubjects),
                                        userTypeKey:userTypeCoachKey,
                                        masterIdKey:_coachId,
                                        sessionIdKey:[LyUtil httpSessionId]
                                        }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)loadMore {
    [self.tvFooterView startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:studentInfoHttpMethod_load];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:getStudent_url
                                 body:@{
                                        startKey:@(arrStudents.count),
                                        subjectModeKey:@(curSubjects),
                                        userTypeKey:userTypeCoachKey,
                                        masterIdKey:_coachId,
                                        sessionIdKey:[LyUtil httpSessionId]
                                        }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
    
}


- (void)handleHttpFailed {
    if ([indicator isAnimating]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
    }
    
    if ([self.tvFooterView isAnimating]) {
        [self.tvFooterView stopAnimation];
    }
    
    [self.tvFooterView setStatus:LyTableViewFooterViewStatus_error];
}


- (void)analysisHttpResult:(NSString *)result {
    
    NSDictionary *dic = [LyUtil getObjFromJson:result];
    if (![LyUtil validateDictionary:dic]) {
        [self handleHttpFailed];
        return;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (![LyUtil validateString:strCode]) {
        [self handleHttpFailed];
        return;
    }
    
    if (codeTimeOut == [strCode integerValue]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        [self.tvFooterView stopAnimation];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        [self.tvFooterView stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch (curHttpMethod) {
        case studentInfoHttpMethod_load: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateArray:arrResult]) {
                        [indicator stopAnimation];
                        [self.refreshControl endRefreshing];
                        [self.tvFooterView stopAnimation];
                        [self.tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                        return;
                    }
                    
                    for (NSDictionary *dicItem in arrResult) {
                        if (![LyUtil validateDictionary:dicItem]) {
                            continue;
                        }
                        
                        NSString *strUserId = [dicItem objectForKey:userIdKey];
                        NSString *strName = [dicItem objectForKey:trueNameKey];
                        NSString *strPhone = [dicItem objectForKey:phoneKey];
                        NSString *strTeacherId = [dicItem objectForKey:masterIdKey];
                        NSString *strCensus = [dicItem objectForKey:addressKey];
                        NSString *strPickAddress = [dicItem objectForKey:pickAddressKey];
                        NSString *strTrainClassName = [dicItem objectForKey:trainClassNameKey];
                        NSString *strPayInfo = [NSString stringWithFormat:@"%@", [dicItem objectForKey:payInfoKey]];
                        NSString *strStudyProgress = [dicItem objectForKey:subjectModeKey];
                        NSString *strRemark = [dicItem objectForKey:noteKey];
                        
                        if (![LyUtil validateString:strUserId]) {
                            continue;
                        }
                        
                        LyStudent *student = [dicStudents objectForKey:strUserId];
                        if (!student)
                        {
                            student = [LyStudent studentWithId:strUserId
                                                       stuName:strName
                                                   stuPhoneNum:strPhone
                                                  stuTeacherId:strTeacherId
                                                     stuCensus:strCensus
                                                stuPickAddress:strPickAddress
                                             stuTrainClassName:strTrainClassName
                                                    stuPayInfo:[strPayInfo integerValue]
                                              stuStudyProgress:[strStudyProgress integerValue]
                                                       stuNote:strRemark];
                            
                            [dicStudents setObject:student forKey:strUserId];
                        }
                    }
                    
                    [self reloadData];
                    
                    [indicator stopAnimation];
                    [self.refreshControl endRefreshing];
                    [self.tvFooterView setStatus:LyTableViewFooterViewStatus_normal];
                    
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case studentInfoHttpMethod_loadMore: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateArray:arrResult]) {
                        [self.tvFooterView stopAnimation];
                        [self.tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                        return;
                    }
                    
                    for (NSDictionary *dicItem in arrResult) {
                        if (![LyUtil validateDictionary:dicItem]) {
                            continue;
                        }
                        
                        NSString *strUserId = [dicItem objectForKey:userIdKey];
                        NSString *strName = [dicItem objectForKey:trueNameKey];
                        NSString *strPhone = [dicItem objectForKey:phoneKey];
                        NSString *strTeacherId = [dicItem objectForKey:masterIdKey];
                        NSString *strCensus = [dicItem objectForKey:addressKey];
                        NSString *strPickAddress = [dicItem objectForKey:pickAddressKey];
                        NSString *strTrainClassName = [dicItem objectForKey:trainClassNameKey];
                        NSString *strPayInfo = [NSString stringWithFormat:@"%@", [dicItem objectForKey:payInfoKey]];
                        NSString *strStudyProgress = [dicItem objectForKey:subjectModeKey];
                        NSString *strRemark = [dicItem objectForKey:noteKey];
                        
                        if (![LyUtil validateString:strUserId]) {
                            continue;
                        }
                        
                        LyStudent *student = [dicStudents objectForKey:strUserId];
                        if (!student)
                        {
                            student = [LyStudent studentWithId:strUserId
                                                       stuName:strName
                                                   stuPhoneNum:strPhone
                                                  stuTeacherId:strTeacherId
                                                     stuCensus:strCensus
                                                stuPickAddress:strPickAddress
                                             stuTrainClassName:strTrainClassName
                                                    stuPayInfo:[strPayInfo integerValue]
                                              stuStudyProgress:[strStudyProgress integerValue]
                                                       stuNote:strRemark];
                            
                            [dicStudents setObject:student forKey:strUserId];
                        }
                    }
                    
                    [self reloadData];
                    
                    [self.tvFooterView stopAnimation];
                    [self.tvFooterView setStatus:LyTableViewFooterViewStatus_normal];
                    
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        default: {
            [self handleHttpFailed];
            break;
        }
    }
}


#pragma mark -LyHttpRequestDelegate
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest {
    if (bHttpFlag) {
        bHttpFlag = NO;
        [self handleHttpFailed];
    }
    
    curHttpMethod = 0;
}

- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result {
    if (bHttpFlag) {
        bHttpFlag = NO;
        curHttpMethod = ahttpRequest.mode;
        [self analysisHttpResult:result];
    }
    
    curHttpMethod = 0;
}

#pragma mark -LyTableViewFooterViewDelegate
- (void)loadMoreData:(LyTableViewFooterView *)tableViewFooterView {
    [self loadMore];
}


#pragma mark -LyStudentProgressViewDelegate
- (void)studentProgressView:(LyStudentProgressView *)aStudentProgressView didSelectedItemAtIndex:(LySubjectMode)index {
    curSubjects = index;
    
    [self reloadData];
    
    if (!arrStudents || arrStudents.count < 1) {
        [self load];
    }
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return stutcellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    curIdx = indexPath;
    
    
}


#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrStudents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LyStudentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lySutdentInfoTvCellReuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[LyStudentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lySutdentInfoTvCellReuseIdentifier];
    }
    
    [cell setStudent:[arrStudents objectAtIndex:indexPath.row]];
    [cell setMode:LyStudentTableViewCellMode_studentInfo];
    
    return cell;
}



#pragma mrak -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ( scrollView == self.tableView && [scrollView contentOffset].y + [scrollView frame].size.height > [scrollView contentSize].height + tvFooterViewDefaultHeight && scrollView.contentSize.height > scrollView.frame.size.height) {
        [self loadMore];
    }
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
