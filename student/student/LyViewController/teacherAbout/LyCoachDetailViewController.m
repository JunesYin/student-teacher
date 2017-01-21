//
//  LyCoachDetailViewController.m
//  student
//
//  Created by MacMini on 2016/12/23.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyCoachDetailViewController.h"
#import "LyTrainClassTableViewCell.h"
#import "LyDriveSchoolDetailPicCollectionViewCell.h"
#import "LyEvaluationForTeacherTableViewCell.h"
#import "LyConsultTableViewCell.h"
#import "LyDetailControlBar.h"

#import "SDPhotoBrowser.h"
#import "LySynopsisView.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyUserManager.h"
#import "LyEvaluationForTeacher.h"
#import "LyConsultManager.h"

#import "NSString+Validate.h"
#import "UIView+LyExtension.h"
#import "UIScrollView+LyExtension.h"
#import "LyUtil.h"

#import "student-Swift.h"
#import <WebKit/WebKit.h>

#import <MessageUI/MessageUI.h>

#import "LyTrainClassDetailViewController.h"
#import "LyCreateOrderViewController.h"
#import "LyTeachByTimeDetailViewController.h"
#import "LyEvaluationForTeacherTableViewController.h"
#import "LyEvaluationForTeacherDetailTableViewController.h"
#import "LyConsultTableViewController.h"
#import "LyConsultDetailTableViewController.h"



CGFloat const cdViewInfoHeight = 210;

CGFloat const cdIvAvatarSize = 60;
CGFloat const cdIvFlagSize = 20;
CGFloat const cdLbNameHeight = 20;
#define cdLbNameFont                LyFont(18)

CGFloat const cdLbAddressHeight = cdLbNameHeight;
#define cdLbAddressFont             LyFont(14)

CGFloat const cdLbAgeHeight = cdLbNameHeight;
#define cdLbAgeFont                 LyFont(12)

#define cdLbPerFont                 LyFont(12)


CGFloat const cdLbTimeFlagWidth = 120;
CGFloat const cdLbTimeFlagHeight = 15;
#define cdLbTimeFlagFont            LyFont(13)

CGFloat const cdBtnTimeDetailWidth = 100;
CGFloat const cdBtnTimeDetailHeight = cdLbTimeFlagHeight;
#define cdBtnTimeDetailFont         cdLbTimeFlagFont


#define cdTvSynFont                 cdLbTimeFlagFont


int const cdCvPicSingleLineNum = 3;
#define cdCvItemSize                ((SCREEN_WIDTH - verticalSpace * (cdCvPicSingleLineNum * 2)) / 3)
#define cdCvPicHeight               (cdCvItemSize + verticalSpace * 2)



typedef NS_ENUM(NSInteger, LyCoachDetailTableViewTag) {
    coachDetailTableViewTag_tc = 10,
    coachDetailTableViewTag_eva,
    coachDetailTableViewTag_con
};

typedef NS_ENUM(NSInteger, LyCoachDetailButtonTag) {
    coachDetailButtonTag_timeDetail = 20,
    coachDetailButtonTag_func_syn,
    coachDetailButtonTag_func_pic,
    coachDetailButtonTag_func_eva,
    coachDetailButtonTag_func_con,
    coachDetailButtonTag_func_ask
};

@interface LyCoachDetailViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MFMessageComposeViewControllerDelegate, LyDetailControlBarDelegate, LyDriveSchoolDetailPicCollectionViewCellDelegate, SDPhotoBrowserDelegate, LyTrainClassTableViewCellDelegate, LyTrainClassDetailViewControllerDelegate, LyCreateOrderViewControllerDelegate, LyConsultTableViewControllerDelegate, LyConsultDetailTableViewControllerDelegate, LyEvaluationForTeacherTableViewControllerDelegate, LyEvaluationForTeacherDetailTableViewControllerDelegate, LyAskViewControllerDelegate>
{
    UIView      *viewError;
    
    UIScrollView        *svMain;
    
    UIView      *viewInfo;
    UIImageView     *ivBack;
    UIImageView     *ivAvatar;
    UIImageView     *ivVerifyFlag;
    UILabel     *lbName;
    UIImageView     *ivSex;
    UILabel     *lbAddress;
    UILabel     *lbAge;
    UILabel     *lbTeachedAge;
    UILabel     *lbDrivedAge;
    UILabel     *lbPerPass;
    UILabel     *lbPerPraise;
    UILabel     *lbAllCount;
    
    UIView      *viewClass;
    UILabel     *lbTitle_tc;
    //self.tvTc
    
    UIView      *viewSynopsis;
    UILabel     *lbTitle_syn;
    UILabel     *lbMaster;
    UILabel     *lbTimeFlag;
    UIButton        *btnTimeDetail;
    UITextView      *tvSyn;
    UIButton        *btnFunc_syn;
    
    UIView      *viewPic;
    UILabel     *lbTitle_pic;
    //self.cvPic
    UIButton        *btnFunc_pic;
    
    UIView      *viewEva;
    UILabel     *lbTitle_eva;
    //self.tvEva
    UIButton        *btnFunc_eva;
    
    UIView      *viewCon;
    UILabel     *lbTitle_con;
    //self.tvCon
    UIButton        *btnFunc_con;
    
    UIButton        *btnAsk;
    
    LyCoach     *coach;
    NSArray     *arrClass;
    NSMutableDictionary     *dicPics;
    LyEvaluationForTeacher      *eva;
    LyConsult       *con;
    
    NSIndexPath     *curIdx_tc;
    
    BOOL        bFlagSetEva;
    BOOL        bFlagSetCon;
    BOOL        bFlagSuccess;
}

@property (strong, nonatomic)       UIRefreshControl        *refreshControl;

@property (strong, nonatomic)       UITableView     *tvTc;
@property (strong, nonatomic)       UILabel     *lbNull_tc;
@property (strong, nonatomic)       UICollectionView        *cvPic;
@property (strong, nonatomic)       UILabel     *lbNull_pic;
@property (strong, nonatomic)       UITableView     *tvEva;
@property (strong, nonatomic)       UILabel     *lbNull_eva;
@property (strong, nonatomic)       UITableView     *tvCon;
@property (strong, nonatomic)       UILabel     *lbNull_con;

@property (strong, nonatomic)       LyDetailControlBar      *controlBar;


@property (strong, nonatomic)       LyIndicator     *indicator;
@property (strong, nonatomic)       LyIndicator     *indicator_oper;

@end

@implementation LyCoachDetailViewController

static NSString *const lyCoachDetailTrainClassTableViewCellReuseIdentifier = @"lyCoachDetailTrainClassTableViewCellReuseIdentifier";
static NSString *const lyCoachDetailPicCollectionViewCellReuseIdentifier = @"lyCoachDetailPicCollectionViewCellReuseIdentifier";
static NSString *const lyCoachDetailEvaluationTableViewCellReuseIdentifier = @"lyCoachDetailEvaluationTableViewCellReuseIdentifier";
static NSString *const lyCoachDetailConsultTableViewCellReuseIdentifier = @"lyCoachDetailConsultTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    if (bFlagSuccess) {
        return;
    }
    
    _coachId = [_delegate coachIdByCoachDetailViewController:self];
    if (!_coachId) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[LyUtil imageForImageName:@"uci_navigatinBar" needCache:NO] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController navigationBar].shadowImage = [LyUtil imageForImageName:@"uci_navigatinBar" needCache:NO];
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    coach = [[LyUserManager sharedInstance] getCoachWithCoachId:_coachId];
    
    [self load];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)initSubviews {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = LyWhiteLightgrayColor;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - dcbHeight)];
    svMain.delegate = self;
    
    
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cdViewInfoHeight)];
    viewInfo.backgroundColor = [UIColor whiteColor];
    
    ivBack = [[UIImageView alloc] initWithFrame:viewInfo.frame];
    ivBack.contentMode = UIViewContentModeScaleAspectFill;
    ivBack.clipsToBounds = YES;
    ivBack.image = [LyUtil imageForImageName:@"chd_background" needCache:NO];
    
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f - cdIvAvatarSize/2.0f, cdViewInfoHeight/2.0f - (cdLbNameHeight * 4 + verticalSpace * 2)/2.0f, cdIvAvatarSize, cdIvAvatarSize)];
    ivAvatar.contentMode = UIViewContentModeScaleAspectFill;
    ivAvatar.clipsToBounds = YES;
    ivAvatar.layer.cornerRadius = btnCornerRadius;
    
    ivVerifyFlag = [[UIImageView alloc] initWithFrame:CGRectMake(ivAvatar.frame.origin.x + cdIvAvatarSize, ivAvatar.frame.origin.y + cdIvAvatarSize - cdIvFlagSize, cdIvFlagSize, cdIvFlagSize)];
    ivVerifyFlag.image = [LyUtil imageForImageName:@"dsd_certificate_flag" needCache:NO];
    
    lbName = [UILabel new];
    lbName.font = cdLbNameFont;
    lbName.textColor = [UIColor whiteColor];
    
    ivSex = [UIImageView new];
    
    lbAddress = [[UILabel alloc] initWithFrame:CGRectMake(0, ivAvatar.frame.origin.y + cdIvAvatarSize + cdLbNameHeight + verticalSpace * 2, SCREEN_WIDTH, cdLbNameHeight)];
    lbAddress.font = cdLbAddressFont;
    lbAddress.textColor = [UIColor whiteColor];
    lbAddress.textAlignment = NSTextAlignmentCenter;
    
    lbAge = [UILabel new];
    lbAge.font = cdLbAgeFont;
    lbAge.textColor = [UIColor whiteColor];
    
    lbTeachedAge = [UILabel new];
    lbTeachedAge.font = cdLbAgeFont;
    lbTeachedAge.textColor = [UIColor whiteColor];
    
    lbDrivedAge = [UILabel new];
    lbDrivedAge.font = cdLbAgeFont;
    lbDrivedAge.textColor = [UIColor whiteColor];
    
    lbPerPass = [UILabel new];
    lbPerPass.font = cdLbPerFont;
    lbPerPass.textColor = [UIColor whiteColor];
    
    lbPerPraise = [UILabel new];
    lbPerPraise.font = cdLbPerFont;
    lbPerPraise.textColor = [UIColor whiteColor];
    
    lbAllCount = [UILabel new];
    lbAllCount.font = cdLbPerFont;
    lbAllCount.textColor = [UIColor whiteColor];
    
    [viewInfo addSubview:ivBack];
    [viewInfo addSubview:ivAvatar];
    [viewInfo addSubview:ivVerifyFlag];
    [viewInfo addSubview:lbName];
    [viewInfo addSubview:ivSex];
    [viewInfo addSubview:lbAddress];
    [viewInfo addSubview:lbAge];
    [viewInfo addSubview:lbTeachedAge];
    [viewInfo addSubview:lbDrivedAge];
    [viewInfo addSubview:lbPerPass];
    [viewInfo addSubview:lbPerPraise];
    [viewInfo addSubview:lbAllCount];
    
    
    
    viewClass = [UIView new];
    viewClass.backgroundColor = [UIColor whiteColor];
    
    lbTitle_tc = [self lbTitleWith:@"培训课程"];
    
    //self.tvTc
    
    //self.lbNull_tc
    
    [viewClass addSubview:lbTitle_tc];
    
    
    
    viewSynopsis = [UIView new];
    viewSynopsis.backgroundColor = [UIColor whiteColor];
    
    lbTitle_syn = [self lbTitleWith:@"教练简介"];
    
    lbMaster = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, LyLbTitleItemHeight, SCREEN_WIDTH - horizontalSpace * 2, cdLbTimeFlagHeight)];
    lbMaster.font = cdLbTimeFlagFont;
    lbMaster.textColor = LyBlackColor;
    lbMaster.textAlignment = NSTextAlignmentLeft;
    
    lbTimeFlag = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, LyLbTitleItemHeight + cdLbTimeFlagHeight, cdLbTimeFlagWidth, cdLbTimeFlagHeight)];
    lbTimeFlag.font = cdLbTimeFlagFont;
    lbTimeFlag.textColor = LyBlackColor;
    lbTimeFlag.textAlignment = NSTextAlignmentLeft;
    
    btnTimeDetail = [[UIButton alloc] initWithFrame:CGRectMake(cdLbTimeFlagWidth + horizontalSpace * 2, LyLbTitleItemHeight + cdLbTimeFlagHeight, cdBtnTimeDetailWidth, cdLbTimeFlagHeight)];
    btnTimeDetail.tag = coachDetailButtonTag_timeDetail;
    btnTimeDetail.titleLabel.font = cdBtnTimeDetailFont;
    [btnTimeDetail setTitle:@"查看详情" forState:UIControlStateNormal];
    [btnTimeDetail setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnTimeDetail addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    tvSyn = [UITextView new];
    tvSyn.font = cdTvSynFont;
    tvSyn.textColor = LyDarkgrayColor;
    tvSyn.selectable = NO;
    tvSyn.editable = NO;
    tvSyn.scrollEnabled = NO;
    tvSyn.textAlignment = NSTextAlignmentLeft;
    tvSyn.textContainer.maximumNumberOfLines = synopsisLinesMax;
    tvSyn.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    
    btnFunc_syn = [self btnFuncWith:coachDetailButtonTag_func_syn];
    
    [viewSynopsis addSubview:lbTitle_syn];
    [viewSynopsis addSubview:lbMaster];
    [viewSynopsis addSubview:lbTimeFlag];
    [viewSynopsis addSubview:btnTimeDetail];
    [viewSynopsis addSubview:tvSyn];
    [viewSynopsis addSubview:btnFunc_syn];
    
    
    
    viewPic = [UIView new];
    viewPic.backgroundColor = [UIColor whiteColor];
    
    lbTitle_pic = [self lbTitleWith:@"教练环境"];
    
    //self.cvPic
    
    //self.lbNull_pic
    
    btnFunc_pic = [self btnFuncWith:coachDetailButtonTag_func_pic];
    
    [viewPic addSubview:lbTitle_pic];
    [viewPic addSubview:btnFunc_pic];
    
    
    
    viewEva = [UIView new];
    viewEva.backgroundColor = [UIColor whiteColor];
    
    lbTitle_eva = [self lbTitleWith:@"学员评价"];
    
    //self.tvEva
    
    //self.lbNull_eva
    
    btnFunc_eva = [self btnFuncWith:coachDetailButtonTag_func_eva];
    
    [viewEva addSubview:lbTitle_eva];
    [viewEva addSubview:btnFunc_eva];
    
    
    
    
    viewCon = [UIView new];
    viewCon.backgroundColor = [UIColor whiteColor];
    
    lbTitle_con = [self lbTitleWith:@"提问咨询"];
    
    //self.tvCon
    
    //self.lbNull_con
    
    btnFunc_con = [self btnFuncWith:coachDetailButtonTag_func_con];
    
    [viewCon addSubview:lbTitle_con];
    [viewCon addSubview:btnFunc_con];
    
    
    
    btnAsk = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAsk.tag = coachDetailButtonTag_func_ask;
    [btnAsk setTitle:@"我要提问" forState:UIControlStateNormal];
    [btnAsk setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnAsk addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [svMain addSubview:viewInfo];
    [svMain addSubview:viewClass];
    [svMain addSubview:viewSynopsis];
    [svMain addSubview:viewPic];
    [svMain addSubview:viewEva];
    [svMain addSubview:viewCon];
    [svMain addSubview:btnAsk];
    
    [svMain addSubview:self.refreshControl];
    
    
    [self.view addSubview:svMain];
    [self.view addSubview:self.controlBar];
    
    
    svMain.hidden = YES;
    self.controlBar.hidden = YES;
}


- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [LyUtil refreshControlWithTitle:nil target:self action:@selector(refresh)];
    }
    
    return _refreshControl;
}

- (UITableView *)tvTc {
    if (!_tvTc) {
        _tvTc = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tvTc.tag = coachDetailTableViewTag_tc;
        _tvTc.delegate = self;
        _tvTc.dataSource = self;
        _tvTc.scrollEnabled = NO;
    }
    
    return _tvTc;
}

- (UILabel *)lbNull_tc {
    if (!_lbNull_tc) {
        _lbNull_tc = [self lbNullWith:@"还没有培训课程"];
    }
    
    return _lbNull_tc;
}

- (UICollectionView *)cvPic {
    if (!_cvPic) {
        UICollectionViewFlowLayout *sdCvFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        [sdCvFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [sdCvFlowLayout setMinimumLineSpacing:verticalSpace];
        [sdCvFlowLayout setMinimumInteritemSpacing:verticalSpace];
        
        _cvPic = [[UICollectionView alloc] initWithFrame:CGRectMake(0, LyLbTitleItemHeight, SCREEN_WIDTH, cdCvPicHeight)
                                    collectionViewLayout:sdCvFlowLayout];
        _cvPic.delegate = self;
        _cvPic.dataSource = self;
        _cvPic.scrollsToTop = NO;
        _cvPic.backgroundColor = [UIColor whiteColor];
        _cvPic.showsVerticalScrollIndicator = NO;
        _cvPic.showsHorizontalScrollIndicator = NO;
        [_cvPic registerClass:[LyDriveSchoolDetailPicCollectionViewCell class] forCellWithReuseIdentifier:lyCoachDetailPicCollectionViewCellReuseIdentifier];
    }
    
    return _cvPic;
}

- (UILabel *)lbNull_pic {
    if (!_lbNull_pic) {
        _lbNull_pic = [self lbNullWith:@"还没有教学环境"];
    }
    
    return _lbNull_pic;
}

- (UITableView *)tvEva {
    if (!_tvEva) {
        _tvEva = [[UITableView alloc] initWithFrame:CGRectZero
                                              style:UITableViewStylePlain];
        _tvEva.tag = coachDetailTableViewTag_eva;
        _tvEva.delegate = self;
        _tvEva.dataSource = self;
        _tvEva.scrollEnabled = NO;
    }
    
    return _tvEva;
}

- (UILabel *)lbNull_eva {
    if (!_lbNull_eva) {
        _lbNull_eva = [self lbNullWith:@"还没有评价"];
    }
    
    return _lbNull_eva;
}

- (UITableView *)tvCon {
    if (!_tvCon) {
        _tvCon = [[UITableView alloc] initWithFrame:CGRectZero
                                              style:UITableViewStylePlain];
        _tvCon.tag = coachDetailTableViewTag_con;
        _tvCon.delegate = self;
        _tvCon.dataSource = self;
        _tvCon.scrollEnabled = NO;
    }
    
    return _tvCon;
}

- (UILabel *)lbNull_con {
    if (!_lbNull_con) {
        _lbNull_con = [self lbNullWith:@"还没有人提问"];
    }
    
    return _lbNull_con;
}

- (LyDetailControlBar *)controlBar {
    if (!_controlBar) {
        _controlBar = [LyDetailControlBar controlBarWidthMode:LyDetailControlBarMode_chDsGe];
        _controlBar.delegate = self;
    }
    
    return _controlBar;
}

- (LyIndicator *)indicator {
    if (!_indicator) {
        _indicator = [LyIndicator indicatorWithTitle:nil];
    }
    
    return _indicator;
}

- (LyIndicator *)indicator_oper {
    if (!_indicator_oper) {
        _indicator_oper = [LyIndicator indicatorWithTitle:nil];
    }
    
    return _indicator_oper;
}

- (UILabel *)lbTitleWith:(NSString *)title
{
    UILabel *itemTitleView = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, 0, 200, LyLbTitleItemHeight)];
    [itemTitleView setText:title];
    [itemTitleView setTextColor:Ly517ThemeColor];
    [itemTitleView setFont:LyFont(16)];
    [itemTitleView setTextAlignment:NSTextAlignmentLeft];
    
    return itemTitleView;
}

- (UILabel *)lbNullWith:(NSString *)text
{
    UILabel *lb = [LyUtil lbNullWithText:text];
    lb.frame = CGRectMake(0, LyLbTitleItemHeight, SCREEN_WIDTH, LyNullItemHeight);
    
    return lb;
}

- (UIButton *)btnFuncWith:(LyCoachDetailButtonTag)btnTag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = btnTag;
    btn.titleLabel.font = LyBtnMoreTitleFont;
    [btn setTitle:@"更多" forState:UIControlStateNormal];
    [btn setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    [btn setHidden:YES];
    
    return btn;
}

- (void)showViewError {
    bFlagSuccess = NO;
    
    if (!viewError) {
        viewError = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 1.5)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        [viewError addSubview:[LyUtil lbErrorWithMode:0]];
    }
    [svMain setHidden:NO];
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 1.05)];
    [svMain addSubview:viewError];
}

- (void)removeViewError {
    bFlagSuccess = YES;
    
    [viewError removeFromSuperview];
    viewError = nil;
}


- (void)reloadData {
    
    [self removeViewError];
    
    svMain.hidden = NO;
    self.controlBar.hidden = NO;
    
    if (!coach.userAvatar) {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:_coachId]
                    placeholderImage:[LyUtil defaultAvatarForTeacher]
                           completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                               if (image) {
                                   coach.userAvatar = image;
                                   
                               } else {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:_coachId]
                                               placeholderImage:[LyUtil defaultAvatarForTeacher]
                                                      completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                                          if (image) {
                                                              coach.userAvatar = image;
                                                          }
                                                      }];
                               }
                           }];
        
    } else {
        ivAvatar.image = coach.userAvatar;
    }
    
    ivVerifyFlag.hidden = LyTeacherVerifyState_access == coach.coaVerifyState ? NO : YES;
    
    CGFloat fWidthLbName = [coach.userName sizeWithAttributes:@{NSFontAttributeName : lbName.font}].width;
    lbName.frame = CGRectMake(SCREEN_WIDTH/2.0f - (fWidthLbName + horizontalSpace + ivSexSize)/2.0, ivAvatar.frame.origin.y + cdIvAvatarSize + verticalSpace, fWidthLbName, cdLbNameHeight);
    lbName.text = coach.userName;
    
    ivSex.frame = CGRectMake(lbName.frame.origin.x + fWidthLbName + horizontalSpace, lbName.frame.origin.y + cdLbNameHeight/2.0f - ivSexSize/2.0f, ivSexSize, ivSexSize);
    [LyUtil setSexImageView:ivSex withUserSex:coach.userSex];
    
    lbAddress.text = [LyUtil validateString:coach.userAddress] ? [[NSString alloc] initWithFormat:@"住址：%@", coach.userAddress] : @"住址：暂无";
    
    NSString *sAge = [[NSString alloc] initWithFormat:@"年龄：%d岁", coach.userAge];
    NSString *sTeachedAge = [[NSString alloc] initWithFormat:@"教龄：%d年", coach.coaTeachedAge];
    NSString *sDrivedAge = [[NSString alloc] initWithFormat:@"驾龄：%d年", coach.coaDrivedAge];
    CGFloat fWidthLbAge = [sAge sizeWithAttributes:@{NSFontAttributeName : lbAge.font}].width;
    CGFloat fWidthLbTeachedAge = [sTeachedAge sizeWithAttributes:@{NSFontAttributeName : lbTeachedAge.font}].width;
    CGFloat fWidthLbDrivedAge = [sDrivedAge sizeWithAttributes:@{NSFontAttributeName : lbDrivedAge.font}].width;
    lbAge.frame = CGRectMake(SCREEN_WIDTH/2.0f - (fWidthLbAge + fWidthLbTeachedAge + fWidthLbDrivedAge + horizontalSpace * 2)/2.0, lbAddress.frame.origin.y + CGRectGetHeight(lbAddress.frame), fWidthLbAge, cdLbNameHeight);
    lbTeachedAge.frame = CGRectMake(lbAge.frame.origin.x + fWidthLbAge + horizontalSpace, lbAge.frame.origin.y, fWidthLbTeachedAge, cdLbNameHeight);
    lbDrivedAge.frame = CGRectMake(lbTeachedAge.frame.origin.x + fWidthLbTeachedAge + horizontalSpace, lbAge.frame.origin.y, fWidthLbDrivedAge, cdLbNameHeight);
    lbAge.text = sAge;
    lbTeachedAge.text = sTeachedAge;
    lbDrivedAge.text = sDrivedAge;
    
    NSString *sPerPassNum = coach.perPass;
    NSString *sPerPraiseNum = coach.perPraise;
    NSString *sAllCountNum = [[NSString alloc] initWithFormat:@"%d", coach.stuAllCount];
    NSString *sPerPassTmp = [[NSString alloc] initWithFormat:@"通过率：%@", sPerPassNum];
    NSString *sPerPraiseTmp = [[NSString alloc] initWithFormat:@"好评率：%@", sPerPraiseNum];
    NSString *sAllCountTmp = [[NSString alloc] initWithFormat:@"已教：%@人", sAllCountNum];
    CGFloat fWidthPerPass = [sPerPassTmp sizeWithAttributes:@{NSFontAttributeName : lbPerPass.font}].width;
    CGFloat fWidthPerPraise = [sPerPraiseTmp sizeWithAttributes:@{NSFontAttributeName : lbPerPraise.font}].width;
    CGFloat fWidthAllCount = [sAllCountTmp sizeWithAttributes:@{NSFontAttributeName : lbAllCount.font}].width;
    NSMutableAttributedString *sPerPass = [[NSMutableAttributedString alloc] initWithString:sPerPassTmp];
    NSMutableAttributedString *sPerPraise = [[NSMutableAttributedString alloc] initWithString:sPerPraiseTmp];
    NSMutableAttributedString *sAllCount = [[NSMutableAttributedString alloc] initWithString:sAllCountTmp];
    [sPerPass addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[sPerPassTmp rangeOfString:sPerPassNum]];
    [sPerPraise addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[sPerPraiseTmp rangeOfString:sPerPraiseNum]];
    [sAllCount addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[sAllCountTmp rangeOfString:sAllCountNum]];
    lbPerPass.frame = CGRectMake(SCREEN_WIDTH/2.0f - (fWidthPerPass + fWidthPerPraise + fWidthAllCount + horizontalSpace * 2)/2.0, lbAge.frame.origin.y + CGRectGetHeight(lbAge.frame), fWidthPerPass, cdLbNameHeight);
    lbPerPraise.frame = CGRectMake(lbPerPass.frame.origin.x + fWidthPerPass + horizontalSpace, lbPerPass.frame.origin.y, fWidthPerPraise, cdLbNameHeight);
    lbAllCount.frame = CGRectMake(lbPerPraise.frame.origin.x + fWidthPerPraise + horizontalSpace, lbPerPass.frame.origin.y, fWidthAllCount, cdLbNameHeight);
    lbPerPass.attributedText = sPerPass;
    lbPerPraise.attributedText = sPerPraise;
    lbAllCount.attributedText = sAllCount;
    
    
    
    CGFloat fHeightViewClass = 0;
    if (![LyUtil validateArray:arrClass]) {
        [_tvTc removeFromSuperview];
        [viewClass addSubview:self.lbNull_tc];
        
        fHeightViewClass = LyLbTitleItemHeight + LyNullItemHeight;
        
    } else {
        [_lbNull_tc removeFromSuperview];
        [viewClass addSubview:self.tvTc];
        
        CGFloat fHeightTvTc = tcHeight * arrClass.count;
        self.tvTc.frame = CGRectMake(0, LyLbTitleItemHeight, SCREEN_WIDTH, fHeightTvTc);
        [self.tvTc reloadData];
        
        fHeightViewClass = LyLbTitleItemHeight + fHeightTvTc;
        
    }
    viewClass.frame = CGRectMake(0, cdViewInfoHeight, SCREEN_WIDTH, fHeightViewClass);
    
    
    
    CGFloat fHeightViewSyn = 0;
    
    lbMaster.text = [[NSString alloc] initWithFormat:@"所属驾校：%@", ({
        NSString *masterName = @"匿名用户";
        if ([LyUtil validateString:coach.coaMasterId]) {
            masterName = [[LyUserManager sharedInstance] getUserNameWithId:coach.coaMasterId];
            if (![LyUtil validateString:masterName]) {
                masterName = [LyUtil getUserNameWithUserId:coach.coaMasterId];
            }
        }
        
        masterName;
    })];
    
    lbTimeFlag.text = coach.timeFlag ? @"计时培训：支持" : @"计时培训：不支持";
    
    btnTimeDetail.hidden = !coach.timeFlag;
    
    if (![LyUtil validateString:coach.coaDescription]) {
        tvSyn.hidden = YES;
        btnFunc_syn.hidden = YES;
        fHeightViewSyn = LyLbTitleItemHeight + cdLbTimeFlagHeight * 2;
        
    } else {
        tvSyn.hidden = NO;
        
        UITextView *tvTmp = [[UITextView alloc] init];
        tvTmp.font = tvSyn.font;
        tvTmp.text = coach.coaDescription;
        CGFloat fHeightTvTmp =  [tvTmp sizeThatFits:CGSizeMake(SCREEN_WIDTH - horizontalSpace * 2, MAXFLOAT)].height;
        
        tvSyn.text = coach.coaDescription;
        CGFloat fHeightTvSyn = [tvSyn sizeThatFits:CGSizeMake(SCREEN_WIDTH - horizontalSpace * 2, CGFLOAT_MAX)].height;
        if (fHeightTvTmp > fHeightTvSyn) {
            tvSyn.frame = CGRectMake(horizontalSpace, lbTimeFlag.frame.origin.y + CGRectGetHeight(lbTimeFlag.frame), SCREEN_WIDTH - horizontalSpace * 2, fHeightTvSyn);
            btnFunc_syn.hidden = NO;
            btnFunc_syn.frame = CGRectMake(SCREEN_WIDTH - horizontalSpace - LyBtnMoreWidth, tvSyn.frame.origin.y + CGRectGetHeight(tvSyn.frame), LyBtnMoreWidth, LyBtnMoreHeight);
            
        } else {
            tvSyn.frame = CGRectMake(horizontalSpace, lbTimeFlag.frame.origin.y + CGRectGetHeight(lbTimeFlag.frame), SCREEN_WIDTH - horizontalSpace * 2, fHeightTvTmp);
            btnFunc_syn.frame = CGRectMake(SCREEN_WIDTH - horizontalSpace - LyBtnMoreWidth, tvSyn.frame.origin.y + CGRectGetHeight(tvSyn.frame), LyBtnMoreWidth, 0);
        }
        
        fHeightViewSyn = btnFunc_syn.frame.origin.y + CGRectGetHeight(btnFunc_syn.frame);
    }
    
    viewSynopsis.frame = CGRectMake(0, viewClass.frame.origin.y + CGRectGetHeight(viewClass.frame) + verticalSpace, SCREEN_WIDTH, fHeightViewSyn);
    
    
    
    
    CGFloat fHeightViewPic = 0;
    if (![LyUtil validateArray:coach.coaArrPicUrl]) {
        [_cvPic removeFromSuperview];
        [viewPic addSubview:self.lbNull_pic];
        
        lbTitle_pic.text = @"教学环境";
        fHeightViewPic = LyLbTitleItemHeight + LyNullItemHeight;
        
    } else {
        [_lbNull_pic removeFromSuperview];
        [viewPic addSubview:self.cvPic];
        
        lbTitle_pic.text = [[NSString alloc] initWithFormat:@"教学环境（%ld张）", coach.coaArrPicUrl.count];
        
        if (coach.coaArrPicUrl.count > cdCvPicSingleLineNum) {
            btnFunc_pic.hidden = NO;
            btnFunc_pic.frame = CGRectMake(SCREEN_WIDTH - horizontalSpace - LyBtnMoreWidth, LyLbTitleItemHeight + cdCvPicHeight, LyBtnMoreWidth, LyBtnMoreHeight);
            
        } else {
            btnFunc_pic.hidden = YES;
            btnFunc_pic.frame = CGRectMake(SCREEN_WIDTH - horizontalSpace - LyBtnMoreWidth, LyLbTitleItemHeight + cdCvPicHeight, LyBtnMoreWidth, 0);
        }
        
        fHeightViewPic = btnFunc_pic.frame.origin.y + CGRectGetHeight(btnFunc_pic.frame);
    }
    
    viewPic.frame = CGRectMake(0, viewSynopsis.frame.origin.y + CGRectGetHeight(viewSynopsis.frame) + verticalSpace, SCREEN_WIDTH, fHeightViewPic);
    
    
    
    [self reloadData_eva];
    
}

- (void)reloadData_eva {
    
    bFlagSetEva = NO;
    if (!eva) {
        lbTitle_eva.text = @"学员评价";
        [_tvEva removeFromSuperview];
        [viewEva addSubview:self.lbNull_eva];
        btnFunc_eva.hidden = YES;
        
        viewEva.frame = CGRectMake(0, viewPic.frame.origin.y + CGRectGetHeight(viewPic.frame) + verticalSpace, SCREEN_WIDTH, LyLbTitleItemHeight + LyNullItemHeight);
        
        [self reloadData_con];
        
    } else {
        [_lbNull_eva removeFromSuperview];
        [viewEva addSubview:self.tvEva];
        lbTitle_eva.text = [[NSString alloc] initWithFormat:@"学员评价（%d条）", coach.coaEvaluationCount];
        
        [self.tvEva reloadData];
    }
}

- (void)reloadData_con {
    
    bFlagSetCon = NO;
    if (!con) {
        lbTitle_con.text = @"提问咨询";
        [_tvCon removeFromSuperview];
        [viewCon addSubview:self.lbNull_con];
        btnFunc_con.hidden = YES;
        
        viewCon.frame = CGRectMake(0, viewEva.frame.origin.y + CGRectGetHeight(viewEva.frame) + verticalSpace, SCREEN_WIDTH, LyLbTitleItemHeight + LyNullItemHeight);
        
        [self reloadData_ask];
        
    } else {
        [_lbNull_con removeFromSuperview];
        [viewCon addSubview:self.tvCon];
        lbTitle_con.text = [[NSString alloc] initWithFormat:@"提问咨询（%d条）", coach.coaConsultCount];
        
        [self.tvCon reloadData];
    }
}

- (void)reloadData_ask {
    btnAsk.frame = CGRectMake(0, viewCon.frame.origin.y + CGRectGetHeight(viewCon.frame) + horizontalSpace, SCREEN_WIDTH, LyViewItemHeight);
    
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, btnAsk.frame.origin.y + LyViewItemHeight + horizontalSpace)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh {
    [self load];
}


- (void)targetForButton:(UIButton *)btn {
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(targetForButton:) object:btn];
        return;
    }
    
    LyCoachDetailButtonTag btnTag = btn.tag;
    switch (btnTag) {
        case coachDetailButtonTag_timeDetail: {
            LyTeachByTimeDetailViewController *teachByTime = [[LyTeachByTimeDetailViewController alloc] init];
            UINavigationController *teachByTimeDetailNavigation = [[UINavigationController alloc] initWithRootViewController:teachByTime];
            [self presentViewController:teachByTimeDetailNavigation animated:YES completion:nil];
            break;
        }
        case coachDetailButtonTag_func_syn: {
            LySynopsisView *synopsisView = [LySynopsisView synopsisViewWithContent:coach.coaDescription withTitle:@"简介"];
            [synopsisView show];
            break;
        }
        case coachDetailButtonTag_func_pic: {
            SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
            browser.sourceImagesContainerView = self.cvPic; // 原图的父控件
            browser.imageCount = coach.coaArrPicUrl.count;
            browser.currentImageIndex = 0;
            browser.delegate = self;
            [browser show];
            break;
        }
        case coachDetailButtonTag_func_eva: {
            LyEvaluationForTeacherTableViewController *evaList = [[LyEvaluationForTeacherTableViewController alloc] init];
            evaList.delegate = self;
            [self.navigationController pushViewController:evaList animated:YES];
            break;
        }
        case coachDetailButtonTag_func_con: {
            LyConsultTableViewController *conList = [[LyConsultTableViewController alloc] init];
            conList.delegate = self;
            [self.navigationController pushViewController:conList animated:YES];
            break;
        }
        case coachDetailButtonTag_func_ask: {
            LyAskViewController *askVC = [[LyAskViewController alloc] init];
            askVC.delegate = self;
            [self.navigationController pushViewController:askVC animated:YES];
            break;
        }
    }
}

- (void)handleHttpFailed:(BOOL)needRemind {
    if (self.indicator.isAnimating) {
        [self.indicator stopAnimation];
        [self.refreshControl endRefreshing];
        [self showViewError];
    }
    
    if (self.indicator_oper.isAnimating) {
        [self.indicator_oper stopAnimation];
        
        if (needRemind) {
            NSString *remindTitle = nil;
            if ([self.indicator_oper.title isEqualToString:LyIndicatorTitle_attente]) {
                remindTitle = @"关注失败";
            } else if ([self.indicator_oper.title isEqualToString:LyIndicatorTitle_deattente]) {
                remindTitle = @"取关失败";
            }
            
            [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:remindTitle];
        }
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
    
    [self.indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest new];
    [hr startHttpRequest:getTeacherDetail_url
                    body:@{
                           objectIdKey:_coachId,
                           userTypeKey:userTypeCoachKey,
                           userIdKey:[LyCurrentUser curUser].userId,
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
                   return ;
               }
               
               NSString *sCode = [[NSString alloc] initWithFormat:@"%@", dic[codeKey]];
               switch (sCode.integerValue) {
                   case 0: {
                       NSDictionary *dicResult = [dic objectForKey:resultKey];
                       if (![LyUtil validateDictionary:dicResult]) {
                           [self.indicator stopAnimation];
                           [self.refreshControl endRefreshing];
                           
                           [self showViewError];
                           return;
                       }
                       
                       NSString *strSex = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:sexKey]];
                       NSString *strPhone = [dicResult objectForKey:phoneKey];
                       NSString *strBirthday = [dicResult objectForKey:birthdayKey];
                       NSString *strAddress = [dicResult objectForKey:addressKey];
                       NSString *strMasterId = [dicResult objectForKey:masterIdKey];
                       NSString *strBossId = [dicResult objectForKey:bossKey];
                       NSString *strIntroduction = [dicResult objectForKey:introductionKey];
                       NSString *strTeachBirthday = [dicResult objectForKey:teachBirthdayKey];
                       NSString *strDriveBirthday = [dicResult objectForKey:driveBirthdayKey];
                       NSString *strScore = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:scoreKey]];
                       
                       NSString *strCoachMode = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:coachModeKey]];
                       NSString *strTimeFlag = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:timeFlagKey]];
                       NSString *strVerifyFlag = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:verifyStateKey]];
                       
                       NSString *strAllCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:teachAllCountKey]];
                       NSString *strPassedCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:teachedPassedCountKey]];
                       NSString *strEvalutionCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:evalutionCountKey]];
                       NSString *strPraiseCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:praiseCountKey]];
                       //                    NSString *strTrainClassCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:trainClassCountKey]];
                       NSString *strConsultCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:consultCountKey]];
                       //                    NSString *strPicCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:picCountKey]];
                       
                       //                    NSString *strTrainAddress = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:trainAddressKey]];
                       NSString *strAttenteFlag = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:attentionFlagKey]];
                       
                       
                       NSString *strPirce = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:priceKey]];
                       //                    NSString *strTeachableCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:teachableCountKey]];
                       
                       
                       NSString *strDeposit = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:depositKey]];
                    
                       
                       if (!coach) {
                           NSString *sName = dicResult[nickNameKey];
                           if (![LyUtil validateString:sName]) {
                               sName = [LyUtil getUserNameWithUserId:_coachId];
                           }
                           
                           coach = [LyCoach coachWithId:_coachId coaName:sName];
                           [[LyUserManager sharedInstance] addUser:coach];
                       }
                       
                       
                       [coach setUserSex:strSex.integerValue];
                       [coach setUserBirthday:strBirthday];
                       [coach setUserAddress:strAddress];
                       [coach setCoaMasterId:strMasterId];
                       [coach setUserSignature:strIntroduction];
                       [coach setCoaDescription:strIntroduction];
                       [coach setCoaTeachBirthday:strTeachBirthday];
                       [coach setCoaDriveBirthday:strDriveBirthday];
                       [coach setScore:[strScore floatValue]];
                       [coach setTimeFlag:[strTimeFlag boolValue]];
                       [coach setCoaVerifyState:[strVerifyFlag integerValue]];
                       [coach setStuAllCount:[strAllCount intValue]];
                       [coach setCoaTeachedPassedCount:[strPassedCount intValue]];
                       [coach setCoaEvaluationCount:[strEvalutionCount intValue]];
                       [coach setCoaPraiseCount:[strPraiseCount intValue]];
                       [coach setCoaConsultCount:[strConsultCount intValue]];
                       [coach setCoaMode:[strCoachMode integerValue]];
                       
                       [coach setPrice:strPirce.floatValue];
                       
                       [coach setDeposit:([strDeposit doubleValue] < 100) ? applyPrepayDeposit : [strDeposit doubleValue]];
                       
                       if ([LyUtil validateString:strPhone] && [strPhone validatePhoneNumber]) {
                           [coach setUserPhoneNum:strPhone];
                       }
                       
                       [self.controlBar setAttentionStatus:[strAttenteFlag boolValue]];
                       
                       LyDriveSchool *driveSchool = [[LyUserManager sharedInstance] getDriveSchoolWithDriveSchoolId:strMasterId];
                       if ( !driveSchool) {
                           NSString *strMasterName = [LyUtil getUserNameWithUserId:strMasterId];
                           
                           driveSchool = [LyDriveSchool driveSchoolWithId:strMasterId
                                                                 dschName:strMasterName];
                           [[LyUserManager sharedInstance] addUser:driveSchool];
                       }
                       
                       NSArray *arrTrainClass = [dicResult objectForKey:trainClassKey];
                       if ([LyUtil validateArray:arrTrainClass]) {
                           for ( int i = 0; i < [arrTrainClass count]; ++i)
                           {
                               NSDictionary *dicTrainClass = [arrTrainClass objectAtIndex:i];
                               if (![LyUtil validateDictionary:dicTrainClass]) {
                                   continue;
                               }
                               
                               NSString *strTcId = [dicTrainClass objectForKey:trainClassIdKey];
                               NSString *strTcName = [dicTrainClass objectForKey:nameKey];
                               NSString *strTcMasterId = [dicTrainClass objectForKey:masterIdKey];
                               NSString *strTcCarName = [dicTrainClass objectForKey:carNameKey];
                               NSString *strTcTime = [dicTrainClass objectForKey:classTimeKey];
                               NSString *strTcOfficialPrice = [[NSString alloc] initWithFormat:@"%@", [dicTrainClass objectForKey:officialPriceKey]];
                               NSString *strTc517WholePrice = [[NSString alloc] initWithFormat:@"%@", [dicTrainClass objectForKey:whole517PriceKey]];
                               NSString *strTc517PrepayPrice = [[NSString alloc] initWithFormat:@"%@", [dicTrainClass objectForKey:prepay517priceKey]];
                               NSString *strTc517PrepayDeposit = [[NSString alloc] initWithFormat:@"%@", [dicTrainClass objectForKey:prepay517depositKey]];
                               NSString *strTcMode = [[NSString alloc] initWithFormat:@"%@", [dicTrainClass objectForKey:trainClassModeKey]];
                               NSString *strTcLiceseType = [[NSString alloc] initWithFormat:@"%@", [dicTrainClass objectForKey:trainClassLiceseTypeKey]];
                               
                               
                               LyTrainClass *trainClass = [LyTrainClass trainClassWithTrainClassId:strTcId
                                                                                            tcName:strTcName
                                                                                        tcMasterId:strTcMasterId
                                                                                       tcTrainTime:strTcTime
                                                                                         tcCarName:strTcCarName
                                                                                            tcMode:[strTcMode integerValue]
                                                                                     tcLicenseType:[strTcLiceseType integerValue]
                                                                                   tcOfficialPrice:[strTcOfficialPrice floatValue]
                                                                                   tc517WholePrice:[strTc517WholePrice floatValue]
                                                                                  tc517PrepayPrice:[strTc517PrepayPrice floatValue]
                                                                                tc517PrePayDeposit:[strTc517PrepayDeposit floatValue]];
                               
                               [[LyTrainClassManager sharedInstance] addTrainClass:trainClass];
                           }
                       }
                       
                       if ( LyCoachMode_normal == strCoachMode.integerValue) {
                           arrClass = [[LyTrainClassManager sharedInstance] getTrainClassWithTeacherId:strMasterId];
                       } else if (LyCoachMode_staff == strCoachMode.integerValue) {
                           coach.bossId = strBossId;
                           
                           arrClass = [[LyTrainClassManager sharedInstance] getTrainClassWithTeacherId:strBossId];
                       } else {
                           arrClass = [[LyTrainClassManager sharedInstance] getTrainClassWithTeacherId:_coachId];
                       }
                       
                       
                       NSArray *arrPic = [dicResult objectForKey:imageUrlKey];
                       if ([LyUtil validateArray:arrPic]) {
                           
                           for ( int i = 0; i < arrPic.count; ++i)
                           {
                               NSString *strImageUrl = [arrPic objectAtIndex:i];
                               
                               if (![LyUtil validateString:strImageUrl]) {
                                   continue;
                               }
                               
                               if ( [strImageUrl rangeOfString:@"https://"].length < 1 && [strImageUrl rangeOfString:@"http://"].length < 1) {
                                   strImageUrl = [[NSString alloc] initWithFormat:@"%@%@", httpFix, strImageUrl];
                               }
                               
                               if ( strImageUrl)
                               {
                                   [coach addPicUrl:strImageUrl];
                               }
                           }
                       }
                       
                       NSDictionary *dicEva = dicResult[evaluationKey];
                       if ([LyUtil validateDictionary:dicEva]) {
                           NSString *sId = [[NSString alloc] initWithFormat:@"%@", dicEva[idKey]];
                           NSString *sContent = [[NSString alloc] initWithFormat:@"%@", dicEva[contentKey]];
                           NSString *sMasterId = [[NSString alloc] initWithFormat:@"%@", dicEva[masterIdKey]];
                           NSString *sMasterName = [[NSString alloc] initWithFormat:@"%@", dicEva[masterNickNameKey]];
                           NSString *sObjectId = [[NSString alloc] initWithFormat:@"%@", dicEva[objectIdKey]];
                           NSString *sScore = [[NSString alloc] initWithFormat:@"%@", dicEva[scoreKey]];
                           NSString *sTime = [[NSString alloc] initWithFormat:@"%@", dicEva[timeKey]];
                           NSString *sReplyCount = [[NSString alloc] initWithFormat:@"%@", dicEva[replyCountKey]];
                           
                           sTime = [LyUtil fixDateTimeString:sTime];
                           
                           LyUser *master = [[LyUserManager sharedInstance] getUserWithUserId:sMasterId];
                           if (!master) {
                               if ([sMasterId isEqualToString:@"1"]) {
                                   sMasterName = @"匿名用户";
                               } else if ([sMasterId isEqualToString:[LyCurrentUser curUser].userId]){
                                   sMasterName = [LyCurrentUser curUser].userName;
                               }else {
                                   if (![LyUtil validateString:sMasterName]) {
                                       sMasterName = [LyUtil getUserNameWithUserId:sMasterId];
                                   }
                               }
                               
                               master = [LyUser userWithId:sMasterId userNmae:sMasterName];
                               [[LyUserManager sharedInstance] addUser:master];
                           }
                           
                           eva  = [LyEvaluationForTeacher evaluationForTeacherWithId:sId
                                                                             content:sContent
                                                                                time:sTime
                                                                            masterId:sMasterId
                                                                            objectId:sObjectId
                                                                               score:sScore.floatValue
                                                                               level:LyEvaluationLevel_good];
                           eva.replyCount = sReplyCount.integerValue;
                       }
                       
                       NSDictionary *dicCon = dicResult[consultKey];
                       if ([LyUtil validateDictionary:dicCon]) {
                           NSString *sId = [[NSString alloc] initWithFormat:@"%@", dicCon[idKey]];
                           NSString *sContent = [[NSString alloc] initWithFormat:@"%@", dicCon[contentKey]];
                           NSString *sMasterId = [[NSString alloc] initWithFormat:@"%@", dicCon[masterIdKey]];
                           NSString *sMasterName = [[NSString alloc] initWithFormat:@"%@", dicCon[masterNickNameKey]];
                           NSString *sObjectId = [[NSString alloc] initWithFormat:@"%@", dicCon[objectIdKey]];
                           NSString *sTime = [[NSString alloc] initWithFormat:@"%@", dicCon[timeKey]];
                           NSString *sReplyCount = [[NSString alloc] initWithFormat:@"%@", dicCon[replyCountKey]];
                           
                           sTime = [LyUtil fixDateTimeString:sTime];
                           
                           LyUser *master = [[LyUserManager sharedInstance] getUserWithUserId:sMasterId];
                           if (!master) {
                               if ([sMasterId isEqualToString:@"1"]) {
                                   sMasterName = @"匿名用户";
                               } else if ([sMasterId isEqualToString:[LyCurrentUser curUser].userId]){
                                   sMasterName = [LyCurrentUser curUser].userName;
                               } else {
                                   if (![LyUtil validateString:sMasterName]) {
                                       sMasterName = [LyUtil getUserNameWithUserId:sMasterId];
                                   }
                               }
                               
                               master = [LyUser userWithId:sMasterId userNmae:sMasterName];
                               [[LyUserManager sharedInstance] addUser:master];
                           }
                           
                           con = [LyConsult consultWithId:sId
                                                     time:sTime
                                                 masterId:sMasterId
                                                 objectId:sObjectId
                                                  content:sContent];
                           
                           con.replyCount = sReplyCount.integerValue;
                       }
                       
                       [self reloadData];
                       
                       [self.refreshControl endRefreshing];
                       [self.indicator stopAnimation];
                       
                       
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
    
    self.indicator_oper.title = LyIndicatorTitle_attente;
    [self.indicator_oper startAnimation];
    
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:addAttention_url
                    body:@{
                           objectIdKey:_coachId,
                           userTypeKey:userTypeCoachKey,
                           userIdKey:[LyCurrentUser curUser].userId,
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
                   return ;
               }
               
               NSString *strCode = [[NSString alloc] initWithFormat:@"%@", dic[codeKey]];
               switch (strCode.integerValue) {
                   case 0: {
                       self.controlBar.attentionStatus = YES;
                       [self.indicator_oper stopAnimation];
                       [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"关注成功"] show];
                       break;
                   }
                   case 2: {
                       [self.indicator_oper stopAnimation];
                       [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"关注已达上限"] show];
                       break;
                   }
                   case 3: {
                       [self.indicator_oper stopAnimation];
                       [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"你已关注过该用户"];
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
    
    self.indicator_oper.title = LyIndicatorTitle_attente;
    [self.indicator_oper startAnimation];
    
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:removeAttention_url
                    body:@{
                           objectIdKey:_coachId,
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
                   return ;
               }
               
               NSString *strCode = [[NSString alloc] initWithFormat:@"%@", dic[codeKey]];
               switch (strCode.integerValue) {
                   case 0: {
                       self.controlBar.attentionStatus = NO;
                       [self.indicator_oper stopAnimation];
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


#pragma mark -LyTrainClassTableViewCellDelegate
- (void)onClickBtnApply:(LyTrainClassTableViewCell *)aTrainClassCell
{
    NSInteger index = [arrClass indexOfObject:aTrainClassCell.trainClass];
    curIdx_tc = [NSIndexPath indexPathForRow:index inSection:0];
    
    LyCreateOrderViewController *createOrder = [[LyCreateOrderViewController alloc] init];
    [createOrder setDelegate:self];
    [self.navigationController pushViewController:createOrder animated:YES];
}



#pragma mark- LyCreateOrderViewControllerDelegate
- (NSDictionary *)obtainGoodsInfo_crateOrder
{
    return @{
             goodKey : arrClass[curIdx_tc.row],
             teacherKey : coach
             };
}


#pragma mark -LyTrainClassDetailViewControllerDelegate
- (NSDictionary *)obtainTrainClassInfoByTrainClassDetailViewController:(LyTrainClassDetailViewController *)aTrainClassDetailVc {
    
    return @{
             trainClassKey : arrClass[curIdx_tc.row],
             teacherKey : coach
             };
}


#pragma mark -LyDriveSchoolDetailPicCollectionViewCellDelegate
- (void)picLoadFinish:(UIImage *)image strUrl:(NSString *)strUrl andDriveSchoolDetailPicCell:(LyDriveSchoolDetailPicCollectionViewCell *)aCell {
    
    NSIndexPath *ip = [self.cvPic indexPathForCell:aCell];
    
    if (!dicPics) {
        dicPics = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    if (image) {
        [dicPics setObject:image forKey:@(ip.row)];
    }
}


#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return dicPics[@(index)];
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    return [NSURL URLWithString:[LyUtil bigPicUrl:coach.coaArrPicUrl[index]]];
}

- (BOOL)isAllowSaveImage:(SDPhotoBrowser *)brower
{
    return NO;
}



#define mark -LyDetailControlBarDelegate
- (void)onClickedButtonAttente
{
    if (self.controlBar.attentionStatus) {
        
        UIAlertController *action = [UIAlertController alertControllerWithTitle:[[NSString alloc] initWithFormat:@"你确定不再关注「%@」吗？", coach.userName]
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
    [LyUtil sendSMS:nil recipients:@[messageNum_517] target:self];
}


- (void)onClickedButtonApply
{
    [svMain setContentOffset:CGPointMake( 0, cdViewInfoHeight) animated:YES];
}



#pragma mark -MFMessageComposeViewControllerDelegate
// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled) {
        [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"短信发送取消"] show];
    } else if (result == MessageComposeResultSent) {
        [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"短信发送成功"] show];
    } else {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"短信发送失败"] show];
    }
}


#pragma mark -LyEvaluationForTeacherTableViewControllerDelegate
- (LyUser *)userByEvaluationForTeacherTableViewController:(LyEvaluationForTeacherTableViewController *)aEvaluationTVC {
    return coach;
}

- (LyEvaluationForTeacher *)evaluationForTeacherByEvaluationForTeacherDetailTableViewController:(LyEvaluationForTeacherDetailTableViewController *)aEvaluationForTeacherDetailTVC {
    return eva;
}


#pragma mark -LyConsultDetailTableViewControllerDelegate
- (LyConsult *)consultByConsultDetailTableViewController:(LyConsultDetailTableViewController *)aConsultDetailTVC {
    return con;
}


#pragma mark -LyConsultTableViewControllerDelegate
- (LyUser *)userByConsultTableViewController:(LyConsultTableViewController *)aConsultTVC {
    return coach;
}


#pragma mark -LyAskViewControllerDelegate
- (LyUser *)userByAskViewController:(LyAskViewController *)aAskVC {
    return coach;
}

- (void)askDoneByAskViewController:(LyAskViewController *)aAskVC con:(LyConsult *)aCon {
    [aAskVC.navigationController popToViewController:self animated:YES];
    
    coach.coaConsultCount++;
    
    con = aCon;
    [self reloadData_con];
}




#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat fHeight = 0;
    LyCoachDetailTableViewTag tvTag = tableView.tag;
    switch (tvTag) {
        case coachDetailTableViewTag_tc: {
            fHeight = tcHeight;
            break;
        }
        case coachDetailTableViewTag_eva: {
            if (!bFlagSetEva) {
                bFlagSetEva = YES;
                
                if (LyChatCellHeightMin >= eva.height || eva.height > LyChatCellHeightMax) {
                    LyEvaluationForTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyCoachDetailEvaluationTableViewCellReuseIdentifier];
                    if (!cell) {
                        cell = [[LyEvaluationForTeacherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyCoachDetailEvaluationTableViewCellReuseIdentifier];
                    }
                    
                    cell.eva = eva;
                }
                
                fHeight = eva.height;
                
                self.tvEva.frame = CGRectMake(0, LyLbTitleItemHeight, SCREEN_WIDTH, fHeight);
                CGFloat fHeightViweEva = LyLbTitleItemHeight + fHeight;
                if (coach.coaEvaluationCount > 1) {
                    btnFunc_eva.hidden = NO;
                    btnFunc_eva.frame = CGRectMake(SCREEN_WIDTH - horizontalSpace - LyBtnMoreWidth, fHeightViweEva, LyBtnMoreWidth, LyBtnMoreHeight);
                    
                    fHeightViweEva += LyBtnMoreHeight;
                } else {
                    btnFunc_eva.hidden = YES;
                }
                viewEva.frame = CGRectMake(0, viewPic.frame.origin.y + CGRectGetHeight(viewPic.frame), SCREEN_WIDTH, fHeightViweEva);
                
                [self reloadData_con];
                
            } else {
                fHeight = CGRectGetHeight(self.tvEva.frame);
            }
            
            break;
        }
        case coachDetailTableViewTag_con: {
            if (!bFlagSetCon) {
                bFlagSetCon = YES;
                
                if (LyChatCellHeightMin >= con.height || con.height > LyChatCellHeightMax) {
                    LyConsultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyCoachDetailConsultTableViewCellReuseIdentifier];
                    if (!cell) {
                        cell = [[LyConsultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyCoachDetailConsultTableViewCellReuseIdentifier];
                    }
                    
                    cell.consult = con;
                }
                
                fHeight = con.height;
                
                self.tvCon.frame = CGRectMake(0, LyLbTitleItemHeight, SCREEN_WIDTH, fHeight);
                CGFloat fHeightViewCon = LyLbTitleItemHeight + fHeight;
                if (coach.coaConsultCount > 1) {
                    btnFunc_con.hidden = NO;
                    btnFunc_con.frame = CGRectMake(SCREEN_WIDTH - horizontalSpace - LyBtnMoreWidth, fHeightViewCon, LyBtnMoreWidth, LyBtnMoreHeight);
                    
                    fHeightViewCon += LyBtnMoreHeight;
                } else {
                    btnFunc_con.hidden = YES;
                }
                viewCon.frame = CGRectMake(0, viewEva.frame.origin.y + CGRectGetHeight(viewEva.frame) + verticalSpace, SCREEN_WIDTH, fHeightViewCon);
                
                [self reloadData_ask];
                
            } else {
                fHeight = CGRectGetHeight(self.tvCon.frame);
            }
            
            break;
        }
    }
    
    return fHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyCoachDetailTableViewTag tvTag = tableView.tag;
    switch (tvTag) {
        case coachDetailTableViewTag_tc: {
            curIdx_tc = indexPath;
            
            LyTrainClassDetailViewController *classDetail = [[LyTrainClassDetailViewController alloc] init];
            classDetail.delegate = self;
            [self.navigationController pushViewController:classDetail animated:YES];
            break;
        }
        case coachDetailTableViewTag_eva: {
            LyEvaluationForTeacherDetailTableViewController *evaDetail = [[LyEvaluationForTeacherDetailTableViewController alloc] init];
            evaDetail.delegate = self;
            [self.navigationController pushViewController:evaDetail animated:YES];
            break;
        }
        case coachDetailTableViewTag_con: {
            LyConsultDetailTableViewController *conDetail = [[LyConsultDetailTableViewController alloc] init];
            conDetail.delegate = self;
            [self.navigationController pushViewController:conDetail animated:YES];
            break;
        }
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger iCount = 0;
    
    LyCoachDetailTableViewTag tvTag = tableView.tag;
    switch (tvTag) {
        case coachDetailTableViewTag_tc: {
            iCount = arrClass.count;
            break;
        }
        case coachDetailTableViewTag_eva: {
            iCount = eva ? 1 : 0;
            break;
        }
        case coachDetailTableViewTag_con: {
            iCount = con ? 1 : 0;
            break;
        }
    }
    
    return iCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    LyCoachDetailTableViewTag tvTag = tableView.tag;
    switch (tvTag) {
        case coachDetailTableViewTag_tc: {
            LyTrainClassTableViewCell *tCell = [tableView dequeueReusableCellWithIdentifier:lyCoachDetailTrainClassTableViewCellReuseIdentifier];
            if (!tCell) {
                tCell = [[LyTrainClassTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyCoachDetailTrainClassTableViewCellReuseIdentifier];
            }
            
            tCell.trainClass = arrClass[indexPath.row];
            tCell.delegate = self;
            cell = tCell;
            break;
        }
        case coachDetailTableViewTag_eva: {
            LyEvaluationForTeacherTableViewCell *tCell = [tableView dequeueReusableCellWithIdentifier:lyCoachDetailEvaluationTableViewCellReuseIdentifier];
            if (!tCell) {
                tCell = [[LyEvaluationForTeacherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyCoachDetailEvaluationTableViewCellReuseIdentifier];
            }
            
            tCell.eva = eva;
            cell = tCell;
            break;
        }
        case coachDetailTableViewTag_con: {
            LyConsultTableViewCell *tCell = [tableView dequeueReusableCellWithIdentifier:lyCoachDetailConsultTableViewCellReuseIdentifier];
            if (!tCell) {
                tCell = [[LyConsultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyCoachDetailConsultTableViewCellReuseIdentifier];
            }
            
            tCell.consult = con;
            cell = tCell;
            break;
        }
    }
    
    return cell;
}

#pragma mark -UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self.cvPic;
    browser.imageCount = coach.coaArrPicUrl.count;
    browser.currentImageIndex = [indexPath row];
    browser.delegate = self;
    [browser show];
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}




#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return coach.coaArrPicUrl.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LyDriveSchoolDetailPicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lyCoachDetailPicCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    if (cell) {
        cell.strUrl = coach.coaArrPicUrl[indexPath.row];
        cell.delegate = self;
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( cdCvItemSize, cdCvItemSize);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(verticalSpace, verticalSpace, verticalSpace, verticalSpace);
}




#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == svMain) {
        
        if (scrollView.ly_offsetY < 0)
        {
            CGFloat newHeight = cdViewInfoHeight - scrollView.ly_offsetY;
            CGFloat newWidth = SCREEN_WIDTH * newHeight / cdViewInfoHeight;
            
            CGFloat newX = (SCREEN_WIDTH - newWidth) / 2.0;
            CGFloat newY = scrollView.ly_offsetY;
            
            ivBack.frame = CGRectMake(newX, newY, newWidth, newHeight);
        }
        else
        {
            ivBack.frame = CGRectMake(0, 0, SCREEN_WIDTH, cdViewInfoHeight);
        }

        
        if (svMain.contentOffset.y >= CGRectGetHeight(viewInfo.frame) - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT) {
            self.title = coach.userName;
            
            [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:nil];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            [self.navigationItem.titleView setHidden:NO];
            
        } else {
            self.title = nil;
            
            [self.navigationController.navigationBar setBackgroundImage:[LyUtil imageForImageName:@"uci_navigatinBar" needCache:NO] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController navigationBar].shadowImage = [LyUtil imageForImageName:@"uci_navigatinBar" needCache:NO];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            [self.navigationItem.titleView setHidden:YES];
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
