
//  LyMySchoolViewController.m
//  student
//
//  Created by Junes on 2016/11/23.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyMySchoolViewController.h"
#import "LyTrainClassTableViewCell.h"
#import "LyTrainBaseTableViewCell.h"
#import "LyCoachTableViewCell.h"
#import "LyDetailControlBar.h"

#import "LyIndicator.h"
#import "LyRemindView.h"
#import "LyTrainBasePicker.h"

#import "LyTrainClassManager.h"
#import "LyTrainBaseManager.h"
#import "LyUserManager.h"
#import "LyCurrentUser.h"

#import "UIView+LyExtension.h"
#import "UIScrollView+LyExtension.h"
#import "LyUtil.h"

#import <MessageUI/MessageUI.h>

#import "LyAddSchoolTableViewController.h"
#import "LyTrainBaseTableViewController.h"
#import "LyCoachTableViewController.h"
#import "LyReservateCoachViewController.h"


//信息
CGFloat const msViewInfoHeight = 220.0f;
//信息-头像
CGFloat const msIvAvatarSize = 70.0f;
//信息-名字
CGFloat const msLbNameHeight = 30.0f;
#define msLbNameFont                    LyFont(14)
//信息-计时培训
CGFloat const msLbTimeFlagHeight = 20.0f;
#define msLbTimeFlagFont                LyFont(12)



//培训课程
#define msTvTrainClassHeight            (tcHeight * 1)
#define msViewTrainClassHeight          (tcHeight + LyLbTitleItemHeight)

//培训基地列表


//教练列表

CGFloat const msViewPulldownWidth = 200.0f;
CGFloat const msViewPulldownHeight = 30.0f;
CGFloat const msIvPulldownSize = 30.0f;
CGFloat const msLbCurTrainBaseWidth = msViewPulldownWidth - msIvPulldownSize;
CGFloat const msLbCurTrainBaseHeight = msViewPulldownHeight;




#define msLbNullHeight                  msTvTrainClassHeight




typedef NS_ENUM(NSInteger, LyMySchoolBarButtonItemTag) {
    mySchoolBarButtonItemTag_replace = 0,
};


typedef NS_ENUM(NSInteger, LyMySchoolTableViewTag) {
    mySchoolTableViewTag_trainClass = 10,
    mySchoolTableViewTag_trainBase,
    mySchoolTableViewTag_coach
};


typedef NS_ENUM(NSInteger, LyMySchoolButtonTag) {
    mySchoolButtonTag_trainBase = 20,
    mySchoolButtonTag_coach
};





@interface LyMySchoolViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, LyDetailControlBarDelegate, LyTrainBasePickerDelegate, LyAddSchoolTableViewControllerDelegate, LyTrainBaseTableViewControllerDelegate, LyCoachTableViewControllerDelegate, LyReservateCoachViewControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    UIView          *viewError;
    
    //驾校信息
    UIView          *viewInfo;
    UIImageView     *ivBack;
    UIImageView     *ivAvatar;
    UILabel         *lbName;
    UILabel         *lbTimeFlag;
    
    //培训课程
    UIView          *viewTrainClass;
    UILabel         *lbtitle_tainClass;
    UILabel         *lbNull_trainClass;
    
    //培训基地
    UIView          *viewTrainBase;
    UILabel         *lbTitle_trainBase;
    UILabel         *lbNull_trainBase;
    UIButton        *btnMore_trainBase;
    
    //教练列表
    UIView          *viewCoach;
    UILabel         *lbTitle_coach;
    UIView          *viewPullDown;
    UILabel         *lbCurTrainBase;
    UIImageView     *ivPulldown;
    UILabel         *lbNull_coach;
    UIButton        *btnMore_coach;
    
    
    NSIndexPath     *curIdx_coach;
    
    LyDriveSchool   *school;
    NSString        *myTcId;
    NSMutableArray  *msArrTrainBase;
    NSMutableArray  *msArrCoach;
    
    
    LyIndicator     *indicator;
    LyIndicator     *indicator_oper;
    UIActivityIndicatorView *indicator_coach;
    BOOL            flagLoadSuccess;
}

@property (strong, nonatomic)           UIScrollView            *svMain;
@property (strong, nonatomic)           UIRefreshControl        *refreshControl;

@property (strong, nonatomic)           UITableView             *tvTrainClass;

@property (strong, nonatomic)           UITableView             *tvTrainBase;

@property (strong, nonatomic)           UITableView             *tvCoach;

@property (strong, nonatomic)           LyDetailControlBar      *controlBar;



@property (retain, nonatomic)           LyTrainBase             *curTrainBase;
@property (assign, nonatomic)           LySubjectModeprac       curSubject;

@end

@implementation LyMySchoolViewController

static NSString *const lyMySchoolTvTrainClassCellReuseIdentifier = @"lyMySchoolTvTrainClassCellReuseIdentifier";
static NSString *const lyMySchoolTvTrainBaseCellReuseIdentifier = @"lyMySchoolTvTrainBaseCellReuseIdentifier";
static NSString *const lyMySchoolTvCoachCellReuseIdentifier = @"lyMySchoolTvCoachCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[LyUtil imageForImageName:@"uci_navigatinBar" needCache:NO] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController navigationBar].shadowImage = [LyUtil imageForImageName:@"uci_navigatinBar" needCache:NO];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    
    [self.svMain setContentOffset:CGPointMake( 0, 0)];
    [self.tvCoach deselectRowAtIndexPath:curIdx_coach animated:NO];
    
    if ( !flagLoadSuccess) {
        [self refresh:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)initSubviews {
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    UIBarButtonItem *bbiReplace = [[UIBarButtonItem alloc] initWithTitle:@"更换"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(targetForBarButtonItem:)];
    [bbiReplace setTag:mySchoolBarButtonItemTag_replace];
    [self.navigationItem setRightBarButtonItem:bbiReplace];
    
    //信息
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, msViewInfoHeight)];
    ivBack = [[UIImageView alloc] initWithFrame:viewInfo.bounds];
    [ivBack setContentMode:UIViewContentModeScaleAspectFill];
    [ivBack setImage:[LyUtil imageForImageName:@"driveExam_backGround" needCache:NO]];
    //信息-头像
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f - msIvAvatarSize/2.0f, msViewInfoHeight - (msIvAvatarSize + msLbNameHeight + msLbTimeFlagHeight + verticalSpace * 3), msIvAvatarSize, msIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [ivAvatar.layer setCornerRadius:btnCornerRadius];
    [ivAvatar setClipsToBounds:YES];
    //信息-名字
    lbName = [[UILabel alloc] initWithFrame:CGRectMake(0, ivAvatar.frame.origin.y + CGRectGetHeight(ivAvatar.frame) + verticalSpace, SCREEN_WIDTH, msLbNameHeight)];
    [lbName setFont:msLbNameFont];
    [lbName setTextColor:[UIColor whiteColor]];
    [lbName setTextAlignment:NSTextAlignmentCenter];
    //信息-计时培训
    lbTimeFlag = [[UILabel alloc] initWithFrame:CGRectMake(0, lbName.frame.origin.y + CGRectGetHeight(lbName.frame) + verticalSpace, SCREEN_WIDTH, msLbTimeFlagHeight)];
    [lbTimeFlag setFont:msLbTimeFlagFont];
    [lbTimeFlag setTextColor:[UIColor whiteColor]];
    [lbTimeFlag setTextAlignment:NSTextAlignmentCenter];
    
    [viewInfo addSubview:ivBack];
    [viewInfo addSubview:ivAvatar];
    [viewInfo addSubview:lbName];
    [viewInfo addSubview:lbTimeFlag];
    
    
    
    //培训课程
    viewTrainClass = [[UIView alloc] initWithFrame:CGRectMake(0, viewInfo.frame.origin.y + CGRectGetHeight(viewInfo.frame) + verticalSpace, SCREEN_WIDTH, msViewTrainClassHeight)];
    [viewTrainClass setBackgroundColor:[UIColor whiteColor]];
    //培训课程-标题
    lbtitle_tainClass = [LyUtil lbItemTitleWithText:@"当前课程"];
    
    //培训课程-表格
    //self.tvTrainClass;
    
    [viewTrainClass addSubview:lbtitle_tainClass];
//    [viewTrainClass addSubview:self.tvTrainClass];
    
    
    //培训基地
    viewTrainBase = [[UIView alloc] initWithFrame:CGRectMake(0, viewTrainClass.frame.origin.y + CGRectGetHeight(viewTrainClass.frame) + verticalSpace, SCREEN_WIDTH, 40)];
    [viewTrainBase setBackgroundColor:[UIColor whiteColor]];
    //培训基地-标题
    lbTitle_trainBase = [LyUtil lbItemTitleWithText:@"培训基地"];
    //培训基地-表格
//    self.tvTrainBase;
    
    [viewTrainBase addSubview:lbTitle_trainBase];
//    [viewTrainBase addSubview:self.tvTrainBase];
    
    
    //教练
    viewCoach = [[UIView alloc] initWithFrame:CGRectMake(0, viewTrainBase.frame.origin.y + CGRectGetHeight(viewTrainBase.frame) + verticalSpace, SCREEN_WIDTH, 40)];
    [viewCoach setBackgroundColor:[UIColor whiteColor]];
    //教练-标题
    lbTitle_coach = [LyUtil lbItemTitleWithText:@"预约教练"];
    //教练-表格
//    self.tvCoach;
    
    [viewCoach addSubview:lbTitle_coach];
//    [viewCoach addSubview:self.tvCoach];
    
    
    
    [self.svMain addSubview:viewInfo];
    [self.svMain addSubview:viewTrainClass];
    [self.svMain addSubview:viewTrainBase];
    [self.svMain addSubview:viewCoach];
    
    [_svMain addSubview:self.refreshControl];
    
    [self.view addSubview:self.svMain];
    [self.view addSubview:self.controlBar];
    
    
    _curSubject = LySubjectModeprac_second;
    msArrTrainBase = [[NSMutableArray alloc] initWithCapacity:1];
    msArrCoach = [[NSMutableArray alloc] initWithCapacity:1];
}

- (UIScrollView *)svMain {
    if (!_svMain) {
        _svMain = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_svMain setDelegate:self];
        [_svMain setBounces:YES];
        [_svMain setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 1.05f)];

    }
    
    return _svMain;
}

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [LyUtil refreshControlWithTitle:nil target:self action:@selector(refresh:)];
    }
    
    return _refreshControl;
}

- (UITableView *)tvTrainClass {
    if (!_tvTrainClass) {
        _tvTrainClass = [[UITableView alloc] initWithFrame:CGRectMake(0, lbtitle_tainClass.frame.origin.y + CGRectGetHeight(lbtitle_tainClass.frame), SCREEN_WIDTH, msTvTrainClassHeight)
                                                     style:UITableViewStylePlain];
        [_tvTrainClass setTag:mySchoolTableViewTag_trainClass];
        [_tvTrainClass setDelegate:self];
        [_tvTrainClass setDataSource:self];
        [_tvTrainClass setScrollEnabled:NO];
        [_tvTrainClass setScrollsToTop:NO];
        [_tvTrainClass setShowsVerticalScrollIndicator:NO];
        [_tvTrainClass setShowsHorizontalScrollIndicator:NO];
        [_tvTrainClass setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tvTrainClass registerClass:[LyTrainClassTableViewCell class] forCellReuseIdentifier:lyMySchoolTvTrainClassCellReuseIdentifier];
    }
    
    return _tvTrainClass;
}

- (UITableView *)tvTrainBase {
    if (!_tvTrainBase) {
        _tvTrainBase = [[UITableView alloc] initWithFrame:CGRectMake(0, lbTitle_trainBase.frame.origin.y + CGRectGetHeight(lbTitle_trainBase.frame), SCREEN_WIDTH, 10)
                                                    style:UITableViewStylePlain];
        [_tvTrainBase setTag:mySchoolTableViewTag_trainBase];
        [_tvTrainBase setDelegate:self];
        [_tvTrainBase setDataSource:self];
        [_tvTrainBase setScrollEnabled:NO];
        [_tvTrainBase setScrollsToTop:NO];
        [_tvTrainBase setShowsVerticalScrollIndicator:NO];
        [_tvTrainBase setShowsHorizontalScrollIndicator:NO];
        [_tvTrainBase registerClass:[LyTrainBaseTableViewCell class] forCellReuseIdentifier:lyMySchoolTvTrainBaseCellReuseIdentifier];
    }
    
    return _tvTrainBase;
}

- (UITableView *)tvCoach {
    if (!_tvCoach) {
        _tvCoach = [[UITableView alloc] initWithFrame:CGRectMake(0, lbTitle_coach.frame.origin.y + CGRectGetHeight(lbTitle_coach.frame), SCREEN_WIDTH, 10)
                                                    style:UITableViewStylePlain];
        [_tvCoach setTag:mySchoolTableViewTag_coach];
        [_tvCoach setDelegate:self];
        [_tvCoach setDataSource:self];
        [_tvCoach setScrollEnabled:NO];
        [_tvCoach setScrollsToTop:NO];
        [_tvCoach setShowsVerticalScrollIndicator:NO];
        [_tvCoach setShowsHorizontalScrollIndicator:NO];
        [_tvCoach registerClass:[LyCoachTableViewCell class] forCellReuseIdentifier:lyMySchoolTvCoachCellReuseIdentifier];
    }
    
    return _tvCoach;
}

- (LyDetailControlBar *)controlBar {
    if (!_controlBar) {
        _controlBar = [LyDetailControlBar controlBarWidthMode:LyDetailControlBarMode_myCDG];
        [_controlBar setDelegate:self];
    }
    
    return _controlBar;
}


- (void)showViewError {
    
    flagLoadSuccess = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    if (!viewError) {
        viewError = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _svMain.contentSize.height * 1.1f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewError addSubview:[LyUtil lbErrorWithMode:0]];
    }
    
    [self.svMain addSubview:viewError];
    [self.controlBar removeFromSuperview];
}

- (void)removeViewError {
    flagLoadSuccess = YES;
    
    [viewError removeFromSuperview];
    viewError = nil;
    
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.view addSubview:self.controlBar];
}


- (void)showIndicator_coach {
    if (!indicator_coach) {
        indicator_coach = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [indicator_coach setFrame:CGRectMake( SCREEN_WIDTH/2.0f, LyLbTitleItemHeight, 30.0f, 30.0f)];
        [indicator_coach setColor:LyBlackColor];
    }
    
    [viewCoach addSubview:indicator_coach];
    [indicator_coach startAnimating];
}

- (void)removeIndicator_coach {
    [indicator_coach stopAnimating];
    indicator_coach = nil;
}


- (void)reloadData {
    
    [self removeViewError];
    
    if (!school.userAvatar) {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:school.userId]
                    placeholderImage:[LyUtil defaultAvatarForTeacher]
                           completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                               if (image) {
                                   [school setUserAvatar:image];
                               } else {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:school.userId]
                                               placeholderImage:[LyUtil defaultAvatarForTeacher]
                                                      completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                                          if (image) {
                                                              [school setUserAvatar:image];
                                                          }
                                                      }];
                               }
                           }];
        
    } else {
        [ivAvatar setImage:school.userAvatar];
    }
    
    
    [lbName setText:school.userName];
    [lbTimeFlag setText:school.timeFlag ? @"支持计时培训" : @"不支持计时培训"];
    
    [self reloadData_trainClass];
}


- (void)reloadData_trainClass {
    
    if (!myTcId) {
        if (!lbNull_trainClass) {
            lbNull_trainClass = [LyUtil lbNullWithText:@"当前没有课程"];
            [lbNull_trainClass setFrame:CGRectMake(0, lbtitle_tainClass.frame.origin.y + CGRectGetHeight(lbtitle_tainClass.frame), SCREEN_WIDTH, msTvTrainClassHeight)];
//            [lbNull_trainClass setBackgroundColor:[UIColor whiteColor]];
        }
        
        [viewTrainClass addSubview:lbNull_trainClass];
        [self.tvTrainClass removeFromSuperview];
        
    } else {
        [lbNull_trainClass removeFromSuperview];
        
        [viewTrainClass addSubview:self.tvTrainClass];
    }
    
    [self reloadData_trainBase];
}

- (void)reloadData_trainBase {
    
    CGFloat fHeightViewTrainBase = 0;
    if (!msArrTrainBase || msArrTrainBase.count < 1) {
        if (!lbNull_trainBase) {
            lbNull_trainBase = [LyUtil lbNullWithText:@"还没有培训基地"];
            [lbNull_trainBase setFrame:CGRectMake(0, lbTitle_trainBase.frame.origin.y + CGRectGetHeight(lbTitle_trainBase.frame), SCREEN_WIDTH, msLbNullHeight)];
//            [lbNull_trainBase setBackgroundColor:[UIColor whiteColor]];
        }
        
        [viewTrainBase addSubview:lbNull_trainBase];
        [self.tvTrainBase removeFromSuperview];
        [btnMore_trainBase removeFromSuperview];
        
        fHeightViewTrainBase = msViewTrainClassHeight;
        
    } else {
        [lbNull_trainBase removeFromSuperview];
        
        CGFloat fHeightTvTrainBase = tbcellHeight * ((msArrTrainBase.count > 2) ? 2: msArrTrainBase.count);
        [self.tvTrainBase setFrame:CGRectMake(0, lbTitle_trainBase.frame.origin.y + CGRectGetHeight(lbTitle_trainBase.frame), SCREEN_WIDTH, fHeightTvTrainBase)];
        [viewTrainBase addSubview:self.tvTrainBase];
        [self.tvTrainBase reloadData];
        
        if (msArrTrainBase.count > 2) {
            if (!btnMore_trainBase) {
                btnMore_trainBase = [self getItemButtonMore:mySchoolButtonTag_trainBase];
                [btnMore_trainBase setFrame:CGRectMake(SCREEN_WIDTH - horizontalSpace - LyBtnMoreWidth, self.tvTrainBase.frame.origin.y + fHeightTvTrainBase, LyBtnMoreWidth, LyBtnMoreHeight)];
            }
            
            [viewTrainBase addSubview:btnMore_trainBase];
            
            fHeightViewTrainBase = btnMore_trainBase.frame.origin.y + CGRectGetHeight(btnMore_trainBase.frame);
            
        } else {
            [btnMore_trainBase removeFromSuperview];
            btnMore_trainBase = nil;
            
            fHeightViewTrainBase = self.tvTrainBase.frame.origin.y + fHeightTvTrainBase;
        }
        
    }
    
    [viewTrainBase setFrame:CGRectMake(0, viewTrainClass.frame.origin.y + CGRectGetHeight(viewTrainClass.frame) + verticalSpace, SCREEN_WIDTH, fHeightViewTrainBase)];
    
    [self reloadData_coach];
}

- (void)reloadData_coach {
    
    CGFloat fHeightViewCoach = 0;
    
    if (!self.curTrainBase) {
        if (!lbNull_coach) {
            lbNull_coach = [LyUtil lbNullWithText:@"该基地还没有教练"];
            [lbNull_coach setFrame:CGRectMake(0, lbTitle_coach.frame.origin.y + CGRectGetHeight(lbTitle_coach.frame), SCREEN_WIDTH, msLbNullHeight)];
//            [lbNull_coach setBackgroundColor:[UIColor whiteColor]];
        }
        
        [viewCoach addSubview:lbNull_coach];
        [self.tvCoach removeFromSuperview];
        [btnMore_coach removeFromSuperview];
        btnMore_coach = nil;
        [viewPullDown removeFromSuperview];
        
        fHeightViewCoach = lbNull_coach.frame.origin.y + CGRectGetHeight(lbNull_coach.frame);
        
    } else {
        NSInteger iCoachCount = self.curTrainBase.tbCoachCount;
        iCoachCount = MIN(iCoachCount, msArrCoach.count);
        iCoachCount = MIN(iCoachCount, 5);
        
        
        if (iCoachCount < 1) {
            if (!lbNull_coach) {
                lbNull_coach = [LyUtil lbNullWithText:@"该基地还没有教练"];
                [lbNull_coach setFrame:CGRectMake(0, lbTitle_coach.frame.origin.y + CGRectGetHeight(lbTitle_coach.frame), SCREEN_WIDTH, msLbNullHeight)];
            }
            
            [self.tvCoach removeFromSuperview];
            [btnMore_coach removeFromSuperview];
            btnMore_coach = nil;
            [viewPullDown removeFromSuperview];
            
            [viewCoach addSubview:lbNull_coach];
            
            fHeightViewCoach = lbNull_coach.frame.origin.y + CGRectGetHeight(lbNull_coach.frame);
            
        } else {
            [lbNull_coach removeFromSuperview];
            lbNull_coach = nil;
            
            [viewCoach addSubview:self.tvCoach];
            
            
            CGFloat fHeightTvCoach = COACHCELLHEIGHT * iCoachCount;
            [self.tvCoach setFrame:CGRectMake(0, lbTitle_coach.frame.origin.y + CGRectGetHeight(lbTitle_coach.frame), SCREEN_WIDTH, fHeightTvCoach)];
            [self.tvCoach reloadData];
            
            if (iCoachCount >= 5) {
                if (!btnMore_coach) {
                    btnMore_coach = [self getItemButtonMore:mySchoolButtonTag_coach];
                    [btnMore_coach setFrame:CGRectMake(SCREEN_WIDTH - horizontalSpace - LyBtnMoreWidth, self.tvCoach.frame.origin.y + CGRectGetHeight(self.tvCoach.frame), LyBtnMoreWidth, LyBtnMoreHeight)];
                }
                
                [viewCoach addSubview:btnMore_coach];
                
                fHeightViewCoach = btnMore_coach.frame.origin.y + CGRectGetHeight(btnMore_coach.frame);
            } else {
                [btnMore_coach removeFromSuperview];
                
                fHeightViewCoach = self.tvCoach.frame.origin.y + fHeightTvCoach;
            }
        }
    }
    
    [viewCoach setFrame:CGRectMake(0, viewTrainBase.frame.origin.y + CGRectGetHeight(viewTrainBase.frame) + verticalSpace, SCREEN_WIDTH, fHeightViewCoach)];
    
    
    if (!msArrTrainBase || msArrTrainBase.count < 1) {
        [viewPullDown removeFromSuperview];
        
    } else {
        if (!viewPullDown) {
            viewPullDown = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - msViewPulldownWidth, 0, msViewPulldownWidth, msViewPulldownHeight)];
            [viewPullDown setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForTapGestureFromViewPulldown)];
            [viewPullDown addGestureRecognizer:tap];
            
            if (!lbCurTrainBase) {
                lbCurTrainBase = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, msLbCurTrainBaseWidth, msLbCurTrainBaseHeight)];
                [lbCurTrainBase setFont:LyFont(12)];
                [lbCurTrainBase setTextColor:Ly517ThemeColor];
                [lbCurTrainBase setTextAlignment:NSTextAlignmentRight];
                
                [lbCurTrainBase setUserInteractionEnabled:YES];
            }
            
            if (!ivPulldown) {
                ivPulldown = [[UIImageView alloc] initWithFrame:CGRectMake(msLbCurTrainBaseWidth, 0, msIvPulldownSize, msIvPulldownSize)];
                [ivPulldown setContentMode:UIViewContentModeScaleAspectFit];
                [ivPulldown setImage:[LyUtil imageForImageName:@"mySchool_coach_pullDown" needCache:NO]];
                
                [ivPulldown setUserInteractionEnabled:YES];
            }
            
            [viewPullDown addSubview:lbCurTrainBase];
            [viewPullDown addSubview:ivPulldown];
        }
        
        [self setCurTrainBase:self.curTrainBase];
        
        [viewCoach addSubview:viewPullDown];
        
        if (indicator_coach.isAnimating) {
            [indicator_coach stopAnimating];
        }
    }
    
    
    CGFloat fHeightSvMainSize = viewCoach.frame.origin.y + CGRectGetHeight(viewCoach.frame);
    fHeightSvMainSize = CGRectGetHeight(self.controlBar.frame) + ((fHeightSvMainSize >= SCREEN_HEIGHT) ? fHeightSvMainSize : SCREEN_HEIGHT);
    [self.svMain setContentSize:CGSizeMake(SCREEN_WIDTH, fHeightSvMainSize)];
}



- (void)setCurTrainBase:(LyTrainBase *)curTrainBase {
    _curTrainBase = curTrainBase;
    
    [lbCurTrainBase setText:_curTrainBase.tbName];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)getItemButtonMore:(LyMySchoolButtonTag)btnTag {
    UIButton *itemBtnMore = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemBtnMore setTitle:@"更多" forState:UIControlStateNormal];
    [itemBtnMore setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [itemBtnMore setTag:btnTag];
    [[itemBtnMore titleLabel] setFont:LyBtnMoreTitleFont];
    [itemBtnMore addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return itemBtnMore;
}



- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    LyMySchoolBarButtonItemTag bbiTag = bbi.tag;
    switch (bbiTag) {
        case mySchoolBarButtonItemTag_replace: {
            LyAddSchoolTableViewController *addSchool = [[LyAddSchoolTableViewController alloc] init];
            [addSchool setDelegate:self];
            [self.navigationController pushViewController:addSchool animated:YES];
            break;
        }
    }
    
}

- (void)targetForButton:(UIButton *)btn {
    LyMySchoolButtonTag btnTag = btn.tag;
    switch (btnTag) {
        case mySchoolButtonTag_trainBase: {
            LyTrainBaseTableViewController *trainBase = [[LyTrainBaseTableViewController alloc] init];
            [trainBase setDelegate:self];
            [self.navigationController pushViewController:trainBase animated:YES];
            break;
        }
        case mySchoolButtonTag_coach: {
            LyCoachTableViewController *coachVc = [[LyCoachTableViewController alloc] init];
            [coachVc setDelegate:self];
            [self.navigationController pushViewController:coachVc animated:YES];
            break;
        }

    }
}

- (void)targetForTapGestureFromViewPulldown {
    LyTrainBasePicker *trainBasePicker = [[LyTrainBasePicker alloc] initWithTrainBase:msArrTrainBase];
    [trainBasePicker setDelegate:self];
    [trainBasePicker showWithInfoString:lbCurTrainBase.text];
}


- (void)refresh:(UIRefreshControl *)refreshControl {
    [self load];
    
    [self.navigationController.navigationBar setHidden:YES];
}


- (void)handleHttpFailed:(BOOL)needRemind {
    [self.navigationController.navigationBar setHidden:NO];
    
    if (indicator.isAnimating) {
        [indicator stopAnimation];
        [self.refreshControl endRefreshing];
        [self showViewError];
    }
    
    if (indicator_oper.isAnimating) {
        [indicator_oper stopAnimation];
        
        if (needRemind) {
            NSString *remindTitle = nil;
            if ([indicator_oper.title isEqualToString:LyIndicatorTitle_attente]) {
                remindTitle = @"关注失败";
            } else if ([indicator_oper.title isEqualToString:LyIndicatorTitle_deattente]) {
                remindTitle = @"取关失败";
            }
            
            [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:remindTitle];
        }
    }
    
    if (indicator_coach.isAnimating) {
        [self reloadData_coach];
        [self removeIndicator_coach];
    }
}

- (NSDictionary *)analysisHttpResult:(NSString *)result {
    NSDictionary *dic = [LyUtil getObjFromJson:result];
    if (![LyUtil validateDictionary:dic]) {
        return nil;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (![LyUtil validateString:strCode]) {
        return nil;
    }
    
    if (codeTimeOut == strCode.intValue) {
        [self handleHttpFailed:NO];
        
        [LyUtil sessionTimeOut:self];
        return nil;
    }
    
    if (codeMaintaining == strCode.intValue) {
        [self handleHttpFailed:NO];
        
        [LyUtil serverMaintaining];
        return nil;
    }
    
    return dic;
}


- (void)load {
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(load) object:nil];
        return;
    }
    
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:nil];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:myDriveShcool_url
                    body:@{
                           classIdKey:(nil != [LyCurrentUser curUser].userTrainClassId) ? [LyCurrentUser curUser].userTrainClassId : @"0",
                           userIdKey:[[LyCurrentUser curUser] userId],
                           userTypeKey:userTypeSchoolKey,
                           myDriveSchoolIdKey:[[LyCurrentUser curUser] userDriveSchoolId],
                           driveLicenseKey:[LyUtil driveLicenseStringFrom:[[LyCurrentUser curUser] userLicenseType]],
                           sessionIdKey:[LyUtil httpSessionId]
                           }
                    type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
           if (error) {
               [self handleHttpFailed:YES];
           } else {
               NSDictionary *dic = [self analysisHttpResult:resStr];
               if (!dic) {
                   [self handleHttpFailed:YES];
               }
               
               NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
               switch (strCode.integerValue) {
                   case 0: {
                       [msArrTrainBase removeAllObjects];
                       [msArrCoach removeAllObjects];
                       self.curTrainBase = nil;
                       
                       NSDictionary *dicResult = [dic objectForKey:resultKey];
                       if (![LyUtil validateDictionary:dicResult]) {
                           [self handleHttpFailed:YES];
                           return;
                       }
                       
                       //驾校信息
                       NSDictionary *dicMySchoolInfo = [dicResult objectForKey:myDriveSchoolInfoKey];
                       if (![LyUtil validateDictionary:dicMySchoolInfo]) {
                           [self handleHttpFailed:YES];
                           return;
                       }
                       
                       NSString *strName = [[NSString alloc] initWithFormat:@"%@", [dicMySchoolInfo objectForKey:nickNameKey]];
                       NSString *strTimeFlag = [[NSString alloc] initWithFormat:@"%@", [dicMySchoolInfo objectForKey:timeFlagKey]];
                       NSString *strFlag = [[NSString alloc] initWithFormat:@"%@", [dicMySchoolInfo objectForKey:flagKey]];
                       
                       school = [[LyUserManager sharedInstance] getDriveSchoolWithDriveSchoolId:[LyCurrentUser curUser].userDriveSchoolId];
                       if (!school) {
                           school = [LyDriveSchool driveSchoolWithId:[LyCurrentUser curUser].userDriveSchoolId
                                                            dschName:strName];
                           [[LyUserManager sharedInstance] addUser:school];
                       } else {
                           [school setUserName:strName];
                       }
                       
                       [school setTimeFlag:strTimeFlag.boolValue];
                       [self.controlBar setAttentionStatus:strFlag.boolValue];
                       
                       
                       //培训课程
                       NSDictionary *dicTrainClass = [dicResult objectForKey:myDriveSchoolTrainClassKey];
                       if ([LyUtil validateDictionary:dicTrainClass]) {
                           NSString *strTcId = [[NSString alloc] initWithFormat:@"%@", [dicTrainClass objectForKey:trainClassIdKey]];
                           NSString *strTcName = [[NSString alloc] initWithFormat:@"%@", [dicTrainClass objectForKey:myDriveSchoolTrainClassNameKey]];
                           NSString *strTcMasterId = [NSString stringWithFormat:@"%@", [dicTrainClass objectForKey:masterIdKey]];
                           NSString *strLicenseType = [[NSString alloc] initWithFormat:@"%@", [dicTrainClass objectForKey:driveLicenseKey]];
                           NSString *strCarName = [[NSString alloc] initWithFormat:@"%@", [dicTrainClass objectForKey:carNameKey]];
                           NSString *strClassTime = [[NSString alloc] initWithFormat:@"%@", [dicTrainClass objectForKey:classTimeKey]];
                           NSString *strOfficialPrice = [[NSString alloc] initWithFormat:@"%@", [dicTrainClass objectForKey:officialPriceKey]];
                           NSString *strWhole517Price = [[NSString alloc] initWithFormat:@"%@", [dicTrainClass objectForKey:whole517PriceKey]];
                           NSString *strPrepay517Price = [[NSString alloc] initWithFormat:@"%@", [dicTrainClass objectForKey:prepay517priceKey]];
                           NSString *strPrepay517Deposit = [[NSString alloc] initWithFormat:@"%@", [dicTrainClass objectForKey:prepay517depositKey]];
                           
                           
                           LyTrainClass *trainClass = [LyTrainClass trainClassWithTrainClassId:strTcId
                                                                                        tcName:strTcName
                                                                                    tcMasterId:strTcMasterId
                                                                                   tcTrainTime:strClassTime
                                                                                     tcCarName:strCarName
                                                                                        tcMode:0
                                                                                 tcLicenseType:strLicenseType.integerValue
                                                                               tcOfficialPrice:strOfficialPrice.floatValue
                                                                               tc517WholePrice:strWhole517Price.floatValue
                                                                              tc517PrepayPrice:strPrepay517Price.floatValue
                                                                            tc517PrePayDeposit:strPrepay517Deposit.floatValue];
                           
                           [[LyTrainClassManager sharedInstance] addTrainClass:trainClass];
                           myTcId = strTcId;
                       }
                       
                       //培训基地
                       [msArrCoach removeAllObjects];
                       //                    [mschArrTrainBase removeAllObjects];
                       NSArray *arrTrainBase = [dicResult objectForKey:trainBaseKey];
                       if ([LyUtil validateArray:arrTrainBase]) {
                           for (NSDictionary *dicTrainBase in arrTrainBase) {
                               
                               if (![LyUtil validateDictionary:dicTrainBase]) {
                                   continue;
                               }
                               
                               NSString *strId = [dicTrainBase objectForKey:idKey];
                               NSString *strName = [dicTrainBase objectForKey:trainBaseNameKey];
                               NSString *strAddress = [dicTrainBase objectForKey:addressKey];
                               NSString *strCoachCount = [[NSString alloc] initWithFormat:@"%@", [dicTrainBase objectForKey:coachCountKey]];
                               NSString *strStudentCount = [[NSString alloc] initWithFormat:@"%@", [dicTrainBase objectForKey:studentCountKey]];
                               

                               //教练
                               if (strCoachCount.intValue > msArrCoach.count) {
                                   NSArray *arrCoach = [dicTrainBase objectForKey:coachKey];
                                   if ([LyUtil validateArray:arrCoach] && arrCoach.count > msArrCoach.count) {
                                       [msArrCoach removeAllObjects];
                                       
                                       for (NSDictionary *dicCoach in arrCoach) {
                                           if (![LyUtil validateDictionary:dicCoach]) {
                                               continue;
                                           }
                                           
                                           NSString *strId = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:userIdKey]];
                                           NSString *strName = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:nickNameKey]];
                                           NSString *strSex = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:sexKey]];
                                           NSString *strScore = [[NSString alloc] initWithFormat:@"%@",[dicCoach objectForKey:scoreKey]];
                                           NSString *strCoachBirthday = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:birthdayKey]];
                                           NSString *strTeachBirthday = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:teachBirthdayKey]];
                                           NSString *strDriveBirthday = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:driveBirthdayKey]];
                                           NSString *strPassedCount = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:teachedPassedCountKey]];
                                           NSString *strTeachAllCount = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:teachAllCountKey]];
                                           NSString *strPraiseCount = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:praiseCountKey]];
                                           NSString *strEvalutionCount = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:evalutionCountKey]];
                                           NSString *strTrainBaseId = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:trainBaseIdKey]];
                                           NSString *strDriveLicense = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:driveLicenseKey]];
                                           
                                           NSString *strMasterId = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:masterIdKey]];
                                           
                                           NSString *strTimeFlag = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:timeFlagKey]];
                                           
                                           
                                           if (!strName) {
                                               strName = [LyUtil getUserNameWithUserId:strId];
                                           }
                                           
                                           LyCoach *coach = [[LyUserManager sharedInstance] getCoachWithCoachId:strId];
                                           if ( !coach || LyUserType_coach != coach.userType)
                                           {
                                               coach = [LyCoach coachWithId:strId
                                                                    coaName:strName
                                                                      score:[strScore floatValue]
                                                                     coaSex:[strSex integerValue]
                                                                coaBirthday:strCoachBirthday
                                                           coaTeachBirthday:strTeachBirthday
                                                           coaDriveBirthday:strDriveBirthday
                                                                stuAllCount:[strTeachAllCount intValue]
                                                      coaTeachedPassedCount:[strPassedCount intValue]
                                                          coaEvaluationCount:[strEvalutionCount intValue]
                                                             coaPraiseCount:[strPraiseCount intValue]
                                                                      price:0];
                                               
                                               
                                               [[LyUserManager sharedInstance] addUser:coach];
                                           }
                                           
                                           [coach setUserSex:[strSex integerValue]];
                                           [coach setScore:[strScore floatValue]];
                                           [coach setUserBirthday:strCoachBirthday];
                                           [coach setCoaTeachBirthday:strTeachBirthday];
                                           [coach setCoaDriveBirthday:strDriveBirthday];
                                           [coach setCoaTeachedPassedCount:[strPassedCount intValue]];
                                           [coach setCoaEvaluationCount:[strEvalutionCount intValue]];
                                           [coach setCoaPraiseCount:[strPraiseCount intValue]];
                                           [coach setCoaTrainBaseId:strTrainBaseId];
                                           [coach setUserLicenseType:[LyUtil driveLicenseFromString:strDriveLicense]];
                                           
                                           [coach setCoaMasterId:strMasterId];
                                           [coach setTimeFlag:[strTimeFlag boolValue]];
                                           
                                           [msArrCoach addObject:coach];
                                       }
                                   }
                               }
                               
                               
                               
                               LyTrainBase *trainBase = [[LyTrainBaseManager sharedInstance] getTrainBaseWithTbId:strId];
                               if (!trainBase)
                               {
                                   trainBase = [LyTrainBase trainBaseWithTbId:strId
                                                                       tbName:strName
                                                                    tbAddress:strAddress
                                                                 tbCoachCount:[strCoachCount integerValue]
                                                               tbStudentCount:[strStudentCount integerValue]];
                                   
                                   [[LyTrainBaseManager sharedInstance] addTrainBase:trainBase];
                               }
                               
                               [msArrTrainBase addObject:trainBase];
                           }
                       }
                       
                       [msArrTrainBase sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                           return [obj1 tbCoachCount] < [obj2 tbCoachCount];
                       }];
                       
                       
                       /*
                       NSDictionary *dicCoach = [dicResult objectForKey:coachKey];
                       if ([LyUtil validateDictionary:dicCoach]) {
                        
                           curTbId = [[NSString alloc] initWithFormat:@"%@", [dicCoach objectForKey:indexKey]];
                           
                           NSArray *arrCoach = [dicCoach objectForKey:@"0"];
                           if ([LyUtil validateArray:arrCoach]) {
                               for (NSDictionary *dicItem in arrCoach) {
                                   if (![LyUtil validateDictionary:dicItem]) {
                                       continue;
                                   }
                                   
                                   NSString *strId = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:userIdKey]];
                                   NSString *strName = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:nickNameKey]];
                                   NSString *strSex = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:sexKey]];
                                   NSString *strScore = [[NSString alloc] initWithFormat:@"%@",[dicItem objectForKey:scoreKey]];
                                   NSString *strCoachBirthday = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:birthdayKey]];
                                   NSString *strTeachBirthday = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:teachBirthdayKey]];
                                   NSString *strDriveBirthday = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:driveBirthdayKey]];
                                   NSString *strPassedCount = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:teachedPassedCountKey]];
                                   NSString *strTeachAllCount = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:teachAllCountKey]];
                                   NSString *strPraiseCount = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:praiseCountKey]];
                                   NSString *strEvalutionCount = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:evalutionCountKey]];
                                   NSString *strTrainBaseId = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:trainBaseIdKey]];
                                   NSString *strDriveLicense = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:driveLicenseKey]];
                                   
                                   NSString *strMasterId = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:masterIdKey]];
                                   
                                   NSString *strTimeFlag = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:timeFlagKey]];
                                   
                                   if (!strName) {
                                       strName = [LyUtil getUserNameWithUserId:strId];
                                   }
                                   
                                   LyCoach *coach = [[LyUserManager sharedInstance] getCoachWithCoachId:strId];
                                   if ( !coach || LyUserType_coach != coach.userType)
                                   {
                                       coach = [LyCoach coachWithId:strId
                                                            coaName:strName
                                                              score:[strScore floatValue]
                                                             coaSex:[strSex integerValue]
                                                        coaBirthday:strCoachBirthday
                                                   coaTeachBirthday:strTeachBirthday
                                                   coaDriveBirthday:strDriveBirthday
                                                        stuAllCount:[strTeachAllCount intValue]
                                              coaTeachedPassedCount:[strPassedCount intValue]
                                                  coaEvaluationCount:[strEvalutionCount intValue]
                                                     coaPraiseCount:[strPraiseCount intValue]
                                                              price:0];
                                       
                                       
                                       [[LyUserManager sharedInstance] addUser:coach];
                                   }
                                   
                                   [coach setUserSex:[strSex integerValue]];
                                   [coach setScore:[strScore floatValue]];
                                   [coach setUserBirthday:strCoachBirthday];
                                   [coach setCoaTeachBirthday:strTeachBirthday];
                                   [coach setCoaDriveBirthday:strDriveBirthday];
                                   [coach setCoaTeachedPassedCount:[strPassedCount intValue]];
                                   [coach setCoaEvaluationCount:[strEvalutionCount intValue]];
                                   [coach setCoaPraiseCount:[strPraiseCount intValue]];
                                   [coach setCoaTrainBaseId:strTrainBaseId];
                                   [coach setUserLicenseType:[LyUtil driveLicenseFromString:strDriveLicense]];
                                   
                                   [coach setCoaMasterId:strMasterId];
                                   [coach setTimeFlag:[strTimeFlag boolValue]];
                                   
                                   [msArrCoach addObject:coach];
                               }
                           }
                       }
                       */
                       
                       if (msArrTrainBase && msArrTrainBase.count > 0) {
                           [self setCurTrainBase:msArrTrainBase[0]];
                       }
                       
                       [self reloadData];
                       
                       [indicator stopAnimation];
                       [self.refreshControl endRefreshing];
                       
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


- (void)loadTrainCoach {
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(loadTrainCoach) object:nil];
        return;
    }
    
    [self.tvCoach removeFromSuperview];
    [self showIndicator_coach];
    
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:getTrainCoach_url
                    body:@{
                           trainBaseIdKey:self.curTrainBase.tbId,
                           subjectModeKey:@(self.curSubject),
                           driveLicenseKey:[LyUtil driveLicenseStringFrom:[LyCurrentUser curUser].userLicenseType],
                           driveSchoolIdKey:[[LyCurrentUser curUser] userDriveSchoolId],
                           userIdKey:[[LyCurrentUser curUser] userId],
                           sessionIdKey:[LyUtil httpSessionId]
                           }
                    type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
           if (error) {
               [self handleHttpFailed:YES];
           } else {
               NSDictionary *dic = [self analysisHttpResult:resStr];
               if (!dic) {
                   [self handleHttpFailed:YES];
                   return;
               }
               
               NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
               switch (strCode.integerValue) {
                   case 0: {
                       [msArrCoach removeAllObjects];
                       
                       NSArray *arrResult = [dic objectForKey:resultKey];
                       if (![LyUtil validateArray:arrResult]) {
                           [self handleHttpFailed:YES];
                           return;
                       }
                       
                       for (NSDictionary *dicItem in arrResult) {
                           if (![LyUtil validateDictionary:dicItem]) {
                               continue;
                           }
                           
                           NSString *strId = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:userIdKey]];
                           NSString *strName = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:nickNameKey]];
                           NSString *strSex = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:sexKey]];
                           NSString *strScore = [[NSString alloc] initWithFormat:@"%@",[dicItem objectForKey:scoreKey]];
                           NSString *strCoachBirthday = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:birthdayKey]];
                           NSString *strTeachBirthday = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:teachBirthdayKey]];
                           NSString *strDriveBirthday = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:driveBirthdayKey]];
                           NSString *strPassedCount = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:teachedPassedCountKey]];
                           NSString *strTeachAllCount = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:teachAllCountKey]];
                           NSString *strPraiseCount = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:praiseCountKey]];
                           NSString *strEvalutionCount = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:evalutionCountKey]];
                           NSString *strTrainBaseId = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:trainBaseIdKey]];
                           NSString *strDriveLicense = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:driveLicenseKey]];
                           
                           NSString *strMasterId = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:masterIdKey]];
                           
                           NSString *strTimeFlag = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:timeFlagKey]];
                           
                           if (!strName) {
                               strName = [LyUtil getUserNameWithUserId:strId];
                           }
                           
                           LyCoach *coach = [[LyUserManager sharedInstance] getCoachWithCoachId:strId];
                           if ( !coach) {
                               coach = [LyCoach coachWithId:strId
                                                    coaName:strName
                                                      score:[strScore floatValue]
                                                     coaSex:[strSex integerValue]
                                                coaBirthday:strCoachBirthday
                                           coaTeachBirthday:strTeachBirthday
                                           coaDriveBirthday:strDriveBirthday
                                                stuAllCount:[strTeachAllCount intValue]
                                      coaTeachedPassedCount:[strPassedCount intValue]
                                          coaEvaluationCount:[strEvalutionCount intValue]
                                             coaPraiseCount:[strPraiseCount intValue]
                                                      price:0];
                               
                               
                               [[LyUserManager sharedInstance] addUser:coach];
                           }
                           
                           [coach setUserSex:[strSex integerValue]];
                           [coach setScore:[strScore floatValue]];
                           [coach setUserBirthday:strCoachBirthday];
                           [coach setCoaTeachBirthday:strTeachBirthday];
                           [coach setCoaDriveBirthday:strDriveBirthday];
                           [coach setCoaTeachedPassedCount:[strPassedCount intValue]];
                           [coach setCoaEvaluationCount:[strEvalutionCount intValue]];
                           [coach setCoaPraiseCount:[strPraiseCount intValue]];
                           [coach setCoaTrainBaseId:strTrainBaseId];
                           [coach setUserLicenseType:[LyUtil driveLicenseFromString:strDriveLicense]];
                           
                           [coach setCoaMasterId:strMasterId];
                           [coach setTimeFlag:[strTimeFlag boolValue]];
                           
                           [msArrCoach addObject:coach];
                           
                           
                           [self reloadData_coach];
                           [self removeIndicator_coach];
                       }
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


- (void)attente {
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(attente) object:nil];
        return;
    }
    
    if (!indicator_oper) {
        indicator_oper = [LyIndicator indicatorWithTitle:LyIndicatorTitle_attente];
    } else {
        [indicator_oper setTitle:LyIndicatorTitle_attente];
    }
    [indicator_oper startAnimation];
    
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:addAttention_url
                    body:@{
                           objectIdKey:school.userId,
                           userIdKey:[LyCurrentUser curUser].userId,
                           sessionIdKey:[LyUtil httpSessionId],
                           userTypeKey:userTypeSchoolKey
                           }
                type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
           if (error) {
               [self handleHttpFailed:YES];
           } else {
               NSDictionary *dic = [self analysisHttpResult:resStr];
               if (!dic) {
                   [self handleHttpFailed:YES];
                   return;
               }
               
               NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
               switch (strCode.integerValue) {
                   case 0: {
                       [self.controlBar setAttentionStatus:YES];
                       [indicator_oper stopAnimation];
                       [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"关注成功"] show];
                       break;
                   }
                   case 1: {
                       [self handleHttpFailed:YES];
                       break;
                   }
                   case 2: {
                       [indicator_oper stopAnimation];
                       [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"关注已达上限"] show];
                       break;
                   }
                   case 3: {
                       [indicator_oper stopAnimation];
                       [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"你已关注过该用户"] show];
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

- (void)deattente {
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(deattente) object:nil];
        return;
    }
    
    if (!indicator_oper) {
        indicator_oper = [LyIndicator indicatorWithTitle:LyIndicatorTitle_deattente];
    } else {
        [indicator_oper setTitle:LyIndicatorTitle_deattente];
    }
    [indicator_oper startAnimation];
    
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:removeAttention_url
                    body:@{
                           userIdKey:[LyCurrentUser curUser].userId,
                           objectIdKey:school.userId,
                           sessionIdKey:[LyUtil httpSessionId]
                           }
                    type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
           if (error) {
               [self handleHttpFailed:YES];
           } else {
               NSDictionary *dic = [self analysisHttpResult:resStr];
               if (!dic) {
                   [self handleHttpFailed:YES];
                   return;
               }
               
               NSString *strCode = [[NSString alloc] initWithFormat:@"%@" ,[dic objectForKey:codeKey]];
               switch (strCode.integerValue) {
                   case 0: {
                       [self.controlBar setAttentionStatus:NO];
                       [indicator_oper stopAnimation];
                       [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"取关成功"] show];
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




#pragma mark -LyAddSchoolTableViewControllerDelegate
- (LyAddTeacherMode)obtainModeViewControllerModeByAddSchoolTableViewController:(LyAddSchoolTableViewController *)aAddSchool
{
    return LyAddTeacherMode_replace;
}

- (void)addSchoolFinishedByAddSchoolTableViewController:(LyAddSchoolTableViewController *)aAddSchool andDriveSchool:(LyDriveSchool *)aDriveSchool
{
    [aAddSchool.navigationController popViewControllerAnimated:YES];
    
    [[LyCurrentUser curUser] setUserDriveSchoolId:[aDriveSchool userId]];
    [[LyCurrentUser curUser] setUserDriveSchoolName:[aDriveSchool userName]];
    [[LyUserManager sharedInstance] addUser:aDriveSchool];
    
    [self load];
}


#pragma mark -LyTrainBasePickerDelegate
- (void)onCancelByTrainBasePicker:(LyTrainBasePicker *)aTrainBasePicker {
    [aTrainBasePicker hide];
}

- (void)onDoneByaTrainBasePicker:(LyTrainBasePicker *)aTrainBasePicker trainBase:(LyTrainBase *)trainBase {
    [aTrainBasePicker hide];

    [self setCurTrainBase:trainBase];
    
    [self loadTrainCoach];
}


#pragma mark -LyTrainBaseTableViewControllerDelegate
- (NSString *)obtainDriveSchoolIdByTrainBaseTableViewController:(LyTrainBaseTableViewController *)aTrainBase
{
    return [[LyCurrentUser curUser] userDriveSchoolId];
}

- (NSArray *)obtainArrTrainBaseByTrainBaseTableViewController:(LyTrainBaseTableViewController *)aTrainBase
{
    return msArrTrainBase;
}


#pragma mark -LyCoachTableViewControllerDelegate
- (NSDictionary *)obtainCoachInfoByCoachTableViewController:(LyCoachTableViewController *)aCoach
{
    return @{
             driveSchoolIdKey:school.userId,
             trainBaseIdKey:self.curTrainBase.tbId,
             subjectModeKey:@(self.curSubject),
             coachKey:msArrCoach
             };
}


#pragma mark -LyDetailControlBarDelegate
- (void)onClickedButtonAttente {
    if ( [self.controlBar attentionStatus]) {
        
        UIAlertController *action = [UIAlertController alertControllerWithTitle:[[NSString alloc] initWithFormat:@"你确定不再关注「%@」吗？", school.userName]
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
        [action addAction:[UIAlertAction actionWithTitle:@"取消"
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
        [action addAction:[UIAlertAction actionWithTitle:@"不再关注"
                                                   style:UIAlertActionStyleDestructive
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     [self deattente];
                                                 }]];
        [self presentViewController:action animated:YES completion:nil];
    } else {
        [self attente];
    }
}

- (void)onClickedButtonPhone {
    [LyUtil call:phoneNum_517];
}


- (void)onClickedButtonMessage {
    [LyUtil sendSMS:nil
         recipients:@[messageNum_517]
             target:self];
}



#pragma mark -MFMessageComposeViewControllerDelegate
// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    [NSThread sleepForTimeInterval:sleepTime];
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled) {
        [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"短信发送取消"] show];
    } else if (result == MessageComposeResultSent) {
        [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"短信发送成功"] show];
    } else {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"短信发送失败"] show];
    }
}


#pragma mark -LyReservateCoachViewControllerDelegate
- (NSDictionary *)obtainCoachObjectByReservateCoachViewController:(LyReservateCoachViewController *)aReservateCoach
{
//    LyCoachTableViewCell *cell = [self.tvCoach cellForRowAtIndexPath:curIdx_coachList];
    
    return @{
             coachIdKey:[[msArrCoach objectAtIndex:curIdx_coach.row] userId],
             subjectModeKey:@(self.curSubject)
             };
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0;
    
    LyMySchoolTableViewTag tvTag = tableView.tag;
    switch (tvTag) {
        case mySchoolTableViewTag_trainClass: {
            cellHeight = tcHeight;
            break;
        }
        case mySchoolTableViewTag_trainBase: {
            cellHeight = tbcellHeight;
            break;
        }
        case mySchoolTableViewTag_coach: {
            cellHeight = COACHCELLHEIGHT;
            break;
        }
        default:
            break;
    }
    
    return cellHeight;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (mySchoolTableViewTag_coach == tableView.tag) {
        curIdx_coach = indexPath;
        
        LyCoach *coach = msArrCoach[indexPath.row];
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        if (coach.timeFlag)
        {
            LyReservateCoachViewController *reservateCoach = [[LyReservateCoachViewController alloc] init];
            [reservateCoach setDelegate:self];
            [self.navigationController pushViewController:reservateCoach animated:YES];
        }
    }
}


#pragma mark -UITableViewDatSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger iCount = 0;
    
    LyMySchoolTableViewTag tvTag = tableView.tag;
    switch (tvTag) {
        case mySchoolTableViewTag_trainClass: {
            iCount = (myTcId) ? 1 : 0;
            break;
        }
        case mySchoolTableViewTag_trainBase: {
            iCount = (msArrTrainBase.count > 2) ? 2 : msArrTrainBase.count;
            break;
        }
        case mySchoolTableViewTag_coach: {
            iCount = msArrCoach.count > 5 ? 5 : msArrCoach.count;
            break;
        }
    }
    
    return iCount;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *uCell = nil;
    
    LyMySchoolTableViewTag tvTag = tableView.tag;
    switch (tvTag) {
        case mySchoolTableViewTag_trainClass: {
            LyTrainClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyMySchoolTvTrainClassCellReuseIdentifier forIndexPath:indexPath];
            if (!cell) {
                cell = [[LyTrainClassTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyMySchoolTvTrainClassCellReuseIdentifier];
            }
            [cell setTrainClass:[[LyTrainClassManager sharedInstance] getTrainClassWithTrainClassId:myTcId]];
            [cell setMode:trainClassTableViewCellMode_mySchool];
            
            uCell = cell;
            break;
        }
        case mySchoolTableViewTag_trainBase: {
            LyTrainBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyMySchoolTvTrainBaseCellReuseIdentifier forIndexPath:indexPath];
            if ( !cell)
            {
                cell = [[LyTrainBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyMySchoolTvTrainBaseCellReuseIdentifier];
            }
            [cell setTrainBase:msArrTrainBase[indexPath.row]];
            
            uCell = cell;
            break;
        }
        case mySchoolTableViewTag_coach: {
            LyCoachTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyMySchoolTvCoachCellReuseIdentifier forIndexPath:indexPath];
            if (!cell) {
                cell = [[LyCoachTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyMySchoolTvCoachCellReuseIdentifier];
            }
            
            [cell setCoach:msArrCoach[indexPath.row]];
            [cell setMode:coachTableViewCellMode_mySchool];
            
            uCell = cell;
            break;
        }
    }
    
    
    return uCell;
}




#pragma mark -UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.ly_offsetY < 0)
    {
        CGFloat newHeight = msViewInfoHeight - scrollView.ly_offsetY;
        CGFloat newWidth = SCREEN_WIDTH * newHeight / msViewInfoHeight;
        
        CGFloat newX = (SCREEN_WIDTH - newWidth) / 2.0;
        CGFloat newY = scrollView.ly_offsetY;
        
        ivBack.frame = CGRectMake(newX, newY, newWidth, newHeight);
    }
    else
    {
        ivBack.frame = CGRectMake(0, 0, SCREEN_WIDTH, msViewInfoHeight);
    }

    
    if ( [self.svMain contentOffset].y > msViewInfoHeight - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT) {
        self.title = @"我的驾校";
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    } else {
        self.title = nil;
        [self.navigationController.navigationBar setBackgroundImage:[LyUtil imageForImageName:@"uci_navigatinBar" needCache:NO] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController navigationBar].shadowImage = [LyUtil imageForImageName:@"uci_navigatinBar" needCache:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
