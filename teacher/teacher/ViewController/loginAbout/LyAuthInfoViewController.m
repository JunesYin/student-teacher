//
//  LyAuthInfoViewController.m
//  teacher
//
//  Created by Junes on 08/10/2016.
//  Copyright © 2016 517xueche. All rights reserved.
//

#import "LyAuthInfoViewController.h"
#import "LyAddressAlertView.h"

#import "LyRemindView.h"
#import "LyIndicator.h"

#import "LyCurrentUser.h"
#import "LyDriveSchool.h"
#import "LyTrainBase.h"
#import "LyPhotoAsset.h"

#import "NSString+Validate.h"

#import "LyUtil.h"


#import "LyAuthPhotoViewController.h"
#import "LyVerifyProgressViewController.h"
#import "LyTxtViewController.h"
#import "LyChooseSchoolTableViewController.h"
#import "LyChooseTrainBaseTableViewController.h"




#define aiContentFont                   LyFont(14)


#define aiBtnCommitWidth                (SCREEN_WIDTH*3/4.0f)
CGFloat const aiBtnCommitHeight = 40.0f;


typedef NS_ENUM(NSInteger, LyAuthInfoTextFieldTag) {
    authInfoTextFieldTag_briefName = 10,
    authInfoTextFieldTag_coachLicenseId,
    authInfoTextFieldTag_driveLicenseId,
    authInfoTextFieldTag_identityId,
    authInfoTextFieldTag_fullName,
    authInfoTextFieldTag_businessLicenseId,
};

typedef NS_ENUM(NSInteger, LyAuthInfoButtonTag) {
    authInfoButtonTag_sex = 20,
    authInfoButtonTag_address,
    authInfoButtonTag_school,
    authInfoButtonTag_trainBase,
    authInfoButtonTag_commit
};


typedef NS_ENUM(NSInteger, LyAuthInfoHttpMethod) {
    authInfoHttpMethod_commit = 100,
};


@interface LyAuthInfoViewController () <UIScrollViewDelegate, UITextFieldDelegate, LyAddressAlertViewDelegate, LyChooseSchoolTableViewControllerDelegate, LyChooseTrainBaseTableViewControllerDelegate, LyHttpRequestDelegate>
{
    UIScrollView                *svMain;
    UILabel                     *lbRemindUpper;
    
    
    UIView                      *viewInfo;
    
    UITextField                 *tfBriefName;           //简名-all
    UIButton                    *btnSex;                //姓别-教练、指导员
    UITextField                 *tfCoachLicenseId;      //教练证号-教练
    UITextField                 *tfDriveLicenseId;      //驾驶证号-教练、指导员
    UITextField                 *tfIdentityId;          //身份证号-教练、指导员
    
    UITextField                 *tfFullName;             //全名-驾校
    UITextField                 *tfBusinessLicenseId;   //营业执照-驾校
    
    UIButton                    *btnAddress;            //地址-all
    
    UIButton                    *btnSchool;             //驾校-教练
    UIButton                    *btnTrainBase;          //基地-教经练
    
    UILabel                     *lbProtocol;            //协议
    
    UIButton                    *btnCommit;             //提交
    
    
    NSString                    *city;
    
    
    LyIndicator                 *indicator;
    BOOL                        bHttpFlag;
    LyAuthInfoHttpMethod        curHttpMethod;
}

@property (retain, nonatomic)       LyDriveSchool       *curSchool;
@property (retain, nonatomic)       LyTrainBase         *curTrainBase;

@end

@implementation LyAuthInfoViewController

static NSString *const btnAddressDefaultTitle = @"点击选择地址";
static NSString *const btnSchoolDefaultTitle = @"请选择所属驾校";
static NSString *const btnTrainBaseDefaultTitle = @"请选择所在基地";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [self addObserverForNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeObserverForNotification];
}


- (void)initAndLayoutSubviews {
    
    self.title = @"认证";
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT)];
    [self.view addSubview:svMain];
    
    
    NSString *strLbRemindUpper = @"请填写真实信息，我们将对你所提供的信息进行认证";
    lbRemindUpper = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, verticalSpace, SCREEN_WIDTH-horizontalSpace*2, 40.0f)];
    [lbRemindUpper setFont:LyFont(12)];
    [lbRemindUpper setTextColor:Ly517ThemeColor];
    [lbRemindUpper setTextAlignment:NSTextAlignmentCenter];
    [lbRemindUpper setText:strLbRemindUpper];
    [svMain addSubview:lbRemindUpper];
    
    
    switch ([LyCurrentUser curUser].userType) {
        case LyUserType_normal: {
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
    
    
    [self initProtocol];
    
    
    [btnCommit setEnabled:NO];
    
}


//教练布局
- (void)initAndLayoutSubviews_coach {
    
    //姓名
    tfBriefName = [self tfContentWithTag:authInfoTextFieldTag_briefName
                        placeholder:@"请输入真实姓名"
                              title:@"真实姓名"];
    [tfBriefName setFrame:CGRectMake(0, 0, SCREEN_WIDTH, LyViewItemHeight)];
    
    
    //姓别
    UIView *viewSex = [[UIView alloc] initWithFrame:CGRectMake(0, tfBriefName.ly_y+CGRectGetHeight(tfBriefName.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewSex setBackgroundColor:[UIColor whiteColor]];
    UILabel *lbTitle_sex = [self lbTitleWithText:@"姓别"];
    btnSex = [[UIButton alloc] initWithFrame:CGRectMake(LyLbTitleItemWidth+horizontalSpace, 0, LyViewItemHeight*2, LyViewItemHeight)];
    [btnSex setTag:authInfoButtonTag_sex];
    [btnSex setImage:[LyUtil imageForImageName:@"sexPick_male" needCache:NO] forState:UIControlStateNormal];
    [btnSex setImage:[LyUtil imageForImageName:@"sexPick_female" needCache:NO] forState:UIControlStateSelected];
    [btnSex addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewSex addSubview:lbTitle_sex];
    [viewSex addSubview:btnSex];
    
    
    //教练证号
    tfCoachLicenseId = [self tfContentWithTag:authInfoTextFieldTag_coachLicenseId
                                  placeholder:@"请输入教练证号"
                                        title:@"教练证号"];
    [tfCoachLicenseId setFrame:CGRectMake(0, viewSex.ly_y+CGRectGetHeight(viewSex.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [tfCoachLicenseId setKeyboardType:UIKeyboardTypeASCIICapable];
    [tfCoachLicenseId setReturnKeyType:UIReturnKeyNext];
    
    
    //驾驶证号
    tfDriveLicenseId = [self tfContentWithTag:authInfoTextFieldTag_driveLicenseId
                                  placeholder:@"请输入驾驶证号"
                                        title:@"驾驶证号"];
    [tfDriveLicenseId setFrame:CGRectMake(0, tfCoachLicenseId.ly_y+CGRectGetHeight(tfCoachLicenseId.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [tfDriveLicenseId setKeyboardType:UIKeyboardTypeASCIICapable];
    [tfDriveLicenseId setReturnKeyType:UIReturnKeyNext];
    
    
    //身份证号
    tfIdentityId = [self tfContentWithTag:authInfoTextFieldTag_identityId
                              placeholder:@"请输入身份证号"
                                    title:@"身份证号"];
    [tfIdentityId setFrame:CGRectMake(0, tfDriveLicenseId.ly_y+CGRectGetHeight(tfDriveLicenseId.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [tfIdentityId setKeyboardType:UIKeyboardTypeASCIICapable];
    [tfIdentityId setReturnKeyType:UIReturnKeyDone];
    
    //地址
    UIView *viewAddress = [[UIView alloc] initWithFrame:CGRectMake(0, tfIdentityId.ly_y+CGRectGetHeight(tfIdentityId.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewAddress setBackgroundColor:[UIColor whiteColor]];
    UILabel *lbTitle_address = [self lbTitleWithText:@"详细地址"];
    btnAddress = [self btnContentWithTag:authInfoButtonTag_address title:btnAddressDefaultTitle];
    
    [viewAddress addSubview:lbTitle_address];
    [viewAddress addSubview:btnAddress];
    
    
    //所属驾校
    UIView *viewSchool = [[UIView alloc] initWithFrame:CGRectMake(0, viewAddress.ly_y+CGRectGetHeight(viewAddress.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewSchool setBackgroundColor:[UIColor whiteColor]];
    UILabel *lbTitle_school = [self lbTitleWithText:@"所属驾校"];
    btnSchool = [self btnContentWithTag:authInfoButtonTag_school title:btnSchoolDefaultTitle];
    
    [viewSchool addSubview:lbTitle_school];
    [viewSchool addSubview:btnSchool];
    
    
    //所在基地
    UIView *viewTrainBase = [[UIView alloc] initWithFrame:CGRectMake(0, viewSchool.ly_y+CGRectGetHeight(viewSchool.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewTrainBase setBackgroundColor:[UIColor whiteColor]];
    UILabel *lbTitle_trainBase = [self lbTitleWithText:@"所在基地"];
    btnTrainBase = [self btnContentWithTag:authInfoButtonTag_trainBase title:btnTrainBaseDefaultTitle];
    
    [viewTrainBase addSubview:lbTitle_trainBase];
    [viewTrainBase addSubview:btnTrainBase];
    
    
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake(0, lbRemindUpper.ly_y+CGRectGetHeight(lbRemindUpper.frame)+verticalSpace, SCREEN_WIDTH, viewTrainBase.ly_y+CGRectGetHeight(viewTrainBase.frame)+verticalSpace)];
    
    [viewInfo addSubview:tfBriefName];
    [viewInfo addSubview:viewSex];
    [viewInfo addSubview:tfCoachLicenseId];
    [viewInfo addSubview:tfDriveLicenseId];
    [viewInfo addSubview:tfIdentityId];
    [viewInfo addSubview:viewAddress];
    [viewInfo addSubview:viewSchool];
    [viewInfo addSubview:viewTrainBase];
    
    [svMain addSubview:viewInfo];
}

//驾校布局
- (void)initAndLayoutSubviews_school {
    
    //全名
    tfFullName = [self tfContentWithTag:authInfoTextFieldTag_fullName
                            placeholder:@"请输入驾校全名"
                                  title:@"驾校全名"];
    [tfFullName setFrame:CGRectMake(0, 0, SCREEN_WIDTH, LyViewItemHeight)];

    
    //简称
    tfBriefName = [self tfContentWithTag:authInfoTextFieldTag_briefName
                             placeholder:@"请输入驾校简称"
                                   title:@"驾校简称"];
    [tfBriefName setFrame:CGRectMake(0, tfFullName.ly_y+CGRectGetHeight(tfFullName.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    
    
    //营业执照
    tfBusinessLicenseId = [self tfContentWithTag:authInfoTextFieldTag_businessLicenseId
                                     placeholder:@"请输入营业执照注册号"
                                           title:@"营业执照"];
    [tfBusinessLicenseId setFrame:CGRectMake(0, tfBriefName.ly_y+CGRectGetHeight(tfBriefName.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [tfBusinessLicenseId setKeyboardType:UIKeyboardTypeASCIICapable];
    
    
    //地址
    UIView *viewAddress = [[UIView alloc] initWithFrame:CGRectMake(0, tfBusinessLicenseId.ly_y+CGRectGetHeight(tfBusinessLicenseId.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewAddress setBackgroundColor:[UIColor whiteColor]];
    UILabel *lbTitle_address = [self lbTitleWithText:@"详细地址"];
    btnAddress = [self btnContentWithTag:authInfoButtonTag_address title:btnAddressDefaultTitle];
    
    [viewAddress addSubview:lbTitle_address];
    [viewAddress addSubview:btnAddress];
    
    
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake(0, lbRemindUpper.ly_y+CGRectGetHeight(lbRemindUpper.frame)+verticalSpace, SCREEN_WIDTH, viewAddress.ly_y+CGRectGetHeight(viewAddress.frame)+verticalSpace)];
    
    [viewInfo addSubview:tfFullName];
    [viewInfo addSubview:tfBriefName];
    [viewInfo addSubview:tfBusinessLicenseId];
    [viewInfo addSubview:viewAddress];
    
    [svMain addSubview:viewInfo];
}

//指导员布局
- (void)initAndLayoutSubviews_guider {
    //姓名
    tfBriefName = [self tfContentWithTag:authInfoTextFieldTag_briefName
                            placeholder:@"请输入真实姓名"
                                  title:@"真实姓名"];
    [tfBriefName setFrame:CGRectMake(0, 0, SCREEN_WIDTH, LyViewItemHeight)];
    
    
    //姓别
    UIView *viewSex = [[UIView alloc] initWithFrame:CGRectMake(0, tfBriefName.ly_y+CGRectGetHeight(tfBriefName.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewSex setBackgroundColor:[UIColor whiteColor]];
    UILabel *lbTitle_sex = [self lbTitleWithText:@"姓别"];
    btnSex = [[UIButton alloc] initWithFrame:CGRectMake(LyLbTitleItemWidth+horizontalSpace, 0, LyViewItemHeight*2, LyViewItemHeight)];
    [btnSex setTag:authInfoButtonTag_sex];
    [btnSex setImage:[LyUtil imageForImageName:@"sexPick_male" needCache:NO] forState:UIControlStateNormal];
    [btnSex setImage:[LyUtil imageForImageName:@"sexPick_female" needCache:NO] forState:UIControlStateSelected];
    [btnSex addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewSex addSubview:lbTitle_sex];
    [viewSex addSubview:btnSex];
    
    
    //驾驶证号
    tfDriveLicenseId = [self tfContentWithTag:authInfoTextFieldTag_driveLicenseId
                                  placeholder:@"请输入驾驶证号"
                                        title:@"驾驶证号"];
    [tfDriveLicenseId setFrame:CGRectMake(0, viewSex.ly_y+CGRectGetHeight(viewSex.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [tfDriveLicenseId setKeyboardType:UIKeyboardTypeASCIICapable];
    [tfDriveLicenseId setReturnKeyType:UIReturnKeyNext];
    
    
    //身份证号
    tfIdentityId = [self tfContentWithTag:authInfoTextFieldTag_identityId
                                  placeholder:@"请输入身份证号"
                                        title:@"身份证号"];
    [tfIdentityId setFrame:CGRectMake(0, tfDriveLicenseId.ly_y+CGRectGetHeight(tfDriveLicenseId.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [tfIdentityId setKeyboardType:UIKeyboardTypeASCIICapable];
    
    
    //地址
    UIView *viewAddress = [[UIView alloc] initWithFrame:CGRectMake(0, tfIdentityId.ly_y+CGRectGetHeight(tfIdentityId.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewAddress setBackgroundColor:[UIColor whiteColor]];
    UILabel *lbTitle_address = [self lbTitleWithText:@"详细地址"];
    btnAddress = [self btnContentWithTag:authInfoButtonTag_address title:btnAddressDefaultTitle];
    
    [viewAddress addSubview:lbTitle_address];
    [viewAddress addSubview:btnAddress];
    
    
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake(0, lbRemindUpper.ly_y+CGRectGetHeight(lbRemindUpper.frame)+verticalSpace, SCREEN_WIDTH, viewAddress.ly_y+CGRectGetHeight(viewAddress.frame)+verticalSpace)];
    
    [viewInfo addSubview:tfBriefName];
    [viewInfo addSubview:viewSex];
    [viewInfo addSubview:tfDriveLicenseId];
    [viewInfo addSubview:tfIdentityId];
    [viewInfo addSubview:viewAddress];
    
    [svMain addSubview:viewInfo];
}



- (void)initProtocol {
    //协议
    lbProtocol = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, viewInfo.ly_y+CGRectGetHeight(viewInfo.frame)+horizontalSpace, SCREEN_WIDTH-horizontalSpace*2, 30.0f)];
    [lbProtocol setFont:LyFont(12)];
    [lbProtocol setTextColor:[UIColor grayColor]];
    [lbProtocol setTextAlignment:NSTextAlignmentCenter];
    [lbProtocol setAttributedText:({
        NSString *strProtocolName;
        if (LyUserType_school == [LyCurrentUser curUser].userType) {
            strProtocolName = @"《我要去学车合作协议》";
        } else {
            strProtocolName = @"《信息服务协议》";
        }
        NSString *strProtocolTmp = [[NSString alloc] initWithFormat:@"注册即代表同意%@", strProtocolName];
        NSMutableAttributedString *strProtocol = [[NSMutableAttributedString alloc] initWithString:strProtocolTmp];
        [strProtocol addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[strProtocolTmp rangeOfString:strProtocolName]];
        strProtocol;
    })];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForTapGestureFromLbProtocol)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    
    [lbProtocol setUserInteractionEnabled:YES];
    [lbProtocol addGestureRecognizer:tap];
    
    
    [svMain addSubview:lbProtocol];
    
    
    //提交按钮
    btnCommit = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f-aiBtnCommitWidth/2.0f, lbProtocol.ly_y+CGRectGetHeight(lbProtocol.frame)+30.0f, aiBtnCommitWidth, aiBtnCommitHeight)];
    [btnCommit setTag:authInfoButtonTag_commit];
    [btnCommit setBackgroundImage:[LyUtil imageWithColor:Ly517ThemeColor withSize:btnCommit.frame.size] forState:UIControlStateNormal];
    [btnCommit setBackgroundImage:[LyUtil imageWithColor:LyHighLightgrayColor withSize:btnCommit.frame.size] forState:UIControlStateDisabled];
    [btnCommit setTitle:@"提交" forState:UIControlStateNormal];
    [[btnCommit layer] setCornerRadius:btnCornerRadius];
    [btnCommit setClipsToBounds:YES];
    [btnCommit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCommit addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [svMain addSubview:btnCommit];
    
    CGFloat fCZHeight = btnCommit.ly_y + CGRectGetHeight(btnCommit.frame) + 50.0f;
    if (fCZHeight <= CGRectGetHeight(svMain.frame)) {
        fCZHeight = CGRectGetHeight(svMain.frame) * 1.05f;
    }
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, fCZHeight)];
}


- (UILabel *)lbTitleWithText:(NSString *)text {
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LyLbTitleItemWidth, LyViewItemHeight)];
    [lbTitle setFont:LyFont(16)];
    [lbTitle setTextColor:[UIColor blackColor]];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    [lbTitle setText:text];
    
    return lbTitle;
}

- (UITextField *)tfContentWithTag:(LyAuthInfoTextFieldTag)tag placeholder:(NSString *)placeholder title:(NSString *)title {
    UITextField *tfContent = [[UITextField alloc] init];
    [tfContent setBackgroundColor:[UIColor whiteColor]];
    [tfContent setTag:tag];
    [tfContent setDelegate:self];
    [tfContent setFont:aiContentFont];
    [tfContent setTextColor:LyBlackColor];
    [tfContent setPlaceholder:placeholder];
    [tfContent setReturnKeyType:UIReturnKeyDone];
    
    [tfContent setLeftView:[self lbTitleWithText:title]];
    [tfContent setLeftViewMode:UITextFieldViewModeAlways];
    [tfContent setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    return tfContent;
}

- (UIButton *)btnContentWithTag:(LyAuthInfoButtonTag)tag title:(NSString *)tittle {
    UIButton *btnContent = [[UIButton alloc] initWithFrame:CGRectMake(LyLbTitleItemWidth+horizontalSpace, 0, SCREEN_WIDTH-LyLbTitleItemWidth-horizontalSpace, LyViewItemHeight)];
    [btnContent setTag:tag];
    [btnContent.titleLabel setFont:aiContentFont];
    [btnContent setTitle:tittle forState:UIControlStateNormal];
    [btnContent setTitleColor:LyBlackColor forState:UIControlStateNormal];
    [btnContent setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnContent addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return btnContent;
}


- (void)setCurSchool:(LyDriveSchool *)curSchool {
    _curSchool = curSchool;
    if (!_curSchool) {
        return;
    }
    
    [btnSchool setTitle:_curSchool.userName forState:UIControlStateNormal];
}

- (void)setCurTrainBase:(LyTrainBase *)curTrainBase {
    _curTrainBase = curTrainBase;
    if (!_curTrainBase) {
        return;
    }
    
    [btnTrainBase setTitle:_curTrainBase.tbName forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addObserverForNotification {
    
    if ([self respondsToSelector:@selector(targetForNotificationFromUIKeyboardWillShowNotification:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(targetForNotificationFromUIKeyboardWillShowNotification:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
    }
    
    if ([self respondsToSelector:@selector(targetForNotificationFromUIKeyboardWillHideNotification:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(targetForNotificationFromUIKeyboardWillHideNotification:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    
    if ([self respondsToSelector:@selector(targetForNotificationFormUITextFieldTextDidChangeNotification:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(targetForNotificationFormUITextFieldTextDidChangeNotification:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:nil];
    }
}

- (void)removeObserverForNotification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


- (void)targetForButton:(UIButton *)button {
    
    [self allControlResignFirstResponder];
    
    if (authInfoButtonTag_sex == button.tag) {
        [btnSex setSelected:!btnSex.isSelected];
        
    } else if (authInfoButtonTag_address == button.tag) {
        LyAddressAlertView *aa = [[LyAddressAlertView alloc] init];
        if (![btnAddress.titleLabel.text isEqualToString:btnAddressDefaultTitle]) {
            [aa setAddress:btnAddress.titleLabel.text];
        }
        [aa setDelegate:self];
        [aa show];
        
    } else if (authInfoButtonTag_school == button.tag) {
        if (!btnAddress.titleLabel.text || btnAddress.titleLabel.text.length < 2 || [btnAddress.titleLabel.text isEqualToString:btnAddressDefaultTitle]) {
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没有选择详细地址"] show];
        } else {
            LyChooseSchoolTableViewController *cs = [[LyChooseSchoolTableViewController alloc] init];
            [cs setDelegate:self];
            [self.navigationController pushViewController:cs animated:YES];
        }
        
    } else if (authInfoButtonTag_trainBase == button.tag) {
        if (!btnSchool.titleLabel.text || btnSchool.titleLabel.text.length < 2 || [btnSchool.titleLabel.text isEqualToString:btnSchoolDefaultTitle]) {
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没有选择所属驾校"] show];
        } else {
            LyChooseTrainBaseTableViewController *chooseTrainBaseVC = [[LyChooseTrainBaseTableViewController alloc] init];
            [chooseTrainBaseVC setMode:LyChooseTrainBaseTableViewControllerMode_school];
            [chooseTrainBaseVC setDelegate:self];
            [self.navigationController pushViewController:chooseTrainBaseVC animated:YES];
        }
        
    } else if (authInfoButtonTag_commit == button.tag) {
        [self commit];
    }
}

- (void)targetForTapGestureFromLbProtocol {
    
    LyTxtViewControllerMode txtMode;
    if (LyUserType_school == [LyCurrentUser curUser].userType) {
        txtMode = LyTxtViewControllerMode_517CooperationProtocol;
    } else {
        txtMode = LyTxtViewControllerMode_517InfoServiceProtocol;
    }
    
    LyTxtViewController *txt = [[LyTxtViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:txt];
    [self presentViewController:nav animated:YES completion:^{
        [txt setMode:txtMode];
    }];
}

- (void)allControlResignFirstResponder
{
    [tfBriefName resignFirstResponder];
    [tfCoachLicenseId resignFirstResponder];
    [tfDriveLicenseId resignFirstResponder];
    [tfIdentityId resignFirstResponder];
    [tfFullName resignFirstResponder];
    [tfBusinessLicenseId resignFirstResponder];
}

- (BOOL)validate:(BOOL)flag {
    [btnCommit setEnabled:NO];
    
    if ( ![tfBriefName.text validateName]) {
        if (flag) {
            [tfBriefName setTextColor:LyWarnColor];
            NSString *strRemindTitle = @"姓名格式错误";
            if (LyUserType_school == [LyCurrentUser curUser].userType) {
                strRemindTitle = @"驾校简称格式错误";
            }
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:strRemindTitle] show];
        }
        
        return NO;
    } else {
        [tfBriefName setTextColor:LyBlackColor];
    }
    
    
    
    switch ([LyCurrentUser curUser].userType) {
        case LyUserType_normal: {
            break;
        }
        case LyUserType_coach: {
            //验证教练证号
            if (tfCoachLicenseId.text.length < 1) {
                if (flag) {
                    [tfCoachLicenseId setTextColor:LyWarnColor];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"教练证号格式错误"] show];
                }
                
                return NO;
            } else {
                [tfCoachLicenseId setTextColor:LyBlackColor];
            }
            
            //验证驾驶证号
            if (![tfDriveLicenseId.text validateIdCar]) {
//            if (tfDriveLicenseId.text.length < 1) {
                if (flag) {
                    [tfDriveLicenseId setTextColor:LyWarnColor];
                    [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"驾驶证号格式错误"];
                }
                
                return NO;
            } else {
                [tfDriveLicenseId setTextColor:LyBlackColor];
            }
            
            //验证身份证号
            if (![tfIdentityId.text validateIdCar]) {
//            if (tfIdentityId.text.length < 1) {
                if (flag) {
                    [tfIdentityId setTextColor:LyWarnColor];
                    [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"身份证号格式错误"];
                }
                
                return NO;
            } else {
                [tfIdentityId setTextColor:LyBlackColor];
            }
            
            //验证所属驾校
            if (!_curSchool || ![LyUtil validateUserId:_curSchool.userId]) {
                if (flag) {
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"还没有选择所属驾校"] show];
                }
                
                return NO;
            }
            
            //验证所在基地
            if (!_curTrainBase || ![LyUtil validateString:_curTrainBase.tbId]) {
                if (flag) {
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"还没有选择所在基地"] show];
                }
                
                return NO;
            }
            
            break;
        }
        case LyUserType_school: {
            //验证驾校简称
            if (![tfFullName.text validateName]) {
                if (flag) {
                    [tfFullName setTextColor:LyWarnColor];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"驾校全名格式错误"] show];
                }
                
                return NO;
            } else {
                [tfFullName setTextColor:LyBlackColor];
            }
            
            //验证营业执照
            if (tfBusinessLicenseId.text.length < 1) {
                if (flag) {
                    [tfBusinessLicenseId setTextColor:LyWarnColor];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"营业执照格式错误"] show];
                }
                
                return NO;
            } else {
                [tfBusinessLicenseId setTextColor:LyBlackColor];
            }
            break;
        }
        case LyUserType_guider: {
            //验证驾驶证号
            if (![tfDriveLicenseId.text validateIdCar]) {
//            if (tfDriveLicenseId.text.length < 1) {
                if (flag) {
                    [tfDriveLicenseId setTextColor:LyWarnColor];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"驾驶证号格式错误"] show];
                }
                
                return NO;
            } else {
                [tfDriveLicenseId setTextColor:LyBlackColor];
            }
            
            //验证身份证号
            if (![tfIdentityId.text validateIdCar]) {
//            if (tfIdentityId.text.length < 1) {
                if (flag) {
                    [tfIdentityId setTextColor:LyWarnColor];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"身份证号格式错误"] show];
                }
                
                return NO;
            } else {
                [tfIdentityId setTextColor:LyBlackColor];
            }
            break;
        }
    }
    
    if (btnAddress.titleLabel.text.length < 1 || [btnAddress.titleLabel.text isEqualToString:btnAddressDefaultTitle]) {
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"还没有选择详细地址"] show];
        }
        
        return NO;
    }
    
    
    [btnCommit setEnabled:YES];
    return YES;
}


- (void)commit {
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:LyIndicatorTitle_commit];
    }
    [indicator startAnimation];
    
    NSString *strUserName = tfBriefName.text;
    NSString *strUserNameSuffix = [LyUtil userTypeChineseStringFrom:[LyCurrentUser curUser].userType];
    if ([strUserName rangeOfString:strUserNameSuffix].length < 1) {
        strUserName = [strUserName stringByAppendingString:strUserNameSuffix];
    }
    
    NSMutableArray *arrPic = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableDictionary *dicHr = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    [dicHr setObject:[LyCurrentUser curUser].userId forKey:userIdKey];
    [dicHr setObject:[[LyCurrentUser curUser] userTypeByString] forKey:userTypeKey];
    [dicHr setObject:@(LyTeacherVerifyState_verifying) forKey:verifyKey];
    [dicHr setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    [dicHr setObject:btnAddress.titleLabel.text forKey:addressKey];
    [dicHr setObject:city forKey:cityKey];
    
    switch ([LyCurrentUser curUser].userType) {
        case LyUserType_normal: {
            //nothing
            break;
        }
        case LyUserType_coach: {
            [arrPic addObject:_photoSource.paCoachLicense.fullImage];
            if (_photoSource.paDriveLicense) {
                [arrPic addObject:_photoSource.paDriveLicense.fullImage];
            }
            if (_photoSource.paIdentity) {
                [arrPic addObject:_photoSource.paIdentity.fullImage];
            }
            
            [dicHr setObject:strUserName forKey:nickNameKey];
            [dicHr setObject:(btnSex.isSelected) ? @(LySexFemale) : @(LySexMale) forKey:sexKey];
            [dicHr setObject:tfCoachLicenseId.text forKey:coachLicenseIdKey];
            [dicHr setObject:tfDriveLicenseId.text forKey:driveLicenseIdKey];
            [dicHr setObject:tfIdentityId.text forKey:identityIdKey];
            [dicHr setObject:_curSchool.userId forKey:masterIdKey];
            [dicHr setObject:_curSchool.userId forKey:schoolIdKey];
            [dicHr setObject:_curTrainBase.tbId forKey:trainBaseIdKey];
            [dicHr setObject:[LyCurrentUser curUser].userId forKey:coachIdKey];
            break;
        }
        case LyUserType_school: {
            [arrPic addObject:_photoSource.paBusinessLicense.fullImage];
            
            [dicHr setObject:tfFullName.text forKey:fullNameKey];
            [dicHr setObject:strUserName forKey:nickNameKey];
            [dicHr setObject:tfBusinessLicenseId.text forKey:businessLicenseIdKey];
            break;
        }
        case LyUserType_guider: {
            [arrPic addObject:_photoSource.paDriveLicense.fullImage];
            [arrPic addObject:_photoSource.paIdentity.fullImage];
            
            [dicHr setObject:strUserName forKey:nickNameKey];
            [dicHr setObject:(btnSex.isSelected) ? @(LySexFemale) : @(LySexMale) forKey:sexKey];
            [dicHr setObject:tfDriveLicenseId.text forKey:driveLicenseIdKey];
            [dicHr setObject:tfIdentityId.text forKey:identityIdKey];
            break;
        }
    }
    
    
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:authInfoHttpMethod_commit];
    [hr setDelegate:self];
    bHttpFlag = [hr uploadCertification:uploadCertification_url
                                   image:arrPic
                                   body:dicHr
                                userType:[LyCurrentUser curUser].userType];
}

- (void)handleHttpFailed {
    if ([indicator isAnimating]) {
        [indicator stopAnimation];
        
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"提交失败"] show];
    }
}

- (void)analysisHttpResult:(NSString *)result {
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
        [indicator stopAnimation];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch (curHttpMethod) {
        case authInfoHttpMethod_commit: {
            switch ([strCode integerValue]) {
                case 0: {
                    [indicator stopAnimation];
                    
                    [[LyCurrentUser curUser] setVerifyState:LyTeacherVerifyState_null];
                    
                    LyVerifyProgressViewController *verifyProgress = [[LyVerifyProgressViewController alloc] init];
                    [self.navigationController pushViewController:verifyProgress animated:YES];
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
    if (bHttpFlag) {
        bHttpFlag = NO;
        [self handleHttpFailed];
    }
    
    curHttpMethod = 0;
}

- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result {
    if (bHttpFlag) {
        bHttpFlag = NO;
        curHttpMethod = ahttpRequest.mode;
        [self analysisHttpResult:result];
    }
    
    curHttpMethod = 0;
}


#pragma mark -LyAddressAlertViewDelegate
- (void)addressAlertView:(LyAddressAlertView *)aAddressAlertView onClickButtonDone:(BOOL)isDone {
    
    [aAddressAlertView hide];
    
    if (isDone) {
        [btnAddress setTitle:aAddressAlertView.address forState:UIControlStateNormal];
        city = aAddressAlertView.city;
        if ([city containsString:@"市"]) {
            city = [city substringToIndex:city.length - 1];
        }
        
        [self validate:NO];
    }
}


#pragma mark -LyChooseSchoolTableViewControllerDelegate
- (NSString *)obtainAddressInfoByChooseSchoolTableViewController:(LyChooseSchoolTableViewController *)aChooseSchoolTableViewContoller {
    return btnAddress.titleLabel.text;
}

- (void)onSelectedDriveSchoolByChooseSchoolTableViewController:(LyChooseSchoolTableViewController *)aChooseSchoolTableViewContoller andSchool:(LyDriveSchool *)dsch {
    
    [aChooseSchoolTableViewContoller.navigationController popViewControllerAnimated:YES];
    [self setCurSchool:dsch];
    
    [self validate:NO];
}


#pragma mark -LyChooseTrainBaseTableViewControllerDelegate
- (NSString *)obtainSchoolIdByChooseTrainBaseTVC:(LyChooseTrainBaseTableViewController *)aChooseTrainBaseTVC {
    return _curSchool.userId;
}

- (void)onDoneByChooseTrainBase:(LyChooseTrainBaseTableViewController *)aChooseTrainBaseVC trainBase:(LyTrainBase *)aTrainBase {
    
    [aChooseTrainBaseVC.navigationController popViewControllerAnimated:YES];
    [self setCurTrainBase:aTrainBase];
    
    [self validate:NO];
}


#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([tfCoachLicenseId isFirstResponder]) {
        [tfCoachLicenseId resignFirstResponder];
        [tfDriveLicenseId becomeFirstResponder];
    } else if ([tfDriveLicenseId isFirstResponder]) {
        [tfDriveLicenseId resignFirstResponder];
        [tfIdentityId becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (authInfoTextFieldTag_briefName == textField.tag) {
        
        if (tfBriefName.text.length > 0) {
            if ([tfBriefName.text validateName]) {
                [tfBriefName setTextColor:LyBlackColor];
            } else {
                [tfBriefName setTextColor:LyWarnColor];
                NSString *strRemindTitle = @"姓名姓式错误";
                if (LyUserType_school == [LyCurrentUser curUser].userType) {
                    strRemindTitle = @"驾校简称格式错误";
                }
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:strRemindTitle] show];
            }
        }
        
    } else if (authInfoTextFieldTag_coachLicenseId == textField.tag) {
        
        
    } else if (authInfoTextFieldTag_driveLicenseId == textField.tag) {
        
        if (tfDriveLicenseId.text.length > 0) {
            if ([tfDriveLicenseId.text validateIdCar]) {
                [tfDriveLicenseId setTextColor:LyBlackColor];
            } else {
                [tfDriveLicenseId setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"驾驶证号格式错误"] show];
            }
        }
        
    } else if (authInfoTextFieldTag_identityId == textField.tag) {
        
        if (tfIdentityId.text.length > 0) {
            if ([tfIdentityId.text validateIdCar]) {
                [tfIdentityId setTextColor:LyBlackColor];
            } else {
                [tfIdentityId setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"身份证号格式错误"] show];
            }
        }
        
    } else if (authInfoTextFieldTag_fullName == textField.tag) {
        
        if (tfFullName.text.length > 0) {
            if ([tfFullName.text validateName]) {
                [tfFullName setTextColor:LyBlackColor];
            } else {
                [tfFullName setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"驾校全名格式错误"] show];
            }
        }
        
    } else if (authInfoTextFieldTag_businessLicenseId == textField.tag) {
        
        
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (authInfoTextFieldTag_fullName == textField.tag) {
        if (textField.text.length + string.length > LyNameLengthMax) {
            return NO;
        }
        
    } else if (authInfoTextFieldTag_briefName == textField.tag) {
        if (textField.text.length + string.length > LyNameLengthMax) {
            return NO;
        }
        
    }
    
    return YES;
}


#pragma mark -UIKeyboardWillShowNotification
- (void)targetForNotificationFromUIKeyboardWillShowNotification:(NSNotification *)notifi {
    CGFloat fHeightKeyboard = CGRectGetHeight([[[notifi userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]);
    CGFloat fHeightKeyboardOnScreen = (SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT - fHeightKeyboard);
    CGFloat offsetY = 0;
    if ([tfBriefName isFirstResponder]) {
        offsetY = (viewInfo.ly_y + tfBriefName.ly_y + CGRectGetHeight(tfBriefName.frame)) - fHeightKeyboardOnScreen + LyViewItemHeight;
        
    } else if ([tfCoachLicenseId isFirstResponder]) {
        offsetY = (viewInfo.ly_y + tfCoachLicenseId.ly_y + CGRectGetHeight(tfCoachLicenseId.frame)) - fHeightKeyboardOnScreen + LyViewItemHeight;
        
    } else if ([tfDriveLicenseId isFirstResponder]) {
        offsetY = (viewInfo.ly_y + tfDriveLicenseId.ly_y + CGRectGetHeight(tfDriveLicenseId.frame)) - fHeightKeyboardOnScreen + LyViewItemHeight;
        
    } else if ([tfIdentityId isFirstResponder]) {
        offsetY = (viewInfo.ly_y + tfIdentityId.ly_y + CGRectGetHeight(tfIdentityId.frame)) - fHeightKeyboardOnScreen + LyViewItemHeight;
        
    } else if ([tfFullName isFirstResponder]) {
        offsetY = (viewInfo.ly_y + tfFullName.ly_y + CGRectGetHeight(tfFullName.frame)) - fHeightKeyboardOnScreen + LyViewItemHeight;
        
    } else if ([tfBusinessLicenseId isFirstResponder]) {
        offsetY = (viewInfo.ly_y + tfBusinessLicenseId.ly_y + CGRectGetHeight(tfBusinessLicenseId.frame)) - fHeightKeyboardOnScreen + LyViewItemHeight;
    }
    
    if (offsetY > 0) {
        [svMain setContentOffset:CGPointMake(0, offsetY)];
    }
}

#pragma mark -UIKeyboardWillHideNotification
- (void)targetForNotificationFromUIKeyboardWillHideNotification:(NSNotification *)notifi {
    
    CGFloat offsetY = svMain.contentOffset.y > - svMain.contentSize.height - CGRectGetHeight(svMain.frame);
    if (offsetY > 0) {
        [svMain setContentOffset:CGPointMake(0, offsetY)];
    }
}


#pragma mark -UITextFieldTextDidChangeNotification
- (void)targetForNotificationFormUITextFieldTextDidChangeNotification:(NSNotification *)notifi {
    if ([notifi.object isKindOfClass:[UITextField class]]) {
        [self validate:NO];
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
