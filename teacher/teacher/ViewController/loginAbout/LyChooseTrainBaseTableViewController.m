//
//  LyChooseTrainBaseTableViewController.m
//  teacher
//
//  Created by Junes on 16/7/27.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyChooseTrainBaseTableViewController.h"
#import "LySearchResultTableViewController.h"

#import "LyIndicator.h"

#import "LyCoach.h"
#import "LyPinyinGroup.h"

#import "LyCurrentUser.h"
#import "LyTrainBase.h"

#import "LyUtil.h"



typedef NS_ENUM(NSInteger, LyChooseTrainBaseHttpMethod)
{
    chooseTrainBaseHttpMethod_load = 10,
};


@interface LyChooseTrainBaseTableViewController () <UISearchResultsUpdating, LySearchResultTableViewControllerDelegate, LyHttpRequestDelegate>
{
    NSString                    *curProvince;
    NSString                    *curCity;
    NSString                    *curSchoolId;
    
    UIView                      *viewError;
    UIView                      *viewNull;
    
    NSMutableArray              *arrTrainBases;
    NSMutableArray              *arrSearchResult;
    
    
    NSArray                     *arrTrainBaseSections;
    NSArray                     *arrTrainBaseRows;
    
    LyIndicator                 *indicator_load;
    BOOL                        bHttpFlag;
    LyChooseTrainBaseHttpMethod curHttpMethod;
}

@property (nonatomic, strong)       UISearchController  *searchController;
@property (nonatomic, strong)       LySearchResultTableViewController   *searchResultTVC;

@end

@implementation LyChooseTrainBaseTableViewController

static NSString *const lyChooseTrainBaseTableViewCellReuseIdentifier = @"lyChooseTrainBaseTableViewCellReuseIdentifier";


+ (instancetype)chooseTrainBaseViewControllerWithMode:(LyChooseTrainBaseTableViewControllerMode)mode {
    LyChooseTrainBaseTableViewController *chooseTrainBaseVC = [[LyChooseTrainBaseTableViewController alloc] initWithMode:mode];
    
    return chooseTrainBaseVC;
}

- (instancetype)initWithMode:(LyChooseTrainBaseTableViewControllerMode)mode {
    if (self = [super init]) {
        _mode = mode;
    }
    
    return self;
}


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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:lyChooseTrainBaseTableViewCellReuseIdentifier];
    self.tableView.tableFooterView  = [UIView new];
    
    self.refreshControl = [LyUtil refreshControlWithTitle:nil
                                                   target:self
                                                   action:@selector(refresh:)];
    
    
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    [self.searchController.searchBar sizeToFit];
    self.definesPresentationContext = YES;
    
    
    arrTrainBases = [[NSMutableArray alloc] initWithCapacity:1];

}


- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    switch (_mode) {
        case LyChooseTrainBaseTableViewControllerMode_all: {
            NSString *address = [_delegate obtainAddressByChooseTrainBaseTVC:self];
            
            NSArray *arr = [LyUtil separateString:address separator:@" "];
            
            if (!arr || arr.count < 2) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            
            curProvince = [arr objectAtIndex:0];
            curCity = [arr objectAtIndex:1];
            break;
        }
        case LyChooseTrainBaseTableViewControllerMode_school: {
            
            curSchoolId = [_delegate obtainSchoolIdByChooseTrainBaseTVC:self];
            
            break;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {

    if (LyChooseTrainBaseTableViewControllerMode_all == _mode && !curCity) {
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  
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
        
        [self.searchController.searchBar setPlaceholder:@"搜索基地"];
    }
    
    return _searchController;
}


- (LySearchResultTableViewController *)searchResultTVC {
    if (!_searchResultTVC) {
        _searchResultTVC = [LySearchResultTableViewController searchResultTableViewControllerWithKeyForShow:@"tbName"];
        [_searchResultTVC setDelegate:self];
    }
    
    return _searchResultTVC;
}



- (void)reloadData {
    [self removeViewNull];
    [self removeViewError];
    
    [self.tableView reloadData];
}



- (void)showViewError
{
    if ( !viewError)
    {
        viewError = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.2f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewError addSubview:[LyUtil lbErrorWithMode:0]];
    }
    
    [self.tableView addSubview:viewError];
    [self.tableView setContentSize:CGSizeMake( SCREEN_WIDTH, SCREEN_HEIGHT*1.2f)];
}

- (void)removeViewError {
    [viewError removeFromSuperview];
    viewError = nil;
}


- (void)showViewNull {
    if ( !viewNull)
    {
        viewNull = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.2f)];
        [viewNull setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewNull addSubview:[LyUtil lbNullWithText:@"还没有相关数据"]];
    }
    
    
    [self.tableView addSubview:viewNull];
    [self.tableView setContentSize:CGSizeMake( SCREEN_WIDTH, SCREEN_HEIGHT*1.2f)];
}

- (void)removeViewNull {
    [viewNull removeFromSuperview];
    viewNull = nil;
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
    
    NSString *strUrl = getAllTrainBase_url;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    switch (_mode) {
        case LyChooseTrainBaseTableViewControllerMode_all: {
            [dic setObject:[curCity substringToIndex:curCity.length-1] forKey:cityKey];
            break;
        }
        case LyChooseTrainBaseTableViewControllerMode_school: {
            [dic setObject:curSchoolId forKey:userIdKey];
            strUrl = getTrainBase_url;
            break;
        }
    }
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:chooseTrainBaseHttpMethod_load];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:strUrl
                                          body:dic
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}


- (void)handleHttpFailed {
    if ([indicator_load isAnimating]) {
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
        case chooseTrainBaseHttpMethod_load: {
            
            if ( [arrTrainBases count])
            {
                [arrTrainBases removeAllObjects];
            }
            
            switch ( [strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (!arrResult || ![LyUtil validateArray:arrResult]) {
                        [indicator_load stopAnimation];
                        [self.refreshControl endRefreshing];
                        [self showViewNull];
                        return;
                    }
                    
                    for (NSDictionary *dicItem in arrResult) {
                        if ( !dicItem || ![LyUtil validateDictionary:dicItem]){
                            continue;
                        }
                        
                        NSString *strId = [dicItem objectForKey:idKey];
                        NSString *strName = [dicItem objectForKey:trainBaseNameKey];
                        
                        
                        if ( strId && [LyUtil validateString:strId]) {
                            LyTrainBase *trainBase = [LyTrainBase trainBaseWithTbId:strId
                                                                             tbName:strName
                                                                          tbAddress:@""
                                                                       tbCoachCount:0
                                                                     tbStudentCount:0];
                            if ( !arrTrainBases) {
                                arrTrainBases = [[NSMutableArray alloc] initWithCapacity:1];
                            }
                            
                            [arrTrainBases addObject:trainBase];
                        }
                        
                    }
                    
                    NSDictionary *dicTrainBaseTmp = [LyPinyinGroup group:arrTrainBases key:@"tbName"];
                    arrTrainBaseSections = [dicTrainBaseTmp objectForKey:LyPinyinGroupNameKey];
                    arrTrainBaseRows = [dicTrainBaseTmp objectForKey:LyPinyinGroupResultKey];
                    
                    [self reloadData];
                    
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
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest
{
    if ( bHttpFlag)
    {
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
        [self analysisHttpRequest:result];
    }
    
    curHttpMethod = 0;
}


#pragma mark -LySearchResultTableViewControllerDelegate
- (void)onSelectedItemBySearchResultTVC:(LySearchResultTableViewController *)aSearchResultTVC object:(id)object {
    
    LyTrainBase *trainBase = (LyTrainBase *)object;
    
    [_delegate onDoneByChooseTrainBase:self trainBase:trainBase];
}


#pragma mark -UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    arrSearchResult = nil;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.tbName contains [c] %@", searchController.searchBar.text];
    arrSearchResult = [[NSMutableArray alloc] initWithArray:[arrTrainBases filteredArrayUsingPredicate:predicate]];
    
//    [LyUtil sortArr:arrSearchResult andKey:@"tbName"];
    arrSearchResult = [LyUtil sortArrByStr:arrSearchResult andKey:@"tbName"];
    
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

    [_delegate onDoneByChooseTrainBase:self trainBase:[[arrTrainBaseRows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (!arrTrainBaseSections || arrTrainBaseSections.count < 1) {
        [self showViewNull];
    }
    else {
        [self removeViewNull];
    }
    
    return arrTrainBaseSections.count;

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[arrTrainBaseRows objectAtIndex:section] count];
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [arrTrainBaseSections objectAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyChooseTrainBaseTableViewCellReuseIdentifier forIndexPath:indexPath];
    if ( !cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:lyChooseTrainBaseTableViewCellReuseIdentifier];
    }
    
    [cell.textLabel setText:[[[arrTrainBaseRows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] tbName]];
    
    return cell;
}


- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return arrTrainBaseSections;
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
