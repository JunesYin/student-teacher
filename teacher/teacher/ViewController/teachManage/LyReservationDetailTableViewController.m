//
//  LyReservationDetailTableViewController.m
//  teacher
//
//  Created by Junes on 2016/9/23.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyReservationDetailTableViewController.h"
#import "LyReservationDetailTableViewCell.h"

#import "LyDateTimeInfo.h"

#import "LyUtil.h"

@interface LyReservationDetailTableViewController ()
{
    NSArray                 *arrItems;
}
@end

@implementation LyReservationDetailTableViewController

static NSString *const lyReservationDetailTvCellReuseIdentifier = @"lyReservationDetailTvCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"预约详情";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [self.tableView registerClass:[LyReservationDetailTableViewCell class] forCellReuseIdentifier:lyReservationDetailTvCellReuseIdentifier];
    [self.tableView setTableFooterView:[UIView new]];
    
    arrItems = @[
                 @"学生姓名",
                 @"联系电话",
                 @"驾照类型",
                 @"预约科目",
                 @"预约时间",
                 @"当前状态"
                 ];
}

- (void)viewWillAppear:(BOOL)animated {
    _dateTimeInfo = [_delegate obtainDateTimeInfoByReservationDetailTVC:self];
    
    [self reloadData];
}


- (void)reloadData {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -UITableViewDeelagte
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rdtcellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (1 == indexPath.row) {
        
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LyReservationDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyReservationDetailTvCellReuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[LyReservationDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyReservationDetailTvCellReuseIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    NSString *strDetail;
    switch (indexPath.row) {
        case 0: {
            strDetail = _dateTimeInfo.masterName;
            break;
        }
        case 1: {
            strDetail = _dateTimeInfo.masterPhone;
            break;
        }
        case 2: {
            strDetail = [LyUtil driveLicenseStringFrom:_dateTimeInfo.license];
            break;
        }
        case 3: {
            strDetail = [LyUtil subjectModePracStringForm:_dateTimeInfo.subject];
            break;
        }
        case 4: {
            strDetail = [_dateTimeInfo dateTimeInfo];
            break;
        }
        case 5: {
            strDetail = [_dateTimeInfo stateStudy];
            break;
        }
        default: {
            strDetail = @"";
            break;
        }
    }
    
    [cell setCellInfo:[arrItems objectAtIndex:indexPath.row]
               detail:strDetail];
    
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
