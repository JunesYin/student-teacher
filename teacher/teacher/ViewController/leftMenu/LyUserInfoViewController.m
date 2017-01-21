//
//  LyUserInfoViewController.m
//  teacher
//
//  Created by Junes on 16/8/9.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyUserInfoViewController.h"
#import "LyUserInfoTableViewCell.h"

#import "LyIndicator.h"
#import "LyRemindView.h"
#import "LyDatePicker.h"
#import "LyAddressAlertView.h"
#import "LySignatureAlertView.h"
#import "LyDriveLicensePicker.h"

#import "LyUserManager.h"
#import "LyCurrentUser.h"
#import "LyTrainBase.h"

#import "NSString+Validate.h"


#import "LyUtil.h"


#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import "VPImageCropperViewController.h"
#import "LyModifyNameViewController.h"
#import "LyChooseSchoolTableViewController.h"
#import "LyChooseTrainBaseTableViewController.h"
#import "LyModifyPhoneViewController.h"
#import "LyModifySignatureViewController.h"
#import "LyMyQRCodeViewController.h"





CGFloat const uiViewInfoHeight = 200.0f;
CGFloat const uiIvAvatarSize = 70.0f;

CGFloat const uiTfNameHeight = 30.0f;
#define tfNameFont                          LyFont(16)
CGFloat const uiBtnModifySize = 20.0f;






typedef NS_ENUM(NSInteger, LyUserInfoTextfieldMode)
{
    userInfoTextfieldMode_name = 1,
};


typedef NS_ENUM(NSInteger, LyUserInfoDatePickerMode)
{
    userInfoDatePickerMode_age = 30,
    userInfoDatePickerMode_drivedAge,
    userInfoDatePickerMode_teachedAge
};


typedef NS_ENUM(NSInteger, LyUserInfoSignatureAlertViewMode)
{
    userInfoSignatureAlertViewMode_signature = 0,
    userInfoSignatureAlertViewMode_schoolTrueName
};


typedef NS_ENUM( NSInteger, LyUserInfoHttpMethod)
{
    userInfoHttpMethod_load = 100,
    userInfoHttpMethod_avatar,
    userInfoHttpMethod_nickName,
    userInfoHttpMethod_sex,
    userInfoHttpMethod_birthday,
    userInfoHttpMethod_phoneNumber,
    userInfoHttpMethod_driveBirthday,
    userInfoHttpMethod_teachBirthday,
    userInfoHttpMethod_signature,
    userInfoHttpMethod_address,
    userInfoHttpMethod_schoolTrueName,
    userInfoHttpMethod_school,
    userInfoHttpMethod_trainBase,
    userInfoHttpMethod_driveLicense
};







@interface LyUserInfoViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource,VPImageCropperDelegate, LyHttpRequestDelegate, LyDatePickerDelegate, LyAddressAlertViewDelegate, LyHttpRequestDelegate, LyChooseSchoolTableViewControllerDelegate, LyChooseTrainBaseTableViewControllerDelegate, LyDriveLicensePickerDelegate, LyModifyNameViewControllerDelegate, LyModifySignatureViewControllerDelegate>
{
    UIView                  *viewInfo;
    UIImageView             *ivAvatar;
    
    UIView                  *viewError;
    
    UIImage                 *nextAvatar;
    LyDriveSchool           *nextSchool;
    LyTrainBase             *nextTrainBase;
    
    
    BOOL                    isTrueName;
    
    
    LyIndicator             *indicator;
    LyIndicator             *indicator_modify;
    BOOL                    bHttpFlag;
    LyUserInfoHttpMethod    curHttpMethod;
}

@property (strong, nonatomic)       UITextField             *tfName;
@property (strong, nonatomic)       UIButton                *btnModify;
@property (strong, nonatomic)       UITableView             *tableView;
@property (strong, nonatomic)       UIRefreshControl        *refreshControl;

@end

@implementation LyUserInfoViewController

static NSString *const lyUserInfoTvInfoCellReuseIdentifier = @"lyUserInfoTvInfoCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[LyUtil imageForImageName:@"uci_navigatinBar" needCache:NO] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController navigationBar].shadowImage = [LyUtil imageForImageName:@"uci_navigatinBar" needCache:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    //    // 保存 Device 的现语言 (英语 法语 ，，，)
    //    userDefaultLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    //
    //    // 强制 成 简体中文
    //    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans", nil] forKey:@"AppleLanguages"];
    
    [self setName:[LyCurrentUser curUser].userName];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![LyUtil flagForGetUserInfo]) {
        [self load:NO];
    } else {
        [self reloadData];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController navigationBar].shadowImage = nil;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


- (void)initAndLayoutSubviews
{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    //头像视图
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, uiViewInfoHeight)];
    UIImageView *ivBack = [[UIImageView alloc] initWithFrame:viewInfo.bounds];
    [ivBack setContentMode:UIViewContentModeScaleToFill];
    [ivBack setImage:[LyUtil imageForImageName:@"viewInfo_background_t" needCache:NO]];
    //头像视图-头像
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f-uiIvAvatarSize/2.0f, uiViewInfoHeight/2.0f-(uiIvAvatarSize+20+uiTfNameHeight)/2.0f+20.0f, uiIvAvatarSize, uiIvAvatarSize)];
    [ivAvatar setClipsToBounds:YES];
    [ivAvatar setImage:[LyCurrentUser curUser].userAvatar];
    [[ivAvatar layer] setCornerRadius:btnCornerRadius];
    //头像视图-姓名
    //头像视图-姓名按钮
//    [self changeFrameForTfNameAndBtnModifyName];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForAvatarTapGesture:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [ivAvatar setUserInteractionEnabled:YES];
    [ivAvatar addGestureRecognizer:tap];
    
    [viewInfo addSubview:ivBack];
    [viewInfo addSubview:ivAvatar];
    [viewInfo addSubview:self.tfName];
    
    [self.view addSubview:viewInfo];
    [self.view addSubview:self.tableView];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, viewInfo.ly_y+CGRectGetHeight(viewInfo.frame), SCREEN_WIDTH, SCREEN_HEIGHT-uiViewInfoHeight)
                                              style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView registerClass:[LyUserInfoTableViewCell class] forCellReuseIdentifier:lyUserInfoTvInfoCellReuseIdentifier];
        [_tableView setSectionHeaderHeight:0];
        [_tableView setSectionFooterHeight:verticalSpace*2];
        
        [_tableView addSubview:self.refreshControl];
    }
    
    return _tableView;
}

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [LyUtil refreshControlWithTitle:nil
                                                   target:self
                                                   action:@selector(refresh:)];
    }
    
    return _refreshControl;
}


- (UITextField *)tfName {
    if (!_tfName) {
        _tfName = [[UITextField alloc] initWithFrame:CGRectMake(0, ivAvatar.ly_y + uiIvAvatarSize + 20.0f, SCREEN_WIDTH, uiTfNameHeight)];
        [_tfName setDelegate:self];
        [_tfName setTextColor:[UIColor whiteColor]];
        [_tfName setFont:tfNameFont];
        [_tfName setBackgroundColor:[UIColor clearColor]];
        [_tfName setTextAlignment:NSTextAlignmentCenter];
        
        [_tfName setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, uiBtnModifySize, uiBtnModifySize)]];
        [_tfName setRightView:self.btnModify];
        [_tfName setLeftViewMode:UITextFieldViewModeAlways];
        [_tfName setRightViewMode:UITextFieldViewModeAlways];
    }
    
    return _tfName;
}

- (UIButton *)btnModify {
    if (!_btnModify) {
        _btnModify = [[UIButton alloc] initWithFrame:CGRectMake(0, uiTfNameHeight/2.0f - uiBtnModifySize / 2.0f, uiBtnModifySize, uiBtnModifySize)];
        [_btnModify setBackgroundImage:[LyUtil imageForImageName:@"ui_btn_pen" needCache:NO] forState:UIControlStateNormal];
        [_btnModify addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btnModify;
}


- (void)reloadData {
    
    [self removeViewError];
    [LyUtil setFinishGetUserIfo:YES];
    
    if ( ![[LyCurrentUser curUser] userAvatar]) {
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
    
    
    [self.tableView reloadData];
    
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


- (void)showModifyNameVC {
    LyModifyNameViewController *modifyNameVC = [[LyModifyNameViewController alloc] init];
    [modifyNameVC setMode:isTrueName ? LyModifyNameControllerMode_trueName : LyModifyNameControllerMode_name];
    [modifyNameVC setDelegate:self];
    [self.navigationController pushViewController:modifyNameVC animated:YES];
}


- (void)showActionForSex {
    UIAlertController *action = [UIAlertController alertControllerWithTitle:@"请选择你的性别"
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    [action addAction:[UIAlertAction actionWithTitle:@"取消"
                                               style:UIAlertActionStyleCancel
                                             handler:nil]];
    [action addAction:[UIAlertAction actionWithTitle:@"男"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * _Nonnull action) {
                                                 [self modifyUserInfo:userInfoHttpMethod_sex extParameter:@(LySexMale)];
                                             }]];
    [action addAction:[UIAlertAction actionWithTitle:@"女"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * _Nonnull action) {
                                                 [self modifyUserInfo:userInfoHttpMethod_sex extParameter:@(LySexFemale)];
                                             }]];
    [self presentViewController:action animated:YES completion:nil];
}


- (void)showDatePickerWithTag:(LyUserInfoDatePickerMode)tag {
    
    LyDatePicker *datePicker = [[LyDatePicker alloc] init];
    [datePicker setTag:tag];
    [datePicker setDateWithString:({
        NSString *strDate = @"";
        switch (tag) {
            case userInfoDatePickerMode_age:{
                strDate = [LyCurrentUser curUser].userBirthday;
                break;
            }
            case userInfoDatePickerMode_drivedAge: {
                strDate = [LyCurrentUser curUser].userDriveBirthday;
                break;
            }
            case userInfoDatePickerMode_teachedAge: {
                strDate = [LyCurrentUser curUser].userTeachBirthday;
                break;
            }
        }
        strDate;
    })];
    [datePicker setDelegate:self];
    [datePicker show];
}


- (void)showModifyPhoneVC {
    LyModifyPhoneViewController *modifyPhone = [[LyModifyPhoneViewController alloc] init];
    [self.navigationController pushViewController:modifyPhone animated:YES];
}


- (void)showAddressPicker {
    LyAddressAlertView *addressAlert = [LyAddressAlertView addressAlertViewWithAddress:[LyCurrentUser curUser].userAddress];
    [addressAlert setDelegate:self];
    [addressAlert show];
}

- (void)showModifySignatureVC {
    LyModifySignatureViewController *modifySignatureVC = [[LyModifySignatureViewController alloc] init];
    [modifySignatureVC setDelegate:self];
    [self.navigationController pushViewController:modifySignatureVC animated:YES];
}

- (void)showMyQRCodeVC {
    LyMyQRCodeViewController *myQRCode = [[LyMyQRCodeViewController alloc] init];
    [self.navigationController pushViewController:myQRCode animated:YES];
}


- (void)showViewError {
    if (!viewError) {
        viewError = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.contentSize.height * 1.1f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewError addSubview:[LyUtil lbErrorWithMode:0]];
    }
    
    [self.tableView addSubview:viewError];
}

- (void)removeViewError {
    [viewError removeFromSuperview];
    viewError = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setName:(NSString *)name {
    CGFloat fWidth = [name sizeWithAttributes:@{NSFontAttributeName : self.tfName.font}].width + uiBtnModifySize * 2;
    [self.tfName setFrame:CGRectMake(SCREEN_WIDTH/2.0f - fWidth/2.0f, self.tfName.ly_y, fWidth, CGRectGetHeight(self.tfName.frame))];
    [self.tfName setText:name];
}



- (void)targetForAvatarTapGesture:(UIGestureRecognizer *)gesture {
    
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

- (void)refresh:(UIRefreshControl *)rc {
    [self load:YES];
}


- (void)targetForButton:(UIButton *)button {
    isTrueName = NO;
    [self showModifyNameVC];
}


- (void)showIndicatorModify {
    if ( !indicator_modify) {
        indicator_modify = [[LyIndicator alloc] initWithTitle:@"正在修改..."];
    }
    [indicator_modify startAnimation];
}



- (void)hideIndicatorModeify:(BOOL)flag
{
    [indicator_modify stopAnimation];
    
    if ( flag) {
        [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"修改成功"] show];
    } else {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"修改失败"] show];
    }
}




- (void)reloadTvInfoItemWithMode:(LyUserInfoHttpMethod)hm {
    
    switch (hm) {
        case userInfoHttpMethod_load: {
            break;
        }
        case userInfoHttpMethod_avatar: {
            
            break;
        }
        case userInfoHttpMethod_nickName: {
            [self setName:[LyCurrentUser curUser].userName];
            break;
        }
        case userInfoHttpMethod_sex: {
            switch ([LyCurrentUser curUser].userType) {
                case LyUserType_normal: {
                    break;
                }
                case LyUserType_coach: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
                case LyUserType_school: {
                    break;
                }
                case LyUserType_guider: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
            }
            break;
        }
        case userInfoHttpMethod_birthday: {
            switch ([LyCurrentUser curUser].userType) {
                case LyUserType_normal: {
                    break;
                }
                case LyUserType_coach: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
                case LyUserType_school: {
                    break;
                }
                case LyUserType_guider: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
            }
            break;
        }
        case userInfoHttpMethod_phoneNumber: {
            switch ([LyCurrentUser curUser].userType) {
                case LyUserType_normal: {
                    break;
                }
                case LyUserType_coach: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
                case LyUserType_school: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
                case LyUserType_guider: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
            }
            break;
        }
        case userInfoHttpMethod_driveBirthday: {
            switch ([LyCurrentUser curUser].userType) {
                case LyUserType_normal: {
                    break;
                }
                case LyUserType_coach: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
                case LyUserType_school: {
                    break;
                }
                case LyUserType_guider: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
            }
            break;
        }
        case userInfoHttpMethod_teachBirthday: {
            switch ([LyCurrentUser curUser].userType) {
                case LyUserType_normal: {
                    break;
                }
                case LyUserType_coach: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
                case LyUserType_school: {
                    break;
                }
                case LyUserType_guider: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
            }
            break;
        }
        case userInfoHttpMethod_signature: {
            switch ([LyCurrentUser curUser].userType) {
                case LyUserType_normal: {
                    break;
                }
                case LyUserType_coach: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
                case LyUserType_school: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
                case LyUserType_guider: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
            }
            break;
        }
        case userInfoHttpMethod_address: {
            switch ([LyCurrentUser curUser].userType) {
                case LyUserType_normal: {
                    break;
                }
                case LyUserType_coach: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
                case LyUserType_school: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
                case LyUserType_guider: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
            }
            break;
        }
        case userInfoHttpMethod_schoolTrueName: {
            switch ([LyCurrentUser curUser].userType) {
                case LyUserType_normal: {
                    break;
                }
                case LyUserType_coach: {
                    break;
                }
                case LyUserType_school: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
                case LyUserType_guider: {
                    break;
                }
            }
            break;
        }
        case userInfoHttpMethod_school: {
            switch ([LyCurrentUser curUser].userType) {
                case LyUserType_normal: {
                    break;
                }
                case LyUserType_coach: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
                case LyUserType_school: {
                    break;
                }
                case LyUserType_guider: {
                    break;
                }
            }
            break;
        }
        case userInfoHttpMethod_trainBase: {
            switch ([LyCurrentUser curUser].userType) {
                case LyUserType_normal: {
                    break;
                }
                case LyUserType_coach: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
                case LyUserType_school: {
                    break;
                }
                case LyUserType_guider: {
                    break;
                }
            }
            break;
        }
        case userInfoHttpMethod_driveLicense: {
            switch ([LyCurrentUser curUser].userType) {
                case LyUserType_normal: {
                    //nothing
                    break;
                }
                case LyUserType_coach: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:2]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
                case LyUserType_school: {
                    //nothing
                    break;
                }
                case LyUserType_guider: {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
            }
        }
    }
}



- (void)load:(BOOL)isRefresh {
    
    if (isRefresh || ![LyUtil flagForGetUserInfo]) {
        
        if ( !indicator) {
            indicator = [[LyIndicator alloc] initWithTitle:nil];
        }
        [indicator startAnimation];
        
        LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:userInfoHttpMethod_load];
        [httpRequest setDelegate:self];
        bHttpFlag = [[httpRequest startHttpRequest:userInfo_url
                                              body:@{
                                                     userIdKey:[LyCurrentUser curUser].userId,
                                                     sessionIdKey:[LyUtil httpSessionId],
                                                     userTypeKey:[[LyCurrentUser curUser] userTypeByString],
                                                     }
                                              type:LyHttpType_asynPost
                                           timeOut:0] boolValue];
        
    } else {
        [self reloadData];
    }
    
}


- (void)modifyUserInfo:(LyUserInfoHttpMethod)modifyMode extParameter:(id)extParameter {
    
    NSMutableDictionary *dicPara = [[NSMutableDictionary alloc] initWithCapacity:1];
    NSString *strKey;
    
    switch (modifyMode) {
        case userInfoHttpMethod_load: {
            //nothing
            break;
        }
        case userInfoHttpMethod_avatar: {
            
            [self showIndicatorModify];
            LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:userInfoHttpMethod_avatar];
            [httpRequest setDelegate:self];
            
            nextAvatar = (UIImage *)extParameter;
            
            bHttpFlag = [httpRequest sendAvatarByHttp:modifyUserInfo_url
                                                image:nextAvatar
                                                 body:@{
                                                        pathKey:pngKey,
                                                        userIdKey:[LyCurrentUser curUser].userId,
                                                        sessionIdKey:[LyUtil httpSessionId],
                                                        userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                                        }];
            return;
            
            break;
        }
        case userInfoHttpMethod_nickName: {
//            [self modifyNickName:extParameter];
            return;
            
            break;
        }
        case userInfoHttpMethod_sex: {
            strKey = sexKey;
            break;
        }
        case userInfoHttpMethod_birthday: {
            strKey = birthdayKey;
            break;
        }
        case userInfoHttpMethod_phoneNumber: {
            return;
            
            break;
        }
        case userInfoHttpMethod_driveBirthday: {
            strKey = driveBirthdayKey;
            break;
        }
        case userInfoHttpMethod_teachBirthday: {
            strKey = teachBirthdayKey;
            break;
        }
        case userInfoHttpMethod_signature: {
//            [self showIndicatorModify];
//            [self modifySignatre:extParameter];
            return;
            
            break;
        }
        case userInfoHttpMethod_address: {
            strKey = addressKey;
            break;
        }
        case userInfoHttpMethod_schoolTrueName: {
//            strKey = fullNameKey;
            return;
            break;
        }
        case userInfoHttpMethod_school: {
            strKey = masterKey;
            [dicPara setObject:extParameter forKey:schoolIdKey];
            break;
        }
        case userInfoHttpMethod_trainBase: {
            strKey = trainBaseIdKey;
            [dicPara setObject:[LyCurrentUser curUser].userId forKey:coachIdKey];
            break;
        }
        case userInfoHttpMethod_driveLicense: {
            strKey = driveLicenseKey;
        }
    }
    
    
    [self showIndicatorModify];
    
    [dicPara setObject:[LyCurrentUser curUser].userId forKey:userIdKey];
    [dicPara setObject:[[LyCurrentUser curUser] userTypeByString] forKey:userTypeKey];
    [dicPara setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    [dicPara setObject:extParameter forKey:strKey];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:modifyMode];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:modifyUserInfo_url
                                          body:dicPara
                                          type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}


- (void)handleHttpFailed {
    if ( [indicator isAnimating]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        
        [self showViewError];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"出错"] show];
    }
    
    if ([indicator_modify isAnimating]) {
        [self hideIndicatorModeify:NO];
    }
}



- (void)analysisHttpUserInfo:(NSString *)userInfo
{
    NSDictionary *dic = [LyUtil getObjFromJson:userInfo];
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
        [indicator stopAnimation];
        [indicator_modify stopAnimation];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        [indicator_modify stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch (curHttpMethod) {
        case userInfoHttpMethod_load: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [self handleHttpFailed];
                        return;
                    }
                    
                    [LyUtil setFinishGetUserIfo:YES];
                    
                    switch ([LyCurrentUser curUser].userType) {
                        case LyUserType_normal: {
                            break;
                        }
                        case LyUserType_coach: {
                            
                            NSString *strSex          = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:sexKey]];
                            NSString *strBirthday     = [dicResult objectForKey:birthdayKey];
                            
                            NSString *strDrivedBirthday = [dicResult objectForKey:driveBirthdayKey];
                            NSString *strTeachedBirthday = [dicResult objectForKey:teachBirthdayKey];
                            NSString *strAddress      = [dicResult objectForKey:addressKey];
                            
                            NSDictionary *dicMaster = [dicResult objectForKey:masterKey];
                            NSString *strMasterId;
                            NSString *strMasterName;
                            if (![LyUtil validateDictionary:dicMaster]) {
                                strMasterId = @"";
                                strMasterName = @"";
                            } else {
                                strMasterId = [dicMaster objectForKey:userIdKey];
                                strMasterName = [dicMaster objectForKey:nickNameKey];
                            }
                            
                            NSDictionary *dicTrainBase = [dicResult objectForKey:trainBaseKey];
                            
                            NSString *strTrainBaseId = nil;
                            NSString *strTrainBaseName = nil;
                            if (![LyUtil validateDictionary:dicTrainBase]) {
                                strTrainBaseId = @"";
                                strTrainBaseName = @"";
                            } else {
                                strTrainBaseId = [dicTrainBase objectForKey:idKey];
                                strTrainBaseName = [dicTrainBase objectForKey:trainBaseNameKey];
                            }
                    
                            NSString *strDriveLicense = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:driveLicenseKey]];
                            
                            
                            NSString *strSignature = [dicResult objectForKey:signatureKey];
                            if (![LyUtil validateString:strSignature]) {
                                strSignature = @"";
                            }
                            
                            
                            
                            [[LyCurrentUser curUser] setUserSex:[strSex integerValue]];
                            [[LyCurrentUser curUser] setUserBirthday:strBirthday];
                            
                            [[LyCurrentUser curUser] setUserDriveBirthday:strDrivedBirthday];
                            [[LyCurrentUser curUser] setUserTeachBirthday:strTeachedBirthday];
                            [[LyCurrentUser curUser] setUserAddress:strAddress];
                            
                            [[LyCurrentUser curUser] setMasterId:strMasterId];
                            [[LyCurrentUser curUser] setMasterName:strMasterName];
                            [[LyCurrentUser curUser] setTrainBaseId:strTrainBaseId];
                            [[LyCurrentUser curUser] setTrainBaseName:strTrainBaseName];
                            [[LyCurrentUser curUser] setUserLicense:[LyUtil driveLicenseFromString:strDriveLicense]];
                            
                            [[LyCurrentUser curUser] setUserSignature:strSignature];
                            
                            [self reloadData];
                            
                            [indicator stopAnimation];
                            [self.refreshControl endRefreshing];
                            
                            break;
                        }
                        case LyUserType_school: {
                            
                            NSDictionary *dicResult = [dic objectForKey:resultKey];
                            if (!dicResult || [dicResult isKindOfClass:[NSNull class]] || dicResult.count < 1)
                            {
                                [indicator stopAnimation];
                                [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"出错"] show];
                                
                                return;
                            }
                            
                            NSString *strTrueName = [dicResult objectForKey:fullNameKey];
                            NSString *strAddress = [dicResult objectForKey:addressKey];
                            NSString *strSignature = [dicResult objectForKey:signatureKey];
                            
                            
                            [[LyCurrentUser curUser] setSchoolTrueName:strTrueName];
                            [[LyCurrentUser curUser] setUserAddress:strAddress];
                            [[LyCurrentUser curUser] setUserSignature:strSignature];
                            
//                            [self reloadUserInfo];
                            [self reloadData];
                            
                            [indicator stopAnimation];
                            [self.refreshControl endRefreshing];
                            break;
                        }
                        case LyUserType_guider: {
                            
                            NSString *strSex          = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:sexKey]];
                            NSString *strBirthday     = [dicResult objectForKey:birthdayKey];
                            
                            NSString *strDrivedBirthday = [dicResult objectForKey:driveBirthdayKey];
                            NSString *strTeachedBirthday = [dicResult objectForKey:teachBirthdayKey];
                            NSString *strAddress      = [dicResult objectForKey:addressKey];
                            
                            NSString *strDriveLicense = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:driveLicenseKey]];
                            
                            NSString *strSignature    = [dicResult objectForKey:signatureKey];
                            
                            
                            [[LyCurrentUser curUser] setUserSex:[strSex integerValue]];
                            [[LyCurrentUser curUser] setUserBirthday:strBirthday];
                            
                            [[LyCurrentUser curUser] setUserDriveBirthday:strDrivedBirthday];
                            [[LyCurrentUser curUser] setUserTeachBirthday:strTeachedBirthday];
                            [[LyCurrentUser curUser] setUserAddress:strAddress];
                            
                            [[LyCurrentUser curUser] setUserLicense:[LyUtil driveLicenseFromString:strDriveLicense]];
                            
                            [[LyCurrentUser curUser] setUserSignature:strSignature];
                            
//                            [self reloadUserInfo];
                            [self reloadData];
                            
                            [indicator stopAnimation];
                            [self.refreshControl endRefreshing];
                            break;
                        }
                    }
                    
                    
                    
                    break;
                }
                default: {
                    
                    break;
                }
            }
            break;
        }
        case userInfoHttpMethod_avatar: {
            curHttpMethod = 0;
            switch ([strCode integerValue]) {
                case 0: {
                    UIImage *newAvatar = [nextAvatar scaleToSize:CGSizeMake(avatarSizeMax, avatarSizeMax)];
                    [[LyCurrentUser curUser] setUserAvatar:newAvatar];
                    [LyUtil saveImage:newAvatar withUserId:[LyCurrentUser curUser].userId withMode:LySaveImageMode_avatar];
                    
                    [ivAvatar setImage:newAvatar];
                    [self hideIndicatorModeify:YES];
                    break;
                }
                default: {
                    [self hideIndicatorModeify:NO];
                    break;
                }
            }
            break;
        }
        case userInfoHttpMethod_nickName: {
//            switch ([strCode integerValue]) {
//                case 0: {
//                    NSDictionary *dicResult = [dic objectForKey:resultKey];
//                    if (![LyUtil validateDictionary:dicResult]) {
//                        [tfName setText:[LyCurrentUser curUser].userName];
//                        
//                        [self hideIndicatorModeify:NO];
//                        return;
//                    }
//                    
//                    NSString *newNickName = [dicResult objectForKey:nickNameKey];
//                    [[LyCurrentUser curUser] setUserName:newNickName];
//                    [[NSUserDefaults standardUserDefaults] setObject:newNickName forKey:userName517Key_tc];
//                    
//                    [self hideIndicatorModeify:YES];
//                    break;
//                }
//                default: {
//                    [self hideIndicatorModeify:NO];
//                    break;
//                }
//            }
            break;
        }
        case userInfoHttpMethod_sex: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [self reloadTvInfoItemWithMode:userInfoHttpMethod_sex];
                        
                        [self hideIndicatorModeify:NO];
                        return;
                    }
                    LySex newSex = [[dicResult objectForKey:sexKey] integerValue]+LySexUnkown;
                    [[LyCurrentUser curUser] setUserSex:newSex];
                    [self reloadTvInfoItemWithMode:userInfoHttpMethod_sex];
                    [self hideIndicatorModeify:YES];
                    break;
                }
                default: {
                    [self reloadTvInfoItemWithMode:userInfoHttpMethod_sex];
                    [self hideIndicatorModeify:NO];
                    break;
                }
            }
            break;
        }
        case userInfoHttpMethod_birthday: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [self reloadTvInfoItemWithMode:userInfoHttpMethod_birthday];
                        
                        [self hideIndicatorModeify:NO];
                        return;
                    }
                    NSString *newBirthday = [dicResult objectForKey:birthdayKey];
                    [[LyCurrentUser curUser] setUserBirthday:newBirthday];
                    
                    [self reloadTvInfoItemWithMode:userInfoHttpMethod_birthday];
                    [self hideIndicatorModeify:YES];
                    break;
                }
                default: {
                    [self reloadTvInfoItemWithMode:userInfoHttpMethod_birthday];
                    [self hideIndicatorModeify:NO];
                    break;
                }
            }
            break;
        }
        case userInfoHttpMethod_phoneNumber: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [self reloadTvInfoItemWithMode:userInfoHttpMethod_phoneNumber];
                        
                        [self hideIndicatorModeify:NO];
                        return;
                    }
                    
                    NSString *newPhoneNumber = [dicResult objectForKey:accountKey];
                    [[LyCurrentUser curUser] setUserPhoneNum:newPhoneNumber];
                    [[NSUserDefaults standardUserDefaults] setObject:newPhoneNumber forKey:userAccount517Key_tc];
                    
                    [self reloadTvInfoItemWithMode:userInfoHttpMethod_phoneNumber];
                    [self hideIndicatorModeify:YES];
                    break;
                }
                default: {
                    [self reloadTvInfoItemWithMode:userInfoHttpMethod_phoneNumber];
                    [self hideIndicatorModeify:NO];
                    break;
                }
            }
            break;
        }
        case userInfoHttpMethod_driveBirthday: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [self reloadTvInfoItemWithMode:userInfoHttpMethod_driveBirthday];
                        
                        [self hideIndicatorModeify:NO];
                        return;
                    }
                    
                    NSString *newDriveBirthday = [dicResult objectForKey:driveBirthdayKey];
                    [[LyCurrentUser curUser] setUserDriveBirthday:newDriveBirthday];
                    
                    [self reloadTvInfoItemWithMode:userInfoHttpMethod_driveBirthday];
                    [self hideIndicatorModeify:YES];
                    break;
                }
                default: {
                    [self reloadTvInfoItemWithMode:userInfoHttpMethod_driveBirthday];
                    [self hideIndicatorModeify:NO];
                    break;
                }
            }
            break;
        }
        case userInfoHttpMethod_teachBirthday: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [self reloadTvInfoItemWithMode:userInfoHttpMethod_teachBirthday];
                        
                        [self hideIndicatorModeify:NO];
                        return;
                    }
                    
                    NSString *newTeachBirthday = [dicResult objectForKey:teachBirthdayKey];
                    [[LyCurrentUser curUser] setUserTeachBirthday:newTeachBirthday];
                    
                    [self reloadTvInfoItemWithMode:userInfoHttpMethod_teachBirthday];
                    [self hideIndicatorModeify:YES];
                    break;
                }
                default: {
                    [self reloadTvInfoItemWithMode:userInfoHttpMethod_teachBirthday];
                    [self hideIndicatorModeify:NO];
                    break;
                }
            }
            break;
        }
        case userInfoHttpMethod_signature: {
//            switch ([strCode integerValue]) {
//                case 0: {
//                    NSDictionary *dicResult = [dic objectForKey:resultKey];
//                    if (![LyUtil validateDictionary:dicResult]) {
//                        [self reloadTvInfoItemWithMode:userInfoHttpMethod_signature];
//                        
//                        [self hideIndicatorModeify:NO];
//                        return;
//                    }
//                    
//                    NSString *newSignature = [dicResult objectForKey:signatureKey];
//                    [[LyCurrentUser curUser] setUserSignature:newSignature];
//                    
//                    [self reloadTvInfoItemWithMode:userInfoHttpMethod_signature];
//                    [self hideIndicatorModeify:YES];
//                    break;
//                }
//                default: {
//                    [self reloadTvInfoItemWithMode:userInfoHttpMethod_signature];
//                    [self hideIndicatorModeify:NO];
//                    break;
//                }
//            }
            break;
        }
        case userInfoHttpMethod_address: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [self reloadTvInfoItemWithMode:userInfoHttpMethod_address];
                        
                        [self hideIndicatorModeify:NO];
                        return;
                    }
                    
                    NSString *newAddress = [dicResult objectForKey:addressKey];
                    [[LyCurrentUser curUser] setUserAddress:newAddress];
                    
                    [self reloadTvInfoItemWithMode:userInfoHttpMethod_address];
                    [self hideIndicatorModeify:YES];
                    break;
                }
                default: {
                    [self reloadTvInfoItemWithMode:userInfoHttpMethod_address];
                    [self hideIndicatorModeify:NO];
                    break;
                }
            }
            break;
        }
        case userInfoHttpMethod_schoolTrueName: {
//            switch ([strCode integerValue]) {
//                case 0: {
//                    NSDictionary *dicResult = [dic objectForKey:resultKey];
//                    if (![LyUtil validateDictionary:dicResult]) {
//                        [self reloadTvInfoItemWithMode:userInfoHttpMethod_schoolTrueName];
//                        
//                        [self hideIndicatorModeify:NO];
//                        return;
//                    }
//                    
//                    NSString *newSchoolTrueName = [dicResult objectForKey:fullNameKey];
//                    [[LyCurrentUser curUser] setSchoolTrueName:newSchoolTrueName];
//                    
//                    [self reloadTvInfoItemWithMode:userInfoHttpMethod_schoolTrueName];
//                    [self hideIndicatorModeify:YES];
//                    break;
//                }
//                default: {
//                    [self reloadTvInfoItemWithMode:userInfoHttpMethod_schoolTrueName];
//                    [self hideIndicatorModeify:NO];
//                    break;
//                }
//            }
            break;
        }
        case userInfoHttpMethod_school: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [self reloadTvInfoItemWithMode:userInfoHttpMethod_school];
                        
                        [self hideIndicatorModeify:NO];
                        return;
                    }
                    
                    NSString *strSchoolId = [dicResult objectForKey:masterIdKey];
                    NSString *strSchoolName = [dicResult objectForKey:schoolNameKey];
                    
                    [[LyCurrentUser curUser] setMasterId:strSchoolId];
                    [[LyCurrentUser curUser] setMasterName:strSchoolName];
                    
                    [self reloadTvInfoItemWithMode:userInfoHttpMethod_school];
                    [self hideIndicatorModeify:YES];
                    break;
                }
                default: {
                    [self reloadTvInfoItemWithMode:userInfoHttpMethod_school];
                    [self hideIndicatorModeify:NO];
                    break;
                }
            }
            break;
        }
        case userInfoHttpMethod_trainBase: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [self reloadTvInfoItemWithMode:userInfoHttpMethod_trainBase];
                        
                        [self hideIndicatorModeify:NO];
                        return;
                    }
                    
                    NSString *strTrainBaseId = [dicResult objectForKey:trainBaseIdKey];
                    NSString *strTrainBaseName = [dicResult objectForKey:trainBaseNameKey];
                    
                    [[LyCurrentUser curUser] setTrainBaseId:strTrainBaseId];
                    [[LyCurrentUser curUser] setTrainBaseName:strTrainBaseName];
                    
                    [self reloadTvInfoItemWithMode:userInfoHttpMethod_trainBase];
                    [self hideIndicatorModeify:YES];
                    break;
                }
                default: {
                    [self reloadTvInfoItemWithMode:userInfoHttpMethod_trainBase];
                    [self hideIndicatorModeify:NO];
                    break;
                }
            }
            
            break;
        }
        case userInfoHttpMethod_driveLicense: {
            switch (strCode.integerValue) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [self reloadTvInfoItemWithMode:userInfoHttpMethod_driveLicense];
                        
                        [self hideIndicatorModeify:NO];
                        return;
                    }
                    
                    NSString *strDriveLicense = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:driveLicenseKey]];
                    [[LyCurrentUser curUser] setUserLicense:[LyUtil driveLicenseFromString:strDriveLicense]];
                    
                    [self reloadTvInfoItemWithMode:userInfoHttpMethod_driveLicense];
                    [self hideIndicatorModeify:YES];
                    break;
                }
                default: {
                    [self hideIndicatorModeify:NO];
                    break;
                }
            }
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
        
        [self analysisHttpUserInfo:result];
    }
    
    curHttpMethod = 0;
}



#pragma mark -LyModifyNameViewControllerDelegate
- (void)modifyNameViewController:(LyModifyNameViewController *)modifyNameVC modifyDone:(NSString *)name {
    [modifyNameVC.navigationController popViewControllerAnimated:YES];
    
    if (isTrueName) {
        [self reloadTvInfoItemWithMode:userInfoHttpMethod_schoolTrueName];
    } else {
        [self performSelector:@selector(setName:) withObject:name afterDelay:LyDelayTime];
    }
}


#pragma mark -LyDatePicker
- (void)onBtnCancelClickBydatePicker:(LyDatePicker *)aDatePicker
{
    [aDatePicker hide];
}

- (void)onBtnDoneClick:(NSDate *)date datePicker:(LyDatePicker *)aDatePicker
{
    [aDatePicker hide];
    
    NSString *strDate = [[LyUtil dateFormatterForAll] stringFromDate:date];
    strDate = [strDate substringToIndex:10];
    
    if (userInfoDatePickerMode_age == aDatePicker.tag) {
        if ( ![strDate isEqualToString:[[LyCurrentUser curUser] userBirthday]]) {
            [self modifyUserInfo:userInfoHttpMethod_birthday extParameter:strDate];
        }
        
    } else if (userInfoDatePickerMode_drivedAge == aDatePicker.tag) {
        if (![strDate isEqualToString:[LyCurrentUser curUser].userDriveBirthday]) {
            [self modifyUserInfo:userInfoHttpMethod_driveBirthday extParameter:strDate];
        }
        
    } else if (userInfoDatePickerMode_teachedAge == aDatePicker.tag) {
        if (![strDate isEqualToString:[LyCurrentUser curUser].userTeachBirthday]) {
            [self modifyUserInfo:userInfoHttpMethod_teachBirthday extParameter:strDate];
        }
    }
}


#pragma mark -LyAddressAlertViewDelegate
- (void)addressAlertView:(LyAddressAlertView *)aAddressAlertView onClickButtonDone:(BOOL)isDone
{
    [aAddressAlertView hide];
    if (isDone)
    {
        if (![aAddressAlertView.address isEqualToString:[LyCurrentUser curUser].userAddress])
        {
            [self modifyUserInfo:userInfoHttpMethod_address extParameter:aAddressAlertView.address];
        }
    }
}


#pragma mark -LyChooseSchoolTableViewControllerDelegate
- (NSString *)obtainAddressInfoByChooseSchoolTableViewController:(LyChooseSchoolTableViewController *)aChooseSchoolTableViewContoller {
    return [LyCurrentUser curUser].userAddress;
}

- (void)onSelectedDriveSchoolByChooseSchoolTableViewController:(LyChooseSchoolTableViewController *)aChooseSchoolTableViewContoller andSchool:(LyDriveSchool *)dsch {
    [aChooseSchoolTableViewContoller.navigationController popViewControllerAnimated:YES];
    
    nextSchool = dsch;
    [self modifyUserInfo:userInfoHttpMethod_school extParameter:nextSchool.userId];
}


#pragma mark -LyChooseTrainBaseTableViewControllerDelegate
- (NSString *)obtainSchoolIdByChooseTrainBaseTVC:(LyChooseTrainBaseTableViewController *)aChooseTrainBaseTVC {
    return [LyCurrentUser curUser].masterId;
}

- (void)onDoneByChooseTrainBase:(LyChooseTrainBaseTableViewController *)aChooseTrainBaseVC trainBase:(LyTrainBase *)aTrainBase {
    [aChooseTrainBaseVC.navigationController popViewControllerAnimated:YES];
    
    nextTrainBase = aTrainBase;
    [self modifyUserInfo:userInfoHttpMethod_trainBase extParameter:nextTrainBase.tbId];
}



#pragma mark -LyDriveLicensePickerDelegate
- (void)onDriveLicensePickerCancel:(LyDriveLicensePicker *)picker {
    [picker hide];
}

- (void)onDriveLicensePickerDone:(LyDriveLicensePicker *)picker license:(LyLicenseType)license {
    [picker hide];
    
    if (license != [[LyCurrentUser curUser] userLicenseType]) {
        [self modifyUserInfo:userInfoHttpMethod_driveLicense extParameter:[LyUtil driveLicenseStringFrom:license]];
    }
}



#pragma mark -LyModifySignatureViewControllerDelegate
- (void)modifySignatureViewController:(LyModifySignatureViewController *)aModifySignatureVC done:(NSString *)signature {
    [aModifySignatureVC.navigationController popViewControllerAnimated:YES];
    
    [self reloadTvInfoItemWithMode:userInfoHttpMethod_signature];
}



#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}


#pragma mark -VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        UIImage *oldAvatar = [[LyCurrentUser curUser] userAvatar];
        NSData *oldAvatarData = UIImagePNGRepresentation(oldAvatar);
        NSData *newAvatarData = UIImagePNGRepresentation(editedImage);
        
        if ( ![oldAvatarData isEqual:newAvatarData])
        {
            [self modifyUserInfo:userInfoHttpMethod_avatar extParameter:editedImage];
        }
    }];
}


- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController
{
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        image = [UIImage fixOrientation:image];
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:nil];
    }];
    
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ucicHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch ([LyCurrentUser curUser].userType) {
        case LyUserType_normal: {
            
            break;
        }
        case LyUserType_coach: {
            switch (indexPath.section) {
                case 0: {
                    switch (indexPath.row) {
                        case 0: {
                            //性别选择
                            [self showActionForSex];
                            break;
                        }
                        case 1: {
                            [self showDatePickerWithTag:userInfoDatePickerMode_age];
                            break;
                        }
                        case 2: {
                            [self showModifyPhoneVC];
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
                            [self showDatePickerWithTag:userInfoDatePickerMode_drivedAge];
                            break;
                        }
                        case 1: {
                            [self showDatePickerWithTag:userInfoDatePickerMode_teachedAge];
                            break;
                        }
                        case 2: {
                            [self showAddressPicker];
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
//                            if ([LyCurrentUser curUser].userAddress && [[LyCurrentUser curUser].userAddress isKindOfClass:[NSString class]] && [LyCurrentUser curUser].userAddress.length > 0 && [[LyCurrentUser curUser].userAddress rangeOfString:@"null"].length < 1) {
//                                LyChooseSchoolTableViewController *cstvc = [[LyChooseSchoolTableViewController alloc] init];
//                                [cstvc setDelegate:self];
//                                [self.navigationController pushViewController:cstvc animated:YES];
//                            } else {
//                                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"你还没有地址"] show];
//                            }
                            break;
                        }
                        case 1: {
//                            if ([LyCurrentUser curUser].masterId && [[LyCurrentUser curUser].masterId isKindOfClass:[NSString class]] && [LyCurrentUser curUser].masterId.length > 0 && [[LyCurrentUser curUser].masterId rangeOfString:@"null"].length < 1) {
//                                LyChooseTrainBaseTableViewController *ctbtvc = [[LyChooseTrainBaseTableViewController alloc] init];
//                                [ctbtvc setDelegate:self];
//                                [ctbtvc setMode:LyChooseTrainBaseTableViewControllerMode_school];
//                                [self.navigationController pushViewController:ctbtvc animated:YES];
//                            } else {
//                                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"你还没有所属驾校"] show];
//                            }
                            break;
                        }
                        case 2: {//Add Licnese
                            LyDriveLicensePicker *dlPicker = [[LyDriveLicensePicker alloc] init];
                            [dlPicker setDelegate:self];
                            [dlPicker setInitDriveLicense:[LyCurrentUser curUser].userLicense];
                            [dlPicker show];
                            break;
                        }
                        default:
                            break;
                    }
                    break;
                }
                case 3: {
                    switch (indexPath.row) {
                        case 0: {
                            [self showModifySignatureVC];
                            break;
                        }
                        case 1: {
                            //已认证//nothgin
                            break;
                        }
                        case 2: {
                            [self showMyQRCodeVC];
                            break;
                        }
                        default:
                            break;
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case LyUserType_school: {
            switch (indexPath.section) {
                case 0: {
                    switch (indexPath.row) {
                        case 0: {
                            isTrueName = YES;
                            [self showModifyNameVC];
                            break;
                        }
                        case 1: {
                            [self showModifyPhoneVC];
                            break;
                        }
                        case 2: {
                            [self showAddressPicker];
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
                            [self showModifySignatureVC];
                            break;
                        }
                        case 1: {
                            //已认证//nothgin
                            break;
                        }
                        case 2: {
                            [self showMyQRCodeVC];
                            break;
                        }
                        default:
                            break;
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case LyUserType_guider: {
            switch (indexPath.section) {
                case 0: {
                    switch (indexPath.row) {
                        case 0: {
                            //性别选择
                            [self showActionForSex];
                            break;
                        }
                        case 1: {
                            [self showDatePickerWithTag:userInfoDatePickerMode_age];
                            break;
                        }
                        case 2: {
                            [self showModifyPhoneVC];
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
                            [self showDatePickerWithTag:userInfoDatePickerMode_drivedAge];
                            break;
                        }
                        case 1: {
                            [self showDatePickerWithTag:userInfoDatePickerMode_teachedAge];
                            break;
                        }
                        case 2: {
                            [self showAddressPicker];
                            break;
                        }
                        default:
                            break;
                    }
                    break;
                }
                case 2: {
                    //Add Licnese
                    LyDriveLicensePicker *dlPicker = [[LyDriveLicensePicker alloc] init];
                    [dlPicker setDelegate:self];
                    [dlPicker setInitDriveLicense:[LyCurrentUser curUser].userLicense];
                    [dlPicker show];
                    break;
                }
                case 3: {
                    switch (indexPath.row) {
                        case 0: {
                            [self showModifySignatureVC];
                            break;
                        }
                        case 1: {
                            //已认证//nothgin
                            break;
                        }
                        case 2: {
                            [self showMyQRCodeVC];
                            break;
                        }
                        default:
                            break;
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
    }
    
}



#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger iCount = 0;
    
    switch ([LyCurrentUser curUser].userType) {
        case LyUserType_normal: {
            break;
        }
        case LyUserType_coach: {
            iCount = 4;
            break;
        }
        case LyUserType_school: {
            iCount = 2;
            break;
        }
        case LyUserType_guider: {
//            iCount = 3;
            //Add Licnese
            iCount = 4;
            break;
        }
        default: {
            break;
        }
    }
    
    return iCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger iCount = 0;
    
    switch ([LyCurrentUser curUser].userType) {
        case LyUserType_normal: {
            break;
        }
        case LyUserType_coach: {
            switch (section) {
                case 0: {
                    iCount = 3;
                    break;
                }
                case 1: {
                    iCount = 3;
                    break;
                }
                case 2: {
//                    iCount = 2;
                    //Add Licnese
                    iCount = [LyCurrentUser curUser].isMaster ? 3 : 2;
                    break;
                }
                case 3: {
                    iCount = 3;
                }
                default: {
                    break;
                }
            }
            break;
        }
        case LyUserType_school: {
            switch (section) {
                case 0: {
                    iCount = 3;
                    break;
                }
                case 1: {
                    iCount = 3;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case LyUserType_guider: {
            switch (section) {
                case 0: {
                    iCount = 3;
                    break;
                }
                case 1: {
                    iCount = 3;
                    break;
                }
                case 2: {//Add Licnese
                    iCount = 1;
                    break;
                }
                case 3: {
                    iCount = 3;
                    break;
                }
                default:
                    break;
            }
            
            break;
        }
        default: {
        }
    }
    
    return iCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LyUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyUserInfoTvInfoCellReuseIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[LyUserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyUserInfoTvInfoCellReuseIdentifier];
    }
    
    
    NSString *title = nil;
    NSString *detail = nil;
    UIImage *icon = nil;
    switch ([LyCurrentUser curUser].userType) {
        case LyUserType_normal: {
            
            break;
        }
        case LyUserType_coach: {
            switch (indexPath.section) {
                case 0: {
                    switch (indexPath.row) {
                        case 0: {
                            title = @"姓别";
                            detail = (LySexUnkown == [LyCurrentUser curUser].userSex) ? @"保密" : ((LySexMale == [LyCurrentUser curUser].userSex) ? @"男" : @"女");
                            icon = nil;
                            break;
                        }
                        case 1: {
                            title = @"年龄";
                            detail = [[NSString alloc] initWithFormat:@"%d岁", [LyCurrentUser curUser].userAge];
                            icon = nil;
                            break;
                        }
                        case 2: {
                            title = @"手机号";
                            detail = [LyUtil hidePhoneNumber:[LyCurrentUser curUser].userPhoneNum];
                            icon = nil;
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
                             title = @"驾龄";
                            detail = [[NSString alloc] initWithFormat:@"%d年", [LyCurrentUser curUser].userDrivedAge];
                            icon = nil;
                            break;
                        }
                        case 1: {
                            title = @"教龄";
                            detail = [[NSString alloc] initWithFormat:@"%d年", [LyCurrentUser curUser].userTeachedAge];
                            icon = nil;
                            break;
                        }
                        case 2: {
                            title = @"地址";
                            detail = [[LyCurrentUser curUser] userAddress];
                            icon = nil;
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
                            title = @"所属驾校";
                            detail = [LyCurrentUser curUser].masterName;
                            icon = nil;
                            break;
                        }
                        case 1: {
                            title = @"所在基地";
                            detail = [LyCurrentUser curUser].trainBaseName;
                            icon = nil;
                            break;
                        }
                        case 2: {//Add Licnese
                            title = @"所教驾照";
                            detail = [LyUtil driveLicenseStringFrom:[LyCurrentUser curUser].userLicense];
                            icon = nil;
                            break;
                        }
                        default:
                            break;
                    }
                    break;
                }
                case 3:{
                    switch (indexPath.row) {
                        case 0: {
                            title = @"个性签名";
                            detail = ([LyUtil validateString:[LyCurrentUser curUser].userSignature]) ? [LyCurrentUser curUser].userSignature : @"这个家伙很懒，什么都没留下";
                            icon = nil;
                            break;
                        }
                        case 1: {
                            title = @"实名认证";
                            detail = @"已认证";
                            icon = nil;
                            break;
                        }
                        case 2: {
                            title = @"二维码名片";
                            detail = nil;
                            icon = [LyUtil imageForImageName:@"userInfo_QRCode" needCache:NO];
                            break;
                        }
                        default:
                            break;
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case LyUserType_school: {
            switch (indexPath.section) {
                case 0: {
                    switch (indexPath.row) {
                        case 0: {
                            title = @"驾校全名";
                            detail = [LyCurrentUser curUser].schoolTrueName;
                            icon = nil;
                            break;
                        }
                        case 1: {
                            title = @"手机号";
                            detail = [LyUtil hidePhoneNumber:[LyCurrentUser curUser].userPhoneNum];
                            icon = nil;
                            break;
                        }
                        case 2: {
                            title = @"地址";
                            detail = [[LyCurrentUser curUser] userAddress];
                            icon = nil;
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
                            title = @"个性签名";
                            detail = ([LyUtil validateString:[LyCurrentUser curUser].userSignature]) ? [LyCurrentUser curUser].userSignature : @"这个家伙很懒，什么都没留下";
                            icon = nil;
                            break;
                        }
                        case 1: {
                            title = @"实名认证";
                            detail = @"已认证";
                            icon = nil;
                            break;
                        }
                        case 2: {
                            title = @"二维码名片";
                            detail = nil;
                            icon = [LyUtil imageForImageName:@"userInfo_QRCode" needCache:NO];
                            break;
                        }
                        default:
                            break;
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case LyUserType_guider: {
            switch (indexPath.section) {
                case 0: {
                    switch (indexPath.row) {
                        case 0: {
                            title = @"姓别";
                            detail = (LySexUnkown == [LyCurrentUser curUser].userSex) ? @"保密" : ((LySexMale == [LyCurrentUser curUser].userSex) ? @"男" : @"女");
                            icon = nil;
                            break;
                        }
                        case 1: {
                            title = @"年龄";
                            detail = [[NSString alloc] initWithFormat:@"%d岁", [LyCurrentUser curUser].userAge];
                            icon = nil;
                            break;
                        }
                        case 2: {
                            title = @"手机号";
                            detail = [LyUtil hidePhoneNumber:[LyCurrentUser curUser].userPhoneNum];
                            icon = nil;
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
                            title = @"驾龄";
                            detail = [[NSString alloc] initWithFormat:@"%d年", [LyCurrentUser curUser].userDrivedAge];
                            icon = nil;
                            break;
                        }
                        case 1: {
                            title = @"教龄";
                            detail = [[NSString alloc] initWithFormat:@"%d年", [LyCurrentUser curUser].userTeachedAge];
                            icon = nil;
                            break;
                        }
                        case 2: {
                            title = @"地址";
                            detail = [[LyCurrentUser curUser] userAddress];
                            icon = nil;
                            break;
                        }
                        default:
                            break;
                    }
                    break;
                }
                case 2: {//Add Licnese
                    title = @"所教驾照";
                    detail = [LyUtil driveLicenseStringFrom:[LyCurrentUser curUser].userLicense];
                    icon = nil;
                    break;
                }
                case 3: {
                    switch (indexPath.row) {
                        case 0: {
                            title = @"个性签名";
                            detail = ([LyUtil validateString:[LyCurrentUser curUser].userSignature]) ? [LyCurrentUser curUser].userSignature : @"这个家伙很懒，什么都没留下";
                            icon = nil;
                            break;
                        }
                        case 1: {
                            title = @"实名认证";
                            detail = @"已认证";
                            icon = nil;
                            break;
                        }
                        case 2: {
                            title = @"二维码名片";
                            detail = nil;
                            icon = [LyUtil imageForImageName:@"userInfo_QRCode" needCache:NO];
                            break;
                        }
                        default:
                            break;
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
    }
    
    [cell setCellInfo:title detail:detail icon:icon];
    
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
