//
//  LyAddTrainBaseTableViewController.m
//  teacher
//
//  Created by Junes on 16/9/5.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyAddTrainBaseTableViewController.h"
#import "LyUserInfoTableViewCell.h"

#import "LyAddressPicker.h"
#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyTrainBase.h"

#import "UILabel+LyTextAlignmentLeftAndRight.h"

#import "LyUtil.h"



#import "LyChooseTrainBaseTableViewController.h"


enum {
    addTrainBaseBarButtonItemTag_add = 0,
}LyAddTrainBaseBarButtonItemTag;


typedef NS_ENUM(NSInteger, LyAddTrainBaseHttpMethod) {
    addTrainBaseHttpMethod_add = 100,
};



@interface LyAddTrainBaseTableViewController () <LyAddressPickerDelegate, LyChooseTrainBaseTableViewControllerDelegate, LyHttpRequestDelegate, LyRemindViewDelegate>
{
    UIBarButtonItem             *bbiAdd;
    
    
    NSString                    *curAddress;
    
    NSArray                     *arrTrainBase;
    NSIndexPath                 *curIdx;
    
    
    LyIndicator                 *indicator_add;
    BOOL                        bHttpFlag;
    LyAddTrainBaseHttpMethod    curHttpMethod;
}
@end

@implementation LyAddTrainBaseTableViewController

static NSString *const lyAddTrainBaseTvItemsCellReuseIdentifier = @"lyAddTrainBaseTvItemsCellReuseIdentifier";
static int const addTrainBaseTvItemsRowNumber = 2;

static NSString *remindTitleSuccess = @"添加成功";
static NSString *remindTitleFail = @"添加失败";




- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
//    [self setMode:_mode];
    bbiAdd = [[UIBarButtonItem alloc] initWithTitle:@"添加"
                                              style:UIBarButtonItemStyleDone
                                             target:self
                                             action:@selector(targetForBarButtonItem:)];
    [bbiAdd setTag:addTrainBaseBarButtonItemTag_add];
    [self.navigationItem setRightBarButtonItem:bbiAdd];
    
    
    [self.tableView registerClass:[LyUserInfoTableViewCell class] forCellReuseIdentifier:lyAddTrainBaseTvItemsCellReuseIdentifier];
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView setRowHeight:ucicHeight];
    
    [bbiAdd setEnabled:NO];
}


- (void)viewWillAppear:(BOOL)animated {
    arrTrainBase = [_delegate trainBaseInfoByAddTrainBaseTVC:self];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    if (addTrainBaseBarButtonItemTag_add == bbi.tag) {
        [self add];
    }
}



- (BOOL)validate:(BOOL)flag {
    [bbiAdd setEnabled:NO];
    
    if (!curAddress) {
        if (flag){
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没有选择地址"] show];
        }
        return NO;
    }
    
    if (!_trainBase) {
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没有选择地址"] show];
        }
        return NO;
    }
    
    [bbiAdd setEnabled:YES];
    
    return YES;
}



- (void)add {
    if (![self validate:YES]) {
        return;
    }
    
    if (!indicator_add) {
        indicator_add = [LyIndicator indicatorWithTitle:LyIndicatorTitle_add];
    }
    else {
        [indicator_add setTitle:LyIndicatorTitle_add];
    }
    
    [indicator_add startAnimation];
    
    NSMutableString *strTrainBsse = [[NSMutableString alloc] initWithString:@""];
    for (LyTrainBase *trainBase in arrTrainBase) {
        if (!trainBase || ![LyUtil validateString:trainBase.tbId]) {
            continue;
        }
        
        [strTrainBsse appendFormat:@"%@,", trainBase.tbId];
    }
    
    [strTrainBsse appendFormat:@"%@,", _trainBase.tbId];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[[LyCurrentUser curUser] userTypeByString] forKey:userTypeKey];
    [dic setObject:strTrainBsse forKey:trainBaseIdKey];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    if (LyUserType_school == [LyCurrentUser curUser].userType) {
        [dic setObject:[LyCurrentUser curUser].userId forKey:schoolIdKey];
    }
    else if (LyUserType_coach == [LyCurrentUser curUser].userType) {
        [dic setObject:[LyCurrentUser curUser].userId forKey:coachIdKey];
    }
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:addTrainBaseHttpMethod_add];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:operateTrainBase_url
                                 body:dic
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)handleHttpFailed {
    if ([indicator_add isAnimating]) {
        [indicator_add stopAnimation];
        LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:remindTitleFail];
        [remind show];
    }
}



- (void)analysisHttpResult:(NSString *)result {
    NSDictionary *dic = [LyUtil getObjFromJson:result];
    if (!dic || ![LyUtil validateDictionary: dic]) {
        [self handleHttpFailed];
        return;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (!strCode || ![LyUtil validateString:strCode]) {
        [self handleHttpFailed];
        return;
    }
    
    if (codeTimeOut == [strCode integerValue]) {
        [indicator_add stopAnimation];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_add stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    switch (curHttpMethod) {
        case addTrainBaseHttpMethod_add: {
            switch ([strCode integerValue]) {
                case 0: {
                    [indicator_add stopAnimation];
                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:remindTitleSuccess];
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


#pragma mark -LyHttpRequest 
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest {
    if (bHttpFlag) {
        bHttpFlag = NO;
        [self handleHttpFailed];
    }
    
    curHttpMethod = 0;
}


- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result {
    if (bHttpFlag) {
        bHttpFlag = 0;
        curHttpMethod = ahttpRequest.mode;
        [self analysisHttpResult:result];
    }
}



#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(LyRemindView *)aRemind {
    [_delegate onDoneByAddTrainBaseTVC:self trainBase:_trainBase];
}



#pragma mark -LyAddressPickerDelegate
- (void)onAddressPickerCancel:(LyAddressPicker *)addressPicker {
    [addressPicker hide];
}


- (void)onAddressPickerDone:(NSString *)address addressPicker:(LyAddressPicker *)addressPicker {
    [addressPicker hide];
    
    if (![curAddress isEqualToString:address]) {
        curAddress = address;
        [self.tableView reloadRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationLeft];
    }
    
    [self validate:NO];
}


#pragma mark -LyChooseTrainBaseTableViewControllerDelegate
- (NSString *)obtainAddressByChooseTrainBaseTVC:(LyChooseTrainBaseTableViewController *)aChooseTrainBaseTVC {
    return curAddress;
}

- (NSString *)obtainSchoolIdByChooseTrainBaseTVC:(LyChooseTrainBaseTableViewController *)aChooseTrainBaseTVC {
//    NSString *strSchoolId;
//    if (LyUserType_school == [LyCurrentUser curUser].userType) {
//        strSchoolId = [LyCurrentUser curUser].userId;
//    } else {
////        strSchoolId = curSchool.userId;
//    }
//    
    return [LyCurrentUser curUser].userId;
}

//- (NSDictionary *)obtainInfoByChooseTrainBaseTVC:(LyChooseTrainBaseTableViewController *)aChooseTrainBaseTVC {
//    return @{
//             addressKey:curAddress,
//             schoolIdKey:[LyCurrentUser curUser].userId
//             };
//}

- (void)onDoneByChooseTrainBase:(LyChooseTrainBaseTableViewController *)aChooseTrainBaseVC trainBase:(LyTrainBase *)aTrainBase {
    [aChooseTrainBaseVC.navigationController popViewControllerAnimated:YES];
    
    if (aTrainBase && ![aTrainBase isEqual:_trainBase]) {
        _trainBase = aTrainBase;
        
        [self.tableView reloadRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationLeft];
    }
    
    [self validate:NO];
}



#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    curIdx = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (0 == indexPath.row) {
        LyAddressPicker *addressPicker = [LyAddressPicker addressPickerWithMode:LyAddressPickerMode_provinceAndCity];
        [addressPicker setDelegate:self];
        [addressPicker setAddress:curAddress];
        [addressPicker show];
    }
    else if (1 == indexPath.row) {
        
        if (!curAddress || ![LyUtil validateString:curAddress]) {
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没有选择地址"] show];
            return;
        }
        
        LyChooseTrainBaseTableViewController *chooseTrainBase = [[LyChooseTrainBaseTableViewController alloc] init];
        [chooseTrainBase setDelegate:self];
        [self.navigationController pushViewController:chooseTrainBase animated:YES];
    }
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return addTrainBaseTvItemsRowNumber;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyAddTrainBaseTvItemsCellReuseIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[LyUserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyAddTrainBaseTvItemsCellReuseIdentifier];
    }
    
    switch (indexPath.row) {
        case 0: {
            [cell setCellInfo:@"城市"
                       detail:(curAddress) ? curAddress : @"请选择城市"
                         icon:nil];
            break;
        }
        case 1: {
            [cell setCellInfo:@"基地"
                       detail:(_trainBase) ? _trainBase.tbName : @"请选择基地"
                         icon:nil];
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
