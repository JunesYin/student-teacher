//
//  LyMyQRCodeViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/25.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyMyQRCodeViewController.h"
#import <CoreImage/CoreImage.h>
#import "LyIndicator.h"
#import "LyCurrentUser.h"
#import "UIImage+QRCode.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyUtil.h"



#define qrcWidth                            CGRectGetWidth(self.view.frame)
#define qrcHeight                           CGRectGetHeight(self.view.frame)

//信息
#define viewInfoWidth                       qrcWidth
CGFloat const mqrcViewInfoHeight = 80.0f;

CGFloat const mqrcIvAvatarSize = 60.0f;

#define mqrcLbNameWidth                         (viewInfoWidth-50.0f-mqrcIvAvatarSize-horizontalSpace)
CGFloat const mqrcLbNameHeight = 20.0f;
#define lbNameFont                          LyFont(16)



#define lbAddressWidth                      mqrcLbNameWidth
#define lbAddressHeight                     mqrcLbNameHeight
#define lbAddressFont                       LyFont(14)


//二维码
CGFloat const ivQRCodeSize = 200.0f;


//提示
#define mqrcTvRemindWidth                       (qrcWidth-horizontalSpace*2.0f)
CGFloat const mqrcTvRemindHeight = 60.0f;
#define tvRemindFont                        LyFont(15)



typedef NS_ENUM( NSInteger, LyMyQRcodeHttpMethod)
{
    myQRCodeHttpMethod_getUserInfo = 53,
    myQRCodeHttpMethod_uploadQRCode
};




@interface LyMyQRCodeViewController () <LyHttpRequestDelegate>
{
    NSString                *currentUserId;
    
    UIView                  *viewInfo;
    UIImageView             *ivAvatar;
    UILabel                 *lbName;
    UIImageView             *ivSex;
    UILabel                 *lbAddress;
    
    UIImageView             *ivMyQRCode;
    
    UIView                  *viewRemind;
    UITextView              *tvRemind;
    
    
    CGFloat                 originalBrightness;
    
    
    LyIndicator             *indicator_save;
    LyIndicator             *indicator_load;
    
    BOOL                    bHttpFlag;
    LyMyQRcodeHttpMethod    curHttpMethod;
}
@end

@implementation LyMyQRCodeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubview];
}





- (void)viewDidAppear:(BOOL)animated
{
    
    if ( ![[[LyCurrentUser curUser] userId] isEqualToString:currentUserId])
    {
        if (!indicator_load)
        {
            indicator_load = [LyIndicator indicatorWithTitle:@"正在生成二维码..."];
        }
        [indicator_load startAnimation];
        
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.05f];
    }
    
    //保存当前屏幕亮度
    originalBrightness = [UIScreen mainScreen].brightness;
    //设置屏幕亮度
    [[UIScreen mainScreen] setBrightness:0.9f];
}



- (void)viewWillDisappear:(BOOL)animated {
    //还原屏幕亮度
    [[UIScreen mainScreen]setBrightness:originalBrightness];
}




- (void)initAndLayoutSubview
{
    self.title = @"我的二维码";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake( 0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT+30.0f, viewInfoWidth, mqrcViewInfoHeight)];
    
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake( 50.0f, mqrcViewInfoHeight/2.0f-mqrcIvAvatarSize/2.0f, mqrcIvAvatarSize, mqrcIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [[ivAvatar layer] setCornerRadius:mqrcIvAvatarSize/2.0f];
    [ivAvatar setClipsToBounds:YES];
    
    lbName = [[UILabel alloc] initWithFrame:CGRectMake( ivAvatar.frame.origin.x+CGRectGetWidth(ivAvatar.frame)+horizontalSpace, ivAvatar.frame.origin.y+CGRectGetHeight(ivAvatar.frame)/2.0f-(mqrcLbNameHeight+verticalSpace*2+lbAddressHeight)/2.0f, mqrcLbNameWidth, mqrcLbNameHeight)];
    [lbName setFont:lbNameFont];
    [lbName setTextColor:LyBlackColor];
    [lbName setTextAlignment:NSTextAlignmentLeft];
    
    
    lbAddress = [[UILabel alloc] initWithFrame:CGRectMake( lbName.frame.origin.x, lbName.frame.origin.y+CGRectGetHeight(lbName.frame)+verticalSpace*2.0f, lbAddressWidth, lbAddressHeight)];
    [lbAddress setFont:lbAddressFont];
    [lbAddress setTextColor:LyDarkgrayColor];
    [lbAddress setTextAlignment:NSTextAlignmentLeft];
    
    [viewInfo addSubview:ivAvatar];
    [viewInfo addSubview:lbName];
    [viewInfo addSubview:lbAddress];
    
    
    ivMyQRCode = [[UIImageView alloc] initWithFrame:CGRectMake( SCREEN_WIDTH/2.0f-ivQRCodeSize/2.0f, viewInfo.frame.origin.y+CGRectGetHeight(viewInfo.frame)+20.0f, ivQRCodeSize, ivQRCodeSize)];
    [ivMyQRCode setClipsToBounds:YES];
//    [ivMyQRCode.layer setBorderWidth:2.0f];
//    [ivMyQRCode.layer setBorderColor:[Ly517ThemeColor CGColor]];
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
    [longPress setMinimumPressDuration:1.0f];
    
    [ivMyQRCode setUserInteractionEnabled:YES];
    [ivMyQRCode addGestureRecognizer:longPress];
    
    
    tvRemind = [[UITextView alloc] initWithFrame:CGRectMake( horizontalSpace, ivMyQRCode.frame.origin.y+CGRectGetHeight(ivMyQRCode.frame)+20.0f, mqrcTvRemindWidth, mqrcTvRemindHeight)];
    [tvRemind setBackgroundColor:[UIColor clearColor]];
    [tvRemind setTextColor:LyBlackColor];
    [tvRemind setEditable:NO];
    [tvRemind setScrollEnabled:NO];
    [tvRemind setScrollsToTop:NO];
    [tvRemind setTextAlignment:NSTextAlignmentCenter];
    [tvRemind setText:@"扫一扫上边的二维码，添加我为驾友吧\n【长按可保存】"];//\n【单击二维码可重新生成】"];
    [tvRemind setHidden:YES];

    
    
    [self.view addSubview:viewInfo];
    [self.view addSubview:ivMyQRCode];
    [self.view addSubview:tvRemind];
    

//    [ivMyQRCode setHidden:YES];
}



- (void)saveImage:(UILongPressGestureRecognizer *)longpress {
    if ( UIGestureRecognizerStateBegan == [longpress state]) {
        
        UIAlertController *action = [UIAlertController alertControllerWithTitle:@"是否要保存当前二维码"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        [action addAction:[UIAlertAction actionWithTitle:@"取消"
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
        [action addAction:[UIAlertAction actionWithTitle:@"保存"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     [self saveQrCode];
                                                 }]];
        [self presentViewController:action animated:YES completion:nil];
    }
}


- (void)saveQrCode
{
    if ( !indicator_save)
    {
        indicator_save = [[LyIndicator alloc] initWithTitle:@"正在保存..."];
    }
    [indicator_save startAnimation];
    
    UIImageWriteToSavedPhotosAlbum(_myQRCode, self, @selector(saveImage:didFinishSaveWithError:contextInfo:), NULL);
}


- (void)saveImage:(UIImage *)image didFinishSaveWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [indicator_save stopAnimation];
    
    if ( !error)
    {
        [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"保存成功"] show];
    }
    else
    {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"保存失败"] show];
    }
}


- (void)refreshView
{

    [lbName setText:[[LyCurrentUser curUser] userName]];
    
    if ( ![[LyCurrentUser curUser] userAvatar])
    {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:[[LyCurrentUser curUser] userId]]
                    placeholderImage:[LyUtil defaultAvatarForStudent]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if (image)
                               {
                                   [[LyCurrentUser curUser] setUserAvatar:image];
                               }
                               else
                               {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:[LyCurrentUser curUser].userId]
                                               placeholderImage:[LyUtil defaultAvatarForStudent]
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                          if (image)
                                                          {
                                                              [[LyCurrentUser curUser] setUserAvatar:image];
                                                          }
                                                      }];
                               }
                           }];
    }
    else
    {
        [ivAvatar setImage:[[LyCurrentUser curUser] userAvatar]];
    }
    
    
    if (![LyCurrentUser curUser].userAddress || ![LyUtil validateString:[LyCurrentUser curUser].userAddress])
    {
        [lbAddress setText:@""];
    }
    else
    {
        [lbAddress setText:[[LyCurrentUser curUser] userAddress]];
    }
    
    [self makeQRCode];
    
    [indicator_load performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.3f];
//    [ivMyQRCode setHidden:NO];
}





- (void)makeQRCode
{
//    UIImage *image = [UIImage imageForQRCodeFromUrl:[[NSString alloc] initWithFormat:@"student517xueche://?userid=%@", [LyCurrentUser curUser].userId]
//                                           codeSize:280
//                                                red:255.0
//                                              green:90.0
//                                               blue:0.0
//                                        insertImage:[LyCurrentUser curUser].userAvatar
//                                       cornerRadius:btnCornerRadius];
    UIImage *image = [UIImage imageForQRCodeFromUrl:[LyCurrentUser curUser].userId
                                           codeSize:280
                                                red:255.0
                                              green:90.0
                                               blue:0.0
                                        insertImage:[LyCurrentUser curUser].userAvatar
                                       cornerRadius:btnCornerRadius];
    
//    UIImage *icon = [LyUtil imageForImageName:@"icon_qrcode" needCache:NO];
//    UIImage *image = [UIImage imageForQRCodeFromUrl:@"itms-apps://itunes.apple.com/app/id1107516226" codeSize:2048 red:0 green:0 blue:0.0 insertImage:icon cornerRadius:btnCornerRadius];
    
    if ( !_myQRCode )
    {
        _myQRCode = image;
        [ivMyQRCode setImage:_myQRCode];
    }

//    NSData *data1 = UIImagePNGRepresentation(_myQRCode);
//    NSData *data2 = UIImagePNGRepresentation(image);
    
    
    if ( ![_myQRCode isEqual:image])
    {
        _myQRCode = image;
        [ivMyQRCode setImage:_myQRCode];
    }
    
    [tvRemind setHidden:NO];
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
