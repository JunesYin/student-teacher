//
//  LyAddPriceDetailViewController.m
//  teacher
//
//  Created by Junes on 2016/9/24.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyAddPriceDetailViewController.h"

#import "LyDriveLicensePicker.h"
#import "LySubjectPracPicker.h"
#import "LyWeekdaySpanPicker.h"
#import "LyTimeBucketPicker.h"

#import "LyIndicator.h"
#import "LyRemindView.h"
#import "LyToolBar.h"

#import "LyCurrentUser.h"
#import "LyPriceDetailManager.h"

#import "NSString+Validate.h"

#import "LyUtil.h"


#define apdContentFont                  LyFont(14)


enum {
    addPriceDetailBarButtonItemTag_add = 0,
}LyAddPriceDetailBarButtonItemTag;

typedef NS_ENUM(NSInteger, LyAddPriceDetailButtonTag) {
    addPriceDetailButtonTag_license = 10,
    addPriceDetailButtonTag_subject,
    addPriceDetailButtonTag_weekday,
    addPriceDetailButtonTag_timeBucket,
};

enum {
    addPriceDetailTextFieldTag_price = 20,
}LyAddPriceDetailTextFieldTag;

enum {
    addPriceDetailAlertViewTag_goon = 30,
}LyAddPriceDetailAlertViewTag;

typedef NS_ENUM(NSInteger, LyAddPriceDetailHttpMethod) {
    addPriceDetailHttpMethod_add = 100,
};


@interface LyAddPriceDetailViewController () <UITextFieldDelegate, LyHttpRequestDelegate, LyDriveLicensePickerDelegate, LySubjectPracPickerDelegate, LyWeekdaySpanPickerDelegate, LyTimeBucketPickerDelegate, LyRemindViewDelegate>
{
    UIBarButtonItem             *bbiAdd;
    
    UIScrollView                *svMain;
    
    UIView                      *viewLicense;
    UIButton                    *btnLicense;
    
    UIView                      *viewSubject;
    UIButton                    *btnSubject;
    
    UIView                      *viewWeekday;
    UIButton                    *btnWeekday;
    
    UIView                      *viewTimeBucket;
    UIButton                    *btnTimeBucket;
    
    UITextField                 *tfPrice;
    
    
    
    LyIndicator                 *indicator;
    BOOL                        bHttpFlag;
    LyAddPriceDetailHttpMethod  curHttpMethod;
}

@property (assign, nonatomic)       LyLicenseType       curLicense;
@property (assign, nonatomic)       LySubjectModeprac   curSubject;
@property (assign, nonatomic)       LyWeekdaySpan       curWeekdaySpan;
@property (assign, nonatomic)       LyTimeBucket        curTimeBucket;

@end

@implementation LyAddPriceDetailViewController

static NSString *const btnLicenseDefaultTitle = @"请选择驾类型";
static NSString *const btnSubjectDefaultTitle = @"请选择科目";
static NSString *const btnWeekdayDefaultTitle = @"请选择星期几";
static NSString *const btnTimeBucketDefaultTitle = @"请选择时间段";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [self addObserverForNotificationFromUIKeyboard];
    
    if (_delegate && [_delegate respondsToSelector:@selector(obtainLicenseTypeByAddPriceDetailVC:)]) {
        LyLicenseType tmpLicense = [_delegate obtainLicenseTypeByAddPriceDetailVC:self];
        
        [self setCurLicense:tmpLicense];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeObserverForNotificationFromUIKeyboard];
}

- (void)initAndLayoutSubviews {
    self.title = @"添加单价";
    self.view.backgroundColor = LyWhiteLightgrayColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    bbiAdd = [[UIBarButtonItem alloc] initWithTitle:@"添加"
                                              style:UIBarButtonItemStyleDone
                                             target:self
                                             action:@selector(targetForBarButtonItem:)];
    [bbiAdd setTag:addPriceDetailBarButtonItemTag_add];
    [self.navigationItem setRightBarButtonItem:bbiAdd];
    
    
    
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-(STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT))];
    [svMain setBackgroundColor:LyWhiteLightgrayColor];
    [self.view addSubview:svMain];
    
    
    UILabel *lbRemind = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LyViewItemHeight)];
    [lbRemind setFont:LyFont(14)];
    [lbRemind setTextColor:[UIColor lightGrayColor]];
    [lbRemind setTextAlignment:NSTextAlignmentCenter];
    [lbRemind setText:@"请不要为同一个时间段添加多个价格，否则你的价格信息将会出现错乱"];
    [lbRemind setNumberOfLines:0];
    [svMain addSubview:lbRemind];
    
    
    //驾照类型
    viewLicense = [[UIView alloc] initWithFrame:CGRectMake(0, lbRemind.ly_y + CGRectGetHeight(lbRemind.frame) + verticalSpace, SCREEN_WIDTH, LyViewItemHeight)];
    [viewLicense setBackgroundColor:[UIColor whiteColor]];
    //驾照类型-标题
    UILabel *lbTitle_license = [self lbTitle:@"驾照类型"];
    //驾照类型-内容
    btnLicense = [self btnContent:addPriceDetailButtonTag_license title:btnLicenseDefaultTitle];
    
    [viewLicense addSubview:lbTitle_license];
    [viewLicense addSubview:btnLicense];
    
    
    //科目
    viewSubject = [[UIView alloc] initWithFrame:CGRectMake(0, viewLicense.ly_y+CGRectGetHeight(viewLicense.frame)+verticalSpace, SCREEN_WIDTH, LyViewItemHeight)];
    [viewSubject setBackgroundColor:[UIColor whiteColor]];
    //科目-标题
    UILabel *lbTitle_subject = [self lbTitle:@"科目"];
    //科目-内容
    btnSubject = [self btnContent:addPriceDetailButtonTag_subject title:btnSubjectDefaultTitle];
    
    [viewSubject addSubview:lbTitle_subject];
    [viewSubject addSubview:btnSubject];
    
    
    //星期几
    viewWeekday = [[UIView alloc] initWithFrame:CGRectMake(0, viewSubject.ly_y+CGRectGetHeight(viewSubject.frame)+verticalSpace, SCREEN_WIDTH, LyViewItemHeight)];
    [viewWeekday setBackgroundColor:[UIColor whiteColor]];
    //星期几-标题
    UILabel *lbTitle_weekday = [self lbTitle:@"星期几"];
    //星期几-内容
    btnWeekday = [self btnContent:addPriceDetailButtonTag_weekday title:btnWeekdayDefaultTitle];
    
    [viewWeekday addSubview:lbTitle_weekday];
    [viewWeekday addSubview:btnWeekday];
    
    
    //时间段
    viewTimeBucket = [[UIView alloc] initWithFrame:CGRectMake(0, viewWeekday.ly_y+CGRectGetHeight(viewWeekday.frame)+verticalSpace, SCREEN_WIDTH, LyViewItemHeight)];
    [viewTimeBucket setBackgroundColor:[UIColor whiteColor]];
    //时间段-标题
    UILabel *lbTitle_timeBucket = [self lbTitle:@"时间段"];
    //时间段-内容
    btnTimeBucket = [self btnContent:addPriceDetailButtonTag_timeBucket title:btnTimeBucketDefaultTitle];
    
    [viewTimeBucket addSubview:lbTitle_timeBucket];
    [viewTimeBucket addSubview:btnTimeBucket];
    
    
    //价格
    tfPrice = [[UITextField alloc] initWithFrame:CGRectMake(0, viewTimeBucket.ly_y+CGRectGetHeight(viewTimeBucket.frame)+verticalSpace, SCREEN_WIDTH, LyViewItemHeight)];
    [tfPrice setBackgroundColor:[UIColor whiteColor]];
    [tfPrice setKeyboardType:UIKeyboardTypeNumberPad];
    [tfPrice setTag:addPriceDetailTextFieldTag_price];
    [tfPrice setFont:apdContentFont];
    [tfPrice setTextColor:LyBlackColor];
    [tfPrice setTextAlignment:NSTextAlignmentRight];
    [tfPrice setPlaceholder:@"请填写价格"];
    [tfPrice setDelegate:self];
    [tfPrice setReturnKeyType:UIReturnKeyDone];
    [tfPrice setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfPrice]];
    
    [tfPrice setLeftView:[self lbTitle:@"价格"]];
    [tfPrice setRightView:({
        NSString *str = @"元/小时";
        CGFloat fWidth = [str sizeWithAttributes:@{NSFontAttributeName:apdContentFont}].width;
        UILabel *lbRight = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fWidth*1.2f, LyViewItemHeight)];
        [lbRight setTextAlignment:NSTextAlignmentCenter];
        [lbRight setFont:apdContentFont];
        [lbRight setTextColor:[UIColor darkGrayColor]];
        [lbRight setText:str];
        lbRight;
    })];
    
    [tfPrice setLeftViewMode:UITextFieldViewModeAlways];
    [tfPrice setRightViewMode:UITextFieldViewModeAlways];
    
    CGFloat fCZHeight = tfPrice.ly_y + CGRectGetHeight(tfPrice.frame);
    if (fCZHeight <= CGRectGetHeight(svMain.frame)) {
        fCZHeight = CGRectGetHeight(svMain.frame) * 1.05f;
    }
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, fCZHeight)];
    
    [svMain addSubview:viewLicense];
    [svMain addSubview:viewSubject];
    [svMain addSubview:viewWeekday];
    [svMain addSubview:viewTimeBucket];
    [svMain addSubview:tfPrice];
    
    
    [bbiAdd setEnabled:NO];
    _curTimeBucket.begin = 0;
    _curTimeBucket.end = 2;
    
    _curWeekdaySpan.begin = 0;
    _curWeekdaySpan.end = 4;
}


- (UILabel *)lbTitle:(NSString *)title {
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LyLbTitleItemWidth, LyLbTitleItemHeight)];
    [lbTitle setFont:LyFont(16)];
    [lbTitle setTextColor:[UIColor blackColor]];
    [lbTitle setText:title];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    
    return lbTitle;
}

- (UIButton *)btnContent:(LyAddPriceDetailButtonTag)tag title:(NSString *)title {
    UIButton *btnContent = [[UIButton alloc] initWithFrame:CGRectMake(horizontalSpace*2+LyLbTitleItemWidth, 0, SCREEN_WIDTH-horizontalSpace*3-LyLbTitleItemWidth, LyViewItemHeight)];
    [btnContent setTag:tag];
    [btnContent.titleLabel setFont:apdContentFont];
    [btnContent setTitleColor:LyBlackColor forState:UIControlStateNormal];
    [btnContent setTitle:title forState:UIControlStateNormal];
    [btnContent setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnContent addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return btnContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addObserverForNotificationFromUIKeyboard {
    if ([self respondsToSelector:@selector(targetForNofiticationFromUIKeyboardWillShow:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(targetForNofiticationFromUIKeyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
    }
    
    if ([self respondsToSelector:@selector(targetForNotificationFromUIKeyboardWillHide:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(targetForNotificationFromUIKeyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
}

- (void)removeObserverForNotificationFromUIKeyboard {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)targetForNofiticationFromUIKeyboardWillShow:(NSNotification *)notifi {
    CGFloat fHeightKeyboard = [[[notifi userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGFloat y = tfPrice.ly_y+CGRectGetHeight(tfPrice.frame)-(SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-fHeightKeyboard);
    if (y > 0) {
        [svMain setContentOffset:CGPointMake(0, y)];
    }
}

- (void)targetForNotificationFromUIKeyboardWillHide:(NSNotification *)notifi {
    [svMain setContentOffset:CGPointMake(0, 0)];
}



- (void)setCurLicense:(LyLicenseType)curLicense {
    _curLicense = curLicense;
    
    [btnLicense setTitle:[LyUtil driveLicenseStringFrom:_curLicense] forState:UIControlStateNormal];
    
    [self validate:NO];
}

- (void)setCurSubject:(LySubjectModeprac)curSubject {
    _curSubject = curSubject;
    
    [btnSubject setTitle:[LyUtil subjectModePracStringForm:_curSubject] forState:UIControlStateNormal];
    
    [self validate:NO];
}

- (void)setCurWeekdaySpan:(LyWeekdaySpan)curWeekdaySpan {
    _curWeekdaySpan = curWeekdaySpan;
    
    [btnWeekday setTitle:[LyUtil weekdaySpanChineseStringFrom:_curWeekdaySpan]
                forState:UIControlStateNormal];
    
    [self validate:NO];
}

- (void)setCurTimeBucket:(LyTimeBucket)curTimeBucket {
    _curTimeBucket = curTimeBucket;
    
    [btnTimeBucket setTitle:[LyUtil timeBucketChineseStringFrom:_curTimeBucket]
                   forState:UIControlStateNormal];
    
    [self validate:NO];
}


- (void)allControlResignFirstResponder {
    [tfPrice resignFirstResponder];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self allControlResignFirstResponder];
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    [self allControlResignFirstResponder];
    
    if (addPriceDetailBarButtonItemTag_add == bbi.tag) {
        [self add];
    }
}


- (void)targetForButton:(UIButton *)button {
    [self allControlResignFirstResponder];
    
    if (addPriceDetailButtonTag_license == button.tag) {
        LyDriveLicensePicker *dlPicker = [[LyDriveLicensePicker alloc] init];
        [dlPicker setDelegate:self];
        [dlPicker setInitDriveLicense:_curLicense];
        [dlPicker show];
    } else if (addPriceDetailButtonTag_subject == button.tag) {
        LySubjectPracPicker *spPicker = [[LySubjectPracPicker alloc] init];
        [spPicker setDelegate:self];
        [spPicker setSubject:_curSubject];
        [spPicker show];
    } else if (addPriceDetailButtonTag_weekday == button.tag) {
        LyWeekdaySpanPicker *wsPicker = [[LyWeekdaySpanPicker alloc] init];
        [wsPicker setDelegate:self];
        [wsPicker setWeekdaySpan:_curWeekdaySpan];
        [wsPicker show];
    } else if (addPriceDetailButtonTag_timeBucket == button.tag) {
        LyTimeBucketPicker *tbPicker = [[LyTimeBucketPicker alloc] init];
        [tbPicker setDelegate:self];
        [tbPicker setTimeBucket:_curTimeBucket];
        [tbPicker show];
    }
}


- (BOOL)validate:(BOOL)flag {
    
    [bbiAdd setEnabled:NO];
    
    if ([btnLicense.titleLabel.text isEqualToString:btnLicenseDefaultTitle]) {
        if (flag) {
            [btnLicense setTitleColor:LyWarnColor forState:UIControlStateNormal];
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没有选择驾照类型"] show];
        }
        
        return NO;
    } else {
        [btnLicense setTitleColor:LyBlackColor forState:UIControlStateNormal];
    }
    
    if ([btnSubject.titleLabel.text isEqualToString:btnSubjectDefaultTitle]) {
        if (flag) {
            [btnSubject setTitleColor:LyWarnColor forState:UIControlStateNormal];
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没有选择科目"] show];
        }
        
        return NO;
    } else {
        [btnSubject setTitleColor:LyBlackColor forState:UIControlStateNormal];
    }
    
    if ([btnWeekday.titleLabel.text isEqualToString:btnWeekdayDefaultTitle]) {
        if (flag) {
            [btnWeekday setTitleColor:LyWarnColor forState:UIControlStateNormal];
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没有选择星期几"] show];
        }
        
        return NO;
    } else {
        [btnWeekday setTitleColor:LyBlackColor forState:UIControlStateNormal];
    }
    
    if ([btnTimeBucket.titleLabel.text isEqualToString:btnTimeBucketDefaultTitle]) {
        if (flag) {
            [btnTimeBucket setTitleColor:LyWarnColor forState:UIControlStateNormal];
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"还没有选择时间段"] show];
        }
        
        return NO;
    } else {
        [btnTimeBucket setTitleColor:LyBlackColor forState:UIControlStateNormal];
    }
    
    if (![tfPrice.text validateFloat]) {
        if (flag) {
            [tfPrice setTextColor:LyWarnColor];
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"价格格式错误"] show];
        }
        
        return NO;
    } else {
        [tfPrice setTextColor:LyBlackColor];
    }
    
    [bbiAdd setEnabled:YES];
    
    return YES;
}



- (void)delayAdd {
    
    if (![self validate:YES]) {
        return;
    }

    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:nil];
    }
    [indicator startAnimation];
    
    [self performSelector:@selector(add) withObject:nil afterDelay:validateSensitiveWordDelayTime];
}



- (void)add {
    
    if (![self validate:YES]) {
        return;
    }

    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:nil];
    }
    [indicator startAnimation];
    
//    NSArray *arrPriceDetails = [[LyPriceDetailManager sharedInstance] priceDetailWithUserId:[LyCurrentUser curUser].userId
//                                                                                    license:_curLicense
//                                                                                subjectMode:_curSubject];
    
    
    
    
    
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:addPriceDetailHttpMethod_add];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:addPriceDetail_url
                                 body:@{
                                       masterIdKey:[LyCurrentUser curUser].userId,
                                       driveLicenseKey:[LyUtil driveLicenseStringFrom:_curLicense],
                                       subjectModeKey:@(_curSubject),
                                       weekdaysKey:[LyUtil weekdaySpanStringFrom:_curWeekdaySpan],
                                       timebucketKey:[LyUtil timeBucketStringFrom:_curTimeBucket],
                                       priceKey:tfPrice.text,
                                       sessionIdKey:[LyUtil httpSessionId]
                                       }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}

- (void)handleHttpFailed {
    if ([indicator isAnimating]) {
        [indicator stopAnimation];
        
        LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"添加失败"];
        [remind show];
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
        case addPriceDetailHttpMethod_add: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [self handleHttpFailed];
                        return;
                    }
                    
                    NSString *strId = [dicResult objectForKey:idKey];
                    NSString *strWeekdays = [dicResult objectForKey:weekdaysKey];
                    NSString *strTimeBucket = [dicResult objectForKey:timebucketKey];
                    NSString *strPrice = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:priceKey]];
                    NSString *strDriveLicense = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:driveLicenseKey]];
                    NSString *strSubject = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:subjectModeKey]];
                    
                    _priceDetail = [LyPriceDetail priceDetailWithPdId:strId
                                                        pdLicenseType:[LyUtil driveLicenseFromString:strDriveLicense]
                                                        pdSubjectMode:[strSubject integerValue]
                                                           pdMasterId:[LyCurrentUser curUser].userId
                                                            pdWeekday:strWeekdays
                                                               pdTime:strTimeBucket
                                                              pdPrice:[strPrice floatValue]];
                    
                    [[LyPriceDetailManager sharedInstance] addPriceDetail:_priceDetail];
                    
                    [indicator stopAnimation];
                    LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"添加成功"];
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


#pragma mark -LyHttpReqeustDelegate
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
    [_delegate onDoneByAddPriceDetailVC:self priceDetail:_priceDetail];
}



#pragma mark -LyDriveLicensePickerDelegate
- (void)onDriveLicensePickerCancel:(LyDriveLicensePicker *)picker {
    [picker hide];
}

- (void)onDriveLicensePickerDone:(LyDriveLicensePicker *)picker license:(LyLicenseType)license {
    [picker hide];
    
    [self setCurLicense:license];
}



#pragma mark -LySubjectPracPickerDelegate
- (void)onCancelBySubjectPracPicker:(LySubjectPracPicker *)aPicker {
    [aPicker hide];
}

- (void)onDoneBySubjectPracPicker:(LySubjectPracPicker *)aPicker subject:(LySubjectModeprac)subject {
    [aPicker hide];
    
    [self setCurSubject:subject];
}


#pragma mark -LyWeekdaySpanPickerDelegate
- (void)onCancelByWeekdaySpanPicker:(LyWeekdaySpanPicker *)aPicker {
    [aPicker hide];
}

- (void)onDoneByByWeekdaySpanPicker:(LyWeekdaySpanPicker *)aPicker weekdaySpan:(LyWeekdaySpan)weekdaySpan {
    [aPicker hide];
    
    [self setCurWeekdaySpan:weekdaySpan];
}


#pragma mark -LyTimeBucketPickerDelegate
- (void)onCancelByTimeBucketPicker:(LyTimeBucketPicker *)aPicker {
    [aPicker hide];
}

- (void)onDoneByTimeBucketPicker:(LyTimeBucketPicker *)aPicker timeBucket:(LyTimeBucket)timeBucket {
    [aPicker hide];
    
    [self setCurTimeBucket:timeBucket];
}




#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (addPriceDetailTextFieldTag_price == textField.tag) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    [self validate:NO];
    
    if (addPriceDetailTextFieldTag_price == textField.tag) {
        if (textField.text.length + string.length > LyPriceLengthMax) {
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (addPriceDetailTextFieldTag_price == textField.tag) {
        if (tfPrice.text.length > 0) {
            if ([tfPrice.text validateFloat]) {
                [tfPrice setTextColor:LyBlackColor];
            } else {
                [tfPrice setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"价格格式错误"] show];
            }
        }
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
