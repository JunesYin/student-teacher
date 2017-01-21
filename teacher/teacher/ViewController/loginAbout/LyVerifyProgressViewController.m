//
//  LyVerifyProgressViewController.m
//  teacher
//
//  Created by Junes on 16/9/20.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyVerifyProgressViewController.h"

#import "LyCurrentUser.h"

#import "LyUtil.h"

#import "LyAuthPhotoViewController.h"


#define vpIvProgressSize            (SCREEN_WIDTH*9/10.0f)

CGFloat const vpLbProgressHeight = 30.0f;

CGFloat const vpTvReasonHeight = 100.0f;

CGFloat const vpBtnReauthWidth = 100.0f;
CGFloat const vpBtnReauthHeight = 30.0f;


enum {
    verifyProgressBarButtonItemTag_close = 0,
}LyVerifyProgressBarButtonItemTag;

enum {
    verifyProgressButtonTag_reauth = 10,
}LyVerifyProgressButtonTag;


@interface LyVerifyProgressViewController () {
    UIImageView             *ivProgress;
    UILabel                 *lbProgress;
    
    UITextView              *tvReason;
    UIButton                *btnReauth;
}
@end

@implementation LyVerifyProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}


- (void)viewWillAppear:(BOOL)animated {
    [self reloadViewData];
}


- (void)initAndLayoutSubviews {
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    UIBarButtonItem *bbiClose = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(targetForBarButtonItem:)];
    [bbiClose setTag:verifyProgressBarButtonItemTag_close];
    [self.navigationItem setLeftBarButtonItem:bbiClose];
    
    
    ivProgress = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f-vpIvProgressSize/2.0f, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT+horizontalSpace, vpIvProgressSize, vpIvProgressSize)];
    [self.view addSubview:ivProgress];
    
    
    lbProgress = [[UILabel alloc] initWithFrame:CGRectMake(0, ivProgress.ly_y+CGRectGetHeight(ivProgress.frame)+horizontalSpace, SCREEN_WIDTH, vpLbProgressHeight)];
    [lbProgress setFont:LyFont(16)];
    [lbProgress setTextAlignment:NSTextAlignmentCenter];
    [lbProgress setNumberOfLines:0];
    [self.view addSubview:lbProgress];
}


- (void)reloadViewData {
    switch ([LyCurrentUser curUser].verifyState) {
        case LyTeacherVerifyState_null: {
            [ivProgress setImage:[LyUtil imageForImageName:@"verifyProgress_verifying" needCache:NO]];
            
            [lbProgress setText:@"提交成功，等待认证..."];
            break;
        }
        case LyTeacherVerifyState_rejected: {
            self.title = @"认证失败";
            
            [ivProgress setImage:[LyUtil imageForImageName:@"verifyProgress_rejected" needCache:NO]];
            [lbProgress setText:@"认证失败"];
            [lbProgress setTextColor:LyWarnColor];
            
            if (!tvReason) {
                tvReason = [[UITextView alloc] initWithFrame:CGRectMake(horizontalSpace, lbProgress.ly_y+CGRectGetHeight(lbProgress.frame)+horizontalSpace, SCREEN_WIDTH-horizontalSpace*4, vpTvReasonHeight)];
                [tvReason setFont:LyFont(14)];
                [tvReason setTextColor:LyBlackColor];
                [tvReason setTextAlignment:NSTextAlignmentLeft];
                [tvReason setBackgroundColor:LyWhiteLightgrayColor];
                [tvReason setSelectable:NO];
                
                [self.view addSubview:tvReason];
            }
            
            if (!btnReauth) {
                btnReauth = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-vpBtnReauthWidth-horizontalSpace, SCREEN_HEIGHT-vpBtnReauthHeight, vpBtnReauthWidth, vpBtnReauthHeight)];
                [btnReauth setTag:verifyProgressButtonTag_reauth];
                [btnReauth.titleLabel setFont:LyFont(14)];
                [btnReauth setTitle:@"再次认证" forState:UIControlStateNormal];
                [btnReauth setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
//                [btnReauth setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                [btnReauth addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.view addSubview:btnReauth];
            }
            
            break;
        }
        case LyTeacherVerifyState_verifying: {
            self.title = @"正在认证";
            
            [ivProgress setImage:[LyUtil imageForImageName:@"verifyProgress_verifying" needCache:NO]];
            [lbProgress setTextColor:[UIColor blackColor]];
            [lbProgress setText:@"我们正在努力...请耐心等待"];
            break;
        }
        case LyTeacherVerifyState_access: {
            
            break;
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    
    if (verifyProgressBarButtonItemTag_close == bbi.tag) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)targetForButton:(UIButton *)btn {
    
    if (verifyProgressButtonTag_reauth == btn.tag) {
        LyAuthPhotoViewController *authPhoto = [[LyAuthPhotoViewController alloc] init];
        [self.navigationController pushViewController:authPhoto animated:YES];
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
