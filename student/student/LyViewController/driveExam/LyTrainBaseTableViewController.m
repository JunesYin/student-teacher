//
//  LyTrainBaseTableViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/17.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyTrainBaseTableViewController.h"
#import "LyTrainBaseTableViewCell.h"


#import "LyTrainBaseManager.h"

#import "LyIndicator.h"
#import "LyCurrentUser.h"

#import "LyUtil.h"





@interface LyTrainBaseTableViewController ()
{
    
}
@end

@implementation LyTrainBaseTableViewController

static NSString *const lyTrainBaseTableViewCellReuseIdentifier = @"lyTrainBaseTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
//     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    [self.tableView registerClass:[LyTrainBaseTableViewCell class] forCellReuseIdentifier:lyTrainBaseTableViewCellReuseIdentifier];
    [self.tableView setTableFooterView:[UIView new]];
 
    
//    UIRefreshControl *refresher = [[UIRefreshControl alloc] init];
//    NSMutableAttributedString *strRefresherTitle = [[NSMutableAttributedString alloc] initWithString:@"正在加载"];
//    [strRefresherTitle addAttribute:NSForegroundColorAttributeName value:LyRefresherColor range:NSMakeRange( 0, [@"正在加载" length])];
//    [refresher setAttributedTitle:strRefresherTitle];
//    [refresher addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
//    [refresher setTintColor:LyRefresherColor];
//    [self setRefreshControl:refresher];
}



- (void)viewWillAppear:(BOOL)animated
{
    NSString *strDriveSchoolId = [_delegate obtainDriveSchoolIdByTrainBaseTableViewController:self];
    
    if ( !_driveSchoolId || ![_driveSchoolId isEqualToString:strDriveSchoolId])
    {
        _driveSchoolId = strDriveSchoolId;
        
        _arrTrainBase = [_delegate obtainArrTrainBaseByTrainBaseTableViewController:self];
        [self.tableView reloadData];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tbcellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrTrainBase count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyTrainBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyTrainBaseTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    if ( !cell)
    {
        cell = [[LyTrainBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyTrainBaseTableViewCellReuseIdentifier];
    }
    [cell setTrainBase:[_arrTrainBase objectAtIndex:[indexPath row]]];

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
