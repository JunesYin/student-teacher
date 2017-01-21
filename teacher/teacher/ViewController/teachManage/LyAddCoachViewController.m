//
//  LyAddCoachViewController.m
//  teacher
//
//  Created by Junes on 16/8/13.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyAddCoachViewController.h"

#import "LyDriveLicensePicker.h"
#import "LyAddressPicker.h"
#import "LyToolBar.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyUserManager.h"
#import "LyTrainBase.h"

#import "NSString+Validate.h"
#import "UILabel+LyTextAlignmentLeftAndRight.h"

#import "LyUtil.h"


#import "LyChooseSchoolTableViewController.h"
#import "LyChooseTrainBaseTableViewController.h"


typedef NS_ENUM(NSInteger, LyAddCoachBarButtonItem) {
    addCoachBarButtonItemTag_add = 0,
};

typedef NS_ENUM(NSInteger, LyAddCoachTextFieldMode)
{
    addCoachTextFieldMode_name = 10,
    addCoachTextFieldMode_phone,
};

typedef NS_ENUM(NSInteger, LyAddCoachButtonMode)
{
    addCoachButtonMode_sex = 20,
    addCoachButtonMode_license,
    addCoachButtonMode_city,
    addCoachButtonMode_school,
    addCoachButtonMode_trainBase
};


typedef NS_ENUM(NSInteger, LyAddCoachActionSheetMode)
{
    addCoachActionSheetMode_sex = 30,
};


typedef NS_ENUM(NSInteger, LyAddCoachHttpMethod) {
    addCoachHttpMethod_add = 100,
};




NSString *const btnSexDefaultTitle = @"请选择教练姓别";
NSString *const btnLicenseDefaultTitle = @"请选择驾照类型";
NSString *const btnCityDefaultTitle = @"请选择所在城市";
NSString *const btnSchoolDefaultTitle = @"请选择所属驾校";
NSString *const btnTrainBaseDefaultTitle = @"请选择培训基地";



@interface LyAddCoachViewController () <UITextFieldDelegate, LyDriveLicensePickerDelegate, LyAddressPickerDelegate, LyChooseTrainBaseTableViewControllerDelegate, LyHttpRequestDelegate, LyRemindViewDelegate, LyChooseSchoolTableViewControllerDelegate>
{
    UIBarButtonItem                 *bbiAdd;
    
    UIScrollView                    *svMain;
    
    //姓名
    UIView                          *viewhName;
    UITextField                     *tfName;
    //性别
    UIView                          *viewSex;
    UIButton                        *btnSex;
    //电话
    UIView                          *viewPhone;
    UITextField                     *tfPhone;
    //驾照类型
    UIView                          *viewLicense;
    UIButton                        *btnLicense;
    //城市
    UIView                          *viewCity;
    UIButton                        *btnCity;
    //驾校
    UIView                          *viewSchool;
    UIButton                        *btnSchool;
    //基地
    UIView                          *viewTrainBase;
    UIButton                        *btnTrainBase;
    
    
    LyLicenseType                   curLicense;
    NSString                        *curAddress;
    LyDriveSchool                   *curSchool;
    LyTrainBase                     *curTrainBase;
    
    
    LyIndicator                     *indicator_oper;
    BOOL                            bHttpFlag;
    LyAddCoachHttpMethod            curHttpMethod;
}
@end

@implementation LyAddCoachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}



- (void)initAndLayoutSubviews
{
    self.title = @"添加教练";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    bbiAdd = [[UIBarButtonItem alloc] initWithTitle:@"添加"
                                              style:UIBarButtonItemStyleDone
                                             target:self
                                             action:@selector(targetForBarButtonItem:)];
    [self.navigationItem setRightBarButtonItem:bbiAdd];
    
    //教练姓名
    viewhName = [[UIView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, LyViewItemHeight)];
    [viewhName setBackgroundColor:[UIColor whiteColor]];
    //教练姓名-标题
    UILabel *lbTitle_name = [self lbTitleWithTitle:@"教练姓名"];
    //教练姓名-输入框
    tfName = [self tfContentWithMode:addCoachTextFieldMode_name placeholder:@"请输入教练姓名"];
    [tfName setReturnKeyType:UIReturnKeyNext];
    
    [viewhName addSubview:lbTitle_name];
    [viewhName addSubview:tfName];
    
    
    //教练电话
    viewPhone = [[UIView alloc] initWithFrame:CGRectMake(0, viewhName.ly_y+CGRectGetHeight(viewhName.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewPhone setBackgroundColor:[UIColor whiteColor]];
    //教练电话-标题
    UILabel *lbtitle_phone = [self lbTitleWithTitle:@"教练手机"];
    //教练电话-输入框
    tfPhone = [self tfContentWithMode:addCoachTextFieldMode_phone placeholder:@"请输入教练电话"];
    [tfPhone setReturnKeyType:UIReturnKeyDone];
    [tfPhone setKeyboardType:UIKeyboardTypePhonePad];
    [tfPhone setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfPhone]];
    
    [viewPhone addSubview:lbtitle_phone];
    [viewPhone addSubview:tfPhone];
    
    
    //教练姓别
    viewSex = [[UIView alloc] initWithFrame:CGRectMake(0, viewPhone.ly_y+CGRectGetHeight(viewPhone.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewSex setBackgroundColor:[UIColor whiteColor]];
    //教练姓别-标题
    UILabel *lbtitle_sex = [self lbTitleWithTitle:@"教练姓别"];
    //教练姓别-按钮
    btnSex = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-LyViewItemHeight*2, 0, LyViewItemHeight*2, LyViewItemHeight)];
    [btnSex setImage:[LyUtil imageForImageName:@"sexPick_male" needCache:NO] forState:UIControlStateNormal];
    [btnSex setImage:[LyUtil imageForImageName:@"sexPick_female" needCache:NO] forState:UIControlStateSelected];
    [btnSex setTag:addCoachButtonMode_sex];
    [btnSex addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewSex addSubview:lbtitle_sex];
    [viewSex addSubview:btnSex];
    
    
    //驾照类型
    viewLicense = [[UIView alloc] initWithFrame:CGRectMake(0, viewSex.ly_y+CGRectGetHeight(viewSex.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewLicense setBackgroundColor:[UIColor whiteColor]];
    //驾照类型-标题
    UILabel *lbTitle_license = [self lbTitleWithTitle:@"所教驾照"];
    //驾照类型-按钮
    btnLicense = [self btnContentWithMode:addCoachButtonMode_license defaultTitle:btnLicenseDefaultTitle];
    
    [viewLicense addSubview:lbTitle_license];
    [viewLicense addSubview:btnLicense];
    
    
    //城市
    viewCity = [[UIView alloc] initWithFrame:CGRectMake(0, viewLicense.ly_y+CGRectGetHeight(viewLicense.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewCity setBackgroundColor:[UIColor whiteColor]];
    //城市-标题
    UILabel *lbTitle_city = [self lbTitleWithTitle:@"所在城市"];
    //城市-按钮
    btnCity = [self btnContentWithMode:addCoachButtonMode_city defaultTitle:btnCityDefaultTitle];
    
    [viewCity addSubview:lbTitle_city];
    [viewCity addSubview:btnCity];
    
    //驾校
    if (LyUserType_coach == [LyCurrentUser curUser].userType) {
        viewSchool = [[UIView alloc] initWithFrame:CGRectMake(0, viewCity.ly_y+CGRectGetHeight(viewCity.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
        [viewSchool setBackgroundColor:[UIColor whiteColor]];
        UILabel *lbTitle_school = [self lbTitleWithTitle:@"所属驾校"];
        btnSchool = [self btnContentWithMode:addCoachButtonMode_school defaultTitle:btnSchoolDefaultTitle];
        
        [viewSchool addSubview:lbTitle_school];
        [viewSchool addSubview:btnSchool];
    } else {
        viewSchool = [[UIView alloc] initWithFrame:CGRectMake(0, viewCity.ly_y+CGRectGetHeight(viewCity.frame)+0, CGRectGetWidth(viewCity.frame), 0)];
    }
    
    
    //基地
    viewTrainBase = [[UIView alloc] initWithFrame:CGRectMake(0, viewSchool.ly_y+CGRectGetHeight(viewSchool.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewTrainBase setBackgroundColor:[UIColor whiteColor]];
    //基地-标题
    UILabel *lbTitle_trainBase = [self lbTitleWithTitle:@"所在基地"];
    //基地-按钮
    btnTrainBase = [self btnContentWithMode:addCoachButtonMode_trainBase defaultTitle:btnTrainBaseDefaultTitle];
    
    [viewTrainBase addSubview:lbTitle_trainBase];
    [viewTrainBase addSubview:btnTrainBase];
    
    
    
    [self.view addSubview:viewhName];
    [self.view addSubview:viewPhone];
    [self.view addSubview:viewSex];
    [self.view addSubview:viewLicense];
    [self.view addSubview:viewCity];
    [self.view addSubview:viewSchool];
    [self.view addSubview:viewTrainBase];

    
    
    [bbiAdd setEnabled:NO];
    if (LyUserType_school == [LyCurrentUser curUser].userType) {
        curSchool = [LyCurrentUser curUser];
    }
}



- (UILabel *)lbTitleWithTitle:(NSString *)title
{
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, LyLbTitleItemWidth, LyLbTitleItemHeight)];
    [lbTitle setFont:LyLbTitleItemFont];
    [lbTitle setTextColor:[UIColor blackColor]];
    [lbTitle setText:title];
//    [lbTitle justifyTextAlignmentLeftAndRight];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    
    return lbTitle;
}


- (UITextField *)tfContentWithMode:(LyAddCoachTextFieldMode)mode placeholder:(NSString *)placeholder
{
    UITextField *tfContet = [[UITextField alloc] initWithFrame:CGRectMake(horizontalSpace*2+LyLbTitleItemWidth, 0, SCREEN_WIDTH-horizontalSpace*3-LyLbTitleItemWidth, LyViewItemHeight)];
    [tfContet setFont:LyFont(14)];
    [tfContet setTextColor:LyBlackColor];
    [tfContet setTextAlignment:NSTextAlignmentRight];
    [tfContet setDelegate:self];
    [tfContet setTag:mode];
    [tfContet setPlaceholder:placeholder];
    [tfContet setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfContet setEnablesReturnKeyAutomatically:YES];
    
    return tfContet;
}


- (UIButton *)btnContentWithMode:(LyAddCoachButtonMode)mode defaultTitle:(NSString *)defaultTitle
{
    UIButton *btnContent = [[UIButton alloc] initWithFrame:CGRectMake(horizontalSpace*2+LyLbTitleItemWidth, 0, SCREEN_WIDTH-horizontalSpace*3-LyLbTitleItemWidth, LyViewItemHeight)];
    [btnContent setTag:mode];
    [btnContent.titleLabel setFont:LyFont(14)];
    [btnContent setTitleColor:LyBlackColor forState:UIControlStateNormal];
    [btnContent setTitle:defaultTitle forState:UIControlStateNormal];
    [btnContent setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnContent addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return btnContent;
}


- (void)allControlResignFirstResponder {
    [tfName resignFirstResponder];
    [tfPhone resignFirstResponder];
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    if (addCoachBarButtonItemTag_add == bbi.tag) {
        [self addCoach];
    }
}


- (void)targetForButton:(UIButton *)button {
    
    [self allControlResignFirstResponder];
    
    LyAddCoachButtonMode btnTag = button.tag;
    switch (btnTag) {
        case addCoachButtonMode_sex: {
            [btnSex setSelected:!btnSex.isSelected];
            break;
        }
        case addCoachButtonMode_license: {
            LyDriveLicensePicker *licensePicker = [LyDriveLicensePicker driveLicensePicker];
            [licensePicker setDelegate:self];
            [licensePicker setInitDriveLicense:curLicense];
            [licensePicker show];
            break;
        }
        case addCoachButtonMode_city: {
            LyAddressPicker *addressPicker = [LyAddressPicker addressPickerWithMode:LyAddressPickerMode_provinceAndCity];
            [addressPicker setDelegate:self];
            if (![btnCity.titleLabel.text isEqualToString:btnCityDefaultTitle]) {
                [addressPicker setAddress:btnCity.titleLabel.text];
            }
            [addressPicker show];
            break;
        }
        case addCoachButtonMode_school: {
            if ([btnCity.titleLabel.text isEqualToString:btnCityDefaultTitle]) {
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没选择城市"] show];
                return;
            }
            
            LyChooseSchoolTableViewController *chooseSchool = [[LyChooseSchoolTableViewController alloc] init];
            [chooseSchool setDelegate:self];
            [self.navigationController pushViewController:chooseSchool animated:YES];
            break;
        }
        case addCoachButtonMode_trainBase: {
            if ([btnCity.titleLabel.text isEqualToString:btnCityDefaultTitle]) {
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没选择城市"] show];
                return;
            }
            
            if (LyUserType_coach == [LyCurrentUser curUser].userType) {
                if ([btnSchool.titleLabel.text isEqualToString:btnSchoolDefaultTitle]) {
                    [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没选择驾校"] show];
                    return;
                }
            }
            
            LyChooseTrainBaseTableViewController *chooseTrainBase = [[LyChooseTrainBaseTableViewController alloc] init];
            [chooseTrainBase setMode:LyChooseTrainBaseTableViewControllerMode_school];
            [chooseTrainBase setDelegate:self];
            [self.navigationController pushViewController:chooseTrainBase animated:YES];
            break;
        }
    }
}



- (BOOL)validate:(BOOL)flag{
    
    if (tfName.text.length < 1) {
        if (flag) {
            [tfName setTextColor:LyWarnColor];
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"教练姓名格式错误"] show];
        }
        return NO;
    } else {
        [tfName setTextColor:LyBlackColor];
    }
    
    if (![tfPhone.text validatePhoneNumber]) {
        if (flag) {
            [tfPhone setTextColor:LyWarnColor];
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号格式错误"] show];
        }
        return NO;
    } else {
        [tfPhone setTextColor:LyBlackColor];
    }
    
    if ([btnLicense.titleLabel.text isEqualToString:btnLicenseDefaultTitle]) {
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"驾照类型格式错误"] show];
        }
        return NO;
    }
    
    if ([btnCity.titleLabel.text isEqualToString:btnCityDefaultTitle]) {
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"城市格式错误"] show];
        }
        return NO;
    }
    
    if (LyUserType_coach == [LyCurrentUser curUser].userType) {
        if (!curSchool || [btnSchool.titleLabel.text isEqualToString:btnSchoolDefaultTitle]) {
            if (flag) {
                [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"驾校格式错误"] show];
            }
            return NO;
        }
    }
    
    if (!curTrainBase || [btnTrainBase.titleLabel.text isEqualToString:btnTrainBaseDefaultTitle]) {
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"基地格式错误"] show];
        }
        return NO;
    }
    
    [bbiAdd setEnabled:YES];
    
    return YES;
}


- (void)setCurLicense:(LyLicenseType)newLicense {
    curLicense = newLicense;
    
    [btnLicense setTitle:[LyUtil driveLicenseStringFrom:curLicense] forState:UIControlStateNormal];
    
    [bbiAdd setEnabled:[self validate:NO]];
}


- (void)setCurAddress:(NSString *)newAddress {
    curAddress = newAddress;
    
    [btnCity setTitle:curAddress forState:UIControlStateNormal];
    
    [bbiAdd setEnabled:[self validate:NO]];
}


- (void)setCurSchool:(LyDriveSchool *)newSchool {
    curSchool = newSchool;
    
    [btnSchool setTitle:curSchool.userName forState:UIControlStateNormal];
    
    [bbiAdd setEnabled:[self validate:NO]];
}

- (void)setCurTrainBase:(LyTrainBase *)newTrainBase {
    curTrainBase = newTrainBase;
    
    [btnTrainBase setTitle:curTrainBase.tbName forState:UIControlStateNormal];
    
    [bbiAdd setEnabled:[self validate:NO]];
}



- (void)addCoach {
    if (![self validate:YES]) {
        return;
    }
    
    if (!indicator_oper) {
        indicator_oper = [LyIndicator indicatorWithTitle:LyIndicatorTitle_add];
    }
    else {
        [indicator_oper setTitle:LyIndicatorTitle_add];
    }
    [indicator_oper startAnimation];
    
    
    NSString *strUserName = tfName.text;
    NSString *strUserNameSuffix = [LyUtil userTypeChineseStringFrom:LyUserType_coach];
    if ([strUserName rangeOfString:strUserNameSuffix].length < 1) {
        strUserName = [strUserName stringByAppendingString:strUserNameSuffix];
    }
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:strUserName forKey:nickNameKey];
    [dic setObject:tfPhone.text forKey:phoneKey];
    [dic setObject:(btnSex.isSelected) ? @(LySexFemale) : @(LySexMale) forKey:sexKey];
    [dic setObject:@(curLicense) forKey:driveLicenseKey];
    [dic setObject:curTrainBase.tbId forKey:trainBaseIdKey];
    
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    
    if (LyUserType_school == [LyCurrentUser curUser].userType) {
        [dic setObject:[LyCurrentUser curUser].userId forKey:masterIdKey];
        [dic setObject:[LyCurrentUser curUser].userId forKey:schoolIdKey];
        [dic setObject:@(LyCoachMode_normal) forKey:coachModeKey];
    }
    else if (LyUserType_coach == [LyCurrentUser curUser].userType) {
        [dic setObject:curSchool.userId forKey:masterIdKey];
        [dic setObject:[LyCurrentUser curUser].userId forKey:bossKey];
        [dic setObject:@(LyCoachMode_staff) forKey:coachModeKey];
    }
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:addCoachHttpMethod_add];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:addCoach_url
                                 body:dic
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)handleHttpFailed {
    if ([indicator_oper isAnimating]) {
        [indicator_oper stopAnimation];
        if ([indicator_oper.title isEqualToString:LyIndicatorTitle_add]) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"添加失败"] show];
        }
    }
}


- (void)analysisHttpResult:(NSString *)result {
    NSDictionary *dic = [LyUtil getObjFromJson:result];
    if (!dic || ![LyUtil validateDictionary:dic]) {
        [self handleHttpFailed];
        return;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (!strCode || ![LyUtil validateString:strCode]) {
        [self handleHttpFailed];
        return;
    }
    
    if (codeTimeOut == [strCode integerValue]) {
        [indicator_oper stopAnimation];
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_oper stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch (curHttpMethod) {
        case addCoachHttpMethod_add: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (!dicResult || ![LyUtil validateDictionary:dicResult]) {
                        [indicator_oper stopAnimation];
                        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"添加失败"] show];
                        
                        return;
                    }
                    
                    NSString *strId = [dicResult objectForKey:coachIdKey];
                    NSString *strName = [dicResult objectForKey:nickNameKey];
                    NSString *strPhone = [dicResult objectForKey:phoneKey];
                    NSString *strSex = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:sexKey]];
                    NSString *strTrainBaseId = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:trainBaseIdKey]];
                    
                    LyCoach *coach = [[LyUserManager sharedInstance] getCoachWithCoachId:strId];
                    if (!coach) {
                        coach = [LyCoach coachWithId:strId
                                                name:strName];
                        
                        [[LyUserManager sharedInstance] addUser:coach];
                    }
                    
                    [coach setUserPhoneNum:strPhone];
                    [coach setUserSex:[strSex integerValue]];
                    [coach setTrainBaseId:strTrainBaseId];
                    [coach setTrainBaseName:curTrainBase.tbName];
                
                    if (LyUserType_school == [LyCurrentUser curUser].userType) {
                        [coach setMasterId:[LyCurrentUser curUser].userId];
                    } else if (LyUserType_coach == [LyCurrentUser curUser].userType) {
                        [coach setMasterId:curSchool.userId];
                        [coach setBossId:[LyCurrentUser curUser].userId];
                    }
                    
                    [indicator_oper stopAnimation];
                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"添加成功"];
                    [remind setDelegate:self];
                    [remind show];
                    
                    break;
                }
                case 1: {
                    [indicator_oper stopAnimation];
                    
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"该教练已有所属驾校"] show];
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


#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(LyRemindView *)aRemind {
    [_delegate onDoneByAddCoachVC:self];
}


#pragma mark -LyDriveLicensePicker
- (void)onDriveLicensePickerCancel:(LyDriveLicensePicker *)picker {
    [picker hide];
}

- (void)onDriveLicensePickerDone:(LyDriveLicensePicker *)picker license:(LyLicenseType)license {
    [picker hide];
    
    [self setCurLicense:license];
}



#pragma mark -LyAddressPickerDelegate
- (void)onAddressPickerCancel:(LyAddressPicker *)addressPicker {
    [addressPicker hide];
}

- (void)onAddressPickerDone:(NSString *)address addressPicker:(LyAddressPicker *)addressPicker {
    [addressPicker hide];

    [self setCurAddress:address];
}


#pragma mark -LyChooseSchoolTableViewControllerDelegate
- (NSString *)obtainAddressInfoByChooseSchoolTableViewController:(LyChooseSchoolTableViewController *)aChooseSchoolTableViewContoller
{
    return curAddress;
}

- (void)onSelectedDriveSchoolByChooseSchoolTableViewController:(LyChooseSchoolTableViewController *)aChooseSchoolTableViewContoller andSchool:(LyDriveSchool *)dsch
{
    [aChooseSchoolTableViewContoller.navigationController popViewControllerAnimated:YES];
    [self setCurSchool:dsch];
}


#pragma mark -LyChooseTrainBaseTableViewControllerDelegate
- (NSString *)obtainAddressByChooseTrainBaseTVC:(LyChooseTrainBaseTableViewController *)aChooseTrainBaseTVC {
    return btnCity.titleLabel.text;
}

- (NSString *)obtainSchoolIdByChooseTrainBaseTVC:(LyChooseTrainBaseTableViewController *)aChooseTrainBaseTVC {
    NSString *strSchoolId;
    if (LyUserType_school == [LyCurrentUser curUser].userType) {
        strSchoolId = [LyCurrentUser curUser].userId;
    } else {
        strSchoolId = curSchool.userId;
    }
    
    return strSchoolId;
}

//- (NSDictionary *)obtainInfoByChooseTrainBaseTVC:(LyChooseTrainBaseTableViewController *)aChooseTrainBaseTVC {
//    return @{
//             addressKey:btnCity.titleLabel.text,
//             schoolIdKey:curSchool.userId,
//             };
//}

- (void)onDoneByChooseTrainBase:(LyChooseTrainBaseTableViewController *)aChooseTrainBaseVC trainBase:(LyTrainBase *)aTrainBase {
    
    [self setCurTrainBase:aTrainBase];
    [aChooseTrainBaseVC.navigationController popViewControllerAnimated:YES];
}


#pragma mark -UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (addCoachTextFieldMode_name == textField.tag) {
        
        if (tfName.text.length > 0) {
            if ([tfName.text validateName]) {
                [tfName setTextColor:LyBlackColor];
            } else {
                [tfName setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"姓名格式错误"] show];
            }
        }
    }
    else if (addCoachTextFieldMode_phone == textField.tag) {
        if (tfPhone.text.length > 0) {
            if ([tfPhone.text validatePhoneNumber]) {
                [tfPhone setTextColor:LyBlackColor];
            } else {
                [tfPhone setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"手机号格式错误"] show];
            }
        }
        
        [bbiAdd setEnabled:[self validate:NO]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (addCoachTextFieldMode_name == textField.tag) {
        [tfName resignFirstResponder];
        [tfPhone performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.01f];
        
        [bbiAdd setEnabled:[self validate:NO]];
        
        return YES;
    } else if (addCoachTextFieldMode_phone == textField.tag) {
        [tfPhone resignFirstResponder];
        
        [bbiAdd setEnabled:[self validate:NO]];
        
        return YES;
    }
    
    return YES;
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
