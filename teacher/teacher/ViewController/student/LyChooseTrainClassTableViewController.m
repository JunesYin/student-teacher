//
//  LyChooseTrainClassTableViewController.m
//  teacher
//
//  Created by Junes on 16/8/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyChooseTrainClassTableViewController.h"
#import "LySearchResultTableViewController.h"

#import "LyIndicator.h"

#import "LyTrainClassManager.h"

#import "LyCurrentUser.h"

#import "LyPinyinGroup.h"

#import "LyUtil.h"


typedef NS_ENUM(NSInteger, LyChooseTrainClassHttpMethod)
{
    chooseTrainClassHttpMethod_load = 100,
};

@interface LyChooseTrainClassTableViewController () <UISearchResultsUpdating, LySearchResultTableViewControllerDelegate, LyHttpRequestDelegate>
{
    
    UIView                      *viewError;
    UIView                      *viewNull;
    
    NSArray                     *arrTrainClasses;
    NSMutableArray              *arrSearchResult;
    
    
    NSArray                     *arrTrainClassSections;
    NSArray                     *arrTrainClassRows;
    
    LyIndicator                 *indicator_load;
    BOOL                        bHttpFlag;
    LyChooseTrainClassHttpMethod    curHttpMethod;
}

@property (nonatomic, strong)       UISearchController  *searchController;
@property (nonatomic, strong)       LySearchResultTableViewController   *searchResultTVC;

@end

@implementation LyChooseTrainClassTableViewController

static NSString *lyChooseTrainClassTableViewCellReuseIdentifier = @"lyChooseTrainClassTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    [self.tableView setSectionIndexColor:LyBlackColor];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:lyChooseTrainClassTableViewCellReuseIdentifier];
    
    self.refreshControl = [LyUtil refreshControlWithTitle:nil
                                                   target:self
                                                   action:@selector(refresh:)];
    
    
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    [self.searchController.searchBar sizeToFit];
    self.definesPresentationContext = YES;
    
    
    arrTrainClasses = [[NSMutableArray alloc] initWithCapacity:1];
}


- (void)viewWillAppear:(BOOL)animated {

}

- (void)viewDidAppear:(BOOL)animated {
    [self refresh:self.refreshControl];
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
    
    [self.tableView setContentSize:CGSizeMake( SCREEN_WIDTH, SCREEN_HEIGHT*1.1f)];
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
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:chooseTrainClassHttpMethod_load];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:getTrainClass_url
                                          body:@{
                                                 userIdKey:[LyCurrentUser curUser].userId,
                                                 userTypeKey:[[LyCurrentUser curUser] userTypeByString],
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
    
    
    
    switch ( curHttpMethod) {
        case chooseTrainClassHttpMethod_load: {
            switch ( [strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateArray:arrResult]) {
                        if ( [self.refreshControl isRefreshing]) {
                            [self.refreshControl endRefreshing];
                        }
                        
                        [indicator_load stopAnimation];
                        [self showViewNull];
                        return;
                    }
                    
//                    for ( int i = 0; i < (([arrResult count] >= 100) ? 100 : [arrResult count]); ++i) {
                    for (NSDictionary *dicItem in arrResult) {
                        if (![LyUtil validateDictionary:dicItem]) {
                            continue;
                        }
                        NSString *strId = [dicItem objectForKey:trainClassIdKey];
                        NSString *strName = [dicItem objectForKey:nameKey];
                        NSString *strCarName = [dicItem objectForKey:carNameKey];
                        NSString *strOfficialPrice = [dicItem objectForKey:officialPriceKey];
                        NSString *str517WholePrice = [dicItem objectForKey:whole517PriceKey];
                        NSString *strClassTime = [dicItem objectForKey:trainClassTimeKey];
                        NSString *strInclude = [dicItem objectForKey:includeKey];
                        
                        
                        if ([LyUtil validateString:strId]) {
                            LyTrainClass *trainClass = [LyTrainClass trainClassWithTrainClassId:strId
                                                                                         tcName:strName
                                                                                     tcMasterId:[LyCurrentUser curUser].userId
                                                                                    tcTrainTime:strClassTime
                                                                                      tcCarName:strCarName
                                                                                      tcInclude:strInclude
                                                                                         tcMode:[LyCurrentUser curUser].userType-LyUserType_coach+LyTrainClassMode_coach
                                                                                  tcLicenseType:LyLicenseType_C1
                                                                                tcOfficialPrice:[strOfficialPrice floatValue]
                                                                                tc517WholePrice:[str517WholePrice floatValue]
                                                                               tc517PrepayPrice:[str517WholePrice floatValue]
                                                                             tc517PrePayDeposit:0];
                            
                            [[LyTrainClassManager sharedInstance] addTrainClass:trainClass];
                        }
                        
                    }
                    
                    arrTrainClasses = [[LyTrainClassManager sharedInstance] getTrainClassWithTeacherId:[LyCurrentUser curUser].userId];
                    
                    NSDictionary *dicTrainBaseTmp = [LyPinyinGroup group:arrTrainClasses key:@"tcName"];
                    arrTrainClassSections = [dicTrainBaseTmp objectForKey:LyPinyinGroupNameKey];
                    arrTrainClassRows = [dicTrainBaseTmp objectForKey:LyPinyinGroupResultKey];
                    
                    [self removeViewNull];
                    [self removeViewError];
                    [self.tableView reloadData];
                    
                    [indicator_load stopAnimation];
                    [self.refreshControl endRefreshing];
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
        curHttpMethod = ahttpRequest.mode;
        [self analysisHttpRequest:result];
    }
    
    curHttpMethod = 0;
}



#pragma mark -LySearchResultTableViewControllerDelegate
- (void)onSelectedItemBySearchResultTVC:(LySearchResultTableViewController *)aSearchResultTVC object:(id)object {
    LyTrainClass *trainClass = (LyTrainClass *)object;
    
    [_delegate onDoneByChooseTrainClassTVC:self trainClass:trainClass];
}


#pragma mark -UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    arrSearchResult = nil;
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.tcName contains [c] %@", searchController.searchBar.text];
    arrSearchResult = [[NSMutableArray alloc] initWithArray:[arrTrainClasses filteredArrayUsingPredicate:predicate]];
    
//    [LyUtil sortArr:arrSearchResult andKey:@"tcName"];
    arrSearchResult = [LyUtil sortArrByStr:arrSearchResult andKey:@"tcName"];
    
    if (self.searchController.searchResultsController) {
        [self.searchResultTVC setArrSearchResult:arrSearchResult];
    }
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _trainClass = [[arrTrainClassRows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [_delegate onDoneByChooseTrainClassTVC:self trainClass:_trainClass];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return arrTrainClassSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[arrTrainClassRows objectAtIndex:section] count];
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [arrTrainClassSections objectAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyChooseTrainClassTableViewCellReuseIdentifier forIndexPath:indexPath];
    if ( !cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:lyChooseTrainClassTableViewCellReuseIdentifier];
    }
    
    [cell.textLabel setText:[[[arrTrainClassRows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] tcName]];
    
    return cell;
}


- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return arrTrainClassSections;
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
