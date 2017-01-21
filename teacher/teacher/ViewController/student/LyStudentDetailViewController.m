//
//  LyStudentDetailViewController.m
//  teacher
//
//  Created by Junes on 16/8/17.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyStudentDetailViewController.h"
#import "LyStudentDetailTableViewCell.h"
#import "LyTableViewHeaderFooterView.h"
#import "LyDetailControlBar.h"


#import "LyPayInfoPicker.h"
#import "LyAddressPicker.h"
#import "LyAddressAlertView.h"
#import "LyStudyProgressPicker.h"
#import "LySignatureAlertView.h"

#import "LyTrainClass.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyStudentManager.h"

#import "LyUtil.h"

#import "LyChooseTrainClassTableViewController.h"
#import <MessageUI/MessageUI.h>


CGFloat const sdViewInfoHeight = 200.0f;
CGFloat const sdIvAvatarSize = 70.0f;
CGFloat const lbItemHeignt = 20.0f;

enum {
    studentDetailBarButtonItemTag_delete = 0,
}LyStudentDetailBarButtonItemTag;


typedef NS_ENUM(NSInteger, LyStudentDetailHttpMethod)
{
    studentDetailHttpMethod_census = 100,
    studentDetailHttpMethod_pickAddress,
    studentDetailHttpMethod_trianClassName,
    studentDetailHttpMethod_payInfo,
    studentDetailHttpMethod_studyProgress,
    studentDetailHttpMethod_note,
    
    studentDetailHttpMethod_delete,
};


@interface LyStudentDetailViewController () <UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, LyDetailControlBarDelegate, LyHttpRequestDelegate, LyAddressPickerDelegate, LyAddressAlertViewDelegate, LyPayInfoPickerDelegate, LyStudyProgressPickerDelegate, LyChooseTrainClassTableViewControllerDelegate, LySignatureAlertViewDelegate, LyRemindViewDelegate>
{
    UIView                  *viewInfo;
    UIImageView             *ivAvatar;
    UILabel                 *lbName;
    UILabel                 *lbPhone;
    
    UITableView             *tvInfos;
    
    LyDetailControlBar      *controlBar;
    
    BOOL                    isEditing;
    
    
    LyStudent               *student;
    NSIndexPath             *curIp;
    
    LyIndicator             *indicator_delete;
    
    LyIndicator             *indicator_modify;
    BOOL                    bHttpFlag;
    LyStudentDetailHttpMethod   curHttpMethod;
}
@end

@implementation LyStudentDetailViewController

static NSString *const lyStudentDetailTvInfosCellReuseIdentifier = @"lyStudentDetailTvInfosCellReuseIdentifier";
static NSString *const lyStudentDetailTvInfosHeaderFooterViewReuseIdetifier = @"lyStudentDetailTvInfosHeaderFooterViewReuseIdetifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLyaoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[LyUtil imageForImageName:@"uci_navigatinBar" needCache:NO] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController navigationBar].shadowImage = [LyUtil imageForImageName:@"uci_navigatinBar" needCache:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    _stuId = [_delegate obtainStudentIdByStudentDetailVC:self];
    
    if (!_stuId)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    student = [[LyStudentManager sharedInstance] getStudentWithId:_stuId];
    
    [self reloadViewData];
}


- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [[self.navigationController navigationBar] setShadowImage:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)initAndLyaoutSubviews
{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    UIBarButtonItem *bbiDelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                               target:self
                                                                               action:@selector(targetForBarButtonItem:)];
    [bbiDelete setTag:studentDetailBarButtonItemTag_delete];
    [self.navigationItem setRightBarButtonItem:bbiDelete];
    
    
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, sdViewInfoHeight)];
    UIImageView *ivBack = [[UIImageView alloc] initWithFrame:viewInfo.bounds];
    [ivBack setContentMode:UIViewContentModeScaleAspectFill];
    [ivBack setImage:[LyUtil imageForImageName:@"viewInfo_background_s" needCache:NO]];
    
    [self.view addSubview:viewInfo];
    
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f-sdIvAvatarSize/2.0f, sdViewInfoHeight-verticalSpace*5-lbItemHeignt*2-sdIvAvatarSize, sdIvAvatarSize, sdIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [ivAvatar.layer setCornerRadius:sdIvAvatarSize/2.0f];
    [ivAvatar setClipsToBounds:YES];
    
    lbName = [[UILabel alloc] initWithFrame:CGRectMake(0, ivAvatar.ly_y+CGRectGetHeight(ivAvatar.frame)+verticalSpace, SCREEN_WIDTH, lbItemHeignt)];
    [lbName setFont:LyFont(16)];
    [lbName setTextColor:[UIColor whiteColor]];
    [lbName setTextAlignment:NSTextAlignmentCenter];
    
    lbPhone = [[UILabel alloc] initWithFrame:CGRectMake(0, lbName.ly_y+CGRectGetHeight(lbName.frame)+verticalSpace, SCREEN_WIDTH, lbItemHeignt)];
    [lbPhone setFont:LyFont(14)];
    [lbPhone setTextColor:LyWhiteLightgrayColor];
    [lbPhone setTextAlignment:NSTextAlignmentCenter];
    
    [viewInfo addSubview:ivBack];
    [viewInfo addSubview:ivAvatar];
    [viewInfo addSubview:lbName];
    [viewInfo addSubview:lbPhone];
    
    
    tvInfos = [[UITableView alloc] initWithFrame:CGRectMake(0, viewInfo.ly_y+CGRectGetHeight(viewInfo.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetHeight(viewInfo.frame)-dcbHeight)
                                           style:UITableViewStyleGrouped];
    [tvInfos setDelegate:self];
    [tvInfos setDataSource:self];
    [tvInfos registerClass:[LyStudentDetailTableViewCell class] forCellReuseIdentifier:lyStudentDetailTvInfosCellReuseIdentifier];
    [tvInfos setSectionFooterHeight:0];
    [self.view addSubview:tvInfos];
    
    
    
    controlBar = [LyDetailControlBar controlBarWidthMode:LyDetailControlBarMode_studentInfo];
    [controlBar setDelegate:self];
    [self.view addSubview:controlBar];
}



- (void)reloadViewData
{
    if (student.userAvatar)
    {
        [ivAvatar setImage:student.userAvatar];
    }
    else
    {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:student.userId]
                    placeholderImage:[LyUtil defaultAvatarForStudent]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if (image) {
                                   [student setUserAvatar:image];
                               } else {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:student.userId]
                                               placeholderImage:[LyUtil defaultAvatarForStudent]
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                          if (image){
                                                              [student setUserAvatar:image];
                                                          }
                                                      }];
                               }
                           }];
    }
    
    
    [lbName setText:student.userName];
    [lbPhone setText:[LyUtil hidePhoneNumber:student.userPhoneNum]];
    
    [tvInfos reloadData];
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    if (studentDetailBarButtonItemTag_delete == bbi.tag) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[[NSString alloc] initWithFormat:@"你确定要删除「%@」学员吗？", student.userName]
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"删除"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    [self delete];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}



//群发短信
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        
        controller.recipients = recipients;
        
        controller.messageComposeDelegate = self;
        
        [self presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"设备不支持短信功能"] show];
    }
}



- (void)showIndicatorModify
{
    if ( !indicator_modify)
    {
        indicator_modify = [[LyIndicator alloc] initWithTitle:@"正在修改..."];
    }
    [indicator_modify startAnimation];
}


- (void)hideIndicatorModeify:(BOOL)flag
{
    [indicator_modify stopAnimation];
    
    if ( flag)
    {
        [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"修改成功"] show];
    }
    else
    {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"修改失败"] show];
    }
}


- (void)updateStudentInfo:(LyStudentDetailHttpMethod)method content:(id)content
{
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:method];
    [httpRequest setDelegate:self];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_stuId forKey:objectIdKey];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    
    switch (method) {
        case studentDetailHttpMethod_census: {
//            [dic setObject:content forKey:censusKey];
            [dic setObject:censusKey forKey:keyKey];
            [dic setObject:content forKey:valueKey];
            break;
        }
        case studentDetailHttpMethod_pickAddress: {
//            [dic setObject:content forKey:pickAddressKey];
            [dic setObject:pickAddressKey forKey:keyKey];
            [dic setObject:content forKey:valueKey];
            break;
        }
        case studentDetailHttpMethod_trianClassName: {
//            [dic setObject:content forKey:trainClassNameKey];
            [dic setObject:trainClassNameKey forKey:keyKey];
            [dic setObject:content forKey:valueKey];
            break;
        }
        case studentDetailHttpMethod_payInfo: {
//            [dic setObject:content forKey:payInfoKey];
            [dic setObject:payInfoKey forKey:keyKey];
            [dic setObject:content forKey:valueKey];
            break;
        }
        case studentDetailHttpMethod_studyProgress: {
//            [dic setObject:content forKey:subjectModeKey];
            [dic setObject:subjectModeKey forKey:keyKey];
            [dic setObject:content forKey:valueKey];
            break;
        }
        case studentDetailHttpMethod_note: {
//            [dic setObject:content forKey:noteKey];
            [dic setObject:noteKey forKey:keyKey];
            [dic setObject:content forKey:valueKey];
            break;
        }
        default: {
            break;
        }
    }
    
    bHttpFlag = [[httpRequest startHttpRequest:modifyStudent_url
                                          body:dic
                                          type:LyHttpType_asynPost
                                      timeOut:0] boolValue];
}


- (void)delete {
    
    if (!indicator_delete) {
        indicator_delete = [LyIndicator indicatorWithTitle:@"正在删除..."];
    }
    [indicator_delete startAnimation];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:studentDetailHttpMethod_delete];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:deleteStudent_url
                                          body:@{
                                                 objectIdKey:_stuId,
                                                 sessionIdKey:[LyUtil httpSessionId]
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}



- (void)handleHttpFailed {
    if ([indicator_modify isAnimating]) {
        [self hideIndicatorModeify:NO];
    }
    
    if ([indicator_delete isAnimating]) {
        [indicator_delete stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"删除失败"] show];
    }
}


- (void)analysisHttpRequest:(NSString *)result
{
    NSDictionary *dic = [LyUtil getObjFromJson:result];
    if (![LyUtil validateDictionary:dic]) {
        [self handleHttpFailed];
        return;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (![LyUtil validateString:strCode]) {
        [self handleHttpFailed];
        return;
    }
    
    if (codeTimeOut == [strCode integerValue]) {
        [indicator_modify stopAnimation];
        [indicator_delete stopAnimation];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_modify stopAnimation];
        [indicator_delete stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch (curHttpMethod) {
        case studentDetailHttpMethod_census: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (!dicResult || [dicResult isKindOfClass:[NSNull class]] || dicResult.count < 1)
                    {
                        [self hideIndicatorModeify:NO];
                        return;
                    }
                    NSString *strCensus = [dicResult objectForKey:censusKey];
                    [student setStuCensus:strCensus];
                    
                    [self hideIndicatorModeify:YES];
                    [tvInfos reloadRowsAtIndexPaths:@[curIp] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
                default: {
                    [self hideIndicatorModeify:NO];
                    break;
                }
            }
            break;
        }
        case studentDetailHttpMethod_pickAddress: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (!dicResult || [dicResult isKindOfClass:[NSNull class]] || dicResult.count < 1)
                    {
                        [self hideIndicatorModeify:NO];
                        return;
                    }
                    NSString *strPickAddress = [dicResult objectForKey:pickAddressKey];
                    [student setStuPickAddress:strPickAddress];
                    
                    [self hideIndicatorModeify:YES];
                    [tvInfos reloadRowsAtIndexPaths:@[curIp] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
                default: {
                    [self hideIndicatorModeify:NO];
                    break;
                }
            }
            break;
        }
        case studentDetailHttpMethod_trianClassName: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (!dicResult || [dicResult isKindOfClass:[NSNull class]] || dicResult.count < 1)
                    {
                        [self hideIndicatorModeify:NO];
                        return;
                    }
                    NSString *strTrainClassName = [dicResult objectForKey:trainClassNameKey];
                    [student setStuTrainClassName:strTrainClassName];
                    
                    [self hideIndicatorModeify:YES];
                    [tvInfos reloadRowsAtIndexPaths:@[curIp] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
                default: {
                    [self hideIndicatorModeify:NO];
                    break;
                }
            }
            break;
        }
        case studentDetailHttpMethod_payInfo: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (!dicResult || [dicResult isKindOfClass:[NSNull class]] || dicResult.count < 1)
                    {
                        [self hideIndicatorModeify:NO];
                        return;
                    }
                    NSString *strPayInfo = [dicResult objectForKey:payInfoKey];
                    [student setStuPayInfo:[strPayInfo integerValue]];
                    
                    [self hideIndicatorModeify:YES];
                    [tvInfos reloadRowsAtIndexPaths:@[curIp] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
                default: {
                    [self hideIndicatorModeify:NO];
                    break;
                }
            }
            break;
        }
        case studentDetailHttpMethod_studyProgress: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (!dicResult || [dicResult isKindOfClass:[NSNull class]] || dicResult.count < 1)
                    {
                        [self hideIndicatorModeify:NO];
                        return;
                    }
                    NSString *strStudyProgress = [dicResult objectForKey:subjectModeKey];
                    [student setStuStudyProgress:[strStudyProgress integerValue]];
                    
                    [self hideIndicatorModeify:YES];
                    [tvInfos reloadRowsAtIndexPaths:@[curIp] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
                default: {
                    [self hideIndicatorModeify:NO];
                    break;
                }
            }
            break;
        }
        case studentDetailHttpMethod_note: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (!dicResult || [dicResult isKindOfClass:[NSNull class]] || dicResult.count < 1)
                    {
                        [self hideIndicatorModeify:NO];
                        return;
                    }
                    NSString *strNote = [dicResult objectForKey:noteKey];
                    [student setStuNote:strNote];
                    
                    [self hideIndicatorModeify:YES];
                    [tvInfos reloadRowsAtIndexPaths:@[curIp] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
                default: {
                    [self hideIndicatorModeify:NO];
                    break;
                }
            }
            break;
        }
        case studentDetailHttpMethod_delete: {
            switch ([strCode integerValue]) {
                case 0: {
                    [[LyStudentManager sharedInstance] removeStudentByStuId:_stuId];
                    
                    [indicator_delete stopAnimation];
                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"删除成功"];
                    [remind setDelegate:self];
                    [remind show];
                    break;
                }
                case 1: {
                    [[LyStudentManager sharedInstance] removeStudentByStuId:_stuId];
                    
                    [indicator_delete stopAnimation];
                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"删除成功"];
                    [remind setDelegate:self];
                    [remind show];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        default: {
            [self handleHttpFailed];
            break;
        }
    }
}



#pragma mark -LyHttpRequestDelegate
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest
{
    if (bHttpFlag) {
        bHttpFlag = NO;
        [self handleHttpFailed];
        
        return;
    }
    
    curHttpMethod = 0;
}


- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result {
    if (bHttpFlag) {
        bHttpFlag = NO;
        curHttpMethod = ahttpRequest.mode;
    
        [self analysisHttpRequest:result];
    }
    
    curHttpMethod = 0;
}



#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(LyRemindView *)aRemind
{
    [_delegate onDeleteByStudentDetailVC:self];
}



#pragma mark -LyDetailControlBarDelegate
- (void)onClickedButtonPhone
{
//    UIWebView *callWebView = [[UIWebView alloc] init];
//    NSString *strContact = [[NSString alloc] initWithFormat:@"tel:%@", student.userPhoneNum];
//    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strContact]]];
//    [self.view addSubview:callWebView];
//}
    [LyUtil call:student.userPhoneNum];
}


- (void)onClickedButtonMessage {
//    [self sendSMS:nil recipientList:@[student.userPhoneNum]];
    [LyUtil sendSMS:nil recipients:@[student.userPhoneNum] target:self];
}



#pragma mark -MFMessageComposeViewControllerDelegate
// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    [NSThread sleepForTimeInterval:closeDelayTime];
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled) {
        [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"短信发送取消"] show];
    } else if (result == MessageComposeResultSent) {
        [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"短信发送成功"] show];
    } else {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"短信发送失败"] show];
    }
}


#pragma mark -LyAddressPicker
- (void)onAddressPickerCancel:(LyAddressPicker *)addressPicker
{
    [addressPicker hide];
}

- (void)onAddressPickerDone:(NSString *)address addressPicker:(LyAddressPicker *)addressPicker
{
    [addressPicker hide];
    
    if (![address isEqualToString:student.stuCensus])
    {
        [self updateStudentInfo:studentDetailHttpMethod_census content:address];
    }
}


#pragma mark -LyAddressAlertViewDelegate
- (void)addressAlertView:(LyAddressAlertView *)aAddressAlertView onClickButtonDone:(BOOL)isDone
{
    [aAddressAlertView hide];
    
    if (isDone)
    {
        NSString *strAddress = aAddressAlertView.address;
        
        if (![strAddress isEqualToString:student.stuPickAddress])
        {
            [self updateStudentInfo:studentDetailHttpMethod_pickAddress content:strAddress];
        }
    }
}


#pragma mark -LyChooseTrainClassTableViewControllerDelegate
- (void)onCancelByChooseTrainClassTVC:(LyChooseTrainClassTableViewController *)aChooseTrainClassTVC
{
    [aChooseTrainClassTVC.navigationController popViewControllerAnimated:YES];
}

- (void)onDoneByChooseTrainClassTVC:(LyChooseTrainClassTableViewController *)aChooseTrainClassTVC trainClass:(LyTrainClass *)aTrainClass
{
    [aChooseTrainClassTVC.navigationController popViewControllerAnimated:YES];
    
    if (![aTrainClass.tcName isEqualToString:student.stuTrainClassName])
    {
        [self updateStudentInfo:studentDetailHttpMethod_trianClassName content:aTrainClass.tcName];
    }
}


#pragma mark -LyPayInfoPickerDelegate
- (void)onCancenByPayInfoPicker:(LyPayInfoPicker *)aPayInfoPicker
{
    [aPayInfoPicker hide];
}

- (void)onDoneByPayInfoPicker:(LyPayInfoPicker *)aPayInfoPicker payInfo:(LyPayInfo)aPayInfo
{
    [aPayInfoPicker hide];
    
    if (aPayInfo != student.stuPayInfo)
    {
        [self updateStudentInfo:studentDetailHttpMethod_payInfo content:@(aPayInfo)];
    }
}


#pragma mark -LyStudyProgressPickerDelegate
- (void)onCancelByStudyProgressPicker:(LyStudyProgressPicker *)aStudyProgressPicker
{
    [aStudyProgressPicker hide];
}

- (void)onDoneByStudyProgressPicker:(LyStudyProgressPicker *)aStudyProgressPicker studyProgress:(LySubjectMode)aStudyProgress
{
    [aStudyProgressPicker hide];
    
    if (aStudyProgress != student.stuStudyProgress)
    {
        [self updateStudentInfo:studentDetailHttpMethod_studyProgress content:@(aStudyProgress)];
    }
}


#pragma mark -LySignatureAlertViewDelegate
- (void)signatureAlertView:(LySignatureAlertView *)aSignatureView isClickButtonDone:(BOOL)isDone
{
    [aSignatureView hide];
    
    if (isDone)
    {
        if (![aSignatureView.signature isEqualToString:student.stuNote])
        {
            [self updateStudentInfo:studentDetailHttpMethod_note content:aSignatureView.signature];
        }
    }
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (2 == indexPath.section)
    {
        return sdtcellHeight * 2;
    }
    else
    {
        return sdtcellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return LyTableViewHeaderFooterViewHeight;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LyTableViewHeaderFooterView *hfView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:lyStudentDetailTvInfosHeaderFooterViewReuseIdetifier];
    
    if (!hfView)
    {
        hfView = [[LyTableViewHeaderFooterView alloc] initWithReuseIdentifier:lyStudentDetailTvInfosHeaderFooterViewReuseIdetifier];
    }
    
    NSString *strContent;
    if (0 == section) {
        strContent = @"基本信息";
    } else if (1 == section) {
        strContent = @"培训课程";
    } else if (2 == section) {
        strContent = @"附加信息";
    }
    else {
        strContent = @"空";
    }
    
    [hfView setContent:strContent];
    
    return hfView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    curIp = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    LyAddressPicker *addressPicker = [LyAddressPicker addressPickerWithMode:LyAddressPickerMode_provinceAndCity];
                    [addressPicker setDelegate:self];
                    [addressPicker setAddress:student.stuCensus];
                    [addressPicker show];
                    break;
                }
                case 1: {
                    LyAddressAlertView *addressAlertView = [[LyAddressAlertView alloc] initWithAddress:student.stuPickAddress];
                    [addressAlertView setDelegate:self];
                    [addressAlertView show];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    LyChooseTrainClassTableViewController *chooseTrainClass = [[LyChooseTrainClassTableViewController alloc] init];
                    [chooseTrainClass setDelegate:self];
                    [self.navigationController pushViewController:chooseTrainClass animated:YES];
                    break;
                }
                case 1: {
                    LyPayInfoPicker *payInfoPicker = [[LyPayInfoPicker alloc] init];
                    [payInfoPicker setPayInfo:student.stuPayInfo];
                    [payInfoPicker setDelegate:self];
                    [payInfoPicker show];
                    break;
                }
                case 2: {
                    LyStudyProgressPicker *studyProgressPicker = [[LyStudyProgressPicker alloc] init];
                    [studyProgressPicker setCurIndex:student.stuStudyProgress];
                    [studyProgressPicker setDelegate:self];
                    [studyProgressPicker show];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    LySignatureAlertView *sign = [LySignatureAlertView signatureAlertViewWithSignature:student.stuNote];
                    [sign setDelegate:self];
                    [sign setPlaceholder:@"例：本周五安排科目一考试"];
                    [sign show];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default: {
            break;
        }
    }
}




#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: {
            return 2;
            break;
        }
        case 1: {
            return 3;
            break;
        }
        case 2: {
            return 1;
            break;
        }
        default: {
            return 0;
            break;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyStudentDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyStudentDetailTvInfosCellReuseIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[LyStudentDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyStudentDetailTvInfosCellReuseIdentifier];
    }
    
    switch (indexPath.section) {
        case 0: {
            [cell setCellInfo:LyStudentDetailTableViewCellMode_census+indexPath.row content:student];
            break;
        }
        case 1: {
            [cell setCellInfo:LyStudentDetailTableViewCellMode_trainClassName+indexPath.row content:student];
            break;
        }
        case 2: {
            [cell setCellInfo:LyStudentDetailTableViewCellMode_remark+indexPath.row content:student];
            break;
        }
        default:
            break;
    }
    
    return cell;
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
