//
//  LyPriceDetailViewController.m
//  student
//
//  Created by Junes on 2016/9/27.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyPriceDetailViewController.h"
#import "LyPriceDetailTableViewCell.h"

#import "LyUserManager.h"
#import "LyPriceDetailManager.h"

#import "LyIndicator.h"

#import "LyUtil.h"


CGFloat const pdViewLicenseHeight = 40.0f;
CGFloat const pdLbLicenseWidth = 50.0f;

CGFloat const pdHeaderTitleHeight = 40.0f;


enum {
    priceDetailTableViewTag_second = 50,
    priceDetailTableViewTag_third
}LyPriceDetailTableViewTag;


@interface LyPriceDetailViewController () <UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource, LyHttpRequestDelegate>
{
    UIScrollView                    *svMain;
    
    UIView                          *viewLicense;
    UILabel                         *lbLicense;
    
    
    UIView                          *viewObjectSecond;
    UILabel                         *lbTitle_objectSecond;
    UITableView                     *tvObjectSecond;
    UILabel                         *lbNull_objectSecond;
    
    
    
    UIView                          *viewObjectThird;
    UILabel                         *lbTitle_objectThird;
    UITableView                     *tvObjectThird;
    UILabel                         *lbNull_objectThird;
    
    NSArray                         *arrPriceDetail;
    NSMutableDictionary             *dicPriceDetailSecond;//存储科目三所有价格详情
    NSMutableDictionary             *dicPriceDetailThird;//存储科目二所有价格详情
    NSMutableArray                  *arrWeekdaySecond;  //存储科目二星期范围，主要用于排序
    NSMutableArray                  *arrWeekdayThird;   //存储科目三星期范围，主要用于排序
}
@end

@implementation LyPriceDetailViewController

static NSString *lyPriceDetailObjectSecondTableViewCellReuseIdentifier = @"lyPriceDetailObjectSecondTableViewCellReuseIdentifier";
static NSString *lyPriceDetailObjectThirdTableViewCellReuseIdentifier = @"lyPriceDetailObjectThirdTableViewCellReuseIdentifier";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}



- (void)viewWillAppear:(BOOL)animated {
    _teacherId = [_delegate obtainTeacherIdByPriceDetailVC:self];
    if (![LyUtil validateString:_teacherId]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self reloadData];
}



- (void)initSubviews {
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.title = @"培训价格";
    
    
    viewLicense = [[UIView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT+verticalSpace, SCREEN_WIDTH, pdViewLicenseHeight)];
    [viewLicense setBackgroundColor:[UIColor whiteColor]];
    UILabel *lbTitle_license = [[UILabel alloc] initWithFrame:viewLicense.bounds];
    [lbTitle_license setFont:LyFont(16)];
    [lbTitle_license setTextColor:[UIColor blackColor]];
    [lbTitle_license setTextAlignment:NSTextAlignmentCenter];
    [lbTitle_license setText:@"每学时单价明细"];
    
    lbLicense = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-pdLbLicenseWidth, 0, pdLbLicenseWidth, pdViewLicenseHeight)];
    [lbLicense setFont:LyFont(14)];
    [lbLicense setTextColor:Ly517ThemeColor];
    [lbLicense setTextAlignment:NSTextAlignmentCenter];
    
    [viewLicense addSubview:lbTitle_license];
    [viewLicense addSubview:lbLicense];
    
    [self.view addSubview:viewLicense];
    
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, viewLicense.frame.origin.y+CGRectGetHeight(viewLicense.frame)+verticalSpace, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-CGRectGetHeight(viewLicense.frame)+verticalSpace*2)];
    [svMain setBackgroundColor:[UIColor whiteColor]];
    [svMain setDelegate:self];
    [svMain setBounces:YES];
    [self.view addSubview:svMain];
    
    
   
    
    
    viewObjectSecond = [[UIView alloc] init];
    lbTitle_objectSecond = [LyUtil lbItemTitleWithText:@"科目二"];
    tvObjectSecond = [[UITableView alloc] initWithFrame:CGRectMake( 0, lbTitle_objectSecond.frame.origin.y+CGRectGetHeight(lbTitle_objectSecond.frame), SCREEN_WIDTH, LyViewItemHeight)
                                                  style:UITableViewStylePlain];
    [tvObjectSecond setTag:priceDetailTableViewTag_second];
    [tvObjectSecond setDelegate:self];
    [tvObjectSecond setDataSource:self];
    [tvObjectSecond setScrollEnabled:NO];
    [tvObjectSecond setSectionHeaderHeight:pdHeaderTitleHeight];
    [tvObjectSecond setSectionFooterHeight:0];
    [tvObjectSecond registerClass:[LyPriceDetailTableViewCell class] forCellReuseIdentifier:lyPriceDetailObjectSecondTableViewCellReuseIdentifier];
    
    [viewObjectSecond addSubview:lbTitle_objectSecond];
    [viewObjectSecond addSubview:tvObjectSecond];
    
    
    viewObjectThird = [[UIView alloc] init];
    lbTitle_objectThird = [LyUtil lbItemTitleWithText:@"科目三"];
    tvObjectThird = [[UITableView alloc] initWithFrame:CGRectMake( 0, lbTitle_objectThird.frame.origin.y+CGRectGetHeight(lbTitle_objectThird.frame), SCREEN_WIDTH, LyViewItemHeight)
                                                 style:UITableViewStylePlain];
    [tvObjectThird setTag:priceDetailTableViewTag_third];
    [tvObjectThird setDelegate:self];
    [tvObjectThird setDataSource:self];
    [tvObjectThird setScrollEnabled:NO];
    [tvObjectThird setSectionHeaderHeight:pdHeaderTitleHeight];
    [tvObjectThird setSectionFooterHeight:0];
    [tvObjectThird registerClass:[LyPriceDetailTableViewCell class] forCellReuseIdentifier:lyPriceDetailObjectThirdTableViewCellReuseIdentifier];
    
    [viewObjectThird addSubview:lbTitle_objectThird];
    [viewObjectThird addSubview:tvObjectThird];
    
    
    [svMain addSubview:viewObjectSecond];
    [svMain addSubview:viewObjectThird];
}

- (void)reloadData {
    
    LyUser *teacher = [[LyUserManager sharedInstance] getUserWithUserId:_teacherId];
    [lbLicense setText:[teacher userLicenseTypeByString]];
    
    arrPriceDetail = [[LyPriceDetailManager sharedInstance] priceDetailWithUserId:_teacherId];
    
    if ( !dicPriceDetailSecond) {
        dicPriceDetailSecond = [[NSMutableDictionary alloc] initWithCapacity:1];
    } else {
        [dicPriceDetailSecond removeAllObjects];
    }
    
    if ( !dicPriceDetailThird) {
        dicPriceDetailThird = [[NSMutableDictionary alloc] initWithCapacity:1];
    } else {
        [dicPriceDetailThird removeAllObjects];
    }
    
    
    //将价格详情按科目，星期几分类
    for (LyPriceDetail *priceDetail in arrPriceDetail) {
        if ( !priceDetail) {
            continue;
        }
        
        if ( LySubjectModeprac_second == priceDetail.pdSubjectMode) {
            
            NSMutableArray *arrTime = [dicPriceDetailSecond objectForKey:priceDetail.pdWeekday];
            if ( !arrTime) {
                arrTime = [[NSMutableArray alloc] initWithCapacity:1];
                [dicPriceDetailSecond setObject:arrTime forKey:priceDetail.pdWeekday];
            }
            //直接使用LyPriceDetail
            [arrTime addObject:priceDetail];
            
        } else if ( LySubjectModeprac_third == priceDetail.pdSubjectMode) {
            
            NSMutableArray *arrTime = [dicPriceDetailThird objectForKey:priceDetail.pdWeekday];
            if ( !arrTime) {
                arrTime = [[NSMutableArray alloc] initWithCapacity:1];
                [dicPriceDetailThird setObject:arrTime forKey:priceDetail.pdWeekday];
            }
            //直接使用LyPriceDetail
            [arrTime addObject:priceDetail];
        }
        
    }
    
    //科目二星期几排序
    arrWeekdaySecond = [[NSMutableArray alloc] initWithArray:[dicPriceDetailSecond allKeys]];
    [arrWeekdaySecond sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        LyWeekdaySpan ws1 = [LyUtil weekdaySpanFromString:obj1];
        LyWeekdaySpan ws2 = [LyUtil weekdaySpanFromString:obj2];
        
        if (ws1.begin == ws2.begin) {
            if (ws1.end > ws2.end) {
                return NSOrderedDescending;
            } else {
                return NSOrderedAscending;
            }
        } else {
            if (ws1.begin > ws2.begin) {
                return NSOrderedDescending;
            } else {
                return NSOrderedAscending;
            }
        }
    }];
    //科目二内部价格详情排序
    for (NSMutableArray *arr in [dicPriceDetailSecond allValues]) {
        [arr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj1 pdTimeBucket].begin == [obj2 pdTimeBucket].begin) {
                if ([obj1 pdTimeBucket].end > [obj2 pdTimeBucket].end) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedAscending;
                }
            } else {
                if ([obj1 pdTimeBucket].begin > [obj2 pdTimeBucket].begin) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedAscending;
                }
            }
        }];
    }
    
    
    //科目三星期几排序
    arrWeekdayThird = [[NSMutableArray alloc] initWithArray:[dicPriceDetailThird allKeys]];
    [arrWeekdayThird sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        LyWeekdaySpan ws1 = [LyUtil weekdaySpanFromString:obj1];
        LyWeekdaySpan ws2 = [LyUtil weekdaySpanFromString:obj2];
        
        if (ws1.begin == ws2.begin) {
            if (ws1.end > ws2.end) {
                return NSOrderedDescending;
            } else {
                return NSOrderedAscending;
            }
        } else {
            if (ws1.begin > ws2.begin) {
                return NSOrderedDescending;
            } else {
                return NSOrderedAscending;
            }
        }
    }];
    //科目三内部价格详情排序
    for (NSMutableArray *arr in [dicPriceDetailThird allValues]) {
        [arr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj1 pdTimeBucket].begin == [obj2 pdTimeBucket].begin) {
                if ([obj1 pdTimeBucket].end > [obj2 pdTimeBucket].end) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedAscending;
                }
            } else {
                if ([obj1 pdTimeBucket].begin > [obj2 pdTimeBucket].begin) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedAscending;
                }
            }
        }];
    }
    
    
    //科目二视图重画
    if (!dicPriceDetailSecond || dicPriceDetailSecond.count < 1) {
        [self showLbNull_objectSecond];
    } else {
        [self removeLbNull_objectSecond];
        
        CGFloat heightForTvObjectSecond = pdHeaderTitleHeight * dicPriceDetailSecond.count;
        for (NSArray *arr in [dicPriceDetailSecond allValues]) {
            heightForTvObjectSecond += pdcellHeight * arr.count;
        }
        heightForTvObjectSecond += verticalSpace*2;
        
        
        [tvObjectSecond setFrame:CGRectMake( 0, lbTitle_objectSecond.frame.origin.y+CGRectGetHeight(lbTitle_objectSecond.frame), SCREEN_WIDTH, heightForTvObjectSecond)];
        [viewObjectSecond setFrame:CGRectMake( 0, verticalSpace, SCREEN_WIDTH, tvObjectSecond.frame.origin.y+CGRectGetHeight(tvObjectSecond.frame))];
        [tvObjectSecond reloadData];
    }
    
    //科目三视图重画
    if (!dicPriceDetailThird || dicPriceDetailThird.count < 1) {
        [self showLbNull_objectThird];
    } else {
        [self removeLbNull_objectThird];
        
        CGFloat heightForTvObjectThird = pdHeaderTitleHeight * dicPriceDetailThird.count;
        for (NSArray *arr in [dicPriceDetailThird allValues]) {
            heightForTvObjectThird += pdcellHeight * arr.count;
        }
        heightForTvObjectThird += verticalSpace*2;
        
        
        [tvObjectThird setFrame:CGRectMake( 0, lbTitle_objectSecond.frame.origin.y+CGRectGetHeight(lbTitle_objectSecond.frame), SCREEN_WIDTH, heightForTvObjectThird)];
        [viewObjectThird setFrame:CGRectMake( 0, viewObjectSecond.frame.origin.y+CGRectGetHeight(viewObjectSecond.frame)+verticalSpace*2.0f, SCREEN_WIDTH, tvObjectThird.frame.origin.y+CGRectGetHeight(tvObjectThird.frame))];
        [tvObjectThird reloadData];
    }
    
    CGFloat sizeY = viewObjectThird.frame.origin.y+CGRectGetHeight(viewObjectThird.frame)+50.0f;
    sizeY = (sizeY < CGRectGetHeight(svMain.frame)) ? CGRectGetHeight(svMain.frame) * 1.05f : sizeY;
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, sizeY)];
}


- (void)showLbNull_objectSecond {
    if (!lbNull_objectSecond) {
        lbNull_objectSecond = [LyUtil lbNullWithText:@"还没有相关数据"];
        [lbNull_objectSecond setFrame:CGRectMake(0, lbTitle_objectSecond.frame.origin.y+CGRectGetHeight(lbTitle_objectSecond.frame), SCREEN_WIDTH, LyViewItemHeight)];
    }
    
    [viewObjectSecond addSubview:lbNull_objectSecond];
    [tvObjectSecond setFrame:CGRectMake( 0, lbTitle_objectSecond.frame.origin.y+CGRectGetHeight(lbTitle_objectSecond.frame), SCREEN_WIDTH, 0)];
    [viewObjectSecond setFrame:CGRectMake(0, verticalSpace, SCREEN_WIDTH, lbNull_objectSecond.frame.origin.y+CGRectGetHeight(lbNull_objectSecond.frame))];
}
- (void)removeLbNull_objectSecond {
    [lbNull_objectSecond removeFromSuperview];
    lbNull_objectSecond = nil;
}

- (void)showLbNull_objectThird {
    if (!lbNull_objectThird) {
        lbNull_objectThird = [LyUtil lbNullWithText:@"还没有相关数据"];
        [lbNull_objectThird setFrame:CGRectMake(0, lbTitle_objectThird.frame.origin.y+CGRectGetHeight(lbTitle_objectThird.frame), SCREEN_WIDTH, LyViewItemHeight)];
    }
    
    [viewObjectThird addSubview:lbNull_objectThird];
    [tvObjectThird setFrame:CGRectMake( 0, lbTitle_objectThird.frame.origin.y+CGRectGetHeight(lbTitle_objectThird.frame), SCREEN_WIDTH, 0)];
    [viewObjectThird setFrame:CGRectMake(0, viewObjectSecond.frame.origin.y+CGRectGetHeight(viewObjectSecond.frame)+verticalSpace*2.0f, SCREEN_WIDTH, lbNull_objectThird.frame.origin.y+CGRectGetHeight(lbNull_objectThird.frame))];
}
- (void)removeLbNull_objectThird {
    [lbNull_objectThird removeFromSuperview];
    lbNull_objectThird = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return pdcellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( priceDetailTableViewTag_second == [tableView tag]) {
        return pdHeaderTitleHeight;
    } else if ( priceDetailTableViewTag_third == [tableView tag]) {
        return pdHeaderTitleHeight;
    }
    
    return 0.0f;
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( priceDetailTableViewTag_second == [tableView tag]) {
        return dicPriceDetailSecond.count;
    } else if ( priceDetailTableViewTag_third == [tableView tag]) {
        return dicPriceDetailThird.count;
    }
    
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( priceDetailTableViewTag_second == [tableView tag]) {
        return [[dicPriceDetailSecond objectForKey:[arrWeekdaySecond objectAtIndex:section]] count];
        
    } else if ( priceDetailTableViewTag_third == [tableView tag]) {
        return [[dicPriceDetailThird objectForKey:[arrWeekdayThird objectAtIndex:section]] count];
        
    }
    
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( priceDetailTableViewTag_second == [tableView tag]) {
        LyPriceDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyPriceDetailObjectSecondTableViewCellReuseIdentifier forIndexPath:indexPath];
        
        if ( !cell) {
            cell = [[LyPriceDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyPriceDetailObjectSecondTableViewCellReuseIdentifier];
        }
        
        NSArray *arrPd = [dicPriceDetailSecond objectForKey:[arrWeekdaySecond objectAtIndex:indexPath.section]];
        LyPriceDetail *pd = [arrPd objectAtIndex:indexPath.row];
        [cell setPriceDetail:pd];
        
        return cell;
    }
    else if ( priceDetailTableViewTag_third == [tableView tag])
    {
        LyPriceDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyPriceDetailObjectThirdTableViewCellReuseIdentifier forIndexPath:indexPath];
        
        if ( !cell) {
            cell = [[LyPriceDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyPriceDetailObjectThirdTableViewCellReuseIdentifier];
        }
        
        NSArray *arrPd = [dicPriceDetailThird objectForKey:[arrWeekdayThird objectAtIndex:indexPath.section]];
        LyPriceDetail *pd = [arrPd objectAtIndex:indexPath.row];
        [cell setPriceDetail:pd];
        
        return cell;
    }
    
    return nil;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ( priceDetailTableViewTag_second == [tableView tag]) {
        
        return [LyUtil weekdaySpanChineseStringFromString:[arrWeekdaySecond objectAtIndex:section]];
    } else if ( priceDetailTableViewTag_third == [tableView tag]) {
        
        return [LyUtil weekdaySpanChineseStringFromString:[arrWeekdayThird objectAtIndex:section]];
    }
    
    
    return nil;
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return nil;
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
