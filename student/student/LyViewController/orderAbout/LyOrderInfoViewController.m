//
//  LyOrderInfoViewController.m
//  student
//
//  Created by Junes on 2016/11/28.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyOrderInfoViewController.h"
#import "LyOrderInfoTableViewCell.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyOrderManager.h"
#import "LyTrainClassManager.h"
#import "LyUserManager.h"
#import "LyEvaluationForTeacher.h"

#import "UIViewController+backButtonHandler.h"
#import "NSString+Validate.h"
#import "LyUtil.h"


#import "LyPayViewController.h"
#import "LyPaySuccessViewController.h"
#import "LyOrderCenterViewController.h"
#import "LySchoolDetailViewController.h"
#import "LyCoachDetailViewController.h"
#import "LyGuiderDetailViewController.h"

#import "LyEvaluateOrderViewController.h"

#import "LyReservateCoachViewController.h"
#import "LyReservateGuiderViewController.h"
#import "LyCreateOrderViewController.h"



CGFloat const oiViewHeaderHeight = 100.0f;
CGFloat const oiTvRemindUpperHeight = 60.0f;

CGFloat const oiIvAvatarSize = 70.0f;
#define oiLbHeaderWidth         (SCREEN_WIDTH - horizontalSpace * 3 - oiIvAvatarSize)
CGFloat const oiLbNameHeight = 30.0f;
#define oiLbNameFont            LyFont(16)
CGFloat const oiLbDetailHeight = oiIvAvatarSize - oiLbNameHeight;
#define oiLbDetailFont          LyFont(14)


NSString *const LyOrderInfoRemindUpper_apply = @"报名已提交，请选择一种安全的网络环境完成支付，谨防第三只眼睛偷窥密码！";
NSString *const LyOrderInfoRemindUpper_reservate = @"预约已提交，请选择一种安全的网络环境完成支付，谨防第三只眼睛偷窥密码！";


typedef NS_ENUM(NSInteger, LyOrderInfoButtonTag)
{
    orderInfoButtonTag_left = 10,
    orderInfoButtonTag_right
};


@interface LyOrderInfoViewController () <UITableViewDelegate, UITableViewDataSource, LyPayViewControllerDelegate, LyRemindViewDelegate, LySchoolDetailViewControllerDelegate, LyCoachDetailViewControllerDelegate, LyGuiderDetailViewControllerDelegate, LyEvaluateOrderViewControllerDelegate, LyReservateCoachViewControllerDelegate, LyReservateGuiderViewControllerDelegate>
{
    UITextView      *tvRemindUpper;
    
    UIView          *viewHeader;
    UIImageView     *ivAvatar;
    UILabel         *lbName;
    UILabel         *lbDetail;
    UIView          *horizontalLine;
    
    UIView          *controlBar;
    UIButton        *btnFunc_left;
    UIButton        *btnFunc_right;
    
    
    NSArray         *arrItems;
    
    LyIndicator     *indicator_oper;
}

@property (strong, nonatomic)       UITableView         *tableView;

@end

@implementation LyOrderInfoViewController

static NSString *const lyOrderInfoTableViewCellReuseIdentifier = @"lyOrderInfoTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    _order = [_delegate obtainOrderByOrderInfoViewController:self];
    if (!_order)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    
    [self reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}

- (void)initSubviews
{
    self.title = @"订单详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = LyWhiteLightgrayColor;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, oiViewHeaderHeight)];
    [viewHeader setBackgroundColor:[UIColor whiteColor]];
    
    tvRemindUpper = [[UITextView alloc] initWithFrame:CGRectZero];
    [tvRemindUpper setEditable:NO];
    [tvRemindUpper setScrollEnabled:NO];
    [tvRemindUpper setTextAlignment:NSTextAlignmentCenter];
    [tvRemindUpper setTextColor:LyBlackColor];
    [tvRemindUpper setFont:LyFont(14)];
    [tvRemindUpper setText:LyOrderInfoRemindUpper_apply];
    [tvRemindUpper setTextContainerInset:UIEdgeInsetsMake(horizontalSpace, horizontalSpace, verticalSpace, horizontalSpace)];
    [tvRemindUpper setBackgroundColor:LyWhiteLightgrayColor];
    
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(horizontalSpace, CGRectGetHeight(tvRemindUpper.frame) + oiViewHeaderHeight/2.0f - oiIvAvatarSize/2.0f, oiIvAvatarSize, oiIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [ivAvatar.layer setCornerRadius:btnCornerRadius];
    [ivAvatar setClipsToBounds:YES];
    
    lbName = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace * 2 + oiIvAvatarSize, ivAvatar.frame.origin.y, oiLbHeaderWidth, oiLbNameHeight)];
    [lbName setFont:oiLbNameFont];
    [lbName setTextColor:[UIColor blackColor]];
    [lbName setTextAlignment:NSTextAlignmentLeft];
    
    lbDetail = [[UILabel alloc] initWithFrame:CGRectMake(lbName.frame.origin.x, lbName.frame.origin.y + oiLbNameHeight, oiLbHeaderWidth, oiLbDetailHeight)];
    [lbDetail setFont:oiLbDetailFont];
    [lbDetail setTextColor:LyBlackColor];
    [lbDetail setTextAlignment:NSTextAlignmentLeft];
    [lbDetail setNumberOfLines:0];
    
    horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(viewHeader.frame) - verticalSpace, SCREEN_WIDTH, verticalSpace)];
    [horizontalLine setBackgroundColor:LyWhiteLightgrayColor];
    
    [viewHeader addSubview:tvRemindUpper];
    [viewHeader addSubview:ivAvatar];
    [viewHeader addSubview:lbName];
    [viewHeader addSubview:lbDetail];
    [viewHeader addSubview:horizontalLine];
    
    
    controlBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - LyControlBarHeight, SCREEN_HEIGHT, LyControlBarHeight)];
    [controlBar setBackgroundColor:LyWhiteLightgrayColor];
    
    btnFunc_left = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - LyControlBarButtonWidth * 2)*2/5.0f, LyControlBarHeight/2-LyControlBarButtonHeight/2, LyControlBarButtonWidth, LyControlBarButtonHeight)];
    [btnFunc_left setTag:orderInfoButtonTag_left];
    [btnFunc_left setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnFunc_left setBackgroundColor:[UIColor whiteColor]];
    [[btnFunc_left layer] setCornerRadius:btnCornerRadius];
    [[btnFunc_left layer] setBorderWidth:1.0f];
    [[btnFunc_left layer] setBorderColor:[Ly517ThemeColor CGColor]];
    [btnFunc_left addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    btnFunc_right = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH-LyControlBarButtonWidth-(SCREEN_WIDTH-LyControlBarButtonWidth*2)*2/5, LyControlBarHeight/2-LyControlBarButtonHeight/2, LyControlBarButtonWidth, LyControlBarButtonHeight)];
    [btnFunc_right setTag:orderInfoButtonTag_right];
    [btnFunc_right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[btnFunc_right layer] setCornerRadius:btnCornerRadius];
    [btnFunc_right setBackgroundColor:Ly517ThemeColor];
    [btnFunc_right addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [controlBar addSubview:btnFunc_left];
    [controlBar addSubview:btnFunc_right];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:controlBar];
    
}


- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT - LyControlBarHeight)
                                                  style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setShowsHorizontalScrollIndicator:NO];
        
        [_tableView registerClass:[LyOrderInfoTableViewCell class] forCellReuseIdentifier:lyOrderInfoTableViewCellReuseIdentifier];
        
        [_tableView setTableFooterView:[UIView new]];
    }
    
    return _tableView;
}

- (void)reloadData
{
    [self reloadData_dataSource];
    [self reloadData_header];
    
    [self.tableView setTableHeaderView:viewHeader];
    [self.tableView reloadData];
    
    [self reloadData_controlBar];
}

- (void)reloadData_dataSource
{
    switch (_order.orderMode) {
        case LyOrderMode_coach: {
            
//            break;
        }
        case LyOrderMode_driveSchool: {
            
//            break;
        }
        case LyOrderMode_guider: {
            
//            break;
        }
        case LyOrderMode_reservation: {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:1];
            [arr addObject:@"学员姓名"];
            [arr addObject:@"学车人数"];
            [arr addObject:@"联系电话"];
            
            if (_order.orderMode == LyOrderMode_reservation)
            {
                [arr addObject:@"培训基地"];
            }
            else
            {
                [arr addObject:@"接送地址"];
            }
            
            [arr addObject:@"报名方式"];
            
            if (LyOrderState_waitPay < _order.orderState)// && _order.orderState < LyOrderState_cancel)
            {
                [arr addObject:@"实付金额"];
                [arr addObject:@"下单时间"];
                [arr addObject:@"支付时间"];
            }
            else
            {
                [arr addObject:@"应付金额"];
                [arr addObject:@"下单时间"];
            }
            [arr addObject:@"备注"];
            
            arrItems = arr.copy;
            break;
        }
        case LyOrderMode_mall: {
            
            break;
        }
        case LyOrderMode_game: {
            
            break;
        }
    }
}

- (void)reloadData_header
{
    CGRect rectTvRemindUpper;
    CGRect rectViewHeader;
    if (_order && LyOrderState_waitPay == _order.orderState)
    {
        rectTvRemindUpper = CGRectMake(0, 0, SCREEN_WIDTH, oiTvRemindUpperHeight);
        rectViewHeader = CGRectMake(0, 0, SCREEN_WIDTH, oiTvRemindUpperHeight + oiViewHeaderHeight);
    }
    else
    {
        rectTvRemindUpper = CGRectZero;
        rectViewHeader = CGRectMake(0, 0, SCREEN_WIDTH, oiViewHeaderHeight);
    }
    [tvRemindUpper setFrame:rectTvRemindUpper];
    [viewHeader setFrame:rectViewHeader];
    
    if (LyOrderMode_reservation == _order.orderMode)
    {
        [tvRemindUpper setText:LyOrderInfoRemindUpper_reservate];
    }
    else
    {
        [tvRemindUpper setText:LyOrderInfoRemindUpper_apply];
    }
    
    [ivAvatar setFrame:CGRectMake(horizontalSpace, CGRectGetHeight(tvRemindUpper.frame) + oiViewHeaderHeight/2.0f - oiIvAvatarSize/2.0f, oiIvAvatarSize, oiIvAvatarSize)];
    [lbName setFrame:CGRectMake(horizontalSpace * 2 + oiIvAvatarSize, ivAvatar.frame.origin.y, oiLbHeaderWidth, oiLbNameHeight)];
    [lbDetail setFrame:CGRectMake(lbName.frame.origin.x, lbName.frame.origin.y + oiLbNameHeight, oiLbHeaderWidth, oiLbDetailHeight)];
    [horizontalLine setFrame:CGRectMake(0, CGRectGetHeight(viewHeader.frame) - verticalSpace, SCREEN_WIDTH, verticalSpace)];
    
    
    LyUser *teacher = [[LyUserManager sharedInstance] getUserWithUserId:_order.orderObjectId];
    if (!teacher) {
        
        NSString *userName = _order.orderName;
        if (![LyUtil validateString:userName]) {
            userName = [LyUtil getUserNameWithUserId:_order.orderObjectId];
        }
        
        switch (_order.orderMode) {
            case LyOrderMode_driveSchool: {
                LyDriveSchool *school = [LyDriveSchool driveSchoolWithId:_order.orderObjectId dschName:userName];
                teacher = school;
                break;
            }
            case LyOrderMode_coach: {
                LyCoach *coach = [LyCoach coachWithId:_order.orderObjectId coaName:userName];
                teacher = coach;
                break;
            }
            case LyOrderMode_guider: {
                LyGuider *guider = [LyGuider guiderWithGuiderId:_order.orderObjectId guiName:userName];
                teacher = guider;
                break;
            }
            case LyOrderMode_reservation: {
                if ([_order.orderName rangeOfString:@"指导员"].length > 0) {
                    LyGuider *guider = [LyGuider guiderWithGuiderId:_order.orderObjectId guiName:userName];
                    teacher = guider;
                } else {
                    LyCoach *coach = [LyCoach coachWithId:_order.orderObjectId coaName:userName];
                    teacher = coach;
                }
                break;
            }
            case LyOrderMode_mall: {
                
                break;
            }
            case LyOrderMode_game: {
                
                break;
            }
        }
        
        [[LyUserManager sharedInstance] addUser:teacher];
    }
    
    if (!teacher.userAvatar)
    {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:_order.orderObjectId]
                    placeholderImage:[LyUtil defaultAvatarForTeacher]
                           completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                               if (image) {
                                   [teacher setUserAvatar:image];
                               } else {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:_order.orderObjectId]
                                               placeholderImage:[LyUtil defaultAvatarForTeacher]
                                                      completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                                          if (image) {
                                                              [teacher setUserAvatar:image];
                                                          }
                                                      }];
                               }
                           }];
    }
    else
    {
        [ivAvatar setImage:teacher.userAvatar];
    }
    
    [lbName setText:_order.orderName];
    [lbDetail setText:_order.orderDetail];
}

- (void)reloadData_controlBar
{
    switch (_order.orderState) {
        case LyOrderState_waitPay: {
            NSString *strTitle = @"取消订单";
            if (LyOrderMode_reservation == _order.orderMode) {
                strTitle = @"取消预约";
            }
            [btnFunc_left setTitle:strTitle forState:UIControlStateNormal];
            [btnFunc_right setTitle:@"立即支付" forState:UIControlStateNormal];
            break;
        }
        case LyOrderState_waitConfirm: {
            NSString *strTitle = @"删除订单";
            if (LyOrderMode_reservation == _order.orderMode) {
                strTitle = @"取消预约";
            }
            [btnFunc_left setTitle:strTitle forState:UIControlStateNormal];
            [btnFunc_right setTitle:@"我已学车" forState:UIControlStateNormal];
            break;
        }
        case LyOrderState_waitEvalute: {
            [btnFunc_left setTitle:@"删除订单" forState:UIControlStateNormal];
            [btnFunc_right setTitle:@"评价" forState:UIControlStateNormal];
            break;
        }
        case LyOrderState_completed: {
            [btnFunc_left setTitle:@"删除订单" forState:UIControlStateNormal];
            [btnFunc_right setTitle:@"再次评价" forState:UIControlStateNormal];
            break;
        }
        case LyOrderState_cancel: {
            [btnFunc_left setTitle:@"删除订单" forState:UIControlStateNormal];
            switch (_order.orderMode) {
                case LyOrderMode_driveSchool: {
//                    break;
                }
                case LyOrderMode_coach: {
//                    break;
                }
                case LyOrderMode_guider: {
                    [btnFunc_right setTitle:@"重新报名" forState:UIControlStateNormal];
                    break;
                }
                case LyOrderMode_reservation: {
                    [btnFunc_right setTitle:@"重新预约" forState:UIControlStateNormal];
                    break;
                }
                case LyOrderMode_mall: {
                    [btnFunc_right setTitle:@"重新购买" forState:UIControlStateNormal];
                    break;
                }
                case LyOrderMode_game: {
                    [btnFunc_right setTitle:@"重新购买" forState:UIControlStateNormal];
                    break;
                }
            }
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)targetForButton:(UIButton *)btn
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(targetForButton:) object:btn];
        return;
    }
    
    LyOrderInfoButtonTag btnTag = btn.tag;
    switch (btnTag) {
        case orderInfoButtonTag_left: {
            
            NSString *title = nil;
            NSString *destructiveTitle = nil;
            SEL target = nil;
            
            if (LyOrderState_waitPay == _order.orderState)
            {
                title = @"确定要取消这条订单吗？";
                destructiveTitle = @"取消订单";
                target = @selector(cancel);
            }
            else
            {
                title = @"确定要删除这条订单吗？";
                destructiveTitle = @"删除订单";
                target = @selector(delete);
            }
            
            if (LyOrderMode_reservation == _order.orderMode)
            {
                title = @"确定要取消这次预约吗？";
                destructiveTitle = @"取消预约";
            }

            UIAlertController *action = [UIAlertController alertControllerWithTitle:title
                                                                            message:nil
                                                                     preferredStyle:UIAlertControllerStyleActionSheet];
            [action addAction:[UIAlertAction actionWithTitle:@"取消"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil]];
            [action addAction:[UIAlertAction actionWithTitle:destructiveTitle
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self performSelector:target withObject:nil afterDelay:0];
                                                     }]];
            
            [self presentViewController:action animated:YES completion:nil];
            break;
        }
        case orderInfoButtonTag_right: {
            
            switch (_order.orderState) {
                case LyOrderState_waitPay: {
                    LyPayViewController *payVC = [[LyPayViewController alloc] init];
                    [payVC setDelegate:self];
                    [self.navigationController pushViewController:payVC animated:YES];
                    break;
                }
                case LyOrderState_waitConfirm: {
                    UIAlertController *action = [UIAlertController alertControllerWithTitle:@"确认学车后系统将自动把钱打给对方， 你确定要确认学车吗？"
                                                                                    message:nil
                                                                             preferredStyle:UIAlertControllerStyleActionSheet];
                    [action addAction:[UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil]];
                    [action addAction:[UIAlertAction actionWithTitle:@"我已学车"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 [self confirm];
                                                             }]];
                    [self presentViewController:action animated:YES completion:nil];
                    break;
                }
                case LyOrderState_waitEvalute: {
//                    LyEvaluationView *evalutionView = [LyEvaluationView evaluationViewWithMode:LyEvaluationViewMode_evaluate];
//                    [evalutionView setDelegate:self];
//                    [evalutionView show];
                    LyEvaluateOrderViewController *evaluateOrderVC = [[LyEvaluateOrderViewController alloc] init];
                    [evaluateOrderVC setDelegate:self];
                    [self.navigationController pushViewController:evaluateOrderVC animated:YES];
                    
                    break;
                }
                case LyOrderState_completed: {
                    LyEvaluateOrderViewController *evaluateOrderVC = [[LyEvaluateOrderViewController alloc] init];
                    [evaluateOrderVC setDelegate:self];
                    [evaluateOrderVC setMode:LyEvaluateOrderViewControllerMode_evaluateAgain];
                    [self.navigationController pushViewController:evaluateOrderVC animated:YES];
                    break;
                }
                case LyOrderState_cancel: {
                    
                    LyUser *user = [[LyUserManager sharedInstance] getUserWithUserId:_order.orderObjectId];
                    switch ( [user userType]) {
                        case LyUserType_normal: {
                            //nothing
                            break;
                        }
                        case LyUserType_coach: {
                            if (LyOrderMode_reservation == _order.orderMode) {
                                LyReservateCoachViewController *reservateCoach = [[LyReservateCoachViewController alloc] init];
                                [reservateCoach setDelegate:self];
                                [self.navigationController pushViewController:reservateCoach animated:YES];
                            } else {
                                LyCoachDetailViewController *coachDetail = [[LyCoachDetailViewController alloc] init];
                                [coachDetail setDelegate:self];
                                [self.navigationController pushViewController:coachDetail animated:YES];
                            }
                            break;
                        }
                        case LyUserType_school: {
                            LySchoolDetailViewController *sd = [[LySchoolDetailViewController alloc] init];
                            [sd setDelegate:self];
                            [self.navigationController pushViewController:sd animated:YES];
                            break;
                        }
                        case LyUserType_guider: {
                            if (LyOrderMode_reservation == _order.orderMode) {
                                LyReservateGuiderViewController *reservateGuider = [[LyReservateGuiderViewController alloc] init];
                                [reservateGuider setDelegate:self];
                                [self.navigationController pushViewController:reservateGuider animated:YES];
                            } else {
                                LyGuiderDetailViewController *ged = [[LyGuiderDetailViewController alloc] init];
                                [ged setDelegate:self];
                                [self.navigationController pushViewController:ged animated:YES];
                            }
                            break;
                        }
                    }

                    
                    break;
                }
            }
            
            break;
        }
    }
}


- (void)cancel
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(cancel) object:nil];
        return;
    }
    
    if ( !indicator_oper) {
        indicator_oper = [[LyIndicator alloc] initWithTitle:LyIndicatorTitle_cancel];
    } else {
        [indicator_oper setTitle:LyIndicatorTitle_cancel];
    }
    [indicator_oper startAnimation];
    
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:cancelOrder_url
                    body:@{
                           modeKey:@(_order.orderMode),
                           masterIdKey:[LyCurrentUser curUser].userId,
                           orderIdKey:_order.orderId,
                           sessionIdKey:[LyUtil httpSessionId]
                           }
                    type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
           if (error)
           {
               [self handleHttpFailed:YES];
           }
           else
           {
               NSDictionary *dic = [self analysisHttpResult:resStr];
               if (!dic)
               {
                   [self handleHttpFailed:YES];
                   return ;
               }
               
               NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
               switch (strCode.intValue) {
                   case 0: {
                       [_order setOrderState:LyOrderState_cancel];
                       
                       [self reloadData];
                       
                       [indicator_oper stopAnimation];
                       [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"取消订单成功"] show];
                       break;
                   }
                   default: {
                       [self handleHttpFailed:YES];
                       break;
                   }
               }
           }
       }];
    
}

- (void)delete
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(delete) object:nil];
        return;
    }
    
    if ( !indicator_oper) {
        indicator_oper = [[LyIndicator alloc] initWithTitle:LyIndicatorTitle_delete];
    } else {
        [indicator_oper setTitle:LyIndicatorTitle_delete];
    }
    [indicator_oper startAnimation];
    
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:deleteOrder_url
                    body:@{
                           modeKey:@(_order.orderMode),
                           masterIdKey:[[LyCurrentUser curUser] userId],
                           orderIdKey:[_order orderId],
                           sessionIdKey:[LyUtil httpSessionId]
                           }
                    type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
           if (error)
           {
               [self handleHttpFailed:YES];
           }
           else
           {
               NSDictionary *dic = [self analysisHttpResult:resStr];
               if (!dic)
               {
                   [self handleHttpFailed:YES];
                   return ;
               }
               
               NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
               switch (strCode.integerValue) {
                   case 0: {
                       [[LyOrderManager sharedInstance] removeOrder:_order];
                       
                       [indicator_oper stopAnimation];
                       
                       LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"删除订单成功"];
                       [remind setDelegate:self];
                       [remind show];
                       break;
                   }
                   default: {
                       [self handleHttpFailed:YES];
                       break;
                   }
               }
           }
       }];
}

- (void)confirm
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(confirm) object:nil];
        return;
    }
    
    if ( !indicator_oper) {
        indicator_oper = [[LyIndicator alloc] initWithTitle:LyIndicatorTitle_confirm];
    } else  {
        [indicator_oper setTitle:LyIndicatorTitle_confirm];
    }
    [indicator_oper startAnimation];
    
    
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:confirmOrder_url
                    body:@{
                           modeKey:@(_order.orderMode),
                           orderIdKey:[_order orderId],
                           masterIdKey:[[LyCurrentUser curUser] userId],
                           sessionIdKey:[LyUtil httpSessionId]
                           }
                    type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
           if (error)
           {
               [self handleHttpFailed:YES];
           }
           else
           {
               NSDictionary *dic = [self analysisHttpResult:resStr];
               if (!dic)
               {
                   [self handleHttpFailed:YES];
                   return ;
               }
               
               NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
               switch (strCode.integerValue) {
                   case 0: {
                       [_order setOrderState:LyOrderState_waitEvalute];
                   
                       [self reloadData];
                       
                       [indicator_oper stopAnimation];
                       
                       [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"确认学车成功"] show];
                       break;
                   }
                   default: {
                       [self handleHttpFailed:YES];
                       break;
                   }
               }
           }
       }];
    
}



- (void)evaluate:(NSString *)content score:(float)score level:(LyEvaluationLevel)level {
    
    if (![LyCurrentUser curUser].isLogined) {
        [LyUtil showLoginVc:self];
        return;
    }
    
    if ( !indicator_oper)
    {
        indicator_oper = [[LyIndicator alloc] initWithTitle:LyIndicatorTitle_evaluate];
    }
    [indicator_oper setTitle:LyIndicatorTitle_evaluate];
    [indicator_oper startAnimation];
    
    [self performSelector:@selector(evaluateForDelay:)
               withObject:@{
                            @"content":content,
                            @"score":[NSNumber numberWithFloat:score],
                            @"level":[NSNumber numberWithInteger:level]
                            }
               afterDelay:validateSensitiveWordDelayTime];
}

- (void)evaluateForDelay:(NSDictionary *)dicInfo
{
    NSString *content = [dicInfo objectForKey:@"content"];
    
    if (![content validateSensitiveWord])
    {
        [indicator_oper stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"含用非法词"] show];
        return;
    }

    
    
        
    float score = [[dicInfo objectForKey:@"score"] floatValue];
    NSInteger level = [[dicInfo objectForKey:@"level"] integerValue];
    
    NSString *strUserType;
    if (LyOrderMode_driveSchool == [_order orderMode])
    {
        strUserType = @"jx";
    }
    else if (LyOrderMode_coach == [_order orderMode])
    {
        strUserType = @"jl";
    }
    else if (LyOrderMode_guider == [_order orderMode])
    {
        strUserType = @"zdy";
    }
    else if (LyOrderMode_reservation == [_order orderMode])
    {
        strUserType = @"jl";
    }
    
    
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:evaluateOrder_url
                    body:@{
                           modeKey:@(_order.orderMode),
                           contentKey:content,
                           evaluationLevelKey:[[NSString alloc] initWithFormat:@"%d", (int)level],
                           scoreKey:[[NSString alloc] initWithFormat:@"%.2f", score],
                           objectIdKey:[_order orderId],
                           objectMasterIdKey:_order.orderObjectId,
                           masterIdKey:[[LyCurrentUser curUser] userId],
                           sessionIdKey:[LyUtil httpSessionId],
                           userTypeKey:strUserType
                           }
                    type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
           if (error)
           {
               [self handleHttpFailed:YES];
           }
           else
           {
               NSDictionary *dic = [self analysisHttpResult:resStr];
               if (!dic)
               {
                   [self handleHttpFailed:YES];
                   return ;
               }
               
               NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
               switch (strCode.integerValue) {
                   case 0: {
                       [_order setOrderState:LyOrderState_completed];
                       
                       [self reloadData];
                       
                       [indicator_oper stopAnimation];
                       
                       [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"评价订单成功"] show];
                       break;
                   }
                   default: {
                       [self handleHttpFailed:YES];
                       break;
                   }
               }
           }
       }];

}



- (void)handleHttpFailed:(BOOL)needRemind
{
    if (indicator_oper.isAnimating)
    {
        [indicator_oper stopAnimation];
        
        if (needRemind)
        {
            NSString *title = nil;
            if ( [[indicator_oper title] isEqualToString:LyIndicatorTitle_cancel]) {
                title = @"取消订单失败";
            } else if ( [[indicator_oper title] isEqualToString:LyIndicatorTitle_delete]) {
                title = @"删除订单失败";
            } else if ( [[indicator_oper title] isEqualToString:LyIndicatorTitle_evaluate]) {
                title = @"评价订单失败";
            } else if ( [[indicator_oper title] isEqualToString:LyIndicatorTitle_confirm]) {
                title = @"确认学车失败";
            }
            
            [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:title];
        }
    }
}

- (NSDictionary *)analysisHttpResult:(NSString *)result
{
    NSDictionary *dic = [LyUtil getObjFromJson:result];
    
    if (![LyUtil validateDictionary:dic])
    {
        return nil;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (![LyUtil validateString:strCode])
    {
        return nil;
    }
    
    if (codeTimeOut == strCode.intValue)
    {
        [self handleHttpFailed:NO];
        
        [LyUtil sessionTimeOut:self];
        return nil;
    }
    
    if (codeMaintaining == strCode.intValue)
    {
        [self handleHttpFailed:NO];
        
        [LyUtil serverMaintaining];
         return nil;
    }
         
    return dic;
}



#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(UIView *)view {
    if ([_delegate isKindOfClass:[LyPaySuccessViewController class]]) {
        NSArray *viewControllers = [self.navigationController viewControllers];
        [self.navigationController popToViewController:viewControllers[[viewControllers indexOfObject:self] - 3] animated:YES];
    } else if ( ![_delegate isKindOfClass:[LyOrderCenterViewController class]]) {
        NSArray *viewControllers = [self.navigationController viewControllers];
        [self.navigationController popToViewController:viewControllers[[viewControllers indexOfObject:self] - 2] animated:YES];
    }
}


#pragma mark -LyPayViewControllerDelegate
- (LyOrder *)orderOfPayViewController:(LyPayViewController *)aPayVC
{
    return _order;
}

- (void)payDoneViewControler:(LyPayViewController *)aPayVC order:(LyOrder *)order
{
    [self.navigationController popToViewController:self animated:YES];
    [self reloadData];
}

#pragma mark -LyEvaluateOrderViewControllerDelegate
- (LyOrder *)obtainOrderByEvaluateOrderViewController:(LyEvaluateOrderViewController *)aEvaluateOrderVC
{
    return _order;
}

- (void)onDoneByEvaluateOrderViewController:(LyEvaluateOrderViewController *)aEvaluateOrderVC
{
    [self.navigationController popViewControllerAnimated:YES];
    [self reloadData];
}



#pragma mark -LySchoolDetailViewControllerDelegate
- (NSString *)schoolIdBySchoolDetailViewController:(LySchoolDetailViewController *)aSchoolDetailVC
{
    return _order.orderObjectId;
}

#pragma mark -LyCoachDetailViewControllerDelegate
- (NSString *)coachIdByCoachDetailViewController:(LyCoachDetailViewController *)aCoachDetailVC
{
    return _order.orderObjectId;
}


#pragma mark -LyGuiderDetailViewControllerDelegate
- (NSString *)userIdByGuiderDetailViewController:(LyGuiderDetailViewController *)aGuiderDetailVC
{
    return _order.orderObjectId;
}



#pragma mark -LyReservateCoachViewControllerDelegate
- (NSDictionary *)obtainCoachObjectByReservateCoachViewController:(LyReservateCoachViewController *)aReservateCoach
{
    return @{
             coachIdKey:_order.orderObjectId,
             subjectModeKey:@(LySubjectModeprac_second)
             };
}

#pragma mark -LyReservateGuiderViewControllerDelegate
- (NSString *)obtainGuiderIdByReservateGuiderVC:(LyReservateGuiderViewController *)aReservateGuiderVC
{
    return _order.orderObjectId;
}


#pragma mark -BackButtonHandlerProtocol
- (BOOL)navigationShouldPopOnBackButton {
    if ([_delegate isKindOfClass:[LyPaySuccessViewController class]]) {
        NSArray *viewControllers = [self.navigationController viewControllers];
        [self.navigationController popToViewController:viewControllers[[viewControllers indexOfObject:self] - 3] animated:YES];
        return NO;
    } else if ([_delegate isKindOfClass:[LyCreateOrderViewController class]]){
        NSArray *viewControllers = [self.navigationController viewControllers];
        [self.navigationController popToViewController:viewControllers[[viewControllers indexOfObject:self] - 2] animated:YES];
        return NO;
    }
    
    return YES;
}


#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return oitcHeight;
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyOrderInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyOrderInfoTableViewCellReuseIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[LyOrderInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyOrderInfoTableViewCellReuseIdentifier];
    }
    
    NSString *title = arrItems[indexPath.row];
    NSString *detail = nil;
    
    switch (indexPath.row) {
        case 0: {
            detail = _order.orderConsignee;
            break;
        }
        case 1: {
            detail = [[NSString alloc] initWithFormat:@"%d", _order.orderStudentCount];
            break;
        }
        case 2: {
            detail = _order.orderPhoneNumber;
            break;
        }
        case 3: {
            detail = _order.orderAddress;
            break;
        }
        case 4: {
            if ( LyApplyMode_prepay == [_order orderApplyMode])
            {
                detail = [[NSString alloc] initWithFormat:@"%@ %.2f元" , lbApplyModeTitlePrepay, [_order orderPrice]/[_order orderStudentCount]];
            }
            else
            {
                detail = [[NSString alloc] initWithFormat:@"%@ %.2f元" , lbApplyModeTitleWhole, [_order orderPrice]/[_order orderStudentCount]];
            }
            break;
        }
        case 5: {
            //若不为待支付状态，则显示已支付金额
            if (LyOrderState_waitPay == _order.orderState)
            {
                detail = [[NSString alloc] initWithFormat:@"%.2f元", _order.orderPrice];
            }
            else
            {
                detail = [[NSString alloc] initWithFormat:@"%.2f元", _order.orderPaidNum];
            }
            break;
        }
        case 6: {
            detail = _order.orderTime;
            break;
        }
        case 7: {
            if (LyOrderState_waitPay < _order.orderState && _order.orderState < LyOrderState_cancel)
            {
                detail = _order.orderPayTime;
            }
            else
            {
                detail = [LyUtil validateString:_order.orderRemark] ? _order.orderRemark : @"无";
            }
            break;
        }
        case 8: {
            detail = [LyUtil validateString:_order.orderRemark] ? _order.orderRemark : @"无";
            break;
        }
        default:
            break;
    }
    
    [cell setCellInfo:title detail:detail];
    [cell setMode:LyOrderInfoTableViewCellMode_orderInfo];
    
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
