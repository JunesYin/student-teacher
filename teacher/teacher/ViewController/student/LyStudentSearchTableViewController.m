//
//  LyStudentSearchTableViewController.m
//  teacher
//
//  Created by Junes on 16/8/20.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyStudentSearchTableViewController.h"
#import "LyStudentTableViewCell.h"

#import "LyStudentManager.h"

#import "LyUtil.h"

@interface LyStudentSearchTableViewController () <UISearchBarDelegate>
{
    NSArray                     *arrStudent;
    
    NSArray                     *arrSearch;
    
    UISearchBar                 *searchBar;
}
@end

@implementation LyStudentSearchTableViewController

static NSString *const lyStudentSearchTableViewCellReuseIdentifier = @"lyStudentSearchTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    [searchBar setDelegate:self];
    [searchBar setTintColor:Ly517ThemeColor];
    [searchBar setShowsCancelButton:NO];
    [self.navigationItem setTitleView:searchBar];
    
    UIBarButtonItem *bbiCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    [self.navigationItem setRightBarButtonItem:bbiCancel];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:lyStudentSearchTableViewCellReuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    arrSearch = arrStudent = [[LyStudentManager sharedInstance] getAllStudent];
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length < 1)
    {
        arrSearch = arrStudent;
        [self.tableView reloadData];
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.userName contains [cd] %@", searchText];
        arrSearch = [[NSArray alloc] initWithArray:[arrStudent filteredArrayUsingPredicate:predicate]];
        
        [self.tableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissViewControllerAnimated:NO completion:^{
        ;
    }];
}





#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrSearch.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyStudentSearchTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:lyStudentSearchTableViewCellReuseIdentifier];
    }
    [cell.textLabel setText:[[arrSearch objectAtIndex:indexPath.row] userName]];
    
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
