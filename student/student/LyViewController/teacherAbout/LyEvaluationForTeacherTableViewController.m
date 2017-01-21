//
//  LyEvaluationForTeacherTableViewController.m
//  student
//
//  Created by MacMini on 2016/12/28.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyEvaluationForTeacherTableViewController.h"
#import "LyEvaluationForTeacherTableViewCell.h"
#import "LyTableViewFooterView.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyUserManager.h"
#import "LyEvaluationForTeacher.h"

#import "LyUtil.h"


#import "LyEvaluationForTeacherDetailTableViewController.h"



@interface LyEvaluationForTeacherTableViewController () <UIScrollViewDelegate, LyTableViewFooterViewDelegate, LyUtilAnalysisHttpResultDelegate, LyEvaluationForTeacherDetailTableViewControllerDelegate>
{
    NSMutableArray      *arrEva;
    
    NSIndexPath     *curIdx;
}

@property (strong, nonatomic)       LyTableViewFooterView       *tvFooter;

@property (strong, nonatomic)       LyIndicator     *indicator;

@end

@implementation LyEvaluationForTeacherTableViewController

static NSString *const lyEvaluationForTeacherTableViewCellReuseIdentifier = @"lyEvaluationForTeacherTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    _user = [_delegate userByEvaluationForTeacherTableViewController:self];
    
    if (!_user) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (!arrEva || arrEva.count < 1) {
        [self load];
    } else {
        [self reloadData];
    }
    
}

- (void)initSubviews {
    self.title = @"学员评价";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    self.refreshControl = [LyUtil refreshControlWithTitle:nil
                                                   target:self
                                                   action:@selector(refresh)];
    
    [self.tableView setTableFooterView:self.tvFooter];
    arrEva = [[NSMutableArray alloc] initWithCapacity:1];
}

- (LyTableViewFooterView *)tvFooter {
    if (!_tvFooter) {
        _tvFooter = [LyTableViewFooterView tableViewFooterViewWithDelegate:self];
    }
    
    return _tvFooter;
}

- (LyIndicator *)indicator {
    if (!_indicator) {
        _indicator = [LyIndicator indicatorWithTitle:nil];
    }
    
    return _indicator;
}

- (void)reloadData {
    
    arrEva = [LyUtil uniquifyAndSort:arrEva keyUniquify:@"oId" keySort:@"time" asc:NO];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh {
    [self load];
}

- (void)load {
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(load) object:nil];
        return;
    }
    
    [self.indicator startAnimation];
    
    [LyHttpRequest startHttpRequest:evaList_url
                               body:@{
                                      objectIdKey: _user.userId,
                                      getListStartKey: @(0),
                                      userTypeKey: [_user userTypeByString],
                                      userIdKey: [LyCurrentUser curUser].userId,
                                      sessionIdKey:[LyUtil httpSessionId]
                                      }
                               type:LyHttpType_asynPost
                            timeOut:0
                  completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
                      if (error) {
                          [self handleHttpFailed:YES];
                          
                      } else {
                          NSDictionary *dic = [LyUtil analysisHttpResult:resStr delegate:self];
                          if (!dic) {
                              [self handleHttpFailed:YES];
                              return ;
                          }
                          
                          NSString *sCode = [[NSString alloc] initWithFormat:@"%@", dic[codeKey]];
                          switch (sCode.integerValue) {
                              case 0: {
                                  NSArray *arrEvaluation = dic[resultKey];
                                  if (![LyUtil validateArray:arrEvaluation]) {
                                      [self.indicator stopAnimation];
                                      [self.refreshControl endRefreshing];
                                      [self.tvFooter stopAnimation];
                                      self.tvFooter.status = LyTableViewFooterViewStatus_disable;
                                      return;
                                  }

                                  for (NSDictionary *dicEva in arrEvaluation) {
                                      if (![LyUtil validateDictionary:dicEva]) {
                                          continue;
                                      }
                                      
                                      NSString *sId = [[NSString alloc] initWithFormat:@"%@", dicEva[idKey]];
                                      NSString *sContent = [[NSString alloc] initWithFormat:@"%@", dicEva[contentKey]];
                                      NSString *sMasterId = [[NSString alloc] initWithFormat:@"%@", dicEva[masterIdKey]];
                                      NSString *sObjectId = [[NSString alloc] initWithFormat:@"%@", dicEva[objectingIdKey]];
                                      NSString *sTime = [[NSString alloc] initWithFormat:@"%@", dicEva[timeKey]];
                                      NSString *sReplyCount = [[NSString alloc] initWithFormat:@"%@", dicEva[replyCountKey]];
                                      
                                      NSString *sScore = [[NSString alloc] initWithFormat:@"%@", dicEva[scoreKey]];
                                      NSString *sLevel = [[NSString alloc] initWithFormat:@"%@", dicEva[evaluationLevelKey]];
                                      
                                      sTime = [LyUtil fixDateTimeString:sTime];
                                      
                                      LyUser *master = [[LyUserManager sharedInstance] getUserWithUserId:sMasterId];
                                      if (!master) {
                                          NSString *sMasterName = nil;
                                          NSDictionary *dicUser = dic[userKey];
                                          if ([LyUtil validateDictionary:dicUser]) {
                                              sMasterName = [[NSString alloc] initWithFormat:@"%@", dicUser[nickNameKey]];
                                          }
                                          
                                          if ([sMasterId isEqualToString:@"1"]) {
                                              sMasterName = @"匿名用户";
                                          } else if ([sMasterId isEqualToString:[LyCurrentUser curUser].userId]){
                                              sMasterName = [LyCurrentUser curUser].userName;
                                          } else {
                                              if (![LyUtil validateString:sMasterName]) {
                                                  sMasterName = [LyUtil getUserNameWithUserId:sMasterId];
                                              }
                                          }
                                          
                                          master = [LyUser userWithId:sMasterId userNmae:sMasterName];
                                          [[LyUserManager sharedInstance] addUser:master];
                                      }

                                      LyEvaluationForTeacher *eva = [LyEvaluationForTeacher evaluationForTeacherWithId:sId
                                                                                                               content:sContent
                                                                                                                  time:sTime
                                                                                                              masterId:sMasterId
                                                                                                              objectId:sObjectId
                                                                                                                 score:sScore.floatValue
                                                                                                                 level:sLevel.integerValue];
                                      
                                      eva.replyCount = sReplyCount.integerValue;
                                      
                                      [arrEva addObject:eva];
                                  }
                                  
                                  [self reloadData];
                                  
                                  [self.indicator stopAnimation];
                                  [self.refreshControl endRefreshing];
                                  [self.tvFooter stopAnimation];
                                  
                                  self.tvFooter.status = LyTableViewFooterViewStatus_normal;
                                  
                                  
                                  break;
                              }
                              default: {
                                  [self handleHttpFailed:YES];
                                  break;
                              }
                          }
                      }
                  }];
}


- (void)loadMore {
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(loadMore) object:nil];
        return;
    }
    
    [self.tvFooter startAnimation];
    
    
    [LyHttpRequest startHttpRequest:evaList_url
                               body:@{
                                      objectIdKey: _user.userId,
                                      getListStartKey: @(arrEva.count),
                                      userTypeKey: [_user userTypeByString],
                                      userIdKey: [LyCurrentUser curUser].userId,
                                      sessionIdKey:[LyUtil httpSessionId]
                                      }
                               type:LyHttpType_asynPost
                            timeOut:0
                  completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
                      if (error) {
                          [self handleHttpFailed:YES];
                          
                      } else {
                          NSDictionary *dic = [LyUtil analysisHttpResult:resStr delegate:self];
                          if (!dic) {
                              [self handleHttpFailed:YES];
                              return ;
                          }
                          
                          NSString *sCode = [[NSString alloc] initWithFormat:@"%@", dic[codeKey]];
                          switch (sCode.integerValue) {
                              case 0: {
                                  NSArray *arrEvaluation = dic[resultKey];
                                  if (![LyUtil validateArray:arrEvaluation]) {
                                      [self.indicator stopAnimation];
                                      [self.refreshControl endRefreshing];
                                      [self.tvFooter stopAnimation];
                                      self.tvFooter.status = LyTableViewFooterViewStatus_disable;
                                      return;
                                  }
                                  
                                  for (NSDictionary *dicEva in arrEvaluation) {
                                      if (![LyUtil validateDictionary:dicEva]) {
                                          continue;
                                      }
                                      
                                      NSString *sId = [[NSString alloc] initWithFormat:@"%@", dicEva[idKey]];
                                      NSString *sContent = [[NSString alloc] initWithFormat:@"%@", dicEva[contentKey]];
                                      NSString *sMasterId = [[NSString alloc] initWithFormat:@"%@", dicEva[masterIdKey]];
                                      NSString *sObjectId = [[NSString alloc] initWithFormat:@"%@", dicEva[objectingIdKey]];
                                      NSString *sTime = [[NSString alloc] initWithFormat:@"%@", dicEva[timeKey]];
                                      NSString *sReplyCount = [[NSString alloc] initWithFormat:@"%@", dicEva[replyCountKey]];
                                      
                                      NSString *sScore = [[NSString alloc] initWithFormat:@"%@", dicEva[scoreKey]];
                                      NSString *sLevel = [[NSString alloc] initWithFormat:@"%@", dicEva[evaluationLevelKey]];
                                      
                                      sTime = [LyUtil fixDateTimeString:sTime];
                                      
                                      LyUser *master = [[LyUserManager sharedInstance] getUserWithUserId:sMasterId];
                                      if (!master) {
                                          NSString *sMasterName = nil;
                                          NSDictionary *dicUser = dic[userKey];
                                          if ([LyUtil validateDictionary:dicUser]) {
                                              sMasterName = [[NSString alloc] initWithFormat:@"%@", dicUser[nickNameKey]];
                                          }
                                          
                                          if ([sMasterId isEqualToString:@"1"]) {
                                              sMasterName = @"匿名用户";
                                          } else if ([sMasterId isEqualToString:[LyCurrentUser curUser].userId]){
                                              sMasterName = [LyCurrentUser curUser].userName;
                                          } else {
                                              if (![LyUtil validateString:sMasterName]) {
                                                  sMasterName = [LyUtil getUserNameWithUserId:sMasterId];
                                              }
                                          }
                                          
                                          master = [LyUser userWithId:sMasterId userNmae:sMasterName];
                                          [[LyUserManager sharedInstance] addUser:master];
                                      }
                                      
                                      LyEvaluationForTeacher *eva = [LyEvaluationForTeacher evaluationForTeacherWithId:sId
                                                                                                               content:sContent
                                                                                                                  time:sTime
                                                                                                              masterId:sMasterId
                                                                                                              objectId:sObjectId
                                                                                                                 score:sScore.floatValue
                                                                                                                 level:sLevel.integerValue];
                                      
                                      eva.replyCount = sReplyCount.integerValue;
                                      
                                      [arrEva addObject:eva];
                                  }
                                  
                                  [self reloadData];
                                  
                                  [self.indicator stopAnimation];
                                  [self.refreshControl endRefreshing];
                                  [self.tvFooter stopAnimation];
                                  
                                  self.tvFooter.status = LyTableViewFooterViewStatus_normal;
                                  
                                  
                                  break;
                              }
                              default: {
                                  [self handleHttpFailed:YES];
                                  break;
                              }
                          }
                      }
                  }];
}



#pragma mark -LyUtilAnalysisHttpResultDelegate
- (void)handleHttpFailed:(BOOL)needRemind {
    if (self.indicator.isAnimating) {
        [self.indicator stopAnimation];
        [self.refreshControl endRefreshing];
    }
    
    if (self.tvFooter.isAnimating) {
        [self.tvFooter stopAnimation];
    }
    
    self.tvFooter.status = LyTableViewFooterViewStatus_error;
}



#pragma mark -LyEvaluationForTeacherDetailTableViewControllerDelegate
- (LyEvaluationForTeacher *)evaluationForTeacherByEvaluationForTeacherDetailTableViewController:(LyEvaluationForTeacherDetailTableViewController *)aEvaluationForTeacherDetailTVC {
    return arrEva[curIdx.row];
}



#pragma mark -LyTableViewFooterViewDelegate
- (void)loadMoreData:(LyTableViewFooterView *)tableViewFooterView {
    [self loadMore];
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LyEvaluationForTeacher *eva = arrEva[indexPath.row];
    if (LyChatCellHeightMin >= eva.height || eva.height > LyChatCellHeightMax) {
        LyEvaluationForTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyEvaluationForTeacherTableViewCellReuseIdentifier];
        if (!cell) {
            cell = [[LyEvaluationForTeacherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyEvaluationForTeacherTableViewCellReuseIdentifier];
        }
        
        cell.eva = eva;

    }
   
    return eva.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    curIdx = indexPath;
    
    LyEvaluationForTeacherDetailTableViewController *evaDetail = [[LyEvaluationForTeacherDetailTableViewController alloc] init];
    evaDetail.delegate = self;
    [self.navigationController pushViewController:evaDetail animated:YES];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrEva.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyEvaluationForTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyEvaluationForTeacherTableViewCellReuseIdentifier];
    if (!cell) {
        cell = [[LyEvaluationForTeacherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyEvaluationForTeacherTableViewCellReuseIdentifier];
    }
    
    cell.eva = arrEva[indexPath.row];
    
    return cell;
}



#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.tableView) {
        if (!self.tvFooter.isAnimating &&
            scrollView.contentSize.height > CGRectGetHeight(scrollView.frame) &&
            scrollView.contentOffset.y + CGRectGetHeight(scrollView.frame) > scrollView.contentSize.height + tvFooterViewDefaultHeight)
        {
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
