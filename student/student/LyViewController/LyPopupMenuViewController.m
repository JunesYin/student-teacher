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



#define tvFuncItemsWidth                        (CGRectGetWidth(self.view.frame)/2)
#define tvFuncItemsHeight                       CGRectGetHeight(self.view.frame)


@interface LyPopupMenuViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray                 *arrItems;
    
    NSIndexPath             *pmIpLast;
}
@end

@implementation LyPopupMenuViewController


lySingle_implementation(LyPopupMenuViewController)


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubview];
    arrItems = @[
//                 @"通知消息",
//                 @"添加关注",
                 @"扫一扫",
                 @"二维码名片"
                 ];
}




- (void)viewWillAppear:(BOOL)animated
{
    
}




- (void)viewWillDisappear:(BOOL)animated
{
    [_pmTvItems deselectRowAtIndexPath:pmIpLast animated:YES];
}



- (void)initAndLayoutSubview
{
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    _pmTvItems = [[UITableView alloc] initWithFrame:CGRectMake( tvFuncItemsWidth, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, tvFuncItemsWidth, tvFuncItemsHeight) style:UITableViewStylePlain];
    [_pmTvItems setDelegate:self];
    [_pmTvItems setDataSource:self];
    [_pmTvItems setBackgroundView:nil];
    [_pmTvItems setBackgroundColor:[UIColor clearColor]];
    [_pmTvItems setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_pmTvItems setBounces:YES];
    
    
    
    [self.view addSubview:_pmTvItems];
    
}



- (void)pmPostNotificationForPush:(int)index
{
    
//    if ( 1 == index && ![[LyCurrentUser curUser] isLogined])
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:LyNotificationForUserCenterPush object:[[NSString alloc] initWithFormat:@"%d", 100]];
//    }
//    else
//    {
        [[NSNotificationCenter defaultCenter] postNotificationName:LyNotificationForUserCenterPush object:[[NSString alloc] initWithFormat:@"%d", index+200+2]];
//    }
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return pmCellHeight;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    pmIpLast = indexPath;
    [self pmPostNotificationForPush:(int)[pmIpLast row]];
}



#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrItems count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *lyPopupMenuTableViewReuseIdentifier = @"lyPopupMenuTableViewReuseIdentifier";
    
    LyPopupMenuTableViewCell *tmpCell = [tableView dequeueReusableCellWithIdentifier:lyPopupMenuTableViewReuseIdentifier];
    
    if ( !tmpCell)
    {
        tmpCell = [[LyPopupMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyPopupMenuTableViewReuseIdentifier];
    }
    
    [tmpCell setCellInfo:[arrItems objectAtIndex:[indexPath row]] withImageName:[[NSString alloc] initWithFormat:@"popupMenu_item_%ld", [indexPath row]]];
    
    
    return tmpCell;
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
