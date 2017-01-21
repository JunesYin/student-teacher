//
//  LyAddTrainClassViewController.m
//  teacher
//
//  Created by Junes on 16/8/4.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyAddTrainClassViewController.h"

#import "LyDriveLicensePicker.h"
#import "LyCarPicker.h"
#import "LyTrainClassTimePicker.h"
#import "LyToolBar.h"

#import "LyRemindView.h"


#import "UILabel+LyTextAlignmentLeftAndRight.h"
#import "NSString+validate.h"

#import "LyUtil.h"


#import "LyAddTrainClassSecondViewController.h"



#define viewItemWidth                               (SCREEN_WIDTH-horizontalSpace*2)
//CGFloat const viewItemHeight = 50.0f;

CGFloat const acLbTitleWidth = 80.0f;
#define lbTitleFont                                 LyFont(16)

#define tfItemWidth                                 (SCREEN_WIDTH-acLbTitleWidth-horizontalSpace*3)
#define tfItemeFont                                  LyFont(14)


enum {
    addTrainClassBarButtonItemTag_next = 0,
}LyAddTrainClassBarButtonItemTag;


enum {
    addTrainClassTextFieldMode_name = 10,
    addTrainClassTextFieldMode_officialPrice,
    addTrainClassTextFieldMode_517WholePrice
}AddTrainClassTextFieldMode;


enum {
    addTrainClassButtonMode_driveLincense = 20,
    addTrainClassButtonMode_carType,
    addTrainClassButtonMode_time
}AddTrainClassButtonMode;


NSString *const btnDriveLicenseDefualtTitle = @"请选择驾照类型";
NSString *const btnCarTypeDefualtTitle = @"请选择教练车型";
NSString *const btnTimeDefualtTitle = @"请选择培训班别";


@interface LyAddTrainClassViewController () <UITextFieldDelegate, LyDriveLicensePickerDelegate, LyCarPickerDelegate, LyTrainClassTimePickerDelegate, AddTrainClassSecondDelegate>
{
    UIBarButtonItem                 *bbiNext;
    
    UIScrollView                    *svMain;
    
    UITextField                     *tfName;
    UIButton                        *btnDriveLincense;
    UIButton                        *btnCarType;
    UIButton                        *btnTime;
    UIView                          *viewOfficialPrice;
    UITextField                     *tfOfficialPrice;
    UIView                          *view517WholePrice;
    UITextField                     *tf517WholePrice;
}
@end

@implementation LyAddTrainClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}



- (void)viewDidAppear:(BOOL)animated
{
    [self addObserverFormNoficationFromKeyboard];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self removeObserverForNoficationFromKeyboard];
}


+ (instancetype)addTrainClassViewControllerWithMode:(LyAddTrainClassMode)mode
{
    LyAddTrainClassViewController *atc = [[LyAddTrainClassViewController alloc] initWithMode:mode];
    
    return atc;
}

- (instancetype)initWithMode:(LyAddTrainClassMode)mode {
    if (self = [super init]) {
        _mode = mode;
    }
    
    return self;
}



- (void)initAndLayoutSubviews {
    self.title = @"添加培训课程";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    bbiNext = [[UIBarButtonItem alloc] initWithTitle:@"下一步"
                                               style:UIBarButtonItemStyleDone
                                              target:self
                                              action:@selector(targetForBarButtonItem:)];
    [bbiNext setTag:addTrainClassBarButtonItemTag_next];
    [self.navigationItem setRightBarButtonItem:bbiNext];
    
    
    
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT)];
    [svMain setBackgroundColor:LyWhiteLightgrayColor];
    [self.view addSubview:svMain];
    
    //课称名
    UIView *viewName = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LyViewItemHeight)];
    [viewName setBackgroundColor:[UIColor whiteColor]];
    //课称名-标题
    UILabel *lbName = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, acLbTitleWidth, LyViewItemHeight)];
    [lbName setFont:lbTitleFont];
    [lbName setTextColor:LyBlackColor];
    [lbName setText:@"课程名称"];
//    [lbName justifyTextAlignmentLeftAndRight];
    [lbName setTextAlignment:NSTextAlignmentLeft];
    //课称名-输入框
    tfName = [[UITextField alloc] initWithFrame:CGRectMake(acLbTitleWidth+horizontalSpace*2, 0, tfItemWidth, LyViewItemHeight)];
    [tfName setTag:addTrainClassTextFieldMode_name];
    [tfName setFont:tfItemeFont];
    [tfName setTextColor:[UIColor darkGrayColor]];
    [tfName setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfName setReturnKeyType:UIReturnKeyDone];
    [tfName setPlaceholder:@"请输入课程名称"];
    [tfName setDelegate:self];
    
    [viewName addSubview:lbName];
    [viewName addSubview:tfName];
    
    
    //驾照类型
    UIView *viewDriveLicnese = [[UIView alloc] initWithFrame:CGRectMake(0, viewName.ly_y+CGRectGetHeight(viewName.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewDriveLicnese setBackgroundColor:[UIColor whiteColor]];
    //驾照类型-标题
    UILabel *lbDriveLicense = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, acLbTitleWidth, LyViewItemHeight)];
    [lbDriveLicense setFont:lbTitleFont];
    [lbDriveLicense setTextColor:LyBlackColor];
    [lbDriveLicense setText:@"驾照类型"];
//    [lbDriveLicense justifyTextAlignmentLeftAndRight];
    [lbDriveLicense setTextAlignment:NSTextAlignmentLeft];
    //驾照类型-按钮
    btnDriveLincense = [[UIButton alloc] initWithFrame:CGRectMake(acLbTitleWidth+horizontalSpace*2, 0, tfItemWidth, LyViewItemHeight)];
    [btnDriveLincense setTag:addTrainClassButtonMode_driveLincense];
    [btnDriveLincense.titleLabel setFont:tfItemeFont];
    [btnDriveLincense setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnDriveLincense setTitle:btnDriveLicenseDefualtTitle forState:UIControlStateNormal];
    [btnDriveLincense setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnDriveLincense addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewDriveLicnese addSubview:lbDriveLicense];
    [viewDriveLicnese addSubview:btnDriveLincense];
    
    
    //车型
    UIView *viewCarType = [[UIView alloc] initWithFrame:CGRectMake(0, viewDriveLicnese.ly_y+CGRectGetHeight(viewDriveLicnese.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewCarType setBackgroundColor:[UIColor whiteColor]];
    //车型-标题
    UILabel *lbCarType = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, acLbTitleWidth, LyViewItemHeight)];
    [lbCarType setFont:lbTitleFont];
    [lbCarType setTextColor:LyBlackColor];
    [lbCarType setText:@"教练车型"];
//    [lbCarType justifyTextAlignmentLeftAndRight];
    [lbCarType setTextAlignment:NSTextAlignmentLeft];
    //车型-按钮
    btnCarType = [[UIButton alloc] initWithFrame:CGRectMake(acLbTitleWidth+horizontalSpace*2, 0, tfItemWidth, LyViewItemHeight)];
    [btnCarType setTag:addTrainClassButtonMode_carType];
    [btnCarType.titleLabel setFont:tfItemeFont];
    [btnCarType setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnCarType setTitle:btnCarTypeDefualtTitle forState:UIControlStateNormal];
    [btnCarType setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnCarType addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewCarType addSubview:lbCarType];
    [viewCarType addSubview:btnCarType];
    
    
    
    //培训班别
    UIView *viewTime = [[UIView alloc] initWithFrame:CGRectMake(0, viewCarType.ly_y+CGRectGetHeight(viewCarType.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewTime setBackgroundColor:[UIColor whiteColor]];
    //培训班别-标题
    UILabel *lbTime = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, acLbTitleWidth, LyViewItemHeight)];
    [lbTime setFont:lbTitleFont];
    [lbTime setTextColor:LyBlackColor];
    [lbTime setText:@"培训班别"];
//    [lbTime justifyTextAlignmentLeftAndRight];
    [lbTime setTextAlignment:NSTextAlignmentLeft];
    //培训班别-按钮
    btnTime = [[UIButton alloc] initWithFrame:CGRectMake(acLbTitleWidth+horizontalSpace*2, 0, tfItemWidth, LyViewItemHeight)];
    [btnTime setTag:addTrainClassButtonMode_time];
    [btnTime.titleLabel setFont:tfItemeFont];
    [btnTime setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnTime setTitle:btnTimeDefualtTitle forState:UIControlStateNormal];
    [btnTime setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnTime addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewTime addSubview:lbTime];
    [viewTime addSubview:btnTime];
    
    
    //官方价
    viewOfficialPrice = [[UIView alloc] initWithFrame:CGRectMake(0, viewTime.ly_y+CGRectGetHeight(viewTime.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewOfficialPrice setBackgroundColor:[UIColor whiteColor]];
    //官方价-标题
    UILabel *lbOfficialPrice = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, acLbTitleWidth, LyViewItemHeight)];
    [lbOfficialPrice setFont:lbTitleFont];
    [lbOfficialPrice setTextColor:LyBlackColor];
    [lbOfficialPrice setText:@"官方价"];
//    [lbOfficialPrice justifyTextAlignmentLeftAndRight];
    [lbOfficialPrice setTextAlignment:NSTextAlignmentLeft];
    //官方价-输入框
    tfOfficialPrice = [[UITextField alloc] initWithFrame:CGRectMake(acLbTitleWidth+horizontalSpace*2, 0, tfItemWidth-90.0f, LyViewItemHeight)];
    [tfOfficialPrice setTag:addTrainClassTextFieldMode_officialPrice];
    [tfOfficialPrice setFont:tfItemeFont];
    [tfOfficialPrice setTextColor:[UIColor darkGrayColor]];
    [tfOfficialPrice setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfOfficialPrice setKeyboardType:UIKeyboardTypeNumberPad];
    [tfOfficialPrice setReturnKeyType:UIReturnKeyDone];
    [tfOfficialPrice setPlaceholder:@"请输入官方价"];
    [tfOfficialPrice setDelegate:self];
    [tfOfficialPrice setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfOfficialPrice]];
    //官方价-货币单位
    UILabel *lbCurrencyUnit_officialPrice = [[UILabel alloc] initWithFrame:CGRectMake(viewItemWidth-90.0f, 0, 90.0f, LyViewItemHeight)];
    [lbCurrencyUnit_officialPrice setFont:LyFont(14)];
    [lbCurrencyUnit_officialPrice setTextColor:[UIColor darkGrayColor]];
    [lbCurrencyUnit_officialPrice setTextAlignment:NSTextAlignmentLeft];
    [lbCurrencyUnit_officialPrice setText:@"（单位：元）"];
    
    [viewOfficialPrice addSubview:lbOfficialPrice];
    [viewOfficialPrice addSubview:tfOfficialPrice];
    [viewOfficialPrice addSubview:lbCurrencyUnit_officialPrice];
    
    
    //优惠价
    view517WholePrice = [[UIView alloc] initWithFrame:CGRectMake(0, viewOfficialPrice.ly_y+CGRectGetHeight(viewOfficialPrice.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [view517WholePrice setBackgroundColor:[UIColor whiteColor]];
    //优惠价-标题
    UILabel *lb517WholePrice = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, acLbTitleWidth, LyViewItemHeight)];
    [lb517WholePrice setFont:lbTitleFont];
    [lb517WholePrice setTextColor:LyBlackColor];
    [lb517WholePrice setText:@"优惠价"];
//    [lb517WholePrice justifyTextAlignmentLeftAndRight];
    [lb517WholePrice setTextAlignment:NSTextAlignmentLeft];
    //优惠价-输入框
    tf517WholePrice = [[UITextField alloc] initWithFrame:CGRectMake(acLbTitleWidth+horizontalSpace*2, 0, tfItemWidth-90.0f, LyViewItemHeight)];
    [tf517WholePrice setTag:addTrainClassTextFieldMode_517WholePrice];
    [tf517WholePrice setFont:tfItemeFont];
    [tf517WholePrice setTextColor:[UIColor darkGrayColor]];
    [tf517WholePrice setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tf517WholePrice setKeyboardType:UIKeyboardTypeNumberPad];
    [tf517WholePrice setReturnKeyType:UIReturnKeyDone];
    [tf517WholePrice setPlaceholder:@"请输入优惠价"];
    [tf517WholePrice setDelegate:self];
    [tf517WholePrice setInputAccessoryView:[LyToolBar toolBarWithInputControl:tf517WholePrice]];
    //官方价-货币单位
    UILabel *lbCurrencyUnit_517WholePrice = [[UILabel alloc] initWithFrame:CGRectMake(viewItemWidth-90.0f, 0, 90.0f, LyViewItemHeight)];
    [lbCurrencyUnit_517WholePrice setFont:LyFont(14)];
    [lbCurrencyUnit_517WholePrice setTextColor:[UIColor darkGrayColor]];
    [lbCurrencyUnit_517WholePrice setTextAlignment:NSTextAlignmentLeft];
    [lbCurrencyUnit_517WholePrice setText:@"（单位：元）"];
    
    [view517WholePrice addSubview:lb517WholePrice];
    [view517WholePrice addSubview:tf517WholePrice];
    [view517WholePrice addSubview:lbCurrencyUnit_517WholePrice];
    
    
    
    [svMain addSubview:viewName];
    [svMain addSubview:viewDriveLicnese];
    [svMain addSubview:viewCarType];
    [svMain addSubview:viewTime];
    [svMain addSubview:viewOfficialPrice];
    [svMain addSubview:view517WholePrice];
    
    CGFloat fCZHeight = view517WholePrice.ly_y + CGRectGetHeight(view517WholePrice.frame) + 50.0f;
    if (fCZHeight <= CGRectGetHeight(svMain.frame)) {
        fCZHeight = CGRectGetHeight(svMain.frame) * 1.05f;
    }
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, fCZHeight)];
    
    
    [bbiNext setEnabled:NO];
    
}


- (void)addObserverFormNoficationFromKeyboard
{
    if ([self respondsToSelector:@selector(targetForNotificationFromKeyboardWillShow:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(targetForNotificationFromKeyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
    }
    
    if ([self respondsToSelector:@selector(targetForNotificationFromKeyboardWillHide:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(targetForNotificationFromKeyboardWillHide:)
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

- (void)removeObserverForNoficationFromKeyboard
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


- (void)allControlResignFirstResponder
{
    [tfName resignFirstResponder];
    [tfOfficialPrice resignFirstResponder];
    [tf517WholePrice resignFirstResponder];
}


- (BOOL)validate:(BOOL)flag {
    [bbiNext setEnabled:NO];
    
    if (tfName.text.length < 1 || tfName.text.length > remarkMaxCount) {
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"课程名格式错误"] show];
        }
        return NO;
    }
    
    if ([btnDriveLincense.titleLabel.text isEqualToString:btnDriveLicenseDefualtTitle]){
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"还没有选择驾照类型"] show];
        }
        return NO;
    }
    
    if ([btnCarType.titleLabel.text isEqualToString:btnCarTypeDefualtTitle]){
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"还没有选择教练类型"] show];
        }
        return NO;
    }
    
    if ([btnTime.titleLabel.text isEqualToString:btnTimeDefualtTitle]){
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"还没有选择培训班别"] show];
        }
        return NO;
    }
    
    if (tfOfficialPrice.text.length < 1 || ![tfOfficialPrice.text validateInt]){
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"官方价格式错误"] show];
        }
        return NO;
    }
    
    if (tf517WholePrice.text.length < 1 || ![tf517WholePrice.text validateInt]){
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"优惠价格式错误"] show];
        }
        return NO;
    }
    
    if ([tf517WholePrice.text floatValue] > [tfOfficialPrice.text floatValue]){
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"优惠价不可高于官方价"] show];
        }
        return NO;
    }
    
    [bbiNext setEnabled:YES];
    return YES;
}





- (void)targetForButton:(UIButton *)button
{
    if (addTrainClassButtonMode_driveLincense == button.tag)
    {
        [self allControlResignFirstResponder];
        
        LyDriveLicensePicker *driveLicensePicker = [[LyDriveLicensePicker alloc] init];
        [driveLicensePicker setDelegate:self];
        if (![btnDriveLincense.titleLabel.text isEqualToString:btnDriveLicenseDefualtTitle])
        {
            [driveLicensePicker setInitDriveLicense:[LyUtil driveLicenseFromString:btnDriveLincense.titleLabel.text]];
        }
        [driveLicensePicker show];
    }
    else if (addTrainClassButtonMode_carType == button.tag)
    {
        [self allControlResignFirstResponder];
        
        LyCarPicker *carPicker = [[LyCarPicker alloc] init];
        [carPicker setDelegate:self];
        if (![btnCarType.titleLabel.text isEqualToString:btnCarTypeDefualtTitle])
        {
            [carPicker setCar:btnCarType.titleLabel.text];
        }
        [carPicker show];
    }
    else if (addTrainClassButtonMode_time == button.tag)
    {
        [self allControlResignFirstResponder];
        
        LyTrainClassTimePicker *trainClassTimePicker = [[LyTrainClassTimePicker alloc] init];
        [trainClassTimePicker setDelegate:self];
        if (![btnTime.titleLabel.text isEqualToString:btnTimeDefualtTitle])
        {
            [trainClassTimePicker setTrainClassTime:btnTime.titleLabel.text];
        }
        [trainClassTimePicker show];
    }
}



- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    if (addTrainClassBarButtonItemTag_next == bbi.tag) {
        if (![self validate:YES]) {
            return;
        }
        
        LyAddTrainClassSecondViewController *addTrainClassSecond = [[LyAddTrainClassSecondViewController alloc] init];
        [addTrainClassSecond setDelegate:self];
        [self.navigationController pushViewController:addTrainClassSecond animated:YES];
    }
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self allControlResignFirstResponder];
}



#pragma mark -UIKeyboardWillShowNotification
- (void)targetForNotificationFromKeyboardWillShow:(NSNotification *)notifi
{
    CGFloat fHeightKeyboard = [[[notifi userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat y = 0;
    
    if ([tfOfficialPrice isFirstResponder]) {
        y = viewOfficialPrice.ly_y + CGRectGetHeight(viewOfficialPrice.frame) - (SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT - fHeightKeyboard) + LyViewItemHeight;
    } else if ([tf517WholePrice isFirstResponder]) {
        y = view517WholePrice.ly_y + CGRectGetHeight(view517WholePrice.frame) - (SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT - fHeightKeyboard) + LyViewItemHeight;
    }
    
    if (y > 0) {
        [svMain setContentOffset:CGPointMake(0, y)];
    }
    
}

#pragma mark -UIKeyboardWillHideNotification
- (void)targetForNotificationFromKeyboardWillHide:(NSNotification *)notifi {
    [svMain setContentOffset:CGPointMake(0, 0)];
}



#pragma mark -AddTrainClassSecondDelegate
- (NSDictionary *)obtainTrainClassInfoByLyAddTrainClassSecondViewController:(LyAddTrainClassSecondViewController *)aAddTrainClassVC
{
    return @{
             nameKey:tfName.text,
             driveLicenseKey:btnDriveLincense.titleLabel.text,
             carNameKey:btnCarType.titleLabel.text,
             trainClassTimeKey:btnTime.titleLabel.text,
             officialPriceKey:[NSNumber numberWithFloat:tfOfficialPrice.text.floatValue],
             whole517PriceKey:[NSNumber numberWithFloat:tf517WholePrice.text.floatValue],
             prepay517priceKey:[NSNumber numberWithFloat:tf517WholePrice.text.floatValue]
             };
}

- (void)onDoneAddTrainClassByLyAddTrainClassSecondViewController:(LyAddTrainClassSecondViewController *)aAddTrainClassVC
{
    [_delegate addDoneByLyAddTrainClassViewController:self];
}



#pragma mark -LyDriveLicensePickerDelegate
- (void)onDriveLicensePickerCancel:(LyDriveLicensePicker *)picker
{
    [picker hide];
}

- (void)onDriveLicensePickerDone:(LyDriveLicensePicker *)picker license:(LyLicenseType)license
{
    [picker hide];
    
    [btnDriveLincense setTitle:[LyUtil driveLicenseStringFrom:license] forState:UIControlStateNormal];
    
    [self validate:NO];
}



#pragma mark -LyCarPickerDelegate
- (void)onCancelByCarPicker:(LyCarPicker *)aCarPicker
{
    [aCarPicker hide];
}


- (void)onDoneByCarPicker:(LyCarPicker *)aCarPicker car:(NSString *)aCar
{
    [aCarPicker hide];
    
    [btnCarType setTitle:aCar forState:UIControlStateNormal];
    
    [self validate:NO];
}


#pragma mark -LyTarinClassTimeDelegate
- (void)onCancelByTrainClassTimePicker:(LyTrainClassTimePicker *)aTrainClassPicker
{
    [aTrainClassPicker hide];
}

- (void)onDoneByTrainClassTimePicker:(LyTrainClassTimePicker *)aTrainClassPicker trainClassTime:(NSString *)aTranClassTime
{
    [aTrainClassPicker hide];
    
    [btnTime setTitle:aTranClassTime forState:UIControlStateNormal];
    
    [self validate:NO];
}


#pragma mark -UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == tfName)
    {
        if (tfName.text.length + string.length > remarkMaxCount)
        {
            [tfName setText:[[[NSString alloc] initWithFormat:@"%@%@", textField.text, string] substringToIndex:remarkMaxCount]];
            return NO;
        }
    }
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == tfName)
    {
    }
    else if (textField == tfOfficialPrice)
    {
        if (tfOfficialPrice.text.length > 0)
        {
            if ([tfOfficialPrice.text validateInt])
            {
                [tfOfficialPrice setTextColor:[UIColor darkGrayColor]];
            }
            else
            {
                [tfOfficialPrice setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"官方价格式错误"] show];
            }
        }
        
    }
    else if (textField == tf517WholePrice)
    {
        if (tf517WholePrice.text.length > 0)
        {
            if ([tf517WholePrice.text validateInt])
            {
                [tf517WholePrice setTextColor:[UIColor darkGrayColor]];
            }
            else
            {
                [tf517WholePrice setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"优惠价格式错误"] show];
            }
        }
    }
    
    [self validate:NO];
}



#pragma mark -UITextFieldTextDidChangeNotification
- (void)targetForNotificationFormUITextFieldTextDidChangeNotification:(NSNotification *)notifi {
    if ([notifi.object isKindOfClass:[UITextField class]]) {
        [self validate:NO];
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
