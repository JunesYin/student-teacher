//
//  LySchoolTableViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/16.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyChooseSchoolTableViewController.h"
#import "LySearchResultTableViewController.h"

#import "LyIndicator.h"

#import "LyDriveSchool.h"


#import "LyCurrentUser.h"

#import "LyPinyinGroup.h"
#import "LyUtil.h"


typedef NS_ENUM( NSInteger, LyChooseSchoolTableViewControllerHttpMethod)
{
    chooseSchoolTableViewControllerHttpMethod_load = 22
};

NSString * const lyChooseSchoolTableViewControllerIdentifier = @"lySchoolTableViewControllerIdentifier";



@interface LyChooseSchoolTableViewController () <UISearchResultsUpdating, LySearchResultTableViewControllerDelegate, LyHttpRequestDelegate>
{
    
    UIView                      *viewError;
    UIView                      *viewNull;
    
    NSMutableArray              *arrSchool;
    NSMutableArray              *arrSearchResult;
    
    
    NSArray                     *arrSchoolSection;
    NSArray                     *arrSchoolRows;
    
    NSIndexPath                 *curIdx;
    
    LyIndicator                 *indicator_load;
    BOOL                        bHttpFlag;
    LyChooseSchoolTableViewControllerHttpMethod    curHttpMethod;
}

@property (nonatomic, strong)       UISearchController  *searchController;
@property (nonatomic, strong)       LySearchResultTableViewController   *searchResultTVC;

@end

@implementation LyChooseSchoolTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
//     self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    

    self.refreshControl = [LyUtil refreshControlWithTitle:nil
                                                   target:self
                                                   action:@selector(refresh:)];
    
    [self.tableView setSectionIndexColor:LyBlackColor];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:lyChooseSchoolTableViewControllerIdentifier];
    self.tableView.tableFooterView  = [UIView new];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    
    
    [self.searchController.searchBar sizeToFit];
    self.definesPresentationContext = YES;

    
    arrSchool = [[NSMutableArray alloc] initWithCapacity:1];
}



- (void)viewWillAppear:(BOOL)animated {

    NSString *strAddress;
    strAddress = [_delegate obtainAddressInfoByChooseSchoolTableViewController:self];
    
    if ( !_address || ![_address isEqualToString:strAddress] || ![arrSchool count]) {
        _address = strAddress;
        [self refresh:self.refreshControl];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
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
        
        [self.searchController.searchBar setPlaceholder:@"搜索驾校"];
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

- (void)showViewNull {
    if ( !viewNull) {
        viewNull = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.1f)];
        [viewNull setBackgroundColor:[UIColor whiteColor]];
        
        [viewNull addSubview:[LyUtil lbNullWithText:@"还没有相关数据"]];
    }
    
    [self.tableView setContentSize:CGSizeMake( SCREEN_WIDTH, SCREEN_HEIGHT*1.05f)];
    [self.tableView addSubview:viewNull];
    [self.tableView bringSubviewToFront:viewNull];
}

- (void)removeViewNull {
    [viewNull removeFromSuperview];
    viewNull = nil;
}


- (void)showViewError {
    if ( !viewError) {
        viewError = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.1f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewError addSubview:[LyUtil lbErrorWithMode:0]];
    }
    
    [self.tableView setContentSize:CGSizeMake( SCREEN_WIDTH, SCREEN_HEIGHT*1.1f)];
    [self.tableView addSubview:viewError];
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



- (void)loadData {
    
    if ( !indicator_load) {
        indicator_load = [[LyIndicator alloc] initWithTitle:nil];
    }
    [indicator_load startAnimation];
    
    NSArray *arrAddress = [LyUtil separateString:_address separator:@" "];
    NSString *strCity;
    if (arrAddress && arrAddress.count > 1) {
        strCity = [arrAddress objectAtIndex:1];
        strCity = [strCity substringToIndex:strCity.length - 1];
    } else {
        strCity = @"";
    }
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:chooseSchoolTableViewControllerHttpMethod_load];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:getTeacher_url
                                          body:@{
                                                 userTypeKey:userTypeSchoolKey,
                                                 addressKey:strCity,
                                                 userIdKey:[LyCurrentUser curUser].userId,
                                                 sessionIdKey:[LyUtil httpSessionId]
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}



- (void)handleHttpFailed {
    if ( [indicator_load isAnimating]) {
        [indicator_load stopAnimation];
        [self.refreshControl endRefreshing];
        [self showViewError];
    }
}


- (void)analysisHttpRequest:(NSString *)result {
    
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
        [indicator_load stopAnimation];
        [self.refreshControl endRefreshing];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_load stopAnimation];
        [self.refreshControl endRefreshing];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    if (arrSchool && arrSchool.count > 0) {
        [arrSchool removeAllObjects];
    }
    
    switch ( curHttpMethod) {
        case chooseSchoolTableViewControllerHttpMethod_load: {
            
            switch ( [strCode integerValue]) {
                case 0: {
                    
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateArray:arrResult]) {
                        [indicator_load stopAnimation];
                        [self.refreshControl endRefreshing];
                        
                        [self showViewNull];
                        return;
                    }
                    
                    
                    for (NSDictionary *dicItem in arrResult) {
                        if (![LyUtil validateDictionary:dicItem]) {
                            continue;
                        }
                        NSString *strId = [dicItem objectForKey:userIdKey];
                        NSString *strName = [dicItem objectForKey:nickNameKey];
                        
                        
                        if ([LyUtil validateString:strId]) {
                            LyDriveSchool *school = [LyDriveSchool driveSchoolWithIdNoAvatar:strId
                                                                                    userName:strName];
                            
                            if ( !arrSchool) {
                                arrSchool = [[NSMutableArray alloc] initWithCapacity:1];
                            }
                            
                            [arrSchool addObject:school];
                        }
                        
                    }
                    
                    NSDictionary *dicSchoolTmp = [LyPinyinGroup group:arrSchool key:@"userName"];
                    arrSchoolSection = [dicSchoolTmp objectForKey:LyPinyinGroupNameKey];
                    arrSchoolRows = [dicSchoolTmp objectForKey:LyPinyinGroupResultKey];
                    
                    [self.tableView reloadData];
                    
                    [self removeViewError];
                    [self removeViewNull];
                    [indicator_load stopAnimation];
                    if ( [self.refreshControl isRefreshing]) {
                        [self.refreshControl endRefreshing];
                    }
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
        bHttpFlag = NO;
        curHttpMethod = [ahttpRequest mode];
        [self analysisHttpRequest:result];
    }
    
    curHttpMethod = 0;
}


#pragma mark -LySearchResultTableViewControllerDelegate
- (void)onSelectedItemBySearchResultTVC:(LySearchResultTableViewController *)aSearchResultTVC object:(id)object {
    LyDriveSchool *school = (LyDriveSchool *)object;
    
    [_delegate onSelectedDriveSchoolByChooseSchoolTableViewController:self andSchool:school];
}


#pragma mark -UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    arrSearchResult = nil;
    

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.userName contains [c] %@", searchController.searchBar.text];
    arrSearchResult = [[NSMutableArray alloc] initWithArray:[arrSchool filteredArrayUsingPredicate:predicate]];
    
//    [LyUtil sortArr:arrSearchResult andKey:@"userName"];
    arrSearchResult = [LyUtil sortArrByStr:arrSearchResult andKey:@"userName"];
    
    if (self.searchController.searchResultsController) {
        [self.searchResultTVC setArrSearchResult:arrSearchResult];
    }
}



#pragma mark - Table view deleagate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!self.searchController.isActive) {
        return 30.0f;
    }

    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.searchController.isActive) {
        [_delegate onSelectedDriveSchoolByChooseSchoolTableViewController:self andSchool:[[arrSchoolRows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (arrSchoolSection.count < 1) {
        [self showViewNull];
    } else {
        [self removeViewNull];
    }
    return [arrSchoolSection count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[arrSchoolRows objectAtIndex:section] count];
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [arrSchoolSection objectAtIndex:section];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyChooseSchoolTableViewControllerIdentifier forIndexPath:indexPath];
    if ( !cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:lyChooseSchoolTableViewControllerIdentifier];
    }
    
    [cell.textLabel setText:[[[arrSchoolRows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] userName]];
    
    return cell;
}


- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return arrSchoolSection;
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
