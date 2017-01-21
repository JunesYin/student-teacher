
//  LyAddTrainClassSecondViewController.m
//  teacher
//
//  Created by Junes on 16/8/5.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyAddTrainClassSecondViewController.h"
#import "LyTrainClassTableViewCell.h"

#import "LyTrainPeriodPicker.h"
#import "LyTrainModePicker.h"
#import "LyTrainTimePicker.h"
#import "LyToolBar.h"
#import "LyRemindView.h"
#import "LyIndicator.h"

#import "LyTrainClassManager.h"

#import "LyCurrentUser.h"

#import "UILabel+LyTextAlignmentLeftAndRight.h"
#import "UITextView+placeholder.h"
#import "NSString+Validate.h"


#import "LyUtil.h"

//NSString *const tcNameKey = @"tcName";
//NSString *const tcDriveLicenseKey = @"tcDriveLicense";
//NSString *const tcCarKey = @"tcCar";
//NSString *const tcTimeKey = @"tcTime";
//NSString *const tcOfficailPriceKey = @"tcOfficialPrice";
//NSString *const tc517WholePriceKey = @"tc517WholePrice";



//课程信息
CGFloat const atcsViewInfoHeight = 115.0f;
//课程信息-
#define lbItemFont                          LyFont(14)
#define lbNameFont                          LyFont(15)



//#define viewItemWidth                       SCREEN_WIDTH
CGFloat const atcsViewItemHeight = 50.0f;
CGFloat const atcsBtnPickModeHeight = atcsViewItemHeight * 4 / 5.0f;
CGFloat const atcsBtnPickModeWidth = atcsBtnPickModeHeight * 100 / 40.0f;

CGFloat const atcsLbTitleWidth = 70.0f;
#define lbTitleFont                         LyFont(16)

#define lbContentWidth                      (SCREEN_WIDTH-atcsLbTitleWidth-horizontalSpace*3)
#define lbContentFont                       LyFont(14)

#define tfContentWidth                      lbContentWidth


#define viewItemBigHeight                   (atcsViewItemHeight*3)

#define tvContentWidth                      lbContentWidth
#define tvContentHeight                     (viewItemBigHeight-verticalSpace*2)



enum {
    addTrainClassSecondBarButtonItemTag_add = 0,
}LyAddTrainClassSecondBarButtonItemTag;


typedef NS_ENUM( NSInteger, AddTrainClassSecondTextViewMode)
{
    addTrainClassSecondTextViewMode_include = 20,
    addTrainClassSecondTextViewMode_pickRange,
};

typedef NS_ENUM( NSInteger, AddTrainClassSecondTextfieldMode)
{
    addTrainClassSecondTextfieldMode_waitDays = 30,
    addTrainClassSecondTextfieldMode_finishDays
};


typedef NS_ENUM(NSInteger, AddTrainClassSecondButtonMode)
{
    addTrainClassSecondButtonMode_trainPeriod = 40,
    addTrainClassSecondButtonMode_pickMode,
    addTrainClassSecondButtonMode_trainMode,
    addTrainClassSecondButtonMode_trainTime
};



typedef NS_ENUM(NSInteger, LyAddTrainClassSecondHttpMethod)
{
    addTrainClassSecondHttpMethod_add = 100,
};



NSString *const btnTrainPeriodDefaultTitle = @"请选择学车课时";
NSString *const btnTrainModeDefaultTitle = @"请选择练车方式";
NSString *const btnTrainTimeDefaultTitle = @"请选择练车时间";



@interface LyAddTrainClassSecondViewController () <UIScrollViewDelegate, UITextViewDelegate, UITextFieldDelegate, LyTrainPeriodPickerDelegate, LyTrainModePickerDelegate, LyTrainTimePickerDelegate, LyRemindViewDelegate, LyHttpRequestDelegate>
{
    UIBarButtonItem             *bbiAdd;
    
    UIScrollView                *svMain;
    
    //课程详情
    UIView                      *viewInfo;
    UILabel                     *lbTitle_info;
    UILabel                     *lbName;
    UILabel                     *lbFold;
    UILabel                     *lbCarType;
    UILabel                     *lbTime;
    UILabel                     *lbOfficialPrice;
    UILabel                     *lb517WholePrice;
    
    
    //课程信息
    UIView                      *viewDetail;
    UILabel                     *lbTitle_detail;
    //课程信息-费用明细
    UIView                      *viewDetail_fee;
    UILabel                     *lbTitleSmall_fee;
    //课程信息-费用明细-总费用
    UIView                      *viewTotalFee;
    UILabel                     *lbTotalFee;
    //课程信息-费用明细-包含费用
    UIView                      *viewInclude;
    UITextView                  *tvInclude;
    //培训服务
    UIView                      *viewDetail_service;
    UILabel                     *lbTitleSmall_service;
    //课程信息-培训服务-驾照类型
    UIView                      *viewDriveLicense;
    UILabel                     *lbDriveLicense;
    //课程信息-培训服务-教练型
    UIView                      *viewCarType;
    UILabel                     *lbCarType__;
    //课程信息-培训服务-排队时间
    UIView                      *viewWaitDays;
    UITextField                 *tfWaitDays;
    //课程信息-培训服务-学车课时
    UIView                      *viewTrainPeriod;
    UIButton                    *btnTrainPeriod;
    //课程信息-培训服务-接送方式
    UIView                      *viewPickMode;
    UIButton                    *btnPickMode;
//    //课程信息-培训服务-接送范围
//    UIView                      *viewPickRange;
//    UITextView                  *tvPickRange;
    //课程信息-培训服务-练车方式
    UIView                      *viewTrainMode;
    UIButton                    *btnTrainMode;
//    //课程信息-培训服务-练车时间
//    UIView                      *viewTrainTime;
//    UIButton                    *btnTrainTime;
//    //课程信息-培训服务-拿证时间
//    UIView                      *viewFinishDays;
//    UITextField                 *tfFinishDays;
    
    
    
    
    LyTrainClassObjectPeriod    curTrainPeriod;
    LyTrainClassTrainMode       curTrainMode;
    LyTimeBucket trainTimeBucket;
    
    
    LyIndicator                 *indicator_add;
    BOOL                        bHttpFlag;
    LyAddTrainClassSecondHttpMethod curHttpMethod;
    
}
@end

@implementation LyAddTrainClassSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}


- (void)viewWillAppear:(BOOL)animated
{
    
    _dicTcInfo = [_delegate obtainTrainClassInfoByLyAddTrainClassSecondViewController:self];
    
    
    if (!_dicTcInfo)
    {
        
    }
    else
    {
        [self reloadViewInfo];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [self addObserverFormNoficationFromKeyboard];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self removeObserverForNoficationFromKeyboard];
}


- (void)initAndLayoutSubviews
{
    self.title = @"添加培训课程";
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    bbiAdd = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                              style:UIBarButtonItemStyleDone
                                             target:self
                                             action:@selector(targetForBarButtonItem:)];
    [bbiAdd setTag:addTrainClassSecondBarButtonItemTag_add];
    [self.navigationItem setRightBarButtonItem:bbiAdd];
    
    
    //滑动主view
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT)];
    [svMain setDelegate:self];
    
    [self.view addSubview:svMain];
    
    
    //课程信息
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, atcsViewInfoHeight)];
    [viewInfo setBackgroundColor:[UIColor whiteColor]];
    //课程信息-标题
    lbTitle_info = [LyUtil lbItemTitleWithText:@"课程信息"];
    [lbTitle_info setBackgroundColor:[UIColor whiteColor]];
    //课程信息-名字
    lbName = [UILabel new];
    [lbName setFont:lbNameFont];
    [lbName setTextColor:LyBlackColor];
    [lbName setTextAlignment:NSTextAlignmentCenter];
    //课程信息-优惠数
    lbFold = [UILabel new];
    [lbFold setFont:lbItemFont];
    [lbFold setTextColor:Ly517ThemeColor];
    [lbFold setTextAlignment:NSTextAlignmentCenter];
    [[lbFold layer] setCornerRadius:3.0f];
    [[lbFold layer] setBorderWidth:1];
    [[lbFold layer] setBorderColor:[Ly517ThemeColor CGColor]];
    //课程信息-教练车型
    lbCarType = [UILabel new];
    [lbCarType setFont:lbItemFont];
    [lbCarType setTextColor:LyBlackColor];
    [lbCarType setTextAlignment:NSTextAlignmentCenter];
    //课程信息-班别
    lbTime = [UILabel new];
    [lbTime setFont:lbItemFont];
    [lbTime setTextColor:LyBlackColor];
    [lbTime setTextAlignment:NSTextAlignmentCenter];
    //课程信息-官方价
    lbOfficialPrice = [UILabel new];
    [lbOfficialPrice setFont:lbItemFont];
    [lbOfficialPrice setTextColor:LyBlackColor];
    [lbOfficialPrice setTextAlignment:NSTextAlignmentCenter];
    //课程信息-517价
    lb517WholePrice = [UILabel new];
    [lb517WholePrice setFont:lbItemFont];
    [lb517WholePrice setTextColor:LyBlackColor];
    [lb517WholePrice setTextAlignment:NSTextAlignmentCenter];
    
    UIView *horizontalLine_info = [[UIView alloc] initWithFrame:CGRectMake( 0, CGRectGetHeight(viewInfo.frame)-sparaterLineHeight, SCREEN_WIDTH, sparaterLineHeight)];
    [horizontalLine_info setBackgroundColor:LyWhiteLightgrayColor];
    
    
    [viewInfo addSubview:lbTitle_info];
    [viewInfo addSubview:lbName];
    [viewInfo addSubview:lbFold];
    [viewInfo addSubview:lbCarType];
    [viewInfo addSubview:lbTime];
    [viewInfo addSubview:lbOfficialPrice];
    [viewInfo addSubview:lb517WholePrice];
    [viewInfo addSubview:horizontalLine_info];
    
    
    
    
    //课程详情
    viewDetail = [UIView new];
    [viewDetail setBackgroundColor:LyWhiteLightgrayColor];
    //课程详情-标题
    lbTitle_detail = [LyUtil lbItemTitleWithText:@"课程详情"];
    
    
    //课程详情-费用明细
    viewDetail_fee = [UIView new];
    [viewDetail_fee setBackgroundColor:LyWhiteLightgrayColor];
    //课程详情-费用明细-标题
    lbTitleSmall_fee = [self lbSmallTitleWithTitle:@"*费用明细"];
    
    //课程详情-费用明细-总学费
    viewTotalFee = [[UIView alloc] initWithFrame:CGRectMake(0, lbTitleSmall_fee.ly_y+CGRectGetHeight(lbTitleSmall_fee.frame), SCREEN_WIDTH, atcsViewItemHeight)];
    [viewTotalFee setBackgroundColor:[UIColor whiteColor]];
    //课程详情-费用明细-总学费-标题
    UILabel *lbTitle_totalFee = [self lbItemTitleWithTitle:@"总学费"];
    //课程详情-费用明细-总学费-内容
    lbTotalFee = [self lbItemContent];
    
    [viewTotalFee addSubview:lbTitle_totalFee];
    [viewTotalFee addSubview:lbTotalFee];
    
    //课程详情-费用明细-包含费用
    viewInclude = [[UIView alloc] initWithFrame:CGRectMake(0, viewTotalFee.ly_y+CGRectGetHeight(viewTotalFee.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, viewItemBigHeight)];
    [viewInclude setBackgroundColor:[UIColor whiteColor]];
    //课程详情-费用明细-包含费用-标题
    UILabel *lbTitle_include = [self lbItemTitleWithTitle:@"包含费用"];
    //课程详情-费用明细-包含费用-输入框
    tvInclude = [self tvContentWithMode:addTrainClassSecondTextViewMode_include];
    [tvInclude setText:@"教材费、办证费、IC卡费、理科术科培训费、燃油费、车辆及人员使用费、经营管理等费用，以及科目一、科目二、科目三考试费、一次补考费"];
    
    [viewInclude addSubview:lbTitle_include];
    [viewInclude addSubview:tvInclude];
    
    
    [viewDetail_fee setFrame:CGRectMake(0, lbTitle_detail.ly_y+CGRectGetHeight(lbTitle_detail.frame)+verticalSpace, SCREEN_WIDTH, viewInclude.ly_y+CGRectGetHeight(viewInclude.frame)+verticalSpace)];
    
    [viewDetail_fee addSubview:lbTitleSmall_fee];
    [viewDetail_fee addSubview:viewTotalFee];
    [viewDetail_fee addSubview:viewInclude];
    
    

    
    //课程详情-培训服务
    viewDetail_service = [UIView new];
    [viewDetail_service setBackgroundColor:LyWhiteLightgrayColor];
    //课程详情-培训服务-标题
    lbTitleSmall_service = [self lbSmallTitleWithTitle:@"*培训服务"];
    
    
    //课程详情-培训服务-驾照类型
    viewDriveLicense = [[UIView alloc] initWithFrame:CGRectMake(0, lbTitleSmall_service.ly_y+CGRectGetHeight(lbTitleSmall_service.frame), SCREEN_WIDTH, atcsViewItemHeight)];
    [viewDriveLicense setBackgroundColor:[UIColor whiteColor]];
    //课程详情-培训服务-驾照类型-标题
    UILabel *lbTitle_driveLicense = [self lbItemTitleWithTitle:@"驾照类型"];
    //课程详情-培训服务-驾照类型-内容
    lbDriveLicense = [self lbItemContent];
    
    [viewDriveLicense addSubview:lbTitle_driveLicense];
    [viewDriveLicense addSubview:lbDriveLicense];
    
    
    
    //课程详情-培训服务-教练车型
    viewCarType = [[UIView alloc] initWithFrame:CGRectMake(0, viewDriveLicense.ly_y+CGRectGetHeight(viewDriveLicense.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, atcsViewItemHeight)];
    [viewCarType setBackgroundColor:[UIColor whiteColor]];
    //课程详情-培训服务-教练车型-标题
    UILabel *lbTitle_carType = [self lbItemTitleWithTitle:@"教练车型"];
    //课程详情-培训服务-教练车型-内容
    lbCarType__ = [self lbItemContent];
    
    [viewCarType addSubview:lbTitle_carType];
    [viewCarType addSubview:lbCarType__];
    
    
    //课程详情-培训服务-排队时间
    viewWaitDays = [[UIView alloc] initWithFrame:CGRectMake(0, viewCarType.ly_y+CGRectGetHeight(viewCarType.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, atcsViewItemHeight)];
    [viewWaitDays setBackgroundColor:[UIColor whiteColor]];
    //课程详情-培训服务-排队时间-标题
    UILabel *lbTitle_waitDays = [self lbItemTitleWithTitle:@"排队时间"];
    //课程详情-培训服务-排队时间-内容
    tfWaitDays = [self tfContentWithMode:addTrainClassSecondTextfieldMode_waitDays];
    [tfWaitDays setPlaceholder:@"请输入排队时间"];
    [tfWaitDays setKeyboardType:UIKeyboardTypeNumberPad];
    [tfWaitDays setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfWaitDays]];
    //课程详情-培训服务-拿证时间-单位
    UILabel *lbUnit_waitDays = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50.0f-horizontalSpace, 0, 50.0f, atcsViewItemHeight)];
    [lbUnit_waitDays setFont:lbContentFont];
    [lbUnit_waitDays setTextColor:[UIColor darkGrayColor]];
    [lbUnit_waitDays setTextAlignment:NSTextAlignmentRight];
    [lbUnit_waitDays setText:@"天"];
    
    
    [viewWaitDays addSubview:lbTitle_waitDays];
    [viewWaitDays addSubview:tfWaitDays];
    [viewWaitDays addSubview:lbUnit_waitDays];
    
    
    
    //课程详情-培训服务-学车课时
    viewTrainPeriod = [[UIView alloc] initWithFrame:CGRectMake(0, viewWaitDays.ly_y+CGRectGetHeight(viewWaitDays.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, atcsViewItemHeight)];
    [viewTrainPeriod setBackgroundColor:[UIColor whiteColor]];
    //课程详情-培训服务-学车课时-标题
    UILabel *lbTitle_trainPeriod = [self lbItemTitleWithTitle:@"学车课时"];
    //课程详情-培训服务-学车课时-内容
    btnTrainPeriod = [self buttonWithMode:addTrainClassSecondButtonMode_trainPeriod];
    
    [viewTrainPeriod addSubview:lbTitle_trainPeriod];
    [viewTrainPeriod addSubview:btnTrainPeriod];
    
    
    
    //课程详情-培训服务-接送方式
    viewPickMode = [[UIView alloc] initWithFrame:CGRectMake(0, viewTrainPeriod.ly_y+CGRectGetHeight(viewTrainPeriod.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, atcsViewItemHeight)];
    [viewPickMode setBackgroundColor:[UIColor whiteColor]];
    //课程详情-培训服务-接送方式-标题
    UILabel *lbTitle_pickMode = [self lbItemTitleWithTitle:@"接送方式"];
    //课程详情-培训服务-接送方式-内容
    btnPickMode = [[UIButton alloc] initWithFrame:CGRectMake(atcsLbTitleWidth+horizontalSpace, atcsViewItemHeight/2.0-atcsBtnPickModeHeight/2.0f, atcsBtnPickModeWidth, atcsBtnPickModeHeight)];
    [btnPickMode setTag:addTrainClassSecondButtonMode_pickMode];
    [btnPickMode setBackgroundImage:[LyUtil imageForImageName:@"btnPickMode_n" needCache:NO] forState:UIControlStateNormal];
    [btnPickMode setBackgroundImage:[LyUtil imageForImageName:@"btnPickMode_h" needCache:NO] forState:UIControlStateSelected];
    [btnPickMode addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [viewPickMode addSubview:lbTitle_pickMode];
    [viewPickMode addSubview:btnPickMode];
    
    
    
//    //课程详情-培训服务-接送范围
//    viewPickRange = [[UIView alloc] initWithFrame:CGRectMake(horizontalSpace, viewPickMode.ly_y+CGRectGetHeight(viewPickMode.frame), viewItemWidth, viewItemBigHeight)];
//    //课程详情-培训服务-接送范围-顶部横线
//    UIView *horizontalLine_pickRange = [self topHorizontalLine];
//    //课程详情-培训服务-接送范围-标题
//    UILabel *lbTitle_pickRange = [self lbItemTitleWithTitle:@"接送范围"];
//    //课程详情-培训服务-接送范围-输入框
//    tvPickRange = [self tvContentWithMode:addTrainClassSecondTextViewMode_pickRange];
//    [tvPickRange setPlaceholder:@"请选择班车接送路线或接送范围"];
//    
//    
//    [viewPickRange addSubview:horizontalLine_pickRange];
//    [viewPickRange addSubview:lbTitle_pickRange];
//    [viewPickRange addSubview:tvPickRange];
    
    
    
    
    //课程详情-培训服务-练车方式
    viewTrainMode = [[UIView alloc] initWithFrame:CGRectMake(0, viewPickMode.ly_y+CGRectGetHeight(viewPickMode.frame)+LyHorizontalLineHeight, SCREEN_WIDTH, atcsViewItemHeight)];
    [viewTrainMode setBackgroundColor:[UIColor whiteColor]];
    //课程详情-培训服务-练车方式-标题
    UILabel *lbTitle_trainMode = [self lbItemTitleWithTitle:@"练车方式"];
    //课程详情-培训服务-练车方式-内容
    btnTrainMode = [self buttonWithMode:addTrainClassSecondButtonMode_trainMode];

    
    [viewTrainMode addSubview:lbTitle_trainMode];
    [viewTrainMode addSubview:btnTrainMode];
    
    
    
    
//    //课程详情-培训服务-练车时间
//    viewTrainTime = [[UIView alloc] initWithFrame:CGRectMake(horizontalSpace, viewTrainMode.ly_y+CGRectGetHeight(viewTrainMode.frame), viewItemWidth, atcsViewItemHeight)];
//    //课程详情-培训服务-练车时间-顶部横线
//    UIView *horizontalLine_trainTime = [self topHorizontalLine];
//    //课程详情-培训服务-练车时间-标题
//    UILabel *lbTitle_trainTime = [self lbItemTitleWithTitle:@"练车时间"];
//    //课程详情-培训服务-练车时间-内容
//    btnTrainTime = [self buttonWithMode:addTrainClassSecondButtonMode_trainTime];
//    
//    [viewTrainTime addSubview:horizontalLine_trainTime];
//    [viewTrainTime addSubview:lbTitle_trainTime];
//    [viewTrainTime addSubview:btnTrainTime];
    
    
    
//    //课程详情-培训服务-拿证时间
//    viewFinishDays = [[UIView alloc] initWithFrame:CGRectMake(horizontalSpace, viewTrainTime.ly_y+CGRectGetHeight(viewTrainTime.frame), viewItemWidth, atcsViewItemHeight)];
//    //课程详情-培训服务-拿证时间-顶部横线
//    UIView *horizontalLine_finishDays = [self topHorizontalLine];
//    //课程详情-培训服务-拿证时间-标题
//    UILabel *lbTitle_finishDays = [self lbItemTitleWithTitle:@"拿证时间"];
//    //课程详情-培训服务-拿证时间-内容
//    tfFinishDays = [self tfContentWithMode:addTrainClassSecondTextfieldMode_finishDays];
//    [tfFinishDays setPlaceholder:@"请输入最快拿证时间"];
//    [tfFinishDays setKeyboardType:UIKeyboardTypeNumberPad];
//    [tfFinishDays setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfFinishDays]];
//    //课程详情-培训服务-拿证时间-单位
//    UILabel *lbUnit_finishDays = [[UILabel alloc] initWithFrame:CGRectMake(viewItemWidth-50.0f, 0, 50.0f, atcsViewItemHeight)];
//    [lbUnit_finishDays setFont:lbContentFont];
//    [lbUnit_finishDays setTextColor:[UIColor darkGrayColor]];
//    [lbUnit_finishDays setTextAlignment:NSTextAlignmentRight];
//    [lbUnit_finishDays setText:@"天"];
//    //课程详情-培训服务-拿证时间-底部横线
//    UIView *horizontalLine_finishDays_lower = [[UIView alloc] initWithFrame:CGRectMake(-horizontalSpace, CGRectGetHeight(viewFinishDays.frame)-LyHorizontalLineHeight, SCREEN_WIDTH, LyHorizontalLineHeight)];
//    [horizontalLine_finishDays_lower setBackgroundColor:[UIColor lightGrayColor]];
    
//    [viewFinishDays addSubview:horizontalLine_finishDays];
//    [viewFinishDays addSubview:lbTitle_finishDays];
//    [viewFinishDays addSubview:tfFinishDays];
//    [viewFinishDays addSubview:lbUnit_finishDays];
//    [viewFinishDays addSubview:horizontalLine_finishDays_lower];
    
    
    
    [viewDetail_service addSubview:lbTitleSmall_service];
    [viewDetail_service addSubview:viewDriveLicense];
    [viewDetail_service addSubview:viewCarType];
    [viewDetail_service addSubview:viewWaitDays];
    [viewDetail_service addSubview:viewTrainPeriod];
    [viewDetail_service addSubview:viewPickMode];
//    [viewDetail_service addSubview:viewPickRange];
    [viewDetail_service addSubview:viewTrainMode];
//    [viewDetail_service addSubview:viewTrainTime];
//    [viewDetail_service addSubview:viewFinishDays];
    
    
    [viewDetail_service setFrame:CGRectMake(0, viewDetail_fee.ly_y+CGRectGetHeight(viewDetail_fee.frame)+verticalSpace, SCREEN_WIDTH, viewTrainMode.ly_y+CGRectGetHeight(viewTrainMode.frame))];

    
    
    [viewDetail setFrame:CGRectMake(0, viewInfo.ly_y+CGRectGetHeight(viewInfo.frame), SCREEN_HEIGHT, viewDetail_service.ly_y+CGRectGetHeight(viewDetail_service.frame))];
    
    
    [viewDetail addSubview:lbTitle_detail];
    [viewDetail addSubview:viewDetail_fee];
    [viewDetail addSubview:viewDetail_service];
    
    
    
    [svMain addSubview:viewInfo];
    [svMain addSubview:viewDetail];
    
    //重设主滑动view的contentSize
    CGFloat fCZHeight = viewDetail.ly_y + CGRectGetHeight(viewDetail.frame) + 50.0f;
    if (fCZHeight <= CGRectGetHeight(svMain.frame)) {
        fCZHeight = CGRectGetHeight(svMain.frame) * 1.05f;
    }
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, fCZHeight)];
    
    
    //默认科目二的课时数
    curTrainMode = 1;
    curTrainPeriod.secondPeriod = 25;
    curTrainPeriod.thirdPeriod = 24;
    [self setTrainPeriod:curTrainPeriod];
    
    //默认班车接送
    [btnPickMode setSelected:YES];
}


- (void)reloadViewInfo
{
    //课程信息
    //课程信息-标题
    //课程信息-名字
    CGFloat fWidthLbName = [[_dicTcInfo objectForKey:nameKey] sizeWithAttributes:@{NSFontAttributeName:lbNameFont}].width;
    [lbName setFrame:CGRectMake( horizontalSpace, lbTitle_info.ly_y+CGRectGetHeight(lbTitle_info.frame)+verticalSpace, fWidthLbName, lbItemHeight)];
    [lbName setText:[_dicTcInfo objectForKey:nameKey]];
    //课程信息-优惠数
    NSString *strLbFoldTxt = [[NSString alloc] initWithFormat:@"省"];
    NSString *strLbFoldTmp = [[NSString alloc] initWithFormat:@"%@%.0f", strLbFoldTxt, [[_dicTcInfo objectForKey:officialPriceKey] floatValue]-[[_dicTcInfo objectForKey:whole517PriceKey] floatValue]];
    
    NSRange rangeFoldTxt = [strLbFoldTmp rangeOfString:strLbFoldTxt];
    CGSize sizeLbFold = [strLbFoldTmp sizeWithAttributes:@{NSFontAttributeName:lbItemFont}];
    
    NSMutableAttributedString *strLbFold = [[NSMutableAttributedString alloc] initWithString:strLbFoldTmp];
    [strLbFold addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeFoldTxt];
    [strLbFold addAttribute:NSBackgroundColorAttributeName value:Ly517ThemeColor range:rangeFoldTxt];
    
    [lbFold setFrame:CGRectMake( lbName.frame.origin.x+CGRectGetWidth(lbName.frame)+horizontalSpace*2, lbName.ly_y+CGRectGetHeight(lbName.frame)/2.0f-sizeLbFold.height/2.0f, sizeLbFold.width+2, sizeLbFold.height)];
    [lbFold setAttributedText:strLbFold];
    //课程信息-教练车型
    NSString *strLbCarType = [[NSString alloc] initWithFormat:@"车型：%@", [_dicTcInfo objectForKey:carNameKey]];
    CGFloat fWidthLbCarType = [strLbCarType sizeWithAttributes:@{NSFontAttributeName:lbItemFont}].width;
    [lbCarType setFrame:CGRectMake( lbName.frame.origin.x, lbName.ly_y+CGRectGetHeight(lbName.frame)+verticalSpace, fWidthLbCarType, lbItemHeight)];
    [lbCarType setText:strLbCarType];
    //课程信息-班别
    NSString *strLbTime = [[NSString alloc] initWithFormat:@"班别：%@", [_dicTcInfo objectForKey:trainClassTimeKey]];
    CGFloat fWidthLbTime = [strLbTime sizeWithAttributes:@{NSFontAttributeName:lbItemFont}].width;
    [lbTime setFrame:CGRectMake( lbCarType.frame.origin.x+CGRectGetWidth(lbCarType.frame)+horizontalSpace*2.0f, lbCarType.ly_y, fWidthLbTime, lbItemHeight)];
    [lbTime setText:strLbTime];
    //课程信息-官方价
    NSString *strLbOfficialPrice = [[NSString alloc] initWithFormat:@"官方价：￥%.0f", [[_dicTcInfo objectForKey:officialPriceKey] floatValue]];
    CGFloat fWidthLbOfficialPrice = [strLbOfficialPrice sizeWithAttributes:@{NSFontAttributeName:lbItemFont}].width;
    [lbOfficialPrice setFrame:CGRectMake( lbCarType.frame.origin.x, lbCarType.ly_y+CGRectGetHeight(lbCarType.frame)+verticalSpace, fWidthLbOfficialPrice, lbItemHeight)];
    [lbOfficialPrice setText:strLbOfficialPrice];
    //课程信息-517价
    NSString *strLb517WholePriceNum = [[NSString alloc] initWithFormat:@"%.0f", [[_dicTcInfo objectForKey:whole517PriceKey] floatValue]];
    NSString *strLb517WholePriceTmp = [[NSString alloc] initWithFormat:@"优惠价：%@", strLb517WholePriceNum];
    
    NSRange rangeLb517WholePriceNum = [strLb517WholePriceTmp rangeOfString:strLb517WholePriceNum];
    CGFloat fWidthLb517WholePrice = [strLb517WholePriceTmp sizeWithAttributes:@{NSFontAttributeName:lbItemFont}].width;
    
    NSMutableAttributedString *strLb517PWholePrice = [[NSMutableAttributedString alloc] initWithString:strLb517WholePriceTmp];
    [strLb517PWholePrice addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:rangeLb517WholePriceNum];
    
    [lb517WholePrice setFrame:CGRectMake( lbOfficialPrice.frame.origin.x+CGRectGetWidth(lbOfficialPrice.frame)+horizontalSpace*2.0f, lbOfficialPrice.ly_y, fWidthLb517WholePrice, lbItemHeight)];
    [lb517WholePrice setAttributedText:strLb517PWholePrice];
    
    
    
    //总费用
    [lbTotalFee setText:[[NSString alloc] initWithFormat:@"%@", [_dicTcInfo objectForKey:whole517PriceKey]]];
    //驾照类型
    [lbDriveLicense setText:[_dicTcInfo objectForKey:driveLicenseKey]];
    //教练车型
    [lbCarType__ setText:[_dicTcInfo objectForKey:carNameKey]];
    
}



- (void)setTrainPeriod:(LyTrainClassObjectPeriod)newTrainPeriod {
    
    curTrainPeriod = newTrainPeriod;
    [btnTrainPeriod setTitle:[[NSString alloc] initWithFormat:@"科目二：%d学时--科目三：%d学时（点击修改）", curTrainPeriod.secondPeriod, curTrainPeriod.thirdPeriod] forState:UIControlStateNormal];
}






- (UILabel *)lbSmallTitleWithTitle:(NSString *)title
{
    UILabel *tmpLb = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, 0, SCREEN_WIDTH, 30.0f)];
    [tmpLb setFont:LyFont(16)];
    [tmpLb setTextAlignment:NSTextAlignmentLeft];
    [tmpLb setTextColor:LyBlackColor];
    [tmpLb setText:title];
    [tmpLb setBackgroundColor:LyWhiteLightgrayColor];
    
    return tmpLb;
}



- (UILabel *)lbItemTitleWithTitle:(NSString *)title
{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, atcsLbTitleWidth, atcsViewItemHeight)];
    [lb setFont:lbTitleFont];
    [lb setTextColor:LyBlackColor];
    [lb setText:title];
    [lb setTextAlignment:NSTextAlignmentLeft];
    
    return lb;
}


- (UILabel *)lbItemContent
{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(atcsLbTitleWidth+horizontalSpace*2, 0, lbContentWidth, atcsViewItemHeight)];
    [lb setFont:lbContentFont];
    [lb setTextColor:[UIColor darkGrayColor]];
    [lb setTextAlignment:NSTextAlignmentLeft];
    
    return lb;

}



- (UITextView *)tvContentWithMode:(AddTrainClassSecondTextViewMode)mode
{
    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(atcsLbTitleWidth+horizontalSpace*2, viewItemBigHeight/2.0f-tvContentHeight/2.0f, tvContentWidth, tvContentHeight)];
    [tv setTag:mode];
    [tv setFont:lbContentFont];
    [tv setTextAlignment:NSTextAlignmentLeft];
    [tv setTextColor:[UIColor darkGrayColor]];
    [[tv layer] setBorderWidth:1.0f];
    [[tv layer] setBorderColor:[LyWhiteLightgrayColor CGColor]];
    [[tv layer] setCornerRadius:btnCornerRadius];
    [tv setReturnKeyType:UIReturnKeyDone];
    [tv setDelegate:self];
    
    return tv;
}


- (UITextField *)tfContentWithMode:(AddTrainClassSecondTextfieldMode)mode
{
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(atcsLbTitleWidth+horizontalSpace, 0, tfContentWidth, atcsViewItemHeight)];
    [tf setTag:mode];
    [tf setTextColor:[UIColor darkGrayColor]];
    [tf setFont:lbContentFont];
    [tf setTextAlignment:NSTextAlignmentLeft];
    [tf setReturnKeyType:UIReturnKeyDone];
    
    
    return tf;
}


- (UIButton *)buttonWithMode:(AddTrainClassSecondButtonMode)mode
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(atcsLbTitleWidth+horizontalSpace, 0, lbContentWidth, atcsViewItemHeight)];
    [btn setTag:mode];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:lbContentFont];
    [btn.titleLabel setNumberOfLines:0];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    switch (mode) {
        case addTrainClassSecondButtonMode_trainPeriod: {
            [btn setTitle:btnTrainPeriodDefaultTitle forState:UIControlStateNormal];
            break;
        }
        case addTrainClassSecondButtonMode_trainMode: {
            [btn setTitle:btnTrainModeDefaultTitle forState:UIControlStateNormal];
            break;
        }
        case addTrainClassSecondButtonMode_trainTime: {
            [btn setTitle:btnTrainTimeDefaultTitle forState:UIControlStateNormal];
            break;
        }
        default: {
            
            break;
        }
    }
    
    [btn addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];

    return btn;
}


//- (UIView *)topHorizontalLine
//{
//    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(-horizontalSpace, 0, SCREEN_WIDTH, LyHorizontalLineHeight)];
//    [horizontalLine setBackgroundColor:[UIColor lightGrayColor]];
//    
//    return horizontalLine;
//}



- (void)allControlResignFirstResponder
{
    [tvInclude resignFirstResponder];
    [tfWaitDays resignFirstResponder];
//    [tvPickRange resignFirstResponder];
//    [tfFinishDays resignFirstResponder];
}



- (void)addObserverFormNoficationFromKeyboard
{
    if ([self respondsToSelector:@selector(targetForNotificationFromKeyboardWillShow:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(targetForNotificationFromKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    
    if ([self respondsToSelector:@selector(targetForNotificationFromKeyboardWillHide:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(targetForNotificationFromKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}


- (void)removeObserverForNoficationFromKeyboard
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}



- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    
    [self allControlResignFirstResponder];
    
    if (addTrainClassSecondBarButtonItemTag_add == bbi.tag) {
        [self add];
    }
    
}


- (void)targetForButton:(UIButton *)button
{
    [self allControlResignFirstResponder];
    
    AddTrainClassSecondButtonMode btnTag = button.tag;
    switch (btnTag) {
        case addTrainClassSecondButtonMode_trainPeriod: {
            LyTrainPeriodPicker *trainPeriodPicker = [[LyTrainPeriodPicker alloc] init];
            //        if (![btnTrainPeriod.titleLabel.text isEqualToString:btnTrainPeriodDefaultTitle])
            //        {
            [trainPeriodPicker setTrainPeriod:curTrainPeriod];
            //        }
            [trainPeriodPicker setDelegate:self];
            [trainPeriodPicker show];
            break;
        }
        case addTrainClassSecondButtonMode_pickMode: {
            [btnPickMode setSelected:!btnPickMode.isSelected];
            break;
        }
        case addTrainClassSecondButtonMode_trainMode: {
            LyTrainModePicker *trainModePicker = [[LyTrainModePicker alloc] init];
            if (![btnTrainMode.titleLabel.text isEqualToString:btnTrainModeDefaultTitle])
            {
                [trainModePicker setTrainModeByString:btnTrainMode.titleLabel.text];
            }
            [trainModePicker setDelegate:self];
            [trainModePicker show];
            break;
        }
        case addTrainClassSecondButtonMode_trainTime: {
            LyTrainTimePicker *trainTimePicker = [[LyTrainTimePicker alloc] init];
            if (![btnTrainMode.titleLabel.text isEqualToString:btnTrainModeDefaultTitle])
            {
                [trainTimePicker setTrainTimeBucket:trainTimeBucket];
            }
            [trainTimePicker setDelegate:self];
            [trainTimePicker show];
            break;
        }
    }
}


- (void)targetForNotificationFromKeyboardWillShow:(NSNotification *)notifi
{
    CGFloat fHeightKeyboard = [[[notifi userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat y = 0;
    
    if ([tvInclude isFirstResponder]) {
        y = (viewDetail.ly_y+viewDetail_fee.ly_y+viewInclude.ly_y+CGRectGetHeight(viewInclude.frame))-(SCREEN_HEIGHT-fHeightKeyboard-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT) + LyViewItemHeight;
    } else if ([tfWaitDays isFirstResponder]) {
        y = (viewDetail.ly_y+viewDetail_service.ly_y+viewWaitDays.ly_y+CGRectGetHeight(viewWaitDays.frame))-(SCREEN_HEIGHT-fHeightKeyboard-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT)  + LyViewItemHeight;
    }
    
    if (y > 0) {
        [svMain setContentOffset:CGPointMake(0, y)];
    }
}


- (void)targetForNotificationFromKeyboardWillHide:(NSNotification *)notifi
{
    if (svMain.contentOffset.y > svMain.contentSize.height - CGRectGetHeight(svMain.frame))
    {
        [svMain setContentOffset:CGPointMake(0, svMain.contentSize.height - CGRectGetHeight(svMain.frame)) animated:YES];
    }
}




- (BOOL)validate:(BOOL)flag {
    
    if (tvInclude.text.length < 1) {
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"包含费用内容不可空"] show];
        }
        return NO;
    }
    
    if (tfWaitDays.text.length > 0 && ![tfWaitDays.text validateInt]) {
        if (flag) {
            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"排队时间格式错误"] show];
        }
        return NO;
    }
    
    
    
    return YES;
}


- (void)add {
    if (![self validate:YES]) {
        return;
    }
    
    if (!indicator_add) {
        indicator_add = [LyIndicator indicatorWithTitle:@"正在添加..."];
    }
    [indicator_add startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:addTrainClassSecondHttpMethod_add];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:addTrainClass_url
                                 body:@{
                                        masterIdKey:[LyCurrentUser curUser].userId,
                                        userTypeKey:[[LyCurrentUser curUser] userTypeByString],
                                        
                                        nameKey:[_dicTcInfo objectForKey:nameKey],
                                        carNameKey:[_dicTcInfo objectForKey:carNameKey],
                                        trainClassTimeKey:[_dicTcInfo objectForKey:trainClassTimeKey],
                                        officialPriceKey:[_dicTcInfo objectForKey:officialPriceKey],
                                        whole517PriceKey:[_dicTcInfo objectForKey:whole517PriceKey],
                                        prepay517priceKey:[_dicTcInfo objectForKey:prepay517priceKey],
                                        driveLicenseKey:[_dicTcInfo objectForKey:driveLicenseKey],
                                        
                                        addressKey:@"",
                                        includeKey:tvInclude.text,
                                        waitDayKey:@((tfWaitDays.text.length > 0) ? tfWaitDays.text.integerValue : 0),
                                        objectSecondCountKey:@(curTrainPeriod.secondPeriod),
                                        objectThirdCountKey:@(curTrainPeriod.thirdPeriod),
                                        trainModeKey:[LyUtil trainModeStringFrom:curTrainMode],
                                        pickModeKey:@((btnPickMode.selected) ? 1 : 0),
                                        userIdKey:[LyCurrentUser curUser].userId,
                                        sessionIdKey:[LyUtil httpSessionId]
                                        }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)handleHttpFailed {
    if ([indicator_add isAnimating]) {
        [indicator_add stopAnimation];
        LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"添加失败"];
        [remind show];
    }
}


- (void)anaslysisHttpResult:(NSString *)result
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
        case addTrainClassSecondHttpMethod_add: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [indicator_add stopAnimation];
                        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"添加失败"] show];
                        
                        return;
                    }
                    
                    NSString *strId = [dicResult objectForKey:trainClassIdKey];
                    NSString *strName = [dicResult objectForKey:nameKey];
                    NSString *strCarName = [dicResult objectForKey:carNameKey];
                    NSString *strTrainTime = [dicResult objectForKey:trainClassTimeKey];
                    NSString *strOfficialPrice = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:officialPriceKey]];
                    NSString *str517WholePrice = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:whole517PriceKey]];
                    NSString *str517PrepayPrice = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:whole517PriceKey]];
                    NSString *strDeposit = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:depositKey]];
                    NSString *strInclude = [dicResult objectForKey:includeKey];
                    NSString *strDriveLicense = [dicResult objectForKey:driveLicenseKey];
                    NSString *strWaitDays = [dicResult objectForKey:waitDayKey];
                    NSString *strObjectSecondCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:objectSecondCountKey]];
                    NSString *strObjectThirdCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:objectThirdCountKey]];
                    NSString *strPickMode = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:pickModeKey]];
                    NSString *strTrainMode = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:trainModeKey]];
                    
                    
                    LyTrainClass *trainClass = [[LyTrainClassManager sharedInstance] getTrainClassWithTrainClassId:strId];
                    if (!trainClass) {
                        trainClass = [LyTrainClass trainClassWithTrainClassId:strId
                                                                       tcName:strName
                                                                   tcMasterId:[LyCurrentUser curUser].userId
                                                                  tcTrainTime:strTrainTime
                                                                    tcCarName:strCarName
                                                                    tcInclude:strInclude
                                                                       tcMode:[LyCurrentUser curUser].userType-LyUserType_coach+LyTrainClassMode_coach
                                                                tcLicenseType:[LyUtil driveLicenseFromString:strDriveLicense]
                                                              tcOfficialPrice:[strOfficialPrice floatValue]
                                                              tc517WholePrice:[str517WholePrice floatValue]
                                                             tc517PrepayPrice:[str517PrepayPrice floatValue]
                                                           tc517PrePayDeposit:[strDeposit floatValue]];
                        
                        [trainClass setTcWaitDays:[strWaitDays intValue]];
                        LyTrainClassObjectPeriod objectPeriod = {[strObjectSecondCount intValue], [strObjectThirdCount intValue]};
                        [trainClass setTcObjectPeriod:objectPeriod];
                        [trainClass setTcPickType:[strPickMode integerValue]];
                        [trainClass setTcTrainMode:[LyUtil trainModeFromString:strTrainMode]];
                        
                        [[LyTrainClassManager sharedInstance] addTrainClass:trainClass];
                    }
                    
                    [indicator_add stopAnimation];
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
        
        [self anaslysisHttpResult:result];
    }
    
    curHttpMethod = 0;
}


#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(LyRemindView *)aRemind
{
    [_delegate onDoneAddTrainClassByLyAddTrainClassSecondViewController:self];
}



#pragma mark -UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self validate:NO];
}


#pragma mark -UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}




#pragma mark -LyTrainPeriodPicker
- (void)onCancenByTrainPeriodPicker:(LyTrainPeriodPicker *)aTrainPeriodPicker
{
    [aTrainPeriodPicker hide];
}

- (void)onDoneByTrainPeriodPicker:(LyTrainPeriodPicker *)aTrainPeriodPicker trainPeriod:(LyTrainClassObjectPeriod)aTrainPeriod
{
    [aTrainPeriodPicker hide];

    [self setTrainPeriod:aTrainPeriod];
}



#pragma mark -LyTrainModePicker
- (void)onCancelByTrainModePicker:(LyTrainModePicker *)aTrainModePicker
{
    [aTrainModePicker hide];
}

- (void)onDoneByTrainModePicker:(LyTrainModePicker *)aTrainModePicker trainMode:(LyTrainClassTrainMode)aTrainMode
{
    [aTrainModePicker hide];
    
    curTrainMode = aTrainMode;
    
    [btnTrainMode setTitle:[LyUtil trainModeStringFrom:curTrainMode] forState:UIControlStateNormal];
}


//#pragma mark -LyTrainTimePicker
//- (void)onCancelByTrainTimePicker:(LyTrainTimePicker *)aTrainTimePicker
//{
//    [aTrainTimePicker hide];
//}
//
//- (void)onDoneByTrainTimePicker:(LyTrainTimePicker *)aTrainTimePicker trainTimeBucket:(LyTimeBucket)aTrainTimeBucket
//{
//    [aTrainTimePicker hide];
//    
//    trainTimeBucket = aTrainTimeBucket;
//    
//    [btnTrainTime setTitle:[[NSString alloc] initWithFormat:@"%d:00--%d:00", trainTimeBucket.begin, trainTimeBucket.end] forState:UIControlStateNormal];
//}


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
