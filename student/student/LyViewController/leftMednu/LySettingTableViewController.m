//
//  LySettingTableViewController.m
//  student
//
//  Created by Junes on 16/8/29.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LySettingTableViewController.h"
#import "LyLeftMenuSettingTableViewCell.h"

#import "LyCurrentUser.h"

#import "LyUtil.h"

#import "LyLoginViewController.h"
#import "LyModifyPasswordViewController.h"

#import "LyMaintainingView.h"


#if DEBUG
#import "LyPaySuccessViewController.h"
#import "LyPayManager.h"
#endif



typedef NS_ENUM(NSInteger, LySettingHttpMethod) {
    settingHttpMethod_test = 100,
};


@interface LySettingTableViewController () <LyHttpRequestDelegate>
{
    NSArray             *arrItems;
    
    BOOL                preFlag;
}
@end

@implementation LySettingTableViewController


static NSString *lyLeftMenuSettingTvItemsCellReuseIdentifier = @"lyLeftMenuSettingTvItemsCellReuseIdentifier";


- (instancetype)init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        ;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.title = @"设置";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    [self.tableView registerClass:[LyLeftMenuSettingTableViewCell class] forCellReuseIdentifier:lyLeftMenuSettingTvItemsCellReuseIdentifier];
    [self.tableView setTableFooterView:[UIView new]];
    
    
    arrItems = @[
                 @"通知设置",
                 @"登录密码",
//                 @"缓存与数据"
                 ];
    
    CGFloat viewHideFcunSize = 50.0f;
    UIView *viewHideFunc = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - viewHideFcunSize, SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT - viewHideFcunSize, viewHideFcunSize, viewHideFcunSize)];
    [viewHideFunc setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForDoubleTapGesture:)];
    [doubleTap setNumberOfTapsRequired:2];
    [doubleTap setNumberOfTouchesRequired:1];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(targetForLongPressGesture:)];
    [longPress setNumberOfTouchesRequired:1];
    [longPress setMinimumPressDuration:2.0f];
    [viewHideFunc setUserInteractionEnabled:YES];
    [viewHideFunc addGestureRecognizer:doubleTap];
    [viewHideFunc addGestureRecognizer:longPress];
    [self.view addSubview:viewHideFunc];
    
#if DEBUG
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT - 30, 100, 30)];
    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
#endif
}


- (void)test {
#if DEBUG
//    [[LyPayManager sharedInstance] authOrderStateWithOrderId:@"2016112812470153535698"];
    LyPaySuccessViewController *paySuceess = [[LyPaySuccessViewController alloc] init];
    paySuceess.payMode = LyPayMode_ApplePay;
    paySuceess.discount = 100;
    [self.navigationController pushViewController:paySuceess animated:YES];
#endif
}


- (void)viewWillAppear:(BOOL)animated
{
    [self reloadData];
    
    if ( [self respondsToSelector:@selector(targetForNotificationToDidBecomeActive:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(targetForNotificationToDidBecomeActive:) name:LyAppDidBecomeActive object:nil];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LyAppDidBecomeActive object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)targetForDoubleTapGesture:(UITapGestureRecognizer *)tap {
    if (UIGestureRecognizerStateEnded == tap.state) {
        preFlag = !preFlag;
    }
}

- (void)targetForLongPressGesture:(UILongPressGestureRecognizer *)longPress {
    if (UIGestureRecognizerStateEnded == longPress.state) {
        if (preFlag) {
            
            NSString *mode = @"";
#if DEBUG
            mode = @"DEBUG";
#else
            mode = @"RELEASE";
#endif
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[NSString stringWithFormat:@"%@\n%@\n%@", realmName_517, mode, [LyUtil getApplicationVersion]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
        
        preFlag = NO;
    }
}


- (void)targetForNotificationToDidBecomeActive:(NSNotification *)notification
{
    [self reloadData];
}


- (void)reloadData
{
    [self.tableView reloadData];
}



#pragma mark -LyHttpRequestDelegate
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest {
//    NSLog(@"setting------error");
}

- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result {
//    NSLog(@"setting------%@", result);
}



#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return lmstcellHeight;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    NSString *title = nil;
    switch (section) {
        case 0: {
            title = [[NSString alloc] initWithFormat:@"你可以在【设置】>【通知】>【%@】设置通知的开启或关闭", [LyUtil getAppDisplayName]];
            break;
        }
        case 1: {
            title = @"你可以在这里修改你的密码";
            break;
        }
        case 2: {
            title = @"点击可清理缓存";
            break;
        }
        default:
            break;
    }
    
    return title;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.section) {
        case 0: {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [LyUtil openUrl:url];
            } else {
                [LyUtil showAlert:LyAlertForAuthorityMode_notification vc:self];
            }
            break;
        }
        case 1: {
            LyModifyPasswordViewController *modifyPassword = [[LyModifyPasswordViewController alloc] init];
            [self.navigationController pushViewController:modifyPassword animated:YES];
            break;
        }
        case 2: {
            
            break;
        }
        default:
            break;
    }
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return arrItems.count;
}

////返回每个分组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger iCount = 0;
    switch (section) {
        case 0: {
            iCount = 1;
            break;
        }
        case 1: {
            iCount = 1;
            break;
        }
        case 2: {
            iCount = 1;
            break;
        }
        default: {
            iCount = 0;
            break;
        }
    }
    return iCount;
}

////生成每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LyLeftMenuSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyLeftMenuSettingTvItemsCellReuseIdentifier forIndexPath:indexPath];
    
    if ( !cell)
    {
        cell = [[LyLeftMenuSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyLeftMenuSettingTvItemsCellReuseIdentifier];
    }
    
    
    UIImage *icon;
    NSString *title;
    NSString *detail;
    
    switch (indexPath.section) {
        case 0: {
            icon = [LyUtil imageForImageName:@"setting_item_notification" needCache:NO];
            title = [arrItems objectAtIndex:indexPath.section];
            if ( UIUserNotificationTypeNone == [[[UIApplication sharedApplication] currentUserNotificationSettings] types]) {
                detail = @"点击前往「设置-通知」";
            } else {
                detail = @"已开启";
            }
            break;
        }
        case 1: {
            icon = [LyUtil imageForImageName:@"setting_item_password" needCache:NO];
            title = [arrItems objectAtIndex:indexPath.section];
            detail = @"点击修改";
            break;
        }
        case 2: {
            icon = [LyUtil imageForImageName:@"setting_item_cache" needCache:NO];
            title = [arrItems objectAtIndex:indexPath.section];
            detail = @"点击清理";
        }
        default:
            break;
    }
    
    [cell setCellInfo:icon
                title:title
               detail:detail];
    
    
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
