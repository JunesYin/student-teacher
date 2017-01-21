//
//  LySweepViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/24.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LySweepViewController.h"

#import "LyCurrentUser.h"

#import "LyUtil.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyMyQRCodeViewController.h"
#import "LyLoginViewController.h"
#import "LyUserDetailViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


#define spWidth                             CGRectGetWidth(self.view.frame)
#define spHeight                            CGRectGetHeight(self.view.frame)


CGFloat const spMarginW = 30.0f;
CGFloat const spMarginH = 50.0f;


CGFloat const  viewScanWidth = 250.0f;
#define viewScanHeight                      viewScanWidth


#define swpLbRemindWidth                       spWidth
CGFloat const swpLbRemindHeight = 50.0f;
#define lbRemindFont                        LyFont(14)


#define viewBarWidth                        spWidth
CGFloat const swpViewBarHeight = 80.0f;

CGFloat const sBtnItemWidth = 100.0f;
#define btnItemHeight                       swpViewBarHeight
#define btnItemTitleFont                    LyFont(16)
#define btnItemSpace                        ((viewBarWidth-sBtnItemWidth*3)/4.0f)


#define viewMaskBoardColor                  [UIColor colorWithRed:50.0/255.0f green:50.0/255.0f blue:50.0/255.0f alpha:0.7]



typedef NS_ENUM( NSInteger, LySweepBarButtonMode)
{
    sweepBarButtonMode_myCode,
    sweepBarButtonMode_album,
    sweepBarButtonMode_light
};



typedef NS_ENUM( NSInteger, LySweepHttpMethod)
{
    sweepHttpMethod_userIsset = 1,
};



@interface LySweepViewController () <AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate, LyHttpRequestDelegate, LyUserDetailDelegate>
{
    
    UIView                          *viewMask;
    
    UIView                          *viewScan;
    UIImageView                     *ivScanNet;
    
    UILabel                         *lbRemind;
    
    UIView                          *viewBar;
    UIButton                        *btnMyCode;
    UIButton                        *btnAlbum;
    UIButton                        *btnLight;
    
    AVCaptureSession                *captureSession;
    AVCaptureDevice                 *captureDevice;
    AVCaptureDeviceInput            *captureInput;
    AVCaptureMetadataOutput         *captureOutput;
    AVCaptureVideoPreviewLayer      *captureLayer;
    
    
    LyIndicator                     *indicator_handle;
    NSString                        *sweepText;
    
    
    BOOL                            bHttpFlag;
    LySweepHttpMethod               curHttpMethod;
}


@end

@implementation LySweepViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initAndLayoutSubview];
}



- (void)viewWillAppear:(BOOL)animated
{
    for ( UIView *item in [self.view subviews])
    {
        if ( [item isKindOfClass:[UIWebView class]])
        {
            [item removeFromSuperview];
            break;
        }
    }
    
    
    [[viewMask layer] setBorderColor:[viewMaskBoardColor CGColor]];
    
    
}



- (void)viewDidAppear:(BOOL)animated
{
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ( AVAuthorizationStatusRestricted == videoStatus || AVAuthorizationStatusDenied == videoStatus) {
        //相机无权限
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitleForCamera
                                                                       message:alertMessageForCamera
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    [self.navigationController popViewControllerAnimated:YES];
                                                }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"设置"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                                        [LyUtil openUrl:url];
                                                    } else {
                                                        [LyUtil showAlert:LyAlertViewForAuthorityMode_camera vc:self];
                                                    }
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    [self  resumeAnimation];
}




- (void)viewWillDisappear:(BOOL)animated
{
    [viewMask setBackgroundColor:[UIColor clearColor]];
    [[viewMask layer] setBorderColor:[[UIColor clearColor] CGColor]];
    
    
    if ( [indicator_handle isAnimating])
    {
        [indicator_handle stop];
    }
}



- (void)initAndLayoutSubview
{
    self.title = @"扫一扫";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];


    if ( [self respondsToSelector:@selector(targetForNotificationAppDidBecomeActive:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(targetForNotificationAppDidBecomeActive:) name:LyAppDidBecomeActive object:nil];
    }
    
    [self reStart];
}



- (void)targetForNotificationAppDidBecomeActive:(NSNotification *)notification {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)reStart
{
    [self setupScanView];
    
    [self beginScan];
}


- (void)setupScanView
{
    viewScan = [[UIView alloc] initWithFrame:CGRectMake( spWidth/2-viewScanWidth/2, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT+spMarginH, viewScanWidth, viewScanHeight)];
    [viewScan setClipsToBounds:YES];
    [self.view addSubview:viewScan];
    
    
    ivScanNet = [[UIImageView alloc] initWithImage:[LyUtil imageForImageName:@"scan_net" needCache:NO]];
    
    
    CGFloat ivEdge = 20;
    UIImageView *ivTopLeft = [[UIImageView alloc] initWithFrame:CGRectMake( -1, -1, ivEdge, ivEdge)];
    UIImageView *ivTopRight = [[UIImageView alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewScan.frame)-ivEdge-1, 1, ivEdge, ivEdge)];
    UIImageView *ivBottomLeft = [[UIImageView alloc] initWithFrame:CGRectMake( -1, CGRectGetHeight(viewScan.frame)-ivEdge+1, ivEdge, ivEdge)];
    UIImageView *ivBottomRight = [[UIImageView alloc] initWithFrame:CGRectMake( CGRectGetWidth(viewScan.frame)-ivEdge+1, CGRectGetHeight(viewScan.frame)-ivEdge+1, ivEdge, ivEdge)];
    
    
    [ivTopLeft setImage:[LyUtil imageForImageName:@"scan_1" needCache:NO]];
    [ivTopRight setImage:[LyUtil imageForImageName:@"scan_2" needCache:NO]];
    [ivBottomLeft setImage:[LyUtil imageForImageName:@"scan_3" needCache:NO]];
    [ivBottomRight setImage:[LyUtil imageForImageName:@"scan_4" needCache:NO]];
    
    [viewScan addSubview:ivTopLeft];
    [viewScan addSubview:ivTopRight];
    [viewScan addSubview:ivBottomLeft];
    [viewScan addSubview:ivBottomRight];
    
    
    [self.view addSubview:viewScan];
    
    
    //遮挡
    viewMask = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, spHeight+viewScanWidth, spHeight+viewScanHeight)];
    [viewMask setCenter:viewScan.center];
    [viewMask setBackgroundColor:[UIColor clearColor]];
    
    [[viewMask layer] setBorderColor:[viewMaskBoardColor CGColor]];
    [[viewMask layer] setBorderWidth:CGRectGetHeight(viewMask.frame)/2.0f-viewScanWidth/2.0f];
    
    ;
    [self.view addSubview:viewMask];
    
    
    
    
    lbRemind = [[UILabel alloc] initWithFrame:CGRectMake( 0, viewScan.ly_y+CGRectGetHeight(viewScan.frame)+verticalSpace*4, swpLbRemindWidth, swpLbRemindHeight)];
    [lbRemind setText:@"将二维码放入取景框内\n即可自动扫描"];
    [lbRemind setNumberOfLines:2];
    [lbRemind setTextColor:LyWhiteLightgrayColor];
    [lbRemind setTextAlignment:NSTextAlignmentCenter];
    [lbRemind setFont:lbRemindFont];
    
    [self.view addSubview:lbRemind];
    
    
    
    viewBar = [[UIView alloc] initWithFrame:CGRectMake( 0, CGRectGetHeight(self.view.frame)-swpViewBarHeight, viewBarWidth, swpViewBarHeight)];
    [viewBar setBackgroundColor:[UIColor colorWithRed:25.0/255.0f green:25.0/255.0f blue:25.0/255.0f alpha:0.9]];
    [self.view addSubview:viewBar];
    
    btnMyCode = [self buttonWithBarButtonMode:sweepBarButtonMode_myCode];
    btnAlbum = [self buttonWithBarButtonMode:sweepBarButtonMode_album];
    btnLight = [self buttonWithBarButtonMode:sweepBarButtonMode_light];
    
    [viewBar addSubview:btnMyCode];
    [viewBar addSubview:btnAlbum];
    [viewBar addSubview:btnLight];
    
}



- (void)beginScan
{
    NSError *error;
    
    //初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //用captureDevice创建输入流
    captureInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if ( !captureInput)
    {
        NSLog(@"输入流创建失败：%@", [error localizedDescription]);
        return ;
    }
    
    //创建媒体数据输出流
    captureOutput = [AVCaptureMetadataOutput new];
    [captureOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    CGRect rectScanCrop = [self getScanCrop:viewScan.frame readerViewBounds:self.view.frame];
    [captureOutput setRectOfInterest:rectScanCrop];
    
    
    
    
    //实例化捕捉会话
    captureSession = [AVCaptureSession new];
    [captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    [captureSession addInput:captureInput];
    [captureSession addOutput:captureOutput];
    
    [captureOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]];
    
    
    //实例化预览图层
    captureLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    [captureLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [captureLayer setFrame:self.view.layer.bounds];
    [self.view.layer insertSublayer:captureLayer atIndex:0];
    
    
    
    [captureSession startRunning];
}



//获取扫描区域的比例关系
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    
    CGFloat x,y,width,height;
    
//    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
//    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
//    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
//    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);

    x = rect.origin.y / readerViewBounds.size.height;
    y = rect.origin.x / readerViewBounds.size.width;
    width = rect.size.height / readerViewBounds.size.height;
    height = rect.size.width / readerViewBounds.size.width;
    
    return CGRectMake(x, y, width, height);
    
}


//恢复动画
- (void)resumeAnimation
{
    CAAnimation *anim = [ivScanNet.layer animationForKey:@"translationAnimation"];
    if(anim){
        // 1. 将动画的时间偏移量作为暂停时的时间点
        CFTimeInterval pauseTime = ivScanNet.layer.timeOffset;
        // 2. 根据媒体时间计算出准确的启动动画时间，对之前暂停动画的时间进行修正
        CFTimeInterval beginTime = CACurrentMediaTime() - pauseTime;
        
        // 3. 要把偏移时间清零
        [ivScanNet.layer setTimeOffset:0.0];
        // 4. 设置图层的开始动画时间
        [ivScanNet.layer setBeginTime:beginTime];
        
        [ivScanNet.layer setSpeed:1.0];
        
    }else{
        
        CGFloat scanNetImageViewH = CGRectGetHeight(viewScan.frame);
        CGFloat scanWindowH = self.view.frame.size.width - spMarginW * 2;
        CGFloat scanNetImageViewW = viewScan.frame.size.width;
        
        ivScanNet.frame = CGRectMake(0, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
        CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
        scanNetAnimation.keyPath = @"transform.translation.y";
        scanNetAnimation.byValue = @(scanWindowH);
        scanNetAnimation.duration = 1.0;
        scanNetAnimation.repeatCount = MAXFLOAT;
        [ivScanNet.layer addAnimation:scanNetAnimation forKey:@"translationAnimation"];
        [viewScan addSubview:ivScanNet];
    }
    
    
    
}




- (UIButton *)buttonWithBarButtonMode:(LySweepBarButtonMode)buttonMode
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake( sBtnItemWidth*(buttonMode-sweepBarButtonMode_myCode)+btnItemSpace*(buttonMode-sweepBarButtonMode_myCode+1), 0, sBtnItemWidth, btnItemHeight)];
    [button setTag:buttonMode];
    [button addTarget:self action:@selector(spTargetForBarButton:) forControlEvents:UIControlEventTouchUpInside];
    
    switch ( buttonMode) {
        case sweepBarButtonMode_myCode: {
            [button setBackgroundImage:[LyUtil imageForImageName:@"sweep_btn_0" needCache:NO] forState:UIControlStateNormal];
            break;
        }
        case sweepBarButtonMode_album: {
            [button setBackgroundImage:[LyUtil imageForImageName:@"sweep_btn_1" needCache:NO] forState:UIControlStateNormal];
            break;
        }
        case sweepBarButtonMode_light: {
            [button setBackgroundImage:[LyUtil imageForImageName:@"sweep_btn_2_n" needCache:NO] forState:UIControlStateNormal];
            [button setBackgroundImage:[LyUtil imageForImageName:@"sweep_btn_2_h" needCache:NO] forState:UIControlStateSelected];
            break;
        }
    }
    
    
    return button;
}




- (void)spTargetForBarButton:(UIButton *)button
{
    switch ( [button tag])
    {
        case sweepBarButtonMode_myCode:
        {
            LyMyQRCodeViewController *qrCode = [[LyMyQRCodeViewController alloc] init];
            [qrCode setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:qrCode animated:YES];
            break;
        }
            
        case sweepBarButtonMode_album:
        {
            [self discernQRCodeFromAlbum];
            break;
        }
            
        case sweepBarButtonMode_light:
        {
            if ( [btnLight isSelected])
            {
                [btnLight setSelected:NO];
            }
            else
            {
                [btnLight setSelected:YES];
            }
            
            [self spSwitchFlashLight];
            break;
        }
            
        default:
        {
            break;
        }
    }
}




- (void)discernQRCodeFromAlbum
{
    
//    NSString *strSystemVersion = [[UIDevice currentDevice] systemVersion];
//    float fSystemVersion = [strSystemVersion floatValue];
//    if ( fSystemVersion < 8.0f)
//    {
//        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"该功能仅适用于iOS8及之后的系统"] show];
//        return;
//    }
    
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if ( ALAuthorizationStatusRestricted == author || ALAuthorizationStatusDenied == author) {
        //相册无权限
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitleForAlbum
                                                                       message:alertTitleForAlbum
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleDestructive
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
    
    
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    
    photoPicker.delegate = self;
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoPicker.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:photoPicker animated:YES completion:NULL];
}





- (void)spSwitchFlashLight
{
    if ( [btnLight isSelected])
    {
        [captureDevice lockForConfiguration:nil];
        [captureDevice setTorchMode:AVCaptureTorchModeOn];
        [captureDevice unlockForConfiguration];
    }
    else
    {
        [captureDevice lockForConfiguration:nil];
        [captureDevice setTorchMode:AVCaptureTorchModeOff];
        [captureDevice unlockForConfiguration];
    }
    
}


- (void)showAlertForText:(NSString *)text {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:text
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self.navigationController popViewControllerAnimated:YES];
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)handleQRCodeObject:(NSString *)text
{
    if (![LyUtil validateString:text]) {
        [self showAlertForText:text];
        return;
    }
    
    if ( !indicator_handle)
    {
        indicator_handle = [LyIndicator indicatorWithTitle:@"正在处理"];
    }
    [indicator_handle startAnimation];
    
    NSURL *url = [NSURL URLWithString:text];
    if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
        [LyUtil openUrl:url];
    } else {
        sweepText = text;
        [self issetUserId:sweepText];
    }
    
}




- (void)issetUserId:(NSString *)strUserId
{
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:sweepHttpMethod_userIsset];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:issetUserId_url
                                          body:@{
                                                userIdKey:strUserId
                                                }
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}


- (void)handleHttpFailed {
    if ([indicator_handle isAnimating]) {
        [indicator_handle stopAnimation];
     
        [self showAlertForText:sweepText];
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
        [indicator_handle stopAnimation];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_handle stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    switch ( curHttpMethod) {
        case sweepHttpMethod_userIsset: {
            curHttpMethod = 0;
            if ( 0 == [strCode integerValue]) {
                LyUserDetailViewController *userDetail = [[LyUserDetailViewController alloc] init];
                [userDetail setDelegate:self];
                [self.navigationController pushViewController:userDetail animated:YES];
            } else {
                [self handleHttpFailed];
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




#pragma mark -LyUserDetailDelegate
- (NSString *)obtainUserId
{
    return sweepText;
}



#pragma mark -AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count>0) {
        
        [captureSession stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        
        [self handleQRCodeObject:[metadataObject stringValue]];
    }

}



#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:^{
    }];
    
    UIImage * srcImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if ( srcImage.size.width > 280)
    {
        srcImage = [srcImage scaleToSize:CGSizeMake( 280, 280)];
    }
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    CIImage *image = [CIImage imageWithCGImage:srcImage.CGImage];
    NSArray *features = [detector featuresInImage:image];
    CIQRCodeFeature *feature = [features firstObject];
    
    NSString *result = feature.messageString;
    
    if ( result)
    {
        [self handleQRCodeObject:result];
    }
    else
    {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"出错"] show];
    }
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
