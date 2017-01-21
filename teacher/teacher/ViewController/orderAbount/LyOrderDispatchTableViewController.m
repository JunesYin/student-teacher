//
//  LyOrderDispatchTableViewController.m
//  teacher
//
//  Created by Junes on 16/9/10.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyOrderDispatchTableViewController.h"
#import "LyChooseTableViewCell.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyTrainBase.h"
#import "LyCoach.h"

#import "LyUtil.h"


#import "LyChooseTrainBaseTableViewController.h"
#import "LyChooseCoachTableViewController.h"

enum {
    orderDispatchBarButtonItemTag_dispatch = 0,
}LyOrderDispatchBarButtonItemTag;


typedef NS_ENUM(NSInteger, LyOrderDispatchHttpMethod) {
    orderDispatchHttpMethod_dispatch = 100,
};




@interface LyOrderDispatchTableViewController () <LyChooseTrainBaseTableViewControllerDelegate, LyChooseCoachTableViewControllerDelegate, LyRemindViewDelegate, LyHttpRequestDelegate>
{
    UIBarButtonItem         *bbiDispatch;
    
    LyTrainBase             *curTrainBase;
    LyCoach                 *curCoach;
    NSIndexPath             *curIdx;
    
    LyIndicator             *indicator;
    BOOL                    bHttpFlag;
    LyOrderDispatchHttpMethod   curHttpMethod;
}
@end

@implementation LyOrderDispatchTableViewController

static NSString *const lyOrderAllocTableViewCellReuseIdentifier = @"lyOrderAllocTableViewCellReuseIdentifier";

static NSString *const trainBaseDefaultText = @"请选择基地";
static NSString *const coachDefaultText = @"请选择教练";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"分配教练";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    bbiDispatch = [[UIBarButtonItem alloc] initWithTitle:@"分配"
                                                   style:UIBarButtonItemStyleDone
                                                  target:self
                                                  action:@selector(targetForBarButtonItem:)];
    [bbiDispatch setTag:orderDispatchBarButtonItemTag_dispatch];
    [self.navigationItem setRightBarButtonItem:bbiDispatch];
    
    [self.tableView registerClass:[LyChooseTableViewCell class] forCellReuseIdentifier:lyOrderAllocTableViewCellReuseIdentifier];
    [self.tableView setRowHeight:choosetcellHeight];
    
    if (LyUserType_school == [LyCurrentUser curUser].userType) {
        [self.tableView setTableHeaderView:({
            UILabel *lbRemind = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40.0f)];
            [lbRemind setFont:LyFont(14)];
            [lbRemind setTextColor:[UIColor lightGrayColor]];
            [lbRemind setTextAlignment:NSTextAlignmentCenter];
            [lbRemind setText:@"选择基地有助于快速选择教练"];
            [lbRemind setBackgroundColor:LyWhiteLightgrayColor];
            [lbRemind setNumberOfLines:0];
            lbRemind;
        })];
    }
    [self.tableView setTableFooterView:[UIView new]];
    
    
    [bbiDispatch setEnabled:NO];
}



- (void)viewWillAppear:(BOOL)animated {
    _orderId = [_delegate obtainOrderIdByOrderDispatchTVC:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    if (orderDispatchBarButtonItemTag_dispatch == bbi.tag) {
        [self dispatch];
    }
}


- (BOOL)validate:(BOOL)flag {
    
    [bbiDispatch setEnabled:NO];
    
    if (LyUserType_school == [LyCurrentUser curUser].userType) {
        
        if (!curTrainBase) {
            if (flag) {
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没有选择基地"] show];
            }
            return NO;
        }
        
        if (!curCoach) {
            if (flag) {
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没有选择教练"] show];
            }
            return NO;
        }
        
    } else if (LyUserType_coach == [LyCurrentUser curUser].userType) {
        if (!curCoach) {
            if (flag) {
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没有选择教练"] show];
            }
            return NO;
        }
    }
    
    [bbiDispatch setEnabled:YES];
    return YES;
}



- (void)dispatch {
    
    if (![self validate:YES]) {
        return;
    }
    
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:@"正在分配"];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:orderDispatchHttpMethod_dispatch];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:orderDispatch_url
                                 body:@{
                                       orderIdKey:_orderId,
                                       recipientKey:curCoach.userId,
                                       sessionIdKey:[LyUtil httpSessionId]
                                       }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)handleHttpFailed {
    if (indicator) {
        [indicator stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"分配失败"] show];
    }
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
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch (curHttpMethod) {
        case orderDispatchHttpMethod_dispatch: {
            switch ([strCode integerValue]) {
                case 0: {
                    [indicator stopAnimation];
                    
                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"分配完成"];
                    [remind setDelegate:self];
                    [remind show];
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
        }
    }
}


#pragma mark -LyHttpReqeustDelegate
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


#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(LyRemindView *)aRemind {
    [_delegate onDisptachByOrderDispatchTVC:self coach:curCoach];
}


#pragma mark -LyChooseTrainBaseTableViewControllerDelegate 
- (NSString *)obtainSchoolIdByChooseTrainBaseTVC:(LyChooseTrainBaseTableViewController *)aChooseTrainBaseTVC {
    return [LyCurrentUser curUser].userId;
}

- (void)onDoneByChooseTrainBase:(LyChooseTrainBaseTableViewController *)aChooseTrainBaseVC trainBase:(LyTrainBase *)aTrainBase {
    
    [aChooseTrainBaseVC.navigationController popViewControllerAnimated:YES];
    
    curTrainBase = aTrainBase;
    [self.tableView reloadRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationLeft];
    
    [self validate:NO];
}


#pragma mark -LyChooseCoachTableViewControllerDelegate 
- (NSString *)obtainTrainBaseIdByChooseCoachTVC:(LyChooseCoachTableViewController *)aChooseCoachTVC {
    return curTrainBase.tbId;
}

- (void)onSelectedCoachByChooseCoachTVC:(LyChooseCoachTableViewController *)aChooseCoachTVC andCoach:(LyCoach *)coach {
    
    [aChooseCoachTVC.navigationController popViewControllerAnimated:YES];
    
    curCoach = coach;
    [self.tableView reloadRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationLeft];
    
    [self validate:NO];
}


#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return choosetcellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    curIdx = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case 0: {
            if (LyUserType_school == [LyCurrentUser curUser].userType) {
                
                LyChooseTrainBaseTableViewController *chooseTrainBase = [LyChooseTrainBaseTableViewController chooseTrainBaseViewControllerWithMode:LyChooseTrainBaseTableViewControllerMode_school];
                [chooseTrainBase setDelegate:self];
                [self.navigationController pushViewController:chooseTrainBase animated:YES];
            } else if (LyUserType_coach == [LyCurrentUser curUser].userType) {
                
                LyChooseCoachTableViewController *chooseCoach = [[LyChooseCoachTableViewController alloc] init];
                [chooseCoach setDelegate:self];
                [self.navigationController pushViewController:chooseCoach animated:YES];
            }
            break;
        }
        case 1: {
            
            if (!curTrainBase) {
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没有选择基地"] show];
                
            } else {
                LyChooseCoachTableViewController *chooseCoach = [[LyChooseCoachTableViewController alloc] init];
                [chooseCoach setDelegate:self];
                [self.navigationController pushViewController:chooseCoach animated:YES];
            }
            break;
        }
        default:
            break;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (LyUserType_school == [LyCurrentUser curUser].userType) {
        return 2;
    } else if (LyUserType_coach == [LyCurrentUser curUser].userType) {
        return 1;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyOrderAllocTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[LyChooseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyOrderAllocTableViewCellReuseIdentifier];
    }
    
    switch (indexPath.row) {
        case 0: {
            if (LyUserType_school == [LyCurrentUser curUser].userType) {
                [cell setCellInfo:@"基地" detail:(curTrainBase) ? curTrainBase.tbName : @"请选择基地"];
            } else {
                [cell setCellInfo:@"教练" detail:(curCoach) ? curCoach.userName : @"请选择教练"];
            }
            break;
        }
        case 1: {
            [cell setCellInfo:@"教练" detail:(curCoach) ? curCoach.userName : @"请选择教练"];
            break;
        }
        default:
            break;
    }
    
    return cell;
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
