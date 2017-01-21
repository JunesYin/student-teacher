//
//  LySchoolDetailViewController.m
//  student
//
//  Created by MacMini on 2016/12/22.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LySchoolDetailViewController.h"
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
#import "LyConsult.h"

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



#define sdViewInfoHeight            (SCREEN_WIDTH * 2 / 3.0)

CGFloat const sdViewDetailHeight = 70;

CGFloat const sdLbNameHeight = 15;
#define sdLbNameFont                LyFont(14)

CGFloat const sdIvScoreHeight = sdLbNameHeight;
CGFloat const sdIvScoreWidth = sdLbNameHeight * 102 / 17.0;

CGFloat const sdIvFlagSize = 20;
CGFloat const sdIvPickWidth = sdIvFlagSize * 2;
CGFloat const sdDetailFlagItemMargin = 3;

#define sdLbNumFont                 LyFont(12)


CGFloat const sdLbTimeFlagWidth = 120;
CGFloat const sdLbTimeFlagHeight = 15;
#define sdLbTimeFlagFont            LyFont(13)

CGFloat const sdBtnTimeDetailWidth = 100;
CGFloat const sdBtnTimeDetailHeight = sdLbTimeFlagHeight;
#define sdBtnTimeDetailFont         sdLbTimeFlagFont


//CGFloat const
#define sdTvSynFont                 sdLbTimeFlagFont


int const sdCvPicSingleLineNum = 3;
#define sdCvItemSize                ((SCREEN_WIDTH - verticalSpace * (sdCvPicSingleLineNum * 2)) / 3)
#define sdCvPicHeight               (sdCvItemSize + verticalSpace * 2)


typedef NS_ENUM(NSInteger, LySchoolDetailTableViewTag) {
    schoolDetailTableViewTag_tc = 10,
    schoolDetailTableViewTag_eva,
    schoolDetailTableViewTag_con
};

typedef NS_ENUM(NSInteger, LySchoolDetailButtonTag) {
    schoolDetailButtonTag_timeDetail = 20,
    schoolDetailButtonTag_func_syn,
    schoolDetailButtonTag_func_pic,
    schoolDetailButtonTag_func_eva,
    schoolDetailButtonTag_func_con,
    schoolDetailButtonTag_func_ask
};


@interface LySchoolDetailViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MFMessageComposeViewControllerDelegate, LyDetailControlBarDelegate, LyDriveSchoolDetailPicCollectionViewCellDelegate, SDPhotoBrowserDelegate, LyTrainClassTableViewCellDelegate, LyTrainClassTableViewCellDelegate, LyCreateOrderViewControllerDelegate, LyConsultTableViewControllerDelegate, LyConsultDetailTableViewControllerDelegate, LyEvaluationForTeacherTableViewControllerDelegate, LyEvaluationForTeacherDetailTableViewControllerDelegate, LyTrainClassDetailViewControllerDelegate, LyAskViewControllerDelegate>
{
    UIView      *viewError;
    
    
    UIScrollView        *svMain;
    
    UIView      *viewInfo;
    UIImageView     *ivBanner;
    UIView      *viewDetail;
    UILabel     *lbName;
    UIImageView     *ivScore;
    UIImageView     *ivPickFlag;
    UIImageView     *ivVerifyFlag;
    UIImageView     *ivRecommendFlag;
    UIImageView     *ivHotFlag;
    UILabel     *lbAllCount;
    UILabel     *lbPerPass;
    UILabel     *lbPerPraise;
    UILabel     *lbPickRange;
    
    
    UIView      *viewTrainClass;
    UILabel     *lbTitle_tc;
    //self.tvTc
    
    
    UIView      *viewSynopsis;
    UILabel     *lbTitle_syn;
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
    //self.tvEva;
    UIButton        *btnFunc_eva;
    
    
    UIView      *viewCon;
    UILabel     *lbTitle_con;
    //self.tvCon
    UIButton        *btnFunc_con;
    
    
    UIButton    *btnAsk;
    
    
    LyDriveSchool       *school;
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

@implementation LySchoolDetailViewController

static NSString *const lySchoolDetailTrainClassTableViewCellReuseIdentifier = @"lySchoolDetailTrainClassTableViewCellReuseIdentifier";
static NSString *const lySchoolDetailPicCollectionViewCellReuseIdentifier = @"lySchoolDetailPicCollectionViewCellReuseIdentifier";
static NSString *const lySchoolDetailEvaluatinTableViewCellReuseIdentifier = @"lySchoolDetailEvaluatinTableViewCellReuseIdentifier";
static NSString *const lySchoolDetailConsultTableViewCellReuseIdentifier = @"lySchoolDetailConsultTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    if (bFlagSuccess) {
        return;
    }
    
    _schoolId = [_delegate schoolIdBySchoolDetailViewController:self];
    if (!_schoolId) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    school = [[LyUserManager sharedInstance] getDriveSchoolWithDriveSchoolId:_schoolId];
    if (school) {
        self.title = school.userName;
    }
    
    [self load];
}

- (void)initSubviews {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = LyWhiteLightgrayColor;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT - dcbHeight)];
    svMain.delegate = self;
    
    
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, sdViewInfoHeight)];
    viewInfo.backgroundColor = [UIColor whiteColor];
    
    ivBanner = [[UIImageView alloc] initWithFrame:viewInfo.bounds];
    ivBanner.contentMode = UIViewContentModeScaleAspectFit;
    ivBanner.clipsToBounds = YES;
    ivBanner.image = [LyUtil imageForImageName:@"dsd_banner_default" needCache:NO];
    
    viewDetail = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(viewInfo.frame) - sdViewDetailHeight, SCREEN_WIDTH, sdViewDetailHeight)];
    viewDetail.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    lbName = [UILabel new];
    lbName.font = sdLbNameFont;
    lbName.textColor = [UIColor whiteColor];
    
    ivScore = [UIImageView new];
    
    ivPickFlag = [UIImageView new];
    ivPickFlag.image = [LyUtil imageForImageName:@"dsd_pickUp_flag" needCache:NO];
    
    ivVerifyFlag = [UIImageView new];
    ivVerifyFlag.image = [LyUtil imageForImageName:@"dsd_certificate_flag" needCache:NO];
    
    ivRecommendFlag = [UIImageView new];
    ivRecommendFlag.image = [LyUtil imageForImageName:@"dsd_recommend_flag" needCache:NO];
    
    ivHotFlag = [UIImageView new];
    ivHotFlag.image = [LyUtil imageForImageName:@"dsd_hot_flag" needCache:NO];
    
    lbAllCount = [UILabel new];
    lbAllCount.font = sdLbNumFont;
    lbAllCount.textColor = [UIColor whiteColor];
    
    lbPerPass = [UILabel new];
    lbPerPass.font = sdLbNumFont;
    lbPerPass.textColor = [UIColor whiteColor];
    
    lbPerPraise = [UILabel new];
    lbPerPraise.font = sdLbNumFont;
    lbPerPraise.textColor = [UIColor whiteColor];
    
    lbPickRange = [UILabel new];
    lbPickRange.font = sdLbNumFont;
    lbPickRange.textColor = [UIColor whiteColor];
    lbPickRange.textAlignment = NSTextAlignmentLeft;
    lbPickRange.numberOfLines = 0;
    
    [viewDetail addSubview:lbName];
    [viewDetail addSubview:ivScore];
    [viewDetail addSubview:ivPickFlag];
    [viewDetail addSubview:ivVerifyFlag];
    [viewDetail addSubview:ivRecommendFlag];
    [viewDetail addSubview:ivHotFlag];
    [viewDetail addSubview:lbAllCount];
    [viewDetail addSubview:lbPerPass];
    [viewDetail addSubview:lbPerPraise];
    [viewDetail addSubview:lbPickRange];
    
    [viewInfo addSubview:ivBanner];
    [viewInfo addSubview:viewDetail];
    
    
    
    viewTrainClass = [UIView new];
    viewTrainClass.backgroundColor = [UIColor whiteColor];
    
    lbTitle_tc = [self lbTitleWith:@"培训课程"];
    
    //self.tvTc
    
    //self.lbNull_tc
    
    [viewTrainClass addSubview:lbTitle_tc];
    
    
    viewSynopsis = [UIView new];
    viewSynopsis.backgroundColor = [UIColor whiteColor];
    
    lbTitle_syn = [self lbTitleWith:@"驾校简介"];
    
    lbTimeFlag = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, LyLbTitleItemHeight, sdLbTimeFlagWidth, sdLbTimeFlagHeight)];
    lbTimeFlag.font = sdLbTimeFlagFont;
    lbTimeFlag.textColor = LyBlackColor;
    lbTimeFlag.textAlignment = NSTextAlignmentLeft;
    
    btnTimeDetail = [[UIButton alloc] initWithFrame:CGRectMake(sdLbTimeFlagWidth + horizontalSpace * 2, LyLbTitleItemHeight, sdBtnTimeDetailWidth, sdLbTimeFlagHeight)];
    btnTimeDetail.tag = schoolDetailButtonTag_timeDetail;
    btnTimeDetail.titleLabel.font = sdBtnTimeDetailFont;
    [btnTimeDetail setTitle:@"查看详情" forState:UIControlStateNormal];
    [btnTimeDetail setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnTimeDetail addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    tvSyn = [UITextView new];
    tvSyn.font = sdTvSynFont;
    tvSyn.textColor = LyDarkgrayColor;
    tvSyn.selectable = NO;
    tvSyn.editable = NO;
    tvSyn.scrollEnabled = NO;
    tvSyn.textAlignment = NSTextAlignmentLeft;
    tvSyn.textContainer.maximumNumberOfLines = synopsisLinesMax;
    tvSyn.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    
    btnFunc_syn = [self btnFuncWith:schoolDetailButtonTag_func_syn];
    
    [viewSynopsis addSubview:lbTitle_syn];
    [viewSynopsis addSubview:lbTimeFlag];
    [viewSynopsis addSubview:btnTimeDetail];
    [viewSynopsis addSubview:tvSyn];
    [viewSynopsis addSubview:btnFunc_syn];
    
    
    viewPic = [UIView new];
    viewPic.backgroundColor = [UIColor whiteColor];
    
    lbTitle_pic = [self lbTitleWith:@"教学环境"];
    
    //self.cvPic
    
    //self.lbNull_pic
    
    btnFunc_pic = [self btnFuncWith:schoolDetailButtonTag_func_pic];
    
    [viewPic addSubview:lbTitle_pic];
    [viewPic addSubview:btnFunc_pic];
    
    
    
    viewEva = [UIView new];
    viewEva.backgroundColor = [UIColor whiteColor];
    
    lbTitle_eva = [self lbTitleWith:@"学员评价"];
    
    //self.tvEva
    
    //self.lbNull_eva
    
    btnFunc_eva = [self btnFuncWith:schoolDetailButtonTag_func_eva];
    
    [viewEva addSubview:lbTitle_eva];
    [viewEva addSubview:btnFunc_eva];
    
    
    viewCon = [UIView new];
    viewCon.backgroundColor = [UIColor whiteColor];
    
    lbTitle_con = [self lbTitleWith:@"提问咨询"];
    
    //self.tvCon
    
    //self.lbNull_con
    
    btnFunc_con = [self btnFuncWith:schoolDetailButtonTag_func_con];
    
    [viewCon addSubview:lbTitle_con];
    [viewCon addSubview:btnFunc_con];
    
    
    
    btnAsk = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAsk.tag = schoolDetailButtonTag_func_ask;
    [btnAsk setTitle:@"我要提问" forState:UIControlStateNormal];
    [btnAsk setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [btnAsk addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [svMain addSubview:viewInfo];
    [svMain addSubview:viewTrainClass];
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
        _tvTc.tag = schoolDetailTableViewTag_tc;
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
        
        _cvPic = [[UICollectionView alloc] initWithFrame:CGRectMake(0, LyLbTitleItemHeight, SCREEN_WIDTH, sdCvPicHeight)
                                    collectionViewLayout:sdCvFlowLayout];
        _cvPic.delegate = self;
        _cvPic.dataSource = self;
        _cvPic.scrollsToTop = NO;
        _cvPic.backgroundColor = [UIColor whiteColor];
        _cvPic.showsVerticalScrollIndicator = NO;
        _cvPic.showsHorizontalScrollIndicator = NO;
        [_cvPic registerClass:[LyDriveSchoolDetailPicCollectionViewCell class] forCellWithReuseIdentifier:lySchoolDetailPicCollectionViewCellReuseIdentifier];
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
        _tvEva.tag = schoolDetailTableViewTag_eva;
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
        _tvCon.tag = schoolDetailTableViewTag_con;
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

- (UIButton *)btnFuncWith:(LySchoolDetailButtonTag)btnTag
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



- (void)setIvFlagFrame {
    
    CGRect rectRightFirst = CGRectMake(SCREEN_WIDTH - sdDetailFlagItemMargin * 1 - sdIvFlagSize * 1, 0, sdIvFlagSize, sdIvFlagSize);
    
    CGRect rectRightSecond = CGRectMake(SCREEN_WIDTH - sdDetailFlagItemMargin * 2 - sdIvFlagSize*2, 0, sdIvFlagSize, sdIvFlagSize);
    
    CGRect rectRightThird = CGRectMake(SCREEN_WIDTH - sdDetailFlagItemMargin * 3 - sdIvFlagSize * 3, 0, sdIvFlagSize, sdIvFlagSize);
    
    CGRect rectZeroFirst = CGRectMake(SCREEN_WIDTH - sdDetailFlagItemMargin * 0 - sdIvFlagSize * 0, 0, 0, 0);
    CGRect rectZeroSecond = CGRectMake(SCREEN_WIDTH - sdDetailFlagItemMargin * 1 - sdIvFlagSize * 1, 0, 0, 0);
    CGRect rectZeroThird = CGRectMake(SCREEN_WIDTH - sdDetailFlagItemMargin * 2 - sdIvFlagSize * 2, 0, 0, 0);
    CGRect rectZeroFourth = CGRectMake(SCREEN_WIDTH - sdDetailFlagItemMargin * 3 - sdIvFlagSize * 2 - sdIvPickWidth, 0, 0, 0);
    
    CGRect rectIvHotFlag;
    CGRect rectIvRecommendFlag;
    CGRect rectIvVerifyFlag;
    CGRect rectIvPickFlag;
    
    
    if (school.dschHotFlag) {
        if (school.dschRecommendFlag) {
            if (LyTeacherVerifyState_access == school.dschVerifyState) {
                rectIvHotFlag = rectRightFirst;
                rectIvRecommendFlag = rectRightSecond;
                rectIvVerifyFlag = rectRightThird;
                
            } else {
                rectIvHotFlag = rectRightFirst;
                rectIvRecommendFlag = rectRightSecond;
                rectIvVerifyFlag = rectZeroThird;
            }
            
        } else {
            if (LyTeacherVerifyState_access == school.dschVerifyState) {
                rectIvHotFlag = rectRightFirst;
                rectIvRecommendFlag = rectZeroSecond;
                rectIvVerifyFlag = rectRightSecond;
                
            } else {
                rectIvHotFlag = rectRightFirst;
                rectIvRecommendFlag = rectZeroSecond;
                rectIvVerifyFlag = rectZeroSecond;
            }
            
        }
        
    } else {
        if (school.dschRecommendFlag) {
            if (LyTeacherVerifyState_access == school.dschVerifyState) {
                rectIvHotFlag = rectZeroFirst;
                rectIvRecommendFlag = rectRightFirst;
                rectIvVerifyFlag = rectRightSecond;
                
            } else {
                rectIvHotFlag = rectZeroFirst;
                rectIvRecommendFlag = rectRightFirst;
                rectIvVerifyFlag = rectZeroSecond;
            }
            
        } else {
            if (LyTeacherVerifyState_access == school.dschVerifyState) {
                rectIvHotFlag = rectZeroFirst;
                rectIvRecommendFlag = rectZeroFirst;
                rectIvVerifyFlag = rectRightFirst;

            } else {
                rectIvHotFlag = rectZeroFirst;
                rectIvRecommendFlag = rectZeroFirst;
                rectIvVerifyFlag = rectZeroFirst;
            }
        }
    }
    
    
    if (school.dschPickupFlag) {
        rectIvPickFlag = CGRectMake(rectIvVerifyFlag.origin.x - sdDetailFlagItemMargin - sdIvPickWidth, 0, sdIvPickWidth, sdIvFlagSize);
    } else {
        rectIvPickFlag = rectZeroFourth;
    }
    
    ivHotFlag.frame = rectIvHotFlag;
    ivRecommendFlag.frame = rectIvRecommendFlag;
    ivVerifyFlag.frame = rectIvVerifyFlag;
    ivPickFlag.frame = rectIvPickFlag;
}

- (void)reloadData {
    
    self.title = school.userName;
    
    [self removeViewError];
    
    svMain.hidden = NO;
    self.controlBar.hidden = NO;
    
    if ([LyUtil validateString:school.bannerUrl]) {
        [ivBanner sd_setImageWithURL:[NSURL URLWithString:school.bannerUrl]
                        placeholderImage:[LyUtil imageForImageName:@"dsd_banner" needCache:NO]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   if (!image) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [ivBanner setImage:[LyUtil imageForImageName:@"dsd_banner_default" needCache:NO]];
                                       });
                                   }
                               }];
    }
    
    CGFloat fWidthLbName = [school.userName sizeWithAttributes:@{NSFontAttributeName: lbName.font}].width;
    lbName.frame = CGRectMake(horizontalSpace, verticalSpace, fWidthLbName, sdLbNameHeight);
    lbName.text = school.userName;
    
    ivScore.frame = CGRectMake(fWidthLbName + horizontalSpace * 2, lbName.frame.origin.y, sdIvScoreWidth, sdIvScoreHeight);
    [LyUtil setScoreImageView:ivScore withScore:school.score];
    
    [self setIvFlagFrame];
    
    NSString *sAllCountNum = [[NSString alloc] initWithFormat:@"%d", school.stuAllCount];
    NSString *sAllCountTmp = [sAllCountNum stringByAppendingString:@"人已报名"];
    NSMutableAttributedString *sAllCount = [[NSMutableAttributedString alloc] initWithString:sAllCountTmp];
    [sAllCount addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[sAllCountTmp rangeOfString:sAllCountNum]];
    CGFloat fWidthLbAllCount = [sAllCountTmp sizeWithAttributes:@{NSFontAttributeName : lbAllCount.font}].width;
    lbAllCount.frame = CGRectMake(horizontalSpace, lbName.frame.origin.y + CGRectGetHeight(lbName.frame) + verticalSpace, fWidthLbAllCount, sdLbNameHeight);
    lbAllCount.attributedText = sAllCount;
    
    NSString *sPerPassTmp = [[NSString alloc] initWithFormat:@"通过率：%@", school.perPass];
    NSMutableAttributedString *sPerPass = [[NSMutableAttributedString alloc] initWithString:sPerPassTmp];
    [sPerPass addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[sPerPassTmp rangeOfString:school.perPass]];
    CGFloat fWidthLbPerPass = [sPerPassTmp sizeWithAttributes:@{NSFontAttributeName : lbPerPass.font}].width;
    lbPerPass.frame = CGRectMake(horizontalSpace * 2 + fWidthLbAllCount, lbAllCount.frame.origin.y, fWidthLbPerPass, sdLbNameHeight);
    lbPerPass.attributedText = sPerPass;
    
    NSString *sPerPraiseTmp = [[NSString alloc] initWithFormat:@"好评率：%@", school.perPraise];
    NSMutableAttributedString *sPerPraise = [[NSMutableAttributedString alloc] initWithString:sPerPraiseTmp];
    [sPerPraise addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[sPerPraiseTmp rangeOfString:school.perPraise]];
    CGFloat fWidthLbPerPraise = [sPerPraiseTmp sizeWithAttributes:@{NSFontAttributeName : lbPerPraise.font}].width;
    lbPerPraise.frame = CGRectMake(horizontalSpace * 3 + fWidthLbAllCount + fWidthLbPerPass, lbAllCount.frame.origin.y, fWidthLbPerPraise, sdLbNameHeight);
    
    lbPickRange.frame = CGRectMake(horizontalSpace, lbAllCount.ly_y + lbAllCount.ly_height, SCREEN_WIDTH - horizontalSpace * 2, sdViewDetailHeight - sdLbNameHeight * 2 - verticalSpace * 4);
    lbPickRange.text = school.dschPickRange;
    
    
    
    CGFloat fHeightViewTrainClass = 0;
    if (![LyUtil validateArray:arrClass]) {
        [_tvTc removeFromSuperview];
        [viewTrainClass addSubview:self.lbNull_tc];
        
        fHeightViewTrainClass = LyLbTitleItemHeight + LyNullItemHeight;
        
    } else {
        [_lbNull_tc removeFromSuperview];
        [viewTrainClass addSubview:self.tvTc];
        
        CGFloat fHeightTvTc = tcHeight * arrClass.count;
        self.tvTc.frame = CGRectMake(0, LyLbTitleItemHeight, SCREEN_WIDTH, fHeightTvTc);
        [self.tvTc reloadData];
        
        fHeightViewTrainClass = LyLbTitleItemHeight + fHeightTvTc;

    }
    viewTrainClass.frame = CGRectMake(0, sdViewInfoHeight, SCREEN_WIDTH, fHeightViewTrainClass);
    
    

    CGFloat fHeightViewSyn = 0;
    
    lbTimeFlag.text = school.timeFlag ? @"计时培训：支持" : @"计时培训：不支持";
    
    [btnTimeDetail setHidden:!school.timeFlag];
    
    if (![LyUtil validateString:school.dschDescription]) {
        tvSyn.hidden = YES;
        btnFunc_syn.hidden = YES;
        fHeightViewSyn = LyLbTitleItemHeight + sdLbTimeFlagHeight;
        
    } else {
        tvSyn.hidden = NO;
        
        UITextView *tvTmp = [[UITextView alloc] init];
        tvTmp.font = tvSyn.font;
        tvTmp.text = school.dschDescription;
        CGFloat fHeightTvTmp =  [tvTmp sizeThatFits:CGSizeMake(SCREEN_WIDTH - horizontalSpace * 2, MAXFLOAT)].height;
        
        tvSyn.text = school.dschDescription;
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
    
    viewSynopsis.frame = CGRectMake(0, viewTrainClass.frame.origin.y + CGRectGetHeight(viewTrainClass.frame) + verticalSpace, SCREEN_WIDTH, fHeightViewSyn);
    
    
    CGFloat fHeightViewPic = 0;;
    if (![LyUtil validateArray:school.dschArrPicUrl]) {
        [_cvPic removeFromSuperview];
        [viewPic addSubview:self.lbNull_pic];
        
        lbTitle_pic.text = @"教学环境";
        fHeightViewPic = LyLbTitleItemHeight + LyNullItemHeight;
        
    } else {
        [_lbNull_pic removeFromSuperview];
        [viewPic addSubview:self.cvPic];
        
        lbTitle_pic.text = [[NSString alloc] initWithFormat:@"教学环境（%ld张）", school.dschArrPicUrl.count];
        
        if (school.dschArrPicUrl.count > sdCvPicSingleLineNum) {
            btnFunc_pic.hidden = NO;
            btnFunc_pic.frame = CGRectMake(SCREEN_WIDTH - horizontalSpace - LyBtnMoreWidth, LyLbTitleItemHeight + sdCvPicHeight, LyBtnMoreWidth, LyBtnMoreHeight);
            
        } else {
            btnFunc_pic.hidden = YES;
            btnFunc_pic.frame = CGRectMake(SCREEN_WIDTH - horizontalSpace - LyBtnMoreWidth, LyLbTitleItemHeight + sdCvPicHeight, LyBtnMoreWidth, 0);
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
        lbTitle_eva.text = [[NSString alloc] initWithFormat:@"学员评价（%d条）", school.dschEvalutionCount];
        
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
        lbTitle_con.text = [[NSString alloc] initWithFormat:@"提问咨询（%d条）", school.dschConsultCount];
        
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
    
    LySchoolDetailButtonTag btnTag = btn.tag;
    switch (btnTag) {
        case schoolDetailButtonTag_timeDetail: {
            LyTeachByTimeDetailViewController *teachByTime = [[LyTeachByTimeDetailViewController alloc] init];
            UINavigationController *teachByTimeDetailNavigation = [[UINavigationController alloc] initWithRootViewController:teachByTime];
            [self presentViewController:teachByTimeDetailNavigation animated:YES completion:nil];
            break;
        }
        case schoolDetailButtonTag_func_syn: {
            LySynopsisView *synopsisView = [LySynopsisView synopsisViewWithContent:school.dschDescription withTitle:@"简介"];
            [synopsisView show];
            break;
        }
        case schoolDetailButtonTag_func_pic: {
            SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
            browser.sourceImagesContainerView = self.cvPic; // 原图的父控件
            browser.imageCount = school.dschArrPicUrl.count;
            browser.currentImageIndex = 0;
            browser.delegate = self;
            [browser show];
            break;
        }
        case schoolDetailButtonTag_func_eva: {
            LyEvaluationForTeacherTableViewController *evaList = [[LyEvaluationForTeacherTableViewController alloc] init];
            evaList.delegate = self;
            [self.navigationController pushViewController:evaList animated:YES];
            break;
        }
        case schoolDetailButtonTag_func_con: {
            LyConsultTableViewController *conList = [[LyConsultTableViewController alloc] init];
            conList.delegate = self;
            [self.navigationController pushViewController:conList animated:YES];
            break;
        }
        case schoolDetailButtonTag_func_ask: {
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
                           objectIdKey : _schoolId,
                           userTypeKey : userTypeSchoolKey,
                           userIdKey : [LyCurrentUser curUser].userId,
                           sessionIdKey : [LyUtil httpSessionId]
                           }
                    type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *sResult, NSData *dResult, NSError *error) {
           if (error) {
               [self handleHttpFailed:YES];
           } else {
               NSDictionary *dic = [self analysisHttpResult:sResult];
               if (!dic) {
                   [self handleHttpFailed:YES];
                   return ;
               }
               
               NSString *strCode = [[NSString alloc] initWithFormat:@"%@", dic[codeKey]];
               switch (strCode.integerValue) {
                   case 0: {
                       NSDictionary *dicResult = dic[resultKey];
                       if (![LyUtil validateDictionary:dicResult]) {
                           [self.indicator stopAnimation];
                           [self.refreshControl endRefreshing];
                           
                           [self showViewError];
                           return;
                       }
                       
                       NSString *strPhone = [dicResult objectForKey:phoneKey];
                       NSString *strAddress = [dicResult objectForKey:addressKey];
                       NSString *strPickRange = [dicResult objectForKey:pickRangeKey];
                       NSString *strScore = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:scoreKey]];
                       NSString *strAllCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:teachAllCountKey]];
                       NSString *strPassedCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:teachedPassedCountKey]];
                       NSString *strPraiseCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:praiseCountKey]];
                       NSString *strPirce = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:priceKey]];
                       NSString *strIntroduction = [dicResult objectForKey:introductionKey];

                       NSString *strHotFlag = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:hotFlagKey]];
                       NSString *strRecommendFlag = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:recomendFlagKey]];
                       NSString *strVerifyState = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:verifyStateKey]];
                       NSString *strPickFlag = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:pickFlagKey]];
                       NSString *strTimeFlag = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:timeFlagKey]];
                       
                       NSString *strTrainAddress = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:trainAddressKey]];

                       NSString *strEvalutionCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:evalutionCountKey]];
                       NSString *strConsultCount = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:consultCountKey]];
                       
                       NSString *strAttenteFlag = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:attentionFlagKey]];
                       
                       NSString *strBannerUrl = [dicResult objectForKey:bannerUrlKey];
                       
                       NSString *strDeposit = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:depositKey]];
                    
                       
                       if (!school) {
                           NSString *strName = dicResult[nickNameKey];
                           if (![LyUtil validateString:strName]) {
                               strName = [LyUtil getUserNameWithUserId:_schoolId];
                           }
                           
                           school = [LyDriveSchool driveSchoolWithId:_schoolId dschName:strName];
                           [[LyUserManager sharedInstance] addUser:school];
                       }
                       
                       [school setUserAddress:strAddress];
                       [school setDschPickRange:strPickRange];
                       [school setScore:[strScore floatValue]];
                       [school setStuAllCount:[strAllCount intValue]];
                       [school setDschStudentPassCount:[strPassedCount intValue]];
                       [school setDschEvalutionCount:[strEvalutionCount intValue]];
                       [school setDschPraiseCount:[strPraiseCount intValue]];
                       [school setPrice:[strPirce floatValue]];
                       [school setDschDescription:strIntroduction];
                       [school setDschHotFlag:[strHotFlag boolValue]];
                       [school setDschRecommendFlag:[strRecommendFlag boolValue]];
                       [school setDschVerifyState:[strVerifyState integerValue]];
                       [school setDschPickupFlag:[strPickFlag boolValue]];
                       [school setTimeFlag:[strTimeFlag boolValue]];
                       [school setDschConsultCount:[strConsultCount intValue]];
                       
                       [school setDschTrainAddress:strTrainAddress];
                       
                       [school setBannerUrl:strBannerUrl];
                       [school setDeposit:([strDeposit doubleValue] < 100) ? applyPrepayDeposit : [strDeposit doubleValue]];
                       
                       if ([LyUtil validateString:strPhone] && [strPhone validatePhoneNumber]) {
                           [school setUserPhoneNum:strPhone];
                       }

                       [self.controlBar setAttentionStatus:strAttenteFlag.boolValue];
                       
                       NSArray *arrTrainClass = [dicResult objectForKey:trainClassKey];
                       if ([LyUtil validateArray:arrTrainClass] ) {
                           for (NSDictionary *dicTrainClass in arrTrainClass) {
                               if (![LyUtil validateDictionary:dicTrainClass ]) {
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
                       
                       arrClass = [[LyTrainClassManager sharedInstance] getTrainClassWithDriveSchoolId:_schoolId];
                       
                       
                       NSArray *arrPic = [dicResult objectForKey:imageUrlKey];
                       if ([LyUtil validateArray:arrPic]) {
                           for ( int i = 0; i < arrPic.count; ++i) {
                               NSString *strImageUrl = [arrPic objectAtIndex:i];
                               
                               if (![LyUtil validateString:strImageUrl]) {
                                   continue;
                               }
                               
                               if ( [strImageUrl rangeOfString:@"https://"].length < 1 && [strImageUrl rangeOfString:@"http://"].length < 1) {
                                   strImageUrl = [[NSString alloc] initWithFormat:@"%@%@", httpFix, strImageUrl];
                               }
                               
                               if ( strImageUrl) {
                                   [school addPicUrl:strImageUrl];
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
                           
                           eva = [LyEvaluationForTeacher evaluationForTeacherWithId:sId
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
                           objectIdKey:_schoolId,
                           userTypeKey:userTypeSchoolKey,
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
                       self.controlBar.attentionStatus = YES;
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
                           objectIdKey:_schoolId,
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
             teacherKey : school
             };
}



#pragma mark -LyTrainClassDetailViewControllerDelegate
- (NSDictionary *)obtainTrainClassInfoByTrainClassDetailViewController:(LyTrainClassDetailViewController *)aTrainClassDetailVc {
    
    return @{
             trainClassKey : arrClass[curIdx_tc.row],
             teacherKey : school
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
    return [NSURL URLWithString:[LyUtil bigPicUrl:school.dschArrPicUrl[index]]];
}

- (BOOL)isAllowSaveImage:(SDPhotoBrowser *)brower
{
    return NO;
}



#define mark -LyDetailControlBarDelegate
- (void)onClickedButtonAttente
{
    if (self.controlBar.attentionStatus) {
        
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
    [LyUtil sendSMS:nil recipients:@[messageNum_517] target:self];
}


- (void)onClickedButtonApply
{
    [svMain setContentOffset:CGPointMake( 0, sdViewInfoHeight) animated:YES];
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
    return school;
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
    return school;
}


#pragma mark -LyAskViewControllerDelegate
- (LyUser *)userByAskViewController:(LyAskViewController *)aAskVC {
    return school;
}

- (void)askDoneByAskViewController:(LyAskViewController *)aAskVC con:(LyConsult *)aCon {
    [aAskVC.navigationController popToViewController:self animated:YES];
    
    school.dschConsultCount++;
    
    con = aCon;
    [self reloadData_con];
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat fHeight = 0;
    LySchoolDetailTableViewTag tvTag = tableView.tag;
    switch (tvTag) {
        case schoolDetailTableViewTag_tc: {
            fHeight = tcHeight;
            break;
        }
        case schoolDetailTableViewTag_eva: {
            if (!bFlagSetEva) {
                bFlagSetEva = YES;
                
                if (LyChatCellHeightMin >= eva.height || eva.height > LyChatCellHeightMax) {
                    LyEvaluationForTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lySchoolDetailEvaluatinTableViewCellReuseIdentifier];
                    if (!cell) {
                        cell = [[LyEvaluationForTeacherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lySchoolDetailEvaluatinTableViewCellReuseIdentifier];
                    }
                    
                    cell.eva = eva;
                }
                
                fHeight = eva.height;
                
                self.tvEva.frame = CGRectMake(0, LyLbTitleItemHeight, SCREEN_WIDTH, fHeight);
                CGFloat fHeightViweEva = LyLbTitleItemHeight + fHeight;
                if (school.dschEvalutionCount > 1) {
                    btnFunc_eva.hidden = NO;
                    btnFunc_eva.frame = CGRectMake(SCREEN_WIDTH - horizontalSpace - LyBtnMoreWidth, fHeightViweEva, LyBtnMoreWidth, LyBtnMoreHeight);
                    
                    fHeightViweEva += LyBtnMoreHeight;
                } else {
                    btnFunc_eva.hidden = YES;
                }
                viewEva.frame = CGRectMake(0, viewPic.frame.origin.y + CGRectGetHeight(viewPic.frame) + verticalSpace, SCREEN_WIDTH, fHeightViweEva);
                
                [self reloadData_con];
                
            } else {
                fHeight = CGRectGetHeight(self.tvEva.frame);
            }
            
            break;
        }
        case schoolDetailTableViewTag_con: {
            if (!bFlagSetCon) {
                bFlagSetCon = YES;
                
                if (LyChatCellHeightMin >= con.height || con.height > LyChatCellHeightMax) {
                    LyConsultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lySchoolDetailConsultTableViewCellReuseIdentifier];
                    if (!cell) {
                        cell = [[LyConsultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lySchoolDetailConsultTableViewCellReuseIdentifier];
                    }
                    
                    cell.consult = con;
                }
                
                fHeight = con.height;
                
                self.tvCon.frame = CGRectMake(0, LyLbTitleItemHeight, SCREEN_WIDTH, fHeight);
                CGFloat fHeightViewCon = LyLbTitleItemHeight + fHeight;
                if (school.dschConsultCount > 1) {
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
    LySchoolDetailTableViewTag tvTag = tableView.tag;
    switch (tvTag) {
        case schoolDetailTableViewTag_tc: {
            curIdx_tc = indexPath;
            
            LyTrainClassDetailViewController *classDetail = [[LyTrainClassDetailViewController alloc] init];
            classDetail.delegate = self;
            [self.navigationController pushViewController:classDetail animated:YES];
            break;
        }
        case schoolDetailTableViewTag_eva: {
            LyEvaluationForTeacherDetailTableViewController *evaDetail = [[LyEvaluationForTeacherDetailTableViewController alloc] init];
            evaDetail.delegate = self;
            [self.navigationController pushViewController:evaDetail animated:YES];
            break;
        }
        case schoolDetailTableViewTag_con: {
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
    
    LySchoolDetailTableViewTag tvTag = tableView.tag;
    switch (tvTag) {
        case schoolDetailTableViewTag_tc: {
            iCount = arrClass.count;
            break;
        }
        case schoolDetailTableViewTag_eva: {
            iCount = eva ? 1 : 0;
            break;
        }
        case schoolDetailTableViewTag_con: {
            iCount = con ? 1 : 0;
            break;
        }
    }
    
    return iCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    LySchoolDetailTableViewTag tvTag = tableView.tag;
    switch (tvTag) {
        case schoolDetailTableViewTag_tc: {
            LyTrainClassTableViewCell *tCell = [tableView dequeueReusableCellWithIdentifier:lySchoolDetailTrainClassTableViewCellReuseIdentifier];
            if (!tCell) {
                tCell = [[LyTrainClassTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lySchoolDetailTrainClassTableViewCellReuseIdentifier];
            }
            
            tCell.trainClass = arrClass[indexPath.row];
            tCell.delegate = self;
            cell = tCell;
            break;
        }
        case schoolDetailTableViewTag_eva: {
            LyEvaluationForTeacherTableViewCell *tCell = [tableView dequeueReusableCellWithIdentifier:lySchoolDetailEvaluatinTableViewCellReuseIdentifier];
            if (!tCell) {
                tCell = [[LyEvaluationForTeacherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lySchoolDetailEvaluatinTableViewCellReuseIdentifier];
            }
            
            tCell.eva = eva;
            cell = tCell;
            break;
        }
        case schoolDetailTableViewTag_con: {
            LyConsultTableViewCell *tCell = [tableView dequeueReusableCellWithIdentifier:lySchoolDetailConsultTableViewCellReuseIdentifier];
            if (!tCell) {
                tCell = [[LyConsultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lySchoolDetailConsultTableViewCellReuseIdentifier];
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
    browser.imageCount = school.dschArrPicUrl.count;
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
    return school.dschArrPicUrl.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LyDriveSchoolDetailPicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lySchoolDetailPicCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    if (cell) {
        cell.strUrl = school.dschArrPicUrl[indexPath.row];
        cell.delegate = self;
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( sdCvItemSize, sdCvItemSize);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(verticalSpace, verticalSpace, verticalSpace, verticalSpace);
}


#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.ly_offsetY < 0)
    {
        CGFloat newHeight = sdViewInfoHeight - scrollView.ly_offsetY;
        CGFloat newWidth = SCREEN_WIDTH * newHeight / sdViewInfoHeight;
        
        CGFloat newX = (SCREEN_WIDTH - newWidth) / 2.0;
        CGFloat newY = scrollView.ly_offsetY;
        
        ivBanner.frame = CGRectMake(newX, newY, newWidth, newHeight);
    }
    else
    {
        ivBanner.frame = CGRectMake(0, 0, SCREEN_WIDTH, sdViewInfoHeight);
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
