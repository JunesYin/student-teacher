//
//  LyQueBankLocalTableViewController.m
//  student
//
//  Created by MacMini on 2016/12/22.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyQueBankLocalTableViewController.h"
#import "LyChapterTableViewCell.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyChapter.h"

#import "LyUtil.h"


#import "LyMyQueAnalysisLocalViewController.h"


typedef NS_ENUM(NSInteger, LyQueBankLocalBarButtonItemTag) {
    queBankLocalBarButtonItemTag_clear = 10,
};


@interface LyQueBankLocalTableViewController () <LyMyQueAnalysisLocalViewControllerDelegate>
{
    NSMutableArray      *arrChapters;
    
    NSIndexPath     *curIdx;
}

@property (strong, nonatomic)       LyIndicator     *indicator;

@end

@implementation LyQueBankLocalTableViewController

static NSString *const lyQueBankLocalTableViewReuseIdentifier = @"lyQueBankLocalTableViewReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!arrChapters || arrChapters.count < 1) {
        [self load];
    } else {
        [self reloadData];
    }
}

- (void)initSubviews {
    self.title = @"我的题库";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    UIBarButtonItem *bbiClear = [[UIBarButtonItem alloc] initWithTitle:@"清空"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(targetForBarButtonItem:)];
    [bbiClear setTag:queBankLocalBarButtonItemTag_clear];
    [self.navigationItem setRightBarButtonItem:bbiClear];
    
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView registerClass:[LyChapterTableViewCell class] forCellReuseIdentifier:lyQueBankLocalTableViewReuseIdentifier];

    arrChapters = [[NSMutableArray alloc] initWithCapacity:1];
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
    LyQueBankLocalBarButtonItemTag bbiTag = bbi.tag;
    switch (bbiTag) {
        case queBankLocalBarButtonItemTag_clear: {
            BOOL flag = NO;
            for (LyChapter *chapter in arrChapters) {
                if (chapter.chapterNum > 0) {
                    flag = YES;
                    break;
                }
            }
            
            if (!flag) {
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"题库为空"] show];
                return;
            }
            
            UIAlertController *action = [UIAlertController alertControllerWithTitle:@"确定要清空我的题库吗？"
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
    [self.indicator setTitle:nil];
    [self.indicator startAnimation];
    
    [self performSelector:@selector(load_genuine) withObject:nil afterDelay:LyDelayTime];
}

- (void)load_genuine {
    NSString *curProvince = nil;
    NSArray *arrAddress = [LyUtil separateString:[LyCurrentUser curUser].userExamAddress separator:@" "];
    if (arrAddress && arrAddress.count > 1) {
        curProvince = [arrAddress objectAtIndex:0];
        curProvince = [curProvince substringToIndex:curProvince.length - 1];
    }
    
    NSInteger iProvinceId = 0;
    if (LySubjectMode_first == [LyCurrentUser curUser].userSubjectMode && [LyUtil validateString:curProvince]) {
        NSString *sqlPro = [[NSString alloc] initWithFormat:@"SELECT id FROM theory_province WHERE province LIKE '%%%@%%'", curProvince];
        FMResultSet *rsProvince = [[LyUtil dbTheory] executeQuery:sqlPro];
        while ([rsProvince next]) {
            iProvinceId = [rsProvince intForColumnIndex:0];
            break;
        }
    }
    
    NSString *sqlCha = [[NSString alloc] initWithFormat:@"SELECT classname, classsmalltype FROM %@ WHERE classtype = %@",
                        LyTheoryTableName_chapter,
                        @([LyCurrentUser curUser].userSubjectMode)
                        ];
    FMResultSet *rsCha = [[LyUtil dbTheory] executeQuery:sqlCha];
    while ([rsCha next]) {
        NSInteger iId = [rsCha intForColumn:@"classsmalltype"];
        NSString *sChapterName = [rsCha stringForColumn:@"classname"];
        
        NSInteger iCount;
        NSString *sqlCount = [[NSString alloc] initWithFormat:@"SELECT COUNT(id) AS count FROM %@ WHERE userId = '%@' AND subjects = %@ AND ChapterId = %@ AND jtype = '%@'",
                              LyRecordTableName_queBank,
                              [LyCurrentUser curUser].userIdForTheory,
                              @([LyCurrentUser curUser].userSubjectMode),
                              @(iId),
                              [LyCurrentUser curUser].userLicenseTypeByString
                              ];
        FMResultSet *rsCount = [[LyUtil dbRecord] executeQuery:sqlCount];
        while ([rsCount next]) {
            iCount = [rsCount intForColumn:@"count"];
            break;
        }
        
        LyChapter *chapter = [LyChapter chapterWithMode:iId
                                            chapterName:sChapterName
                                             chapterNum:iCount
                                                    tid:0
                                                  index:0];
        
        if (iProvinceId > 0 && [sChapterName rangeOfString:@"题库"].length > 0) {
            [chapter setChapterName:[curProvince stringByAppendingString:sChapterName]];
            [chapter setProvinceId:iProvinceId];
        }
        
        [arrChapters addObject:chapter];
    }
    
    
    [arrChapters sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 chapterMode] > [obj2 chapterMode];
    }];
    
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
                        LyRecordTableName_queBank,
                        [LyCurrentUser curUser].userIdForTheory,
                        @([LyCurrentUser curUser].userSubjectMode),
                        [LyCurrentUser curUser].userLicenseTypeByString
                        ];
    
    BOOL flag = [[LyUtil dbRecord] executeUpdate:sqlDel];
    
    
    
    if (flag) {
        for (LyChapter *chapter in arrChapters) {
            [chapter setChapterNum:0];
        }
        [self reloadData];
        
        [self.indicator stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"清空成功"] show];
    } else {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"清空失败"] show];
    }
    
    
}


#pragma mark -LyMyQueAnalysisLocalViewControllerDelegate
- (LyChapter *)chapterByMyQueAnalysisViewController:(LyMyQueAnalysisLocalViewController *)aMyQueAnalysisVC {
    return arrChapters[curIdx.row];
}


#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return chaptcHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    curIdx = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LyChapter *chapter = arrChapters[indexPath.row];
    if (chapter.chapterNum < 1) {
        [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"此章节没有题目"] show];
        return;
    }
    
    LyMyQueAnalysisLocalViewController *myQueAnalysis = [[LyMyQueAnalysisLocalViewController alloc] init];
    [myQueAnalysis setDelegate:self];
    [self.navigationController pushViewController:myQueAnalysis animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrChapters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyChapterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyQueBankLocalTableViewReuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[LyChapterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyQueBankLocalTableViewReuseIdentifier];
    }
    
    LyChapter *chapter = arrChapters[indexPath.row];
    
    [cell setCellTitleWithMode:LyChapterTableViewCellMode_myLibrary
                         title:chapter.chapterName
                      allCount:chapter.chapterNum
                      andIndex:indexPath.row];
    
    return cell;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
