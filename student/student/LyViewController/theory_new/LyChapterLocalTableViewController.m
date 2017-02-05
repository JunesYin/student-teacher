//
//  LyChapterLocalTableViewController.m
//  student
//
//  Created by MacMini on 2016/12/9.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyChapterLocalTableViewController.h"
#import "LyChapterTableViewCell.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyChapter.h"
#import "LyCurrentUser.h"

#import "LyUtil.h"


#import "LyChapterExeciseLocalViewController.h"


typedef NS_ENUM(NSInteger, LyChapterLocalBarButtonItemTag) {
    chaptgerLocalBarButtonItemTag_clear = 10,
};


@interface LyChapterLocalTableViewController () <LyChapterExeciseLocalViewControllerDelegate>
{
    NSMutableArray      *arrChapter;
    
    NSIndexPath         *curIdx;
}

@property (strong, nonatomic)       LyIndicator     *indicator;

@end

@implementation LyChapterLocalTableViewController

static NSString *const lyChapterNewTableViewCellReuseIdentifier = @"lyChapterNewTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    if (!arrChapter || arrChapter.count < 1)
    {
        [self load];
    }
    else
    {
        if (curIdx) {
            [self.tableView reloadRowsAtIndexPaths:@[curIdx] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

- (void)initSubviews {
    self.title = @"章节练习";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    UIBarButtonItem *bbiClear = [[UIBarButtonItem alloc] initWithTitle:@"重置"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(targetForBarButtonItem:)];
    [bbiClear setTag:chaptgerLocalBarButtonItemTag_clear];
    [self.navigationItem setRightBarButtonItem:bbiClear];
    
    
    [self.tableView registerClass:[LyChapterTableViewCell class] forCellReuseIdentifier:lyChapterNewTableViewCellReuseIdentifier];
    [self.tableView setTableFooterView:[UIView new]];
    
    arrChapter = [[NSMutableArray alloc] initWithCapacity:1];
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
    LyChapterLocalBarButtonItemTag bbiTag = bbi.tag;
    switch (bbiTag) {
        case chaptgerLocalBarButtonItemTag_clear: {
            UIAlertController *action = [UIAlertController alertControllerWithTitle:@"确定要重置章节练习的进度吗？"
                                                                            message:nil
                                                                     preferredStyle:UIAlertControllerStyleActionSheet];
            [action addAction:[UIAlertAction actionWithTitle:@"重置"
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
    [self.indicator setTitle:@""];
    [self.indicator startAnimation];
    
    [self performSelector:@selector(load_genuine) withObject:nil afterDelay:LyDelayTime];
}

- (void)load_genuine
{
    [arrChapter removeAllObjects];
    
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
    
    
    
    NSString *sqlCha = [[NSString alloc] initWithFormat:@"SELECT c.classname, c.classsmalltype, count(q.id) AS num FROM %@ q JOIN %@ c ON c.classsmalltype = q.ChapterId AND q.subjects = c.classtype AND c.classtype = %@ AND (AddressId = 0 OR AddressId = %@) GROUP BY c.classname",
                        LyTheoryTableName_question,
                        LyTheoryTableName_chapter,
                        @([LyCurrentUser curUser].userSubjectMode),
                        @(iProvinceId)
                        ];
    
    FMResultSet *rs = [[LyUtil dbTheory] executeQuery:sqlCha];
    while ([rs next]) {
        NSInteger iId = [rs intForColumn:@"classsmalltype"];
        NSString *sChapterName = [rs stringForColumn:@"classname"];
        NSInteger iNum = [rs intForColumn:@"num"];

        LyChapter *chapter = [LyChapter chapterWithMode:iId
                                            chapterName:sChapterName
                                             chapterNum:iNum
                                                    tid:0
                                                  index:0];
        
        if (iProvinceId > 0 && [sChapterName rangeOfString:@"题库"].length > 0) {
            [chapter setChapterName:[curProvince stringByAppendingString:sChapterName]];
            [chapter setProvinceId:iProvinceId];
        }
        
        [arrChapter addObject:chapter];
    }
    
    
    
    NSInteger iId_chap_6 = 6;
    NSString *sChapterName = nil;
    FMResultSet *rsChap_6 = nil;
    if (LyLicenseType_A1 == [LyCurrentUser curUser].userLicenseType ||
        LyLicenseType_A3 == [LyCurrentUser curUser].userLicenseType ||
        LyLicenseType_B1 == [LyCurrentUser curUser].userLicenseType)
    {
        rsChap_6 = [[LyUtil dbTheory] executeQuery:@"SELECT count(id) AS num FROM theory_question WHERE cartype = 1"];
        sChapterName = @"客车专用试题";
    }
    else if (LyLicenseType_A2 == [LyCurrentUser curUser].userLicenseType ||
             LyLicenseType_B2 == [LyCurrentUser curUser].userLicenseType)
    {
        rsChap_6 = [[LyUtil dbTheory] executeQuery:@"SELECT count(id) AS num FROM theory_question WHERE cartype = 2"];
        sChapterName = @"货车专用试题";
    }
    else if (LyLicenseType_M == [LyCurrentUser curUser].userLicenseType)
    {
        rsChap_6 = [[LyUtil dbTheory] executeQuery:@"SELECT count(id) AS num FROM theory_question WHERE cartype = 3"];
        sChapterName = @"轮式机械专用试题";
    }
    
    if (rsChap_6 && sChapterName) {
        while ([rsChap_6 next]) {
            NSInteger iNum = [rsChap_6 intForColumnIndex:0];
            LyChapter *chater = [LyChapter chapterWithMode:iId_chap_6
                                               chapterName:sChapterName
                                                chapterNum:iNum
                                                       tid:0
                                                     index:0];
            
            [arrChapter addObject:chater];
            break;
        }
    }
    
    for (LyChapter *chapter in arrChapter) {
        NSInteger iIndex = 0;
        NSString *sql = [[NSString alloc] initWithFormat:@"SELECT indexs FROM %@ WHERE userid = '%@' AND subjects = %@ AND ChapterId = %@",
                         LyRecordTableName_exeSpeed,
                         [LyCurrentUser curUser].userIdForTheory,
                         @([LyCurrentUser curUser].userSubjectMode),
                         @(chapter.chapterMode)
                         ];
        FMResultSet *rsIndex = [[LyUtil dbRecord] executeQuery:sql];
        while ([rsIndex next]) {
            iIndex = [rsIndex intForColumn:@"indexs"];
        }
        
        [chapter setIndex:iIndex];
    }
    
    
    [arrChapter sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 chapterMode] > [obj2 chapterMode];
    }];

    [self reloadData];
    [self.indicator stopAnimation];
}


- (void)clear {
    [self.indicator setTitle:@"正在重置"];
    [self.indicator startAnimation];
    
    [self performSelector:@selector(clear_genuine) withObject:nil afterDelay:LyDelayTime];
    
}

- (void)clear_genuine {
    NSString *sqlDel = [[NSString alloc] initWithFormat:@"DELETE FROM %@ WHERE userid = '%@' AND subjects = %@",
                        LyRecordTableName_exeSpeed,
                        [LyCurrentUser curUser].userIdForTheory,
                        @([LyCurrentUser curUser].userSubjectMode)
                        ];
    BOOL flag = [[LyUtil dbRecord] executeUpdate:sqlDel];
    
    if (flag) {
        [self load_genuine];
        
    } else {
        [self.indicator stopAnimation];
        
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"重置失败"] show];
    }
}


#pragma mark -LyChapterExeciseLocalViewControllerDelegate
- (LyChapter *)chapterOfChapterExeciseLocalViewController:(LyChapterExeciseLocalViewController *)aChapterExeciseLocalVC
{
    return arrChapter[curIdx.row];
}


#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return chaptcHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    curIdx = indexPath;
    [tableView deselectRowAtIndexPath:curIdx animated:NO];
    
    LyChapter *chapter = [arrChapter objectAtIndex:[curIdx row]];
    if ( [chapter chapterNum] > 0)
    {
        LyChapterExeciseLocalViewController *chapterExeciseLocal = [[LyChapterExeciseLocalViewController alloc] init];
        [chapterExeciseLocal setDelegate:self];
        [self.navigationController pushViewController:chapterExeciseLocal animated:YES];
    }
    else
    {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"该章节没有题目"] show];
    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrChapter.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyChapterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyChapterNewTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    if ( !cell)
    {
        cell = [[LyChapterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyChapterNewTableViewCellReuseIdentifier];
    }
    
    [cell setCellInfoWithMode:LyChapterTableViewCellMode_chapter chapter:arrChapter[indexPath.row]];
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
