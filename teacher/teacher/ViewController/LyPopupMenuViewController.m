//
//  LyPopupMenuViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/24.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyPopupMenuViewController.h"
#import "LyPopupMenuTableViewCell.h"

#import "LyCurrentUser.h"

#import "LyUtil.h"





@interface LyPopupMenuViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray                 *arrItems;
}

@property (strong, nonatomic)   UITableView         *tableView;

@end

@implementation LyPopupMenuViewController

static NSString *const lyPopupMenuTableViewReuseIdentifier = @"lyPopupMenuTableViewReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    [self.view addSubview:self.tableView];
    
    arrItems = @[
//                 @"通知消息",
//                 @"添加关注",
                 @"扫一扫",
                 @"二维码名片"
                 ];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH/2.0f, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT)
                                                  style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundView:nil];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setBounces:YES];
    }
    
    return _tableView;
}




#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return pmCellHeight;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //从30开始
//    [_delegate pushVCByPopupMenuViewController:self index:indexPath.row+30];
    [_delegate pushViewControllerWithIndex:indexPath.row+30];
}


#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrItems.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyPopupMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyPopupMenuTableViewReuseIdentifier];
    
    if ( !cell) {
        cell = [[LyPopupMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyPopupMenuTableViewReuseIdentifier];
    }
    
    [cell setCellInfo:[arrItems objectAtIndex:[indexPath row]] withImageName:[[NSString alloc] initWithFormat:@"popupMenu_item_%ld", [indexPath row]]];
    
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
