//
//  LyAddCoachTableViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/17.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyAddCoachTableViewController.h"
#import "LyChooseTableViewCell.h"


#import "LyAddressPicker.h"
#import "LyIndicator.h"
#import "LyRemindView.h"


#import "LyCurrentUser.h"
#import "LyUserManager.h"
#import "LyCoach.h"


#import "LyUtil.h"


#import "LyChooseSchoolTableViewController.h"
#import "LyChooseCoachTableViewController.h"


typedef NS_ENUM( NSInteger, LyAddCoachHttpMethod)
{
    addCoachHttpMethod_commit = 1,
    addCoachHttpMethod_replace
};


NSString *const lyAddCoachTableViewCellReuseIdentifier = @"lyAddCoachTableViewCellReuseIdentifier";


@interface LyAddCoachTableViewController () <LyAddressPickerDelegate, LyHttpRequestDelegate, LyChooseSchoolTableViewControllerDelegate, LyChooseCoachTableViewControllerDelegate, LyRemindViewDelegate>
{
    UIBarButtonItem             *barBtnItemRight;
    
    LyIndicator                 *indicator_oper;
    
    NSArray                     *arrTvAddItems;
    
    NSIndexPath                 *curIdx;
    NSString                    *curAddress;
    LyDriveSchool               *curSchool;
    LyCoach                     *curCoach;
    
    LyAddCoachHttpMethod       curHttpMethod;
    BOOL                        bHttpFlag;
}
@end

@implementation LyAddCoachTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"添加教练";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    barBtnItemRight = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(targetForRightBarButton:)];
    [self.navigationItem setRightBarButtonItem:barBtnItemRight];
    
    [self.tableView registerClass:[LyChooseTableViewCell class] forCellReuseIdentifier:lyAddCoachTableViewCellReuseIdentifier];
    [self.tableView setTableFooterView:[UIView new]];
}



- (void)viewWillAppear:(BOOL)animated
{
    if ( [_delegate respondsToSelector:@selector(obtainModeByAddCoachTableViewController:)]) {
        _mode = [_delegate obtainModeByAddCoachTableViewController:self];
    }
    
    
    switch ( _mode) {
        case LyAddTeacherMode_add: {
            self.title = @"添加教练";
            [barBtnItemRight setTitle:@"添加"];
            break;
        }
        case LyAddTeacherMode_replace: {
            self.title = @"更换教练";
            [barBtnItemRight setTitle:@"更换"];
            break;
        }
    }
}



- (void)targetForRightBarButton:(UIBarButtonItem *)barBtnItem {
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(targetForRightBarButton:) object:barBtnItem];
        return;
    }
    
    if ( !curCoach) {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"你还没有选择教练"] show];
        return;
    }
    
    if ( [[curCoach userId] isEqualToString:[[LyCurrentUser curUser] userCoachId]]) {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"你并没有选择新的教练"] show];
        return;
    }
    
    if ( !indicator_oper)
    {
        indicator_oper = [[LyIndicator alloc] initWithTitle:LyIndicatorTitle_commit];
    }
    LyHttpRequest *httpReqeust;
    NSString *strUrl;
    switch ( _mode) {
        case LyAddTeacherMode_add: {
            [indicator_oper setTitle:LyIndicatorTitle_commit];
            httpReqeust = [LyHttpRequest httpRequestWithMode:addCoachHttpMethod_commit];
            strUrl = addMyTeacher_url;
            break;
        }
        case LyAddTeacherMode_replace: {
            [indicator_oper setTitle:LyIndicatorTitle_replace];
            httpReqeust = [LyHttpRequest httpRequestWithMode:addCoachHttpMethod_replace];
            strUrl = replaceTeacher_url;
            break;
        }
    }
    [indicator_oper startAnimation];
    [httpReqeust setDelegate:self];
    
    
    bHttpFlag = [[httpReqeust startHttpRequest:strUrl
                                          body:@{
                                                 userTypeKey:userTypeCoachKey,
                                                 objectIdKey:[curCoach userId],
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
        case addCoachHttpMethod_commit: {
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
        case addCoachHttpMethod_replace: {
            curHttpMethod = 0;
            
            switch ( [strCode integerValue]) {
                case 0: {
                    [[LyCurrentUser curUser] setUserTrainClassId:nil];
                    
                    [indicator_oper stopAnimation];
                    LyRemindView *remindSuccess = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"更换成功"];
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
        default: {
            [self handleHttpFailed];
            break;
        }
    }
    
}


#pragma mark -LyHttpRequest
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest {
    if ( bHttpFlag) {
        bHttpFlag = NO;
        [self handleHttpFailed];
    }
    
    curHttpMethod = 0;
}

- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result {
    if ( bHttpFlag) {
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
    [_delegate addCoachFinishedByAddCoachTableViewController:self andCoach:curCoach];
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



#pragma mark -LyChooseSchoolTableViewControllerDelegate
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




#pragma mark -LyChooseCoachTableViewControllerDelegate
- (NSString *)obtainDriveSchoolIdByChooseCoachTableViewController:(LyChooseCoachTableViewController *)aChooseCoachTableViewController
{
    return [curSchool userId];
}

- (void)onSelectedCoachByChooseCoachTableViewController:(LyChooseCoachTableViewController *)aChooseCoachTableViewController andCoach:(LyCoach *)coach
{
    [aChooseCoachTableViewController.navigationController popViewControllerAnimated:YES];
    
    curCoach = coach;
    
    [self.tableView reloadRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationLeft];
}





#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return chsecellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        if ( !curAddress || [curAddress isKindOfClass:[NSNull class]] || [curAddress length] < 1) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"你还没有选择地址"] show];
        }
        else {
            LyChooseSchoolTableViewController *chooseSchool = [[LyChooseSchoolTableViewController alloc] init];
            [chooseSchool setDelegate:self];
            [self.navigationController pushViewController:chooseSchool animated:YES];
        }
    }
    else if ( 2 == [indexPath row])
    {
        if ( !curAddress || [curAddress isKindOfClass:[NSNull class]] || [curAddress length] < 1) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"你还没有选择地址"] show];
        }
        else if ( !curSchool) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"你还没有选择驾校"] show];
        }
        else {
            LyChooseCoachTableViewController *chooseCoach = [[LyChooseCoachTableViewController alloc] init];
            [chooseCoach setDelegate:self];
            [self.navigationController pushViewController:chooseCoach animated:YES];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyAddCoachTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    if ( !cell) {
        cell = [[LyChooseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyAddCoachTableViewCellReuseIdentifier];
    }
    
    switch (indexPath.row) {
        case 0: {
            [cell setCellInfo:@"地址" detail:(curAddress) ? curAddress : @"请选择地址"];
            break;
        }
        case 1: {
            [cell setCellInfo:@"所属驾校" detail:(curSchool) ? curSchool.userName : @"请选择所属驾校"];
            break;
        }
        case 2: {
            [cell setCellInfo:@"教练" detail:(curCoach) ? curCoach.userName : @"请选择教练"];
            break;
        }
        default:
            break;
    }
//    [cell setCellInfo:(LyChooseTableViewCellMode_addressForCoach+[indexPath row]) andDetail:@""];
    
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
