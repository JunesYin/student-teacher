//
//  LyMyMistakeLocalTableViewController.m
//  student
//
//  Created by MacMini on 2016/12/22.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyMyMistakeLocalTableViewController.h"
#import "LyChapterTableViewCell.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"

#import "LyUtil.h"

#import "LyViewMistakeLocalViewController.h"
#import "LyExeciseMistakeLocalViewController.h"


typedef NS_ENUM(NSInteger, LyMyMistakeLocalBarButtonItemTag) {
    myMistakeLocalBarButtonItemTag_clear = 10,
};



@interface LyMyMistakeLocalTableViewController ()
{
    NSInteger       count;
}

@property (strong, nonatomic)       LyIndicator     *indicator;

@end

@implementation LyMyMistakeLocalTableViewController

static NSString *const lyMyMistakeTableViewCellReuseIdentifier = @"lyMyMistakeTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [self load];
}

- (void)initSubviews {
    self.title = @"我的错题";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    UIBarButtonItem *bbiClear = [[UIBarButtonItem alloc] initWithTitle:@"清空"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(targetForBarButtonItem:)];
    [bbiClear setTag:myMistakeLocalBarButtonItemTag_clear];
    [self.navigationItem setRightBarButtonItem:bbiClear];
    
    
    [self.tableView registerClass:[LyChapterTableViewCell class] forCellReuseIdentifier:lyMyMistakeTableViewCellReuseIdentifier];
    [self.tableView setTableFooterView:[UIView new]];
}

- (LyIndicator *)indicator {
    if (!_indicator) {
        _indicator = [LyIndicator indicatorWithTitle:nil];
    }
    
    return _indicator;
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    LyMyMistakeLocalBarButtonItemTag bbiTag = bbi.tag;
    switch (bbiTag) {
        case myMistakeLocalBarButtonItemTag_clear: {
            UIAlertController *action = [UIAlertController alertControllerWithTitle:@"确定要清空错题吗？"
                                                                            message:nil
                                                                     preferredStyle:UIAlertControllerStyleActionSheet];
            [action addAction:[UIAlertAction actionWithTitle:@"清空"
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self clear];
                                                     }]];
            [action addAction:[UIAlertAction actionWithTitle:@"取消"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil]];
            [self presentViewController:action animated:YES completion:nil];
            break;
        }
    }
}

- (void)load {
    [self.indicator startAnimation];
    
    [self performSelector:@selector(load_genuine) withObject:nil afterDelay:LyDelayTime];
}

- (void)load_genuine {
    NSString *sqlQue = [[NSString alloc] initWithFormat:@"SELECT count(id) AS num FROM %@ WHERE userid = '%@' AND subjects = %@ AND jtype = '%@'",
                        LyRecordTableName_exeMistake,
                        [LyCurrentUser curUser].userIdForTheory,
                        @([LyCurrentUser curUser].userSubjectMode),
                        [[LyCurrentUser curUser] userLicenseTypeByString]
                        ];
    FMResultSet *rsQue = [[LyUtil dbRecord] executeQuery:sqlQue];
    while ([rsQue next]) {
        count = [rsQue intForColumn:@"num"];
        break;
    }
    
    [self reloadData];
    
    [self.indicator stopAnimation];
}

- (void)clear {
    [self.indicator setTitle:@"正在清空"];
    [self.indicator startAnimation];
    
    [self performSelector:@selector(clear_genuine) withObject:nil afterDelay:LyDelayTime];
}

- (void)clear_genuine {
    NSString *sqlDel = [[NSString alloc] initWithFormat:@"DELETE FROM %@ WHERE userid = '%@' AND subjects = %@ AND jtype = '%@'",
                        LyRecordTableName_exeMistake,
                        [LyCurrentUser curUser].userIdForTheory,
                        @([LyCurrentUser curUser].userSubjectMode),
                        [LyCurrentUser curUser].userLicenseTypeByString
                        ];
    
    BOOL flag = [[LyUtil dbRecord] executeUpdate:sqlDel];
    
    if (flag) {
        count = 0;
        [self reloadData];
        [self.indicator stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"清空成功"] show];
    } else {
        [self.indicator stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"清空失败"] show];
    }
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return chaptcHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (count < 1) {
        [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没有错题"] show];
        return;
    }
    
    switch (indexPath.row) {
        case 0: {
            LyViewMistakeLocalViewController *viewMistake = [[LyViewMistakeLocalViewController alloc] init];
            [self.navigationController pushViewController:viewMistake animated:YES];
            break;
        }
        case 1: {
            LyExeciseMistakeLocalViewController *execiseMistake = [[LyExeciseMistakeLocalViewController alloc] init];
            [self.navigationController pushViewController:execiseMistake animated:YES];
            break;
        }
        default:
            break;
    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyChapterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyMyMistakeTableViewCellReuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[LyChapterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyMyMistakeTableViewCellReuseIdentifier];
    }
    
    NSString *sTitle = nil;
    
    switch (indexPath.row) {
        case 0: {
            sTitle = @"查看错题";
            break;
        }
        case 1: {
            sTitle = @"练习错题";
            break;
        }
        default:
            break;
    }
    
    [cell setCellTitleWithMode:LyChapterTableViewCellMode_myMistake
                         title:sTitle
                      allCount:count
                      andIndex:indexPath.row];
    
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
