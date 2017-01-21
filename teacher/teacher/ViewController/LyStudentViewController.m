//
//  LyStudentViewController.m
//  teacher
//
//  Created by Junes on 16/7/30.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyStudentViewController.h"
#import "LyStudentProgressView.h"
#import "LyStudentTableViewCell.h"
#import "LyTableViewFooterView.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyStudyProgressPicker.h"

#import "LyCurrentUser.h"
#import "LyStudentManager.h"

#import "UIViewController+RESideMenu.h"

#import "LyUtil.h"


#import "teacher-Swift.h"

#import "LyAddStudentTableViewController.h"
#import "LyStudentDetailViewController.h"

#import "LyStudentSearchTableViewController.h"


CGFloat const btnAddSize = 50.0f;


typedef NS_ENUM(NSInteger, LyStudentBarButtonItemTag)
{
    studentBarButtonItemTag_leftMenu = 10,
    studentBarButtonItemTag_search,
    studentBarButtonItemTag_msg,
    studentBarButtonItemTag_rightMenu
};

typedef NS_ENUM(NSInteger, LyStudentButtonMode)
{
    studentButtonMode_add = 20,
};


typedef NS_ENUM(NSInteger, LyStudentHttpMethod)
{
    studentHttpMethod_load = 100,
    studentHttpMethod_loadMore,
    
    studentHttpMethod_update
};


@interface LyStudentViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, LyStudentProgressViewDelegate, LyTableViewFooterViewDelegate, LyHttpRequestDelegate, LyAddStudentTableViewControllerDelegate, LyStudentDetailViewControllerDelegate, LyStudyProgressPickerDelegate, LyStudentTableViewCellDelegate>
{
    UIBarButtonItem                 *bbiLeftMenu;
//    UIBarButtonItem                 *bbiSearch;
    UIBarButtonItem                 *bbiMsg;
    UIBarButtonItem                 *bbiRightMenu;
    
    UISearchController              *search;
    
    LyStudentProgressView           *stuProgressView;
    
//    UIRefreshControl                *self.refreshControl;
//    UITableView                     *tvStudent;
//    LyTableViewFooterView           *tvFooter;
    
    UIButton                        *btnAdd;
    
    NSArray                         *arrStudents;
    LySubjectMode                   curSubjects;
    NSIndexPath                     *curIp;
    
    
    BOOL                            flagLoad;
    LyIndicator                     *indicator_modify;
    BOOL                            bHttpFlag;
    LyStudentHttpMethod             curHttpMethod;
}

@property (strong, nonatomic)   UIRefreshControl        *refreshControl;
@property (strong, nonatomic)   UITableView             *tableView;
@property (strong, nonatomic)   LyTableViewFooterView   *tvFooterView;

@end

@implementation LyStudentViewController

static NSString *const lyStudentTvStudentCellReuseIdentifier = @"lyStudentTvStudentCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}


- (void)viewDidAppear:(BOOL)animated
{
    [LyUtil ready:YES target:self];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    if (!flagLoad) {
        [self refresh:self.refreshControl];
    } else {
        arrStudents = [[LyStudentManager sharedInstance] getStudentWithStudyProgress:curSubjects];
        [self.tableView reloadData];
    }
        
}


- (void)initAndLayoutSubviews
{
    //navigationBar
    self.title = @"学员";
    self.view.backgroundColor = LyWhiteLightgrayColor;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    bbiLeftMenu = [LyUtil barButtonItem:studentBarButtonItemTag_leftMenu
                              imageName:@"navigationBar_left"
                                 target:self
                                 action:@selector(presentLeftMenuViewController:)];
    
    bbiMsg = [LyUtil barButtonItem:studentBarButtonItemTag_msg
                         imageName:@"navigationBar_msg"
                            target:self
                            action:@selector(targetForBarButtonItem:)];
    bbiRightMenu = [LyUtil barButtonItem:studentBarButtonItemTag_rightMenu
                               imageName:@"navigationBar_right"
                                  target:self
                                  action:@selector(presentRightMenuViewController:)];
    
    
    self.navigationItem.leftBarButtonItem = bbiLeftMenu;
    self.navigationItem.rightBarButtonItems = @[bbiRightMenu, bbiMsg];

    
    //tabbar
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"学员"
                                                    image:[LyUtil imageForImageName:@"student_n" needCache:NO]
                                            selectedImage:[LyUtil imageForImageName:@"student_h" needCache:NO]];
    
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    
    
    stuProgressView = [[LyStudentProgressView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, LyStudentProgressViewHeight)];
    [stuProgressView setDelegate:self];
    [self.view addSubview:stuProgressView];
    
    
    [self.view addSubview:self.tableView];
    
    
    btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-btnAddSize, SCREEN_HEIGHT*3/4.0f, btnAddSize, btnAddSize)];
    [btnAdd setTag:studentButtonMode_add];
    [btnAdd setImage:[LyUtil imageForImageName:@"student_btn_Add" needCache:NO] forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnAdd];
    
    curSubjects = 1;
}


- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [LyUtil refreshControlWithTitle:nil
                                                   target:self
                                                   action:@selector(refresh:)];
    }
    
    return _refreshControl;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT+LyStudentProgressViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-TABBAR_HEIGHT-LyStudentProgressViewHeight)
                                                 style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setRowHeight:stutcellHeight];
        [_tableView registerClass:[LyStudentTableViewCell class] forCellReuseIdentifier:lyStudentTvStudentCellReuseIdentifier];
        
        [_tableView addSubview:self.refreshControl];
        [_tableView setTableFooterView:self.tvFooterView];
    }
    
    return _tableView;
}

- (LyTableViewFooterView *)tvFooterView {
    if (!_tvFooterView) {
        _tvFooterView = [LyTableViewFooterView tableViewFooterViewWithDelegate:self];
    }
    
    return _tvFooterView;
}


- (void)reloadData {
    arrStudents = [[LyStudentManager sharedInstance] getStudentWithStudyProgress:curSubjects];
    
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)targetForButton:(UIButton *)button {
    if (studentButtonMode_add == button.tag) {
        LyAddStudentTableViewController *addStudent = [[LyAddStudentTableViewController alloc] init];
        [addStudent setDelegate:self];
        [addStudent setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:addStudent animated:YES];
    }
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    LyStudentBarButtonItemTag bbiTag = bbi.tag;
    switch (bbiTag) {
        case studentBarButtonItemTag_leftMenu: {
            //nothing
            break;
        }
        case studentBarButtonItemTag_search: {
            //nothing
            break;
        }
        case studentBarButtonItemTag_msg: {
            LyMsgCenterTableViewController *msgCenter = [[LyMsgCenterTableViewController alloc] init];
            msgCenter.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:msgCenter animated:YES];
            break;
        }
        case studentBarButtonItemTag_rightMenu: {
            //nothing
            break;
        }
    }
}


- (void)refresh:(UIRefreshControl *)refreshControl {
    [self load];
}


- (void)load {
    //getStudent_url
    [self.tvFooterView startAnimation];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:studentHttpMethod_load];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:getStudent_url
                                          body:@{
                                                startKey:@(0),
                                                subjectModeKey:@(curSubjects),
                                                userTypeKey:[[LyCurrentUser curUser] userTypeByString],
                                                masterIdKey:[LyCurrentUser curUser].userId,
                                                sessionIdKey:[LyUtil httpSessionId]
                                                }
                                          type:LyHttpType_asynPost
                                      timeOut:0] boolValue];
}


- (void)loadMoreData {
    [self.tvFooterView startAnimation];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:studentHttpMethod_loadMore];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:getStudent_url
                                          body:@{
                                                 startKey:@(arrStudents.count),
                                                 subjectModeKey:@(curSubjects),
                                                 userTypeKey:[[LyCurrentUser curUser] userTypeByString],
                                                 masterIdKey:[LyCurrentUser curUser].userId,
                                                 sessionIdKey:[LyUtil httpSessionId]
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}


- (void)updateStudent:(LySubjectMode)aStudyProgress {
    if (!indicator_modify) {
        indicator_modify = [LyIndicator indicatorWithTitle:LyIndicatorTitle_modify];
    }
    [indicator_modify startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:studentHttpMethod_update];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:modifyStudent_url
                                 body:@{
                                        keyKey:subjectModeKey,
                                        valueKey:@(aStudyProgress),
                                        objectIdKey:[[arrStudents objectAtIndex:curIp.row] userId],
                                        sessionIdKey:[LyUtil httpSessionId]
                                        }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}



- (void)handleHttpFailed {
    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }
    
    if ([self.tvFooterView isAnimating]) {
        [self.tvFooterView stopAnimation];
        
    }
    
    if ([indicator_modify isAnimating]) {
        [indicator_modify stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"修改失败"] show];
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
        [self.refreshControl endRefreshing];
        [self.tvFooterView stopAnimation];
        [indicator_modify stopAnimation];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [self.refreshControl endRefreshing];
        [self.tvFooterView stopAnimation];
        [indicator_modify stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    switch (curHttpMethod) {
        case studentHttpMethod_load: {
            curHttpMethod = 0;
            switch ([strCode integerValue]) {
                case 0: {
                    flagLoad = YES;
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateArray:arrResult]) {
                        if ([self.refreshControl isRefreshing]) {
                            [self.refreshControl endRefreshing];
                        }
                        if ([self.tvFooterView isAnimating]) {
                            [self.tvFooterView stopAnimation];
                        }
                        [self.tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                        return;
                    }
                    
                    for (NSDictionary *item in arrResult) {
                        if (![LyUtil validateDictionary:item]) {
                            continue;
                        }
                        
                        NSString *strUserId = [item objectForKey:userIdKey];
                        NSString *strName = [item objectForKey:trueNameKey];
                        NSString *strPhone = [item objectForKey:phoneKey];
                        NSString *strTeacherId = [item objectForKey:masterIdKey];
                        NSString *strCensus = [item objectForKey:addressKey];
                        NSString *strPickAddress = [item objectForKey:pickAddressKey];
                        NSString *strTrainClassName = [item objectForKey:trainClassNameKey];
                        NSString *strPayInfo = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:payInfoKey]];
                        NSString *strStudyProgress = [item objectForKey:subjectModeKey];
                        NSString *strRemark = [item objectForKey:noteKey];
                        
                        if (![LyUtil validateString:strUserId]) {
                            continue;
                        }
                        
                        LyStudent *student = [[LyStudentManager sharedInstance] getStudentWithId:strUserId];
                        if (!student) {
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
                            
                            [[LyStudentManager sharedInstance] addStudent:student];
                        }
                    }
                    
                    
                    
                    [self reloadData];
                    
                    if ([self.refreshControl isRefreshing]) {
                        [self.refreshControl endRefreshing];
                    }
                    if ([self.tvFooterView isAnimating]) {
                        [self.tvFooterView stopAnimation];
                    }
                    [self.tvFooterView setStatus:LyTableViewFooterViewStatus_normal];
                    
                    break;
                }
                case 1: {
                    [self handleHttpFailed];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case studentHttpMethod_loadMore: {
            curHttpMethod = 0;
            switch ([strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateArray:arrResult]) {
                        if ([self.refreshControl isRefreshing]) {
                            [self.refreshControl endRefreshing];
                        }
                        if ([self.tvFooterView isAnimating]) {
                            [self.tvFooterView stopAnimation];
                        }
                        [self.tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                        
                        return;
                    }
                    
                    for (NSDictionary *item in arrResult) {
                        if (![LyUtil validateDictionary:item]) {
                            continue;
                        }
                        
                        NSString *strUserId = [item objectForKey:userIdKey];
                        NSString *strName = [item objectForKey:trueNameKey];
                        NSString *strPhone = [item objectForKey:phoneKey];
                        NSString *strTeacherId = [item objectForKey:masterIdKey];
                        NSString *strCensus = [item objectForKey:addressKey];
                        NSString *strPickAddress = [item objectForKey:pickAddressKey];
                        NSString *strTrainClassName = [item objectForKey:trainClassNameKey];
                        NSString *strPayInfo = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:payInfoKey]];
                        NSString *strStudyProgress = [item objectForKey:subjectModeKey];
                        NSString *strRemark = [item objectForKey:noteKey];
                        
                        if (![LyUtil validateString:strUserId]) {
                            continue;
                        }
                        
                        LyStudent *student = [[LyStudentManager sharedInstance] getStudentWithId:strUserId];
                        if (!student) {
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
                            
                            [[LyStudentManager sharedInstance] addStudent:student];
                        }
                        
                    }
                    
                    [self reloadData];
                    
                    if ([self.refreshControl isRefreshing])
                    {
                        [self.refreshControl endRefreshing];
                    }
                    if ([self.tvFooterView isAnimating])
                    {
                        [self.tvFooterView stopAnimation];
                    }
                    
                    [self.tvFooterView setStatus:LyTableViewFooterViewStatus_normal];
                    
                    break;
                }
                case 1: {
                    [self handleHttpFailed];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case studentHttpMethod_update: {
            curHttpMethod = 0;
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [indicator_modify stopAnimation];
                        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"修改失败"] show];
                        return;
                    }
                    
                    NSString *strStudyProgress = [dicResult objectForKey:subjectModeKey];
                    LyStudent *student = [arrStudents objectAtIndex:curIp.row];
                    [student setStuStudyProgress:[strStudyProgress integerValue]];
                    
                    
                    
                    [self reloadData];
                    
                    [indicator_modify stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"修改成功"] show];
                    
                    break;
                }
                case 1: {
                    [self handleHttpFailed];
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



#pragma mark LyHttpReqeustDelegate
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


#pragma mark -LyStudyProgressPickerDelegate
- (void)onCancelByStudyProgressPicker:(LyStudyProgressPicker *)aStudyProgressPicker {
    [aStudyProgressPicker hide];
}

- (void)onDoneByStudyProgressPicker:(LyStudyProgressPicker *)aStudyProgressPicker studyProgress:(LySubjectMode)aStudyProgress {
    [aStudyProgressPicker hide];
    
    if (aStudyProgress != [[arrStudents objectAtIndex:curIp.row] stuStudyProgress]) {
        [self updateStudent:aStudyProgress];
    }
}


#pragma mark -LyAddStudentTableViewControllerDelegate
- (void)onAddDoneByAddStudentTVC:(LyAddStudentTableViewController *)aAddStudentTVC {
    [aAddStudentTVC.navigationController popToRootViewControllerAnimated:YES];
    
    [self reloadData];
}


#pragma mark -LyStudentDetailViewControllerDelegate
- (NSString *)obtainStudentIdByStudentDetailVC:(LyStudentDetailViewController *)aStudentDetailVC
{
    return [[arrStudents objectAtIndex:curIp.row] userId];
}

- (void)onDeleteByStudentDetailVC:(LyStudentDetailViewController *)aStudentDetailVC
{
    [aStudentDetailVC.navigationController popViewControllerAnimated:YES];
    
    arrStudents = [[LyStudentManager sharedInstance] getStudentWithStudyProgress:curSubjects];
    
    [self  reloadData];
}


#pragma mark -LyStudentTableViewCellDelegate
- (void)onClickBttonProgressByStudentTableViewCell:(LyStudentTableViewCell *)aCell
{
    curIp = [self.tableView indexPathForCell:aCell];
    
    LyStudyProgressPicker *spp = [[LyStudyProgressPicker alloc] init];
    [spp setDelegate:self];
    [spp setCurIndex:aCell.student.stuStudyProgress];
    
    [spp show];
}



#pragma mark -LyTableViewFooterViewDelegate
- (void)loadMoreData:(LyTableViewFooterView *)tableViewFooterView
{
    [self loadMoreData];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    curIp = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    LyStudentDetailViewController *stuentDetail = [[LyStudentDetailViewController alloc] init];
    [stuentDetail setDelegate:self];
    [stuentDetail setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:stuentDetail animated:YES];
}


#pragma mark -UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    LyStudentSearchTableViewController *sstvc = [[LyStudentSearchTableViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sstvc];
//    [self presentViewController:nav animated:NO completion:^{
//        ;
//    }];
    [self.navigationController pushViewController:sstvc animated:YES];
    
    return NO;
}



#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return arrStudents.count;
    }

    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyStudentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyStudentTvStudentCellReuseIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[LyStudentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyStudentTvStudentCellReuseIdentifier];
    }
    
    if (tableView == self.tableView) {
        [cell setStudent:[arrStudents objectAtIndex:indexPath.row]];
        [cell setMode:LyStudentTableViewCellMode_home];
        [cell setDelegate:self];
    }
    
    
    return cell;
}


#pragma mrak -UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ( scrollView == self.tableView && [scrollView contentOffset].y + [scrollView frame].size.height > [scrollView contentSize].height + tvFooterViewDefaultHeight && scrollView.contentSize.height > scrollView.frame.size.height) {
        [self loadMoreData];
    }
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
