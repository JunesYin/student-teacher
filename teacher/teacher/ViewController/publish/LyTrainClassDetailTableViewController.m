//
//  LyTrainClassDetailTableViewController.m
//  teacher
//
//  Created by Junes on 16/8/25.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyTrainClassDetailTableViewController.h"
#import "LyTrainClassDetailTableViewCell.h"
#import "LyTableViewHeaderFooterView.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyTrainClassManager.h"

#import "LyUtil.h"


CGFloat const tcdViewInfoHeight = 150.0f;
//CGFloat const lbItemHeight = 20.0f;
#define lbItemFont                          LyFont(14)



enum {
    trainClassDetailBarButtonItemTag_delete = 0,
}LyTrainClassDetailBarButtonItemTag_delete;


typedef NS_ENUM(NSInteger, LyTrainClassDetailHttpMethod) {
    trainClassDetailHttpMethod_delete = 100,
};


@interface LyTrainClassDetailTableViewController () <LyHttpRequestDelegate, LyRemindViewDelegate>
{
    UIView              *viewInfo;
    UILabel             *lbTitle_info;
    UILabel             *lbWholeName;
    UILabel             *lbFold;
    UILabel             *lbCarType;
    UILabel             *lbTrainClassTime;
    UILabel             *lbOfficialPrice;
    UILabel             *lbWhole517Price;
    
    LyIndicator         *indicator_oper;
    BOOL                bHttpFlag;
    LyTrainClassDetailHttpMethod    curHttpMethod;
}
@end

@implementation LyTrainClassDetailTableViewController

static NSString *const lyTrainClassDetailTvInfoCellReuseIdentifier = @"lyTrainClassDetailTvInfoCellReuseIdentifier";
static NSString *const lyTrainClassDetailTvHeaderFooterViewReuseIdentifier = @"lyTrainClassDetailTvHeaderFooterViewReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initAndLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    _trainClass = [_delegate obtainTrainClassByTrainClassDetailTVC:self];
    
    [self reloadViewData];
}

- (void)initAndLayoutSubviews
{
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    if ([[LyCurrentUser curUser] isMaster]) {
        UIBarButtonItem *bbiDelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                   target:self
                                                                                   action:@selector(targetForBarButtonItem:)];
        [bbiDelete setTag:trainClassDetailBarButtonItemTag_delete];
        [self.navigationItem setRightBarButtonItem:bbiDelete];
    }
    
    //课程信息
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, tcdViewInfoHeight)];
    [viewInfo setBackgroundColor:[UIColor whiteColor]];
    //课程信息-标题
    lbTitle_info = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, 20, SCREEN_WIDTH, 30.0f)];
    [lbTitle_info setTextColor:Ly517ThemeColor];
    [lbTitle_info setFont:LyFont(18)];
    [lbTitle_info setTextAlignment:NSTextAlignmentLeft];
    //课程信息-名字
    lbWholeName = [UILabel new];
    [lbWholeName setFont:lbItemFont];
    [lbWholeName setTextColor:LyBlackColor];
    [lbWholeName setTextAlignment:NSTextAlignmentCenter];
    //课程信息-优惠数
    lbFold = [UILabel new];
    [lbFold setFont:lbItemFont];
    [lbFold setTextColor:Ly517ThemeColor];
    [lbFold setTextAlignment:NSTextAlignmentCenter];
    [[lbFold layer] setCornerRadius:3.0f];
    [[lbFold layer] setBorderWidth:1];
    [[lbFold layer] setBorderColor:[Ly517ThemeColor CGColor]];
    //课程信息-教练车型
    lbCarType = [UILabel new];
    [lbCarType setFont:lbItemFont];
    [lbCarType setTextColor:LyBlackColor];
    [lbCarType setTextAlignment:NSTextAlignmentCenter];
    //课程信息-班别
    lbTrainClassTime = [UILabel new];
    [lbTrainClassTime setFont:lbItemFont];
    [lbTrainClassTime setTextColor:LyBlackColor];
    [lbTrainClassTime setTextAlignment:NSTextAlignmentCenter];
    //课程信息-官方价
    lbOfficialPrice = [UILabel new];
    [lbOfficialPrice setFont:lbItemFont];
    [lbOfficialPrice setTextColor:LyBlackColor];
    [lbOfficialPrice setTextAlignment:NSTextAlignmentCenter];
    //课程信息-517价
    lbWhole517Price = [UILabel new];
    [lbWhole517Price setFont:lbItemFont];
    [lbWhole517Price setTextColor:LyBlackColor];
    [lbWhole517Price setTextAlignment:NSTextAlignmentCenter];
    
    
    [viewInfo addSubview:lbTitle_info];
    [viewInfo addSubview:lbWholeName];
    [viewInfo addSubview:lbFold];
    [viewInfo addSubview:lbCarType];
    [viewInfo addSubview:lbTrainClassTime];
    [viewInfo addSubview:lbOfficialPrice];
    [viewInfo addSubview:lbWhole517Price];
    
    
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[LyTrainClassDetailTableViewCell class] forCellReuseIdentifier:lyTrainClassDetailTvInfoCellReuseIdentifier];
    [self.tableView registerClass:[LyTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:lyTrainClassDetailTvHeaderFooterViewReuseIdentifier];
    [self.tableView setSectionFooterHeight:0];
    
    [self.tableView setTableHeaderView:viewInfo];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50.0f)]];
    
}


- (void)reloadViewData
{
    NSString *strLbTitle_info;
    NSRange rangeForNameMoreInfo = [[_trainClass tcName] rangeOfString:@"（"];
    if ( NSEqualRanges( rangeForNameMoreInfo, NSMakeRange( 0, 0)))
    {
        rangeForNameMoreInfo = [[_trainClass tcName] rangeOfString:@"("];
    }
    
    
    if ( rangeForNameMoreInfo.length > 0)
    {
        strLbTitle_info = [[_trainClass tcName] substringToIndex:rangeForNameMoreInfo.location];
    }
    else
    {
        strLbTitle_info = [_trainClass tcName];
    }
    
    self.title = strLbTitle_info;
    
    //课程信息
    //课程信息-标题
    [lbTitle_info setText:strLbTitle_info];
    //课程信息-名字
    CGSize sizeLbName = [[_trainClass tcName] sizeWithAttributes:@{NSFontAttributeName:lbItemFont}];
    [lbWholeName setFrame:CGRectMake( horizontalSpace, lbTitle_info.ly_y+CGRectGetHeight(lbTitle_info.frame)+verticalSpace, sizeLbName.width, lbItemHeight)];
    [lbWholeName setText:[_trainClass tcName]];
    //课程信息-优惠数
    NSString *strLbFoldTxt = [[NSString alloc] initWithFormat:@"省"];
    NSString *strLbFoldTmp = [[NSString alloc] initWithFormat:@"%@%.0f", strLbFoldTxt, [_trainClass tcOfficialPrice]-[_trainClass tc517WholePrice]];
    
    NSRange rangeFoldTxt = [strLbFoldTmp rangeOfString:strLbFoldTxt];
    CGSize sizeLbFold = [strLbFoldTmp sizeWithAttributes:@{NSFontAttributeName:lbItemFont}];
    
    NSMutableAttributedString *strLbFold = [[NSMutableAttributedString alloc] initWithString:strLbFoldTmp];
    [strLbFold addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeFoldTxt];
    [strLbFold addAttribute:NSBackgroundColorAttributeName value:Ly517ThemeColor range:rangeFoldTxt];
    
    [lbFold setFrame:CGRectMake( lbWholeName.frame.origin.x+CGRectGetWidth(lbWholeName.frame)+horizontalSpace*2, lbWholeName.ly_y+CGRectGetHeight(lbWholeName.frame)/2.0f-sizeLbFold.height/2.0f, sizeLbFold.width+2, sizeLbFold.height)];
    [lbFold setAttributedText:strLbFold];
    //课程信息-教练车型
    NSString *strLbCarName = [[NSString alloc] initWithFormat:@"车型：%@", [_trainClass tcCarName]];
    CGSize sizeLbCarName = [strLbCarName sizeWithAttributes:@{NSFontAttributeName:lbItemFont}];
    [lbCarType setFrame:CGRectMake( lbWholeName.frame.origin.x, lbWholeName.ly_y+CGRectGetHeight(lbWholeName.frame)+verticalSpace, sizeLbCarName.width, lbItemHeight)];
    [lbCarType setText:strLbCarName];
    //课程信息-班别
    NSString *strLbTime = [[NSString alloc] initWithFormat:@"班别：%@", [_trainClass tcTrainTime]];
    CGSize sizeLbTime = [strLbTime sizeWithAttributes:@{NSFontAttributeName:lbItemFont}];
    [lbTrainClassTime setFrame:CGRectMake( lbCarType.frame.origin.x+CGRectGetWidth(lbCarType.frame)+horizontalSpace*2.0f, lbCarType.ly_y, sizeLbTime.width, lbItemHeight)];
    [lbTrainClassTime setText:strLbTime];
    //课程信息-官方价
    NSString *strLbOfficialPrice = [[NSString alloc] initWithFormat:@"官方价：￥%.0f", [_trainClass tcOfficialPrice]];
    CGSize sizeLbOfficialPrice = [strLbOfficialPrice sizeWithAttributes:@{NSFontAttributeName:lbItemFont}];
    [lbOfficialPrice setFrame:CGRectMake( lbCarType.frame.origin.x, lbCarType.ly_y+CGRectGetHeight(lbCarType.frame)+verticalSpace, sizeLbOfficialPrice.width, lbItemHeight)];
    [lbOfficialPrice setText:strLbOfficialPrice];
    //课程信息-517价
    NSString *strLb517PriceNum = [[NSString alloc] initWithFormat:@"%.0f", [_trainClass tc517WholePrice]];
    NSString *strLb517PriceTmp = [[NSString alloc] initWithFormat:@"优惠价：%@", strLb517PriceNum];
    
    NSRange rangeLb517PriceNum = [strLb517PriceTmp rangeOfString:strLb517PriceNum];
    CGSize sizeLb517Price = [strLb517PriceTmp sizeWithAttributes:@{NSFontAttributeName:lbItemFont}];
    
    NSMutableAttributedString *strLb517Price = [[NSMutableAttributedString alloc] initWithString:strLb517PriceTmp];
    [strLb517Price addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:rangeLb517PriceNum];
    
    [lbWhole517Price setFrame:CGRectMake( lbOfficialPrice.frame.origin.x+CGRectGetWidth(lbOfficialPrice.frame)+horizontalSpace*2.0f, lbOfficialPrice.ly_y, sizeLb517Price.width, lbItemHeight)];
    [lbWhole517Price setAttributedText:strLb517Price];
    
    
    
    [self.tableView reloadData];
    [self.tableView layoutSubviews];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    if (trainClassDetailBarButtonItemTag_delete == bbi.tag) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[[NSString alloc] initWithFormat:@"确定删除「%@」课程吗？", _trainClass.tcName]
                                                                       message:nil
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


- (void)delete {
    if (!indicator_oper) {
        indicator_oper = [LyIndicator indicatorWithTitle:LyIndicatorTitle_delete];
    }
    else {
        [indicator_oper setTitle:LyIndicatorTitle_delete];
    }
    [indicator_oper startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:trainClassDetailHttpMethod_delete];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:deleteTrainClass_url
                                 body:@{
                                        trainClassIdKey:_trainClass.tcId,
                                        userIdKey:[LyCurrentUser curUser].userId,
                                        sessionIdKey:[LyUtil httpSessionId],
                                        userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                        }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)handleHttpFailed {
    if (indicator_oper.isAnimating) {
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
        [indicator_oper stopAnimation];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_oper stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch (curHttpMethod) {
        case trainClassDetailHttpMethod_delete: {
            switch ([strCode integerValue]) {
                case 0: {
                    [[LyTrainClassManager sharedInstance] removeTrainClassWithId:_trainClass.tcId];
                    
                    [indicator_oper stopAnimation];
                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"删除成功"];
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
- (void)remindViewDidHide:(LyRemindView *)aRemind {
    [_delegate onDeleteByTrainClassByTrainClassDetailTVC:self];
}




#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section && 1 == indexPath.row) {
        return tcdcellHeight*2;
    }
    else
    {
        return tcdcellHeight;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return LyTableViewHeaderFooterViewHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LyTableViewHeaderFooterView *hfView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:lyTrainClassDetailTvHeaderFooterViewReuseIdentifier];
    
    if (!hfView)
    {
        hfView = [[LyTableViewHeaderFooterView alloc] initWithReuseIdentifier:lyTrainClassDetailTvHeaderFooterViewReuseIdentifier];
    }
    
    NSString *strConetnt;
    if (0 == section) {
        strConetnt = @"费用明细";
    } else if (1 == section) {
        strConetnt = @"培训服务";
    } else {
        strConetnt = @"";
    }
    
    [hfView setContent:strConetnt];
    
    return hfView;
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section)
    {
        return 2;
    }
    else if (1 == section)
    {
        return 6;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyTrainClassDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyTrainClassDetailTvInfoCellReuseIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[LyTrainClassDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyTrainClassDetailTvInfoCellReuseIdentifier];
    }
    
    if (0 == indexPath.section)
    {
        switch (indexPath.row) {
            case 0: {
                [cell setCellInfo:@"总学费" content:[[NSString alloc] initWithFormat:@"%.0f元", _trainClass.tc517WholePrice]];
                break;
            }
            case 1: {
                [cell setCellInfo:@"包含" content:_trainClass.tcInclude];
                break;
            }
            default:
                break;
        }
    } else if (1 == indexPath.section) {
        switch (indexPath.row) {
            case 0: {
                [cell setCellInfo:@"驾照类型" content:[LyUtil driveLicenseStringFrom:_trainClass.tcLicenseType]];
                break;
            }
            case 1: {
                [cell setCellInfo:@"教练车型" content:_trainClass.tcCarName];
                break;
            }
            case 2: {
                [cell setCellInfo:@"排队时间" content:[[NSString alloc] initWithFormat:@"%i天", _trainClass.tcWaitDays]];
                break;
            }
            case 3: {
                [cell setCellInfo:@"学车课程" content:[[NSString alloc] initWithFormat:@"科二：%d课时  科三：%d课时", _trainClass.tcObjectPeriod.secondPeriod, _trainClass.tcObjectPeriod.thirdPeriod]];
                break;
            }
            case 4: {
                [cell setCellInfo:@"接送方式" content:[LyUtil pickTypeStringFrom:_trainClass.tcPickType]];
                break;
            }
            case 5: {
                [cell setCellInfo:@"练车方式" content:[LyUtil trainModeStringFrom:_trainClass.tcTrainMode]];
                break;
            }
            default:
                break;
        }
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
