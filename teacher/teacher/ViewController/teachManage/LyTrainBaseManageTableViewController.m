//
//  LyTrainBaseManageTableViewController.m
//  teacher
//
//  Created by Junes on 16/8/12.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyTrainBaseManageTableViewController.h"
#import "LyTrainBaseTableViewCell.h"
#import "LyTableViewFooterView.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyTrainBase.h"
#import "LyCurrentUser.h"

#import "NSMutableArray+SingleElement.h"

#import "LyUtil.h"


#import "LyAddTrainBaseTableViewController.h"
#import "LyTrainBaseDetailTableViewController.h"



enum {
    trainBaseManageBarButtonItemTag_add = 0
}LyTrainBaseManageBarButtonItemTag;


typedef NS_ENUM(NSInteger, LyTrainBaseManageHttpMethod)
{
    trainBaseManageHttpMethod_load = 100,
    trainBaseManageHttpMethod_delete
};


@interface LyTrainBaseManageTableViewController () <LyTrainBaseTableViewCellDelegate, LyAddTrainBaseTableViewControllerDelegate, LyHttpRequestDelegate, LyTrainBaseDetailTableViewControllerDelegate>
{
    UIView                          *viewError;
    UIView                          *viewNull;
    
    NSMutableArray                  *arrTrainBase;
    NSIndexPath                     *curIdx;
    
    LyIndicator                     *indicator_oper;
    LyIndicator                     *indicator;
    BOOL                            bHttpFlag;
    LyTrainBaseManageHttpMethod     curHttpMethod;
}
@end

@implementation LyTrainBaseManageTableViewController

static NSString *const lyTrainBaseManageTableVeiwCellIdentifier = @"lyTrainBaseManageTableVeiwCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.title = @"基地管理";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    UIBarButtonItem *bbiAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(targetForBarButtonItem:)];
    [bbiAdd setTag:trainBaseManageBarButtonItemTag_add];
    [self.navigationItem setRightBarButtonItem:bbiAdd];
    
    arrTrainBase = [NSMutableArray array];
    
    
    [self.tableView registerClass:[LyTrainBaseTableViewCell class] forCellReuseIdentifier:lyTrainBaseManageTableVeiwCellIdentifier];
    [self.tableView setTableFooterView:[UIView new]];
    self.refreshControl = [LyUtil refreshControlWithTitle:@"正在加载" target:self action:@selector(refresh:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!arrTrainBase || arrTrainBase.count < 1) {
        [self load];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)reloadData {
    [self removeViewError];
    [self removeViewNull];
    
    [arrTrainBase singleElementByKey:@"tbId"];
    [arrTrainBase sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [[LyUtil getPinyinFromHanzi:[obj1 tbName]] compare:[LyUtil getPinyinFromHanzi:[obj2 tbName]]];
    }];
    
    [self.tableView reloadData];
}


- (void)showViewError {
    if (!viewError) {
        viewError = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.2f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewError addSubview:[LyUtil lbErrorWithMode:0]];
    }
    
    [self.tableView addSubview:viewError];
    [self.tableView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.05f)];
}

- (void)removeViewError {
    [viewError removeFromSuperview];
    viewError = nil;
}


- (void)showViewNull {
    if (!viewNull) {
        viewNull = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.2f)];
        [viewNull setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewNull addSubview:[LyUtil lbNullWithText:@"还没有基地"]];

    }
    
    [self.tableView addSubview:viewNull];
    [self.tableView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.05f)];
}


- (void)removeViewNull {
    [viewNull removeFromSuperview];
    viewNull = nil;
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    if (trainBaseManageBarButtonItemTag_add == bbi.tag) {
        LyAddTrainBaseTableViewController *addTrainBase = [[LyAddTrainBaseTableViewController alloc] init];
        [addTrainBase setDelegate:self];
        [self.navigationController pushViewController:addTrainBase animated:YES];
    }
}



- (void)refresh:(UIRefreshControl *)rc {
    [self load];
}


- (void)load {
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:@"正在加载"];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:trainBaseManageHttpMethod_load];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:trainBaseManage_url
                                 body:@{
                                       userTypeKey:[[LyCurrentUser curUser] userTypeByString],
                                       userIdKey:[LyCurrentUser curUser].userId,
                                       sessionIdKey:[LyUtil httpSessionId]
                                       }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}



- (void)delete {
    if (!indicator_oper) {
        indicator_oper = [LyIndicator indicatorWithTitle:LyIndicatorTitle_delete];
    }
    else {
        [indicator_oper setTitle:LyIndicatorTitle_delete];
    }
    
    [indicator_oper startAnimation];
    
    LyTrainBase *tbWillDel = arrTrainBase[curIdx.row];
    
    NSMutableString *strTrainBase = [[NSMutableString alloc] initWithString:@""];
    for (LyTrainBase *trainBase in arrTrainBase) {
        if (!trainBase || ![LyUtil validateString:trainBase.tbId] || [trainBase.tbId isEqualToString:tbWillDel.tbId]) {
            continue;
        }

        [strTrainBase appendFormat:@"%@,", trainBase.tbId];
    }
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:trainBaseManageHttpMethod_delete];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:operateTrainBase_url
                                 body:@{
                                       trainBaseIdKey:strTrainBase,
                                       userTypeKey:[[LyCurrentUser curUser] userTypeByString],
                                       userIdKey:[LyCurrentUser curUser].userId,
                                       sessionIdKey:[LyUtil httpSessionId]
                                       }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)handleHttpFailed {
    if ([indicator isAnimating]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        [self showViewError];
    }
    
    if ([indicator_oper isAnimating]) {
        [indicator_oper stopAnimation];
        if ([indicator_oper.title isEqualToString:LyIndicatorTitle_delete]) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"删除失败"] show];
        }
    }
}

- (void)analysisHttpResult:(NSString *)result
{
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
        [self.refreshControl endRefreshing];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch (curHttpMethod) {
        case trainBaseManageHttpMethod_load: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (!arrResult || ![LyUtil validateArray:arrResult])
                    {
                        [indicator stopAnimation];
                        [self.refreshControl endRefreshing];
                        [self showViewNull];
                        return;
                    }
                    
                    for (NSDictionary *item in arrResult) {
                        if (!item || ![LyUtil validateDictionary:item])
                        {
                            continue;
                        }
                        
                        NSString *strId = [item objectForKey:idKey];
                        NSString *strName = [item objectForKey:trainBaseNameKey];
                        NSString *strAddress = [item objectForKey:addressKey];
                        NSString *strCoachCount = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:coachCountKey]];
                        NSString *strStudendCount = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:studentCountKey]];
                        
                        LyTrainBase *trainBase = [LyTrainBase trainBaseWithTbId:strId
                                                                         tbName:strName
                                                                      tbAddress:strAddress
                                                                   tbCoachCount:[strCoachCount intValue]
                                                                 tbStudentCount:[strStudendCount intValue]];
                        
                        [arrTrainBase addObject:trainBase];
                    }
                    
                    
                    
                    [self reloadData];
                    
                    [indicator stopAnimation];
                    [self.refreshControl endRefreshing];
                    
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case trainBaseManageHttpMethod_delete: {
            switch ([strCode integerValue]) {
                case 0: {
                    
                    [arrTrainBase removeObjectAtIndex:curIdx.row];
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



#pragma mark -LyHttpRequestDelegate
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest {
    if (bHttpFlag) {
        bHttpFlag = NO;
        
        [self handleHttpFailed];
    }
    curHttpMethod = 0;
}

- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result
{
    if (bHttpFlag) {
        bHttpFlag = NO;
        
        curHttpMethod = ahttpRequest.mode;
        [self analysisHttpResult:result];
    }
    
    curHttpMethod = 0;
}


#pragma mark -LyTrainBaseDetailTableViewControllerDelegate
- (NSDictionary *)trainBaseInfoByTrainBaseDetailTVC:(LyTrainBaseDetailTableViewController *)aTrainBaseDetailTVC {
    return @{
             trainBaseKey : arrTrainBase[curIdx.row],
             @"trainBase" : arrTrainBase
             };
}

- (void)onDeleteByTrainBaseDetailTVC:(LyTrainBaseDetailTableViewController *)aTrainBaseDetailTVC {
    [aTrainBaseDetailTVC.navigationController popViewControllerAnimated:YES];
    
    [arrTrainBase removeObjectAtIndex:curIdx.row];
    [self reloadData];
}



#pragma mark -LyAddTrainBaseTableViewControllerDelegate
- (NSArray *)trainBaseInfoByAddTrainBaseTVC:(LyAddTrainBaseTableViewController *)aAddTrainBaseTVC {
    return arrTrainBase;
}

- (void)onDoneByAddTrainBaseTVC:(LyAddTrainBaseTableViewController *)aAddTrainBaseVC trainBase:(LyTrainBase *)aTrainBase {
    [aAddTrainBaseVC.navigationController popViewControllerAnimated:YES];
    
    [arrTrainBase addObject:aTrainBase];
    
    [arrTrainBase singleElementByKey:@"tbId"];
    [self reloadData];
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tbcellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    curIdx = indexPath;
    
    LyTrainBaseDetailTableViewController *trainBaseDetail = [[LyTrainBaseDetailTableViewController alloc] init];
    [trainBaseDetail setDelegate:self];
    [self.navigationController pushViewController:trainBaseDetail animated:YES];
}


- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
        UITableViewRowAction *raDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                            title:@"删除"
                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                              curIdx = indexPath;
                                                                              
                                                                              UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除基地"
                                                                                                                                             message:[[NSString alloc] initWithFormat:@"确定删除「%@」吗？", [[arrTrainBase objectAtIndex:curIdx.row] tbName]]
                                                                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                                                              [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                                                                                        style:UIAlertActionStyleCancel
                                                                                                                      handler:nil]];
                                                                              [alert addAction:[UIAlertAction actionWithTitle:@"删除基地"
                                                                                                                        style:UIAlertActionStyleDestructive
                                                                                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                                                                                          [self delete];
                                                                                                                      }]];
                                                                              [self presentViewController:alert animated:YES completion:nil];
                                                                          }];
        
        return @[raDelete];
    }
    
    return nil;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (arrTrainBase.count < 1) {
        [self showViewNull];
    }
    else {
        [self removeViewNull];
    }
    return arrTrainBase.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyTrainBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyTrainBaseManageTableVeiwCellIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[LyTrainBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyTrainBaseManageTableVeiwCellIdentifier];
        [cell setDelegate:self];
    }
    [cell setTrainBase:[arrTrainBase objectAtIndex:indexPath.row]];
    
    return cell;
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.tableView)
//    {
//        if (scrollView.contentOffset.y > CGRectGetHeight(scrollView.frame)+scrollView.contentSize.height)
//        {
//            [self loadMoreData:tvFooterView];
//        }
//    }
//}

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
