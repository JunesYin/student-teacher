//
//  LySendNewsViewController.m
//  teacher
//
//  Created by Junes on 2016/10/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LySendNewsViewController.h"
#import "LySendNewsCollectionViewCell.h"
#import "ZLPhoto.h"
#import "LyPhotoAsset.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "NSString+Validate.h"
#import "UITextView+placeholder.h"
//#import "UITextView+maxLength.h"

#import "LyCurrentUser.h"
#import "LyCurrentNews.h"
#import "LyNewsManager.h"


#import "LyUtil.h"


#import <AssetsLibrary/AssetsLibrary.h>


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

#define viewPicsWidth                                   SCREEN_WIDTH
#define viewPicsHeight                                  (cvPicItemSize+ssPicVerticalMargin*2)

#define cvPicsWidth                                     viewPicsWidth
#define cvPicsHeight                                    viewPicsHeight

#define cvPicItemSize                                   ((SCREEN_WIDTH-ssPicHorizontalMargin*(picsMaxCount-1))/picsMaxCount)




//定位view


#define ssStatusContentFont                             LyFont(14)
#define ssLocateFont                                    LyFont(14)



enum {
    sendNewsBarButtonItemTag_send = 0,
    
}LySendNewsBarButtonItemTag;



typedef NS_ENUM( NSInteger, LySendNewsHttpMethod) {
    sendNewsHttpMethod_send = 100,
};



@interface LySendNewsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LyHttpRequestDelegate, LySendNewsCollectionViewCellDelegate, ZLPhotoPickerBrowserViewControllerDelegate, UITextViewDelegate, LyRemindViewDelegate>
{
    UIBarButtonItem                         *bbiSend;
    
    UITextView                              *tvContent;
    UIView                                  *viewPics;
    UICollectionView                        *cvPics;
    
    NSMutableArray                          *ssArrPic;
    
    LyIndicator                             *indicotar_send;
    BOOL                                    bHttpFlag;
    LySendNewsHttpMethod                    curHttpMethod;
}
@end

@implementation LySendNewsViewController

static NSString *lySendNewsPicCvCellReuseIdentifier = @"lySendNewsPicCvCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initAndLayoutSubviews];
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


- (void)viewWillDisappear:(BOOL)animated {
    if (![tvContent.text isEqualToString:@""] || (ssArrPic && ssArrPic.count > 0)) {
        [[LyCurrentNews sharedInstance] setNewsContent:tvContent.text];
        
        [[LyCurrentNews sharedInstance] setNewsPics:ssArrPic];
    }
}



- (void)initAndLayoutSubviews {
    [self.view setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0  blue:238/255.0  alpha:1]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"发表动态";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    bbiSend = [[UIBarButtonItem alloc] initWithTitle:@"发表"
                                               style:UIBarButtonItemStyleDone
                                              target:self
                                              action:@selector(ssTargetForBarBtnItemRight)];
    [bbiSend setTag:sendNewsBarButtonItemTag_send];
    [self.navigationItem setRightBarButtonItem:bbiSend];
    
    //动态输入框
    tvContent = [[UITextView alloc] initWithFrame:CGRectMake(horizontalSpace, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT+verticalSpace*2, SCREEN_WIDTH-horizontalSpace*2, tvContentHeight)];
    [tvContent setPlaceholder:@"517吐槽……"];
    [tvContent setDelegate:self];
    [tvContent setFont:ssStatusContentFont];
    [tvContent setTextColor:LyBlackColor];
    [tvContent setBackgroundColor:[UIColor whiteColor]];
    [tvContent setReturnKeyType:UIReturnKeyDone];
    [tvContent.layer setCornerRadius:btnCornerRadius];
    
    
    viewPics = [[UIView alloc] initWithFrame:CGRectMake( 0, tvContent.ly_y+CGRectGetHeight(tvContent.frame)+verticalSpace*2.0f, viewPicsWidth, viewPicsHeight)];
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
    [cvPics registerClass:[LySendNewsCollectionViewCell class] forCellWithReuseIdentifier:lySendNewsPicCvCellReuseIdentifier];
    
    
    [viewPics addSubview:cvPics];
    
    
    
    [self.view addSubview:tvContent];
    [self.view addSubview:viewPics];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)updateBbiSend {
    [bbiSend setEnabled:(tvContent.text.length > 0 || ssArrPic.count > 0)];
}


- (void)ssTargetForBarBtnItemRight {
    [tvContent resignFirstResponder];
    
    if ( ![tvContent text] || [[tvContent text] isKindOfClass:[NSNull class]] || [[tvContent text] isEqualToString:@""]) {
        if ( !ssArrPic || ![ssArrPic isKindOfClass:[NSArray class]] || ![ssArrPic count]) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"没有任何内容"] show];
            return;
        }
    }
    
    [self send];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [tvContent resignFirstResponder];
}



- (void)send {
    if ( !indicotar_send) {
        indicotar_send = [[LyIndicator alloc] initWithTitle:@"正在发表..."];
    }
    [indicotar_send startAnimation];
    
    [self performSelector:@selector(sendNewsForDelay) withObject:nil afterDelay:validateSensitiveWordDelayTime];
}


- (void)sendNewsForDelay
{
    if ( ![[tvContent text] validateSensitiveWord]) {
        [indicotar_send stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:LyRemindTitle_sensitiveWord] show];
    } else {
        NSMutableArray *arr = [NSMutableArray array];
        for (LyPhotoAsset *item in ssArrPic) {
            if (item && item.fullImage) {
                [arr addObject:item.fullImage];
            }
        }
        
        
        LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:sendNewsHttpMethod_send];
        [httpRequest setDelegate:self];
        bHttpFlag = [httpRequest sendMultiPics:sendNews_url
                                         image:arr
                                          body:@{
                                                 contentKey:[tvContent text],
                                                 picCountKey:@(arr.count),
                                                 userIdKey:[LyCurrentUser curUser].userId,
                                                 sessionIdKey:[LyUtil httpSessionId],
                                                 userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                                 }];
    }
    
}



- (void)handleHttpFailed {
    if ([indicotar_send isAnimating]) {
        [indicotar_send stopAnimation];
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
        [indicotar_send stopAnimation];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicotar_send stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch ( curHttpMethod) {
        case sendNewsHttpMethod_send: {
            curHttpMethod = 0;
            switch ( [strCode integerValue]) {
                case 0: {
                    NSDictionary *dicItem = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicItem]) {
                        [self handleHttpFailed];
                        return;
                    }
                    
                    
                    NSString *strId = [dicItem objectForKey:newsIdKey];
                    NSString *strTime = [dicItem objectForKey:newsTimeKey];
                    
                    strTime = [LyUtil fixDateTimeString:strTime];
                    
                    LyNews *news = [LyNews newsWithId:strId
                                             masterId:[LyCurrentUser curUser].userId
                                                 time:strTime
                                              content:tvContent.text
                                        transmitCount:0
                                      evaluationCount:0
                                          praiseCount:0];
                    
                    
                    
                    NSArray *arrPicUrls = [dicItem objectForKey:imageUrlKey];
                    for ( int i = 0; i < [arrPicUrls count]; ++i) {
                        NSString *strImageUrl = [arrPicUrls objectAtIndex:i];
                        [news addPic:[[ssArrPic objectAtIndex:i] fullImage] picUrl:strImageUrl index:i];
                    }
                    
                    
                    [[LyNewsManager sharedInstance] addNews:news];
                    
                    
                    [indicotar_send stopAnimation];
                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"发表成功"];
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
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest {
    if ( bHttpFlag) {
        bHttpFlag = NO;
        [self handleHttpFailed];
    }
    
    curHttpMethod = 0;
}

- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result {
    if ( bHttpFlag) {
        bHttpFlag = NO;
        curHttpMethod = [ahttpRequest mode];
        [self analysisHttpResult:result];
    }
    
    curHttpMethod = 0;
}


#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(UIView *)view {
    tvContent.text = @"";
    ssArrPic = nil;
    [[LyCurrentNews sharedInstance] clear];
    
    [_delegate onDoneBySendNewsVC:self];

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


#pragma mark -LySendNewsCollectionViewCellDelegate
- (void)onDeleteBySendNewsCollectionViewCell:(LySendNewsCollectionViewCell *)acell {
    NSInteger index = acell.index;
    [ssArrPic removeObjectAtIndex:index];
    [cvPics reloadData];
    
    [self updateBbiSend];
}



#pragma mark -ZLPhotoPickerBrowserViewControllerDelegate
- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index
{
    if ( [ssArrPic count] > 0) {
        [ssArrPic removeObjectAtIndex:index];
        [cvPics reloadData];
    }
    
    [self updateBbiSend];
}




#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [indexPath row] == [ssArrPic count]) {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if ( ALAuthorizationStatusRestricted == author || ALAuthorizationStatusDenied == author) {
            //相册无权限
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitleForAlbum
                                                                           message:alertMessageForAlbum
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"设置"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                                            [LyUtil openUrl:url];
                                                        } else {
                                                            [LyUtil showAlert:LyAlertViewForAuthorityMode_album vc:self];
                                                        }
                                                    }]];
            [self presentViewController:alert animated:YES completion:nil];
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
                if (!ssArrPic) {
                    ssArrPic = [[NSMutableArray alloc] initWithCapacity:1];
                }
                
                id zlImage = [status objectAtIndex:i];
                LyPhotoAsset *asset = nil;
                
                if ([zlImage isKindOfClass:[ZLPhotoAssets class]]) {
                    asset = [LyPhotoAsset assetWithAsset:[zlImage asset]];
                } else if ([zlImage isKindOfClass:[ZLCamera class]]) {
                    //                    NSString *zlImagePath = [zlImage imagePath];
                    asset = [LyPhotoAsset assetWithImage:[UIImage imageWithContentsOfFile:[zlImage imagePath]]];
                }
                
                if (asset) {
                    [ssArrPic addObject:asset];
                }
            }
            [self updateBbiSend];
            [cvPics reloadData];
            
        };
        [pickerVc showPickerVc:self];
    } else {
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

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ([ssArrPic count] < 4) ? [ssArrPic count]+1 : [ssArrPic count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (LySendNewsCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LySendNewsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lySendNewsPicCvCellReuseIdentifier forIndexPath:indexPath];
    if ( cell) {
        [cell setIndex:[indexPath row]];
        
        if ( [indexPath row] == [ssArrPic count]) {
            [cell setCellInfo:nil andMode:LySendNewsPicCollectionViewCellMode_add andIndex:[indexPath row] isEditing:YES];
        } else {
            [cell setCellInfo:[[ssArrPic objectAtIndex:indexPath.row] thumbnailImage] andMode:LySendNewsPicCollectionViewCellMode_pic andIndex:[indexPath row] isEditing:YES];
            [cell setDelegate:self];
        }
    }
    
    return cell;
}

#pragma mark -UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(cvPicItemSize, cvPicItemSize);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake( ssPicVerticalMargin, 0, ssPicVerticalMargin, 0);
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
