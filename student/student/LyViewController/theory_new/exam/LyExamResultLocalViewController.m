//
//  LyExamResultLocalViewController.m
//  student
//
//  Created by MacMini on 2016/12/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyExamResultLocalViewController.h"
#import "LyTheoryStudyControlBar.h"

#import "LyIndicator.h"
#import "LyRemindView.h"
#import "LyShareView.h"

#import "LyQuestion.h"
#import "LyExamHistory.h"

#import "LyCurrentUser.h"
#import "LyShareManager.h"

#import "LyUtil.h"


#import "LyExamMistakeLocalViewController.h"



CGFloat const erlIvAvatarSize = 70.0f;
CGFloat const erlLbNameHeight = 30.0f;


#define erlLbNameFont               LyFont(16)

#define erlLbExamScoreFont          LyFont(14)
#define erlLbExamScoreNumFont       LyFont(24)




@interface LyExamResultLocalViewController () <LyTheoryStudyControlBarDelegate, LyShareViewDelegate, LyExamMistakeLocalViewControllerDelegate>
{
    UIScrollView        *svMain;
    
    UIImageView         *ivAvatar;
    UILabel             *lbName;
    
    UIView              *viewExamScore;
    UILabel             *lbExamScore;
    
    UIImageView         *ivExamLevel;
    
    
    NSMutableArray      *arrMistakes;
    BOOL                flagOper;
}

@property (strong, nonatomic)       LyTheoryStudyControlBar     *controlBar;

@property (strong, nonatomic)       LyIndicator     *indicator;

@end

@implementation LyExamResultLocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    if (flagOper) {
        return;
    }
    
    flagOper = YES;
    
    [self cacluScore];
    [self writExamScore];
    [self writMistake];
    [self reloadData];
}

- (void)initSubviews {
    self.title = @"全真模考";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT - tscbHeight)];
    [svMain setBackgroundColor:[UIColor whiteColor]];
    
    
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f - erlIvAvatarSize/2.0f, verticalSpace * 4, erlIvAvatarSize, erlIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFit];
    [ivAvatar.layer setCornerRadius:erlIvAvatarSize / 2.0f];
    [ivAvatar setClipsToBounds:YES];
    
    lbName = [[UILabel alloc] initWithFrame:CGRectMake(0, ivAvatar.frame.origin.y + erlIvAvatarSize, SCREEN_WIDTH, erlLbNameHeight)];
    [lbName setFont:erlLbNameFont];
    [lbName setTextColor:[UIColor blackColor]];
    [lbName setTextAlignment:NSTextAlignmentCenter];
    
    
    viewExamScore = [[UIView alloc] initWithFrame:CGRectMake(0, lbName.frame.origin.y + erlLbNameHeight, SCREEN_WIDTH, SCREEN_WIDTH/2.0f)];
    
    UIImageView *ivBack = [[UIImageView alloc] initWithFrame:viewExamScore.bounds];
    [ivBack setContentMode:UIViewContentModeScaleAspectFit];
    [ivBack setImage:[LyUtil imageForImageName:@"simulate_result_info" needCache:NO]];
    
    lbExamScore = [[UILabel alloc] initWithFrame:viewExamScore.bounds];
    [lbExamScore setFont:erlLbExamScoreFont];
    [lbExamScore setTextColor:[UIColor whiteColor]];
    [lbExamScore setTextAlignment:NSTextAlignmentCenter];
    [lbExamScore setNumberOfLines:0];
    
    [viewExamScore addSubview:ivBack];
    [viewExamScore addSubview:lbExamScore];
    
    
    
    ivExamLevel = [[UIImageView alloc] initWithFrame:CGRectMake(0, viewExamScore.frame.origin.y + CGRectGetHeight(viewExamScore.frame) + verticalSpace * 4, SCREEN_WIDTH, SCREEN_WIDTH/2.0f)];
    [ivExamLevel setContentMode:UIViewContentModeScaleAspectFit];
    
    [svMain addSubview:ivAvatar];
    [svMain addSubview:lbName];
    [svMain addSubview:viewExamScore];
    [svMain addSubview:ivExamLevel];
    
    [svMain setContentSize:CGSizeMake(SCREEN_WIDTH, ivExamLevel.frame.origin.y + CGRectGetHeight(ivExamLevel.frame) + 50.0f)];

    
    [self.view addSubview:svMain];
    [self.view addSubview:self.controlBar];
    
}


- (LyTheoryStudyControlBar *)controlBar {
    if (!_controlBar) {
        _controlBar = [LyTheoryStudyControlBar theoryStudyControlBarWithMode:theoryStudyControlBar_simulate_commited];
        [_controlBar setDelegate:self];
    }
    
    return _controlBar;
}

- (LyIndicator *)indicator {
    if (!_indicator) {
        _indicator = [LyIndicator indicatorWithTitle:nil];
    }
    
    return _indicator;
}

- (void)reloadData {
    if ([LyCurrentUser curUser].isLogined) {
        if ([LyCurrentUser curUser].userAvatar) {
            [ivAvatar setImage:[LyCurrentUser curUser].userAvatar];
            
        } else {
            [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:[LyCurrentUser curUser].userId]
                        placeholderImage:[LyUtil defaultAvatarForStudent]
                               completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                   if (image) {
                                       [[LyCurrentUser curUser] setUserAvatar:image];
                                   } else {
                                       [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:[LyCurrentUser curUser].userId]
                                                   placeholderImage:[LyUtil defaultAvatarForStudent]
                                                          completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                                              if (image) {
                                                                  [[LyCurrentUser curUser] setUserAvatar:image];
                                                              }
                                                          }];
                                   }
                               }];
        }
        [lbName setText:[LyCurrentUser curUser].userName];
        
    } else {
        [ivAvatar setImage:[LyUtil defaultAvatarForStudent]];
        [lbName setText:@"尊敬的517用户"];
    }
    
    NSString *sExamScoreNum = [[NSString alloc] initWithFormat:@"%ld", _score];
    NSString *sExamScoreTmp = [[NSString alloc] initWithFormat:@"%@分\n用时%@", sExamScoreNum, [LyUtil translateSecondsToClock:_useMinutes]];
    NSMutableAttributedString *sExamScore = [[NSMutableAttributedString alloc] initWithString:sExamScoreTmp];
    [sExamScore addAttribute:NSFontAttributeName value:erlLbExamScoreNumFont range:[sExamScoreTmp rangeOfString:sExamScoreNum]];
    [lbExamScore setAttributedText:sExamScore];
    
    NSString *strImageName;
    switch ( [LyExamHistory cacluExamLevel:_score]) {
        case LyExamLevel_killer: {
            strImageName = @"simulate_level_killer";
            break;
        }
        case LyExamLevel_newbird: {
            strImageName = @"simulate_level_newbird";
            break;
        }
        case LyExamLevel_mass: {
            strImageName = @"simulate_level_mass";
            break;
        }
        case LyExamLevel_superior: {
            strImageName = @"simulate_level_superior";
            break;
        }
        default: {
            strImageName = @"simulate_level_killer";
            break;
        }
    }
    [ivExamLevel setImage:[LyUtil imageForImageName:strImageName needCache:NO]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)cacluScore {
    NSInteger tmpScore = 0;
    for (LyQuestion *questoin in _arrQuestion) {
        if ([questoin judge]) {
            tmpScore++;
        } else {
            if ([LyUtil validateString:questoin.myAnswer]) {
                if (!arrMistakes) {
                    arrMistakes = [[NSMutableArray alloc] initWithCapacity:1];
                }
                
                [arrMistakes addObject:questoin];
            }
        }
            
    }
    
    
    if ( LySubjectMode_fourth == [[LyCurrentUser curUser] userSubjectMode])
    {
        _score = tmpScore * 2;
    }
    else
    {
        _score = tmpScore;
    }
}

- (void)writExamScore {
    NSString *sqlInsert = [[NSString alloc] initWithFormat:@"INSERT INTO %@ (userid, jtype, score, usetime, stime) \
                           VALUES ('%@', '%@', %@, '%@', '%@')",
                           LyRecordTableName_examScore,
                           [LyCurrentUser curUser].userIdForTheory,
                           [[LyCurrentUser curUser] userLicenseTypeByString],
                           @(_score),
                           [LyUtil translateSecondsToClock:_useMinutes],
                           [LyUtil stringFromDate:[NSDate date]]
                           ];
    BOOL flag = [[LyUtil dbRecord] executeUpdate:sqlInsert];
    
    NSInteger count;
    NSString *sqlCount = [[NSString alloc] initWithFormat:@"SELECT COUNT(id) AS count FROM %@ WHERE userid = '%@'",
                             LyRecordTableName_examScore,
                             [LyCurrentUser curUser].userIdForTheory
                             ];
    FMResultSet *rsCount = [[LyUtil dbRecord] executeQuery:sqlCount];
    while ([rsCount next]) {
        count = [rsCount intForColumn:@"count"];
        break;
    }
    
    if (count > 10) {
        NSString *sqlDel = [[NSString alloc] initWithFormat:@"DELETE FROM %@ WHERE id = (SELECT MIN(id) FROM %@ WHERE userid = '%@')",
                            LyRecordTableName_examScore,
                            LyRecordTableName_examScore,
                            [LyCurrentUser curUser].userIdForTheory
                            ];
        BOOL flagDel = [[LyUtil dbRecord] executeUpdate:sqlDel];
    }
    
    
}

- (void)writMistake {
    for (LyQuestion *question in arrMistakes) {
        NSString *sId = nil;
        NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT id FROM %@ WHERE userid = '%@' AND tid = %@",
                              LyRecordTableName_exeMistake,
                              [LyCurrentUser curUser].userIdForTheory,
                              question.queId
                              ];
        FMResultSet *rsMistake = [[LyUtil dbRecord] executeQuery:sqlQuery];
        while ([rsMistake next]) {
            sId = [rsMistake stringForColumn:@"id"];
            break;
        }
        
        if (sId) {
            NSString *sqlUpdate = [[NSString alloc] initWithFormat:@"UPDATE %@ SET errors = errors + 1, myanswer = '%@' WHERE id = %@",
                                   LyRecordTableName_exeMistake,
                                   question.myAnswer,
                                   sId];
            BOOL flag = [[LyUtil dbRecord] executeUpdate:sqlUpdate];
            
        } else {
            NSString *sqlInsert = [[NSString alloc] initWithFormat:
                                   @"INSERT INTO %@ (subjects, ChpaterId, tid, myanswer , userid, errors, jtype)   \
                                   VALUES (%@, %@, %@, '%@', '%@', %@, '%@')",
                                   LyRecordTableName_exeMistake,
                                   @([LyCurrentUser curUser].userSubjectMode),
                                   @(question.queChapterId),
                                   question.queId,
                                   question.myAnswer,
                                   [LyCurrentUser curUser].userIdForTheory,
                                   @(1),
                                   [[LyCurrentUser curUser] userLicenseTypeByString]
                                   ];
            BOOL flag = [[LyUtil dbRecord] executeUpdate:sqlInsert];
            
        }
        
    }
}

#pragma mark -LyTheoryStudyControlBarDelegate
- (void)onClickedButtonViewMistake:(LyTheoryStudyControlBar *)theoryStudyControlBar
{
    if (!arrMistakes || arrMistakes.count < 1) {
        [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"没有错题"] show];
        return;
    }
    
    LyExamMistakeLocalViewController *examMistake = [[LyExamMistakeLocalViewController alloc] init];
    [examMistake setArrQuestion:arrMistakes];
    [examMistake setDelegate:self];
    [self.navigationController pushViewController:examMistake animated:YES];
}

- (void)onClickedButtonShare:(LyTheoryStudyControlBar *)theoryStudyControlBar
{
    LyShareView *shareView = [[LyShareView alloc] init];
    [shareView setDelegate:self];
    [shareView show];
}

- (void)onClickedButtonRetest:(LyTheoryStudyControlBar *)theoryStudyControlBar
{
    [_delegate onReexamByExamResultLocalViewController:self];
}


#pragma mark -LyExamMistakeLocalViewControllerDelegate
- (void)onReexamByExamMistakeLocalViewController:(LyExamMistakeLocalViewController *)aExamMistakeLocalVC
{
    [_delegate onReexamByExamResultLocalViewController:self];
}




#pragma mark -LyShareViewDelegate
- (void)onClickButtonClose:(LyShareView *)aShareView
{
    [aShareView hide];
}

- (void)onSharedByQQFriend:(LyShareView *)aShareView
{
    [aShareView hide];
    
    [LyShareManager share:SSDKPlatformSubTypeQQFriend
               alertTitle:@"分享给QQ好友"
                  content:shareContent_exam(_score)
                   images:@[
                            [LyUtil imageForImageName:@"icon_517" needCache:NO]
                            ]
                    title:shareTitle
                      url:[NSURL URLWithString:share_url]
           viewController:self];
}

- (void)onSharedByQQZone:(LyShareView *)aShareView
{
    [aShareView hide];
    
    [LyShareManager share:SSDKPlatformSubTypeQZone
               alertTitle:@"分享到QQ空间"
                  content:shareContent_exam(_score)
                   images:@[
                            [LyUtil imageForImageName:@"icon_517" needCache:NO]
                            ]
                    title:shareTitle
                      url:[NSURL URLWithString:share_url]
           viewController:self];
}

- (void)onSharedByWeiBo:(LyShareView *)aShareView
{
    [aShareView hide];
    
    [LyShareManager share:SSDKPlatformTypeSinaWeibo
               alertTitle:@"分享到微博"
                  content:shareContent_exam_sinaWeibo(_score)
                   images:@[
                            [LyUtil imageForImageName:@"icon_517" needCache:NO]
                            ]
                    title:shareTitle
                      url:[NSURL URLWithString:share_url]
           viewController:self];
}

- (void)onSharedByWeChatFriend:(LyShareView *)aShareView
{
    [aShareView hide];
    
    [LyShareManager share:SSDKPlatformSubTypeWechatSession
               alertTitle:@"分享给微信好友"
                  content:shareContent_exam(_score)
                   images:@[
                            [LyUtil imageForImageName:@"icon_517" needCache:NO]
                            ]
                    title:shareTitle
                      url:[NSURL URLWithString:share_url]
           viewController:self];
}

- (void)onSharedByWeChatMoments:(LyShareView *)aShareView
{
    [aShareView hide];
    
    [LyShareManager share:SSDKPlatformSubTypeWechatTimeline
               alertTitle:@"分享到朋友圈"
                  content:shareContent_exam(_score)
                   images:@[
                            [LyUtil imageForImageName:@"icon_517" needCache:NO]
                            ]
                    title:shareTitle
                      url:[NSURL URLWithString:share_url]
           viewController:self];
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
