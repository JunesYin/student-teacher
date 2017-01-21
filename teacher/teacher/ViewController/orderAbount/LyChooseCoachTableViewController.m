//
//  LyChooseCoachTableViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/17.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyChooseCoachTableViewController.h"
#import "LySearchResultTableViewController.h"

#import "LyIndicator.h"


#import "LyCoach.h"
#import "LyPinyinGroup.h"


#import "LyCurrentUser.h"


#import "LyUtil.h"




typedef NS_ENUM( NSInteger, LyChooseCoachTableViewControllerHttpMethod)
{
    chooseCoachTableViewControllerHttpMethod_load = 13
};




@interface LyChooseCoachTableViewController ()<UISearchResultsUpdating, LySearchResultTableViewControllerDelegate, LyHttpRequestDelegate>
{
    
    UIView                      *viewError;
    UIView                      *viewNull;
    
    NSMutableArray              *arrCoach;
    NSMutableArray              *arrSearchResult;
    
    
    NSArray                     *arrCoachSection;
    NSArray                     *arrCoachRows;
    
    LyIndicator                 *indicator;
    BOOL                        bHttpFlag;
    LyChooseCoachTableViewControllerHttpMethod    curHttpMethod;
}

@property (nonatomic, strong)       UISearchController  *searchController;
@property (nonatomic, strong)       LySearchResultTableViewController   *searchResultTVC;

@end

@implementation LyChooseCoachTableViewController

static NSString *const lyChooseCoachTableViewCellReuseIdentifier = @"lyChooseCoachTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
//    self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [self.tableView setSectionIndexColor:LyBlackColor];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:lyChooseCoachTableViewCellReuseIdentifier];
    
    self.refreshControl = [LyUtil refreshControlWithTitle:nil
                                                   target:self
                                                   action:@selector(refresh:)];
    
    
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    [self.searchController.searchBar sizeToFit];
    self.definesPresentationContext = YES;
    
    
    arrCoach = [[NSMutableArray alloc] initWithCapacity:1];
}


- (void)viewWillAppear:(BOOL)animated
{

    if (LyUserType_school == [LyCurrentUser curUser].userType) {
        _trainBaseId = [_delegate obtainTrainBaseIdByChooseCoachTVC:self];
        
        if (!_trainBaseId) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.searchController.isActive) {
        [self.searchController setActive:NO];
        [self.searchController.searchBar removeFromSuperview];
    }
}



- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultTVC];
        [_searchController setSearchResultsUpdater:self];
        
        [self.searchController.searchBar setPlaceholder:@"搜索教练"];
    }
    
    return _searchController;
}


- (LySearchResultTableViewController *)searchResultTVC {
    if (!_searchResultTVC) {
        _searchResultTVC = [LySearchResultTableViewController searchResultTableViewControllerWithKeyForShow:@"userName"];
        [_searchResultTVC setDelegate:self];
    }
    
    return _searchResultTVC;
}


- (void)reloadData {
    
    [self removeViewNull];
    [self removeViewError];
    [self.tableView reloadData];
}

- (void)showViewNull {
    if ( !viewNull) {
        viewNull = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.2f)];
        [viewNull setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewNull addSubview:[LyUtil lbNullWithText:@"还没有相关数据"]];
    }
    
    [self.tableView addSubview:viewNull];
    [self.tableView setContentSize:CGSizeMake( SCREEN_WIDTH, SCREEN_HEIGHT*1.05f)];
}

- (void)removeViewNull {
    [viewNull removeFromSuperview];
    viewNull = nil;
}


- (void)showViewError {
    if ( !viewError){
        viewError = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.2f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewError addSubview:[LyUtil lbErrorWithMode:0]];
    }
    
    [self.tableView addSubview:viewError];
    [self.tableView setContentSize:CGSizeMake( SCREEN_WIDTH, SCREEN_HEIGHT*1.05f)];
}


- (void)removeViewError {
    [viewError removeFromSuperview];
    viewError = nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)refresh:(UIRefreshControl *)refreControl {
    [self loadData];
}


- (void)loadData
{
    if ( !indicator) {
        indicator = [[LyIndicator alloc] initWithTitle:LyIndicatorTitle_load];
    }
    [indicator startAnimation];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[LyCurrentUser curUser].userId forKey:userIdKey];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    if (LyUserType_school == [LyCurrentUser curUser].userType) {
        [dic setObject:_trainBaseId forKey:trainBaseIdKey];
    }
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:chooseCoachTableViewControllerHttpMethod_load];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:usefulCoach_url
                                          body:dic
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


- (void)analysisHttpRequest:(NSString *)result
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
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        
        [LyUtil serverMaintaining];
        return;
    }

    
    
    if (arrCoach && arrCoach.count > 0) {
        [arrCoach removeAllObjects];
    }
    
    
    switch ( curHttpMethod) {
        case chooseCoachTableViewControllerHttpMethod_load: {
            curHttpMethod = 0;
            
            switch ( [strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateArray:arrResult]) {
                        [self.refreshControl endRefreshing];
                        [indicator stopAnimation];
                        [self showViewNull];
                        return;
                    }
                    
                    for (NSDictionary *dicItem in arrResult) {
                        
                        if (![LyUtil validateDictionary:dicItem]){
                            continue;
                        }
                        
                        NSString *strId = [dicItem objectForKey:userIdKey];
                        NSString *strName = [dicItem objectForKey:nickNameKey];
                        
                        
                        if ([LyUtil validateString:strId]) {
                            LyCoach *coach = [LyCoach coachWithIdNoAvatar:strId
                                                                     name:strName];
                                              
                            if ( !arrCoach) {
                                arrCoach = [[NSMutableArray alloc] initWithCapacity:1];
                            }
                            
                            [arrCoach addObject:coach];
                        }
                        
                    }
                    
                    NSDictionary *dicSchoolTmp = [LyPinyinGroup group:arrCoach key:@"userName"];
                    arrCoachSection = [dicSchoolTmp objectForKey:LyPinyinGroupNameKey];
                    arrCoachRows = [dicSchoolTmp objectForKey:LyPinyinGroupResultKey];
                    
                    [self reloadData];
                    
                    [self.refreshControl endRefreshing];
                    [indicator stopAnimation];
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
        curHttpMethod = [ahttpRequest mode];
        [self analysisHttpRequest:result];
    }
    
    curHttpMethod = 0;
}



#pragma mark -LySearchResultTableViewControllerDelegate
- (void)onSelectedItemBySearchResultTVC:(LySearchResultTableViewController *)aSearchResultTVC object:(id)object {
    LyCoach *coach = (LyCoach *)object;
    
    [_delegate onSelectedCoachByChooseCoachTVC:self andCoach:coach];
}


#pragma mark -UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    arrSearchResult = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.userName contains [c] %@", searchController.searchBar.text];
    arrSearchResult = [[NSMutableArray alloc] initWithArray:[arrCoach filteredArrayUsingPredicate:predicate]];
    
//    [LyUtil sortArr:arrSearchResult andKey:@"userName"];
    arrSearchResult = [LyUtil sortArrByStr:arrSearchResult andKey:@"userName"];
    
    if (self.searchController.searchResultsController) {
        [self.searchResultTVC setArrSearchResult:arrSearchResult];
    }
}



#pragma mark - Table view deleagate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_delegate onSelectedCoachByChooseCoachTVC:self andCoach:[[arrCoachRows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (arrCoachSection.count < 1) {
        [self showViewNull];
    } else {
        [self removeViewNull];
    }
    return [arrCoachSection count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[arrCoachRows objectAtIndex:section] count];
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [arrCoachSection objectAtIndex:section];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyChooseCoachTableViewCellReuseIdentifier forIndexPath:indexPath];
    if ( !cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:lyChooseCoachTableViewCellReuseIdentifier];
    }
    
    [[cell textLabel] setText:[[[arrCoachRows objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] userName]];
    
    return cell;
}


- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return arrCoachSection;
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
