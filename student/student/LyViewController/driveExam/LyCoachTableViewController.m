//
//  LyCoachTableViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/17.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyCoachTableViewController.h"
#import "LyCoachTableViewCell.h"


#import "LyTableViewFooterView.h"

#import "LyCurrentUser.h"
#import "LyUserManager.h"


#import "LyUtil.h"


typedef NS_ENUM( NSInteger, LyCoachTableViewHttpMethod)
{
    coachTableViewHttpMethod_loadMore = 1
};


NSString *const lyCoachTableViewCellReuseIdentifier = @"lyCoachTableViewCellReuseIdentifier";


@interface LyCoachTableViewController () <LyHttpRequestDelegate, LyTableViewFooterViewDelegate, UIScrollViewDelegate>
{
    NSArray                         *arrCoachInit;
    NSMutableArray                  *arrCoach;
    
    
    LyTableViewFooterView           *tvFooterView;
    
    
    LyCoachTableViewHttpMethod      curHttpMethod;
    BOOL                            bHttpFlag;
}
@end

@implementation LyCoachTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    [self.tableView registerClass:[LyCoachTableViewCell class] forCellReuseIdentifier:lyCoachTableViewCellReuseIdentifier];
    
    tvFooterView = [[LyTableViewFooterView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, tvFooterViewDefaultHeight)];
    [tvFooterView setDelegate:self];
    [self.tableView setTableFooterView:tvFooterView];
}


- (void)viewWillAppear:(BOOL)animated
{
    NSDictionary *dic = [_delegate obtainCoachInfoByCoachTableViewController:self];
    
    if ( ![[dic objectForKey:driveSchoolIdKey] isEqualToString:_driveSchoolId] || ![[dic objectForKey:trainBaseIdKey] isEqualToString:_trainBaseId] || ![arrCoach count])
    {
        _driveSchoolId = [dic objectForKey:driveSchoolIdKey];
        _trainBaseId = [dic objectForKey:trainBaseIdKey];
        _subject = [[dic objectForKey:subjectModeKey] integerValue];
        arrCoachInit = [dic objectForKey:coachKey];
        arrCoach = [[NSMutableArray alloc] initWithArray:arrCoachInit];
        
        [self.tableView reloadData];
    }
}



- (void)loadMoreData
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(loadMoreData) object:nil];
        return;
    }
    
    [tvFooterView startAnimation];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:coachTableViewHttpMethod_loadMore];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:getMoreCoach_url
                                          body:@{
                                                startKey:[[NSString alloc] initWithFormat:@"%d", (int)[arrCoach count]],
                                                driveSchoolIdKey:_driveSchoolId,
                                                trainBaseIdKey:_trainBaseId,
                                                driveLicenseKey:[LyUtil driveLicenseStringFrom:[[LyCurrentUser curUser] userLicenseType]],
                                                subjectModeKey:[[NSString alloc] initWithFormat:@"%d", (int)_subject]
                                                }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}


- (void)handleHttpFailed {
    if ([tvFooterView isAnimating]) {
        [tvFooterView stopAnimation];
    }
    
    [tvFooterView setStatus:LyTableViewFooterViewStatus_error];
}


- (void)analysiHttpResult:(NSString *)result
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
        [tvFooterView stopAnimation];
        
        [LyUtil sessionTimeOut:self];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [tvFooterView stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    
    
    switch ( curHttpMethod) {
        case coachTableViewHttpMethod_loadMore: {
            switch ( [strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateArray:arrResult]) {
                        [tvFooterView stopAnimation];
                        [tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                        return;
                    }
                    
                    [arrCoach removeAllObjects];
                    [arrCoach addObjectsFromArray:arrCoachInit];
                    
                    for ( int i = 0; i < [arrResult count]; ++i)
                    {
                        NSDictionary *dicCoach = [arrResult objectAtIndex:i];
                        if ( !dicCoach || [dicCoach isKindOfClass:[NSNull class]] || ![dicCoach isKindOfClass:[NSDictionary class]] || ![dicCoach count])
                        {
                            continue;
                        }
                        
                        NSString *strId = [dicCoach objectForKey:userIdKey];
                        NSString *strName = [dicCoach objectForKey:nickNameKey];
                        NSString *strSex = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:sexKey]];
                        NSString *strScore = [[NSString alloc] initWithFormat:@"%@",[dicCoach objectForKey:scoreKey]];
                        NSString *strBirthday = [dicCoach objectForKey:birthdayKey];
                        NSString *strTeachBirthday = [dicCoach objectForKey:teachBirthdayKey];
                        NSString *strDriveBirthday = [dicCoach objectForKey:driveBirthdayKey];
                        NSString *strPassedCount = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:teachedPassedCountKey]];
                        NSString *strTeachAllCount = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:teachAllCountKey]];
                        NSString *strPraiseCount = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:praiseCountKey]];
                        NSString *strEvalutionCount = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:evalutionCountKey]];
                        NSString *strTrainBaseId = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:trainBaseKey]];
                        NSString *strDriveLicense = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:driveLicenseKey]];
                        
                        NSString *strMasterId = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:masterIdKey]];
                        
                        
                        if (![LyUtil validateString:strName]) {
                            strName = [LyUtil getUserNameWithUserId:strId];
                        }
                        
                        
                        LyCoach *coach = [[LyUserManager sharedInstance] getCoachWithCoachId:strId];
                        if ( !coach) {
                            coach = [LyCoach coachWithId:strId
                                                 coaName:strName
                                                score:[strScore floatValue]
                                                  coaSex:[strSex integerValue]
                                             coaBirthday:strBirthday
                                           coaTeachBirthday:strTeachBirthday
                                        coaDriveBirthday:strDriveBirthday
                                        stuAllCount:[strTeachAllCount intValue]
                                   coaTeachedPassedCount:[strPassedCount intValue]
                                       coaEvaluationCount:[strEvalutionCount intValue]
                                          coaPraiseCount:[strPraiseCount intValue]
                                                price:0];
                            
                            [coach setCoaMasterId:strMasterId];
                            
                            [[LyUserManager sharedInstance] addUser:coach];
                        }
                    
                        [coach setUserSex:[strSex integerValue]];
                        [coach setScore:[strScore floatValue]];
                        [coach setUserBirthday:strBirthday];
                        [coach setCoaTeachBirthday:strTeachBirthday];
                        [coach setCoaDriveBirthday:strDriveBirthday];
                        [coach setCoaTeachedPassedCount:[strPassedCount intValue]];
                        [coach setCoaEvaluationCount:[strEvalutionCount intValue]];
                        [coach setCoaPraiseCount:[strPraiseCount intValue]];
                        [coach setCoaTrainBaseId:strTrainBaseId];
                        [coach setUserLicenseType:[LyUtil driveLicenseFromString:strDriveLicense]];
                        
                        [coach setCoaMasterId:strMasterId];
                        
                        [arrCoach addObject:coach];
                    }
                    
                    [self.tableView reloadData];
                    
                    [tvFooterView stopAnimation];

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
    if ( bHttpFlag) {
        bHttpFlag = NO;
        [self handleHttpFailed];
    }
    
    curHttpMethod = 0;
}

- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result {
    if ( bHttpFlag) {
        bHttpFlag = YES;
        curHttpMethod = ahttpRequest.mode;
        [self analysiHttpResult:result];
    }
    
    curHttpMethod = 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)loadMoreData:(LyTableViewFooterView *)tableViewFooterView
{
    [self loadMoreData];
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return COACHCELLHEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [arrCoach count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyCoachTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyCoachTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    if ( !cell)
    {
        cell = [[LyCoachTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyCoachTableViewCellReuseIdentifier];
    }
    [cell setCoach:[arrCoach objectAtIndex:[indexPath row]]];
    [cell setMode:coachTableViewCellMode_mySchool];
    
    return cell;
}




#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.tableView) {// && !decelerate) {
        if ( [scrollView contentOffset].y + [scrollView frame].size.height > [scrollView contentSize].height) {
            [self loadMoreData];
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
