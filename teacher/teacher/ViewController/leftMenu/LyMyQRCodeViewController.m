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



//信息
#define viewInfoWidth                       SCREEN_WIDTH
CGFloat const mqrcViewInfoHeight = 80.0f;

CGFloat const mqrcIvAvatarX = 30.0f;
CGFloat const mqrcIvAvatarSize = 60.0f;


#define mqrcLbNameWidth                         (viewInfoWidth-mqrcIvAvatarX-mqrcIvAvatarSize-horizontalSpace*3)
CGFloat const mqrcLbNameHeight = 20.0f;

#define mqrcLbAddressWidth                      mqrcLbNameWidth
CGFloat const mqrcLbAddressHeight = 40.0f;


//二维码
CGFloat const ivQRCodeWidth = 200.0f;
CGFloat const ivQRCodeHeight = ivQRCodeWidth;


//提示
#define mqrcTvRemindWidth                       (SCREEN_WIDTH-horizontalSpace*2.0f)
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
    UILabel                 *lbAddress;
    
    UIView                  *viewQRCode;
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



- (void)viewDidAppear:(BOOL)animated {
    
    if ( ![[LyCurrentUser curUser].userId isEqualToString:currentUserId]) {
        if (!indicator_load) {
            indicator_load = [LyIndicator indicatorWithTitle:@"正在生成二维码..." allowCancel:NO];
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
    
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake( mqrcIvAvatarX, mqrcViewInfoHeight/2.0f-mqrcIvAvatarSize/2.0f, mqrcIvAvatarSize, mqrcIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [[ivAvatar layer] setCornerRadius:btnCornerRadius];
    [ivAvatar setClipsToBounds:YES];
    
    lbName = [[UILabel alloc] initWithFrame:CGRectMake( ivAvatar.frame.origin.x+CGRectGetWidth(ivAvatar.frame)+horizontalSpace, ivAvatar.ly_y, mqrcLbNameWidth, mqrcLbNameHeight)];
    [lbName setFont:LyFont(16)];
    [lbName setTextColor:[UIColor blackColor]];
    [lbName setTextAlignment:NSTextAlignmentLeft];
    
    
    lbAddress = [[UILabel alloc] initWithFrame:CGRectMake( lbName.frame.origin.x, lbName.ly_y+CGRectGetHeight(lbName.frame), mqrcLbAddressWidth, mqrcLbAddressHeight)];
    [lbAddress setFont:LyFont(14)];
    [lbAddress setTextColor:LyBlackColor];
    [lbAddress setTextAlignment:NSTextAlignmentLeft];
    [lbAddress setNumberOfLines:0];
    
    [viewInfo addSubview:ivAvatar];
    [viewInfo addSubview:lbName];
    [viewInfo addSubview:lbAddress];
    
    ivMyQRCode = [[UIImageView alloc] initWithFrame:CGRectMake( SCREEN_WIDTH/2.0f-ivQRCodeWidth/2.0f, viewInfo.ly_y+CGRectGetHeight(viewInfo.frame)+30.0f, ivQRCodeWidth, ivQRCodeHeight)];
    [ivMyQRCode setClipsToBounds:YES];
    [ivMyQRCode setImage:_myQRCode];
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
    [longPress setMinimumPressDuration:1.0f];
    
    [ivMyQRCode setUserInteractionEnabled:YES];
    [ivMyQRCode addGestureRecognizer:longPress];
    
    
    tvRemind = [[UITextView alloc] initWithFrame:CGRectMake( horizontalSpace, ivMyQRCode.ly_y+CGRectGetHeight(ivMyQRCode.frame)+20.0f, mqrcTvRemindWidth, mqrcTvRemindHeight)];
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

}



- (void)saveImage:(UILongPressGestureRecognizer *)longpress {
    if ( UIGestureRecognizerStateBegan == [longpress state]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否要保存当前二维码？"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"保存"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    [self saveQrCode];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (void)saveQrCode
{
    if ( !indicator_save) {
        indicator_save = [[LyIndicator alloc] initWithTitle:@"正在保存..."];
    }
    [indicator_save startAnimation];
    
    UIImageWriteToSavedPhotosAlbum(_myQRCode, self, @selector(saveImage:didFinishSaveWithError:contextInfo:), NULL);
}


- (void)saveImage:(UIImage *)image didFinishSaveWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [indicator_save stopAnimation];
    
    if ( !error) {
        [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"保存成功"] show];
    } else {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"保存失败"] show];
    }
}


- (void)refreshView {
    
    [lbName setText:[[LyCurrentUser curUser] userName]];
    
    if ( ![[LyCurrentUser curUser] userAvatar])
    {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:[LyCurrentUser curUser].userId]
                    placeholderImage:[LyUtil defaultAvatarForTeacher]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if (image) {
                                   [[LyCurrentUser curUser] setUserAvatar:image];
                               } else {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:[LyCurrentUser curUser].userId]
                                                       placeholderImage:[LyUtil defaultAvatarForTeacher]
                                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                  if (!image) {
                                                                      image = [LyUtil defaultAvatarForTeacher];
                                                                  }
                                                                  
                                                                  [[LyCurrentUser curUser] setUserAvatar:image];
                                                              }];
                               }
                           }];
    } else {
        [ivAvatar setImage:[[LyCurrentUser curUser] userAvatar]];
    }
    
    
    if (![LyUtil validateString:[LyCurrentUser curUser].userAddress]) {
        [lbAddress setText:@""];
    } else {
        CGFloat fHeight = [[LyCurrentUser curUser].userAddress boundingRectWithSize:CGSizeMake(CGRectGetWidth(lbAddress.frame), mqrcIvAvatarSize)
                                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                                             attributes:@{
                                                                                          NSFontAttributeName:lbAddress.font
                                                                                          }
                                                                                context:nil].size.height;
        
        if (fHeight > CGRectGetHeight(lbAddress.frame)) {
            [lbAddress setFrame:CGRectMake( lbName.frame.origin.x, lbName.ly_y+CGRectGetHeight(lbName.frame), mqrcLbAddressWidth, fHeight)];
        }
        [lbAddress setText:[LyCurrentUser curUser].userAddress];
    }
    
    [self makeQRCode];
    
    [indicator_load performSelector:@selector(stop) withObject:nil afterDelay:0.5f];
}





- (void)makeQRCode {
    
    UIImage *image = [UIImage imageForQRCodeFromUrl:[LyCurrentUser curUser].userId codeSize:280 red:255.0 green:90.0 blue:0.0 insertImage:[[LyCurrentUser curUser] userAvatar] cornerRadius:2.0f];
//    UIImage *image = [UIImage imageForQRCodeFromUrl:@"http://www.517xc.com" codeSize:2048 red:0 green:0 blue:0.0 insertImage:[UIImage imageNamed:@"icon_qrcode"] cornerRadius:2.0f];
    
    if ( !_myQRCode ) {
        _myQRCode = image;
        [ivMyQRCode setImage:_myQRCode];
    }

    NSData *data1 = UIImagePNGRepresentation(_myQRCode);
    NSData *data2 = UIImagePNGRepresentation(image);
    
    
    if (![data1 isEqual:data2]) {
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
