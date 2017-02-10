//
//  LyFriendsTableViewController.m
//  teacher
//
//  Created by Junes on 16/9/2.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyFriendsTableViewController.h"
#import "LyFriendsTableViewCell.h"
#import "LyTableViewFooterView.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyUserManager.h"

#import "LyPinyinGroup.h"
#import "NSMutableArray+SingleElement.h"

#import "LyUtil.h"
#import "student-Swift.h"

#import "LyUserDetailViewController.h"


enum {
    friendsBarButtonItemTag_add = 0
}LyFriendsBarButtonItemTag;

typedef NS_ENUM(NSInteger, LyFriendsAlertViewTag) {
    friendsAlertViewTag_deattente = 30,
};

typedef NS_ENUM(NSInteger, LyFriendsHttpMethod) {
    friendsHttpMethod_load = 100,
    friendsHttpMethod_loadMore,
    friendsHttpMethod_deattente,
};


@interface LyFriendsTableViewController () <LyTableViewFooterViewDelegate, LyHttpRequestDelegate, LyUserDetailDelegate>
{
    LyTableViewFooterView       *tvFooterView;
//    UIView                      *viewError;
//    UIView                      *viewNull;
    
    NSMutableArray              *arrFriends;
    NSMutableArray              *arrFriendsGroup;
    NSMutableArray              *arrFriendsItems;
    NSIndexPath                 *curIdx;
    
    LyIndicator                 *indicator;
    LyIndicator                 *indicator_oper;
    BOOL                        bHttpFlag;
    LyFriendsHttpMethod         curHttpMethod;
}
@end

@implementation LyFriendsTableViewController

static NSString *const lyFriendsTvCellReuseIdentifier = @"lyFriendsTvCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"我的关注";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    UIBarButtonItem *bbiAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(targetForBarButtonItem:)];
    [bbiAdd setTag:friendsBarButtonItemTag_add];
    [self.navigationItem setRightBarButtonItem:bbiAdd];
    
    [self.tableView registerClass:[LyFriendsTabelViewCell class] forCellReuseIdentifier:lyFriendsTvCellReuseIdentifier];
    tvFooterView = [LyTableViewFooterView tableViewFooterViewWithDelegate:self];
    [self.tableView setTableFooterView:tvFooterView];
    
    [self.tableView setSectionIndexColor:[UIColor blackColor]];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];
    
    self.refreshControl = [LyUtil refreshControlWithTitle:nil target:self action:@selector(refresh:)];
    
    arrFriends = [NSMutableArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    if (!arrFriends || arrFriends.count < 1) {
        [self load];
    } else {
        [self reloadData];
    }
}


- (void)reloadData {
//    [self removeViewError];
//    [self removeViewNull];
    
    [arrFriends singleElement];
    
    NSDictionary *dicFriends = [LyPinyinGroup group:arrFriends key:@"userName"];
    arrFriendsGroup = [NSMutableArray arrayWithArray:[dicFriends objectForKey:LyPinyinGroupNameKey]];
    arrFriendsItems = [NSMutableArray arrayWithArray:[dicFriends objectForKey:LyPinyinGroupResultKey]];
    
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    if (friendsBarButtonItemTag_add == bbi.tag) {
        LyScanQRCodeViewController *sweep = [[LyScanQRCodeViewController alloc] init];
        [self.navigationController pushViewController:sweep animated:YES];
    }
}


- (void)refresh:(UIRefreshControl *)rc {
    [self load];
}


- (void)load {
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(load) object:nil];
        return;
    }
    
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:nil];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:friendsHttpMethod_load];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:getMyAttention_url
                                 body:@{
                                       startKey:@(0),
                                       userIdKey:[LyCurrentUser curUser].userId,
                                       sessionIdKey:[LyUtil httpSessionId]
                                       }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
    
}

- (void)loadMore {
    
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(loadMore) object:nil];
        return;
    }
    
    [tvFooterView startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:friendsHttpMethod_loadMore];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:getMyAttention_url
                                 body:@{
                                        startKey:@(arrFriends.count),
                                        userIdKey:[LyCurrentUser curUser].userId,
                                        sessionIdKey:[LyUtil httpSessionId]
                                        }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}

- (void)deattente {
    if (!indicator_oper) {
        indicator_oper = [LyIndicator indicatorWithTitle:LyIndicatorTitle_deattente];
    } else {
        [indicator_oper setTitle:LyIndicatorTitle_deattente];
    }
    [indicator_oper startAnimation];
    
    LyUser *user = [[arrFriendsItems objectAtIndex:curIdx.section] objectAtIndex:curIdx.row];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:friendsHttpMethod_deattente];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:removeAttention_url
                                 body:@{
                                        userIdKey:[[LyCurrentUser curUser] userId],
                                        objectIdKey:user.userId,
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
    
    if ([indicator_oper isAnimating]) {
        [indicator_oper stopAnimation];
        
        if ([indicator_oper.title isEqualToString:LyIndicatorTitle_deattente]) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"取关失败"] show];
        }
    }
    
    if ([tvFooterView isAnimating]) {
        [tvFooterView stopAnimation];
    }
    
    [tvFooterView setStatus:LyTableViewFooterViewStatus_error];
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
        [indicator_oper stopAnimation];
        [self.refreshControl endRefreshing];
        
        [LyUtil sessionTimeOut:self];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        [indicator_oper stopAnimation];
        [self.refreshControl endRefreshing];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    
    switch (curHttpMethod) {
        case friendsHttpMethod_load: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (!arrResult || ![LyUtil validateArray:arrResult]) {
                        [indicator stopAnimation];
                        [self.refreshControl endRefreshing];
                        [tvFooterView stopAnimation];
                        [tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                        return;
                    }
                    
                    [arrFriends removeAllObjects];
                    
                    for (NSDictionary *dicItem in arrResult) {
                        if ( !dicItem  || ![LyUtil validateDictionary:dicItem])
                        {
                            continue;
                        }
                        
                        NSString *strId = [dicItem objectForKey:userIdKey];
                        NSString *strName = [dicItem objectForKey:nickNameKey];
                        NSString *strSignature = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:signatureKey]];
                        NSString *strSex = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:sexKey]];
                        NSString *strUserType = [dicItem objectForKey:userTypeKey];
                        
                        LyUser *tmpUser = [[LyUserManager sharedInstance] getUserWithUserId:strId];
                        if (!tmpUser) {
                            if ( [strUserType isEqualToString:@"jl"]) {
                                LyCoach *coach = [LyCoach coachWithId:strId
                                                              coaName:strName
                                                         coaSignature:strSignature
                                                               coaSex:[strSex integerValue]];
                                tmpUser = coach;
                            } else if ( [strUserType isEqualToString:@"jx"]) {
                                LyDriveSchool *dsch = [LyDriveSchool userWithId:strId
                                                                              userName:strName];
                                [dsch setUserSignature:strSignature];
                                
                                tmpUser = dsch;
                            } else if ( [strUserType isEqualToString:@"zdy"]) {
                                LyGuider *guider = [LyGuider userWithId:strId
                                                                        userName:strName];
                                [guider setUserSignature:strSignature];
                                [guider setUserSex:[strSex integerValue]];
                                
                                tmpUser = guider;
                            } else {
                                LyUser *user = [LyUser userWithId:strId
                                                         userName:strName];
                                [user setUserSignature:strSignature];
                                [user setUserSex:[strSex integerValue]];
                                
                                tmpUser = user;
                            }
                            
                            [[LyUserManager sharedInstance] addUser:tmpUser];
                        }
                        
                        [arrFriends addObject:tmpUser];
                    }
                    
                    [self reloadData];
                    
                    [indicator stopAnimation];
                    [self.refreshControl endRefreshing];
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
        case friendsHttpMethod_loadMore: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (!arrResult || ![LyUtil validateArray:arrResult]) {
                        [tvFooterView stopAnimation];
                        [tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                        return;
                    }
                    
                    for (NSDictionary *dicItem in arrResult) {
                        if ( !dicItem  || ![LyUtil validateDictionary:dicItem])
                        {
                            continue;
                        }
                        
                        NSString *strId = [dicItem objectForKey:userIdKey];
                        NSString *strName = [dicItem objectForKey:nickNameKey];
                        NSString *strSignature = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:signatureKey]];
                        NSString *strSex = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:sexKey]];
                        NSString *strUserType = [dicItem objectForKey:userTypeKey];
                        
                        LyUser *tmpUser = [[LyUserManager sharedInstance] getUserWithUserId:strId];
                        if (!tmpUser) {
                            if ( [strUserType isEqualToString:@"jl"]) {
                                LyCoach *coach = [LyCoach coachWithId:strId
                                                              coaName:strName
                                                         coaSignature:strSignature
                                                               coaSex:[strSex integerValue]];
                                tmpUser = coach;
                            } else if ( [strUserType isEqualToString:@"jx"]) {
                                LyDriveSchool *dsch = [LyDriveSchool userWithId:strId
                                                                              userName:strName];
                                [dsch setUserSignature:strSignature];
                                
                                tmpUser = dsch;
                            } else if ( [strUserType isEqualToString:@"zdy"]) {
                                LyGuider *guider = [LyGuider userWithId:strId
                                                                        userName:strName];
                                [guider setUserSignature:strSignature];
                                [guider setUserSex:[strSex integerValue]];
                                
                                tmpUser = guider;
                            } else {
                                LyUser *user = [LyUser userWithId:strId
                                                         userName:strName];
                                [user setUserSignature:strSignature];
                                [user setUserSex:[strSex integerValue]];
                                
                                tmpUser = user;
                            }
                            
                            [[LyUserManager sharedInstance] addUser:tmpUser];
//                            [arrFriends addObject:tmpUser];
                        }
                        
                        [arrFriends addObject:tmpUser];
                    }

                    [self reloadData];
                    
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
        case friendsHttpMethod_deattente: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSMutableArray *arrItems = [arrFriendsItems objectAtIndex:curIdx.section];
                    
                    [arrItems removeObjectAtIndex:curIdx.row];
                    
                    [self.tableView deleteRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationRight];
                    if (arrItems.count < 1)
                    {
                        [arrFriendsItems removeObjectAtIndex:curIdx.section];
                        [arrFriendsGroup removeObjectAtIndex:curIdx.section];
                        [self.tableView reloadData];
                    }
                    
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"取关成功"] show];
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


#pragma mark -LyUserDetailDelegate
- (NSString *)obtainUserId {
    
    LyUser *user = [[arrFriendsItems objectAtIndex:curIdx.section] objectAtIndex:curIdx.row];
    
    return user.userId;
}


#pragma mark -LyTableViewFooterView
- (void)loadMoreData:(LyTableViewFooterView *)tableViewFooterView {
    [self loadMore];
}



#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return fcellHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    curIdx = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    LyUserDetailViewController *userDetail = [[LyUserDetailViewController alloc] init];
    [userDetail setDelegate:self];
    [self.navigationController pushViewController:userDetail animated:YES];
}


- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return arrFriendsGroup;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle)
    {
//        [[maArrAttentionItems objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
//        
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        
        UITableViewRowAction *actionDeleteAttention = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"不再关注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            curIdx = indexPath;
            
            LyFriendsTabelViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"取消关注"
                                                                           message:[[NSString alloc] initWithFormat:@"你确定要取消关注「%@」吗？", cell.user.userName]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消关注"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        [self deattente];
                                                    }]];
            
        }];
        
        return @[actionDeleteAttention];
    }
    
    return nil;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return arrFriendsGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[arrFriendsItems objectAtIndex:section] count];
}

////生成每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LyFriendsTabelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyFriendsTvCellReuseIdentifier];
    
    if ( !cell) {
        cell = [[LyFriendsTabelViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyFriendsTvCellReuseIdentifier];
    }
    
    [cell setUser:[[arrFriendsItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    return cell;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [arrFriendsGroup objectAtIndex:section];
}



#pragma mrak -UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ( scrollView == self.tableView) {// && !decelerate) {
        if ([scrollView contentOffset].y + [scrollView frame].size.height + tvFooterViewDefaultHeight > [scrollView contentSize].height && scrollView.contentSize.height > CGRectGetHeight(scrollView.frame)) {
            [self loadMore];
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
