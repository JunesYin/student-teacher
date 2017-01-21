
//  LyConsultDetailTableViewController.m
//  student
//
//  Created by MacMini on 2016/12/28.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyConsultDetailTableViewController.h"
#import "LyReplyTableViewCell.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyUserManager.h"
#import "LyConsult.h"
#import "LyReply.h"

#import "LyUtil.h"


CGFloat const condIvAvatarSize = 40.0f;

#define condLbNameWidth                 (SCREEN_WIDTH - condIvAvatarSize - horizontalSpace * 3)
CGFloat const condLbNameHeight = 20.0f;
#define condlbNameFont                  LyFont(16)

#define condlbTimeFont                  LyFont(13)

#define condTvContentWidth              (SCREEN_WIDTH - horizontalSpace * 2)
#define condTvContentFont               LyFont(14)


@interface LyConsultDetailTableViewController () <LyUtilAnalysisHttpResultDelegate>
{
    UIView      *viewHeader;
    UIImageView     *ivAvatar;
    UILabel     *lbName;
    UILabel     *lbTime;
    UITextView      *tvContent;
    UIView      *line;
    
    
    UIView      *viewError;
    UIView      *viewNull;
    
    
    NSMutableArray      *arrRep;
}

@property (strong, nonatomic)       LyIndicator     *indicator;

@end

@implementation LyConsultDetailTableViewController

static NSString *const lyConsultDetailTableViewCellReuseIdentifier = @"lyConsultDetailTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    _con = [_delegate consultByConsultDetailTableViewController:self];
    if (!_con) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self reloadData_header];
    
    [self load];
}

- (void)initSubviews {
    self.title = @"咨询详情";
    self.view.backgroundColor = LyWhiteLightgrayColor;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.refreshControl = [LyUtil refreshControlWithTitle:nil
                                                   target:self
                                                   action:@selector(refresh)];
    
    viewHeader = [UIView new];
    viewHeader.backgroundColor = [UIColor whiteColor];
    
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(horizontalSpace, verticalSpace, condIvAvatarSize, condIvAvatarSize)];
    ivAvatar.contentMode = UIViewContentModeScaleAspectFill;
    [ivAvatar.layer setCornerRadius:condIvAvatarSize / 2.0];
    ivAvatar.clipsToBounds = YES;
    
    lbName = [[UILabel alloc] initWithFrame:CGRectMake(condIvAvatarSize + horizontalSpace * 2, ivAvatar.frame.origin.y, condLbNameWidth, condLbNameHeight)];
    lbName.font = condlbNameFont;
    lbName.textColor = LyBlackColor;
    lbName.textAlignment = NSTextAlignmentLeft;
    
    lbTime = [[UILabel alloc] initWithFrame:CGRectMake(lbName.frame.origin.x, lbName.frame.origin.y + CGRectGetHeight(lbName.frame), condLbNameWidth, condLbNameHeight)];
    lbTime.font = condlbTimeFont;
    lbTime.textColor = [UIColor darkGrayColor];
    lbTime.textAlignment = NSTextAlignmentLeft;
    
    tvContent = [UITextView new];
    tvContent.font = condTvContentFont;
    tvContent.textColor = LyBlackColor;
    tvContent.textAlignment = NSTextAlignmentLeft;
    tvContent.scrollEnabled = NO;
    tvContent.editable = NO;
    tvContent.selectable = NO;
    
    line = [UIView new];
    line.backgroundColor = LyWhiteLightgrayColor;
    
    [viewHeader addSubview:ivAvatar];
    [viewHeader addSubview:lbName];
    [viewHeader addSubview:lbTime];
    [viewHeader addSubview:tvContent];
    [viewHeader addSubview:line];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = LyWhiteLightgrayColor;
    self.tableView.tableFooterView = [UIView new];
    
    arrRep = [[NSMutableArray alloc] init];
}


- (LyIndicator *)indicator {
    if (!_indicator) {
        _indicator = [LyIndicator indicatorWithTitle:nil];
    }
    
    return _indicator;
}

- (void)reloadData {
    [self removeViewError];
    
    [self reloadData_header];
    
    arrRep = [LyUtil uniquifyAndSort:arrRep keyUniquify:@"oId" keySort:@"time" asc:NO];
    
    if (!arrRep || arrRep.count < 1) {
        [self showViewNull];
    } else {
        [self removeViewNull];
    }
    
    [self.tableView reloadData];
}

- (void)reloadData_header {
    LyUser *master = [[LyUserManager sharedInstance] getUserWithUserId:_con.masterId];
    
    if (!master.userAvatar) {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:_con.masterId]
                    placeholderImage:[LyUtil defaultAvatarForStudent]
                           completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                               if (image) {
                                   master.userAvatar = image;
                                   
                               } else {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:_con.masterId]
                                               placeholderImage:[LyUtil defaultAvatarForStudent]
                                                      completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                                          if (image) {
                                                              master.userAvatar = image;
                                                          }
                                                      }];
                                   
                               }
                           }];
        
    } else {
        ivAvatar.image = master.userAvatar;
    }
    
    lbName.text = master.userName;
    
    lbTime.text = [LyUtil translateTime:_con.time];
    
    tvContent.text = _con.content;
    CGFloat fHeightTvContent = [tvContent sizeThatFits:CGSizeMake(condTvContentWidth, MAXFLOAT)].height;
    tvContent.frame = CGRectMake(horizontalSpace, ivAvatar.frame.origin.y + CGRectGetHeight(ivAvatar.frame) + verticalSpace, condTvContentWidth, fHeightTvContent);
    
    line.frame = CGRectMake(0, tvContent.frame.origin.y + fHeightTvContent, SCREEN_WIDTH, verticalSpace);
    
    viewHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, line.frame.origin.y + verticalSpace);
    
    
    
    self.tableView.tableHeaderView = viewHeader;
}

- (void)showViewError {
    if (!viewError) {
//        viewError = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeader.frame.origin.y + CGRectGetHeight(viewHeader.frame), SCREEN_WIDTH, SCREEN_HEIGHT * 1.2)];
        viewError = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeader.frame.origin.y + CGRectGetHeight(viewHeader.frame), SCREEN_WIDTH, 200)];
        viewError.backgroundColor = LyWhiteLightgrayColor;
        
        [viewError addSubview:[LyUtil lbErrorWithMode:0]];
    }
    
    self.tableView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 1.05);
    [self.tableView addSubview:viewError];
}

- (void)removeViewError {
    [viewError removeFromSuperview];
    viewError = nil;
}

- (void)showViewNull {
    if (!viewNull) {
        viewNull = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeader.frame.origin.y + CGRectGetHeight(viewHeader.frame), SCREEN_WIDTH, SCREEN_HEIGHT * 1.2)];
        viewNull = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeader.frame.origin.y + CGRectGetHeight(viewHeader.frame), SCREEN_WIDTH, 200)];
        viewNull.backgroundColor = LyWhiteLightgrayColor;
        
        [viewNull addSubview:[LyUtil lbNullWithText:@"还没有回复"]];
    }
    
    self.tableView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 1.05);
    [self.tableView addSubview:viewNull];
}

- (void)removeViewNull {
    [viewNull removeFromSuperview];
    viewNull = nil;
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
    
    [LyHttpRequest startHttpRequest:consultDetail_url
                               body:@{
                                      idKey: _con.oId,
                                      sessionIdKey: [LyUtil httpSessionId]
                                      }
                               type:LyHttpType_asynPost
                            timeOut:0
                  completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
                      if (error) {
                          [self handleHttpFailed:YES];
                          return ;
                      }
                      
                      NSDictionary *dic = [LyUtil analysisHttpResult:resStr delegate:self];
                      if (!dic) {
                          [self handleHttpFailed:YES];
                          return ;
                      }
                      
                      NSArray *arrReply = dic[resultKey];
                      if ([LyUtil validateArray:arrReply]) {
                          for (NSDictionary *dicReply in arrReply) {
                              if (![LyUtil validateDictionary:dicReply]) {
                                  continue;
                              }
                              
                              NSString *sId = [[NSString alloc] initWithFormat:@"%@", dicReply[idKey]];
                              NSString *sContent = [[NSString alloc] initWithFormat:@"%@", dicReply[contentKey]];
                              NSString *sMasterId = [[NSString alloc] initWithFormat:@"%@", dicReply[masterIdKey]];
                              NSString *sObjectId = [[NSString alloc] initWithFormat:@"%@", dicReply[objectIdKey]];
                              NSString *sTime = [[NSString alloc] initWithFormat:@"%@", dic[timeKey]];
                              
                              sTime = [LyUtil fixDateTimeString:sTime];
                              
                              LyReply *reply = [LyReply replyWithId:sId
                                                           masterId:sMasterId
                                                           objectId:sObjectId
                                                        objectingId:_con.oId
                                                            content:sContent
                                                               time:sTime
                                                         objectRpId:nil];
                              
                              [arrRep addObject:reply];
                          }
                      }
                      
                      [self reloadData];
                      
                      [self.indicator stopAnimation];
                      [self.refreshControl endRefreshing];
                  }];
    
}


#pragma mark -LyUtilAnalysisHttpResultDelegate
- (void)handleHttpFailed:(BOOL)needRemind {
    if (self.indicator.isAnimating) {
        [self.indicator stopAnimation];
        
        [self showViewError];
    }
}


#pragma mark -UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyReply *reply = arrRep[indexPath.row];
    if (LyChatCellHeightMin >= reply.height || reply.height > LyChatCellHeightMax) {
        LyReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyConsultDetailTableViewCellReuseIdentifier];
        if (!cell) {
            cell = [[LyReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyConsultDetailTableViewCellReuseIdentifier];
        }
        
        cell.reply = reply;
    }
    
    return reply.height;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrRep.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyConsultDetailTableViewCellReuseIdentifier];
    if (!cell) {
        cell = [[LyReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyConsultDetailTableViewCellReuseIdentifier];
    }
    
    cell.reply = arrRep[indexPath.row];
    
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
