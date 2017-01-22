//
//  LyAuthPhotoViewController.m
//  teacher
//
//  Created by Junes on 16/7/25.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyAuthPhotoViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import "LyRemindView.h"

#import "LyCurrentUser.h"

#import "LyPhotoAsset.h"
#import "UIImage+Scale.h"

#import "LyUtil.h"

#import "LyAuthInfoViewController.h"




#define viewItemWidth                   SCREEN_WIDTH
#define viewItemHeight                  (apLbItemHeight+ivItemHeight+20.0f)


CGFloat const apLbItemWidth = 300.0f;
CGFloat const apLbItemHeight = 40.0f;
#define lbItemFont                      LyFont(16)


#define ivItemWidth                     (viewItemWidth*4/5.0f)
#define ivItemHeight                    (ivItemWidth*300.0f/477.0f)
CGFloat const apIvItemBorderWidth = 1.0f;


#define apLbRemindWidth                   (SCREEN_WIDTH-horizontalSpace*2)
CGFloat const apLbRemindHeight = 100.0f;

CGFloat const ivItemCornerRadius = 15.0f;


typedef NS_ENUM(NSInteger, AuthPhotoBarButtonItemMode)
{
    authPhotoBarButtonItemMode_close = 1,
    authPhotoBarButtonItemMode_next
};


typedef NS_ENUM(NSInteger, CertificationImageViewIndex)
{
    certificationImageViewIndex_first = 10,
    certificationImageViewIndex_second,
    certificationImageViewIndex_third
};


typedef NS_ENUM(NSInteger, AuthPhotoAlertViewMode)
{
    authPhotoAlertViewMode_camera = 20,
    authPhotoAlertViewMode_album
};



@interface LyAuthPhotoViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIBarButtonItem             *bbiNext;
    UIScrollView                *svMain;
    
    UIImageView                 *ivFirst;
    UIImageView                 *ivSecond;
    UIImageView                 *ivThird;
    
    UILabel                     *lbRemind;
    
    UIImage                     *defaultImage;
    CertificationImageViewIndex currentIndex;
}
@end

@implementation LyAuthPhotoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = LyLocalize(@"认证");
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    UIBarButtonItem *bbiClose = [[UIBarButtonItem alloc] initWithTitle:LyLocalize(@"返回")
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(targetForBarButtonItem:)];
    [bbiClose setTag:authPhotoBarButtonItemMode_close];
    
    bbiNext = [[UIBarButtonItem alloc] initWithTitle:LyLocalize(@"下一步") style:UIBarButtonItemStyleDone target:self action:@selector(targetForBarButtonItem:)];
    [bbiNext setTag:authPhotoBarButtonItemMode_next];

    [self.navigationItem setLeftBarButtonItem:bbiClose];
    [self.navigationItem setRightBarButtonItem:bbiNext];
    
    
    
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT)];
    [self.view addSubview:svMain];
    
    defaultImage = [LyUtil imageForImageName:@"authPhoto_defaultImage" needCache:NO];
    
    switch ([[LyCurrentUser curUser] userType]) {
        case LyUserType_normal: {
            //教练端，学员不可登录
            break;
        }
        case LyUserType_coach: {
            [self initAndLayoutSubviews_coach];
            break;
        }
        case LyUserType_school: {
            [self initAndLayoutSubviews_school];
            break;
        }
        case LyUserType_guider: {
            [self initAndLayoutSubviews_guider];
            break;
        }
    }
    
    [bbiNext setEnabled:NO];
}


- (void)viewDidAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


- (void)initAndLayoutSubviews_coach
{
    //照片-教练证
    UIView *viewCoachCertification = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewItemWidth, viewItemHeight)];
    //照片-教练证-标题
    NSMutableAttributedString *strLbCoachCertification = [[NSMutableAttributedString alloc] initWithString:@"教练证*"];
    [strLbCoachCertification addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[@"教练证*" rangeOfString:@"*"]];
    UILabel *lbCoachCertification = [[UILabel alloc] initWithFrame:CGRectMake(viewItemWidth/2.0f-apLbItemWidth/2.0f, 0, apLbItemWidth, apLbItemHeight)];
    [lbCoachCertification setFont:lbItemFont];
    [lbCoachCertification setTextColor:LyBlackColor];
    [lbCoachCertification setTextAlignment:NSTextAlignmentCenter];
    [lbCoachCertification setAttributedText:strLbCoachCertification];
    //照片-教练证-图
    UITapGestureRecognizer *tapGestureFirst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForTapGestureFromFirstImageView:)];
    [tapGestureFirst setNumberOfTapsRequired:1];
    [tapGestureFirst setNumberOfTouchesRequired:1];
    ivFirst = [[UIImageView alloc] initWithFrame:CGRectMake(viewItemWidth/2.0f-ivItemWidth/2.0f, lbCoachCertification.ly_y+apLbItemHeight+verticalSpace, ivItemWidth, ivItemHeight)];
    [ivFirst setContentMode:UIViewContentModeScaleAspectFill];
    [[ivFirst layer] setCornerRadius:ivItemCornerRadius];
    [ivFirst.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [ivFirst.layer setBorderWidth:apIvItemBorderWidth];
    [ivFirst setClipsToBounds:YES];
    [ivFirst setUserInteractionEnabled:YES];
    [ivFirst addGestureRecognizer:tapGestureFirst];
    [ivFirst setImage:defaultImage];
    
    [viewCoachCertification addSubview:lbCoachCertification];
    [viewCoachCertification addSubview:ivFirst];
    
    
    //照片-驾驶证
    UIView *viewDriveLicense = [[UIView alloc] initWithFrame:CGRectMake(0, viewCoachCertification.ly_y+CGRectGetHeight(viewCoachCertification.frame), viewItemWidth, viewItemHeight)];
    //照片-驾驶证-标题
    UILabel *lbDriveLicense = [[UILabel alloc] initWithFrame:CGRectMake(viewItemWidth/2.0f-apLbItemWidth/2.0f, 0, apLbItemWidth, apLbItemHeight)];
    [lbDriveLicense setFont:lbItemFont];
    [lbDriveLicense setTextColor:LyBlackColor];
    [lbDriveLicense setTextAlignment:NSTextAlignmentCenter];
    [lbDriveLicense setText:@"驾驶证"];
    //照片-驾驶证-图
    UITapGestureRecognizer *tapGestureSecond = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForTapGestureFromSecondImageView:)];
    [tapGestureSecond setNumberOfTapsRequired:1];
    [tapGestureSecond setNumberOfTouchesRequired:1];
    ivSecond = [[UIImageView alloc] initWithFrame:CGRectMake(viewItemWidth/2.0f-ivItemWidth/2.0f, lbDriveLicense.ly_y+apLbItemHeight, ivItemWidth, ivItemHeight)];
    [ivSecond setContentMode:UIViewContentModeScaleAspectFill];
    [[ivSecond layer] setCornerRadius:ivItemCornerRadius];
    [ivSecond.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [ivSecond.layer setBorderWidth:apIvItemBorderWidth];
    [ivSecond setClipsToBounds:YES];
    [ivSecond setUserInteractionEnabled:YES];
    [ivSecond addGestureRecognizer:tapGestureSecond];
//    [ivSecond setImage:[LyUtil imageForImageName:@"authPhoto_defaultImage" needCache:NO]];
    [ivSecond setImage:defaultImage];
    
    [viewDriveLicense addSubview:lbDriveLicense];
    [viewDriveLicense addSubview:ivSecond];
    
    //照片-身份证
    UIView *viewIdentity = [[UIView alloc] initWithFrame:CGRectMake(0, viewDriveLicense.ly_y+CGRectGetHeight(viewDriveLicense.frame), viewItemWidth, viewItemHeight)];
    //照片-身份证-标题
    UILabel *lbIdentity = [[UILabel alloc] initWithFrame:CGRectMake(viewItemWidth/2.0f-apLbItemWidth/2.0f, 0, apLbItemWidth, apLbItemHeight)];
    [lbIdentity setFont:lbItemFont];
    [lbIdentity setTextColor:LyBlackColor];
    [lbIdentity setTextAlignment:NSTextAlignmentCenter];
    [lbIdentity setText:@"身份证"];
    //照片-身份证-图
    UITapGestureRecognizer *tapGestureThird = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForTapGestureFromThirdImageView:)];
    [tapGestureThird setNumberOfTapsRequired:1];
    [tapGestureThird setNumberOfTouchesRequired:1];
    ivThird = [[UIImageView alloc] initWithFrame:CGRectMake(viewItemWidth/2.0f-ivItemWidth/2.0f, lbIdentity.ly_y+apLbItemHeight, ivItemWidth, ivItemHeight)];
    [ivThird setContentMode:UIViewContentModeScaleAspectFill];
    [[ivThird layer] setCornerRadius:ivItemCornerRadius];
    [ivThird.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [ivThird.layer setBorderWidth:apIvItemBorderWidth];
    [ivThird setClipsToBounds:YES];
    [ivThird setUserInteractionEnabled:YES];
    [ivThird addGestureRecognizer:tapGestureThird];
//    [ivThird setImage:[LyUtil imageForImageName:@"authPhoto_defaultImage" needCache:NO]];
    [ivThird setImage:defaultImage];
    
    [viewIdentity addSubview:lbIdentity];
    [viewIdentity addSubview:ivThird];
    
    
    lbRemind = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f-apLbRemindWidth/2.0f, viewIdentity.ly_y+CGRectGetHeight(viewIdentity.frame), apLbRemindWidth, apLbRemindHeight)];
    [lbRemind setFont:LyFont(12)];
    [lbRemind setNumberOfLines:0];
    [lbRemind setTextColor:Ly517ThemeColor];
    [lbRemind setAttributedText:[[NSMutableAttributedString alloc] initWithString:@"要求：\n\t1、必须为本人证件，否则认证失败；\n\t2、证件须在有效期内，否则认证失败；\n\t3、驾龄必须在5年以上；\n\t4、证件照片要清晰，照片格式为png、jpg、jpeg，大小5M以内。"
                                                                       attributes:@{NSParagraphStyleAttributeName:({
        NSMutableParagraphStyle *style =  [[NSMutableParagraphStyle alloc] init];
        style.headIndent = [@"要求：" sizeWithAttributes:@{NSFontAttributeName:LyFont(12)}].width;          //行首缩进
        style;
    })}]];
    
    
    
    [svMain addSubview:viewCoachCertification];
    [svMain addSubview:viewDriveLicense];
    [svMain addSubview:viewIdentity];
    [svMain addSubview:lbRemind];
    
    CGFloat fCZHeight = lbRemind.ly_y + CGRectGetHeight(lbRemind.frame) + 50.0f;
    if (fCZHeight <= CGRectGetHeight(svMain.frame)) {
        fCZHeight = CGRectGetHeight(svMain.frame) * 1.05f;
    }
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, fCZHeight)];
}


- (void)initAndLayoutSubviews_school
{
    //照片-营业执照
    UIView *viewBusinessLicense = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewItemWidth, viewItemHeight)];
    //照片-营业执照-标题
    UILabel *lbBusinessLicense = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, apLbItemWidth, apLbItemHeight)];
    [lbBusinessLicense setFont:lbItemFont];
    [lbBusinessLicense setTextColor:LyBlackColor];
    [lbBusinessLicense setTextAlignment:NSTextAlignmentCenter];
    [lbBusinessLicense setAttributedText:({
        NSMutableAttributedString *strLbDriveLicense = [[NSMutableAttributedString alloc] initWithString:@"营业执照*"];
        [strLbDriveLicense addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[@"营业执照*" rangeOfString:@"*"]];
        strLbDriveLicense;})];
    //照片-营业执照-图
    UITapGestureRecognizer *tapGestureFirst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForTapGestureFromFirstImageView:)];
    [tapGestureFirst setNumberOfTapsRequired:1];
    [tapGestureFirst setNumberOfTouchesRequired:1];
    ivFirst = [[UIImageView alloc] initWithFrame:CGRectMake(viewItemWidth/2.0f-ivItemWidth/2.0f, lbBusinessLicense.ly_y+apLbItemHeight, ivItemWidth, ivItemHeight)];
    [ivFirst setContentMode:UIViewContentModeScaleAspectFill];
    [[ivFirst layer] setCornerRadius:ivItemCornerRadius];
    [ivFirst.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [ivFirst.layer setBorderWidth:apIvItemBorderWidth];
    [ivFirst setClipsToBounds:YES];
    [ivFirst setUserInteractionEnabled:YES];
    [ivFirst addGestureRecognizer:tapGestureFirst];
//    [ivFirst setImage:[LyUtil imageForImageName:@"authPhoto_defaultImage" needCache:NO]];
    [ivFirst setImage:defaultImage];
    
    [viewBusinessLicense addSubview:lbBusinessLicense];
    [viewBusinessLicense addSubview:ivFirst];
    
    
    lbRemind = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f-apLbRemindWidth/2.0f, viewBusinessLicense.ly_y+CGRectGetHeight(viewBusinessLicense.frame), apLbRemindWidth, apLbRemindHeight)];
    [lbRemind setFont:LyFont(12)];
    [lbRemind setNumberOfLines:0];
    [lbRemind setTextColor:Ly517ThemeColor];
    [lbRemind setAttributedText:[[NSMutableAttributedString alloc] initWithString:@"要求：\n\t1、必须为的已注册的营业执照，否则认证失败；\n\t2、营业执照须在有效期内，否则认证失败；\n\t3、证件照片要清晰，照片格式为png、jpg、jpeg，大小5M以内。"
                                                                       attributes:@{NSParagraphStyleAttributeName:({
        NSMutableParagraphStyle *style =  [[NSMutableParagraphStyle alloc] init];
        style.headIndent = [@"要求：" sizeWithAttributes:@{NSFontAttributeName:LyFont(12)}].width;          //行首缩进
        style;
    })}]];
    
    
    [svMain addSubview:viewBusinessLicense];
    [svMain addSubview:lbRemind];
    
    CGFloat fCZHeight = lbRemind.ly_y + CGRectGetHeight(lbRemind.frame) + 50.0f;
    if (fCZHeight <= CGRectGetHeight(svMain.frame)) {
        fCZHeight = CGRectGetHeight(svMain.frame) * 1.05f;
    }
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, fCZHeight)];
}


- (void)initAndLayoutSubviews_guider
{
    //照片-驾驶证
    UIView *viewDriveLicense = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewItemWidth, viewItemHeight)];
    //照片-驾驶证-标题
    
    UILabel *lbDriveLicense = [[UILabel alloc] initWithFrame:CGRectMake(viewItemWidth/2.0f-apLbItemWidth/2.0f, 0, apLbItemWidth, apLbItemHeight)];
    [lbDriveLicense setFont:lbItemFont];
    [lbDriveLicense setTextColor:LyBlackColor];
    [lbDriveLicense setTextAlignment:NSTextAlignmentCenter];
    [lbDriveLicense setAttributedText:({
        NSMutableAttributedString *strLbDriveLicense = [[NSMutableAttributedString alloc] initWithString:@"驾驶证*"];
        [strLbDriveLicense addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[@"驾驶证*" rangeOfString:@"*"]];
        strLbDriveLicense;
    })];
    //照片-驾驶证-图
    UITapGestureRecognizer *tapGestureFirst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForTapGestureFromFirstImageView:)];
    [tapGestureFirst setNumberOfTapsRequired:1];
    [tapGestureFirst setNumberOfTouchesRequired:1];
    ivFirst = [[UIImageView alloc] initWithFrame:CGRectMake(viewItemWidth/2.0f-ivItemWidth/2.0f, lbDriveLicense.ly_y+apLbItemHeight, ivItemWidth, ivItemHeight)];
    [ivFirst setContentMode:UIViewContentModeScaleAspectFill];
    [[ivFirst layer] setCornerRadius:ivItemCornerRadius];
    [ivFirst.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [ivFirst.layer setBorderWidth:apIvItemBorderWidth];
    [ivFirst setClipsToBounds:YES];
    [ivFirst setUserInteractionEnabled:YES];
    [ivFirst addGestureRecognizer:tapGestureFirst];
//    [ivFirst setImage:[LyUtil imageForImageName:@"authPhoto_defaultImage" needCache:NO]];
    [ivFirst setImage:defaultImage];
    
    [viewDriveLicense addSubview:lbDriveLicense];
    [viewDriveLicense addSubview:ivFirst];
    
    //照片-身份证
    UIView *viewIdentity = [[UIView alloc] initWithFrame:CGRectMake(0, viewDriveLicense.ly_y+CGRectGetHeight(viewDriveLicense.frame), viewItemWidth, viewItemHeight)];
    //照片-身份证-标题
    NSMutableAttributedString *strLbIdentity = [[NSMutableAttributedString alloc] initWithString:@"身份证*"];
    [strLbIdentity addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[@"身份证*" rangeOfString:@"*"]];
    UILabel *lbIdentity = [[UILabel alloc] initWithFrame:CGRectMake(viewItemWidth/2.0f-apLbItemWidth/2.0f, 0, apLbItemWidth, apLbItemHeight)];
    [lbIdentity setFont:lbItemFont];
    [lbIdentity setTextColor:LyBlackColor];
    [lbIdentity setTextAlignment:NSTextAlignmentCenter];
    [lbIdentity setAttributedText:strLbIdentity];
    //照片-身份证-图
    UITapGestureRecognizer *tapGestureSecond = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForTapGestureFromSecondImageView:)];
    [tapGestureSecond setNumberOfTapsRequired:1];
    [tapGestureSecond setNumberOfTouchesRequired:1];
    ivSecond = [[UIImageView alloc] initWithFrame:CGRectMake(viewItemWidth/2.0f-ivItemWidth/2.0f, lbIdentity.ly_y+apLbItemHeight, ivItemWidth, ivItemHeight)];
    [ivSecond setContentMode:UIViewContentModeScaleAspectFill];
    [[ivSecond layer] setCornerRadius:ivItemCornerRadius];
    [ivSecond.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [ivSecond.layer setBorderWidth:apIvItemBorderWidth];
    [ivSecond setClipsToBounds:YES];
    [ivSecond setUserInteractionEnabled:YES];
    [ivSecond addGestureRecognizer:tapGestureSecond];
//    [ivSecond setImage:[LyUtil imageForImageName:@"authPhoto_defaultImage" needCache:NO]];
    [ivSecond setImage:defaultImage];
    
    [viewIdentity addSubview:lbIdentity];
    [viewIdentity addSubview:ivSecond];
    
    
    
   
    lbRemind = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f-apLbRemindWidth/2.0f, viewIdentity.ly_y+CGRectGetHeight(viewIdentity.frame), apLbRemindWidth, apLbRemindHeight)];
    [lbRemind setFont:LyFont(12)];
    [lbRemind setNumberOfLines:0];
    [lbRemind setTextColor:Ly517ThemeColor];
    [lbRemind setAttributedText:[[NSMutableAttributedString alloc] initWithString:@"要求：\n\t1、必须为本人证件，否则认证失败；\n\t2、证件须在有效期内，否则认证失败；\n\t3、驾龄必须在5年以上；\n\t4、证件照片要清晰，照片格式为png、jpg、jpeg，大小5M以内。"
                                                                       attributes:@{NSParagraphStyleAttributeName:({
        NSMutableParagraphStyle *style =  [[NSMutableParagraphStyle alloc] init];
        style.headIndent = [@"要求：" sizeWithAttributes:@{NSFontAttributeName:LyFont(12)}].width;          //行首缩进
        style;
    })}]];
    
    
    
    [svMain addSubview:viewDriveLicense];
    [svMain addSubview:viewIdentity];
    [svMain addSubview:lbRemind];
    
    CGFloat fCZHeight = lbRemind.ly_y + CGRectGetHeight(lbRemind.frame) + 50.0f;
    if (fCZHeight <= CGRectGetHeight(svMain.frame)) {
        fCZHeight = CGRectGetHeight(svMain.frame) * 1.05f;
    }
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, fCZHeight)];
}


- (BOOL)validate:(BOOL)flag {
    [bbiNext setEnabled:NO];
    
    switch ([LyCurrentUser curUser].userType) {
        case LyUserType_normal: {
            //nothing
            break;
        }
        case LyUserType_coach: {
            if (!_paCoachLicense) {
                if (flag) {
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"还没有选择教练证"] show];
                }
                return NO;
            }
            break;
        }
        case LyUserType_school: {
            if (!_paBusinessLicense) {
                if (flag) {
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"还没有选择营业执照"] show];
                }
                return NO;
            }
            
            break;
        }
        case LyUserType_guider: {
            if (!_paDriveLicense) {
                if (flag) {
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"还没有选择驾驶证"] show];
                }
                return NO;
            }
            
            if (!_paIdentity) {
                if (flag) {
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"还没有选择身份证"] show];
                }
                return NO;
            }
            
            break;
        }
    }
    
    [bbiNext setEnabled:YES];
    return YES;
}




- (void)showImagePickerForCamera {
    //相机
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ( AVAuthorizationStatusRestricted == authStatus || AVAuthorizationStatusDenied == authStatus) {
        //无权限
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitleForCamera
                                                                       message:alertMessageForCamera
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
                                                        [LyUtil showAlert:LyAlertViewForAuthorityMode_camera vc:self];
                                                    }
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    [imagePicker setEditing:YES];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)showImagePickerForAlbum {
    //相册
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
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    [imagePicker setEditing:YES];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self presentViewController:imagePicker animated:YES completion:nil];
}



- (void)showActionForImagePicker {
    
    UIAlertController *action = [UIAlertController alertControllerWithTitle:nil
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    [action addAction:[UIAlertAction actionWithTitle:@"取消"
                                               style:UIAlertActionStyleCancel
                                             handler:nil]];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [action addAction:[UIAlertAction actionWithTitle:@"拍照"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     [self showImagePickerForCamera];
                                                 }]];
    }
    
    [action addAction:[UIAlertAction actionWithTitle:@"从相册选择"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * _Nonnull action) {
                                                 [self showImagePickerForAlbum];
                                             }]];
    
    [self presentViewController:action animated:YES completion:nil];
}



- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi
{
    if (authPhotoBarButtonItemMode_close == bbi.tag) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if (authPhotoBarButtonItemMode_next == bbi.tag) {
        
        if (![self validate:YES]) {
            return;
        }
        
        LyAuthInfoViewController *authInfo = [[LyAuthInfoViewController alloc] init];
        [authInfo setPhotoSource:self];
        [self.navigationController pushViewController:authInfo animated:YES];
    }
}


- (void)targetForTapGestureFromFirstImageView:(UITapGestureRecognizer *)tagGesture
{
    currentIndex = certificationImageViewIndex_first;
    
    [self showActionForImagePicker];
}


- (void)targetForTapGestureFromSecondImageView:(UITapGestureRecognizer *)tagGesture
{
    currentIndex = certificationImageViewIndex_second;
    
    [self showActionForImagePicker];
}


- (void)targetForTapGestureFromThirdImageView:(UITapGestureRecognizer *)tagGesture
{
    currentIndex = certificationImageViewIndex_third;
    
    [self showActionForImagePicker];
}



#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        image = [UIImage fixOrientation:image];
        
        switch (currentIndex) {
            case certificationImageViewIndex_first: {
                [ivFirst setImage:image];
                
                switch ([LyCurrentUser curUser].userType) {
                    case LyUserType_normal: {
                        //nothing
                        break;
                    }
                    case LyUserType_coach: {
                        _paCoachLicense = [LyPhotoAsset assetWithImage:image];
                        break;
                    }
                    case LyUserType_school: {
//                        _imgBusinessLicense = image;
                        _paBusinessLicense = [LyPhotoAsset assetWithImage:image];
                        break;
                    }
                    case LyUserType_guider: {
                        _paDriveLicense = [LyPhotoAsset assetWithImage:image];
                        break;
                    }
                }
                break;
            }
            case certificationImageViewIndex_second: {
                [ivSecond setImage:image];
                
                switch ([LyCurrentUser curUser].userType) {
                    case LyUserType_normal:{
                        //nothing
                        break;
                    }
                    case LyUserType_coach: {
                        _paDriveLicense = [LyPhotoAsset assetWithImage:image];
                        break;
                    }
                    case LyUserType_school: {
                        //nothing
                        break;
                    }
                    case LyUserType_guider: {
                        _paIdentity = [LyPhotoAsset assetWithImage:image];
                        break;
                    }
                }
                break;
            }
            case certificationImageViewIndex_third: {
                [ivThird setImage:image];
                
                switch ([LyCurrentUser curUser].userType) {
                    case LyUserType_normal:{
                        //nothing
                        break;
                    }
                    case LyUserType_coach: {
                        _paIdentity = [LyPhotoAsset assetWithImage:image];
                        break;
                    }
                    case LyUserType_school: {
                        //nothing
                        break;
                    }
                    case LyUserType_guider: {
                        //nothing
                        break;
                    }
                }
                break;
            }
        }
        
        [self validate:NO];
    }];
    
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
