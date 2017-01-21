//
//  LyExamHistoryLocalTableViewController.m
//  student
//
//  Created by MacMini on 2016/12/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyExamHistoryLocalTableViewController.h"
#import "LyExamHistoryTableViewCell.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyExamHistory.h"

#import "LyUtil.h"


#define ehlLbAverScoreFont          LyFont(14)
#define ehlLbAverScoreNumFont       LyFont(18)


@interface LyExamHistoryLocalTableViewController ()
{
    UIView      *viewHeader;
    UILabel     *lbAverScore;
    
    NSInteger       averScore;
    NSMutableArray      *arrExamHistory;
}

@property (strong, nonatomic)       LyIndicator     *indicator;

@end

@implementation LyExamHistoryLocalTableViewController

static NSString *const lyExamHistoryLocalTableViewCellReudeIdentifier = @"lyExamHistoryLocalTableViewCellReudeIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self load];
}

- (void)initSubviews {
    self.title = @"考试记录";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    
    viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2.0f)];
    [viewHeader setBackgroundColor:LyWhiteLightgrayColor];
    
    UIImageView *ivBack = [[UIImageView alloc] initWithFrame:viewHeader.bounds];
    [ivBack setImage:[LyUtil imageForImageName:@"simulate_history_averageScore" needCache:NO]];
    [ivBack setContentMode:UIViewContentModeScaleAspectFit];
    
    lbAverScore = [[UILabel alloc] initWithFrame:viewHeader.bounds];
    [lbAverScore setFont:ehlLbAverScoreFont];
    [lbAverScore setTextColor:Ly517ThemeColor];
    [lbAverScore setTextAlignment:NSTextAlignmentCenter];
    [lbAverScore setNumberOfLines:0];
    
    [viewHeader addSubview:ivBack];
    [viewHeader addSubview:lbAverScore];
    
    [self.tableView setTableHeaderView:viewHeader];
    [self.tableView registerClass:[LyExamHistoryTableViewCell class] forCellReuseIdentifier:lyExamHistoryLocalTableViewCellReudeIdentifier];
    [self.tableView setTableFooterView:[UIView new]];
}

- (LyIndicator *)indicator {
    if (!_indicator) {
        _indicator = [LyIndicator indicatorWithTitle:nil];
    }
    
    return _indicator;
}

- (void)reloadData {
    NSString *strAverageScoreNum = [[NSString alloc] initWithFormat:@"你的平均成绩为%ld分", averScore];
    NSString *strAverageScoreTxt = ({
        NSString *str;
        switch ([LyExamHistory cacluExamLevel:averScore]) {
            case LyExamLevel_killer: {
                str = @"不要灰心，再来一次！";
                break;
            }
            case LyExamLevel_newbird: {
                str = @"哎呦不错哦，继续加油！";
                break;
            }
            case LyExamLevel_mass: {
                str = @"哇塞！你可以参加考试了！";
                break;
            }
            case LyExamLevel_superior: {
                str = @"大神级别！小吾膜拜！";
                break;
            }
            default: {
                str = @"不要灰心，再来一次！";
                break;
            }
        }
        
        str;
    });
    
    NSString *strAverageScoreTmp = [[NSString alloc] initWithFormat:@"%@\n\n%@", strAverageScoreNum, strAverageScoreTxt];
    NSMutableAttributedString *strAverageScore = [[NSMutableAttributedString alloc] initWithString:strAverageScoreTmp];
    [strAverageScore addAttribute:NSFontAttributeName value:ehlLbAverScoreNumFont range:[strAverageScoreTmp rangeOfString:strAverageScoreNum]];
    [lbAverScore setAttributedText:strAverageScore];
    
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)load {
    [self.indicator startAnimation];
    [self performSelector:@selector(load_genuine) withObject:nil afterDelay:LyDelayTime];
}

- (void)load_genuine {
    NSString *sqlQue = [[NSString alloc] initWithFormat:@"SELECT id, score, usetime, stime FROM %@ WHERE userid = '%@' AND jtype = '%@' ORDER BY id DESC",
                        LyRecordTableName_examScore,
                        [LyCurrentUser curUser].userIdForTheory,
                        [[LyCurrentUser curUser] userLicenseTypeByString]
                        ];
    FMResultSet *rsQue = [[LyUtil dbRecord] executeQuery:sqlQue];
    while ([rsQue next]) {
        NSString *sId = [rsQue stringForColumn:@"id"];
        NSInteger iScore = [rsQue intForColumn:@"score"];
        NSString *sUseTime = [rsQue stringForColumn:@"usetime"];
        NSString *sTime = [rsQue stringForColumn:@"stime"];
        
        LyExamHistory *examHistory = [LyExamHistory examHistoryWithId:sId
                                                               userId:[LyCurrentUser curUser].userIdForTheory
                                                                score:iScore
                                                                 time:sUseTime
                                                                 date:sTime];
        
        if (!arrExamHistory) {
            arrExamHistory = [[NSMutableArray alloc] initWithCapacity:1];
        }
        
        [arrExamHistory addObject:examHistory];
    }
    
    NSInteger totalScore = 0;
    for (LyExamHistory *examHistory in arrExamHistory) {
        totalScore += examHistory.score;
    }
    
    averScore = totalScore / arrExamHistory.count;
    
    [self reloadData];
    [self.indicator stopAnimation];
}


#pragma mark -UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ehcellHeight;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrExamHistory.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyExamHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyExamHistoryLocalTableViewCellReudeIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[LyExamHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyExamHistoryLocalTableViewCellReudeIdentifier];
    }
    
    [cell setIndex:indexPath.row + 1];
    [cell setExamHistory:arrExamHistory[indexPath.row]];
    
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
