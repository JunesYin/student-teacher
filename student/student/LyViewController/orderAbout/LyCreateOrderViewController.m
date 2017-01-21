//
//  LyCreateOrderViewController.m
//  student
//
//  Created by Junes on 2016/11/7.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyCreateOrderViewController.h"
#import "LyApplyModeTableViewCell.h"
#import "LyAddressAlertView.h"

#import "LyToolBar.h"
#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyUserManager.h"
#import "LyTrainClassManager.h"
#import "LyOrderManager.h"
#import "LyCurrentUser.h"

#import "NSString+Validate.h"
#import "UITextView+placeholder.h"
#import "UITextView+textCount.h"
#import "LyUtil.h"


#import "LyOrderInfoViewController.h"


#define svMainHeight                            (SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT - viewControlBarHeight - 2)

#define coLbItemTitleFont                       LyFont(16)
#define coLbItemTitleTextColor                  [UIColor blackColor]
#define coLbItemInputFont                       LyFont(14)
#define coLbItemInputTextColor                  LyBlackColor



//商品信息
CGFloat const coViewGoodsInfoHeight = 100.0f;
//商品信息-商品头像
CGFloat const coIvGoodsSize = 80.0f;
//商品信息-商品名
#define tvGoodsNameWidth                        (SCREEN_WIDTH - coIvGoodsSize- horizontalSpace * 3)
#define tvGoodsNameHeight                       (coViewGoodsInfoHeight * 2 / 5.0f)
#define tvGoodsFont                             LyFont()
//商品信息-商品详情
#define tvGoodsDetailWidth                      tvGoodsNameWidth
#define tvGoodsDetailHeight                     (coViewGoodsInfoHeight * 3 / 5.0f)
#define tvGoodsDetailFont                       LyFont()



//订单信息

//订单信息-报名方式
#define viewApplyModeHeight                     (amtcHeight * [LyUtil applyModeNum])
//订单信息-报名方式-表格
#define tvApplyModeWidth



//控制台
CGFloat const viewControlBarHeight = 50.0f;



typedef NS_ENUM(NSInteger, LyCreateOrderTextFieldTag) {
    createOrderTextFieldTag_name = 10,
    createOrderTextFieldTag_stuCount,
    createOrderTextFieldTag_phone
};


typedef NS_ENUM(NSInteger, LyCreateOrderButtonTag) {
    createOrderButtonTag_address = 20,
    createOrderButtonTag_create,
};


typedef NS_ENUM(NSInteger, LyCreateOrderTextViewTag) {
    createOrderTextViewTag_remark = 30,
};


typedef NS_ENUM( NSInteger, LyCreateOrderHttpMethod) {
    createOrderHttpMethod_create = 100
};


@interface LyCreateOrderViewController () <UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, LyHttpRequestDelegate, LyOrderInfoViewControllerdelegate, LyAddressAlertViewDelegate>
{
    UIScrollView                *svMain;
    
    //商品信息
    UIView                      *viewGoodsInfo;
    UIImageView                 *ivGoods;
    UITextView                  *tvGoodsName;
    UITextView                  *tvGoodsDetail;
    
    //订单信息
    UIView                      *viewOrderInfo;
    UITextField                 *tfName;
    UITextField                 *tfStuCount;
    UITextField                 *tfPhone;
    UIView                      *viewAddress;
    UIButton                    *btnAddress;
    UIView                      *viewApplyMode;
    UITableView                 *tvApplyMode;
    UIView                      *viewRemark;
    UITextView                  *tvRemark;
    
    //控制台
    UIView                      *controlBar;
    UIButton                    *btnCreate;
    
    
    NSIndexPath                 *curIdx;
    LyOrder                     *curOrder;
    
    LyIndicator                 *indicator;
    BOOL                        bHttpFlag;
    LyCreateOrderHttpMethod     curHttpMethod;
}
@end

@implementation LyCreateOrderViewController


static NSString *lyCreateOrderTvApplyModeCellReuseIdentifier = @"lyCreateOrderTvApplyModeCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [self coAddKeyboardEventNotification];
    
    if ( [_delegate respondsToSelector:@selector(obtainGoodsInfo_crateOrder)]) {
        _goodsInfo = [_delegate obtainGoodsInfo_crateOrder];
        
        if ( !_goodsInfo) {
            return;
        }
    } else {
        return;
    }
    
    
    [self reloadData_GoodsInfo];
    
}


- (void)viewDidDisappear:(BOOL)animated {
    [self coRemoveKeyboardEventNotification];
}


- (void)initSubviews {
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.title = @"填写订单";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, svMainHeight)];
    [svMain setDelegate:self];
    [svMain setBounces:YES];
    [svMain setBackgroundColor:LyWhiteLightgrayColor];
    
    
    //商品信息
    viewGoodsInfo = [[UIView alloc] initWithFrame:CGRectMake(0, verticalSpace, SCREEN_WIDTH, coViewGoodsInfoHeight)];
    viewGoodsInfo.backgroundColor = [UIColor whiteColor];
    //商品信息-商品头像
    ivGoods = [[UIImageView alloc] initWithFrame:CGRectMake(horizontalSpace, coViewGoodsInfoHeight/2.0f - coIvGoodsSize/2.0f, coIvGoodsSize, coIvGoodsSize)];
    [ivGoods setContentMode:UIViewContentModeScaleAspectFill];
    [ivGoods.layer setCornerRadius:btnCornerRadius];
    [ivGoods setClipsToBounds:YES];
    //商品信息-商品名
    tvGoodsName = [[UITextView alloc] initWithFrame:CGRectMake(coIvGoodsSize + horizontalSpace * 2, 0, tvGoodsNameWidth, tvGoodsNameHeight)];
    [tvGoodsName setEditable:NO];
    [tvGoodsName setSelectable:NO];
    [tvGoodsName setTextAlignment:NSTextAlignmentLeft];
    [tvGoodsName setTextColor:[UIColor blackColor]];
    [tvGoodsName setFont:coLbItemTitleFont];
    //商品信息-商品详情
    tvGoodsDetail = [[UITextView alloc] initWithFrame:CGRectMake(tvGoodsName.frame.origin.x, tvGoodsName.frame.origin.y + CGRectGetHeight(tvGoodsName.frame), tvGoodsDetailWidth, tvGoodsDetailHeight)];
    [tvGoodsDetail setEditable:NO];
    [tvGoodsDetail setSelectable:NO];
    [tvGoodsDetail setTextAlignment:NSTextAlignmentLeft];
    [tvGoodsDetail setTextColor:LyBlackColor];
    [tvGoodsDetail setFont:coLbItemInputFont];

    [viewGoodsInfo addSubview:ivGoods];
    [viewGoodsInfo addSubview:tvGoodsName];
    [viewGoodsInfo addSubview:tvGoodsDetail];
    
    
    //订单信息
    viewOrderInfo = [[UIView alloc] init];
    viewOrderInfo.backgroundColor = LyWhiteLightgrayColor;
    //订单信息-姓名
    tfName = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LyViewItemHeight)];
    [tfName setTag:createOrderTextFieldTag_name];
    [tfName setDelegate:self];
    [tfName setFont:coLbItemInputFont];
    [tfName setTextAlignment:NSTextAlignmentLeft];
    [tfName setTextColor:coLbItemInputTextColor];
    [tfName setReturnKeyType:UIReturnKeyNext];
    [tfName setBackgroundColor:[UIColor whiteColor]];
    
    [tfName setLeftView:[self getLableItem:@"学员姓名"]];
    [tfName setLeftViewMode:UITextFieldViewModeAlways];
    [tfName setClearButtonMode:UITextFieldViewModeWhileEditing];
    //订单信息-人数
    tfStuCount = [[UITextField alloc] initWithFrame:CGRectMake(0, tfName.frame.origin.y + CGRectGetHeight(tfName.frame) + LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [tfStuCount setTag:createOrderTextFieldTag_stuCount];
    [tfStuCount setDelegate:self];
    [tfStuCount setFont:coLbItemInputFont];
    [tfStuCount setTextAlignment:NSTextAlignmentLeft];
    [tfStuCount setTextColor:coLbItemInputTextColor];
    [tfStuCount setReturnKeyType:UIReturnKeyNext];
    [tfStuCount setKeyboardType:UIKeyboardTypeNumberPad];
    [tfStuCount setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfStuCount]];
    [tfStuCount setBackgroundColor:[UIColor whiteColor]];
    
    [tfStuCount setLeftView:[self getLableItem:@"学员人数"]];
    [tfStuCount setLeftViewMode:UITextFieldViewModeAlways];
    [tfStuCount setClearButtonMode:UITextFieldViewModeWhileEditing];
    //订单信息-电话
    tfPhone = [[UITextField alloc] initWithFrame:CGRectMake(0, tfStuCount.frame.origin.y + CGRectGetHeight(tfStuCount.frame) + LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [tfPhone setTag:createOrderTextFieldTag_phone];
    [tfPhone setDelegate:self];
    [tfPhone setFont:coLbItemInputFont];
    [tfPhone setTextAlignment:NSTextAlignmentLeft];
    [tfPhone setTextColor:coLbItemInputTextColor];
    [tfPhone setReturnKeyType:UIReturnKeyNext];
    [tfPhone setKeyboardType:UIKeyboardTypeNumberPad];
    [tfPhone setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfPhone]];
    [tfPhone setBackgroundColor:[UIColor whiteColor]];
    
    [tfPhone setLeftView:[self getLableItem:@"联系电话"]];
    [tfPhone setLeftViewMode:UITextFieldViewModeAlways];
    [tfPhone setClearButtonMode:UITextFieldViewModeWhileEditing];
    //订单信息-地址
    viewAddress = [[UIView alloc] initWithFrame:CGRectMake(0, tfPhone.frame.origin.y + CGRectGetHeight(tfPhone.frame) + LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight)];
    [viewAddress setBackgroundColor:[UIColor whiteColor]];
    //订单信息-地址-标题
    UILabel *lbTitle_address = [self getLableItem:@"接送地址"];
    //订单信息-地址-内容
    btnAddress = [[UIButton alloc] initWithFrame:CGRectMake(lbTitle_address.frame.origin.x + CGRectGetWidth(lbTitle_address.frame) + horizontalSpace, 0, SCREEN_WIDTH - CGRectGetWidth(lbTitle_address.frame) - horizontalSpace * 2, CGRectGetHeight(viewAddress.frame))];
    [btnAddress setTag:createOrderButtonTag_address];
    [btnAddress setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnAddress.titleLabel setFont:coLbItemInputFont];
    [btnAddress.titleLabel setNumberOfLines:0];
    [btnAddress setTitleColor:coLbItemInputTextColor forState:UIControlStateNormal];
    [btnAddress addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewAddress addSubview:lbTitle_address];
    [viewAddress addSubview:btnAddress];
    //订单信息-报名方式
    viewApplyMode = [[UIView alloc] initWithFrame:CGRectMake(0, viewAddress.frame.origin.y + CGRectGetHeight(viewAddress.frame) + LyHorizontalLineHeight, SCREEN_WIDTH, viewApplyModeHeight)];
    [viewApplyMode setBackgroundColor:[UIColor whiteColor]];
    //订单信息-报名方式-标题
    UILabel *lbTitle_applyMode = [self getLableItem:@"报名方式"];
    //订单信息-报名方式-表格
    tvApplyMode = [[UITableView alloc] initWithFrame:CGRectMake(lbTitle_applyMode.frame.origin.x + CGRectGetWidth(lbTitle_applyMode.frame), 0, SCREEN_WIDTH - CGRectGetWidth(lbTitle_applyMode.frame), viewApplyModeHeight)
                                               style:UITableViewStylePlain];
    [tvApplyMode setDelegate:self];
    [tvApplyMode setDataSource:self];
    [tvApplyMode setBackgroundColor:[UIColor clearColor]];
    [tvApplyMode setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tvApplyMode setScrollsToTop:NO];
    [tvApplyMode setScrollEnabled:NO];
    
    [viewApplyMode addSubview:lbTitle_applyMode];
    [viewApplyMode addSubview:tvApplyMode];
    //订单信息-备注
    viewRemark = [[UIView alloc] initWithFrame:CGRectMake(0, viewApplyMode.frame.origin.y + CGRectGetHeight(viewApplyMode.frame) + LyHorizontalLineHeight, SCREEN_WIDTH, LyViewItemHeight * 1.5f)];
    [viewRemark setBackgroundColor:[UIColor whiteColor]];
    //订单信息-备注-标题
    UILabel *lbTitle_remark = [self getLableItem:@"备注"];
    //订单信息-备注-内容
    tvRemark = [[UITextView alloc] initWithFrame:CGRectMake(lbTitle_remark.frame.origin.x + CGRectGetWidth(lbTitle_remark.frame) + horizontalSpace, CGRectGetHeight(viewRemark.frame) / 20.0f, SCREEN_WIDTH - CGRectGetWidth(lbTitle_remark.frame) - horizontalSpace * 3, CGRectGetHeight(viewRemark.frame) * 9 / 10.0f)];
    [tvRemark setDelegate:self];
    [tvRemark setFont:coLbItemInputFont];
    [tvRemark setPlaceholder:@"无"];
    [tvRemark setTextColor:coLbItemInputTextColor];
    [[tvRemark layer] setCornerRadius:5.0f];
    [[tvRemark layer] setBorderWidth:1.0f];
    [[tvRemark layer] setBorderColor:[LyWhiteLightgrayColor CGColor]];
    [tvRemark setTag:createOrderTextViewTag_remark];;
    [tvRemark setDelegate:self];
    [tvRemark setReturnKeyType:UIReturnKeyDone];
    [tvRemark setTextCount:LyEvaluationLengthMax];
    
    [viewRemark addSubview:lbTitle_remark];
    [viewRemark addSubview:tvRemark];
    
    
    [viewOrderInfo addSubview:tfName];
    [viewOrderInfo addSubview:tfStuCount];
    [viewOrderInfo addSubview:tfPhone];
    [viewOrderInfo addSubview:viewAddress];
    [viewOrderInfo addSubview:viewApplyMode];
    [viewOrderInfo addSubview:viewRemark];
    
    [viewOrderInfo setFrame:CGRectMake(0, viewGoodsInfo.frame.origin.y + CGRectGetHeight(viewGoodsInfo.frame) + verticalSpace, SCREEN_WIDTH, viewRemark.frame.origin.y + CGRectGetHeight(viewRemark.frame))];
    
    
    [svMain addSubview:viewGoodsInfo];
    [svMain addSubview:viewOrderInfo];
    
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, viewOrderInfo.frame.origin.y + CGRectGetHeight(viewOrderInfo.frame) + 50.0f)];
    
    
    //控制台
    controlBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - viewControlBarHeight, SCREEN_WIDTH, viewControlBarHeight)];
    [controlBar setBackgroundColor:[UIColor whiteColor]];
    [controlBar setAlpha:0.9f];
    
    btnCreate = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(controlBar.frame), CGRectGetHeight(controlBar.frame))];
    [btnCreate setTag:createOrderButtonTag_create];
    [btnCreate setTitle:@"马上报名" forState:UIControlStateNormal];
    [btnCreate setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnCreate.titleLabel setFont:coLbItemTitleFont];
    [btnCreate addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [controlBar addSubview:btnCreate];
    
    [self.view addSubview:svMain];
    [self.view addSubview:controlBar];
    
    
    
    
    [tfName setText:[LyCurrentUser curUser].userName];
    [tfStuCount setText:@"1"];
    [tfPhone setText:[LyCurrentUser curUser].userPhoneNum];
    if ([LyUtil validateString:[LyCurrentUser curUser].location.wholeAddress]) {
        [btnAddress setTitle:[LyCurrentUser curUser].location.wholeAddress forState:UIControlStateNormal];
    }
    
    curIdx = [NSIndexPath indexPathForRow:LyApplyMode_whole inSection:0];
    [tvApplyMode selectRowAtIndexPath:curIdx animated:NO scrollPosition:UITableViewScrollPositionNone];
    
}

- (void)reloadData_GoodsInfo {
    
    if ([[_goodsInfo objectForKey:goodKey] isKindOfClass:[LyTrainClass class]]) {
        LyTrainClass *trianClass = [_goodsInfo objectForKey:goodKey];
        LyUser *teacher = [_goodsInfo objectForKey:teacherKey];
        
        switch (teacher.userType) {
            case LyUserType_normal: {
                //nothging
                break;
            }
            case LyUserType_school: {
                LyDriveSchool *driveSchool = (LyDriveSchool *)teacher;
                
                if (!driveSchool.userAvatar) {
                    [ivGoods sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:[driveSchool userId]]
                               placeholderImage:[LyUtil defaultAvatarForTeacher]
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                          if (image) {
                                                [driveSchool setUserAvatar:image];
                                          } else {
                                              [ivGoods sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:driveSchool.userId]
                                                         placeholderImage:[LyUtil defaultAvatarForTeacher]
                                                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                    if (image)
                                                                    {
                                                                        [driveSchool setUserAvatar:image];
                                                                    }
                                                                }];
                                          }
                                      }];
                } else {
                    [ivGoods setImage:driveSchool.userAvatar];
                }
                
                [tvGoodsName setText:driveSchool.userName];
                [tvGoodsDetail setText:trianClass.tcName];
                break;
            }
            case LyUserType_coach: {
                LyCoach *coach = (LyCoach *)teacher;
                
                if (!coach.userAvatar)
                {
                    [ivGoods sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:[coach userId]]
                               placeholderImage:[LyUtil defaultAvatarForTeacher]
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                          if (image) {
                                              [coach setUserAvatar:image];
                                          } else {
                                              [ivGoods sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:coach.userId]
                                                         placeholderImage:[LyUtil defaultAvatarForTeacher]
                                                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                    if (image) {
                                                                        [coach setUserAvatar:image];
                                                                    }
                                                                }];
                                          }}];
                } else {
                    [ivGoods setImage:coach.userAvatar];
                }
                
                [tvGoodsName setText:coach.userName];
                [tvGoodsDetail setText:trianClass.tcName];
                break;
            }
            case LyUserType_guider: {
                LyGuider *guider = (LyGuider *)teacher;
                
                if (!guider.userAvatar) {
                    [ivGoods sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:[guider userId]]
                               placeholderImage:[LyUtil defaultAvatarForTeacher]
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                          if (image) {
                                              [guider setUserAvatar:image];
                                          } else {
                                              [ivGoods sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:guider.userId]
                                                         placeholderImage:[LyUtil defaultAvatarForTeacher]
                                                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                    if (image) {
                                                                        [guider setUserAvatar:image];
                                                                    }
                                                                }];
                                          }
                                      }];
                } else {
                    [ivGoods setImage:[guider userAvatar]];
                }
                
                [tvGoodsName setText:guider.userName];
                
                [tvGoodsDetail setText:trianClass.tcName];
                break;
            }
        }
    }
    
}


- (UILabel *)getLableItem:(NSString *)text {
    UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, LyLbTitleItemWidth, LyViewItemHeight)];
    [tmpLable setText:text];
    [tmpLable setTextColor:coLbItemTitleTextColor];
    [tmpLable setFont:coLbItemTitleFont];
    [tmpLable setTextAlignment:NSTextAlignmentCenter];
    [tmpLable setBackgroundColor:[UIColor clearColor]];
    [tmpLable setUserInteractionEnabled:YES];
    
    return tmpLable;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)coAddKeyboardEventNotification
{
    //增加监听，当键盘出现或改变时收出消息
    if ( [self respondsToSelector:@selector(coTargetForNotificationToKeyboardWillShow:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coTargetForNotificationToKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    
    //增加监听，当键退出时收出消息
    if ( [self respondsToSelector:@selector(coTargetForNotificationToKeyboardWillHide:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coTargetForNotificationToKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)coRemoveKeyboardEventNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)allControlResignFirstResponder
{
    [tfName resignFirstResponder];
    [tfStuCount resignFirstResponder];
    [tfPhone resignFirstResponder];
    [tvRemark resignFirstResponder];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self allControlResignFirstResponder];
}


- (BOOL)validate_create
{
    if (![tfName.text validateName])
    {
        [tfName setTextColor:LyWarnColor];
        
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"姓名格式错误"] show];
        return NO;
    }
    
    if (![tfStuCount.text validateInt])
    {
        
        
        return NO;
    }
    
    if ( ![tfPhone.text validatePhoneNumber])
    {
        [tfPhone setTextColor:LyWarnColor];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号格式错误"] show];
        return NO;
    }
    
    
    if ([btnAddress.titleLabel.text isEqualToString:@"点击选择地址"])
    {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"你还没有选择地址"] show];
        return NO;
    }
    
    
    return YES;
}


- (void)targetForButton:(UIButton *)button {
    
    LyCreateOrderButtonTag btnTag = button.tag;
    switch (btnTag) {
        case createOrderButtonTag_address: {
            LyAddressAlertView *addressAlert = [LyAddressAlertView addressAlertViewWithAddress:btnAddress.titleLabel.text];
            [addressAlert setDelegate:self];
            [addressAlert show];
            break;
        }
        case createOrderButtonTag_create: {
            
            if ( ![self validate_create])
            {
                return;
            }
            
            LyTrainClass *trainClass = [_goodsInfo objectForKey:goodKey];
            
            float fPrice = 0;
            switch ( curIdx.row) {
                case LyApplyMode_whole: {
                    fPrice = trainClass.tc517WholePrice;
                    break;
                }
                case LyApplyMode_prepay: {
                    fPrice = trainClass.tc517PrePayDeposit;
                    
                    break;
                }
            }
            fPrice *= tfStuCount.text.intValue;
            [self createOrder:@(fPrice)];
            break;
        }
    }
}



- (void)createOrder:(NSNumber *)nPrice {
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(createOrder:) object:nPrice];
        return;
    }
    
    if ( !indicator)
    {
        indicator = [[LyIndicator alloc] initWithTitle:@"创建订单"];
    }
    [indicator startAnimation];
    
    
    NSDictionary *dic;
    
    float price = nPrice.floatValue;
    
    if ( [[_goodsInfo objectForKey:goodKey] isKindOfClass:[LyTrainClass class]]) {
        
        LyUser *teacher = [_goodsInfo objectForKey:teacherKey];
        
        dic = @{
                masterIdKey:[[LyCurrentUser curUser] userId],
                consigneeKey:tfName.text,
                phoneKey:tfPhone.text,
                addressKey:btnAddress.titleLabel.text,
                objectIdKey:[[_goodsInfo objectForKey:teacherKey] userId],
                classIdKey:[[_goodsInfo objectForKey:goodKey] tcId],
                remarkKey:tvRemark.text,
                orderModeKey:@(teacher.userType),
                studentCountKey:tfStuCount.text,
                applyModeKey:( 0 == curIdx.row) ? @"0" : @"1",
                orderPriceKey:[[NSString alloc] initWithFormat:@"%.2f", price],
                couponModeKey:@"0",
                orderNameKey:tvGoodsName.text,
                orderDetailKey:tvGoodsDetail.text,
                subjectModeKey:@(1),
                sessionIdKey:[LyUtil httpSessionId],
                userTypeKey:[teacher userTypeByString]
                };
    }
//    else if ( [[_goodsInfo objectForKey:goodKey] isKindOfClass:[LyReservation class]])
//    {
//        
//    }
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:createOrderHttpMethod_create];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:createOrder_url
                                   body:dic
                                   type:LyHttpType_asynPost
                                       timeOut:0] boolValue];
}


- (void)handleHttpFailed {
    if ([indicator isAnimating]) {
        [indicator stopAnimation];
        
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"创建失败"] show];
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
        [indicator stopAnimation];
        
        [LyUtil sessionTimeOut:self];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    switch ( curHttpMethod) {
        case createOrderHttpMethod_create: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicOrder = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicOrder]) {
                        [self handleHttpFailed];
                        return;
                    }
                    
                    
                    NSString *strOrderId = [dicOrder objectForKey:orderIdKey];
                    NSString *strMasterId = [dicOrder objectForKey:masterIdKey];
                    NSString *strOrderName = [dicOrder objectForKey:orderNameKey];
                    NSString *strOrderDetail = [dicOrder objectForKey:orderDetailKey];
                    NSString *strPhone = [dicOrder objectForKey:phoneKey];
                    NSString *strAddress = [dicOrder objectForKey:addressKey];
                    NSString *strTrainBaseName = [dicOrder objectForKey:trainBaseNameKey];
                    NSString *strRemark = [dicOrder objectForKey:remarkKey];
                    NSString *strMode = [[NSString alloc] initWithFormat:@"%@", [dicOrder objectForKey:orderModeKey]];
                    NSString *strApplyMode = [[NSString alloc] initWithFormat:@"%@", [dicOrder objectForKey:applyModeKey]];
                    NSString *strStuCount = [[NSString alloc] initWithFormat:@"%@", [dicOrder objectForKey:studentCountKey]];
                    NSString *strConsignee = [dicOrder objectForKey:consigneeKey];
                    NSString *strObjectId = [dicOrder objectForKey:objectIdKey];
                    NSString *strClassId = [dicOrder objectForKey:classIdKey];
                    NSString *strTime = [dicOrder objectForKey:orderTimeKey];
                    NSString *strPrice = [[NSString alloc] initWithFormat:@"%@", [dicOrder objectForKey:orderPriceKey]];
                    NSString *strPreferentialPrice = [[NSString alloc] initWithFormat:@"%@", [dicOrder objectForKey:orderPreferentialPriceKey]];
                    NSString *strPainNum = [[NSString alloc] initWithFormat:@"%@", [dicOrder objectForKey:paidNumKey]];
                    NSString *strState = [[NSString alloc] initWithFormat:@"%@", [dicOrder objectForKey:orderStateKey]];
                    NSString *strOrderFlag = [[NSString alloc] initWithFormat:@"%@", [dicOrder objectForKey:flagKey]];
                    
                    
                    LyOrder *order = [LyOrder orderWithOrderId:strOrderId
                                                 orderMasterId:strMasterId
                                                     orderName:strOrderName
                                                   orderDetail:strOrderDetail
                                                orderConsignee:strConsignee
                                              orderPhoneNumber:strPhone
                                                  orderAddress:strAddress
                                            orderTrainBaseName:strTrainBaseName
                                                     orderTime:strTime
                                                  orderPayTime:@""
                                                 orderObjectId:strObjectId
                                                  orderClassId:strClassId
                                                   orderRemark:strRemark
                                                   orderStatus:[strState integerValue]
                                                     orderMode:[strMode integerValue]
                                             orderStudentCount:[strStuCount intValue]
                                                    orderPrice:[strPrice doubleValue]
                                        orderPreferentialPrice:[strPreferentialPrice doubleValue]
                                                  orderPaidNum:[strPainNum doubleValue]
                                                orderApplyMode:[strApplyMode integerValue]
                                                     orderFlag:[strOrderFlag intValue]];
                    
                    
                    curOrder = order;
                    [[LyOrderManager sharedInstance] addOrder:order];
                    
                    [indicator stopAnimation];
                    
                    LyOrderInfoViewController *orderInfo = [[LyOrderInfoViewController alloc] init];
                    [orderInfo setDelegate:self];
                    [self.navigationController pushViewController:orderInfo animated:YES];
                    
                    
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
    if ( bHttpFlag) {
        bHttpFlag = NO;
        [self handleHttpFailed];
    }
    
    curHttpMethod = 0;
}



- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result {
    if ( bHttpFlag) {
        bHttpFlag = NO;
        curHttpMethod = ahttpRequest.mode;
        [self analysisHttpResult:result];
    }
    
    curHttpMethod = 0;
}



#pragma mark -LyOrderInfoViewControllerdelegate
- (LyOrder *)obtainOrderByOrderInfoViewController:(LyOrderInfoViewController *)aOrderInfoVC
{
    return curOrder;
}


#pragma mark -LyAddressAlertViewDelegate
- (void)addressAlertView:(LyAddressAlertView *)aAddressAlertView onClickButtonDone:(BOOL)isDone {
    [aAddressAlertView hide];
    
    if (isDone) {
        [btnAddress setTitle:aAddressAlertView.address forState:UIControlStateNormal];
    }
}



#pragma mark -UIKeyboardWillShowNotification
- (void)coTargetForNotificationToKeyboardWillShow:(NSNotification *)notification
{
    CGFloat fHeightKeyboard = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    /*if ( [_coTvAddress isFirstResponder])
    {
        CGFloat currentY = viewOrderInfo.frame.origin.y + viewAddress.frame.origin.y + CGRectGetHeight(viewAddress.frame);
        CGFloat offsetY = currentY + fHeightKeyboard - viewControlBarHeight - svMainHeight;
        if ( offsetY > 0.0f)
        {
            CGPoint offset = CGPointMake( 0, offsetY);
            [svMain setContentOffset:offset];
        }
        
    }
    else*/ if ( [tvRemark isFirstResponder])
    {
        CGFloat currentY = viewOrderInfo.frame.origin.y + viewRemark.frame.origin.y + CGRectGetHeight(viewRemark.frame);
        CGFloat offsetY = currentY + fHeightKeyboard -viewControlBarHeight - svMainHeight;
        if ( offsetY > 0.0f)
        {
            CGPoint offset = CGPointMake( 0, offsetY);
            [svMain setContentOffset:offset];
        }
    }
    
}


#pragma mark -UIKeyboardWillHideNotification
- (void)coTargetForNotificationToKeyboardWillHide:(NSNotification *)notification
{
    CGFloat offsetY = viewOrderInfo.frame.origin.y + viewRemark.frame.origin.y + CGRectGetHeight(viewRemark.frame) - svMainHeight;
    offsetY = ( offsetY > 0) ? offsetY : 0;
    [svMain setContentOffset:CGPointMake( 0, offsetY)];
}




#pragma mark -UITextfieldDelegate
//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (createOrderTextFieldTag_name == textField.tag) {
        [tfStuCount becomeFirstResponder];
    }
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch ( [textField tag]) {
        case createOrderTextFieldTag_name: {
            if (tfName.text.length > 0) {
                if ([tfName.text validateName]) {
                    [tfName setTextColor:LyBlackColor];
                } else {
                    [tfName setTextColor:LyWarnColor];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"姓名格式错误"] show];
                }
            }
            break;
        }
        case createOrderTextFieldTag_stuCount: {
            if ([tfStuCount.text validateInt]) {
                [tfStuCount setTextColor:LyBlackColor];
            } else {
                [tfStuCount setTextColor:LyWarnColor];
                [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"学车人数格式错误"] show];
            }
            
            break;
        }
        case createOrderTextFieldTag_phone: {
            if (tfPhone.text.length > 0) {
                if ( [[tfPhone text] validatePhoneNumber]) {
                    [tfPhone setTextColor:LyBlackColor];
                } else {
                    [tfPhone setTextColor:LyWarnColor];
                    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"手机号格式错误"] show];
                }
            }
            break;
        }
    }
}



#pragma mark -UITextViewDelegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (createOrderTextViewTag_remark == textView.tag) {
        if (tvRemark.text.length > tvRemark.textCount) {
            tvRemark.text = [tvRemark.text substringToIndex:tvRemark.textCount];
        }
    }
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return amtcHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    curIdx = indexPath;
}

#pragma mark UITableViewDataSource相关
////返回每个分组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LyUtil applyModeNum];
}

////生成每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    LyApplyModeTableViewCell *tmpCell = [tableView dequeueReusableCellWithIdentifier:lyCreateOrderTvApplyModeCellReuseIdentifier];
    
    if ( !tmpCell)
    {
        tmpCell = [[LyApplyModeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyCreateOrderTvApplyModeCellReuseIdentifier];
    }
    [tmpCell setCellInfo:[_goodsInfo objectForKey:goodKey] withApplyMode:[indexPath row] andDeposit:0];
    
    return tmpCell;
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == tvRemark) {
        [tvRemark update];
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
