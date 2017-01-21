//
//  LyUpdateCoachTrainBaseTableViewController.m
//  teacher
//
//  Created by Junes on 16/9/7.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyUpdateCoachTrainBaseTableViewController.h"
#import "LyUserInfoTableViewCell.h"

#import "LyAddressPicker.h"
#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyDriveSchool.h"
#import "LyCoach.h"
#import "LyTrainBase.h"

#import "UILabel+LyTextAlignmentLeftAndRight.h"

#import "LyUtil.h"

#import "LyChooseSchoolTableViewController.h"
#import "LyChooseTrainBaseTableViewController.h"

typedef enum : NSUInteger {
    updateCoachTrainBaseBarButtonItemTag_update = 0,
} LyUpdateCoachTrainBaseBarButtonItemTag;


typedef NS_ENUM(NSInteger, LyUpdateCoachTrainBaseHttpMethod) {
    updateCoachTrainBaseHttpMethod_update = 100,
};


@interface LyUpdateCoachTrainBaseTableViewController () <LyAddressPickerDelegate, LyChooseSchoolTableViewControllerDelegate, LyChooseTrainBaseTableViewControllerDelegate, LyHttpRequestDelegate, LyRemindViewDelegate>
{
    NSString                    *curAddress;
    LyDriveSchool               *curSchool;
    LyCoach                     *curCoach;
    
    
    NSIndexPath                 *curIdx;
    
    
    LyIndicator                 *indicator_update;
    BOOL                        bHttpFlag;
    LyUpdateCoachTrainBaseHttpMethod    curHttpMethod;
}
@end

@implementation LyUpdateCoachTrainBaseTableViewController

static NSString *const lyUpdateCoachTrainBaseRvItemsCellReuseIdentifier = @"lyUpdateCoachTrainBaseRvItemsCellReuseIdentifier";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    
    self.title = @"更换基地";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    UIBarButtonItem *bbiUpdate = [[UIBarButtonItem alloc] initWithTitle:@"更换"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(targetForBarButtonItem:)];
    [bbiUpdate setTag:updateCoachTrainBaseBarButtonItemTag_update];
    [self.navigationItem setRightBarButtonItem:bbiUpdate];
    
    if (LyUserType_school == [LyCurrentUser curUser].userType) {
        curSchool = (LyDriveSchool *)[LyCurrentUser curUser];
    }
    
    [self.tableView registerClass:[LyUserInfoTableViewCell class] forCellReuseIdentifier:lyUpdateCoachTrainBaseRvItemsCellReuseIdentifier];
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView setRowHeight:ucicHeight];
}


- (void)viewWillAppear:(BOOL)animated {
    curCoach = [_delegate obtainCoachByUpdateCoachTrainBaseTVC:self];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    if (updateCoachTrainBaseBarButtonItemTag_update == bbi.tag) {
        [self update];
    }
}


- (void)update {
    if (!indicator_update) {
        indicator_update = [LyIndicator indicatorWithTitle:@"正在更换"];
    } else  {
        [indicator_update setTitle:@"正在更换"];
    }
    
    [indicator_update startAnimation];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[LyCurrentUser curUser].userId forKey:userIdKey];
    [dic setObject:curCoach.userId forKey:objectIdKey];
    [dic setObject:[_trainBase.tbId stringByAppendingString:@","] forKey:trainBaseIdKey];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    
    if (LyUserType_school == [LyCurrentUser curUser].userType) {
        [dic setObject:schoolIdKey forKey:masterKey];
    } else if (LyUserType_coach == [LyCurrentUser curUser].userType) {
        [dic setObject:bossKey forKey:masterKey];
    }
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:updateCoachTrainBaseHttpMethod_update];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:modifyCoachTrainBase_url
                                 body:dic
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)handleHttpFailed {
    if ([indicator_update isAnimating]) {
        [indicator_update stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"更换失败"] show];
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
        [indicator_update stopAnimation];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_update stop];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    switch (curHttpMethod) {
        case updateCoachTrainBaseHttpMethod_update: {
            switch ([strCode integerValue]) {
                case 0: {
                    [indicator_update stopAnimation];
                    
                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"更换成功"];
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
    [_delegate onDoneByUpdateCoachTrainBaseTVC:self trainBase:_trainBase];
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
}


#pragma mark -LyChooseSchoolTableViewControllerDelegate
- (NSString *)obtainAddressInfoByChooseSchoolTableViewController:(LyChooseSchoolTableViewController *)aChooseSchoolTableViewContoller {
    return curAddress;
}


- (void)onSelectedDriveSchoolByChooseSchoolTableViewController:(LyChooseSchoolTableViewController *)aChooseSchoolTableViewContoller andSchool:(LyDriveSchool *)dsch {
    [aChooseSchoolTableViewContoller.navigationController popViewControllerAnimated:YES];
    
    curSchool = dsch;
    [self.tableView reloadRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationLeft];
}



#pragma mark -LyChooseTrainBaseTableViewControllerDelegate
- (NSString *)obtainAddressByChooseTrainBaseTVC:(LyChooseTrainBaseTableViewController *)aChooseTrainBaseTVC {
    return curAddress;
}

- (NSString *)obtainSchoolIdByChooseTrainBaseTVC:(LyChooseTrainBaseTableViewController *)aChooseTrainBaseTVC {
    NSString *strSchoolId;
    if (LyUserType_school == [LyCurrentUser curUser].userType) {
        strSchoolId = [LyCurrentUser curUser].userId;
    } else {
        strSchoolId = curSchool.userId;
    }
    
    return strSchoolId;
}

//- (NSDictionary *)obtainInfoByChooseTrainBaseTVC:(LyChooseTrainBaseTableViewController *)aChooseTrainBaseTVC {
//    return @{
//             addressKey:curAddress,
//             schoolIdKey:curSchool.userId
//             };
//}

- (void)onDoneByChooseTrainBase:(LyChooseTrainBaseTableViewController *)aChooseTrainBaseVC trainBase:(LyTrainBase *)aTrainBase {
    [aChooseTrainBaseVC.navigationController popViewControllerAnimated:YES];
    
    if (aTrainBase && ![aTrainBase isEqual:_trainBase]) {
        _trainBase = aTrainBase;
        
        [self.tableView reloadRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationLeft];
    }
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
        
        if (LyUserType_school == [LyCurrentUser curUser].userType) {
            
            LyChooseTrainBaseTableViewController *chooseTrainBase = [LyChooseTrainBaseTableViewController chooseTrainBaseViewControllerWithMode:LyChooseTrainBaseTableViewControllerMode_school];
            [chooseTrainBase setDelegate:self];
            [self.navigationController pushViewController:chooseTrainBase animated:YES];
            
        } else if (LyUserType_coach == [LyCurrentUser curUser].userType) {
            
            LyChooseSchoolTableViewController *chooseSchool = [[LyChooseSchoolTableViewController alloc] init];
            [chooseSchool setDelegate:self];
            [self.navigationController pushViewController:chooseSchool animated:YES];
            
        }
        
    } else if (2 == indexPath.row) {
        if (!curAddress || ![LyUtil validateString:curAddress]) {
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没有选择地址"] show];
            return;
        }
        
        if (!curSchool) {
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没有选择驾校"] show];
            return;
        }
        
        LyChooseTrainBaseTableViewController *chooseTrainBase = [LyChooseTrainBaseTableViewController chooseTrainBaseViewControllerWithMode:LyChooseTrainBaseTableViewControllerMode_school];
        [chooseTrainBase setDelegate:self];
        [self.navigationController pushViewController:chooseTrainBase animated:YES];
    }
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (LyUserType_school == [LyCurrentUser curUser].userType) {
        return 2;
    }
    else if (LyUserType_coach == [LyCurrentUser curUser].userType) {
        return 3;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyUpdateCoachTrainBaseRvItemsCellReuseIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[LyUserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyUpdateCoachTrainBaseRvItemsCellReuseIdentifier];
    }
    
    
    switch (indexPath.row) {
        case 0: {
            [cell setCellInfo:@"所在城市"
                       detail:(curAddress) ? curAddress : @"请选择城市"
                         icon:nil];
            break;
        }
        case 1: {
            if (LyUserType_school == [LyCurrentUser curUser].userType) {
                [cell setCellInfo:@"所属基地"
                           detail:(_trainBase) ? _trainBase.tbName : @"请选择基地"
                             icon:nil];
            }
            else if (LyUserType_coach == [LyCurrentUser curUser].userType) {
                [cell setCellInfo:@"所属驾校"
                           detail:(curSchool) ? curSchool.userName : @"请选择所属驾校"
                             icon:nil];
            }
            break;
        }
        case 2: {
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
