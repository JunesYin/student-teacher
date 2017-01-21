//
//  LyAddStudentManuallyViewController.m
//  teacher
//
//  Created by Junes on 16/8/18.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyAddStudentManuallyViewController.h"


#import "LyPayInfoPicker.h"
#import "LyAddressPicker.h"
#import "LyAddressAlertView.h"
#import "LyStudyProgressPicker.h"

#import "LyToolBar.h"
#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyTrainClass.h"

#import "LyCurrentUser.h"
#import "LyStudentManager.h"

#import "UILabel+LyTextAlignmentLeftAndRight.h"
#import "NSString+Validate.h"

#import "LyUtil.h"

#import "LyChooseTrainClassTableViewController.h"



NSString *const asmNameKey = @"name";
NSString *const asmPhoneKey = @"phone";


enum {
    addStudentManuallyBarButtonItemTag_add,
}LyAddStudentManuallyBarButtonItemTag;


typedef NS_ENUM(NSInteger, LyAddStudentManuallyTextFieldMode)
{
    addStudentManuallyTextFieldMode_name = 10,
    addStudentManuallyTextFieldMode_phone,
};


typedef NS_ENUM(NSInteger, LyAddStudentManuallyButtonMode)
{
    addStudentManuallyButtonMode_census = 20,
    addStudentManuallyButtonMode_address,
    addStudentManuallyButtonMode_trainClassName,
    addStudentManuallyButtonMode_payInfo,
    addStudentManuallyButtonMode_studyProgress
};


typedef NS_ENUM(NSInteger, LyAddStudentManuallyTextViewMode)
{
    addStudentManuallyTextViewMode_remark = 30,
};


typedef NS_ENUM(NSInteger, LyAddStudentManuallyHttpMethod)
{
    addStudentManuallyHttpMethod_add = 100,
};


NSString *const btnCensusDefaultTitle = @"请选择学员户籍";
NSString *const btnAddressDefaultTitle = @"请选接送地址";
NSString *const btnTrainClassNameDefaultTitle = @"请选择培训课程";
NSString *const btnPayInfoDefaultTitle = @"请选择付款情况";
NSString *const btnStudyProgressDefaultTitle = @"请选择学车进度";


@interface LyAddStudentManuallyViewController () <UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate, LyPayInfoPickerDelegate, LyAddressPickerDelegate, LyAddressAlertViewDelegate, LyStudyProgressPickerDelegate, LyRemindViewDelegate, LyHttpRequestDelegate, LyChooseTrainClassTableViewControllerDelegate>
{
    BOOL                    flagObtain;
    
    UIBarButtonItem         *bbiAdd;
    
    UIScrollView            *svMain;
    
    UITextField             *tfName;
    UITextField             *tfPhone;
    UIButton                *btnCensus;
    UIButton                *btnAddress;
    UIButton                *btnTrainClassName;
    UIButton                *btnPayInfo;
    UIButton                *btnStudyProgress;
    
    UIView                  *viewRemark;
    UITextView              *tvRemark;
    
    
    LyPayInfo               curPayInfo;
    LySubjectMode           curSubjectMode;
    
    
    LyIndicator             *indicator_add;
    
    LyAddStudentManuallyHttpMethod curHttpMethod;
    BOOL                    bHttpFlag;
}
@end

@implementation LyAddStudentManuallyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}


- (void)viewWillAppear:(BOOL)animated {
    
    if (!flagObtain && LyAddStudentManuallyViewControllerMode_addressBook == _mode) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(obtainStudentInfoByAddStudentManuallyViewController:)]) {
            
            NSDictionary *dic = [_delegate obtainStudentInfoByAddStudentManuallyViewController:self];
            if (!dic || dic.count < 2) {
                return;
            }
            
            [tfName setText:[dic objectForKey:asmNameKey]];
            [tfPhone setText:[dic objectForKey:asmPhoneKey]];
        }

        flagObtain = YES;
    }
    
    
    [self addObserverForNotificationFromUIKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self removeObserverForNotificationFromUIKeyboard];
}


- (void)initAndLayoutSubviews
{
    //navigationbar
    self.title = @"添加学员";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    

    bbiAdd = [[UIBarButtonItem alloc] initWithTitle:@"添加"
                                               style:UIBarButtonItemStyleDone
                                              target:self
                                              action:@selector(targetForBarButtonItem:)];
    [bbiAdd setTag:addStudentManuallyBarButtonItemTag_add];
    [self.navigationItem setRightBarButtonItem:bbiAdd];
    
    
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT)];
    [svMain setDelegate:self];
    [svMain setBackgroundColor:LyWhiteLightgrayColor];
    [self.view addSubview:svMain];
    
    //姓名
    UIView *viewName = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LyViewItemHeight)];
    [viewName setBackgroundColor:[UIColor whiteColor]];
    UILabel *lbTitle_name = [self lbTitleWithTitle:@"姓名"];
    tfName = [self tfContentWithMode:addStudentManuallyTextFieldMode_name pleaceholder:@"请输入学员姓名"];
    [tfName setReturnKeyType:UIReturnKeyNext];
    
    [viewName addSubview:lbTitle_name];
    [viewName addSubview:tfName];
    
    
    //电话
    UIView *viewPhone = [[UIView alloc] initWithFrame:CGRectMake(0, viewName.ly_y+CGRectGetHeight(viewName.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewPhone setBackgroundColor:[UIColor whiteColor]];
    UILabel *lbTitle_phone = [self lbTitleWithTitle:@"联系电话"];
    tfPhone = [self tfContentWithMode:addStudentManuallyTextFieldMode_phone pleaceholder:@"请输入学员联系电话"];
    [tfPhone setReturnKeyType:UIReturnKeyDone];
    [tfPhone setKeyboardType:UIKeyboardTypeNumberPad];
    [tfPhone setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfPhone]];
    
    [viewPhone addSubview:lbTitle_phone];
    [viewPhone addSubview:tfPhone];
    
    
    //户籍
    UIView *viewCensus = [[UIView alloc] initWithFrame:CGRectMake(0, viewPhone.ly_y+CGRectGetHeight(viewPhone.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewCensus setBackgroundColor:[UIColor whiteColor]];
    UILabel *lbTitle_census = [self lbTitleWithTitle:@"户籍"];
    btnCensus = [self btnContentWithMode:addStudentManuallyButtonMode_census title:btnCensusDefaultTitle];
    
    [viewCensus addSubview:lbTitle_census];
    [viewCensus addSubview:btnCensus];
    
    
    //接送地址
    UIView *viewAddress = [[UIView alloc] initWithFrame:CGRectMake(0, viewCensus.ly_y+CGRectGetHeight(viewCensus.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewAddress setBackgroundColor:[UIColor whiteColor]];
    UILabel *lbTitle_address = [self lbTitleWithTitle:@"接送地址"];
    btnAddress = [self btnContentWithMode:addStudentManuallyButtonMode_address title:btnAddressDefaultTitle];
    [btnAddress.titleLabel setNumberOfLines:0];
    
    [viewAddress addSubview:lbTitle_address];
    [viewAddress addSubview:btnAddress];
    
    
    //培训课程
    UIView *viewTrainClassName = [[UIView alloc] initWithFrame:CGRectMake(0, viewAddress.ly_y+CGRectGetHeight(viewAddress.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewTrainClassName setBackgroundColor:[UIColor whiteColor]];
    UILabel *lbTitle_trainClassName = [self lbTitleWithTitle:@"培训课程"];
    btnTrainClassName = [self btnContentWithMode:addStudentManuallyButtonMode_trainClassName title:btnTrainClassNameDefaultTitle];
    [btnTrainClassName.titleLabel setNumberOfLines:0];
    
    [viewTrainClassName addSubview:lbTitle_trainClassName];
    [viewTrainClassName addSubview:btnTrainClassName];
    
    
    //付款情况
    UIView *viewPayInfo = [[UIView alloc] initWithFrame:CGRectMake(0, viewTrainClassName.ly_y+CGRectGetHeight(viewTrainClassName.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewPayInfo setBackgroundColor:[UIColor whiteColor]];
    UILabel *lbTitle_payInfo = [self lbTitleWithTitle:@"付款情况"];
    btnPayInfo = [self btnContentWithMode:addStudentManuallyButtonMode_payInfo title:btnPayInfoDefaultTitle];
    
    [viewPayInfo addSubview:lbTitle_payInfo];
    [viewPayInfo addSubview:btnPayInfo];
    
    
    //学车进度
    UIView *viewStudyProgress = [[UIView alloc] initWithFrame:CGRectMake(0, viewPayInfo.ly_y+CGRectGetHeight(viewPayInfo.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewStudyProgress setBackgroundColor:[UIColor whiteColor]];
    UILabel *lbTitle_studyProgress = [self lbTitleWithTitle:@"学车进度"];
    btnStudyProgress = [self btnContentWithMode:addStudentManuallyButtonMode_studyProgress title:btnStudyProgressDefaultTitle];
    
    [viewStudyProgress addSubview:lbTitle_studyProgress];
    [viewStudyProgress addSubview:btnStudyProgress];
    
    
    //备注
    viewRemark = [[UIView alloc] initWithFrame:CGRectMake(0, viewStudyProgress.ly_y+CGRectGetHeight(viewStudyProgress.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight*2)];
    [viewRemark setBackgroundColor:[UIColor whiteColor]];
    UILabel *lbTitle_remark = [self lbTitleWithTitle:@"备注"];
    tvRemark = [[UITextView alloc] initWithFrame:CGRectMake(horizontalSpace*2+LyLbTitleItemWidth, CGRectGetHeight(viewRemark.frame)/2.0f-CGRectGetHeight(viewRemark.frame)*9/10.0f/2.0f, SCREEN_WIDTH-horizontalSpace*3-LyLbTitleItemWidth, CGRectGetHeight(viewRemark.frame)*9/10.0f)];
    [tvRemark setTag:addStudentManuallyTextViewMode_remark];
    [tvRemark setFont:LyFont(14)];
    [tvRemark setTextColor:[UIColor darkGrayColor]];
    [tvRemark setTextAlignment:NSTextAlignmentLeft];
    [tvRemark.layer setCornerRadius:btnCornerRadius];
    [tvRemark.layer setBorderWidth:1.0f];
    [tvRemark.layer setBorderColor:[LyWhiteLightgrayColor CGColor]];
    [tvRemark setDelegate:self];
    [tvRemark setReturnKeyType:UIReturnKeyDone];
    
    [viewRemark addSubview:lbTitle_remark];
    [viewRemark addSubview:tvRemark];
    
    
    [svMain addSubview:viewName];
    [svMain addSubview:viewPhone];
    [svMain addSubview:viewCensus];
    [svMain addSubview:viewAddress];
    [svMain addSubview:viewTrainClassName];
    [svMain addSubview:viewPayInfo];
    [svMain addSubview:viewStudyProgress];
    [svMain addSubview:viewRemark];
    
    CGFloat fCZHeight = viewRemark.ly_y + CGRectGetHeight(viewRemark.frame) + 50.0f;
    if (fCZHeight <= CGRectGetHeight(svMain.frame)) {
        fCZHeight = CGRectGetHeight(svMain.frame) * 1.05f;
    }
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, fCZHeight)];
    
    
    [bbiAdd setEnabled:NO];
}


- (UILabel *)lbTitleWithTitle:(NSString *)title
{
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, LyLbTitleItemWidth, LyViewItemHeight)];
    [lbTitle setFont:LyFont(16)];
    [lbTitle setTextColor:[UIColor blackColor]];
    [lbTitle setText:title];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    
    return lbTitle;
}

- (UITextField *)tfContentWithMode:(LyAddStudentManuallyTextFieldMode)tfMode pleaceholder:(NSString *)pleaceholder
{
    UITextField *tfContent = [[UITextField alloc] initWithFrame:CGRectMake(horizontalSpace*2+LyLbTitleItemWidth, 0, SCREEN_WIDTH-horizontalSpace*3-LyLbTitleItemWidth, LyViewItemHeight)];
    [tfContent setTag:tfMode];
    [tfContent setFont:LyFont(14)];
    [tfContent setTextColor:LyBlackColor];
    [tfContent setTextAlignment:NSTextAlignmentLeft];
    [tfContent setDelegate:self];
    [tfContent setPlaceholder:pleaceholder];
    [tfContent setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    return tfContent;
}


- (UIButton *)btnContentWithMode:(LyAddStudentManuallyButtonMode)btnMode title:(NSString *)title {
    
    UIButton *btnContent = [[UIButton alloc] initWithFrame:CGRectMake(horizontalSpace*2+LyLbTitleItemWidth, 0, SCREEN_WIDTH-horizontalSpace*3-LyLbTitleItemWidth, LyViewItemHeight)];
    [btnContent setTag:btnMode];
    [btnContent.titleLabel setFont:LyFont(14)];
    [btnContent setTitleColor:LyBlackColor forState:UIControlStateNormal];
    [btnContent setTitle:title forState:UIControlStateNormal];
    [btnContent setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnContent addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return btnContent;
}


- (void)addObserverForNotificationFromUIKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(targetForNotificationFromKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(targetForNotificationFromKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeObserverForNotificationFromUIKeyboard
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)allControlResignFirstResponder
{
    [tfName resignFirstResponder];
    [tfPhone resignFirstResponder];
    [tvRemark resignFirstResponder];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self allControlResignFirstResponder];
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    [self allControlResignFirstResponder];
    
    if (addStudentManuallyBarButtonItemTag_add == bbiAdd.tag) {
        [self add];
    }
}


- (void)targetForButton:(UIButton *)button
{
    [self allControlResignFirstResponder];
    
    switch (button.tag) {
        case addStudentManuallyButtonMode_census: {
            LyAddressPicker *addressPicker = [LyAddressPicker addressPickerWithMode:LyAddressPickerMode_provinceAndCity];
            [addressPicker setDelegate:self];
            if (![btnCensus.titleLabel.text isEqualToString:btnCensusDefaultTitle])
            {
                [addressPicker setAddress:btnCensus.titleLabel.text];
            }
            [addressPicker show];
            break;
        }
        case addStudentManuallyButtonMode_address: {
            LyAddressAlertView *addressAlertView = [[LyAddressAlertView alloc] init];
            [addressAlertView setDelegate:self];
            if (![btnAddress.titleLabel.text isEqualToString:btnAddressDefaultTitle]) {
                [addressAlertView setAddress:btnAddress.titleLabel.text];
            }
            [addressAlertView show];
            break;
        }
        case addStudentManuallyButtonMode_trainClassName: {
            LyChooseTrainClassTableViewController *chooseTrainClass = [[LyChooseTrainClassTableViewController alloc] init];
            [chooseTrainClass setDelegate:self];
            [self.navigationController pushViewController:chooseTrainClass animated:YES];
            break;
        }
        case addStudentManuallyButtonMode_payInfo: {
            LyPayInfoPicker *payInfoPicker = [[LyPayInfoPicker alloc] init];
            [payInfoPicker setDelegate:self];
            if (![btnPayInfo.titleLabel.text isEqualToString:btnPayInfoDefaultTitle]) {
                [payInfoPicker setPayInfo:curPayInfo];
            }
            [payInfoPicker show];
            break;
        }
        case addStudentManuallyButtonMode_studyProgress: {
            LyStudyProgressPicker *studyProgressPicker = [[LyStudyProgressPicker alloc] init];
            [studyProgressPicker setDelegate:self];
            if (![btnStudyProgress.titleLabel.text isEqualToString:btnStudyProgressDefaultTitle]) {
                [studyProgressPicker setCurIndex:curSubjectMode];
            }
            [studyProgressPicker show];
            break;
        }
    }
}


- (BOOL)validate:(BOOL)flag {
    
    [bbiAdd setEnabled:NO];
    
    if (![tfName.text validateName]){
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"姓名格式错误"] show];
        }
        [tfName setTextColor:LyWarnColor];
        return NO;
    }
    
    if (![tfPhone.text validatePhoneNumber]){
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号格式错误"] show];
        }
        [tfPhone setTextColor:LyWarnColor];
        return NO;
    }
    
    if ([btnCensus.titleLabel.text isEqualToString:btnCensusDefaultTitle]){
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"户籍格式错误"] show];
        }
        return NO;
    }
    
    if ([btnAddress.titleLabel.text isEqualToString:btnAddressDefaultTitle]){
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"接送地址格式错误"] show];
        }
        return NO;
    }
    
    if ([btnTrainClassName.titleLabel.text isEqualToString:btnTrainClassNameDefaultTitle]){
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"培训课程格式错误"] show];
        }
        return NO;
    }
    
    if ([btnPayInfo.titleLabel.text isEqualToString:btnPayInfoDefaultTitle]){
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"付款情况格式错误"] show];
        }
        return NO;
    }
    
    if ([btnStudyProgress.titleLabel.text isEqualToString:btnStudyProgressDefaultTitle]){
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"学车进度格式错误"] show];
        }
        return NO;
    }
    
    [bbiAdd setEnabled:YES];
    
    return YES;
}


- (void)add {
    if (![self validate:YES]){
        return;
    }
    
    if (!indicator_add) {
        indicator_add = [LyIndicator indicatorWithTitle:@"正在添加..."];
    }
    [indicator_add startAnimation];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:addStudentManuallyHttpMethod_add];
    [httpRequest setDelegate:self];
    bHttpFlag = [httpRequest startHttpRequest:addStudent_url
                                         body:@{
                                                trueNameKey:tfName.text,
                                                accountKey:tfPhone.text,
                                                phoneKey:tfPhone.text,
                                                censusKey:btnCensus.titleLabel.text,
                                                pickAddressKey:btnAddress.titleLabel.text,
                                                trainClassNameKey:btnTrainClassName.titleLabel.text,
                                                payInfoKey:@(curPayInfo),
                                                subjectModeKey:@(curSubjectMode),
                                                noteKey:tvRemark.text,
                                                masterIdKey:[LyCurrentUser curUser].userId,
                                                sessionIdKey:[LyUtil httpSessionId]
                                                }
                                         type:LyHttpType_asynPost
                                      timeOut:0];
}


- (void)handleHttpFailed {
    if ([indicator_add isAnimating]) {
        [indicator_add stopAnimation];
        LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"添加失败"];
        [remind show];
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
        [indicator_add stopAnimation];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_add stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    switch (curHttpMethod) {
        case addStudentManuallyHttpMethod_add: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        if ([indicator_add isAnimating]) {
                            [indicator_add stopAnimation];
                            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"添加失败"] show];
                        }
                        
                        return;
                    }
                    
                    NSString *strUserId = [dicResult objectForKey:userIdKey];
                    NSString *strName = [dicResult objectForKey:trueNameKey];
                    NSString *strPhone = [dicResult objectForKey:phoneKey];
                    NSString *strTeacherId = [dicResult objectForKey:masterIdKey];
                    NSString *strCensus = [dicResult objectForKey:addressKey];
                    NSString *strPickAddress = [dicResult objectForKey:pickAddressKey];
                    NSString *strTrainClassName = [dicResult objectForKey:trainClassNameKey];
                    NSString *strPayInfo = [dicResult objectForKey:payInfoKey];
                    NSString *strStudyProgress = [dicResult objectForKey:subjectModeKey];
                    NSString *strRemark = [dicResult objectForKey:noteKey];
                    
                    LyStudent *student = [LyStudent studentWithId:strUserId
                                                          stuName:strName
                                                      stuPhoneNum:strPhone
                                                     stuTeacherId:strTeacherId
                                                        stuCensus:strCensus
                                                   stuPickAddress:strPickAddress
                                                stuTrainClassName:strTrainClassName
                                                       stuPayInfo:[strPayInfo integerValue]
                                                 stuStudyProgress:[strStudyProgress integerValue]
                                                          stuNote:strRemark];
                    
                    [[LyStudentManager sharedInstance] addStudent:student];
                    
                    [indicator_add stopAnimation];
                    
                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"添加成功"];
                    [remind setDelegate:self];
                    [remind show];
                    
                    break;
                }
                case 3: {
                    [indicator_add stopAnimation];
                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"学员已存在"];
                    [remind show];
                    break;
                }
                case 4: {
                    [indicator_add stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"该帐号已存在"] show];
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
    [_delegate onAddDoneByAddStudentManuallyViewController:self];
}


#pragma mark -LyAddressPickerDelegate
- (void)onAddressPickerCancel:(LyAddressPicker *)addressPicker
{
    [addressPicker hide];
}

- (void)onAddressPickerDone:(NSString *)address addressPicker:(LyAddressPicker *)addressPicker
{
    [addressPicker hide];
    
    [btnCensus setTitle:address forState:UIControlStateNormal];
    [self validate:NO];
}

#pragma mark -LyAddressAlertViewDelegate
- (void)addressAlertView:(LyAddressAlertView *)aAddressAlertView onClickButtonDone:(BOOL)isDone
{
    [aAddressAlertView hide];
    
    if (isDone)
    {
        [btnAddress setTitle:aAddressAlertView.address forState:UIControlStateNormal];
    }
    
    [self validate:NO];
}


#pragma mark -LyPayInfoPickerDelegate
- (void)onCancenByPayInfoPicker:(LyPayInfoPicker *)aPayInfoPicker
{
    [aPayInfoPicker hide];
}

- (void)onDoneByPayInfoPicker:(LyPayInfoPicker *)aPayInfoPicker payInfo:(LyPayInfo)aPayInfo
{
    [aPayInfoPicker hide];
    
    curPayInfo = aPayInfo;
    [btnPayInfo setTitle:[LyUtil payInfoStringFrom:curPayInfo] forState:UIControlStateNormal];
    [self validate:NO];
}


#pragma mark -LyStudyProgressPickerDelegate
- (void)onCancelByStudyProgressPicker:(LyStudyProgressPicker *)aStudyProgressPicker
{
    [aStudyProgressPicker hide];
}

- (void)onDoneByStudyProgressPicker:(LyStudyProgressPicker *)aStudyProgressPicker studyProgress:(LySubjectMode)aStudyProgress
{
    [aStudyProgressPicker hide];
    
    curSubjectMode = aStudyProgress;
    [btnStudyProgress setTitle:[LyUtil subjectModeStringFrom:curSubjectMode] forState:UIControlStateNormal];
    [self validate:NO];
}

#pragma mark -LyChooseTrainClassTableViewControllerDelegate
- (void)onCancelByChooseTrainClassTVC:(LyChooseTrainClassTableViewController *)aChooseTrainClassTVC
{
    [aChooseTrainClassTVC.navigationController popViewControllerAnimated:YES];
}

- (void)onDoneByChooseTrainClassTVC:(LyChooseTrainClassTableViewController *)aChooseTrainClassTVC trainClass:(LyTrainClass *)aTrainClass
{
    [aChooseTrainClassTVC.navigationController popViewControllerAnimated:YES];
    
    [btnTrainClassName setTitle:aTrainClass.tcName forState:UIControlStateNormal];
    [self validate:NO];
}


#pragma mark -UIKeyboardWillShowNotification
- (void)targetForNotificationFromKeyboardWillShow:(NSNotification *)notifi {
    CGFloat fHeightKeyboard = [[[notifi userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat y = 0;
    
    if ([tvRemark isFirstResponder]) {
        y = svMain.contentSize.height-50.0f-(SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-fHeightKeyboard) + LyViewItemHeight;
    }
    
    if (y > 0) {
        [svMain setContentOffset:CGPointMake(0, y)];
    }
}

#pragma mark -UIKeyboardWillHideNotification
- (void)targetForNotificationFromKeyboardWillHide:(NSNotification *)notifi
{
    [svMain setContentOffset:CGPointMake(0, 0) animated:YES];
}



#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (addStudentManuallyTextFieldMode_name == textField.tag) {
        [tfName resignFirstResponder];
        [tfPhone becomeFirstResponder];
    } else if (addStudentManuallyTextFieldMode_phone == textField.tag) {
        [tfPhone resignFirstResponder];
    }
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (addStudentManuallyTextFieldMode_name == textField.tag) {
        if (tfName.text.length > 0) {
            if ([tfName.text validateName]) {
                [tfName setTextColor:LyBlackColor];
            } else {
                [tfName setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"姓名错误"] show];
            }
        }
        
    } else if (addStudentManuallyTextFieldMode_phone == textField.tag) {
        if (tfPhone.text.length > 0) {
            if ([tfPhone.text validatePhoneNumber]) {
                [tfPhone setTextColor:LyBlackColor];
            }
            else {
                [tfPhone setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"手机号格式错误"] show];
            }
        }
        
    } else if (addStudentManuallyTextFieldMode_name)
    
    
    [self validate:NO];
}




#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
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
