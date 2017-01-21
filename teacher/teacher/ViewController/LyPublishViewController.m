//
//  LyPublishViewController.m
//  teacher
//
//  Created by Junes on 16/7/30.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyPublishViewController.h"
#import "LyFragmentCollectionViewCell.h"
#import "LyTrainClassTableViewCell.h"
#import "LyEnvPicCollectionViewCell.h"
#import "LyTableViewFooterView.h"
#import "LyToolBar.h"

#import "LyTrainClass.h"
#import "LyPhotoAsset.h"


#import "LyIndicator.h"
#import "LyRemindView.h"
#import "ZLPhoto.h"
#import "SDPhotoBrowser.h"

#import "LyCurrentUser.h"
#import "LyTrainClassManager.h"


#import "UIViewController+RESideMenu.h"
#import "UITextView+placeholder.h"

#import "LyUtil.h"


#import "teacher-Swift.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "LyAddTrainClassViewController.h"
#import "LyTrainClassDetailTableViewController.h"



CGFloat const cvFragsHeight = 50.0f;
//int const fragsCount = 3;

#define svMainHeight                        (SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-cvFragsHeight-TABBAR_HEIGHT)


//培训课程
CGFloat const pBtnAddTrainClassHeight = 50.0f;

//简介
//计时培训view
CGFloat const pViewTeachByTimeHeight = 50.0f;
CGFloat const pLbTitleTbtWidth = 90.0f;
CGFloat const pBtnTbtWidth = 100.0f;
CGFloat const pBtnTbtHeight = 40.0f;
//接送范围
CGFloat const pViewPickRangeHeight = 150.0f;
CGFloat const pTvPickRangeHeight = 100.0f;
//用户简介
CGFloat const pViewSynopsisHeight = 350.0f;
CGFloat const pTvSynopsisHeight = 300.0f;

CGFloat const pLbTitleWidth = 70.0f;
CGFloat const pLbTitleHeight = 40.0f;
#define pLbTitleFont                LyFont(16)
CGFloat const pBtnItemWidth = 60;
CGFloat const pBtnItemHeight = pLbTitleHeight;
#define pBtnItemTitleFont           LyFont(14)

#define pTvItemFont                 LyFont(14)




//教学环境
//CGFloat const cvEnvrionmentItemMargin = 2.0f;
CGFloat const cvEnvrionmentSingleRowCount = 3.0f;
#define cvEnvrionmentItemWidth              ((SCREEN_WIDTH-epccellMargin*(cvEnvrionmentSingleRowCount+1))/cvEnvrionmentSingleRowCount)
#define cvEnvrionmentItemHeight             cvEnvrionmentItemWidth



typedef NS_ENUM(NSInteger, LyPublishBarButtonItemTag) {
    publishBarButtonItemTag_leftMenu = 10,
    publishBarButtonItemTag_msg,
    publishBarButtonItemTag_rightMenu
};


typedef NS_ENUM(NSInteger, LyPublishButtonMode)
{
    publishButtonMode_addTrainClass = 20,
    publishButtonMode_tbtAgree,
    publishButtonMode_pickRange,
    publishButtonMode_pickRangeCancel,
    publishButtonMode_synopsis,
    publishButtonMode_synopsisCancel,
    publishButtonMode_envEdit,
    publishButtonMode_envCancel
};

typedef NS_ENUM(NSInteger, LyPublishAlertViewMode)
{
    publishAlertViewMode_album = 30,
    publishAlertViewMode_deleteTrainCLass,
    publishAlertViewMode_closeTimeTeach,
    publishAlertViewMode_abandonEditPickRange,
    publishAlertViewMode_abandonEditSynopsis,
    publishAlertViewMode_deleteEnv,
};


typedef NS_ENUM(NSInteger, LyPublishTextViewMode)
{
    publishTextViewMode_pickRange = 40,
    publishTextViewMode_synspsis
};


typedef NS_ENUM(NSInteger, LyPublishRefreshControlMode)
{
    publishRefreshControlMode_tc = 50,
    publishRefreshControlMode_syn,
    publishRefreshControlMode_env
};

typedef NS_ENUM(NSInteger, LyPublishHttpMethod)
{
    publishHttpMethod_load = 100,
    publishHttpMethod_loadTrainClass,
    publishHttpMethod_loadSynopsis,
    publishHttpMethod_loadTeachEnvironment,
    
    publishHttpMethod_deleteTrainClass,
    publishHttpMethod_updateTimeTeach,
    publishHttpMethod_updatePickRange,
    publishHttpMethod_updateSynopsis,
    publishHttpMethod_uploadEnv,
    publishHttpMethod_deleteEnv
    
};




@interface LyPublishViewController ()<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, LyEnvPicCollectionViewCellDelegate, LyTrainClassTableViewCellDelegate, AddTrainClassDelegate, LyHttpRequestDelegate, ZLPhotoPickerBrowserViewControllerDelegate, SDPhotoBrowserDelegate, LyTrainClassDetailTableViewControllerDelegate>
{
    UICollectionView                *cvFrags;
    UIScrollView                    *svMain;
    BOOL                            flagClickCvFrags;
    
    BOOL                            flagLoad;
    BOOL                            flagLoadTrainClass;
    BOOL                            flagLoadSynopsis;
    BOOL                            flagLoadTeachEnvironment;
    
    //培训课程
    ////培训课程
    UITableView                     *tvTrainClass;
    UIButton                        *btnAddTrainClass;
    UIRefreshControl                *refresherTC;
    
    //简介
    UIScrollView                    *svSynopsis;
    UIRefreshControl                *refresherSyn;
    //简介-订时培训
    UIView                          *viewTeachByTime;
    UIButton                        *btnIsSupport_teachByTime;
    //简介-接送范围
    UIView                          *viewPickRange;
    UITextView                      *tvPickRange;
    UIButton                        *btnPickRange;
    UIButton                        *btnPickRangeCancel;
    //简介-简介
    UIView                          *viewSynopsis;
    UITextView                      *tvSynopsis;
    UIButton                        *btnSynopsis;
    UIButton                        *btnSynopsisCancel;
    
    
    //教学环境
//    UIView                          *viewEnvrionment;
    UIScrollView                    *svEnvrioment;
    UICollectionView                *cvEnvrionment;
    UIButton                        *btnEnvEdit;
    UIButton                        *btnEnvCancel;
    UIRefreshControl                *refresherEnv;
    
    
    
    NSArray                         *arrFrags;
    NSArray                         *arrTrainClass;
    NSMutableDictionary             *dicEnv_add;
    NSMutableDictionary             *dicEnv;
    
    
    BOOL                            curTimeFlag;
    NSString                        *curPickRange;
    NSString                        *curSynopsis;
    
    NSIndexPath                     *lastIp_tc;
    UIView                          *viewError;
    
    
    LyIndicator                     *indicator;
    BOOL                            bHttpFlag;
    LyPublishHttpMethod             curHttpMethod;
    
}
@end

@implementation LyPublishViewController

static NSString *const publishCvFragsCellReuseIdentifier = @"publishCvFragsCellReuseIdentifier";
static NSString *const publishTvTrainClassCellReuseIdentifier = @"publishTvTrainClassCellReuseIdentifier";
static NSString *const publishCvEnvrionmentCellReuseIdentifier = @"publishCvEnvrionmentCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}


- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    if (!flagLoad) {
        [self load];
    }
    
    [self addObserverForNotificationFromUIKeyboard];
}


- (void)initSubviews
{
    //navigationBar
    self.title = @"发布";
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    UIBarButtonItem *bbiLeftMenu = [LyUtil barButtonItem:publishBarButtonItemTag_leftMenu
                                               imageName:@"navigationBar_left"
                                                  target:self
                                                  action:@selector(presentLeftMenuViewController:)];
    
    UIBarButtonItem *bbiMsg = [LyUtil barButtonItem:publishBarButtonItemTag_msg
                                          imageName:@"navigationBar_msg"
                                             target:self
                                             action:@selector(targetForBarButtonItem:)];
    UIBarButtonItem *bbiRightMenu = [LyUtil barButtonItem:publishBarButtonItemTag_rightMenu
                                                imageName:@"navigationBar_right"
                                                   target:self
                                                   action:@selector(presentRightMenuViewController:)];
    
    
    self.navigationItem.leftBarButtonItem = bbiLeftMenu;
    self.navigationItem.rightBarButtonItems = @[bbiRightMenu, bbiMsg];
    
    //tabbar
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发布"
                                                    image:[LyUtil imageForImageName:@"publish_n" needCache:NO]
                                            selectedImage:[LyUtil imageForImageName:@"publish_h" needCache:NO]];
    
    
    //
    UICollectionViewFlowLayout *cvFragsFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [cvFragsFlowLayout setMinimumLineSpacing:0];
    [cvFragsFlowLayout setMinimumInteritemSpacing:0];
    cvFrags = [[UICollectionView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, cvFragsHeight)
                                 collectionViewLayout:cvFragsFlowLayout];
    [cvFrags setDelegate:self];
    [cvFrags setDataSource:self];
    [cvFrags setBackgroundColor:[UIColor whiteColor]];
    [cvFrags registerClass:[LyFragmentCollectionViewCell class] forCellWithReuseIdentifier:publishCvFragsCellReuseIdentifier];
    
    switch ([LyCurrentUser curUser].userType) {
        case LyUserType_normal: {
            break;
        }
        case LyUserType_coach: {
            arrFrags = @[
                         @"培训课程",
                         @"教练简介",
                         @"教学环境"
                         ];
            break;
        }
        case LyUserType_school: {
            arrFrags = @[
                         @"培训课程",
                         @"驾校简介",
                         @"教学环境"
                         ];
            break;
        }
        case LyUserType_guider: {
            arrFrags = @[
                         @"培训课程",
                         @"指导员简介",
                         @"自学用车"
                         ];
            break;
        }
    }
    
    [self.view addSubview:cvFrags];
    
    
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake(0, cvFrags.ly_y+CGRectGetHeight(cvFrags.frame), SCREEN_WIDTH, svMainHeight)];
    [svMain setDelegate:self];
    [svMain setShowsVerticalScrollIndicator:NO];
    [svMain setShowsHorizontalScrollIndicator:NO];
    [svMain setPagingEnabled:YES];
    [self.view addSubview:svMain];
    
    
    
    //培训课程
    tvTrainClass = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, svMainHeight)
                                                style:UITableViewStylePlain];
    [tvTrainClass setDelegate:self];
    [tvTrainClass setDataSource:self];
    [tvTrainClass setScrollsToTop:NO];
    [tvTrainClass setShowsVerticalScrollIndicator:NO];
    [tvTrainClass registerClass:[LyTrainClassTableViewCell class] forCellReuseIdentifier:publishTvTrainClassCellReuseIdentifier];
    [svMain addSubview:tvTrainClass];
    
    refresherTC = [LyUtil refreshControlWithTitle:nil
                                           target:self
                                           action:@selector(refresh:)];
    [refresherTC setTag:publishRefreshControlMode_tc];
    [tvTrainClass addSubview:refresherTC];
    
    
    if ([LyCurrentUser curUser].isMaster) {
        btnAddTrainClass = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, pBtnAddTrainClassHeight)];
        [btnAddTrainClass setTag:publishButtonMode_addTrainClass];
        [btnAddTrainClass setTitle:@"+添加培训课程" forState:UIControlStateNormal];
        [btnAddTrainClass setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
        [[btnAddTrainClass titleLabel] setFont:LyFont(14)];
        [btnAddTrainClass addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [tvTrainClass setTableFooterView:btnAddTrainClass];
    } else {
        [tvTrainClass setTableFooterView:[UIView new]];
    }
    
    
    //简介
    svSynopsis = [[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, svMainHeight)];
    [svSynopsis setBackgroundColor:LyWhiteLightgrayColor];
    [svSynopsis setDelegate:self];
    [svSynopsis setShowsVerticalScrollIndicator:NO];
    [svMain addSubview:svSynopsis];
    
    refresherSyn = [LyUtil refreshControlWithTitle:nil target:self action:@selector(refresh:)];
    [refresherSyn setTag:publishRefreshControlMode_syn];
    [svSynopsis addSubview:refresherSyn];
    
    if (LyUserType_guider == [LyCurrentUser curUser].userType) {
        //指导员不需要“计时培训”和“接送范围”
        viewTeachByTime = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        viewPickRange = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    } else {
        //计时培训
        viewTeachByTime = [[UIView alloc] initWithFrame:CGRectMake(0, verticalSpace*2, SCREEN_WIDTH, pViewTeachByTimeHeight)];
        [viewTeachByTime setBackgroundColor:[UIColor whiteColor]];
        //计时培训-标题
        UILabel *lbTitle_teachByTime = [self lbTitleWithText:@"计时培训"];
        [lbTitle_teachByTime setFrame:CGRectMake(horizontalSpace, pViewTeachByTimeHeight/2.0f-pLbTitleHeight/2.0f, pLbTitleWidth, pLbTitleHeight)];
        //计时培训-按钮
        btnIsSupport_teachByTime = [[UIButton alloc] initWithFrame:CGRectMake(lbTitle_teachByTime.frame.origin.x+CGRectGetWidth(lbTitle_teachByTime.frame)*1.5f, pViewTeachByTimeHeight/2.0f-pBtnTbtHeight/2.0f, pBtnTbtWidth, pBtnTbtHeight)];
        [btnIsSupport_teachByTime setTag:publishButtonMode_tbtAgree];
        [btnIsSupport_teachByTime setBackgroundImage:[LyUtil imageForImageName:@"btnTbtIsSupport_n" needCache:NO] forState:UIControlStateNormal];
        [btnIsSupport_teachByTime setBackgroundImage:[LyUtil imageForImageName:@"btnTbtIsSupport_h" needCache:NO] forState:UIControlStateSelected];
        [btnIsSupport_teachByTime addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [viewTeachByTime addSubview:lbTitle_teachByTime];
        [viewTeachByTime addSubview:btnIsSupport_teachByTime];
        
        //接送范围
        viewPickRange = [[UIView alloc] initWithFrame:CGRectMake(0, viewTeachByTime.ly_y+CGRectGetHeight(viewTeachByTime.frame)+verticalSpace*2, SCREEN_WIDTH, pViewPickRangeHeight)];
        [viewPickRange setBackgroundColor:[UIColor whiteColor]];
        //接送范围-标题
        UILabel *lbTitle_pickRange = [self lbTitleWithText:@"接送范围"];
        //接送范围-编辑按钮
        btnPickRange = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-pBtnItemWidth, 0, pBtnItemWidth, pBtnItemHeight)];
        [btnPickRange setTag:publishButtonMode_pickRange];
        [btnPickRange.titleLabel setFont:pBtnItemTitleFont];
        [btnPickRange setTitle:@"编辑" forState:UIControlStateNormal];
        [btnPickRange setTitle:@"保存" forState:UIControlStateSelected];
        [btnPickRange setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
        [btnPickRange setTitleColor:Ly517ThemeColor forState:UIControlStateSelected];
        [btnPickRange addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
        //接送范围-取消按钮
        btnPickRangeCancel = [[UIButton alloc] initWithFrame:CGRectMake(btnPickRange.frame.origin.x-horizontalSpace-pBtnItemWidth, 0, pBtnItemWidth, pBtnItemHeight)];
        [btnPickRangeCancel setTag:publishButtonMode_pickRangeCancel];
        [btnPickRangeCancel.titleLabel setFont:pBtnItemTitleFont];
        [btnPickRangeCancel setTitle:@"取消" forState:UIControlStateNormal];
        [btnPickRangeCancel setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
        [btnPickRangeCancel addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
        //接送范围-文本框
        tvPickRange = [[UITextView alloc] initWithFrame:CGRectMake(horizontalSpace, lbTitle_pickRange.ly_y+CGRectGetHeight(lbTitle_pickRange.frame)+verticalSpace, SCREEN_WIDTH-horizontalSpace*2, pTvPickRangeHeight)];
        [tvPickRange setTag:publishTextViewMode_pickRange];
        [tvPickRange setFont:pTvItemFont];
        [tvPickRange setTextColor:LyBlackColor];
        [tvPickRange setTextAlignment:NSTextAlignmentLeft];
        [tvPickRange setDelegate:self];
        [[tvPickRange layer] setCornerRadius:btnCornerRadius];
        [[tvPickRange layer] setBorderWidth:1.0f];
        [[tvPickRange layer] setBorderColor:[LyWhiteLightgrayColor CGColor]];
        [tvPickRange setPlaceholder:@"还没有接送范围"];
        [tvPickRange setInputAccessoryView:[LyToolBar toolBarWithInputControl:tvPickRange]];
        
        [viewPickRange addSubview:lbTitle_pickRange];
        [viewPickRange addSubview:btnPickRange];
        [viewPickRange addSubview:btnPickRangeCancel];
        [viewPickRange addSubview:tvPickRange];
    }
    
    //简介
    viewSynopsis = [[UIView alloc] initWithFrame:CGRectMake(0, viewPickRange.ly_y+CGRectGetHeight(viewPickRange.frame)+verticalSpace*2, SCREEN_WIDTH, pViewSynopsisHeight)];
    [viewSynopsis setBackgroundColor:[UIColor whiteColor]];
    //简介-标题
    UILabel *lbTitle_synopsis = [self lbTitleWithText:@"简介"];
    //简介-编辑按钮
    btnSynopsis = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-pBtnItemWidth, 0, pBtnItemWidth, pBtnItemHeight)];
    [btnSynopsis setTag:publishButtonMode_synopsis];
    [btnSynopsis.titleLabel setFont:LyFont(14)];
    [btnSynopsis setTitle:@"编辑" forState:UIControlStateNormal];
    [btnSynopsis setTitle:@"保存" forState:UIControlStateSelected];
    [btnSynopsis setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnSynopsis setTitleColor:Ly517ThemeColor forState:UIControlStateSelected];
    [btnSynopsis addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    //简介-取消按钮
    btnSynopsisCancel = [[UIButton alloc] initWithFrame:CGRectMake(btnSynopsis.frame.origin.x-horizontalSpace-pBtnItemWidth, 0, pBtnItemWidth, pBtnItemHeight)];
    [btnSynopsisCancel setTag:publishButtonMode_synopsisCancel];
    [btnSynopsisCancel.titleLabel setFont:LyFont(14)];
    [btnSynopsisCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnSynopsisCancel setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnSynopsisCancel addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    //简介-文本框
    tvSynopsis = [[UITextView alloc] initWithFrame:CGRectMake(horizontalSpace, lbTitle_synopsis.ly_y+CGRectGetHeight(lbTitle_synopsis.frame)+verticalSpace, SCREEN_WIDTH-horizontalSpace*2, pTvSynopsisHeight)];
    [tvSynopsis setTag:publishTextViewMode_synspsis];
    [tvSynopsis setFont:pTvItemFont];
    [tvSynopsis setTextColor:LyBlackColor];
    [tvSynopsis setTextAlignment:NSTextAlignmentLeft];
    [tvSynopsis setDelegate:self];
    [[tvSynopsis layer] setCornerRadius:btnCornerRadius];
    [[tvSynopsis layer] setBorderWidth:1.0f];
    [[tvSynopsis layer] setBorderColor:[LyWhiteLightgrayColor CGColor]];
    [tvSynopsis setPlaceholder:@"还没有任何简介"];
    [tvSynopsis setInputAccessoryView:[LyToolBar toolBarWithInputControl:tvSynopsis]];
    
    [viewSynopsis addSubview:lbTitle_synopsis];
    [viewSynopsis addSubview:btnSynopsis];
    [viewSynopsis addSubview:btnSynopsisCancel];
    [viewSynopsis addSubview:tvSynopsis];
    
    [svSynopsis addSubview:viewTeachByTime];
    [svSynopsis addSubview:viewPickRange];
    [svSynopsis addSubview:viewSynopsis];
    
    
    CGFloat fHeightSvSynposis = viewSynopsis.ly_y + CGRectGetHeight(viewSynopsis.frame) + 50.0f;
    if (fHeightSvSynposis <= CGRectGetHeight(svSynopsis.frame)) {
        fHeightSvSynposis = CGRectGetHeight(svSynopsis.frame) * 1.05f;
    }
    [svSynopsis setContentSize:CGSizeMake(SCREEN_WIDTH, fHeightSvSynposis)];
    
    
    //教学环境
    svEnvrioment = [[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, svMainHeight)];
    [svEnvrioment setShowsVerticalScrollIndicator:NO];
    
    refresherEnv = [LyUtil refreshControlWithTitle:nil target:self action:@selector(refresh:)];
    [refresherEnv setTag:publishRefreshControlMode_env];
    [svEnvrioment addSubview:refresherEnv];
    
    UICollectionViewFlowLayout *cvEnvFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [cvEnvFlowLayout setMinimumLineSpacing:epccellMargin];
    [cvEnvFlowLayout setMinimumInteritemSpacing:epccellMargin];
    [cvEnvFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    cvEnvrionment = [[UICollectionView alloc] initWithFrame:CGRectMake(0, verticalSpace, SCREEN_WIDTH, SCREEN_WIDTH)
                                       collectionViewLayout:cvEnvFlowLayout];
    [cvEnvrionment setDelegate:self];
    [cvEnvrionment setDataSource:self];
    [cvEnvrionment setBackgroundColor:[UIColor whiteColor]];
    [cvEnvrionment setShowsVerticalScrollIndicator:NO];
    [cvEnvrionment setScrollEnabled:NO];
    [cvEnvrionment setScrollsToTop:NO];
    [cvEnvrionment registerClass:[LyEnvPicCollectionViewCell class] forCellWithReuseIdentifier:publishCvEnvrionmentCellReuseIdentifier];

    
    
    
    btnEnvEdit = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-pBtnItemWidth, cvEnvrionment.ly_y+CGRectGetHeight(cvEnvrionment.frame), pBtnItemWidth, pBtnItemHeight)];
    [btnEnvEdit setTag:publishButtonMode_envEdit];
    [btnEnvEdit.titleLabel setFont:LyFont(16)];
    [btnEnvEdit setTitle:@"编辑" forState:UIControlStateNormal];
    [btnEnvEdit setTitle:@"删除" forState:UIControlStateSelected];
    [btnEnvEdit setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnEnvEdit setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btnEnvEdit addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    btnEnvCancel = [[UIButton alloc] initWithFrame:CGRectMake(btnEnvEdit.frame.origin.x-horizontalSpace-pBtnItemWidth, btnEnvEdit.ly_y, pBtnItemWidth, pBtnItemHeight)];
    [btnEnvCancel setTag:publishButtonMode_envCancel];
    [btnEnvCancel.titleLabel setFont:LyFont(16)];
    [btnEnvCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnEnvCancel setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnEnvCancel addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [svEnvrioment addSubview:cvEnvrionment];
    [svEnvrioment addSubview:btnEnvEdit];
    [svEnvrioment addSubview:btnEnvCancel];
    
    CGFloat fHeightSvEnvrioment = btnEnvEdit.ly_y + CGRectGetHeight(btnEnvEdit.frame) + 50.0f;
    if (fHeightSvEnvrioment <= CGRectGetHeight(svEnvrioment.frame)) {
        fHeightSvEnvrioment = CGRectGetHeight(svEnvrioment.frame) * 1.05f;
    }
    [svEnvrioment setContentSize:CGSizeMake(SCREEN_WIDTH, fHeightSvEnvrioment)];
    
    
    [svMain addSubview:svEnvrioment];
    
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH * 3, 0)];
    
    
    
    //默认选择培训课程
    [cvFrags selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionRight];
    [self collectionView:cvFrags didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    flagClickCvFrags = NO;
    
    [btnIsSupport_teachByTime setSelected:YES];
    
    [tvPickRange setEditable:NO];
    [tvSynopsis setEditable:NO];
    dicEnv = [NSMutableDictionary dictionary];

    [btnPickRangeCancel setHidden:YES];
    [btnSynopsisCancel setHidden:YES];
    [btnEnvCancel setHidden:YES];
    
}


- (UILabel *)lbTitleWithText:(NSString *)text {
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, pLbTitleWidth, pLbTitleHeight)];
    [lbTitle setFont:LyFont(16)];
    [lbTitle setText:text];
    [lbTitle setTextColor:[UIColor blackColor]];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    
    return lbTitle;
}


- (void)reloadViewData
{
    [self reloadTrainClass];
    
    [self reloadSynopsis];
    
    [self reloadEnvrionment];
}


- (void)reloadTrainClass {
    [tvTrainClass reloadData];
}

- (void)reloadSynopsis
{
    [tvSynopsis setText:curSynopsis];
    [tvSynopsis updatePlaceholder];
    
    if (LyUserType_guider != [LyCurrentUser curUser].userType) {
        [btnIsSupport_teachByTime setSelected:curTimeFlag];
        [[LyCurrentUser curUser] setTimeFlag:curTimeFlag];
        
        [tvPickRange setText:curPickRange];
        [tvPickRange updatePlaceholder];
    }
    
}

- (void)reloadEnvrionment {
    [cvEnvrionment reloadData];
}



- (void)showViewError
{
    if (!viewError)
    {
        viewError = [[UIView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-TABBAR_HEIGHT)];
        
        UILabel *lbError = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LyLbErrorHeight)];
        [lbError setFont:LyNullItemTitleFont];
        [lbError setTextColor:[UIColor lightGrayColor]];
        [lbError setTextAlignment:NSTextAlignmentCenter];
        [lbError setText:@"加载失败，点击再次加载"];
        
        [viewError addSubview:lbError];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForTagGestureFromViewError)];
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        
        
        [viewError setUserInteractionEnabled:YES];
        [lbError setUserInteractionEnabled:YES];
        [viewError addGestureRecognizer:tap];
    }
    
    [self.view addSubview:viewError];
}


- (void)removeViewError {
    [viewError removeFromSuperview];
    viewError = nil;
}



- (void)dealloc {
    [self removeObserverFroNotificaiontFromUIKeyBoard];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    LyPublishBarButtonItemTag bbiTag = bbi.tag;
    switch (bbiTag) {
        case publishBarButtonItemTag_leftMenu: {
            //nothing yet
            break;
        }
        case publishBarButtonItemTag_msg: {
            LyMsgCenterTableViewController *msgCenter = [[LyMsgCenterTableViewController alloc] init];
            msgCenter.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:msgCenter animated:YES];
            break;
        }
        case publishBarButtonItemTag_rightMenu: {
            //nothing yet
            break;
        }
    }
}


- (void)targetForTagGestureFromViewError {
    [self load];
}


- (void)addObserverForNotificationFromUIKeyboard {
    
    if ([self respondsToSelector:@selector(targetForNotificationFromUIKeyboardWillShowNotification:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(targetForNotificationFromUIKeyboardWillShowNotification:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
    }
    
    if ([self respondsToSelector:@selector(targetForNotificationFromUIKeyboardWillHideNotification:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(targetForNotificationFromUIKeyboardWillHideNotification:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
}

- (void)removeObserverFroNotificaiontFromUIKeyBoard {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



#pragma mark -UIKeyboardWillShowNotification
- (void)targetForNotificationFromUIKeyboardWillShowNotification:(NSNotification *)notifi {
    
    CGFloat fHeightKeyboard = [[[notifi userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGFloat y = 0;
    
    if ([tvPickRange isFirstResponder]) {
        y = viewPickRange.ly_y+CGRectGetHeight(viewPickRange.frame)-(SCREEN_HEIGHT-fHeightKeyboard-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-cvFragsHeight);
    } else if ([tvSynopsis isFirstResponder]) {
        y = viewSynopsis.ly_y+CGRectGetHeight(viewSynopsis.frame)/2.0f-verticalSpace*2-(SCREEN_HEIGHT-fHeightKeyboard-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-cvFragsHeight);
    }
    
    if (y > 0) {
        [svSynopsis setContentOffset:CGPointMake(0, y)];
    }
}


#pragma mark -UIKeyboardWillHideNotification
- (void)targetForNotificationFromUIKeyboardWillHideNotification:(NSNotification *)notifi {
    if (svSynopsis.contentOffset.y > svSynopsis.contentSize.height-CGRectGetHeight(svSynopsis.frame)) {
        [svSynopsis setContentOffset:CGPointMake(0, svSynopsis.contentSize.height-CGRectGetHeight(svSynopsis.frame))];
    }
}



- (void)targetForButton:(UIButton *)button
{
    switch (button.tag) {
        case publishButtonMode_addTrainClass: {
            LyAddTrainClassViewController *atc = [[LyAddTrainClassViewController alloc] init];
            [atc setDelegate:self];
            [atc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:atc animated:YES];
            break;
        }
        case publishButtonMode_tbtAgree: {
            
            if ([tvPickRange isEditable]) {
                //直接放弃对简介的编辑
                [self targetForButton:btnPickRangeCancel];
                [NSThread sleepForTimeInterval:0.1f];
                
            } else if ([tvSynopsis isEditable]) {
                //直接放弃对接送范围的编辑
                [self targetForButton:btnSynopsisCancel];
                [NSThread sleepForTimeInterval:0.1f];
            }
            
            
            if (btnIsSupport_teachByTime.isSelected) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"计时培训"
                                                                               message:@"你确认从此以后都不支持计时培训了吗？"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"不支持了"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [self updateTimeTeach:@"0"];
                                                        }]];
                [self presentViewController:alert animated:YES completion:nil];
                
            } else {
                [self updateTimeTeach:@"1"];
            }
            break;
        }
        case publishButtonMode_pickRange: {
            
            //直接放弃对简介的编辑
            if ([tvSynopsis isEditable]) {
                [self targetForButton:btnSynopsisCancel];
                [NSThread sleepForTimeInterval:0.1f];
            }
            
            if (!btnPickRange.isSelected) {
                [btnPickRange setSelected:YES];
                [btnPickRangeCancel setHidden:NO];
                [tvPickRange setEditable:YES];
                [tvPickRange becomeFirstResponder];
            } else {
                [tvPickRange resignFirstResponder];
                if ([curPickRange isEqualToString:tvPickRange.text]) {
                    
                    [btnPickRange setSelected:NO];
                    [btnPickRangeCancel setHidden:YES];
                    [tvPickRange setEditable:YES];
                } else {
                    [self updatePickRange];
                }
            }
            break;
        }
        case publishButtonMode_pickRangeCancel: {
            [tvPickRange resignFirstResponder];
            [tvPickRange setEditable:NO];
            [btnPickRange setSelected:NO];
            [btnPickRangeCancel setHidden:YES];
            break;
        }
        case publishButtonMode_synopsis: {
            
            //直接放弃对接送范围的编辑
            if ([tvPickRange isEditable]) {
                [self targetForButton:btnPickRangeCancel];
                [NSThread sleepForTimeInterval:0.1f];
            }
            
            if (!btnSynopsis.isSelected) {
                [btnSynopsis setSelected:YES];
                [btnSynopsisCancel setHidden:NO];
                [tvSynopsis setEditable:YES];
                [tvSynopsis becomeFirstResponder];
            } else {
                [tvSynopsis resignFirstResponder];
                if ([curSynopsis isEqualToString:tvSynopsis.text]) {
                    
                    [btnSynopsis setSelected:NO];
                    [btnSynopsisCancel setHidden:YES];
                    [tvSynopsis setEditable:NO];
                } else {
                    [self updateSynopsis];
                }
            }
            break;
        }
        case publishButtonMode_synopsisCancel: {
            [tvSynopsis resignFirstResponder];
            [btnSynopsis setSelected:NO];
            [btnSynopsisCancel setHidden:YES];
            [tvSynopsis setEditable:NO];
            
            [tvSynopsis setText:curSynopsis];
            break;
        }
        case publishButtonMode_envEdit: {
            if (btnEnvEdit.isSelected) {
                //删除
                NSMutableArray *arr = [NSMutableArray array];
                
                BOOL needDelete = NO;
                for (LyEnvPicCollectionViewCell *cell in [cvEnvrionment visibleCells]) {
                    if (cell.isChoosed) {
                        [arr addObject:@([cvEnvrionment indexPathForCell:cell].row+1)];
                        needDelete = YES;
                    }
                }
                
                if (!needDelete) {
                    [btnEnvEdit setSelected:NO];
                    [btnEnvCancel setHidden:YES];
                    [cvEnvrionment reloadData];
                    return;
                }
                
                NSMutableString *strMessage = [[NSMutableString alloc] initWithString:@"你确定要删除第「"];
                for (NSNumber *num in arr) {
                    [strMessage appendFormat:@"%@、", num];
                }
                [strMessage deleteCharactersInRange:NSMakeRange(strMessage.length-1, 1)];
                [strMessage appendFormat:@"」张图片吗？"];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除教学环境"
                                                                               message:strMessage
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"删除"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [self deleteEnviroment];
                                                        }]];
                [self presentViewController:alert animated:YES completion:nil];
                
            } else {
                //编辑
                [btnEnvEdit setSelected:YES];
                [btnEnvCancel setHidden:NO];
                [cvEnvrionment reloadData];
            }
            break;
        }
        case publishButtonMode_envCancel: {
            [btnEnvEdit setSelected:NO];
            [btnEnvCancel setHidden:YES];
            
            [cvEnvrionment reloadData];
            break;
        }
        default: {
            break;
        }
    }
}



- (void)refresh:(UIRefreshControl *)rc {
    if (publishRefreshControlMode_tc == rc.tag) {
        if (!flagLoad) {
            [self load];
        } else {
            [self loadTrainClass];
        }
    } else if (publishRefreshControlMode_syn == rc.tag) {
        if (!flagLoad) {
            [self load];
        } else {
            [self loadSynopsis];
        }
    } else if (publishRefreshControlMode_env == rc.tag) {
        if (!flagLoad) {
            [self load];
        } else {
            [self loadEnvrionment];
        }
    }
}



#pragma mark -读取“发布”界面信息
- (void)load {
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:LyIndicatorTitle_load];
    } else {
        [indicator setTitle:LyIndicatorTitle_load];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:publishHttpMethod_load];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:getPublishInfo_url
                                 body:@{
                                       userTypeKey:[[LyCurrentUser curUser] userTypeByString],
                                       userIdKey:[LyCurrentUser curUser].userId,
                                       sessionIdKey:[LyUtil httpSessionId]
                                       }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


#pragma mark -读取培训课程
- (void)loadTrainClass {
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:LyIndicatorTitle_load];
    } else {
        [indicator setTitle:LyIndicatorTitle_load];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:publishHttpMethod_loadTrainClass];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:getTrainClass_url
                                 body:@{
                                       userTypeKey:[[LyCurrentUser curUser] userTypeByString],
                                       userIdKey:[LyCurrentUser curUser].userId,
                                       sessionIdKey:[LyUtil httpSessionId]
                                       }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


#pragma mark -读取简介
- (void)loadSynopsis {
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:LyIndicatorTitle_load];
    } else {
        [indicator setTitle:LyIndicatorTitle_load];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:publishHttpMethod_loadSynopsis];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:getSynopsis_url
                                 body:@{
                                        userTypeKey:[[LyCurrentUser curUser] userTypeByString],
                                        userIdKey:[LyCurrentUser curUser].userId,
                                        sessionIdKey:[LyUtil httpSessionId]
                                        }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


#pragma mark -读取图片（教学环境）
- (void)loadEnvrionment {
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:LyIndicatorTitle_load];
    }
    else {
        [indicator setTitle:LyIndicatorTitle_load];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:publishHttpMethod_loadTeachEnvironment];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:getTeachEnvironment_url
                                 body:@{
                                        userTypeKey:[[LyCurrentUser curUser] userTypeByString],
                                        userIdKey:[LyCurrentUser curUser].userId,
                                        sessionIdKey:[LyUtil httpSessionId]
                                        }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


#pragma mark -上传图片（教学环境）
- (void)uploadEnvrionment {
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:LyIndicatorTitle_upload];
    } else {
        [indicator setTitle:LyIndicatorTitle_upload];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:publishHttpMethod_uploadEnv];
    [hr setDelegate:self];
    bHttpFlag = [hr sendMultiPics:updateTeachEnvironmnet_url
                            image:({
        NSMutableArray *arr = [NSMutableArray array];
        for (LyPhotoAsset *asset in [dicEnv_add allValues]) {
            [arr addObject:asset.fullImage];
        }
        arr;
    })
                             body:@{
                                    userIdKey:[LyCurrentUser curUser].userId,
                                    userTypeKey:[[LyCurrentUser curUser] userTypeByString],
                                    sessionIdKey:[LyUtil httpSessionId]
                                    }];
}



#pragma mark -删除境训课程
- (void)deleteTrainClass {
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:LyIndicatorTitle_delete];
    }
    else {
        [indicator setTitle:LyIndicatorTitle_delete];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:publishHttpMethod_deleteTrainClass];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:deleteTrainClass_url
                                 body:@{
                                        trainClassIdKey:[[arrTrainClass objectAtIndex:lastIp_tc.row] tcId],
                                        userIdKey:[LyCurrentUser curUser].userId,
                                        sessionIdKey:[LyUtil httpSessionId],
                                        userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                        }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


#pragma mark -更新是否支持计时说训
- (void)updateTimeTeach:(NSString *)flag {
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:LyIndicatorTitle_modify];
    } else {
        [indicator setTitle:LyIndicatorTitle_modify];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:publishHttpMethod_updateTimeTeach];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:updateTimeTeachFlag_url
                                 body:@{
                                        timeFlagKey:flag,
                                        userIdKey:[LyCurrentUser curUser].userId,
                                        sessionIdKey:[LyUtil httpSessionId],
                                        userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                        }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}



#pragma mark -修改接送范围
- (void)updatePickRange {
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:LyIndicatorTitle_modify];
    } else {
        [indicator setTitle:LyIndicatorTitle_modify];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:publishHttpMethod_updatePickRange];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:updatePickRange_url
                                 body:@{
                                       contentKey:tvPickRange.text,
                                       userIdKey:[LyCurrentUser curUser].userId,
                                       sessionIdKey:[LyUtil httpSessionId],
                                       userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                       }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


#pragma mark -修改简介
- (void)updateSynopsis {
	if (!indicator)
    {
        indicator = [LyIndicator indicatorWithTitle:LyIndicatorTitle_modify];
    } else {
        [indicator setTitle:LyIndicatorTitle_modify];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:publishHttpMethod_updateSynopsis];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:updateSynopsis_url
                                 body:@{
                                        introductionKey:tvSynopsis.text,
                                        userIdKey:[LyCurrentUser curUser].userId,
                                        sessionIdKey:[LyUtil httpSessionId],
                                        userTypeKey:[[LyCurrentUser curUser] userTypeByString]
                                        }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


#pragma mark -删除教学环境
- (void)deleteEnviroment {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[LyCurrentUser curUser].userId forKey:userIdKey];
    [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    
    for (LyEnvPicCollectionViewCell *cell in [cvEnvrionment visibleCells]) {
        if (cell.isChoosed) {
            [dic setObject:cell.asset.assetId forKey:cell.asset.assetId];
        }
    }
    
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:LyIndicatorTitle_delete];
    } else {
        [indicator setTitle:LyIndicatorTitle_delete];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:publishHttpMethod_deleteEnv];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:deleteTeachEnvironment_url
                                 body:dic
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}



- (void)handleHttpFailed {
    
    if (publishHttpMethod_load == curHttpMethod) {
        [self showViewError];
    }
    
    if ([indicator isAnimating]) {
        [indicator stopAnimation];
        NSString *str;
        if ([indicator.title isEqualToString:LyIndicatorTitle_modify]) {
            str = @"修改失败";
        } else if ([indicator.title isEqualToString:LyIndicatorTitle_upload]) {
            str = @"上传失败";
        } else if ([indicator.title isEqualToString:LyIndicatorTitle_delete]) {
            str = @"删除失败";
        }
        
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:str] show];
    }
    
    if (refresherTC.isRefreshing) {
        [refresherTC endRefreshing];
    }
    
    if (refresherSyn.isRefreshing) {
        [refresherSyn endRefreshing];
    }
    
    if (refresherEnv.isRefreshing) {
        [refresherEnv endRefreshing];
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
        [refresherTC endRefreshing];
        [refresherSyn endRefreshing];
        [refresherEnv endRefreshing];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        [refresherTC endRefreshing];
        [refresherSyn endRefreshing];
        [refresherEnv endRefreshing];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    switch (curHttpMethod) {
        case publishHttpMethod_load: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [indicator stopAnimation];
                        [refresherTC endRefreshing];
                        [refresherSyn endRefreshing];
                        [refresherEnv endRefreshing];
                        [self showViewError];
                        return;
                    }
                    
                    
                    NSArray *arrClass = [dicResult objectForKey:classKey];
                    if ([LyUtil validateArray:arrClass]) {
                        for (NSDictionary *item in arrClass) {
                            if (![LyUtil validateDictionary:item]) {
                                continue;
                            }
                            
                            NSString *strId = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:trainClassIdKey]];
                            NSString *strName = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:nameKey]];
                            NSString *strCarName = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:carNameKey]];
                            NSString *strOfficialPrice = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:officialPriceKey]];
                            NSString *str517WholePrice = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:whole517PriceKey]];
                            NSString *str517PrepayPrice = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:whole517PriceKey]];
                            NSString *strTrainTime = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:trainClassTimeKey]];
                            
                            
                            NSString *strDeposit = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:depositKey]];
                            NSString *strInclude = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:includeKey]];
                            NSString *strDriveLicense = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:driveLicenseKey]];
                            NSString *strWaitDays = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:waitDayKey]];
                            NSString *strObjectSecondCount = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:objectSecondCountKey]];
                            NSString *strObjectThirdCount = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:objectThirdCountKey]];
                            NSString *strPickMode = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:pickModeKey]];
                            NSString *strTrainMode = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:trainModeKey]];
                            
                            
                            LyTrainClass *trainClass = [[LyTrainClassManager sharedInstance] getTrainClassWithTrainClassId:strId];
                            if (!trainClass)
                            {
                                trainClass = [LyTrainClass trainClassWithTrainClassId:strId
                                                                               tcName:strName
                                                                           tcMasterId:[LyCurrentUser curUser].userId
                                                                          tcTrainTime:strTrainTime
                                                                            tcCarName:strCarName
                                                                            tcInclude:strInclude
                                                                               tcMode:[LyCurrentUser curUser].userType+LyTrainClassMode_coach
                                                                        tcLicenseType:[LyUtil driveLicenseFromString:strDriveLicense]
                                                                      tcOfficialPrice:[strOfficialPrice floatValue]
                                                                      tc517WholePrice:[str517WholePrice floatValue]
                                                                     tc517PrepayPrice:[str517PrepayPrice floatValue]
                                                                   tc517PrePayDeposit:[strDeposit floatValue]];
                                
                                [trainClass setTcWaitDays:[strWaitDays intValue]];
                                
                                
                                if ([LyUtil validateString:strObjectSecondCount] && [LyUtil validateString:strObjectThirdCount]) {
                                    LyTrainClassObjectPeriod objectPeriod = {strObjectSecondCount.intValue, strObjectThirdCount.intValue};
                                    [trainClass setTcObjectPeriod:objectPeriod];
                                } else {
                                    LyTrainClassObjectPeriod objectPeriod = {0, 0};
                                    [trainClass setTcObjectPeriod:objectPeriod];
                                }
                                [trainClass setTcPickType:[strPickMode integerValue]];
                                [trainClass setTcTrainMode:[LyUtil trainModeFromString:strTrainMode]];
                                
                                [[LyTrainClassManager sharedInstance] addTrainClass:trainClass];
                            }

                        }
                    }
                        
                    
                    
                    
                    NSDictionary *dicSynopsis = [dicResult objectForKey:introductionKey];
                    if ([LyUtil validateDictionary:dicSynopsis]) {
                        curTimeFlag = [[[NSString alloc] initWithFormat:@"%@", [dicSynopsis objectForKey:timeFlagKey]] boolValue];
                        curPickRange = [dicSynopsis objectForKey:pickRangeKey];
                        curPickRange = ([LyUtil validateString:curPickRange]) ? curPickRange : @"";
                        curSynopsis = [dicSynopsis objectForKey:introductionKey];
                        curSynopsis = ([LyUtil validateString:curSynopsis]) ? curSynopsis : @"";
                    }
                    
                    NSArray *arrImge = [dicResult objectForKey:imageKey];
                    if ([LyUtil validateArray:arrImge]) {
                        [dicEnv removeAllObjects];
                        
                        for (NSInteger i = 0; i < arrImge.count; ++i) {
                            NSDictionary *item = [arrImge objectAtIndex:i];
                            if (!item || ![item isKindOfClass:[NSDictionary class]] || item.count < 1)
                            {
                                continue;
                            }
                            
                            NSString *strId = [item objectForKey:idKey];
                            NSString *strImageUrl = [item objectForKey:imageNameKey];
                            if ([LyUtil validateString:strImageUrl]) {
                                if ( [strImageUrl rangeOfString:@"http"].length < 1) {
                                    strImageUrl = [[NSString alloc] initWithFormat:@"%@%@", httpFix, strImageUrl];
                                }
                            }
                            
                            if (strImageUrl) {
                                LyPhotoAsset *asset = [LyPhotoAsset assetWithId:strId
                                                                       smallUrl:[NSURL URLWithString:strImageUrl]
                                                                         bigUrl:[NSURL URLWithString:[LyUtil bigPicUrl:strImageUrl]]];
                                [asset setIndex:i];
                                
                                [dicEnv setObject:asset forKey:@(i)];
                            }
                            
                        }
                    }
                    
                    arrTrainClass = [[LyTrainClassManager sharedInstance] getTrainClassWithTeacherId:[LyCurrentUser curUser].userId];
                    
                    flagLoad = YES;
                    
                    [self reloadViewData];
                    
                    [indicator stopAnimation];
                    
                    
                    [refresherTC endRefreshing];
                    [refresherSyn endRefreshing];
                    [refresherEnv endRefreshing];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case publishHttpMethod_loadTrainClass: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateArray:arrResult]) {
                        if ([refresherTC isRefreshing]) {
                            [refresherTC endRefreshing];
                        }
                        [indicator stopAnimation];
                        
                        return;
                    }
                    
                    for (NSDictionary *item in arrResult) {
                        if (![LyUtil validateDictionary:item]) {
                            continue;
                        }
                        
                        NSString *strId = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:trainClassIdKey]];
                        NSString *strName = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:nameKey]];
                        NSString *strCarName = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:carNameKey]];
                        NSString *strOfficialPrice = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:officialPriceKey]];
                        NSString *str517WholePrice = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:whole517PriceKey]];
                        NSString *str517PrepayPrice = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:whole517PriceKey]];
                        NSString *strTrainTime = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:trainClassTimeKey]];
                        
                        
                        NSString *strDeposit = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:depositKey]];
                        NSString *strInclude = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:includeKey]];
                        NSString *strDriveLicense = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:subjectModeKey]];
                        NSString *strWaitDays = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:waitDayKey]];
                        NSString *strObjectSecondCount = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:objectSecondCountKey]];
                        NSString *strObjectThirdCount = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:objectThirdCountKey]];
                        NSString *strPickMode = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:pickModeKey]];
                        NSString *strTrainMode = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:trainModeKey]];
                        
                        
                        LyTrainClass *trainClass = [[LyTrainClassManager sharedInstance] getTrainClassWithTrainClassId:strId];
                        if (!trainClass) {
                            trainClass = [LyTrainClass trainClassWithTrainClassId:strId
                                                                           tcName:strName
                                                                       tcMasterId:[LyCurrentUser curUser].userId
                                                                      tcTrainTime:strTrainTime
                                                                        tcCarName:strCarName
                                                                        tcInclude:strInclude
                                                                           tcMode:[LyCurrentUser curUser].userType+LyTrainClassMode_coach
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
                    }
                    
                    
                    
                    arrTrainClass = [[LyTrainClassManager sharedInstance] getTrainClassWithTeacherId:[LyCurrentUser curUser].userId];
                    
                    [self reloadTrainClass];
                    
                    [refresherTC endRefreshing];
                    [indicator stopAnimation];
                    
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            
            break;
        }
        case publishHttpMethod_loadSynopsis: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [refresherSyn endRefreshing];
                        [indicator stopAnimation];
                        return;
                    }
                    
                    curTimeFlag = [[[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:timeFlagKey]] boolValue];
                    curPickRange = [dicResult objectForKey:pickRangeKey];
                    curPickRange = ([LyUtil validateString:curPickRange]) ? curPickRange : @"";
                    curSynopsis = [dicResult objectForKey:introductionKey];
                    curSynopsis = ([LyUtil validateString:curSynopsis]) ? curSynopsis : @"";
                    
                    [self reloadSynopsis];
                    
                    [refresherSyn endRefreshing];
                    [indicator stopAnimation];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case publishHttpMethod_loadTeachEnvironment: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateArray:arrResult]) {
                        [refresherEnv endRefreshing];
                        [indicator stopAnimation];
                        return;
                    }
                    
                    [dicEnv removeAllObjects];
                    
                    for (NSInteger i = 0; i < arrResult.count; ++i) {
                        NSDictionary *item = [arrResult objectAtIndex:i];
                        if (![LyUtil validateDictionary:item]) {
                            continue;
                        }
                        
                        NSString *strId = [item objectForKey:idKey];
                        NSString *strImageUrl = [item objectForKey:imageNameKey];
                        if ([LyUtil validateString:strImageUrl]) {
                            if ( [strImageUrl rangeOfString:@"http"].length < 1) {
                                strImageUrl = [[NSString alloc] initWithFormat:@"%@%@", httpFix, strImageUrl];
                            }
                        }
                        
                        if (strImageUrl) {
                            LyPhotoAsset *asset = [LyPhotoAsset assetWithId:strId
                                                                   smallUrl:[NSURL URLWithString:strImageUrl]
                                                                     bigUrl:[NSURL URLWithString:[LyUtil bigPicUrl:strImageUrl]]];
                            [asset setIndex:i];
                            
                            [dicEnv setObject:asset forKey:@(i)];
                        }
                    }
                    
                    [self reloadEnvrionment];

                    [indicator stopAnimation];
                    [refresherEnv endRefreshing];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case publishHttpMethod_deleteTrainClass: {
            switch ([strCode integerValue]) {
                case 0: {
                    
                    [[LyTrainClassManager sharedInstance] removeTrainClassWithId:[[arrTrainClass objectAtIndex:lastIp_tc.row] tcId]];
                    arrTrainClass = [[LyTrainClassManager sharedInstance] getTrainClassWithTeacherId:[LyCurrentUser curUser].userId];
                    [tvTrainClass reloadData];
                    
                    [indicator stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"删除成功"] show];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case publishHttpMethod_updateTimeTeach: {
            switch ([strCode integerValue]) {
                case 0: {
                    [btnIsSupport_teachByTime setSelected:!btnIsSupport_teachByTime.isSelected];
                    [indicator stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"修改成功"] show];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case publishHttpMethod_updatePickRange: {
            switch ([strCode integerValue]) {
                case 0: {
                    curPickRange = tvPickRange.text;
                    [tvPickRange setEditable:NO];
                    [btnPickRange setSelected:NO];
                    [btnPickRangeCancel setHidden:YES];
                    
                    [indicator stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"修改成功"] show];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case publishHttpMethod_updateSynopsis: {
            switch ([strCode integerValue]) {
                case 0: {
                    curSynopsis = tvSynopsis.text;
                    [tvSynopsis setEditable:NO];
                    [btnSynopsis setSelected:NO];
                    [btnSynopsisCancel setHidden:YES];
                    
                    [indicator stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"修改成功"] show];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case publishHttpMethod_uploadEnv: {
            switch ([strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (!arrResult || ![arrResult isKindOfClass:[NSArray class]] || arrResult.count < 1)
                    {
                        [indicator stopAnimation];
                        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"上传失败"] show];
                        return;
                    }
                    
                    [dicEnv removeAllObjects];
                    for (NSInteger i = 0; i < arrResult.count; ++i) {
                        NSDictionary *item = [arrResult objectAtIndex:i];
                        if (!item || ![item isKindOfClass:[NSDictionary class]] || item.count < 1)
                        {
                            continue;
                        }
                        
                        NSString *strId = [item objectForKey:idKey];
                        NSString *strImageUrl = [item objectForKey:imageNameKey];
                        if ([LyUtil validateString:strImageUrl]) {
                            if ( [strImageUrl rangeOfString:@"http"].length < 1) {
                                strImageUrl = [[NSString alloc] initWithFormat:@"%@%@", httpFix, strImageUrl];
                            }
                        }
                        
                        if (strImageUrl) {
                            LyPhotoAsset *asset = [LyPhotoAsset assetWithId:strId
                                                                   smallUrl:[NSURL URLWithString:strImageUrl]
                                                                     bigUrl:[NSURL URLWithString:[LyUtil bigPicUrl:strImageUrl]]];
                            [asset setIndex:i];
                            
                            [dicEnv setObject:asset forKey:@(i)];
                        }
                    
                    }
                    
                    [indicator stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"上传成功"] show];
                    
                    [dicEnv_add removeAllObjects];
                    [self reloadEnvrionment];
                    break;
                }
                default: {
                    [dicEnv removeObjectsForKeys:[dicEnv_add allKeys]];
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case publishHttpMethod_deleteEnv: {
            switch ([strCode integerValue]) {
                case 0: {
                    [dicEnv removeAllObjects];
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    for (NSInteger i = 0; i < arrResult.count; ++i) {
                        NSDictionary *item = [arrResult objectAtIndex:i];
                        if (!item || ![item isKindOfClass:[NSDictionary class]] || item.count < 1)
                        {
                            continue;
                        }
                        
                        NSString *strId = [item objectForKey:idKey];
                        NSString *strImageUrl = [item objectForKey:imageNameKey];
                        if ([LyUtil validateString:strImageUrl]) {
                            if ( [strImageUrl rangeOfString:@"http"].length < 1) {
                                strImageUrl = [[NSString alloc] initWithFormat:@"%@%@", httpFix, strImageUrl];
                            }
                        }
                        
                        if (strImageUrl)
                        {
                            LyPhotoAsset *asset = [LyPhotoAsset assetWithId:strId
                                                                   smallUrl:[NSURL URLWithString:strImageUrl]
                                                                     bigUrl:[NSURL URLWithString:[LyUtil bigPicUrl:strImageUrl]]];
                            [asset setIndex:i];
                            
                            [dicEnv setObject:asset forKey:@(i)];
                        }
                        
                    }
                    
                    [btnEnvEdit setSelected:NO];
                    [btnEnvCancel setHidden:YES];
                    
                    [indicator stopAnimation];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"删除成功"] show];
                    
                    [self reloadEnvrionment];
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



#pragma mark -LyTrainClassTableViewCellDeleagte
- (void)onClickBtnDelete:(LyTrainClassTableViewCell *)aTrainClassCell
{
    lastIp_tc = [tvTrainClass indexPathForCell:aTrainClassCell];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除课程"
                                                                   message:[[NSString alloc] initWithFormat:@"确定要删除「%@」课程吗？", aTrainClassCell.trainClass.tcName]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"删除"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self deleteTrainClass];
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark -AddTrainClassDelegate
- (void)addDoneByLyAddTrainClassViewController:(LyAddTrainClassViewController *)aAddTrainClassVC
{
    [aAddTrainClassVC.navigationController popToRootViewControllerAnimated:YES];
    
    arrTrainClass = [[LyTrainClassManager sharedInstance] getTrainClassWithTeacherId:[LyCurrentUser curUser].userId];
    [tvTrainClass performSelector:@selector(reloadData) withObject:nil afterDelay:LyDelayTime];
}



#pragma mark -LyTrainClassDetailTableViewControllerDelegate
- (LyTrainClass *)obtainTrainClassByTrainClassDetailTVC:(LyTrainClassDetailTableViewController *)aTrainClassDetailTVC
{
    return [[tvTrainClass cellForRowAtIndexPath:lastIp_tc] trainClass];
}

- (void)onDeleteByTrainClassByTrainClassDetailTVC:(LyTrainClassDetailTableViewController *)aTrainClassDetailTVC {
    [aTrainClassDetailTVC.navigationController popViewControllerAnimated:YES];
    
    arrTrainClass = [[LyTrainClassManager sharedInstance] getTrainClassWithTeacherId:[LyCurrentUser curUser].userId];
    [tvTrainClass performSelector:@selector(reloadData) withObject:nil afterDelay:LyDelayTime];
}



#pragma mark -ZLPhotoPickerBrowserViewControllerDelegate
- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index {
}


#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
//    if (btnEnvEdit.isSelected)
//    {
//        return [[dicEnv objectForKey:@(index)] thumbnailImage];
//    }
//    else
//    {
        return [[dicEnv objectForKey:@(index)] thumbnailImage];
//    }
}


- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
//    return [NSURL URLWithString:[LyUtil bigPicUrl:[arrEnvUrl objectAtIndex:index]]];
    return [[dicEnv objectForKey:@(index)] bigUrl];
}



#pragma mark -LyEnvPicCollectionViewCellDelegate
- (void)onLoadFinishByEnvPicCollectionViewCell:(LyEnvPicCollectionViewCell *)aCell image:(UIImage *)image {
    NSInteger index = aCell.index;
    
    [dicEnv setObject:image forKey:@(index)];
}


#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == cvFrags) {
        
        if ([tvPickRange isEditable]) {
            [self targetForButton:btnPickRangeCancel];
        } else if ([tvSynopsis isEditable]) {
            [self targetForButton:btnSynopsisCancel];
        }
        [NSThread sleepForTimeInterval:0.1f];
        
        flagClickCvFrags = YES;
        [svMain setContentOffset:CGPointMake(SCREEN_WIDTH*indexPath.row, 0) animated:YES];
    } else if (collectionView == cvEnvrionment) {
        if (btnEnvEdit.isSelected) {
            //编辑状态
            // 图片游览器
            ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
            // 淡入淡出效果
            pickerBrowser.status = UIViewAnimationAnimationStatusFade;
            // 数据源/delegate
            pickerBrowser.delegate = self;
            
            NSMutableArray *photos = [[NSMutableArray alloc] initWithCapacity:1];
            for (LyPhotoAsset *item in [dicEnv allValues]) {
                [photos addObject:[ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:item.fullImage]];
            }
            pickerBrowser.photos = photos;
            // 能够删除
            pickerBrowser.editing = NO;
            // 当前选中的值
            pickerBrowser.currentIndex = indexPath.row;
            // 展示控制器
            [pickerBrowser showPickerVc:self];
        } else {
            //展示状态
            if (indexPath.row == dicEnv.count) {
                ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
                if ( ALAuthorizationStatusRestricted == author || ALAuthorizationStatusDenied == author) {
                    //相册没有权限
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitleForAlbum
                                                                                   message:alertMessageForAlbum
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                              style:UIAlertActionStyleCancel
                                                            handler:nil]];
                    [alert addAction:[UIAlertAction actionWithTitle:@"设置"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                                                    [LyUtil openUrl:url];
                                                                } else {
                                                                    [LyUtil showAlert:LyAlertViewForAuthorityMode_album vc:self];
                                                                }
                                                            }]];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    return;
                }
                
                ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
                // MaxCount, Default = 9
                pickerVc.maxCount = 9-dicEnv.count;
                // Jump AssetsVc
                pickerVc.status = PickerViewShowStatusCameraRoll;
                // Filter: PickerPhotoStatusAllVideoAndPhotos, PickerPhotoStatusVideos, PickerPhotoStatusPhotos.
                pickerVc.photoStatus = PickerPhotoStatusPhotos;
                // Recoder Select Assets
                pickerVc.selectPickers = nil;
                // Desc Show Photos, And Suppor Camera
                pickerVc.topShowPhotoPicker = YES;
                pickerVc.isShowCamera = YES;
                pickerVc.callBack = ^(NSArray <ZLPhotoAssets *> *status) {
                    NSInteger iCount = dicEnv.count;
                    [dicEnv_add removeAllObjects];
                    for (NSInteger i = 0; i < status.count; ++i){
                        id zlImage = [status objectAtIndex:i];
                        LyPhotoAsset *asset = nil;
                        
                        if ([zlImage isKindOfClass:[ZLPhotoAssets class]]) {
                            asset = [LyPhotoAsset assetWithAsset:[zlImage asset]];
                        } else if ([zlImage isKindOfClass:[ZLCamera class]]) {
                            //                    NSString *zlImagePath = [zlImage imagePath];
                            asset = [LyPhotoAsset assetWithImage:[UIImage imageWithContentsOfFile:[zlImage imagePath]]];
                        }
                        [asset setIndex:iCount+i];
                        
                        [dicEnv setObject:asset forKey:@(iCount+i)];
                        if (!dicEnv_add) {
                            dicEnv_add = [NSMutableDictionary dictionary];
                        }
                        [dicEnv_add setObject:asset forKey:@(iCount+i)];
                    }
                    
                    
                    [self performSelector:@selector(uploadEnvrionment) withObject:nil afterDelay:0.1f];
                };
                
                [pickerVc showPickerVc:self];
            } else {
                SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
                browser.sourceImagesContainerView = cvEnvrionment; // 原图的父控件
                browser.imageCount = [dicEnv count];
                browser.currentImageIndex = [indexPath row];
                browser.delegate = self;
                [browser show];
            }
        }
    }
}


#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == cvFrags) {
        return arrFrags.count;
    } else if (collectionView == cvEnvrionment) {
        if (btnEnvEdit.isSelected) {
            //编辑状态
            return dicEnv.count;
        } else {
            //展示状态
            return (dicEnv.count >= 9) ? 9 : dicEnv.count + 1;
        }
    }
    
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == cvFrags)
    {
        LyFragmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:publishCvFragsCellReuseIdentifier forIndexPath:indexPath];
        if (cell)
        {
            [cell setTitle:arrFrags[indexPath.row]];
        }
        
        return cell;
    }
    else if (collectionView == cvEnvrionment)
    {
        LyEnvPicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:publishCvEnvrionmentCellReuseIdentifier forIndexPath:indexPath];
        if (cell) {
            if (btnEnvEdit.isSelected) {
                //编辑模式
                [cell setCellInfo:[dicEnv objectForKey:@(indexPath.row)]
                             mode:LyEnvPicCollectionViewCellMode_pic
                            index:indexPath.row
                        isEditing:YES];
            } else {
                //展示模式
                if (dicEnv.count == indexPath.row) {
                    [cell setCellInfo:nil
                                 mode:LyEnvPicCollectionViewCellMode_add
                                index:indexPath.row
                            isEditing:NO];
                    [cell setChoosed:NO];
                } else {
                    [cell setCellInfo:[dicEnv objectForKey:@(indexPath.row)]
                                 mode:LyEnvPicCollectionViewCellMode_pic
                                index:indexPath.row
                            isEditing:NO];
                    [cell setChoosed:NO];
                }
                
            }
        }
        
        return cell;
    }
    
    return nil;
}

#pragma mark -UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == cvFrags) {
        return CGSizeMake(SCREEN_WIDTH/arrFrags.count, cvFragsHeight);
    } else if (collectionView == cvEnvrionment) {
        return CGSizeMake(cvEnvrionmentItemWidth, cvEnvrionmentItemHeight);
    }
    
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)sectio {
    if (collectionView == cvFrags) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    } else if (collectionView == cvEnvrionment) {
        return UIEdgeInsetsMake(verticalSpace, epccellMargin, verticalSpace, epccellMargin);
    }
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    lastIp_tc = indexPath;
    
    if (tableView == tvTrainClass) {
        LyTrainClassDetailTableViewController *tcd = [[LyTrainClassDetailTableViewController alloc] init];
        [tcd setHidesBottomBarWhenPushed:YES];
        [tcd setDelegate:self];
        [self.navigationController pushViewController:tcd animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tcHeight;
}


#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrTrainClass.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyTrainClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:publishTvTrainClassCellReuseIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[LyTrainClassTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:publishTvTrainClassCellReuseIdentifier];
    }
    [cell setDelegate:self];
    [cell setShowDeleteButton:[LyCurrentUser curUser].isMaster];
    [cell setTrainClass:[arrTrainClass objectAtIndex:indexPath.row]];
    
    return cell;
}


#pragma mark -UIScrollViewDeleagte
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == svMain) {
        if (!flagClickCvFrags ) {
            
            NSInteger indexCvFrags = cvFrags.indexPathsForSelectedItems[0].row;
            NSInteger timesSvMainOffsetX = svMain.contentOffset.x / SCREEN_WIDTH;
            
            if (indexCvFrags < timesSvMainOffsetX) {
                [cvFrags selectItemAtIndexPath:[NSIndexPath indexPathForRow:timesSvMainOffsetX inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionRight];
                
            } else {
                [cvFrags selectItemAtIndexPath:[NSIndexPath indexPathForRow:timesSvMainOffsetX inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
            }
            
//            float curIdx = (float)cvFrags.indexPathsForSelectedItems[0].row;
//            float nextIdx = svMain.contentOffset.x / (float)SCREEN_WIDTH;
//            if (curIdx < nextIdx) {
//                //向左滑
//                [cvFrags selectItemAtIndexPath:[NSIndexPath indexPathForRow:curIdx+1 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionRight];
//            } else if (curIdx > nextIdx) {
//                //向右滑
//                [cvFrags selectItemAtIndexPath:[NSIndexPath indexPathForRow:curIdx-1 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
//            }
            
        }
    }
}



// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == svMain) {
        flagClickCvFrags = NO;
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
