//
//  LyAddSchoolTableViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/17.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyAddSchoolTableViewController.h"
#import "LyChooseTableViewCell.h"


#import "LyAddressPicker.h"
#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyDriveSchool.h"
#import "LyCurrentUser.h"

#import "LyMacro.h"

#import "LyChooseSchoolTableViewController.h"




typedef NS_ENUM( NSInteger, LyAddSchoolHttpMethod)
{
    addSchoolHttpMethod_commit = 43,
    addSchoolHttpMethod_replace
};


NSString * const lyAddSchoolTableViewCellReuseIdentifier = @"lyAddSchoolTableViewCellReuseIdentifier";


@interface LyAddSchoolTableViewController () <LyHttpRequestDelegate, LyChooseSchoolTableViewControllerDelegate, LyAddressPickerDelegate, LyRemindViewDelegate>
{
    UIBarButtonItem             *barBtnItemRight;
    
    LyIndicator                 *indicator_oper;
    
    NSIndexPath                 *curIdx;
    NSString                    *curAddress;
    LyDriveSchool               *curSchool;
    
    
    LyAddSchoolHttpMethod       curHttpMethod;
    BOOL                        bHttpFlag;
}
@end

@implementation LyAddSchoolTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
//     self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"添加驾校";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    barBtnItemRight = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(targetForRightBarButton:)];
    [self.navigationItem setRightBarButtonItem:barBtnItemRight];
    
    [self.tableView registerClass:[LyChooseTableViewCell class] forCellReuseIdentifier:lyAddSchoolTableViewCellReuseIdentifier];
    [self.tableView setTableFooterView:[UIView new]];
}



- (void)viewWillAppear:(BOOL)animated
{
    if ( [_delegate respondsToSelector:@selector(obtainModeViewControllerModeByAddSchoolTableViewController:)]) {
        _mode = [_delegate obtainModeViewControllerModeByAddSchoolTableViewController:self];
    }
    
    
    switch ( _mode) {
        case LyAddTeacherMode_add: {
            self.title = @"添加驾校";
            [barBtnItemRight setTitle:@"添加"];
            break;
        }
        case LyAddTeacherMode_replace: {
            self.title = @"更换驾校";
            [barBtnItemRight setTitle:@"更换"];
            break;
        }
    }
    
    
}




- (void)targetForRightBarButton:(UIBarButtonItem *)barBtnItem {
    [self addSchool];
}


- (void)addSchool {

    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(addSchool) object:nil];
        return;
    }
    
    if ( !curSchool) {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"你还没有选择驾校"] show];
        return;
    }
    
    if ( [[curSchool userId] isEqualToString:[[LyCurrentUser curUser] userDriveSchoolId]]) {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"你并没有选择新的驾校"] show];
        return;
    }
    
    
    if ( !indicator_oper) {
        indicator_oper = [[LyIndicator alloc] initWithTitle:LyIndicatorTitle_commit];
    }
    LyHttpRequest *httpReqeust;
    NSString *strUrl;
    switch ( _mode) {
        case LyAddTeacherMode_add: {
            [indicator_oper setTitle:LyIndicatorTitle_commit];
            httpReqeust = [LyHttpRequest httpRequestWithMode:addSchoolHttpMethod_commit];
            strUrl = addMyTeacher_url;
            break;
        }
        case LyAddTeacherMode_replace: {
            [indicator_oper setTitle:LyIndicatorTitle_replace];
            httpReqeust = [LyHttpRequest httpRequestWithMode:addSchoolHttpMethod_replace];
            strUrl = replaceTeacher_url;
            break;
        }
    }
    
    [indicator_oper startAnimation];
    [httpReqeust setDelegate:self];
    
    
    bHttpFlag = [[httpReqeust startHttpRequest:strUrl
                                          body:@{
                                                 userTypeKey:userTypeSchoolKey,
                                                 objectIdKey:[curSchool userId],
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


- (void)analysisHttpResult:(NSString *)result
{
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
        case addSchoolHttpMethod_commit: {
            switch ( [strCode integerValue]) {
                case 0: {
                    [[LyCurrentUser curUser] setUserTrainClassId:nil];
                    
                    [indicator_oper stopAnimation];
                    LyRemindView *remindSuccess = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"添加成功"];
                    [remindSuccess setDelegate:self];
                    [remindSuccess show];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            
            break;
        }
        case addSchoolHttpMethod_replace: {
            switch ( [strCode integerValue]) {
                case 0: {
                    [[LyCurrentUser curUser] setUserTrainClassId:nil];
                    
                    [indicator_oper stopAnimation];
                    LyRemindView *remindSuccess = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"更换成功"];
                    [remindSuccess setDelegate:self];
                    [remindSuccess show];;
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if ( bHttpFlag) {
        bHttpFlag = NO;
        curHttpMethod = ahttpRequest.mode;
        [self analysisHttpResult:result];
    }
    
    curHttpMethod = 0;
}



#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(UIView *)view
{
    [_delegate addSchoolFinishedByAddSchoolTableViewController:self andDriveSchool:curSchool];
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



#pragma mark -LySchoolTableViewControllerDelegate
- (NSString *)obtainAddressInfoByChooseSchoolTableViewController:(LyChooseSchoolTableViewController *)aChooseSchoolTableViewContoller
{
    return curAddress;
}


- (void)onSelectedDriveSchoolByChooseSchoolTableViewController:(LyChooseSchoolTableViewController *)aChooseSchoolTableViewContoller andSchool:(LyDriveSchool *)dsch
{
    [aChooseSchoolTableViewContoller.navigationController popViewControllerAnimated:YES];
    
    curSchool = dsch;
    
    [self.tableView reloadRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationLeft];
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return chsecellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    curIdx = indexPath;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ( 0 == [indexPath row]) {
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
        else {
            LyChooseSchoolTableViewController *chooseSchool = [[LyChooseSchoolTableViewController alloc] init];
            [chooseSchool setDelegate:self];
            [self.navigationController pushViewController:chooseSchool animated:YES];
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
    LyChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyAddSchoolTableViewCellReuseIdentifier forIndexPath:indexPath];
    if ( !cell) {
        cell = [[LyChooseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyAddSchoolTableViewCellReuseIdentifier];
    }
    switch (indexPath.row) {
        case 0: {
            [cell setCellInfo:@"地址" detail:(curAddress) ? curAddress : @"请选择地址"];
            break;
        }
        case 1: {
            [cell setCellInfo:@"驾校" detail:(curSchool) ? curSchool.userName : @"请选择驾校"];
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
