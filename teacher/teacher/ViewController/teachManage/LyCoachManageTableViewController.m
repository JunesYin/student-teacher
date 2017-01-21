//
//  LyCoachManageTableViewController.m
//  teacher
//
//  Created by Junes on 16/8/26.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyCoachManageTableViewController.h"
#import "LyCoachTableViewCell.h"

#import "LyTableViewFooterView.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyUserManager.h"

#import "LyUtil.h"



#import "LyAddCoachViewController.h"
#import "LyCoachDetailTableViewController.h"



typedef NS_ENUM(NSInteger, LyCoachManageBarButtonItemTag) {
    coachManageBarButtonItemTag_add = 0,
    coachManageBarButtonItemTag_delete,
};



typedef NS_ENUM(NSInteger, LyCoachManageHttpMethod) {
    coachManageHttpMethod_load = 100,
    coachManageHttpMethod_loadMore,
    coachManageHttpMethod_delete
};


@interface LyCoachManageTableViewController () <UIScrollViewDelegate, LyTableViewFooterViewDelegate, LyHttpRequestDelegate, LyCoachDetailTableViewControllerDelegate, LyAddCoachViewControllerDelegate, LyCoachDetailTableViewControllerDelegate>
{
    UIView                  *viewError;
    UIView                  *viewNull;
    LyTableViewFooterView   *tvFooterView;
    
    NSArray                 *arrCoaches;
    
    NSIndexPath             *curIdx;
    NSString                *curCoachId;
    
    LyIndicator             *indicator_oper;
    LyIndicator             *indicator;
    BOOL                    bHttpFlag;
    LyCoachManageHttpMethod curHttpMethod;
}
@end

@implementation LyCoachManageTableViewController

static NSString *const lyCoachManageTvCellReuseIdntifier = @"lyCoachManageTvCellReuseIdntifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"教练管理";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    UIBarButtonItem *bbiAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(targetFotBarButtonItem:)];
    [bbiAdd setTag:coachManageBarButtonItemTag_add];
//    UIBarButtonItem *bbiDelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
//                                                                               target:self
//                                                                               action:@selector(targetFotBarButtonItem:)];
//    [bbiDelete setTag:coachManageBarButtonItemTag_delete];
//    [self.navigationItem setRightBarButtonItems:@[bbiDelete, bbiAdd]];
    [self.navigationItem setRightBarButtonItem:bbiAdd];
    
    
    [self.tableView registerClass:[LyCoachTableViewCell class] forCellReuseIdentifier:lyCoachManageTvCellReuseIdntifier];
    self.refreshControl = [LyUtil refreshControlWithTitle:@"正在加载" target:self action:@selector(refresh:)];
    
    
    tvFooterView = [LyTableViewFooterView tableViewFooterViewWithDelegate:self];
    [self.tableView setTableFooterView:tvFooterView];
}




- (void)viewWillAppear:(BOOL)animated {
    if (!arrCoaches || arrCoaches.count < 1) {
        [self load];
    } else {
        [self reloadData];
    }
}



- (void)reloadData {
    [self removeViewError];
    
    [self.tableView reloadData];
}


- (void)showViewError {
    if (!viewError) {
        viewError = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_HEIGHT*1.2f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewError addSubview:[LyUtil lbErrorWithMode:0]];
    }
    
    [self.tableView addSubview:viewError];
    [self.tableView setContentSize:CGSizeMake(SCREEN_WIDTH,  SCREEN_HEIGHT*1.2f)];
}

- (void)removeViewError {
    [viewError removeFromSuperview];
    viewError = nil;
}


- (void)showViewNull {
    if (!viewNull) {
        viewNull = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.2f)];
        [viewNull setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewNull addSubview:[LyUtil lbNullWithText:@"还没有教练"]];
    }
    
    [self.tableView addSubview:viewNull];
    [self.tableView setContentSize:CGSizeMake(SCREEN_WIDTH,  SCREEN_HEIGHT*1.2f)];
}


- (void)removeViewNull {
    [viewNull removeFromSuperview];
    viewNull = nil;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)getCoachesFromUserManager {
    if (LyUserType_school == [LyCurrentUser curUser].userType) {
        arrCoaches = [[LyUserManager sharedInstance] getCoachWithDriveSchoolId:[LyCurrentUser curUser].userId];
    }
    else if (LyUserType_coach == [LyCurrentUser curUser].userType) {
        arrCoaches = [[LyUserManager sharedInstance] getCoachWithBossId:[LyCurrentUser curUser].userId];
    }
    
    arrCoaches = [arrCoaches sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [[LyUtil getPinyinFromHanzi:[obj1 userName]] compare:[LyUtil getPinyinFromHanzi:[obj2 userName]]];
    }];

}


- (void)targetFotBarButtonItem:(UIBarButtonItem *)bbi {
    if (coachManageBarButtonItemTag_add == bbi.tag) {
        LyAddCoachViewController *addCoach = [[LyAddCoachViewController alloc] init];
        [addCoach setDelegate:self];
        [self.navigationController pushViewController:addCoach animated:YES];
    }
    else if (coachManageBarButtonItemTag_delete == bbi.tag) {
        [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    }
}


- (void)refresh:(UIRefreshControl *)rc {
    [self load];
}


- (void)load {
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:LyIndicatorTitle_load];
    } else {
        [indicator setTitle:LyIndicatorTitle_load];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:coachManageHttpMethod_load];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:coachManage_url
                                 body:@{
                                       startKey:@(0),
                                       userIdKey:[LyCurrentUser curUser].userId,
                                       sessionIdKey:[LyUtil httpSessionId],
                                       userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                       }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}

- (void)loadMore {
    [tvFooterView startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:coachManageHttpMethod_loadMore];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:coachManage_url
                                 body:@{
                                        startKey:@(arrCoaches.count),
                                        userIdKey:[LyCurrentUser curUser].userId,
                                        sessionIdKey:[LyUtil httpSessionId],
                                        userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                        }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}



- (void)delete {
    if (!indicator_oper) {
        indicator_oper = [LyIndicator indicatorWithTitle:LyIndicatorTitle_delete];
    } else {
        [indicator_oper setTitle:LyIndicatorTitle_delete];
    }
    
    [indicator_oper startAnimation];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    LyCoach *coach = [arrCoaches objectAtIndex:curIdx.row];
    [dic setObject:coach.userId forKey:objectIdKey];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    
    if (LyUserType_school == [LyCurrentUser curUser].userType) {
        [dic setObject:masterIdKey forKey:masterKey];
    }
    else if (LyUserType_coach == [LyCurrentUser curUser].userType) {
        [dic setObject:bossKey forKey:masterKey];
    }
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:coachManageHttpMethod_delete];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:deleteCoach_url
                                 body:dic
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}



- (void)handleHttpFailed {
    if ([indicator isAnimating]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        [self showViewError];
        
        [tvFooterView setStatus:LyTableViewFooterViewStatus_error];
    }
    
    if ([indicator_oper isAnimating]) {
        [indicator_oper stopAnimation];
    
        if ([indicator_oper.title isEqualToString:LyIndicatorTitle_delete]) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"删除失败"] show];
        }
    }
    
    if (tvFooterView.isAnimating) {
        [tvFooterView stopAnimation];
        [tvFooterView setStatus:LyTableViewFooterViewStatus_error];
    }
    
}



- (void)analysisHttpResult:(NSString *)result {
    NSDictionary *dic = [LyUtil getObjFromJson:result];
    if (!dic || ![LyUtil validateDictionary:dic]) {
        [self handleHttpFailed];
        return;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (!strCode || ![LyUtil validateString:strCode]) {
        [self handleHttpFailed];
        return;
    }
    
    if (codeTimeOut == [strCode integerValue]) {
        [indicator stopAnimation];
        [tvFooterView stopAnimation];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        [indicator_oper stopAnimation];
        [self.refreshControl endRefreshing];
        [tvFooterView stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        [indicator_oper stopAnimation];
        [self.refreshControl endRefreshing];
        [tvFooterView stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    switch (curHttpMethod) {
        case coachManageHttpMethod_load: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (!arrResult || ![LyUtil validateArray:arrResult]) {
                        [indicator stopAnimation];
                        [self.refreshControl endRefreshing];
                        [tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                        return;
                    }
                    
                    for (NSDictionary *item in arrResult) {
                        if (!item || ![LyUtil validateDictionary:item]) {
                            continue;
                        }
                        
                        NSString *strId = [item objectForKey:userIdKey];
                        NSString *strName = [item objectForKey:nickNameKey];
                        NSString *strStuCount = [item objectForKey:studentCountKey];
                        NSString *strOrderCount = [item objectForKey:orderCountKey];
                        NSString *strTrainBaseName = [item objectForKey:trainBaseKey];
                        
                        LyCoach *coach = [[LyUserManager sharedInstance] getCoachWithCoachId:strId];
                        if (!coach || LyUserType_coach != coach.userType) {
                            coach = [LyCoach coachWithId:strId
                                                    name:strName];
                            
                            
                            [[LyUserManager sharedInstance] addUser:coach];
                        }
                        
                        if (LyUserType_school == [LyCurrentUser curUser].userType) {
                            [coach setMasterId:[LyCurrentUser curUser].userId];
                        } else if (LyUserType_coach == [LyCurrentUser curUser].userType) {
                            [coach setBossId:[LyCurrentUser curUser].userId];
                        }
                        
                        [coach setUserName:strName];
                        [coach setStuAllCount:[strStuCount intValue]];
                        [coach setAllOrderCount:[strOrderCount intValue]];
                        [coach setTrainBaseName:strTrainBaseName];
                        
                        
                    }
                    
                    [self getCoachesFromUserManager];
                    
                    [self reloadData];
                    
                    [tvFooterView setStatus:LyTableViewFooterViewStatus_normal];
                    [indicator stopAnimation];
                    [self.refreshControl endRefreshing];
                    
                    break;
                }
                default: {
                    break;
                }
            }
            break;
        }
        case coachManageHttpMethod_loadMore: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (!arrResult || ![LyUtil validateArray:arrResult]) {
                        [tvFooterView stopAnimation];
                        [tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                        return;
                    }
                    
                    for (NSDictionary *item in arrResult) {
                        if (!item || ![LyUtil validateDictionary:item])
                        {
                            continue;
                        }
                        
                        NSString *strId = [item objectForKey:userIdKey];
                        NSString *strName = [item objectForKey:nickNameKey];
                        NSString *strStuCount = [item objectForKey:studentCountKey];
                        NSString *strOrderCount = [item objectForKey:orderCountKey];
                        NSString *strTrainBaseName = [item objectForKey:trainBaseKey];
                        
                        LyCoach *coach = [[LyUserManager sharedInstance] getCoachWithCoachId:strId];
                        if (!coach || LyUserType_coach != coach.userType) {
                            coach = [LyCoach coachWithId:strId
                                                    name:strName];
                            
                            
                            [[LyUserManager sharedInstance] addUser:coach];
                        }
                        
                        if (LyUserType_school == [LyCurrentUser curUser].userType) {
                            [coach setMasterId:[LyCurrentUser curUser].userId];
                        } else if (LyUserType_coach == [LyCurrentUser curUser].userType) {
                            [coach setBossId:[LyCurrentUser curUser].userId];
                        }
                        
                        [coach setTeachingCount:[strStuCount intValue]];
                        [coach setMonthOrderCount:[strOrderCount intValue]];
                        [coach setTrainBaseName:strTrainBaseName];
                        
                    }
                    
                    [self getCoachesFromUserManager];
                    
                    [self reloadData];
                    
                    [indicator stopAnimation];
                    [tvFooterView stopAnimation];
                    [tvFooterView setStatus:LyTableViewFooterViewStatus_normal];
                    
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case coachManageHttpMethod_delete: {
            switch ([strCode integerValue]) {
                case 0: {
                    LyCoach *coach = [arrCoaches objectAtIndex:curIdx.row];
                    [[LyUserManager sharedInstance] removeUser:coach];
                    
                    [self getCoachesFromUserManager];
                    [self reloadData];
                    
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"删除成功"] show];
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


#pragma mark -LyHttpRequestDeleaget
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


#pragma mark -LyAddCoachViewControllerDelegate 
- (void)onDoneByAddCoachVC:(LyAddCoachViewController *)aAddCoachVC {
    [aAddCoachVC.navigationController popViewControllerAnimated:YES];
    
    [self getCoachesFromUserManager];
    [self reloadData];
}


#pragma mark -LyCoachDetailTableViewControllerDelegate
- (NSString *)obtainCoachIdByCoachDetailTVC:(LyCoachDetailTableViewController *)aCoachDetailTVC {
//    return [[arrCoaches objectAtIndex:curIdx.row] userId];
    return curCoachId;
}

- (void)onDeleteByCoachDetailTVC:(LyCoachDetailTableViewController *)aCoachDetailTVC {
    [aCoachDetailTVC.navigationController popViewControllerAnimated:YES];
    
    [self getCoachesFromUserManager];
    [self reloadData];
}


#pragma mark -LyTableViewFooterViewDelegate
- (void)loadMoreData:(LyTableViewFooterView *)tableViewFooterView {
    [self loadMore];
}


#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return coachtcellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    curIdx = indexPath;
    
    if ( LyUserType_coach == [LyCurrentUser curUser].userType) {
        if (0 == indexPath.row) {
            curCoachId = [LyCurrentUser curUser].userId;
        } else {
            curCoachId = [[arrCoaches objectAtIndex:indexPath.row - 1] userId];
        }
    } else {
        curCoachId = [[arrCoaches objectAtIndex:indexPath.row] userId];
    }
    
    LyCoachDetailTableViewController *coachDetail = [[LyCoachDetailTableViewController alloc] init];
    [coachDetail setDelegate:self];
    [self.navigationController pushViewController:coachDetail animated:YES];
}


//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (UITableViewCellEditingStyleDelete == editingStyle)
//    {
//        //        [[maArrAttentionItems objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
//        //
//        //        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
//    }
//}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {

//    curIdx = indexPath;
    
    if ( LyUserType_coach == [LyCurrentUser curUser].userType) {
        curIdx = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        
    } else {
        curIdx = indexPath;
    }
    
    UITableViewRowAction *actionDeleteAttention = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        
        NSString *strMessage = nil;
        if (curIdx.row < 0) {
            strMessage = @"你不能删除你自已";
        } else {
            strMessage = [[NSString alloc] initWithFormat:@"你确定要删除「%@」吗？", [[arrCoaches objectAtIndex:curIdx.row] userName]];
        }
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除"
                                                                       message:strMessage
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        
        if (curIdx.row < 0) {
            [alert addAction:[UIAlertAction actionWithTitle:@"好"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
        } else {
            [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"删除"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        [self delete];
                                                    }]];
        }
        
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
    
    return @[actionDeleteAttention];
    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger iCount = arrCoaches.count;
    
    if (LyUserType_coach == [LyCurrentUser curUser].userType) {
        iCount ++;
    }
    
    if (iCount < 1) {
        [self showViewNull];
    } else {
        [self removeViewNull];
    }
    
    return iCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyCoachTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyCoachManageTvCellReuseIdntifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[LyCoachTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyCoachManageTvCellReuseIdntifier];
    }
    
    LyCoach *coach = nil;
    if ( LyUserType_coach == [LyCurrentUser curUser].userType) {
        if (0 == indexPath.row) {
            coach = [[LyUserManager sharedInstance] getCoachWithCoachId:[LyCurrentUser curUser].userId];
        } else {
            coach = [arrCoaches objectAtIndex:indexPath.row - 1];
        }
    } else {
        coach = [arrCoaches objectAtIndex:indexPath.row];
    }
    
    [cell setCoach:coach mode:LyCoachTableViewCellMode_coachManage];
    
    return cell;
}


#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        if (scrollView.contentOffset.y > CGRectGetHeight(scrollView.frame)+scrollView.contentSize.height)
        {
            [self loadMoreData:tvFooterView];
        }
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
