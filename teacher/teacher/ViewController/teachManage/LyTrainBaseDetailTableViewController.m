//
//  LyTrainBaseDetailTableViewController.m
//  teacher
//
//  Created by Junes on 16/8/26.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyTrainBaseDetailTableViewController.h"
#import "LyCoachTableViewCell.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCoach.h"
#import "LyTrainBase.h"

#import "LyCurrentUser.h"

#import "NSMutableArray+SingleElement.h"

#import "LyUtil.h"



//基地信息
CGFloat const tbdViewInfoHeight = 90.0f;
//基地名
CGFloat const lbTbNameHeight = 30.0f;
//教练人数//学员人数
CGFloat const lbTbCountInfoHeight = 20.0f;
//基地地址
CGFloat const lbTbAddressHeight = 30.0f;



enum {
    trainBaseDetailBarButtonItemTag_delete = 0,
}LyTrainBaseDetailBarButtonItemTag;



typedef NS_ENUM(NSInteger, LyTrainBaseDetailHttpMethod) {
    trainBaseDetailHttpMethod_load = 100,
    trainBaseDetailHttpMethod_delete
};


@interface LyTrainBaseDetailTableViewController () <LyHttpRequestDelegate, LyRemindViewDelegate>
{
    UIView                  *viewError;
    UIView                  *viewNull;
    
    //基地信息
    UIView                  *viewInfo;
    UILabel                 *lbTbName;
    UILabel                 *lbCoachCount;
//    UILabel                 *lbStudentCount;
    UILabel                 *lbAddress;
    
    NSIndexPath             *curIdx;
    NSMutableArray          *arrCoaches;
    
    NSArray                 *arrTrainBase;
    
    LyIndicator             *indicator_oper;
    LyIndicator             *indicator;
    BOOL                    bHttpFlag;
    LyTrainBaseDetailHttpMethod curHttpMethod;
}
@end

@implementation LyTrainBaseDetailTableViewController

static NSString *const lyTrainBaseDetailTvCoachesCellReuseIdentifier = @"lyTrainBaseDetailTvCoachesCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initAndLayoutSubviews];
}



- (void)viewWillAppear:(BOOL)animated {

    
    if (!_trainBase) {
        NSDictionary *dic = [_delegate trainBaseInfoByTrainBaseDetailTVC:self];
        _trainBase = [dic objectForKey:trainBaseKey];
        arrTrainBase = [dic objectForKey:@"trainBase"];
        
        if (!_trainBase || ![LyUtil validateArray:arrTrainBase]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
        [self reloadViewInfoData];
        [self load];
    }
}


- (void)initAndLayoutSubviews {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    UIBarButtonItem *bbiDelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                               target:self
                                                                               action:@selector(targetForBarButtonItem:)];
    [bbiDelete setTag:trainBaseDetailBarButtonItemTag_delete];
    [self.navigationItem setRightBarButtonItem:bbiDelete];
    
    //基地信息
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tbdViewInfoHeight)];
    [self.view addSubview:viewInfo];
    
    //基地名
    lbTbName = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, verticalSpace, SCREEN_WIDTH-horizontalSpace*2, lbTbNameHeight)];
    [lbTbName setFont:LyFont(18)];
    [lbTbName setTextColor:Ly517ThemeColor];
    [lbTbName setTextAlignment:NSTextAlignmentLeft];
    //教练人数
    lbCoachCount = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, lbTbName.ly_y+CGRectGetHeight(lbTbName.frame), (SCREEN_WIDTH-horizontalSpace*2-verticalSpace)/2.0f, lbTbCountInfoHeight)];
    [lbCoachCount setFont:LyFont(14)];
    [lbCoachCount setTextColor:LyBlackColor];
    [lbCoachCount setTextAlignment:NSTextAlignmentLeft];
    //学员人数
//    lbStudentCount = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f, lbCoachCount.ly_y, (SCREEN_WIDTH-horizontalSpace*2-verticalSpace)/2.0f, lbTbCountInfoHeight)];
//    [lbStudentCount setFont:LyFont(14)];
//    [lbStudentCount setTextColor:LyBlackColor];
//    [lbStudentCount setTextAlignment:NSTextAlignmentLeft];
    //基地地址
    lbAddress = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, lbCoachCount.ly_y+CGRectGetHeight(lbCoachCount.frame), SCREEN_WIDTH-horizontalSpace*2, lbTbAddressHeight)];
    [lbAddress setFont:LyFont(14)];
    [lbAddress setTextColor:LyBlackColor];
    [lbAddress setTextAlignment:NSTextAlignmentLeft];
    [lbAddress setNumberOfLines:0];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, tbdViewInfoHeight-verticalSpace, SCREEN_WIDTH, verticalSpace)];
    [horizontalLine setBackgroundColor:LyWhiteLightgrayColor];
    
    [viewInfo addSubview:lbTbName];
    [viewInfo addSubview:lbCoachCount];
//    [viewInfo addSubview:lbStudentCount];
    [viewInfo addSubview:lbAddress];
    [viewInfo addSubview:horizontalLine];
    
    [self.tableView registerClass:[LyCoachTableViewCell class] forCellReuseIdentifier:lyTrainBaseDetailTvCoachesCellReuseIdentifier];
    [self.tableView setRowHeight:coachtcellHeight];
    
    [self.tableView setTableHeaderView:viewInfo];
    [self.tableView setTableFooterView:[UIView new]];
    
    arrCoaches = [NSMutableArray array];
}


- (void)reloadViewInfoData {
    
    self.title = _trainBase.tbName;
    
    [lbTbName setText:_trainBase.tbName];
    [lbCoachCount setText:[_trainBase coachCountByString]];
//    [lbStudentCount setText:[_trainBase studentCountByString]];
    [lbAddress setText:_trainBase.tbAddress];
}


- (void)reloadData {
    
    [arrCoaches singleElementByKey:@"userId"];
    
    [self reloadViewInfoData];
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
        viewNull = [[UIView alloc] initWithFrame:CGRectMake(0, viewInfo.ly_y+CGRectGetHeight(viewInfo.frame), SCREEN_WIDTH, SCREEN_HEIGHT)];
        [viewNull setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewNull addSubview:[LyUtil lbNullWithText:@"该基地暂无教练"]];
    }
    
    [self.tableView addSubview:viewNull];
    [self.tableView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.05)];
}

- (void)removeViewNull {
    [viewNull removeFromSuperview];
    viewNull = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    if (trainBaseDetailBarButtonItemTag_delete == bbi.tag) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:[[NSString alloc] initWithFormat:@"确定要删除「%@」吗", _trainBase.tbName]
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"删除"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    [self delete];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (void)refresh:(UIRefreshControl *)rc {
    [self load];
}


- (void)load {
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:nil];
    }
    
    [indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:trainBaseDetailHttpMethod_load];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:trainBaseDetail_url
                                 body:@{
                                        trainBaseIdKey:_trainBase.tbId,
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
    }
    else {
        [indicator_oper setTitle:LyIndicatorTitle_delete];
    }
    
    [indicator_oper startAnimation];
    
    
    NSMutableString *strTrainBase = [[NSMutableString alloc] initWithString:@""];
    for (LyTrainBase *trainBase in arrTrainBase) {
        if (!trainBase || ![LyUtil validateString:trainBase.tbId]) {
            continue;
        }
        
        if ([trainBase.tbId isEqualToString:_trainBase.tbId]) {
            continue;
        }
        
        [strTrainBase appendFormat:@"%@,", trainBase.tbId];
    }
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:trainBaseDetailHttpMethod_delete];
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
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"删除失败"] show];
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
        [self.refreshControl endRefreshing];
        [indicator_oper stopAnimation];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        [indicator_oper stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch (curHttpMethod) {
        case trainBaseDetailHttpMethod_load: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateArray:arrResult]) {
                        [indicator stopAnimation];
                        [self.refreshControl endRefreshing];
                        [self showViewNull];
                        return;
                    }
                    
                    for (NSDictionary *dicItem in arrResult) {
                        if (![LyUtil validateDictionary:dicItem]) {
                            continue;
                        }
                        
                        NSString *strCoachId = [dicItem objectForKey:coachIdKey];
                        NSString *strNickName;
                        NSDictionary *dicCoachInfo = [dicItem objectForKey:coachKey];
                        if ([LyUtil validateDictionary:dicCoachInfo]) {
                            strNickName = [dicCoachInfo objectForKey:nickNameKey];
                        } else  {
                            strNickName = [LyUtil getUserNameWithUserId:strCoachId];
                        }
                        NSString *strStudentCount = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:studentCountKey]];
                        NSString *strOrderCount = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:orderCountKey]];
                        
                        
                        LyCoach *coach = [LyCoach coachWithId:strCoachId
                                                         name:strNickName];
                        [coach setStuAllCount:[strStudentCount intValue]];
                        [coach setAllOrderCount:[strOrderCount intValue]];
                        
                        [arrCoaches addObject:coach];
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
        case trainBaseDetailHttpMethod_delete: {
            switch ([strCode integerValue]) {
                case 0: {
                    [indicator_oper stopAnimation];
                    
                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"删除成功"];
                    [remind setDelegate:self];
                    [remind showWithTime:@(1.5f)];
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


#pragma mark -LyRemindViewDelegate
- (void)remindViewWillHide:(LyRemindView *)aRemind {
    [_delegate onDeleteByTrainBaseDetailTVC:self];
}





#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (arrCoaches.count < 1) {
        [self showViewNull];
    } else {
        [self removeViewNull];
    }
    
    return arrCoaches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyCoachTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyTrainBaseDetailTvCoachesCellReuseIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[LyCoachTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyTrainBaseDetailTvCoachesCellReuseIdentifier];
    }
    [cell setCoach:[arrCoaches objectAtIndex:indexPath.row] mode:LyCoachTableViewCellMode_trainBaseDetail];
    
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
