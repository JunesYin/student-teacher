//
//  LyStudyGuidanceTableViewController.m
//  student
//
//  Created by Junes on 16/8/29.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyStudyGuidanceTableViewController.h"
#import "LyLeftMenuSettingTableViewCell.h"

#import "LyUtil.h"



@interface LyStudyGuidanceTableViewController ()
{
    NSArray             *arrItems;
}
@end

@implementation LyStudyGuidanceTableViewController

static NSString *const lyStudyGuidanceTvItemsCellReuseIdentifier = @"lyStudyGuidanceTvItemsCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"学车指南";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    arrItems = @[
                 @"学车流程",
                 @"驾考大纲",
                 @"择校指南",
                 @"报名须知",
                 @"体检事项",
                 @"学车费用",
                 @"作弊处理",
                 @"残疾人学车"
                 ];
    
    [self.tableView registerClass:[LyLeftMenuSettingTableViewCell class] forCellReuseIdentifier:lyStudyGuidanceTvItemsCellReuseIdentifier];
    [self.tableView setTableFooterView:[UIView new]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return lmstcellHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [LyUtil showWebViewController:LyWebMode_studyFlow + indexPath.row target:self];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LyLeftMenuSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyStudyGuidanceTvItemsCellReuseIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[LyLeftMenuSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyStudyGuidanceTvItemsCellReuseIdentifier];
    }
    
    [cell setCellInfo:[LyUtil imageForImageName:[[NSString alloc] initWithFormat:@"studyGuide_item_%ld", indexPath.row] needCache:NO]
                title:[arrItems objectAtIndex:indexPath.row]
               detail:@""];
    
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
