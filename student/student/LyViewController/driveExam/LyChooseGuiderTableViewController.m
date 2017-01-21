//
//  LyChooseGuiderTableViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/17.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyChooseGuiderTableViewController.h"

#import "LyIndicator.h"


#import "LyGuider.h"
#import "LyPinyinGroup.h"

#import "LyCurrentUser.h"

#import "LyUtil.h"


NSString * const lyChooseGuiderTableViewCellReuseIdentifier = @"lyChooseGuiderTableViewCellReuseIdentifier";


typedef NS_ENUM( NSInteger, LyChooseGuiderTableViewControllerHttpMethod)
{
    chooseGuiderTableViewControllerHttpMethod_load
};



@interface LyChooseGuiderTableViewController ()< UISearchBarDelegate, UISearchDisplayDelegate, LyHttpRequestDelegate>
{
    UISearchDisplayController   *searchDisplay;
    
    UIView                      *viewError;
    UIView                      *viewNull;
    
    NSMutableArray              *arrGuider;
    NSArray                     *arrSearchResult;
    
    
    NSArray                     *arrGuiderSection;
    NSArray                     *arrGuiderRows;
    
    LyIndicator                 *indicator_load;
    BOOL                        bHttpFlag;
    LyChooseGuiderTableViewControllerHttpMethod    curHttpMethod;
}
@end

@implementation LyChooseGuiderTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    [searchBar setBackgroundColor:LyWhiteLightgrayColor];
    [searchBar setTintColor:Ly517ThemeColor];
    [searchBar sizeToFit];
    [searchBar setDelegate:self];
    
    searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    [searchDisplay setDelegate:self];
    [searchDisplay setSearchResultsDelegate:self];
    [searchDisplay setSearchResultsDataSource:self];
    [searchDisplay.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:lyChooseGuiderTableViewCellReuseIdentifier];
    
    
    
    [self.tableView setTableHeaderView:searchBar];
    [self.tableView setSectionIndexColor:LyBlackColor];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:lyChooseGuiderTableViewCellReuseIdentifier];
    
    
    UIRefreshControl *refresher = [[UIRefreshControl alloc] init];
    NSMutableAttributedString *strRefresherTitle = [[NSMutableAttributedString alloc] initWithString:@"正在加载"];
    [strRefresherTitle addAttribute:NSForegroundColorAttributeName value:LyRefresherColor range:NSMakeRange( 0, [@"正在加载" length])];
    [refresher setAttributedTitle:strRefresherTitle];
    [refresher addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [refresher setTintColor:LyRefresherColor];
    [self setRefreshControl:refresher];
}



- (void)viewWillAppear:(BOOL)animated
{
    NSString *strAddress;
    strAddress = [_delegate obtainAddressByChooseGuiderTableViewController:self];
    
    if ( !strAddress || ![_address isEqualToString:strAddress] || ![arrGuider count])
    {
        _address = strAddress;
        [self refreshData:self.refreshControl];
    }
}




- (void)showViewNull
{
    if ( !viewNull)
    {
        viewNull = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.1f)];
        [viewNull setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *lbNull = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, LyLbNullHeight)];
        [lbNull setBackgroundColor:[UIColor whiteColor]];
        [lbNull setTextAlignment:NSTextAlignmentCenter];
        [lbNull setFont:LyNullItemTitleFont];
        [lbNull setTextColor:LyNullItemTextColor];
        [lbNull setText:@"还没有相关数据"];
        
        [viewNull addSubview:lbNull];
    }
    
    [self.tableView setContentSize:CGSizeMake( SCREEN_WIDTH, SCREEN_HEIGHT*1.1f)];
    [self.tableView addSubview:viewNull];
    [self.tableView bringSubviewToFront:viewNull];
}

- (void)removeViewNull
{
    [viewNull removeFromSuperview];
}


- (void)showViewError
{
    if ( !viewError)
    {
        viewError = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.1f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        UILabel *lbError = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, LyLbErrorHeight)];
        [lbError setBackgroundColor:LyWhiteLightgrayColor];
        [lbError setTextAlignment:NSTextAlignmentCenter];
        [lbError setFont:LyNullItemTitleFont];
        [lbError setTextColor:LyNullItemTextColor];
        [lbError setText:@"加载失败，下拉再次加载"];
        
        [viewError addSubview:lbError];
    }
    
    [self.tableView setContentSize:CGSizeMake( SCREEN_WIDTH, SCREEN_HEIGHT*1.1f)];
    [self.tableView addSubview:viewError];
    [self.tableView bringSubviewToFront:viewError];
}


- (void)refreshData:(UIRefreshControl *)refreControl
{
    [self loadData];
}



- (void)loadData
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(loadData) object:nil];
        return;
    }
    
    if ( !indicator_load)
    {
        indicator_load = [[LyIndicator alloc] initWithTitle:@"正在加载..."];
    }
    [indicator_load startAnimation];
    
    NSArray *arrAddress = [LyUtil separateString:_address separator:@" "];
    NSString *strCity;
    if (arrAddress && arrAddress.count > 1) {
        strCity = [arrAddress objectAtIndex:1];
        strCity = [strCity substringToIndex:strCity.length - 1];
    } else {
        strCity = @"上海";
    }
    
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:chooseGuiderTableViewControllerHttpMethod_load];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:getTeacher_url
                                          body:@{
                                                 userTypeKey:userTypeGuiderKey,
                                                 addressKey:strCity,
                                                 cityKey:strCity,
                                                 userIdKey:[[LyCurrentUser curUser] userId],
                                                 sessionIdKey:[LyUtil httpSessionId]
                                                 }
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
        
        [LyUtil sessionTimeOut:self];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_load stopAnimation];
        [self.refreshControl endRefreshing];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    
    switch ( curHttpMethod) {
        case chooseGuiderTableViewControllerHttpMethod_load: {
            
            if ( [arrGuider count])
            {
                [arrGuider removeAllObjects];
            }
            switch ( [strCode integerValue]) {
                case 0: {
                    
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateArray:arrResult])
                    {
                        if ( [self.refreshControl isRefreshing])
                        {
                            [self.refreshControl endRefreshing];
                        }
                        
                        [indicator_load stopAnimation];
                        [self showViewNull];
                    }
                    
                    for (NSDictionary *dicItem in arrResult) {
                        
//                        NSDictionary *dicItem = [arrResult objectAtIndex:i];
                        if (![LyUtil validateDictionary:dicItem]) {
                            continue;
                        }
                        NSString *strId = [dicItem objectForKey:userIdKey];
                        NSString *strName = [dicItem objectForKey:nickNameKey];
                        
                        
                        if ([LyUtil validateString:strId]) {
                            LyGuider *guider = [LyGuider guiderWithIdNoAvatar:strId
                                                                     userName:strName];
                            
                            if ( !arrGuider) {
                                arrGuider = [[NSMutableArray alloc] initWithCapacity:1];
                            }
                            
                            [arrGuider addObject:guider];
                        }
                        
                    }
                    
                    NSDictionary *dicSchoolTmp = [LyPinyinGroup group:arrGuider key:@"userName"];
                    arrGuiderSection = [dicSchoolTmp objectForKey:LyPinyinGroupNameKey];
                    arrGuiderRows = [dicSchoolTmp objectForKey:LyPinyinGroupResultKey];
                    
                    [self.tableView reloadData];
                    [indicator_load stopAnimation];
                    if ( [self.refreshControl isRefreshing])
                    {
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view deleagate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( tableView == self.tableView)
    {
        return 30.0f;
    }
    
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( tableView == self.tableView)
    {
        [_delegate onSelectedGuiderByChooseGuiderTableViewController:self andGuider:[[arrGuiderRows objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]]];
    }
    else if ( tableView == searchDisplay.searchResultsTableView)
    {
        [_delegate onSelectedGuiderByChooseGuiderTableViewController:self andGuider:[arrSearchResult objectAtIndex:[indexPath row]]];
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ( tableView == self.tableView)
    {
        return [arrGuiderSection count];
    }
    else if ( tableView == searchDisplay.searchResultsTableView)
    {
        return 1;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( tableView == self.tableView)
    {
        return [[arrGuiderRows objectAtIndex:section] count];
    }
    else if ( tableView == searchDisplay.searchResultsTableView)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.userName contains [cd] %@", searchDisplay.searchBar.text];
        arrSearchResult = [[NSArray alloc] initWithArray:[arrGuider filteredArrayUsingPredicate:predicate]];
        
        return [arrSearchResult count];
    }
    
    return 0;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ( tableView == self.tableView)
    {
        return [arrGuiderSection objectAtIndex:section];
    }
    
    
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyChooseGuiderTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    if ( !cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:lyChooseGuiderTableViewCellReuseIdentifier];
    }
    
    if ( tableView == self.tableView)
    {
        [[cell textLabel] setText:[[[arrGuiderRows objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] userName]];
    }
    else if ( tableView == searchDisplay.searchResultsTableView)
    {
        [[cell textLabel] setText:[[arrSearchResult objectAtIndex:[indexPath row]] userName]];
    }
    
    return cell;
}


- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ( tableView == self.tableView)
    {
        return arrGuiderSection;
    }
    
    return nil;
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
