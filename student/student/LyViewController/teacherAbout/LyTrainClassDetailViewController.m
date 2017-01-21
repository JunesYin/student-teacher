//
//  LyTrainClassDetailViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/21.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyTrainClassDetailViewController.h"
#import "LyTrainClassDetailTableViewCell.h"
#import "LyDetailControlBar.h"
#import "LyTableViewHeaderFooterView.h"

#import "LyUserManager.h"
#import "LyTrainClassManager.h"
#import "LyCurrentUser.h"

#import "LyUtil.h"

#import "LyCreateOrderViewController.h"


#define tcdWidth                            CGRectGetWidth(self.view.frame)
#define tcdHeight                           CGRectGetHeight(self.view.frame)

#define svMainWidth                         tcdWidth
#define svMainHeight                        (tcdHeight-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT-CGRectGetHeight(tcdViewControlBar.frame))




//课程信息
#define viewInfoWidth                       svMainWidth
CGFloat const tcdViewInfoHeight = 110.0f;
//课程信息-名字

CGFloat const tcdLbNameHeight = 20.0f;
#define lbNameFont                          LyFont(14)
//课程信息-优惠数

CGFloat const lbFoldHeight = tcdLbNameHeight;
#define lbFoldFont                          lbNameFont
//课程信息-教练车型

CGFloat const lbCarNameHeight = tcdLbNameHeight;
#define lbCarNameFont                       lbNameFont
//课程信息-班别

CGFloat const tcdLbTimeHeight = tcdLbNameHeight;
#define lbTimeFont                          lbNameFont
//课程信息-官方价

CGFloat const tcdLbOfficialPriceHeight = tcdLbNameHeight;
#define lbOfficailPriceFont                 lbNameFont
//课程信息-517价

CGFloat const tcdLb517PriceHeight = tcdLbNameHeight;
#define lb517PriceFont                      lbNameFont


//课程详情
#define viewDetailWidth                     svMainWidth
#define viewDetailHeight


#define lbSmallTitleWidth                   viewDetailWidth
CGFloat const lbSmallTitleHeight = 30.0f;
#define lbSmallTitleFont                    LyFont(16)


#define tvDetailWidth                       viewDetailWidth
CGFloat const tvDetailHeight = 10.0f;



//我们的承诺
#define viewPromiseWidth                    svMainWidth
CGFloat const viewPromiseHeight = 10.0f;

#define tvPromiseWidth                      (viewPromiseWidth-horizontalSpace*2)
CGFloat const tvPromiseHeight = viewPromiseHeight;
#define tvPromiseFont                       LyFont(14)



typedef NS_ENUM( NSInteger, LyTrainClassDetailTableViewTag)
{
    trainClassDetailTableViewTag_fee,
    trainClassDetailTableViewTag_service
};


//CGFloat const tcdViewInfoHeight = 150.0f;
//CGFloat const lbItemHeight = 20.0f;
#define lbItemFont                          LyFont(14)


@interface LyTrainClassDetailViewController () <LyDetailControlBarDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, LyCreateOrderViewControllerDelegate>
{
    UIView              *viewInfo;
    UILabel             *lbTitle_info;
    UILabel             *lbWholeName;
    UILabel             *lbFold;
    UILabel             *lbCarType;
    UILabel             *lbTrainClassTime;
    UILabel             *lbOfficialPrice;
    UILabel             *lbWhole517Price;
    
    UITableView         *tvInfo;
    
    UIView              *viewPromise;
    UILabel             *lbTitle_primise;
    UITextView          *tvPromise;
    
    LyDetailControlBar  *controlBar;
}
@end

@implementation LyTrainClassDetailViewController


static NSString *const lyTrainClassDetailTvInfoCellReuseIdentifier = @"lyTrainClassDetailTvInfoCellReuseIdentifier";
static NSString *const lyTrainClassDetailTvHeaderFooterViewReuseIdentifier = @"lyTrainClassDetailTvHeaderFooterViewReuseIdentifier";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}



- (void)viewWillAppear:(BOOL)animated
{
    NSDictionary *dic = [_delegate obtainTrainClassInfoByTrainClassDetailViewController:self];
    
    _trainClass = [dic objectForKey:trainClassKey];
    _teacher = [dic objectForKey:teacherKey];
    
    [self reloadViewData];
}






- (void)initSubviews
{
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    //课程信息
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, tcdViewInfoHeight)];
    [viewInfo setBackgroundColor:[UIColor whiteColor]];
    //课程信息-标题
    lbTitle_info = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, verticalSpace, SCREEN_WIDTH, 30.0f)];
    [lbTitle_info setTextColor:Ly517ThemeColor];
    [lbTitle_info setFont:LyFont(18)];
    [lbTitle_info setTextAlignment:NSTextAlignmentLeft];
    //课程信息-名字
    lbWholeName = [UILabel new];
    [lbWholeName setFont:lbItemFont];
    [lbWholeName setTextColor:LyBlackColor];
    [lbWholeName setTextAlignment:NSTextAlignmentCenter];
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
    lbTrainClassTime = [UILabel new];
    [lbTrainClassTime setFont:lbItemFont];
    [lbTrainClassTime setTextColor:LyBlackColor];
    [lbTrainClassTime setTextAlignment:NSTextAlignmentCenter];
    //课程信息-官方价
    lbOfficialPrice = [UILabel new];
    [lbOfficialPrice setFont:lbItemFont];
    [lbOfficialPrice setTextColor:LyBlackColor];
    [lbOfficialPrice setTextAlignment:NSTextAlignmentCenter];
    //课程信息-517价
    lbWhole517Price = [UILabel new];
    [lbWhole517Price setFont:lbItemFont];
    [lbWhole517Price setTextColor:LyBlackColor];
    [lbWhole517Price setTextAlignment:NSTextAlignmentCenter];
    
    
    [viewInfo addSubview:lbTitle_info];
    [viewInfo addSubview:lbWholeName];
    [viewInfo addSubview:lbFold];
    [viewInfo addSubview:lbCarType];
    [viewInfo addSubview:lbTrainClassTime];
    [viewInfo addSubview:lbOfficialPrice];
    [viewInfo addSubview:lbWhole517Price];
    
    
    
    //我们的承诺
    viewPromise = [UIView new];
    [viewPromise setBackgroundColor:[UIColor whiteColor]];
    //我们的承诺-标题
    lbTitle_primise = [LyUtil lbItemTitleWithText:@"我们的承诺"];
    //我们的承诺-文字
    tvPromise = [UITextView new];
    [tvPromise setFont:LyFont(14)];
    [tvPromise setTextColor:LyBlackColor];
    [tvPromise setTextAlignment:NSTextAlignmentLeft];
    [tvPromise setEditable:NO];
    [tvPromise setScrollEnabled:NO];
    [tvPromise setSelectable:NO];
    [tvPromise setText:@"1、支付成功，立即进入交规考试排队系统，为你节省约一周等待时间\n2、517学车网全包价为驾校总部最低价，差价双倍退还；\n3、支付成功24小时内驾校教练与你确认体检安排；\n4、提供第三方监督及投诉处理体系，学车全程权益保障；\n5、全透明价格，学车全程无任何其他费用；\n6、杜绝索要“红包、请客、保险费”等不正当费用。"];
    CGFloat fHeightTvPromise =  [tvPromise sizeThatFits:CGSizeMake(SCREEN_WIDTH-horizontalSpace*2, MAXFLOAT)].height;
    
    [tvPromise setFrame:CGRectMake(horizontalSpace, lbTitle_primise.frame.origin.y+CGRectGetHeight(lbTitle_primise.frame), SCREEN_WIDTH-horizontalSpace*2, fHeightTvPromise)];
    
    [viewPromise setFrame:CGRectMake(0, 0, SCREEN_WIDTH, tvPromise.frame.origin.y+CGRectGetHeight(tvPromise.frame)+verticalSpace*4)];
    
    [viewPromise addSubview:lbTitle_primise];
    [viewPromise addSubview:tvPromise];
    
    
    
    tvInfo = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-dcbHeight)
                                          style:UITableViewStyleGrouped];
    [tvInfo setDelegate:self];
    [tvInfo setDataSource:self];
    [tvInfo setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tvInfo registerClass:[LyTrainClassDetailTableViewCell class] forCellReuseIdentifier:lyTrainClassDetailTvInfoCellReuseIdentifier];
    [tvInfo registerClass:[LyTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:lyTrainClassDetailTvHeaderFooterViewReuseIdentifier];
    [tvInfo setSectionFooterHeight:0];
    
    [tvInfo setTableHeaderView:viewInfo];
    [tvInfo setTableFooterView:viewPromise];
    
    [self.view addSubview:tvInfo];
    
    controlBar = [LyDetailControlBar controlBarWidthMode:LyDetailControlBarMode_trainClass];
    [controlBar setDelegate:self];
    [self.view addSubview:controlBar];
    
}

- (void)reloadViewData
{
    NSString *strLbTitle_info;
    NSRange rangeForNameMoreInfo = [[_trainClass tcName] rangeOfString:@"（"];
    if ( NSEqualRanges( rangeForNameMoreInfo, NSMakeRange( 0, 0)))
    {
        rangeForNameMoreInfo = [[_trainClass tcName] rangeOfString:@"("];
    }
    
    
    if ( rangeForNameMoreInfo.length > 0)
    {
        strLbTitle_info = [[_trainClass tcName] substringToIndex:rangeForNameMoreInfo.location];
    }
    else
    {
        strLbTitle_info = [_trainClass tcName];
    }
    
    self.title = strLbTitle_info;
    
    //课程信息
    //课程信息-标题
    [lbTitle_info setText:strLbTitle_info];
    //课程信息-名字
    CGSize sizeLbName = [[_trainClass tcName] sizeWithAttributes:@{NSFontAttributeName:lbItemFont}];
    [lbWholeName setFrame:CGRectMake( horizontalSpace, lbTitle_info.frame.origin.y+CGRectGetHeight(lbTitle_info.frame)+verticalSpace, sizeLbName.width, lbItemHeight)];
    [lbWholeName setText:[_trainClass tcName]];
    //课程信息-优惠数
    NSString *strLbFoldTxt = [[NSString alloc] initWithFormat:@"省"];
    NSString *strLbFoldTmp = [[NSString alloc] initWithFormat:@"%@%.0f", strLbFoldTxt, [_trainClass tcOfficialPrice]-[_trainClass tc517WholePrice]];
    
    NSRange rangeFoldTxt = [strLbFoldTmp rangeOfString:strLbFoldTxt];
    CGSize sizeLbFold = [strLbFoldTmp sizeWithAttributes:@{NSFontAttributeName:lbItemFont}];
    
    NSMutableAttributedString *strLbFold = [[NSMutableAttributedString alloc] initWithString:strLbFoldTmp];
    [strLbFold addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeFoldTxt];
    [strLbFold addAttribute:NSBackgroundColorAttributeName value:Ly517ThemeColor range:rangeFoldTxt];
    
    [lbFold setFrame:CGRectMake( lbWholeName.frame.origin.x+CGRectGetWidth(lbWholeName.frame)+horizontalSpace*2, lbWholeName.frame.origin.y+CGRectGetHeight(lbWholeName.frame)/2.0f-sizeLbFold.height/2.0f, sizeLbFold.width+2, sizeLbFold.height)];
    [lbFold setAttributedText:strLbFold];
    //课程信息-教练车型
    NSString *strLbCarName = [[NSString alloc] initWithFormat:@"车型：%@", [_trainClass tcCarName]];
    CGSize sizeLbCarName = [strLbCarName sizeWithAttributes:@{NSFontAttributeName:lbItemFont}];
    [lbCarType setFrame:CGRectMake( lbWholeName.frame.origin.x, lbWholeName.frame.origin.y+CGRectGetHeight(lbWholeName.frame)+verticalSpace, sizeLbCarName.width, lbItemHeight)];
    [lbCarType setText:strLbCarName];
    //课程信息-班别
    NSString *strLbTime = [[NSString alloc] initWithFormat:@"班别：%@", [_trainClass tcTrainTime]];
    CGSize sizeLbTime = [strLbTime sizeWithAttributes:@{NSFontAttributeName:lbItemFont}];
    [lbTrainClassTime setFrame:CGRectMake( lbCarType.frame.origin.x+CGRectGetWidth(lbCarType.frame)+horizontalSpace*2.0f, lbCarType.frame.origin.y, sizeLbTime.width, lbItemHeight)];
    [lbTrainClassTime setText:strLbTime];
    //课程信息-官方价
    NSString *strLbOfficialPrice = [[NSString alloc] initWithFormat:@"官方价：￥%.0f", [_trainClass tcOfficialPrice]];
    CGSize sizeLbOfficialPrice = [strLbOfficialPrice sizeWithAttributes:@{NSFontAttributeName:lbItemFont}];
    [lbOfficialPrice setFrame:CGRectMake( lbCarType.frame.origin.x, lbCarType.frame.origin.y+CGRectGetHeight(lbCarType.frame)+verticalSpace, sizeLbOfficialPrice.width, lbItemHeight)];
    [lbOfficialPrice setText:strLbOfficialPrice];
    //课程信息-517价
    NSString *strLb517PriceNum = [[NSString alloc] initWithFormat:@"%.0f", [_trainClass tc517WholePrice]];
    NSString *strLb517PriceTmp = [[NSString alloc] initWithFormat:@"优惠价：%@", strLb517PriceNum];
    
    NSRange rangeLb517PriceNum = [strLb517PriceTmp rangeOfString:strLb517PriceNum];
    CGSize sizeLb517Price = [strLb517PriceTmp sizeWithAttributes:@{NSFontAttributeName:lbItemFont}];
    
    NSMutableAttributedString *strLb517Price = [[NSMutableAttributedString alloc] initWithString:strLb517PriceTmp];
    [strLb517Price addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:rangeLb517PriceNum];
    
    [lbWhole517Price setFrame:CGRectMake( lbOfficialPrice.frame.origin.x+CGRectGetWidth(lbOfficialPrice.frame)+horizontalSpace*2.0f, lbOfficialPrice.frame.origin.y, sizeLb517Price.width, lbItemHeight)];
    [lbWhole517Price setAttributedText:strLb517Price];
    
    
    
    [tvInfo reloadData];
    [tvInfo layoutSubviews];
}







#pragma mark -LyDetailControlBarDelegate
- (void)onClickedButtonApply
{
    LyCreateOrderViewController *createOrder = [[LyCreateOrderViewController alloc] init];
    [createOrder setDelegate:self];
    
    if ([LyCurrentUser curUser].isLogined) {
        [self.navigationController pushViewController:createOrder animated:YES];
    } else {
        [LyUtil showLoginVc:self nextVC:createOrder showMode:LyShowVcMode_push];
    }
}


#pragma mark -LyCreateOrderViewControllerDelegate
- (NSDictionary *)obtainGoodsInfo_crateOrder
{
    return @{
             goodKey:_trainClass,
             teacherKey:_teacher
             };
}




#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section && 1 == indexPath.row)
    {
        return tcdcellHeight*2;
    }
    else
    {
        return tcdcellHeight;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return LyTableViewHeaderFooterViewHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LyTableViewHeaderFooterView *hfView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:lyTrainClassDetailTvHeaderFooterViewReuseIdentifier];
    
    if (!hfView)
    {
        hfView = [[LyTableViewHeaderFooterView alloc] initWithReuseIdentifier:lyTrainClassDetailTvHeaderFooterViewReuseIdentifier];
    }
    
    NSString *strConetnt;
    if (0 == section)
    {
        strConetnt = @"费用明细";
    }
    else if (1 == section)
    {
        strConetnt = @"培训服务";
    }
    else
    {
        strConetnt = @"空";
    }
    
    [hfView setContent:strConetnt];
    
    return hfView;
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section)
    {
        return 2;
    }
    else if (1 == section)
    {
        return 6;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyTrainClassDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyTrainClassDetailTvInfoCellReuseIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[LyTrainClassDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyTrainClassDetailTvInfoCellReuseIdentifier];
    }
    
    if (0 == indexPath.section)
    {
        switch (indexPath.row) {
            case 0: {
                [cell setCellInfo:@"总学费" content:[[NSString alloc] initWithFormat:@"%.0f元", _trainClass.tc517WholePrice]];
                break;
            }
            case 1: {
                [cell setCellInfo:@"包含" content:_trainClass.tcInclude];
                break;
            }
            default:
                break;
        }
    }
    else if (1 == indexPath.section)
    {
        switch (indexPath.row) {
            case 0: {
                [cell setCellInfo:@"驾照类型" content:[LyUtil driveLicenseStringFrom:_trainClass.tcLicenseType]];
                break;
            }
            case 1: {
                [cell setCellInfo:@"教练车型" content:_trainClass.tcCarName];
                break;
            }
            case 2: {
                [cell setCellInfo:@"排队时间" content:[[NSString alloc] initWithFormat:@"%i天", _trainClass.tcWaitDays]];
                break;
            }
            case 3: {
                [cell setCellInfo:@"学车课程" content:[[NSString alloc] initWithFormat:@"科二：%d课时  科三：%d课时", _trainClass.tcObjectPeriod.secondPeriod, _trainClass.tcObjectPeriod.thirdPeriod]];
                break;
            }
            case 4: {
                [cell setCellInfo:@"接送方式" content:[LyUtil pickTypeStringFrom:_trainClass.tcPickType]];
                break;
            }
            case 5: {
                [cell setCellInfo:@"练车方式" content:[LyUtil trainModeStringFrom:_trainClass.tcTrainMode]];
                break;
            }
            default:
                break;
        }
    }
    
    return cell;
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
