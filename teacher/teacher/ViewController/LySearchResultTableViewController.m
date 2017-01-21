//
//  LySearchResultTableViewController.m
//  teacher
//
//  Created by Junes on 17/10/2016.
//  Copyright © 2016 517xueche. All rights reserved.
//

#import "LySearchResultTableViewController.h"

@interface LySearchResultTableViewController ()

@end

@implementation LySearchResultTableViewController

static NSString *const lySearchResultTableViewCellReuseIdentifier = @"lySearchResultTableViewCellReuseIdentifier";


+ (instancetype)searchResultTableViewControllerWithKeyForShow:(NSString *)keyForShow {
    LySearchResultTableViewController *searchResult = [[LySearchResultTableViewController alloc] initWithKeyForShow:keyForShow];
    
    return searchResult;
}

- (instancetype)initWithKeyForShow:(NSString *)keyForShow {
    if (self = [super init]) {
        _keyForShow = keyForShow;
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
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:lySearchResultTableViewCellReuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setArrSearchResult:(NSArray *)arrSearchResult {
    _arrSearchResult = arrSearchResult;
    
    [self.tableView reloadData];
}


#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_delegate onSelectedItemBySearchResultTVC:self object:[_arrSearchResult objectAtIndex:indexPath.row]];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrSearchResult.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lySearchResultTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:lySearchResultTableViewCellReuseIdentifier];
    }
    
    [cell.textLabel setText:[[_arrSearchResult objectAtIndex:indexPath.row] valueForKey:_keyForShow]];
    
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
