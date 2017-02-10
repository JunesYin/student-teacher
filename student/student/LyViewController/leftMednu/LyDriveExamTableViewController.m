//
//  LyDriveExamTableViewController.m
//  student
//
//  Created by Junes on 16/9/3.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyDriveExamTableViewController.h"
#import "LyNotificationTableViewCell.h"


#import "LyIndicator.h"

#import "LyCurrentUser.h"
#import "LyUserManager.h"

#import "LyMacro.h"
#import "LyUtil.h"


#import "LyMySchoolViewController.h"
#import "LyAddSchoolTableViewController.h"
#import "LyMyCoachViewController.h"
#import "LyAddCoachTableViewController.h"
#import "LySelfStudyToExamViewController.h"


const NSString *myDriveSchoolName = @"myDriveSchoolName";
const NSString *myCoachName = @"myCoachName";
const NSString *myGuiderName = @"myGuiderName";


typedef NS_ENUM( NSInteger, LyDriveExamHttpMethod) {
    driveExamHttpMethdod_load,
};


@interface LyDriveExamTableViewController () < LyHttpRequestDelegate, UITableViewDelegate, UITableViewDataSource, LyAddSchoolTableViewControllerDelegate, LyAddCoachTableViewControllerDelegate>
{
    UIView                      *viewError;
    
    NSArray                     *arrItems;
    NSIndexPath                 *curIdx;
    
    
    BOOL                        flagLoad;
    LyIndicator                 *indicator;
    BOOL                        bHttpFalg;
    LyDriveExamHttpMethod       curHttpMethod;
}
@end

@implementation LyDriveExamTableViewController

static NSString *lyDriveExamTvCellReuseIdentifier = @"lyDriveExamTvCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.title = @"驾考学堂";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [self.tableView registerClass:[LyNotificationTableViewCell class] forCellReuseIdentifier:lyDriveExamTvCellReuseIdentifier];
    [self.tableView setTableFooterView:[UIView new]];
    self.refreshControl = [LyUtil refreshControlWithTitle:nil target:self action:@selector(refresh:)];
    
    arrItems = [[NSArray alloc] initWithObjects:
                @"我的驾校",
                @"我的教练",
                //                @"我的预约",
                @"自学直考",
                //                @"学车进度",
                nil];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if (!flagLoad) {
        [self load];
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


- (void)reloadData {
    [self removeViewError];
    [self.tableView reloadData];
}


- (void)showViewError {
    flagLoad = NO;
    if ( !viewError)
    {
        viewError = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.2f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewError addSubview:[LyUtil lbErrorWithMode:0]];
    }
    
    [self.tableView addSubview:viewError];
    [self.tableView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.05f)];
}


- (void)removeViewError {
    flagLoad = YES;
    [viewError removeFromSuperview];
    viewError = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)refresh:(UIRefreshControl *)refreshControl
{
    [self load];
}


- (void)load {
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(load) object:nil];
        return;
    }
    
    if ( !indicator){
        indicator = [[LyIndicator alloc] initWithTitle:@""];
    }
    [indicator startAnimation];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:driveExamHttpMethdod_load];
    [httpRequest setDelegate:self];
    bHttpFalg = [[httpRequest startHttpRequest:driveExam_url
                                          body:@{
                                                 userIdKey:[[LyCurrentUser curUser] userId],
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
        
        [LyUtil sessionTimeOut:self];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    
    switch (curHttpMethod) {
        case driveExamHttpMethdod_load: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (!dicResult || ![LyUtil validateDictionary:dicResult])
                    {
                        [indicator stopAnimation];
                        [self.refreshControl endRefreshing];
                        [self showViewError];
                        return;
                    }
                    
                    NSString *strDschId = [[dic objectForKey: resultKey] objectForKey:myDriveSchoolIdKey];
                    NSString *strCoachId = [dicResult objectForKey:myCoachIdKey];
                    NSString *strGuiderId = [dicResult objectForKey:myGuiderIdKey];
                    NSString *strTrainClassId = [dicResult objectForKey:classIdKey];
                    
                    NSString *strDschName = [dicResult objectForKey:myDriveSchoolNameKey];
                    NSString *strCoachName = [dicResult objectForKey:myCoachNameKey];
                    NSString *strGuiderName = [dicResult objectForKey:myGuiderNameKey];
                    
                    
//                    NSString *nCountForMyDsch          = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:myDriveSchoolNotificationCount]];
//                    NSString *nCountForMyCoach         = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:myCoachNotificationCount]];
//                    NSString *nCountForMyGuider        = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:myGuiderNotificationCount]];
                    
                    if (!strDschName || ![LyUtil validateString:strDschName]) {
                        strDschName = @"无";
                    }
                    
                    if (!strCoachName || ![LyUtil validateString:strCoachName]) {
                        strCoachName = @"无";
                    }
                    
                    if (!strGuiderName || ![LyUtil validateString:strGuiderName]) {
                        strGuiderName = @"无";
                    }
                    
                    [[LyCurrentUser curUser] setUserDriveSchoolId:strDschId];
                    [[LyCurrentUser curUser] setUserCoachId:strCoachId];
                    [[LyCurrentUser curUser] setUserGuiderId:strGuiderId];
                    [[LyCurrentUser curUser] setUserTrainClassId:strTrainClassId];
                    [[LyCurrentUser curUser] setUserDriveSchoolName:strDschName];
                    [[LyCurrentUser curUser] setUserCoachName:strCoachName];
                    [[LyCurrentUser curUser] setUserGuiderName:strGuiderName];
                    
                    
                    if (strDschId && [LyUtil validateString:strDschId]) {
                        LyDriveSchool *driveSchool = [[LyUserManager sharedInstance] getDriveSchoolWithDriveSchoolId:strDschId];
                        if ( !driveSchool) {
                            driveSchool = [LyDriveSchool userWithId:strDschId
                                                                  userName:strDschName];
                            [[LyUserManager sharedInstance] addUser:driveSchool];
                        }
                    }
                    
                    
                    if (strCoachId && [LyUtil validateString:strCoachId]) {
                        LyCoach *coach = [[LyUserManager sharedInstance] getCoachWithCoachId:strCoachId];
                        if ( !coach) {
                            coach = [LyCoach userWithId:strCoachId
                                                 userName:strCoachName];
                            [[LyUserManager sharedInstance] addUser:coach];
                            
                        }
                    }
                    
                    
                    if (strGuiderId && [LyUtil validateString:strGuiderId]) {
                        LyGuider *guider = [[LyUserManager sharedInstance] getGuiderWithGuiderId:strGuiderId];
                        if ( !guider) {
                            guider = [LyGuider userWithId:strGuiderId
                                                          userName:strGuiderName];
                            [[LyUserManager sharedInstance] addUser:guider];
                        }
                    }
                
                    [indicator stopAnimation];
                    [self.refreshControl endRefreshing];
                    [self reloadData];
                    
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
    if (bHttpFalg) {
        
        bHttpFalg = NO;
        [self handleHttpFailed];
    }
    
    curHttpMethod = 0;
}

- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result {
    if (bHttpFalg) {
        
        bHttpFalg = NO;
        curHttpMethod = ahttpRequest.mode;
        [self analysisHttpResult:result];
    }
    
    curHttpMethod = 0;
}


#pragma mark -LyAddSchoolTableViewControllerDelegate
- (LyAddTeacherMode)obtainModeViewControllerModeByAddSchoolTableViewController:(LyAddSchoolTableViewController *)aAddSchool {
    return LyAddTeacherMode_add;
}


- (void)addSchoolFinishedByAddSchoolTableViewController:(LyAddSchoolTableViewController *)aAddSchool andDriveSchool:(LyDriveSchool *)driveSchool
{
    [aAddSchool.navigationController popViewControllerAnimated:YES];
    
    [[LyUserManager sharedInstance] addUser:driveSchool];
    [[LyCurrentUser curUser] setUserDriveSchoolId:[driveSchool userId]];
    [[LyCurrentUser curUser] setUserDriveSchoolName:[driveSchool userName]];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
}



#pragma mark -LyAddCoachTableViewControllerDelegate
- (LyAddTeacherMode)obtainModeByAddCoachTableViewController:(LyAddCoachTableViewController *)aAddCoach
{
    return LyAddTeacherMode_add;
}


- (void)addCoachFinishedByAddCoachTableViewController:(LyAddCoachTableViewController *)aAddCoach andCoach:(LyCoach *)coach
{
    [aAddCoach.navigationController popViewControllerAnimated:YES];
    
    [[LyUserManager sharedInstance] addUser:coach];
    [[LyCurrentUser curUser] setUserCoachId:[coach userId]];
    [[LyCurrentUser curUser] setUserCoachName:[coach userName]];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
}


#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ncellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    curIdx = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    if (![LyCurrentUser curUser].isLogined) {
//        return;
//    }
    
    switch ( [indexPath row]) {
        case 0: {
            UIViewController *nextVC = nil;
            if (![LyCurrentUser curUser].userDriveSchoolId || ![LyUtil validateString:[LyCurrentUser curUser].userDriveSchoolId]) {
                LyAddSchoolTableViewController *addSchool = [[LyAddSchoolTableViewController alloc] init];
                [addSchool setDelegate:self];
//                [self.navigationController pushViewController:addSchool animated:YES];
                nextVC = addSchool;
            }
            else
            {
                LyMySchoolViewController *mySchool = [[LyMySchoolViewController alloc] init];
                nextVC = mySchool;
//                [self.navigationController pushViewController:mySchool animated:YES];
            }
            
            if ([LyCurrentUser curUser].isLogined) {
                [self.navigationController pushViewController:nextVC animated:YES];
            } else {
                [LyUtil showLoginVc:self nextVC:nextVC showMode:LyShowVcMode_push];
            }
            
            break;
        }
            
        case 1: {
            UIViewController *nextVC = nil;
            if (![LyCurrentUser curUser].userCoachId || ![LyUtil validateString:[LyCurrentUser curUser].userCoachId]) {
                LyAddCoachTableViewController *addCoach = [[LyAddCoachTableViewController alloc] init];
                [addCoach setDelegate:self];
//                [self.navigationController pushViewController:addCoach animated:YES];
                nextVC = addCoach;
            }
            else
            {
                LyMyCoachViewController *myCoach = [[LyMyCoachViewController alloc] init];
//                [self.navigationController pushViewController:myCoach animated:YES];
                nextVC = myCoach;
            }
            
            if ([LyCurrentUser curUser].isLogined) {
                [self.navigationController pushViewController:nextVC animated:YES];
            } else {
                [LyUtil showLoginVc:self nextVC:nextVC showMode:LyShowVcMode_push];
            }
            
            break;
        }
            
        case 2: {
            LySelfStudyToExamViewController *selfStudyToExam = [[LySelfStudyToExamViewController alloc] init];
//            [self.navigationController pushViewController:selfStudyToExam animated:YES];
            
            if ([LyCurrentUser curUser].isLogined) {
                [self.navigationController pushViewController:selfStudyToExam animated:YES];
            } else {
                [LyUtil showLoginVc:self nextVC:selfStudyToExam showMode:LyShowVcMode_push];
            }
            
            break;
        }
            
        default:
            break;
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyNotificationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:lyDriveExamTvCellReuseIdentifier forIndexPath:indexPath];
    
    if ( !cell) {
        cell = [[LyNotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyDriveExamTvCellReuseIdentifier];
    }
    
    switch (indexPath.row) {
        case 0: {
            [cell setCellInfo:[LyUtil imageForImageName:@"de_item_0" needCache:NO]
                        title:[arrItems objectAtIndex:indexPath.row]
                       detail:[[NSString alloc] initWithFormat:@"我的驾校：%@", [LyCurrentUser curUser].userDriveSchoolName]
                        count:0];
            break;
        }
        case 1: {
            [cell setCellInfo:[LyUtil imageForImageName:@"de_item_1" needCache:NO]
                        title:[arrItems objectAtIndex:indexPath.row]
                       detail:[[NSString alloc] initWithFormat:@"我的教练：%@", [LyCurrentUser curUser].userCoachName]
                        count:0];
            break;
        }
        case 2: {
            [cell setCellInfo:[LyUtil imageForImageName:@"de_item_2" needCache:NO]
                        title:[arrItems objectAtIndex:indexPath.row]
                       detail:[[NSString alloc] initWithFormat:@"我的指导员：%@", [LyCurrentUser curUser].userGuiderName]
                        count:0];
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
