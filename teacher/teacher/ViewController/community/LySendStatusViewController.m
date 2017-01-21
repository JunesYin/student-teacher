//
//  LySendStatusViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/1.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LySendStatusViewController.h"
#import "LySendStatusPicCollectionViewCell.h"
#import "ZLPhoto.h"
#import "LyPhotoAsset.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "NSString+Validate.h"
#import "UITextView+placeholder.h"
//#import "UITextView+maxLength.h"

#import "LyCurrentUser.h"
#import "LyCurrentNews.h"
#import "LyStatusManager.h"


#import "LyUtil.h"


#import <AssetsLibrary/AssetsLibrary.h>



#define ssWidth                                         FULLSCREENWIDTH
#define ssHeight                                        FULLSCREENHEIGHT

CGFloat const ssVerticalSpace = 15.0f;

CGFloat const ssPicSpace = 5.0f;


int const ssViewPicMaxCount = 4;


//动态输入框
CGFloat const tvContentHeight = 200.0f;
//动态输入框最大字符数
int const ssTvStatusContentMaxNum = 120;





//添加照片view
int const picsMaxCount = 4;

CGFloat const ssPicHorizontalMargin = 2.0f;
CGFloat const ssPicVerticalMargin = 5.0f;

#define viewPicsWidth                                   FULLSCREENWIDTH
#define viewPicsHeight                                  (cvPicItemSize+ssPicVerticalMargin*2)

#define cvPicsWidth                                     viewPicsWidth
#define cvPicsHeight                                    viewPicsHeight

#define cvPicItemSize                                   ((FULLSCREENWIDTH-ssPicHorizontalMargin*(picsMaxCount-1))/picsMaxCount)




//定位view


#define ssStatusContentFont                             LyFont(14)
#define ssLocateFont                                    LyFont(14)


enum {
    sendStatusBarButtonItemTag_send = 0,
    
}LySendStatusBarButtonItemTag;

typedef NS_ENUM( NSInteger, LySendStatusAlertViewMode)
{
    sendStatusAlertViewMode_album = 10,
};


typedef NS_ENUM( NSInteger, LySendStatusHttpMethod)
{
    sendStatusHttpMethod_send = 100,
};


@interface LySendStatusViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LyHttpRequestDelegate, LySendStatusPicCollectionViewCellDelegate, ZLPhotoPickerBrowserViewControllerDelegate, UITextViewDelegate, LyRemindViewDelegate, UIAlertViewDelegate>
{
    UIBarButtonItem                         *bbiSend;
    
    UITextView                              *tvContent;
    
    UIView                                  *viewPics;
    UICollectionView                        *cvPics;

    NSMutableArray                          *ssArrPic;
    
    LySendStatusHttpMethod                  curHttpMethod;
    BOOL                                    bHttpFlag;
    
    LyIndicator                             *indicotar_send;
}
@end

@implementation LySendStatusViewController


static NSString *LySendStatusPicCollectionViewCellReuseIdentifier = @"LySendStatusPicCollectionViewCellReuseIdentifier";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self ssLayoutUI];
    
}



- (void)viewWillAppear:(BOOL)animated {
    
    [bbiSend setEnabled:NO];
    
    if ([[LyCurrentNews sharedInstance] hasNews]) {
        if ([LyCurrentNews sharedInstance].newsContent) {
            [tvContent setText:[LyCurrentNews sharedInstance].newsContent];
            [tvContent updatePlaceholder];
        }
        
        if ([LyCurrentNews sharedInstance].newsPics && [LyCurrentNews sharedInstance].newsPics.count > 0) {
            ssArrPic = [LyCurrentNews sharedInstance].newsPics;
            [cvPics reloadData];
        }
        
        [bbiSend setEnabled:YES];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    if (![tvContent.text isEqualToString:@""] || (ssArrPic && ssArrPic.count > 0))
    {
        [[LyCurrentNews sharedInstance] setNewsContent:tvContent.text];
        
        [[LyCurrentNews sharedInstance] setNewsPics:ssArrPic];
    }
}



- (void)ssLayoutUI
{
    [self.view setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0  blue:238/255.0  alpha:1]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"发表动态";
    
    
    bbiSend = [[UIBarButtonItem alloc] initWithTitle:@"发表"
                                                style:UIBarButtonItemStyleDone
                                               target:self
                                               action:@selector(ssTargetForBarBtnItemRight)];
    [bbiSend setTag:sendStatusBarButtonItemTag_send];
    [self.navigationItem setRightBarButtonItem:bbiSend];
    
    //动态输入框
    tvContent = [[UITextView alloc] initWithFrame:CGRectMake(horizontalSpace, STATUSBARHEIGHT+NAVIGATIONBARHEIGHT+verticalSpace*2, FULLSCREENWIDTH-horizontalSpace*2, tvContentHeight)];
    [tvContent setPlaceholder:@"517吐槽……"];
    [tvContent setDelegate:self];
    [tvContent setFont:ssStatusContentFont];
    [tvContent setTextColor:LyBlackColor];
    [tvContent setBackgroundColor:[UIColor whiteColor]];
    [tvContent setReturnKeyType:UIReturnKeyDone];
    [tvContent.layer setCornerRadius:btnCornerRadius];
    
    
    viewPics = [[UIView alloc] initWithFrame:CGRectMake( 0, tvContent.frame.origin.y+CGRectGetHeight(tvContent.frame)+verticalSpace*2.0f, viewPicsWidth, viewPicsHeight)];
    [viewPics setBackgroundColor:[UIColor whiteColor]];
    
    UICollectionViewFlowLayout *sendStatusPicCollectoinViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [sendStatusPicCollectoinViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [sendStatusPicCollectoinViewFlowLayout setMinimumLineSpacing:ssPicHorizontalMargin];
    [sendStatusPicCollectoinViewFlowLayout setMinimumInteritemSpacing:verticalSpace];
    
    cvPics = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, cvPicsWidth, cvPicsHeight) collectionViewLayout:sendStatusPicCollectoinViewFlowLayout];
    [cvPics setDelegate:self];
    [cvPics setDataSource:self];
    [cvPics setScrollsToTop:NO];
    [cvPics setScrollEnabled:YES];
    [cvPics setShowsVerticalScrollIndicator:NO];
    [cvPics setShowsHorizontalScrollIndicator:NO];
    [cvPics setBackgroundColor:[UIColor clearColor]];
    [cvPics registerClass:[LySendStatusPicCollectionViewCell class] forCellWithReuseIdentifier:LySendStatusPicCollectionViewCellReuseIdentifier];
    
    
    [viewPics addSubview:cvPics];


    
    [self.view addSubview:tvContent];
    [self.view addSubview:viewPics];
}



- (void)updateBbiSend {
    [bbiSend setEnabled:(tvContent.text.length > 0 || ssArrPic.count > 0)];
}


- (void)ssTargetForBarBtnItemRight {
    [tvContent resignFirstResponder];
    
    if ( ![tvContent text] || [[tvContent text] isKindOfClass:[NSNull class]] || [[tvContent text] isEqualToString:@""])
    {
        if ( !ssArrPic || ![ssArrPic isKindOfClass:[NSArray class]] || ![ssArrPic count])
        {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"没有任何内容"] show];
            return;
        }
        
        [self send];
    }
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [tvContent resignFirstResponder];
}





- (void)send {
    if ( !indicotar_send)
    {
        indicotar_send = [[LyIndicator alloc] initWithTitle:@"正在发表..."];
    }
    [indicotar_send start];
    
    [self performSelector:@selector(sendNewsForDelay) withObject:nil afterDelay:validateSensitiveWordDelayTime];
}


- (void)sendNewsForDelay
{
    if ( ![[tvContent text] validateSensitiveWord])
    {
        [indicotar_send stop];
        LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:remindTitle_sensitiveWord];
        [remind show];
    }
    else
    {
        NSMutableArray *arr = [NSMutableArray array];
        for (LyPhotoAsset *item in ssArrPic) {
            if (item && item.fullImage)
            {
                [arr addObject:item.fullImage];
            }
        }
        
        
        LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:sendStatusHttpMethod_send];
        [httpRequest setDelegate:self];
        bHttpFlag = [httpRequest sendMultiPics:sendNews_url
                                         image:arr
                                   requestBody:@{
                                                 contentKey:[tvContent text],
                                                 picCountKey:@(arr.count),
                                                 userIdKey:[[LyCurrentUser currentUser] userId],
                                                 sessionIdKey:[LyUtil httpSessionId],
                                                 userTypeKey:[[LyCurrentUser currentUser] userTypeByString]
                                                 }];
    }

}




- (void)handleHttpFailed {
    if ([indicotar_send isAnimating]) {
        [indicotar_send stop];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"发表失败"] show];
    }
}


- (void)analysisHttpResult:(NSString *)result
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
        [indicotar_send stop];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicotar_send stop];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch ( curHttpMethod) {
        case sendStatusHttpMethod_send: {
            curHttpMethod = 0;
            switch ( [strCode integerValue]) {
                case 0: {
                    
                    NSDictionary *dicItem = [dic objectForKey:resultKey];
                    if ( !dicItem || [dicItem isKindOfClass:[NSNull class]] || ![dicItem count])
                    {
                        [indicotar_send stop];
                        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"发表失败"] show];
                        return;
                    }
                    
                    
                    NSString *strId = [dicItem objectForKey:statusIdKey];
                    NSString *strTime = [dicItem objectForKey:statusTimeKey];
                    
                    strTime = [LyUtil fixDateTimeString:strTime];
                    
                    LyStatus *status = [LyStatus statusWithStatusId:strId
                                                           masterId:[[LyCurrentUser currentUser] userId]
                                                               time:strTime
                                                            content:[tvContent text]
                                                           picCount:(int)[ssArrPic count]
                                                        praiseCount:0
                                                     evalutionCount:0
                                                      transmitCount:0];
                    
                    
                    NSArray *arrPicUrls = [dicItem objectForKey:imageUrlKey];
                    for ( int i = 0; i < [arrPicUrls count]; ++i)
                    {
                        NSString *strImageUrl = [arrPicUrls objectAtIndex:i];
                        
                        [status addPic:[[ssArrPic objectAtIndex:i] fullImage] andBigPicUrl:strImageUrl withIndex:i];
                    }

                    
                    [[LyStatusManager sharedInstance] addStatus:status];
                    
                    
                    
                    [indicotar_send stop];
                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"发表成功"];
                    [remind setDelegate:self];
                    [remind show];
                    
                    break;
                }
                 
                case 1: {
                    NSString *strMessage = [dic objectForKey:messageKey];
                    [indicotar_send stop];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:strMessage] show];
                    
                    break;
                }
                    
                default: {
                    NSString *strMessage = [dic objectForKey:messageKey];
                    [indicotar_send stop];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:strMessage] show];
                    break;
                }
                    
            }
            
            break;
        }
            
        default: {
            
            curHttpMethod = 0;
            
            [indicotar_send stop];
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"发表失败"] show];

            
            break;
        }
    }
}



#pragma mark -LyHttpRequestDelegate
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest
{
    if ( bHttpFlag)
    {
        bHttpFlag = NO;
        
        curHttpMethod = 0;
        
        [indicotar_send stop];
        
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"发表失败"] show];
    }
}

- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result
{
    if ( bHttpFlag)
    {
        bHttpFlag = NO;
        curHttpMethod = [ahttpRequest mode];
        [self analysisHttpResult:result];
    }
}


#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(UIView *)view
{
    tvContent.text = @"";
    ssArrPic = nil;
    [[LyCurrentNews sharedInstance] clear];
    
    if ( [_delegate respondsToSelector:@selector(onSendStatusSucess:)])
    {
        [_delegate onSendStatusSucess:self];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark -UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    [tvContent resignFirstResponder];
}



- (void)textViewDidChange:(UITextView *)textView {
    [self updateBbiSend];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ( [text isEqualToString:@"\n"]) {
        [tvContent resignFirstResponder];
        return NO;
    }
    
    
    return YES;
}


#pragma mark -LySendStatusPicCollectionViewCellDelegate
- (void)onDeleteLySendStatusPicCollectionViewCell:(LySendStatusPicCollectionViewCell *)ycell
{
    NSInteger index = [ycell index];
    [ssArrPic removeObjectAtIndex:index];
    [cvPics reloadData];
    
    [self updateBbiSend];
}


#pragma mark -ZLPhotoPickerBrowserViewControllerDelegate
- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index
{
    if ( [ssArrPic count] > 0)
    {
        [ssArrPic removeObjectAtIndex:index];
        [cvPics reloadData];
    }
    
    [self updateBbiSend];
}


#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( sendStatusAlertViewMode_album == [alertView tag]) {
        if ( 1 == buttonIndex) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [LyUtil openUrl:url];
            } else {
                [LyUtil showAlertView:LyAlertViewForAuthorityMode_album];
            }
        }
    }
}



#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [indexPath row] == [ssArrPic count])
    {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if ( ALAuthorizationStatusRestricted == author || ALAuthorizationStatusDenied == author)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertViewTitleForAlbum
                                                            message:alertViewMessageForAlbum
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"设置", nil];
            [alert setTag:sendStatusAlertViewMode_album];
            [alert show];
            return;
        }
        
        
        ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
        // MaxCount, Default = 9
        pickerVc.maxCount = 4 - ssArrPic.count;
        // Jump AssetsVc
        pickerVc.status = PickerViewShowStatusCameraRoll;
        // Filter: PickerPhotoStatusAllVideoAndPhotos, PickerPhotoStatusVideos, PickerPhotoStatusPhotos.
        pickerVc.photoStatus = PickerPhotoStatusPhotos;
        // Recoder Select Assets
        pickerVc.selectPickers = ssArrPic;
        // Desc Show Photos, And Suppor Camera
        pickerVc.topShowPhotoPicker = YES;
        pickerVc.isShowCamera = YES;
        // CallBack
        pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
            for ( int i = 0; i < [status count]; ++i)
            {
                if (!ssArrPic)
                {
                    ssArrPic = [[NSMutableArray alloc] initWithCapacity:1];
                }
                
                ZLPhotoAssets *zlAssets = [status objectAtIndex:i];
                LyPhotoAsset *asset = [LyPhotoAsset assetWithAsset:zlAssets.asset];

                [ssArrPic addObject:asset];
            }
            [self updateBbiSend];
            [cvPics reloadData];
            
        };
        [pickerVc showPickerVc:self];
    }
    else
    {
        // 图片游览器
        ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
        // 淡入淡出效果
         pickerBrowser.status = UIViewAnimationAnimationStatusZoom;
        // 数据源/delegate
        pickerBrowser.editing = YES;
        
        NSMutableArray *photos = [[NSMutableArray alloc] initWithCapacity:1];
        for ( int i = 0; i < [ssArrPic count]; ++i) {
            [photos addObject:[ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:[[ssArrPic objectAtIndex:i] fullImage]]];
        }
        pickerBrowser.photos = photos;
        // 能够删除
        pickerBrowser.delegate = self;
        // 当前选中的值
        pickerBrowser.currentIndex = indexPath.row;
        // 展示控制器
        [pickerBrowser showPickerVc:self];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ([ssArrPic count] < 4) ? [ssArrPic count]+1 : [ssArrPic count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (LySendStatusPicCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LySendStatusPicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LySendStatusPicCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    if ( cell)
    {
        [cell setIndex:[indexPath row]];
        
        if ( [indexPath row] == [ssArrPic count])
        {
            [cell setCellInfo:nil andMode:LySendStatusPicCollectionViewCellMode_add andIndex:[indexPath row] isEditing:YES];
        }
        else
        {
            [cell setCellInfo:[[ssArrPic objectAtIndex:indexPath.row] thumbnailImage] andMode:LySendStatusPicCollectionViewCellMode_pic andIndex:[indexPath row] isEditing:YES];
            [cell setDelegate:self];
        }
    }
    
    return cell;
}

#pragma mark -UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(cvPicItemSize, cvPicItemSize);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake( ssPicVerticalMargin, 0, ssPicVerticalMargin, 0);
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
