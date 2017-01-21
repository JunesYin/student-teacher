//
//  LyTheoryStudyViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/21.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyTheoryStudyViewController.h"
#import "LyTheoryStudyCollectionViewCell.h"

#import "LyCurrentUser.h"
#import "LyLoginViewController.h"

#import "LyRemindView.h"
#import "LyIndicator.h"
#import "LyBottomControl.h"
#import "LyAddressPicker.h"
#import "LyLicenseInfoPicker.h"

#import "RESideMenu.h"
#import "UIImage+Scale.h"

#import "UIBarButtonItem+Badge.h"
#import "LyUtil.h"

#import "student-Swift.h"
#import <WebKit/WebKit.h>


#import "LySimulateLocalViewController.h"
#import "LyChapterLocalTableViewController.h"
#import "LyQuestionAnalysisLocalViewController.h"
#import "LyMyMistakeLocalTableViewController.h"
#import "LyQueBankLocalTableViewController.h"






#define tsWidth                     SCREEN_WIDTH
#define tsHeight                    SCREEN_HEIGHT






int const cvItemCountEveryrow = 4;


#define cvItemsMargin               verticalSpace

#define cvItemsWidth                tsWidth
#define cvItemsHeight               tsHeight


#define cvItemWidth                 ((cvItemsWidth-cvItemsMargin*(cvItemCountEveryrow-1))/cvItemCountEveryrow)
#define cvItemHeight                cvItemWidth


#define itemSimulateWidth           (cvItemWidth*1.7)
#define itemSimulateHeight          itemSimulateWidth


typedef NS_ENUM(NSInteger, LyTheoryStudyBarButtonItemTag) {
    theoryStudyBarButtonItemTag_msg = 10,
};



typedef NS_ENUM( NSInteger, LyTheoryStudyHttpMethod)
{
    theoryStudyHttpMethod_modifyLicense = 100,
};




@interface LyTheoryStudyViewController () < UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIWebViewDelegate, LyAddressPickerDelegate, LyLicenseInfoPickerDelegate, LyHttpRequestDelegate>
{
    
    
    NSArray                     *tsArrItems;

    UIButton                    *btnSimulate;
    
    UICollectionView            *cvItems;
    
    
    LyLocateMode                locateMode;
    
    
    BOOL                        bHttpFlag;
    LyTheoryStudyHttpMethod     curHttpMethod;
}
@end


@implementation LyTheoryStudyViewController


lySingle_implementation(LyTheoryStudyViewController)

static NSString *tsCollectionViweCellIdentifier = @"tsCollectionViweCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initSubviews];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [[LyBottomControl sharedInstance] setLicenseInfo:[[LyCurrentUser curUser] userLicenseType] object:[[LyCurrentUser curUser] userSubjectMode]];
}



- (void)viewDidAppear:(BOOL)animated
{
    [[self.tabBarController tabBar] setHidden:YES];
    [[LyBottomControl sharedInstance] setHidden:NO];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [[self.tabBarController tabBar] setHidden:YES];
    [[LyBottomControl sharedInstance] setHidden:YES];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [[LyBottomControl sharedInstance] setHidden:YES];
}



- (void)initSubviews
{
    tsArrItems = @[
                   @"全真模考",
                   @"章节练习",
                   @"试题分析",
                   @"我的错题",
                   @"我的题库"
                   ];
    
    self.title = @"理论学习";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    UIBarButtonItem *bbiLeft_Menu = [LyUtil barButtonItem:0
                                                imageName:@"navigationBar_left"
                                                   target:self
                                                   action:@selector(presentLeftMenuViewController:)];
    UIBarButtonItem *bbiLeft_hyaline = [LyUtil barButtonItem:0
                                                   imageName:@"navigationBar_hyaline"
                                                      target:nil
                                                      action:nil];
    UIBarButtonItem *bbiRight_menu = [LyUtil barButtonItem:0
                                                 imageName:@"navigationBar_right"
                                                    target:self
                                                    action:@selector(presentRightMenuViewController:)];
    UIBarButtonItem *bbiRight_msg = [LyUtil barButtonItem:theoryStudyBarButtonItemTag_msg
                                                imageName:@"navigationBar_msg"
                                                   target:self
                                                   action:@selector(targetForBarButtonItem:)];
    
    [self.navigationItem setLeftBarButtonItems:@[bbiLeft_Menu, bbiLeft_hyaline]];
    [self.navigationItem setRightBarButtonItems:@[bbiRight_menu, bbiRight_msg]];
    
    
    CGRect rectTsItems = CGRectMake( 0, verticalSpace*2, cvItemsWidth, cvItemsHeight);
    UICollectionViewFlowLayout *tsCollectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [tsCollectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    cvItems = [[UICollectionView alloc] initWithFrame:rectTsItems collectionViewLayout:tsCollectionViewFlowLayout];
    [cvItems setDelegate:self];
    [cvItems setDataSource:self];
    [cvItems setBackgroundColor:[UIColor whiteColor]];
    [cvItems setScrollEnabled:NO];
    [cvItems registerClass:[LyTheoryStudyCollectionViewCell class] forCellWithReuseIdentifier:tsCollectionViweCellIdentifier];
    
    
    [self.view addSubview:cvItems];
    
    
    locateMode = LyLocateMode_auto;
    [[LyCurrentUser curUser].location addObserver:self forKeyPath:@"address" options:NSKeyValueObservingOptionNew context:nil];
    
    
}


- (void)initDataBase {
//    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//    NSString *dbPath = [docPath stringByAppendingString:LyTheoryLocalDataBaseName];
//    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
//
    
    NSString *path = [LyUtil filePathForFileName:@"SQLite3.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    if (db.open) {
        NSLog(@"打开数据库成功");
    } else {
        NSLog(@"打开数据库失败");
    }
    
//    FMResultSet *result = [db executeQuery:@"SELECT * FROM theory_province"];
//    while ([result next]) {
//        int iId = [result intForColumn:@"id"];
//        NSString *sProvince = [result stringForColumn:@"province"];
//        
//        NSLog(@"id=%d---province=%@", iId, sProvince);
//    }
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"address"])
    {
        NSString *newValue = [change objectForKey:NSKeyValueChangeNewKey];
        
        if (newValue && newValue.length > 0 && LyLocateMode_auto == locateMode)
        {
            [[LyBottomControl sharedInstance] setLocale:newValue];
        }
    }
}



- (void)showAddressPicker
{
    [[LyBottomControl sharedInstance] setHidden:YES];
    
    LyAddressPicker *adderssPicker = [LyAddressPicker addressPickerWithMode:LyAddressPickerMode_theoryStudy];
    
    if ([[LyCurrentUser curUser] userExamAddress])
    {
        [adderssPicker setAddress:[LyCurrentUser curUser].userExamAddress];
    }
    
    [adderssPicker setDelegate:self];
    [adderssPicker show];
}



- (void)showLicenseInfoPicker
{
    [[LyBottomControl sharedInstance] setHidden:YES];
    
    LyLicenseInfoPicker *licenseInfoPicker = [[LyLicenseInfoPicker alloc] init];
    [licenseInfoPicker setDelegate:self];
    [licenseInfoPicker setLicense:[[LyCurrentUser curUser] userLicenseType] andObject:[[LyCurrentUser curUser] userSubjectMode]];
    [licenseInfoPicker show];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(targetForBarButtonItem:) object:bbi];
        return;
    }
    
    LyTheoryStudyBarButtonItemTag bbiTag = (LyTheoryStudyBarButtonItemTag)bbi.tag;
    switch (bbiTag) {
        case theoryStudyBarButtonItemTag_msg: {
            LyMsgCenterTableViewController *msgCenter = [[LyMsgCenterTableViewController alloc] init];
            [self.navigationController pushViewController:msgCenter animated:YES];
            break;
        }
    }
}


- (void)modifyLicenseInfo:(LyLicenseType)license subjectMode:(LySubjectMode)subject
{
    if ( ![[LyCurrentUser curUser] isLogined])
    {
        return;
    }
    
    LyHttpRequest *httpReqeust = [LyHttpRequest httpRequestWithMode:theoryStudyHttpMethod_modifyLicense];
    [httpReqeust setDelegate:self];
    bHttpFlag = [[httpReqeust startHttpRequest:modifyUserInfo_url
                                          body:@{
                                                 userIdKey:[[LyCurrentUser curUser] userId],
                                                 driveLicenseKey:[LyUtil driveLicenseStringFrom:license],
                                                 subjectModeKey:[[NSString alloc] initWithFormat:@"%d", (int)subject],
                                                 sessionIdKey:[LyUtil httpSessionId],
                                                 userTypeKey:userTypeStudentKey
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}




#pragma mark -LyHttpRequestDelegate
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest
{
    if ( bHttpFlag)
    {
        bHttpFlag = NO;
        curHttpMethod = 0;
    }
}


- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result
{
    if ( bHttpFlag)
    {
        bHttpFlag = NO;
        curHttpMethod = 0;
    }
}


#pragma mark -LyAddressPickerDelegate
- (void)onAddressPickerCancel:(LyAddressPicker *)addressPicker
{
    [addressPicker hide];
    
    [[LyBottomControl sharedInstance] setHidden:NO];
}


- (void)onAddressPickerDone:(NSString *)address addressPicker:(LyAddressPicker *)addressPicker
{
    [addressPicker hide];
    
    locateMode = LyLocateMode_pick;
    
    [[LyBottomControl sharedInstance] setHidden:NO];
    
    [[LyCurrentUser curUser] setUserExamAddress:address];
    [[LyBottomControl sharedInstance] setLocale:address];
}


- (void)onAddressPickerAutoLocate:(LyAddressPicker *)aAddressPicker
{
    [aAddressPicker hide];
    locateMode = LyLocateMode_auto;
    
    [[LyBottomControl sharedInstance] setHidden:NO];
    
    [[LyCurrentUser curUser] setUserExamAddress:[LyCurrentUser curUser].location.address];
    [[LyBottomControl sharedInstance] setLocale:[LyCurrentUser curUser].userExamAddress];
}




#pragma mark -LyLicenseInfoPickerDelegate
- (void)onLicenseInfoPickerCancel:(LyLicenseInfoPicker *)licenseInfoPicker
{
    [licenseInfoPicker hide];
    
    [[LyBottomControl sharedInstance] setHidden:NO];
}


- (void)onLicenseInfoPickerDone:(LyLicenseInfoPicker *)licenseInfoPicker andLicense:(LyLicenseType)license andObject:(LySubjectMode)subject
{
    [licenseInfoPicker hide];
    
    [[LyBottomControl sharedInstance] setHidden:NO];
    
    if ( license != [[LyCurrentUser curUser] userLicenseType] || subject != [[LyCurrentUser curUser] userSubjectMode])
    {
        [self modifyLicenseInfo:license subjectMode:subject];
    }
    
    [[LyBottomControl sharedInstance] setLicenseInfo:license object:subject];
    [[LyCurrentUser curUser] setUserLicenseType:license];
    [[LyCurrentUser curUser] setUserSubjectMode:subject];
    
}



#pragma mark --UICollectionViewDelegate   
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
//        return;
//    }
    
    
    switch ( [indexPath section]) {
        case 0: {
            
            switch ( [indexPath row] + theoryStudyChildViewControllerIndex_simulate) {
                case theoryStudyChildViewControllerIndex_simulate: {
                    LySimulateLocalViewController *simulte = [[LySimulateLocalViewController alloc] init];
                    [self.navigationController pushViewController:simulte animated:YES];
                    break;
                }
                    
                default: {
                    break;
                }
            }
            
            break;
        }
            
        case 1: {
            
            switch ( [indexPath row] + theoryStudyChildViewControllerIndex_chapter) {
                case theoryStudyChildViewControllerIndex_chapter: {
                    LyChapterLocalTableViewController *chapterLocal = [[LyChapterLocalTableViewController alloc] init];
                    [self.navigationController pushViewController:chapterLocal animated:YES];
                    break;
                }
                    
                case theoryStudyChildViewControllerIndex_analysis: {
                    LyQuestionAnalysisLocalViewController *questionAnalysis = [[LyQuestionAnalysisLocalViewController alloc] init];
                    [self.navigationController pushViewController:questionAnalysis animated:YES];
                    break;
                }
                    
                case theoryStudyChildViewControllerIndex_mistake: {
                    LyMyMistakeLocalTableViewController *myMistake = [[LyMyMistakeLocalTableViewController alloc] init];
                    [self.navigationController pushViewController:myMistake animated:YES];
                    break;
                }
                    
                case theoryStudyChildViewControllerIndex_library: {
                    LyQueBankLocalTableViewController *queBank = [[LyQueBankLocalTableViewController alloc] init];
                    [self.navigationController pushViewController:queBank animated:YES];
                    break;
                }
                    
                default:
                    break;
            }
            
        }
            
        default:
            break;
    }
    
}


//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ( 0 == section)
    {
        return 1;
    }
    else
    {
        return [tsArrItems count]-1;
    }

}


//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}


//每个UICollectionView展示的内容
-(LyTheoryStudyCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LyTheoryStudyCollectionViewCell *cell = (LyTheoryStudyCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:tsCollectionViweCellIdentifier forIndexPath:indexPath];
    
    if ( cell)
    {
        NSString *sImageName = nil;
        NSString *sTitle = nil;
        UIFont *font = nil;
        
        if ( 0 == [indexPath section])
        {
            font = LyFont(16);
            sImageName = @"ts_item_simulate";
            sTitle = tsArrItems[0];
        }
        else
        {
            font = LyFont(12);
            sImageName = [[NSString alloc] initWithFormat:@"ts_item_%ld", indexPath.row];
            sTitle = tsArrItems[indexPath.row + 1];
        }
        
        [cell setFont:font];
        [cell setCellInfo:[LyUtil imageForImageName:sImageName needCache:NO]
                withTitle:sTitle];
        
    }
    
    return cell;
}



#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( 0 == [indexPath section])
    {
        return CGSizeMake( itemSimulateWidth, itemSimulateHeight);
    }
    else
    {
        return CGSizeMake( cvItemWidth, cvItemHeight);
    }
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if ( 0 == section)
    {
        return (cvItemsWidth-itemSimulateWidth)/2.0f;
    }
    else
    {
        return cvItemsMargin;
    }
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if ( 0 == section)
    {
        return (cvItemsWidth-itemSimulateWidth)/2.0f;
    }
    else
    {
        return cvItemsMargin;
    }
}



//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if ( 0 == section)
    {
        return UIEdgeInsetsMake( cvItemsMargin*4, (cvItemsWidth-itemSimulateWidth)/2.0f, cvItemsMargin*8, (cvItemsWidth-itemSimulateWidth)/2.0f);
    }
    else
    {
        return UIEdgeInsetsMake( cvItemsMargin, 0, cvItemsMargin, 0);
    }
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
