//
//  LyAddGuiderTableViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/17.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyAddGuiderTableViewController.h"
#import "LyChooseTableViewCell.h"

#import "LyAddressPicker.h"
#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyGuider.h"
#import "LyCurrentUser.h"

#import "LyUtil.h"

#import "LyChooseGuiderTableViewController.h"



typedef  NS_ENUM( NSInteger, LyAddGuiderHttpMethod)
{
    addGuiderHttpMethod_commit = 1,
    addGuiderHttpMethod_replace
};



NSString * const lyAddGuiderTableViewCellReuseIdentifier = @"lyAddGuiderTableViewCellReuseIdentifier";


@interface LyAddGuiderTableViewController () <LyHttpRequestDelegate, LyChooseGuiderTableViewControllerDelegate, LyAddressPickerDelegate, LyRemindViewDelegate>
{
    UIBarButtonItem             *barBtnItemRight;
    
    LyIndicator                 *indicator_oper;
    
    NSIndexPath                 *curIdx;
    NSString                    *curAddress;
    LyGuider                    *curGuider;
    
    LyAddGuiderHttpMethod       curHttpMethod;
    BOOL                        bHttpFlag;
}
@end

@implementation LyAddGuiderTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"添加指导员";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    barBtnItemRight = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(targetForRightBarButton:)];
    [self.navigationItem setRightBarButtonItem:barBtnItemRight];
    
    [self.tableView registerClass:[LyChooseTableViewCell class] forCellReuseIdentifier:lyAddGuiderTableViewCellReuseIdentifier];
    [self.tableView setTableFooterView:[UIView new]];
}



- (void)viewWillAppear:(BOOL)animated
{
    if ( [_delegate respondsToSelector:@selector(obtainModeByAddGuiderTableViewController:)])
    {
        _mode = [_delegate obtainModeByAddGuiderTableViewController:self];
    }
    
    
    switch ( _mode) {
        case LyAddTeacherMode_add: {
            [barBtnItemRight setTitle:@"添加"];
            self.title = @"添加指导员";
            break;
        }
        case LyAddTeacherMode_replace: {
            [barBtnItemRight setTitle:@"更换"];
            self.title = @"更换指导员";
            break;
        }
    }
}


- (void)targetForRightBarButton:(UIBarButtonItem *)barBtnItem {
    [self addGuider];
}


- (void)addGuider {
    
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(addGuider) object:nil];
        return;
    }
    
    NSArray *arrAddress = [LyUtil separateString:curAddress separator:@" "];
    if (!arrAddress || arrAddress.count < 2) {
        [[LyRemindView remindWithMode: LyRemindViewMode_fail withTitle:@"地址格式错误"] show];
        return;
    }
    if ( !curGuider) {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"你还没有选择指导员"] show];
        return;
    }
    
    if ( [[curGuider userId] isEqualToString:[[LyCurrentUser curUser] userGuiderId]]) {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"你并没有选择新的指导员"] show];
        return;
    }
    
    
    if ( !indicator_oper) {
        indicator_oper = [[LyIndicator alloc] initWithTitle:LyIndicatorTitle_commit];
    }
    [indicator_oper startAnimation];
    
    LyHttpRequest *httpReqeust;
    NSString *strUrl;
    switch ( _mode) {
        case LyAddTeacherMode_add: {
            [indicator_oper setTitle:LyIndicatorTitle_commit];
            httpReqeust = [LyHttpRequest httpRequestWithMode:addGuiderHttpMethod_commit];
            strUrl = addMyTeacher_url;
            break;
        }
        case LyAddTeacherMode_replace: {
            [indicator_oper setTitle:LyIndicatorTitle_replace];
            httpReqeust = [LyHttpRequest httpRequestWithMode:addGuiderHttpMethod_replace];
            strUrl = replaceTeacher_url;
            break;
        }
    }
    [indicator_oper startAnimation];
    [httpReqeust setDelegate:self];
    
    NSString *strAddress = [arrAddress objectAtIndex:1];
    strAddress = [strAddress substringToIndex:strAddress.length-1];
    
    bHttpFlag = [[httpReqeust startHttpRequest:strUrl
                                          body:@{
                                                 userTypeKey:userTypeGuiderKey,
                                                 cityKey:strAddress,
                                                 objectIdKey:[curGuider userId],
                                                 userIdKey:[[LyCurrentUser curUser] userId],
                                                 sessionIdKey:[LyUtil httpSessionId]
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}


- (void)handleHttpFailed {
    if ( [indicator_oper isAnimating]) {
        [indicator_oper stopAnimation];
        NSString *str;
        if ( [[indicator_oper title] isEqualToString:LyIndicatorTitle_commit]) {
            str = @"添加失败";
        } else if ( [[indicator_oper title] isEqualToString:LyIndicatorTitle_replace]) {
            str = @"更换失败";
        }
        
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:str] show];
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
        
        [LyUtil sessionTimeOut:self];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_oper stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    
    switch ( curHttpMethod) {
        case addGuiderHttpMethod_commit: {
            switch ( [strCode integerValue]) {
                case 0: {
                    [indicator_oper stopAnimation];
                    LyRemindView *remindSuccess = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"添加成功"];
                    [remindSuccess setDelegate:self];
                    [remindSuccess show];;
                    break;
                }
                case 3: {
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"当前城市未开通自学直考"] show];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case addGuiderHttpMethod_replace: {
            switch ( [strCode integerValue]) {
                case 0: {
                    [indicator_oper stopAnimation];
                    LyRemindView *remindSuccess = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"更换成功"];
                    [remindSuccess setDelegate:self];
                    [remindSuccess show];;
                    break;
                }
                case 3: {
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"当前城市未开通自学直考"] show];
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



#pragma mark -LyHttpRequest
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest
{
    if ( bHttpFlag) {
        bHttpFlag = NO;
        [self handleHttpFailed];
    }
    
    curHttpMethod = 0;
}

- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result
{
    if ( bHttpFlag)
    {
        bHttpFlag = NO;
        curHttpMethod = ahttpRequest.mode;
        [self analysisHttpResult:result];
    }
    
    curHttpMethod = 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(UIView *)view
{
    [_delegate addGuiderFinishedByAddGuiderTableViewController:self andGuider:curGuider];
}


#pragma mark -LyAddressPickerDelegate
- (void)onAddressPickerCancel:(LyAddressPicker *)addressPicker
{
    [addressPicker hide];
}


- (void)onAddressPickerDone:(NSString *)address addressPicker:(LyAddressPicker *)addressPicker
{
    [addressPicker hide];
    curAddress = address;
    
    [self.tableView reloadRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationLeft];
}


#pragma mark -LyChooseGuiderTableViewControllerDelegate
- (NSString *)obtainAddressByChooseGuiderTableViewController:(LyChooseGuiderTableViewController *)aChooseGuider
{
    return curAddress;
}

- (void)onSelectedGuiderByChooseGuiderTableViewController:(LyChooseGuiderTableViewController *)aChooseGuider andGuider:(LyGuider *)guider
{
    [aChooseGuider.navigationController popViewControllerAnimated:YES];
    curGuider = guider;
    
    [self.tableView reloadRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationLeft];
}







#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return chsecellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    curIdx = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ( 0 == [indexPath row])
    {
        LyAddressPicker *addressPicker = [LyAddressPicker addressPickerWithMode:LyAddressPickerMode_provinceAndCity];
        [addressPicker setDelegate:self];
        [addressPicker show];
    }
    else if ( 1 == [indexPath row])
    {
        if ( !curAddress || [curAddress isKindOfClass:[NSNull class]] || [curAddress length] < 1)
        {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"你还没有选择地区"] show];
        }
        else
        {
            LyChooseGuiderTableViewController *chooseGuider = [[LyChooseGuiderTableViewController alloc] init];
            [chooseGuider setDelegate:self];
            [self.navigationController pushViewController:chooseGuider animated:YES];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyAddGuiderTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    if ( !cell) {
        cell = [[LyChooseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyAddGuiderTableViewCellReuseIdentifier];
    }
    
    switch (indexPath.row) {
        case 0: {
            [cell setCellInfo:@"地址" detail:(curAddress) ? curAddress : @"请选择地址"];
            break;
        }
        case 1: {
            [cell setCellInfo:@"指导员" detail:(curGuider) ? curGuider.userName : @"请选择指导员"];
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
