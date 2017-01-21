//
//  LyAddLandMarkTableViewController.m
//  teacher
//
//  Created by Junes on 16/8/11.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyAddLandMarkTableViewController.h"
#import "LyAddLandMarkTableViewCell.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyDistrict.h"
#import "LyCurrentUser.h"

#import "NSMutableArray+SingleElement.h"

#import "LyUtil.h"

typedef NS_ENUM(NSInteger, LyAddLandMarkBarButtonItemTag) {
    addLandMarkBarButtonItemTag_selectAll = 0,
    addLandMarkBarButtonItemTag_deselectAll,
    addLandMarkBarButtonItemTag_done,
};

//typedef NS_ENUM(NSInteger, LyAddLandMarkHttpMethod) {
//    addLandMarkHttpMethod_load = 100,
//    addLandMarkHttpMethod_add,
//};


@interface LyAddLandMarkTableViewController () <LyRemindViewDelegate, LyHttpRequestDelegate>
{
    UIBarButtonItem             *bbiSelect;
    UIBarButtonItem             *bbiAdd;
    
    
    UIView                      *viewError;
    NSMutableArray              *arrAllLandMark;
    
    NSArray                     *arrDistrict;
    
    LyIndicator                 *indicator;
    LyIndicator                 *indicator_oper;
}
@end

@implementation LyAddLandMarkTableViewController


static NSString *const lyAddLandMarkTableViewCellReuseIdentifier = @"lyAddLandMarkTableViewCellReuseIdentifier";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"添加地标";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    bbiAdd = [[UIBarButtonItem alloc] initWithTitle:@"添加"
                                              style:UIBarButtonItemStyleDone
                                             target:self
                                             action:@selector(targetForBarButtonItem:)];
    [bbiAdd setTag:addLandMarkBarButtonItemTag_done];
    
    bbiSelect = [[UIBarButtonItem alloc] initWithTitle:@"全选"
                                                 style:UIBarButtonItemStyleDone
                                                target:self
                                                action:@selector(targetForBarButtonItem:)];
    [bbiSelect setTag:addLandMarkBarButtonItemTag_selectAll];
    
    [self.navigationItem setRightBarButtonItems:@[bbiAdd, bbiSelect]];
    
    
    [self.tableView registerClass:[LyAddLandMarkTableViewCell class] forCellReuseIdentifier:lyAddLandMarkTableViewCellReuseIdentifier];
    [self.tableView setTableFooterView:[UIView new]];
    
    arrAllLandMark = [[NSMutableArray alloc] initWithCapacity:1];
    _arrLandMarks = [[NSMutableArray alloc] initWithCapacity:1];
    
    [bbiAdd setEnabled:NO];
}


- (void)viewWillAppear:(BOOL)animated {
    NSDictionary *dic = [_delegate landMarkInfoByAddLandMarkTVC:self];
    if (![LyUtil validateDictionary:dic]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    arrDistrict = [dic objectForKey:landMarkKey];
    _district = [dic objectForKey:districtKey];
    
    if (!arrDistrict || !_district) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    self.title = [[NSString alloc] initWithFormat:@"添加地标-%@", _district.dName];
    [self refresh:self.refreshControl];
}

- (void)reloadViewData {
    [self removeViewError];
    [self arrAllLandMark_singleElementAndSort];
    [self.tableView reloadData];
}


- (void)showViewError {
    if (!viewError) {
        viewError = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2.0f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewError addSubview:[LyUtil lbErrorWithMode:0]];
    }
    
    [self.tableView addSubview:viewError];
    [self.tableView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.05f)];
}


- (void)removeViewError {
    [viewError removeFromSuperview];
    viewError = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)arrAllLandMark_singleElementAndSort {
    [arrAllLandMark singleElementByKey:@"lmId"];
    
    [arrAllLandMark sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [[LyUtil getPinyinFromHanzi:[obj1 lmName]] compare:[LyUtil getPinyinFromHanzi:[obj2 lmName]]];
    }];
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    LyAddLandMarkBarButtonItemTag bbiTag = bbi.tag;
    switch (bbiTag) {
        case addLandMarkBarButtonItemTag_selectAll: {
            [self operSelect];
            break;
        }
        case addLandMarkBarButtonItemTag_deselectAll: {
            [self operSelect];
            break;
        }
        case addLandMarkBarButtonItemTag_done: {
            [self addLandMark];
            break;
        }
    }
}


- (void)operSelect {
    if (addLandMarkBarButtonItemTag_selectAll == bbiSelect.tag) {
        [bbiSelect setTitle:@"取消全选"];
        [bbiSelect setTag:addLandMarkBarButtonItemTag_deselectAll];
        
        [_arrLandMarks removeAllObjects];
        for (int i = 0; i < arrAllLandMark.count; ++i) {
            LyLandMark *landMark = arrAllLandMark[i];
            
            BOOL bFlag = NO;
            for (LyLandMark *lmItem in _district.dArrLandMark) {
                if ([landMark.lmId isEqualToString:lmItem.lmId] || [landMark.lmName isEqualToString:lmItem.lmName]) {
                    bFlag = YES;
                    break;
                }
            }
            if (bFlag) {
                continue;
            }
            
            LyAddLandMarkTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            [cell setChoosed:YES];
            
            [_arrLandMarks addObject:landMark];
        }
        
        [bbiAdd setEnabled:YES];
    
    } else {
        [bbiSelect setTitle:@"全选"];
        [bbiSelect setTag:addLandMarkBarButtonItemTag_selectAll];
        
        [_arrLandMarks removeAllObjects];
        for (int i = 0; i < arrAllLandMark.count; ++i) {
            LyAddLandMarkTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            [cell setChoosed:NO];
        }
        
        
        [bbiAdd setEnabled:NO];
    }
    
    
}


- (void)refresh:(UIRefreshControl *)rc {
    [self load];
}


- (void)handleHttpFailed:(BOOL)needRemind {
    if (indicator.isAnimating) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        [self showViewError];
    }
    
    if (indicator_oper.isAnimating) {
        [indicator_oper stopAnimation];
        
        if (needRemind) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"添加失败"] show];
        }
    }
}

- (NSDictionary *)analysisHttpResult:(NSString *)result {
    NSDictionary *dic = [LyUtil getObjFromJson:result];
    if (![LyUtil validateDictionary:dic]) {
        return nil;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (![LyUtil validateString:strCode]) {
        return nil;
    }
    
    if (codeTimeOut == strCode.intValue) {
        [self handleHttpFailed:NO];
        
        [LyUtil sessionTimeOut];
        return nil;
    }
    
    if (codeMaintaining == strCode.intValue) {
        [self handleHttpFailed:NO];
        
        [LyUtil serverMaintaining];
        return nil;
    }
    
    return dic;
}


- (void)load {
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:nil];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:getDistrictLandMark_url
                    body:@{
                           districtIdKey : _district.dId,
                           sessionIdKey : [LyUtil httpSessionId]
                           }
                    type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
           if (error) {
               [self handleHttpFailed:YES];
           } else {
               NSDictionary *dic = [self analysisHttpResult:resStr];
               if (!dic) {
                   [self handleHttpFailed:YES];
                   return ;
               }
               
               NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
               switch (strCode.integerValue) {
                   case 0: {
                       NSArray *arrResult = [dic objectForKey:resultKey];
                       
                       for (NSDictionary *item in arrResult) {
                           if (!arrResult || ![LyUtil validateArray:arrResult]) {
                               continue;
                           }
                           
                           NSString *strId = [item objectForKey:idKey];
                           NSString *strName = [item objectForKey:landNameKey];
                           
                           LyLandMark *landMark = [LyLandMark landMarkWithId:strId name:strName];
                           
                           [arrAllLandMark addObject:landMark];
                       }
                       
                       [self reloadViewData];
                       
                       [indicator stopAnimation];
                       [self.refreshControl endRefreshing];
                       break;
                   }
                   default: {
                       [self handleHttpFailed:YES];
                       break;
                   }
               }
           }
       }];
}

- (void)addLandMark {
    if (!_arrLandMarks || _arrLandMarks.count < 1) {
        [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"没有选择任何地标"] show];
        return;
    }
    
    if (!indicator_oper) {
        indicator_oper = [LyIndicator indicatorWithTitle:LyIndicatorTitle_add];
    }
    else {
        [indicator_oper setTitle:LyIndicatorTitle_add];
    }
    
    [indicator_oper startAnimation];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[LyCurrentUser curUser].userId forKey:userIdKey];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    [dic setObject:[[LyCurrentUser curUser] userTypeByString] forKey:userTypeKey];
    
    NSMutableString *strLandMark = [[NSMutableString alloc] initWithString:@""];
    
    for (LyDistrict *district in arrDistrict) {
        if (!district) {
            continue;
        }
        
        for (LyLandMark *landMark in district.dArrLandMark) {
            if (!landMark) {
                continue;
            }
            
            [strLandMark appendFormat:@"%@,", landMark.lmId];
        }
    }
    
    for (LyLandMark *landMark in _arrLandMarks) {
        if (!landMark) {
            continue;
        }
        
        [strLandMark appendFormat:@"%@,", landMark.lmId];
    }
    
    
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:operateLandMark_url
                    body:@{
                           cityKey: _district.cityName,
                           landMarkIdKey: strLandMark,
                           userIdKey: [LyCurrentUser curUser].userId,
                           userTypeKey: [[LyCurrentUser curUser] userTypeByString],
                           sessionIdKey: [LyUtil httpSessionId]
                           }
                    type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
           if (error) {
               [self handleHttpFailed:YES];
           } else {
               NSDictionary *dic = [self analysisHttpResult:resStr];
               if (!dic) {
                   [self handleHttpFailed:YES];
                   return ;
               }
               
               NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
               switch (strCode.integerValue) {
                   case 0: {
                       [_district addLandMarksFromArray:_arrLandMarks];
                       
                       [indicator_oper stopAnimation];
                       LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"添加成功"];
                       [remind setDelegate:self];
                       [remind show];
                       break;
                   }
                   default:{
                       [self handleHttpFailed:YES];
                       break;
                   }
               }
           }
       }];
}


#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(LyRemindView *)aRemind {
    [_delegate onDoneAddLandMark:self landMarks:_arrLandMarks];
}


#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return almtcellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    //判断是否已添加
    LyLandMark *landMark = [arrAllLandMark objectAtIndex:indexPath.row];
    for (LyLandMark *lmItem in _district.dArrLandMark) {
        if ([landMark.lmId isEqualToString:lmItem.lmId] || [landMark.lmName isEqualToString:lmItem.lmName]) {
            return;
        }
    }
    
    LyAddLandMarkTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setChoosed:!cell.isChoosed];
    
    
    
//    for (NSInteger i = 0; i < [tableView numberOfRowsInSection:0]; ++i) {
//        LyAddLandMarkTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//        if (cell.isChoosed) {
//            [_arrLandMarks addObject:cell.landMark];
//        } else {
//            [_arrLandMarks removeObject:cell.landMark];
//        }
//    }
    if (cell.isChoosed) {
        [_arrLandMarks addObject:landMark];
    } else {
        [_arrLandMarks removeObject:landMark];
    }
    
    [bbiAdd setEnabled:(_arrLandMarks && _arrLandMarks.count > 0)];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrAllLandMark.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LyAddLandMarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyAddLandMarkTableViewCellReuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[LyAddLandMarkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyAddLandMarkTableViewCellReuseIdentifier];
    }
    
    LyLandMark *landMark = [arrAllLandMark objectAtIndex:indexPath.row];
    
    BOOL isAdded = NO;
    BOOL isChoosed = NO;
    
    for (LyLandMark *lmItem in _district.dArrLandMark) {
        if ([landMark.lmId isEqualToString:lmItem.lmId] || [landMark.lmName isEqualToString:lmItem.lmName]) {
            isAdded = YES;
            break;
        }
    }
    
    for (LyLandMark *lmItem in _arrLandMarks) {
        if ([landMark.lmId isEqualToString:lmItem.lmId] || [landMark.lmName isEqualToString:lmItem.lmName]) {
            isChoosed = YES;
            break;
        }
    }
    
    
    [cell setLandMark:landMark added:isAdded choosed:isChoosed];
    
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
