//
//  LyConsultTableViewController.m
//  student
//
//  Created by MacMini on 2016/12/28.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyConsultTableViewController.h"
#import "LyConsultTableViewCell.h"
#import "LyTableViewFooterView.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyUserManager.h"
#import "LyConsult.h"

#import "LyUtil.h"


#import "LyConsultDetailTableViewController.h"


@interface LyConsultTableViewController () <UIScrollViewDelegate, LyTableViewFooterViewDelegate, LyUtilAnalysisHttpResultDelegate, LyConsultDetailTableViewControllerDelegate>
{
    NSMutableArray      *arrCon;
    
    NSIndexPath     *curIdx;
}

@property (strong, nonatomic)       LyTableViewFooterView       *tvFooter;

@property (strong, nonatomic)       LyIndicator     *indicator;

@end

@implementation LyConsultTableViewController

static NSString *const lyConsultTableViewCellReuseIdentifier = @"lyConsultTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    _user = [_delegate userByConsultTableViewController:self];
    
    if (!_user) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (!arrCon || arrCon.count < 1) {
        [self load];
    } else {
        [self reloadData];
    }
}

- (void)initSubviews {
    self.title = @"提问咨询";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.refreshControl = [LyUtil refreshControlWithTitle:nil
                                                   target:self
                                                   action:@selector(refresh)];
    
    [self.tableView setTableFooterView:self.tvFooter];
    
    arrCon = [[NSMutableArray alloc] initWithCapacity:1];
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
    
    arrCon = [LyUtil uniquifyAndSort:arrCon keyUniquify:@"oId" keySort:@"time" asc:NO];
    
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
    
    [LyHttpRequest startHttpRequest:conList_url
                               body:@{
                                      objectIdKey: _user.userId,
                                      getListStartKey: @0,
                                      userTypeKey: [_user userTypeByString],
                                      userIdKey: [LyCurrentUser curUser].userId,
                                      sessionIdKey: [LyUtil httpSessionId]
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
                                  NSArray *arrConsult = dic[resultKey];
                                  if (![LyUtil validateArray:arrConsult]) {
                                      [self.indicator stopAnimation];
                                      [self.refreshControl endRefreshing];
                                      [self.tvFooter stopAnimation];
                                      self.tvFooter.status = LyTableViewFooterViewStatus_disable;
                                      return;
                                  }
                                  
                                  for (NSDictionary *dicCon in arrConsult) {
                                      if (![LyUtil validateDictionary:dicCon]) {
                                          continue;
                                      }
                                      
                                      NSString *sId = [[NSString alloc] initWithFormat:@"%@", dicCon[idKey]];
                                      NSString *sContent = [[NSString alloc] initWithFormat:@"%@", dicCon[contentKey]];
                                      NSString *sMasterId = [[NSString alloc] initWithFormat:@"%@", dicCon[masterIdKey]];
                                      NSString *sMasterName = [[NSString alloc] initWithFormat:@"%@", dicCon[masterNickNameKey]];
                                      NSString *sObjectId = [[NSString alloc] initWithFormat:@"%@", dicCon[objectIdKey]];
                                      NSString *sTime = [[NSString alloc] initWithFormat:@"%@", dicCon[timeKey]];
                                      NSString *sReplyCount = [[NSString alloc] initWithFormat:@"%@", dicCon[replyCountKey]];
                                      
                                      sTime = [LyUtil fixDateTimeString:sTime];
                                      
                                      LyUser *master = [[LyUserManager sharedInstance] getUserWithUserId:sMasterId];
                                      if (!master) {
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
                                      
                                      LyConsult *con = [LyConsult consultWithId:sId
                                                                           time:sTime
                                                                       masterId:sMasterId
                                                                       objectId:sObjectId
                                                                        content:sContent];
                                      con.replyCount = sReplyCount.integerValue;
                                      
                                      [arrCon addObject:con];
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
    
    [LyHttpRequest startHttpRequest:conList_url
                               body:@{
                                      objectIdKey: _user.userId,
                                      getListStartKey: @(arrCon.count),
                                      userTypeKey: [_user userTypeByString],
                                      userIdKey: [LyCurrentUser curUser].userId,
                                      sessionIdKey: [LyUtil httpSessionId]
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
                                  NSArray *arrConsult = dic[resultKey];
                                  if (![LyUtil validateArray:arrConsult]) {
                                      [self.indicator stopAnimation];
                                      [self.refreshControl endRefreshing];
                                      [self.tvFooter stopAnimation];
                                      self.tvFooter.status = LyTableViewFooterViewStatus_disable;
                                      return;
                                  }
                                  
                                  for (NSDictionary *dicCon in arrConsult) {
                                      if (![LyUtil validateDictionary:dicCon]) {
                                          continue;
                                      }
                                      
                                      NSString *sId = [[NSString alloc] initWithFormat:@"%@", dicCon[idKey]];
                                      NSString *sContent = [[NSString alloc] initWithFormat:@"%@", dicCon[contentKey]];
                                      NSString *sMasterId = [[NSString alloc] initWithFormat:@"%@", dicCon[masterIdKey]];
                                      NSString *sMasterName = [[NSString alloc] initWithFormat:@"%@", dicCon[masterNickNameKey]];
                                      NSString *sObjectId = [[NSString alloc] initWithFormat:@"%@", dicCon[objectIdKey]];
                                      NSString *sTime = [[NSString alloc] initWithFormat:@"%@", dicCon[timeKey]];
                                      NSString *sReplyCount = [[NSString alloc] initWithFormat:@"%@", dicCon[replyCountKey]];
                                      
                                      sTime = [LyUtil fixDateTimeString:sTime];
                                      
                                      LyUser *master = [[LyUserManager sharedInstance] getUserWithUserId:sMasterId];
                                      if (!master) {
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
                                      
                                      LyConsult *con = [LyConsult consultWithId:sId
                                                                           time:sTime
                                                                       masterId:sMasterId
                                                                       objectId:sObjectId
                                                                        content:sContent];
                                      
                                      con.replyCount = sReplyCount.integerValue;
                                      
                                      [arrCon addObject:con];
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


#pragma mark -LyConsultDetailTableViewControllerDelegate
- (LyConsult *)consultByConsultDetailTableViewController:(LyConsultDetailTableViewController *)aConsultDetailTVC {
    return arrCon[curIdx.row];
}


#pragma mark -LyTabelViewFooterViewDelegate
- (void)loadMoreData:(LyTableViewFooterView *)tableViewFooterView {
    [self loadMore];
}


#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyConsult *con = arrCon[indexPath.row];
//    if (LyChatCellHeightMin >= con.height || con.height > LyChatCellHeightMax) {
        LyConsultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyConsultTableViewCellReuseIdentifier];
        if (!cell) {
            cell = [[LyConsultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyConsultTableViewCellReuseIdentifier];
        }
        
        cell.consult = con;
//    }
    
//    return con.height;
    return cell.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    curIdx = indexPath;
    
    LyConsultDetailTableViewController *conDetail = [[LyConsultDetailTableViewController alloc] init];
    conDetail.delegate = self;
    [self.navigationController pushViewController:conDetail animated:YES];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrCon.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyConsultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyConsultTableViewCellReuseIdentifier];
    if (!cell) {
        cell = [[LyConsultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyConsultTableViewCellReuseIdentifier];
    }
    
    cell.consult = arrCon[indexPath.row];
    
    return cell;
}


#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.tableView) {
        if (
            !self.tvFooter.isAnimating &&
            scrollView.contentSize.height > CGRectGetHeight(scrollView.frame) &&
            scrollView.contentOffset.y + CGRectGetHeight(scrollView.frame) > scrollView.contentSize.height + tvFooterViewDefaultHeight
            )
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
