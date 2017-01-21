//
//  LyPriceDetailViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/20.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyPriceDetailViewController.h"
#import "LyPriceDetailTableViewCell.h"

#import "LyIndicator.h"
#import "LyRemindView.h"
#import "LyDriveLicensePicker.h"

#import "LyCurrentUser.h"
#import "LyPriceDetailManager.h"

#import "UIViewController+CloseSelf.h"

#import "LyUtil.h"

#import "LyAddPriceDetailViewController.h"



CGFloat const pdViewLicenseHeight = 50.0f;
CGFloat const pdBtnLicenseWidth = 100.0f;


#define svMainHeight                                (SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-pdViewLicenseHeight-verticalSpace)

#define lbTitleWidth                                SCREEN_WIDTH
CGFloat const pdLbTitleHeight = 40.0f;
#define lbTitleFont                                 LyFont(14)


#define rpdViewItemWidth                            SCREEN_WIDTH
CGFloat const pdViewItemHeight = 10.0f;

#define tvItemWidth                                 rpdViewItemWidth
#define tvItemHeight                                pdViewItemHeight


CGFloat const pdHeaderTitleHeight = 40.0f;



enum {
    priceDetailBarButtonItemTag_edit = 0,
    priceDetailBarButtonItemTag_done,
    priceDetailBarButtonItemTag_add,
}LyPriceDetailBarButtonItemTag;


enum {
    priceDetailButtonTag_license = 10,
}LyPriceDetailButtonTag;


typedef NS_ENUM( NSInteger, LyPriceDetailTableViewMode)
{
    priceDetailTableViewMode_objectSecond = 50,
    priceDetailTableViewMode_objectThird
};



typedef NS_ENUM(NSInteger, LyPriceDetailHttpMethod) {
    priceDetailHttpMethod_load = 100,
    priceDetailHttpMethod_loadWithLicense,
    priceDetailHttpMethod_delete
};



@interface LyPriceDetailViewController () <UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource, LyHttpRequestDelegate, LyDriveLicensePickerDelegate, LyPriceDetailTableViewCellDelegate, LyAddPriceDetailViewControllerDelegate>
{
    UIBarButtonItem                 *bbiEdit;
    UIBarButtonItem                 *bbiAdd;
    
    UIView                          *viewLicense;
    UILabel                         *lbLicense;
    UIButton                        *btnLicense;
    
    UIView                          *viewError;
    UIScrollView                    *svMain;
    
    
    
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
    
    
//    LyPriceDetailTableViewMode      curTvIdx;
//    NSIndexPath                     *curIdx;
    LyPriceDetail                   *curPd;
    
    
    LyIndicator                     *indicator;
    LyIndicator                     *indicator_oper;
    BOOL                            bHttpFlag;
    LyPriceDetailHttpMethod         curHttpMethod;
}

@property (assign, nonatomic)         LyLicenseType           curLicense;
@property (assign, nonatomic, getter=isEditing)       BOOL        editing;
@property (strong, nonatomic)       UIRefreshControl        *refreshControl;

@end

@implementation LyPriceDetailViewController


static NSString *lyPriceDetailObjectSecondTableViewCellReuseIdentifier = @"lyPriceDetailObjectSecondTableViewCellReuseIdentifier";
static NSString *lyPriceDetailObjectThirdTableViewCellReuseIdentifier = @"lyPriceDetailObjectThirdTableViewCellReuseIdentifier";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}



- (void)viewWillAppear:(BOOL)animated {
    arrPriceDetail = [[LyPriceDetailManager sharedInstance] priceDetailWithUserId:[LyCurrentUser curUser].userId license:_curLicense];
    if (!arrPriceDetail || arrPriceDetail.count < 1) {
        [self load];
    } else {
        [self reloadData];
    }
}



- (void)initAndLayoutSubviews {
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.title = @"培训价格";
    
    if ([LyCurrentUser curUser].isMaster) {
        bbiEdit = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                   style:UIBarButtonItemStyleDone
                                                  target:self
                                                  action:@selector(targetForBarButtonItem:)];
        [bbiEdit setTag:priceDetailBarButtonItemTag_edit];
        
        bbiAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                               target:self
                                                               action:@selector(targetForBarButtonItem:)];
        [bbiAdd setTag:priceDetailBarButtonItemTag_add];
        
        [self.navigationItem setRightBarButtonItems:@[bbiEdit, bbiAdd]];
    }
    
    
    
    
    //当前驾照
    viewLicense = [[UIView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, pdViewLicenseHeight)];
    [viewLicense setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:viewLicense];
    //当前驾照-标题
    lbLicense = [LyUtil lbItemTitleWithText:@"当前驾照类型"];
    [lbLicense setBackgroundColor:[UIColor whiteColor]];
    [lbLicense setFrame:CGRectMake(horizontalSpace, 0, 100.0f, pdViewLicenseHeight)];
    //当前驾照-按钮
    btnLicense = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-pdBtnLicenseWidth, 0, pdBtnLicenseWidth, pdViewLicenseHeight)];
    [btnLicense setTag:priceDetailButtonTag_license];
    [btnLicense setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnLicense addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewLicense addSubview:lbLicense];
    [viewLicense addSubview:btnLicense];
    
    
    
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, viewLicense.ly_y+CGRectGetHeight(viewLicense.frame)+verticalSpace, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-CGRectGetHeight(viewLicense.frame)-verticalSpace)];
    [svMain setBackgroundColor:LyWhiteLightgrayColor];
    [svMain setDelegate:self];
    [svMain setBounces:YES];
    [self.view addSubview:svMain];
    
    [svMain addSubview:self.refreshControl];
    

    viewObjectSecond = [[UIView alloc] init];
    lbTitle_objectSecond = [LyUtil lbItemTitleWithText:@"科目二"];
    tvObjectSecond = [[UITableView alloc] initWithFrame:CGRectMake( 0, lbTitle_objectSecond.ly_y+CGRectGetHeight(lbTitle_objectSecond.frame), tvItemWidth, tvItemHeight)
                                                  style:UITableViewStyleGrouped];
    [tvObjectSecond setTag:priceDetailTableViewMode_objectSecond];
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
    tvObjectThird = [[UITableView alloc] initWithFrame:CGRectMake( 0, lbTitle_objectThird.ly_y+CGRectGetHeight(lbTitle_objectThird.frame), tvItemWidth, tvItemHeight)
                                                 style:UITableViewStyleGrouped];
    [tvObjectThird setTag:priceDetailTableViewMode_objectThird];
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
    
    _curLicense = LyLicenseType_C1;
    [btnLicense setTitle:[LyUtil driveLicenseStringFrom:_curLicense] forState:UIControlStateNormal];
}


- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [LyUtil refreshControlWithTitle:nil
                                                   target:self
                                                   action:@selector(refresh:)];
    }
    
    return _refreshControl;
}


- (void)showViewError {
    
    if ( !viewError)
    {
        viewError = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, svMainHeight*1.2f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewError addSubview:[LyUtil lbErrorWithMode:0]];
    }
    [svMain setContentSize:CGSizeMake( SCREEN_WIDTH, svMainHeight*1.05f)];
    [svMain addSubview:viewError];
}


- (void)removeViewError {
    [viewError removeFromSuperview];
    viewError = nil;
}



- (void)reloadData {
    
    [self removeViewError];
    
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
        
        
        [tvObjectSecond setFrame:CGRectMake( 0, lbTitle_objectSecond.ly_y+CGRectGetHeight(lbTitle_objectSecond.frame), SCREEN_WIDTH, heightForTvObjectSecond)];
        [viewObjectSecond setFrame:CGRectMake( 0, verticalSpace, SCREEN_WIDTH, tvObjectSecond.ly_y+CGRectGetHeight(tvObjectSecond.frame))];
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
        
        
        [tvObjectThird setFrame:CGRectMake( 0, lbTitle_objectSecond.ly_y+CGRectGetHeight(lbTitle_objectSecond.frame), SCREEN_WIDTH, heightForTvObjectThird)];
        [viewObjectThird setFrame:CGRectMake( 0, viewObjectSecond.ly_y+CGRectGetHeight(viewObjectSecond.frame)+verticalSpace*2.0f, SCREEN_WIDTH, tvObjectThird.ly_y+CGRectGetHeight(tvObjectThird.frame))];
        [tvObjectThird reloadData];
    }
    
    CGFloat fCZHeight = viewObjectThird.ly_y + CGRectGetHeight(viewObjectThird.frame) + 50.0f;
    if (fCZHeight <= CGRectGetHeight(svMain.frame)) {
        fCZHeight = CGRectGetHeight(svMain.frame) * 1.05f;
    }
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, fCZHeight)];
}


- (void)showLbNull_objectSecond {
    if (!lbNull_objectSecond) {
        lbNull_objectSecond = [LyUtil lbNullWithText:@"还没有相关数据"];
        [lbNull_objectSecond setBackgroundColor:[UIColor whiteColor]];
        [lbNull_objectSecond setFrame:CGRectMake(0, lbTitle_objectSecond.ly_y+CGRectGetHeight(lbTitle_objectSecond.frame), SCREEN_WIDTH, LyViewItemHeight)];
    }
    
    [viewObjectSecond addSubview:lbNull_objectSecond];
    [tvObjectSecond setFrame:CGRectMake( 0, lbTitle_objectSecond.ly_y+CGRectGetHeight(lbTitle_objectSecond.frame), SCREEN_WIDTH, 0)];
    [viewObjectSecond setFrame:CGRectMake(0, verticalSpace, SCREEN_WIDTH, lbNull_objectSecond.ly_y+CGRectGetHeight(lbNull_objectSecond.frame))];
}
- (void)removeLbNull_objectSecond {
    [lbNull_objectSecond removeFromSuperview];
    lbNull_objectSecond = nil;
}

- (void)showLbNull_objectThird {
    if (!lbNull_objectThird) {
        lbNull_objectThird = [LyUtil lbNullWithText:@"还没有相关数据"];
        [lbNull_objectThird setBackgroundColor:[UIColor whiteColor]];
        [lbNull_objectThird setFrame:CGRectMake(0, lbTitle_objectThird.ly_y+CGRectGetHeight(lbTitle_objectThird.frame), SCREEN_WIDTH, LyViewItemHeight)];
    }
    
    [viewObjectThird addSubview:lbNull_objectThird];
    [tvObjectThird setFrame:CGRectMake( 0, lbTitle_objectThird.ly_y+CGRectGetHeight(lbTitle_objectThird.frame), SCREEN_WIDTH, 0)];
    [viewObjectThird setFrame:CGRectMake(0, viewObjectSecond.ly_y+CGRectGetHeight(viewObjectSecond.frame)+verticalSpace*2.0f, SCREEN_WIDTH, lbNull_objectThird.ly_y+CGRectGetHeight(lbNull_objectThird.frame))];
}
- (void)removeLbNull_objectThird {
    [lbNull_objectThird removeFromSuperview];
    lbNull_objectThird = nil;
}


- (void)setCurLicense:(LyLicenseType)curLicense {

    _curLicense = curLicense;
    
    [btnLicense setTitle:[LyUtil driveLicenseStringFrom:_curLicense] forState:UIControlStateNormal];
    
    if ([self isVisiable]) {
        [self loadWithLicense];
    }
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    if (priceDetailBarButtonItemTag_edit == bbi.tag) {
        
        [bbiEdit setTitle:@"完成"];
        [bbi setTag:priceDetailBarButtonItemTag_done];
        self.editing = YES;
        [self reloadData];
        
    } else if (priceDetailBarButtonItemTag_done == bbi.tag) {
        
        [bbiEdit setTitle:@"编辑"];
        [bbi setTag:priceDetailBarButtonItemTag_edit];
        self.editing = NO;
        [self reloadData];
    } else if (priceDetailBarButtonItemTag_add == bbi.tag) {
        LyAddPriceDetailViewController *addPriceDetail = [[LyAddPriceDetailViewController alloc] init];
        [addPriceDetail setDelegate:self];
        [self.navigationController pushViewController:addPriceDetail animated:YES];
    }
}


- (void)targetForButton:(UIButton *)button {
    if (priceDetailButtonTag_license == button.tag) {
        if (LyUserType_coach == [LyCurrentUser curUser].userType &&
            (LyCoachMode_normal == [LyCurrentUser curUser].coachMode || LyCoachMode_staff == [LyCurrentUser curUser].coachMode))
        {
            return;
        }
        LyDriveLicensePicker *dlPicker = [[LyDriveLicensePicker alloc] init];
        [dlPicker setDelegate:self];
        [dlPicker setInitDriveLicense:_curLicense];
        [dlPicker show];
    }
}

- (void)refresh:(UIRefreshControl *)rc {
    [self load];
}


- (void)load {
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:nil];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:priceDetailHttpMethod_load];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:priceDetailByLicense_url
                                 body:@{
                                       masterIdKey:[LyCurrentUser curUser].userId,
                                       driveLicenseKey:[LyUtil driveLicenseStringFrom:_curLicense],
                                       sessionIdKey:[LyUtil httpSessionId]
                                       }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}

- (void)loadWithLicense {
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:nil];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:priceDetailHttpMethod_loadWithLicense];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:priceDetailByLicense_url
                                 body:@{
                                        masterIdKey:[LyCurrentUser curUser].userId,
                                        driveLicenseKey:[LyUtil driveLicenseStringFrom:_curLicense],
                                        sessionIdKey:[LyUtil httpSessionId]
                                        }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)modify {
//    modifyPriceDetail_url
}


- (void)delete {
    //deletePriceDetail_url
    if (!indicator_oper) {
        indicator_oper = [LyIndicator indicatorWithTitle:LyIndicatorTitle_delete];
    } else {
        [indicator_oper setTitle:LyIndicatorTitle_delete];
    }
    
    [indicator_oper startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:priceDetailHttpMethod_delete];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:deletePriceDetail_url
                                 body:@{
                                       idKey:curPd.pdId,
                                       sessionIdKey:[LyUtil httpSessionId]
                                       }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
    
}

- (void)handleHttpFailed {
    if ([indicator isAnimating]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        [self showViewError];
    }
    
    if ([indicator_oper isAnimating]) {
        [indicator_oper stopAnimation];
        if ([indicator_oper.title isEqualToString:LyIndicatorTitle_delete]) {
            LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"删除失败"];
            [remind show];
        }
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
        [self.refreshControl endRefreshing];
        [indicator_oper stopAnimation];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        [indicator_oper stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    switch (curHttpMethod) {
        case priceDetailHttpMethod_load: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if ([LyUtil validateArray:arrResult]) {
                    
                        for (NSDictionary *dicItem in arrResult) {
                            if (![LyUtil validateDictionary:dicItem]) {
                                continue;
                            }
                            
                            NSString *strId = [dicItem objectForKey:idKey];
                            NSString *strWeekdays = [dicItem objectForKey:weekdaysKey];
                            NSString *strTimeBucket = [dicItem objectForKey:timebucketKey];
                            NSString *strPrice = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:priceKey]];
                            NSString *strDriveLicense = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:driveLicenseKey]];
                            NSString *strSubject = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:subjectModeKey]];
                            
                            LyPriceDetail *priceDetail = [LyPriceDetail priceDetailWithPdId:strId
                                                                              pdLicenseType:[LyUtil driveLicenseFromString:strDriveLicense]
                                                                              pdSubjectMode:[strSubject integerValue]
                                                                                 pdMasterId:[LyCurrentUser curUser].userId
                                                                                  pdWeekday:strWeekdays
                                                                                     pdTime:strTimeBucket
                                                                                    pdPrice:[strPrice floatValue]];
                            
                            [[LyPriceDetailManager sharedInstance] addPriceDetail:priceDetail];
                        }
                    }
                    
                    arrPriceDetail = [[LyPriceDetailManager sharedInstance] priceDetailWithUserId:[LyCurrentUser curUser].userId license:_curLicense];
                    [self reloadData];
                    
                    [indicator stopAnimation];
                    [self.refreshControl endRefreshing];
                    
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case priceDetailHttpMethod_loadWithLicense: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if ([LyUtil validateArray:arrResult]) {
                     
                        for (NSDictionary *dicItem in arrResult) {
                            if (![LyUtil validateDictionary:dicItem]) {
                                continue;
                            }
                            
                            NSString *strId = [dicItem objectForKey:idKey];
                            NSString *strWeekdays = [dicItem objectForKey:weekdaysKey];
                            NSString *strTimeBucket = [dicItem objectForKey:timebucketKey];
                            NSString *strPrice = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:priceKey]];
                            NSString *strDriveLicense = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:driveLicenseKey]];
                            NSString *strSubject = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:subjectModeKey]];
                            
                            LyPriceDetail *priceDetail = [LyPriceDetail priceDetailWithPdId:strId
                                                                              pdLicenseType:[LyUtil driveLicenseFromString:strDriveLicense]
                                                                              pdSubjectMode:[strSubject integerValue]
                                                                                 pdMasterId:[LyCurrentUser curUser].userId
                                                                                  pdWeekday:strWeekdays
                                                                                     pdTime:strTimeBucket
                                                                                    pdPrice:[strPrice floatValue]];
                            
                            [[LyPriceDetailManager sharedInstance] addPriceDetail:priceDetail];
                        }
                    }
                    
                    arrPriceDetail = [[LyPriceDetailManager sharedInstance] priceDetailWithUserId:[LyCurrentUser curUser].userId license:_curLicense];
                    [self reloadData];
                    
                    [indicator stopAnimation];
                    [self.refreshControl endRefreshing];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case priceDetailHttpMethod_delete: {
            switch ([strCode integerValue]) {
                case 0: {
                    
                    [[LyPriceDetailManager sharedInstance] removePriceDetail:curPd];
                    arrPriceDetail = [[LyPriceDetailManager sharedInstance] priceDetailWithUserId:[LyCurrentUser curUser].userId license:_curLicense];
                    [self reloadData];
                    
                    
                    [indicator_oper stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"删除成功"] show];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
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



#pragma mark -LyAddPriceDetailViewControllerDelegate
- (NSInteger)obtainLicenseTypeByAddPriceDetailVC:(LyAddPriceDetailViewController *)aAddPriceDetailVC {
    return _curLicense;
}

- (void)onDoneByAddPriceDetailVC:(LyAddPriceDetailViewController *)aAddPriceDetailVC priceDetail:(LyPriceDetail *)priceDetail {
    [aAddPriceDetailVC.navigationController popViewControllerAnimated:YES];
    
    if (_curLicense != priceDetail.pdLicenseType) {
        arrPriceDetail = [[LyPriceDetailManager sharedInstance] priceDetailWithUserId:[LyCurrentUser curUser].userId
                                                                              license:_curLicense];
        [self reloadData];
    }
}




#pragma mark -LyDriveLicensePickerDelegate
- (void)onDriveLicensePickerCancel:(LyDriveLicensePicker *)picker {
    [picker hide];
}

- (void)onDriveLicensePickerDone:(LyDriveLicensePicker *)picker license:(LyLicenseType)license {
    [picker hide];
    
    if (_curLicense != license) {
        [self setCurLicense:license];
    }
}



#pragma mark -LyPriceDetailTableViewCellDelegate
- (void)onClickedBtnDeleteByPriceDetailTableViewCell:(LyPriceDetailTableViewCell *)aCell {
    
    curPd = aCell.priceDetail;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除单价"
                                                                   message:[[NSString alloc] initWithFormat:@"确定删除「%@」吗？", [curPd description]]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"删除"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self delete];
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
}




#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ( priceDetailTableViewMode_objectSecond == [tableView tag])
//    {
//        return pdcellHeight;
//    }
//    else if ( priceDetailTableViewMode_objectThird == [tableView tag])
//    {
//        return pdcellHeight;
//    }
    
    return pdcellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( priceDetailTableViewMode_objectSecond == [tableView tag]) {
        return pdHeaderTitleHeight;
    } else if ( priceDetailTableViewMode_objectThird == [tableView tag]) {
        return pdHeaderTitleHeight;
    }
    
    return 0.0f;
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( priceDetailTableViewMode_objectSecond == [tableView tag]) {
        return dicPriceDetailSecond.count;
    } else if ( priceDetailTableViewMode_objectThird == [tableView tag]) {
        return dicPriceDetailThird.count;
    }
    
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( priceDetailTableViewMode_objectSecond == [tableView tag]) {
        
//        NSArray *allKeys = [dicPriceDetailSecond allKeys];
        return [[dicPriceDetailSecond objectForKey:[arrWeekdaySecond objectAtIndex:section]] count];
    } else if ( priceDetailTableViewMode_objectThird == [tableView tag]) {
        
//        NSArray *allKeys = [dicPriceDetailThird allKeys];
        return [[dicPriceDetailThird objectForKey:[arrWeekdayThird objectAtIndex:section]] count];
    }
    
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( priceDetailTableViewMode_objectSecond == [tableView tag]) {
        LyPriceDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyPriceDetailObjectSecondTableViewCellReuseIdentifier forIndexPath:indexPath];
        
        if ( !cell) {
            cell = [[LyPriceDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyPriceDetailObjectSecondTableViewCellReuseIdentifier];
        }
        
        NSArray *arrPd = [dicPriceDetailSecond objectForKey:[arrWeekdaySecond objectAtIndex:indexPath.section]];
        LyPriceDetail *pd = [arrPd objectAtIndex:indexPath.row];
        [cell setPriceDetail:pd];
        [cell setEditing:self.editing];
        [cell setDelegate:self];
        
        return cell;
    }
    else if ( priceDetailTableViewMode_objectThird == [tableView tag])
    {
        LyPriceDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyPriceDetailObjectThirdTableViewCellReuseIdentifier forIndexPath:indexPath];
        
        if ( !cell) {
            cell = [[LyPriceDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyPriceDetailObjectThirdTableViewCellReuseIdentifier];
        }
        
        NSArray *arrPd = [dicPriceDetailThird objectForKey:[arrWeekdayThird objectAtIndex:indexPath.section]];
        LyPriceDetail *pd = [arrPd objectAtIndex:indexPath.row];
        [cell setPriceDetail:pd];
        [cell setEditing:self.editing];
        [cell setDelegate:self];
        
        return cell;
    }
    
//    if ( priceDetailTableViewMode_objectSecond == [tableView tag]) {
//        LyPriceDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyPriceDetailObjectSecondTableViewCellReuseIdentifier forIndexPath:indexPath];
//        
//        if ( !cell) {
//            cell = [[LyPriceDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyPriceDetailObjectSecondTableViewCellReuseIdentifier];
//        }
//        [cell setDelegate:self];
//
//        NSArray *allKeysWeekdays = [dicPriceDetailSecond allKeys];
//        NSDictionary *dicWeekdays = [dicPriceDetailSecond objectForKey:[allKeysWeekdays objectAtIndex:indexPath.section]];
//        NSArray *allKeysTimeBucket = [dicWeekdays allKeys];
//        LyPriceDetail *pd = [dicWeekdays objectForKey:[allKeysTimeBucket objectAtIndex:indexPath.row]];
////        [cell setCellInfo:[allKeysTimeBucket objectAtIndex:indexPath.row] andPrice:[dicWeekdays objectForKey:[allKeysTimeBucket objectAtIndex:indexPath.row]]];
//        [cell setPriceDetail:pd];
//        [cell setEditing:self.editing];
//        
//        return cell;
//    }
//    else if ( priceDetailTableViewMode_objectThird == [tableView tag])
//    {
//        LyPriceDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyPriceDetailObjectThirdTableViewCellReuseIdentifier forIndexPath:indexPath];
//        
//        if ( !cell) {
//            cell = [[LyPriceDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyPriceDetailObjectThirdTableViewCellReuseIdentifier];
//        }
//        [cell setDelegate:self];
//        
//        NSArray *allKeysWeekdays = [dicPriceDetailThird allKeys];
//        NSDictionary *dicWeekdays = [dicPriceDetailThird objectForKey:[allKeysWeekdays objectAtIndex:indexPath.section]];
//        NSArray *allKeysTimeBucket = [dicWeekdays allKeys];
//        LyPriceDetail *pd = [dicWeekdays objectForKey:[allKeysTimeBucket objectAtIndex:indexPath.row]];
////        [cell setCellInfo:[allKeysTimeBucket objectAtIndex:indexPath.row] andPrice:[dicWeekdays objectForKey:[allKeysTimeBucket objectAtIndex:indexPath.row]]];
//        [cell setPriceDetail:pd];
//        [cell setEditing:self.editing];
//        
//        return cell;
//    }
    
    return nil;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ( priceDetailTableViewMode_objectSecond == [tableView tag]) {
        
        return [LyUtil weekdaySpanChineseStringFromString:[arrWeekdaySecond objectAtIndex:section]];
    } else if ( priceDetailTableViewMode_objectThird == [tableView tag]) {
        
        return [LyUtil weekdaySpanChineseStringFromString:[arrWeekdayThird objectAtIndex:section]];
    }
    
    
    return nil;
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return nil;
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
