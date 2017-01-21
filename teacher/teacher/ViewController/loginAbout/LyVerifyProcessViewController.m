//
//  LyVerifyProcessViewController.m
//  teacher
//
//  Created by Junes on 16/8/1.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyVerifyProcessViewController.h"

#import "LyCurrentUser.h"

#import "LyUtil.h"

#define ivProgressSize                  (FULLSCREENWIDTH*4/5.0f)
CGFloat const lbProcessHeight = 30.0f;

CGFloat const tvReasonHeight = 100.0f;


@interface LyVerifyProcessViewController ()
{
    UIImageView             *ivProcess;
    
    UILabel                 *lbProcess;
    
    UITextView              *tvReason;
}
@end

@implementation LyVerifyProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self reloadViewData];
}


- (void)initAndLayoutSubviews
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    ivProcess = [[UIImageView alloc] initWithFrame:CGRectMake(FULLSCREENWIDTH/2.0f-ivProgressSize/2.0f, STATUSBARHEIGHT+NAVIGATIONBARHEIGHT+FULLSCREENWIDTH/2.0f-ivProgressSize/2.0f, ivProgressSize, ivProgressSize)];
    [self.view addSubview:ivProcess];
    
    
    lbProcess = [[UILabel alloc] initWithFrame:CGRectMake(0, ivProcess.frame.origin.y+CGRectGetHeight(ivProcess.frame)+20.0f, FULLSCREENWIDTH, lbProcessHeight)];
    [lbProcess setFont:LyFont(20)];
    [lbProcess setTextAlignment:NSTextAlignmentCenter];
    [lbProcess setNumberOfLines:0];
    [self.view addSubview:lbProcess];
}


- (void)reloadViewData
{
    switch ([LyCurrentUser currentUser].verifyState) {
        case LyTeacherVerifyState_null: {
            break;
        }
        case LyTeacherVerifyState_rejected: {
            self.title = @"被拒绝";
            
            [ivProcess setBackgroundColor:LyWrongColor];
            [lbProcess setTextColor:LyWrongColor];
            [lbProcess setText:@"被拒绝"];
            
            if (!tvReason)
            {
                tvReason = [[UITextView alloc] initWithFrame:CGRectMake(horizontalSpace, lbProcess.frame.origin.y+CGRectGetHeight(lbProcess.frame)+10.0f, FULLSCREENWIDTH-horizontalSpace*2, tvReasonHeight)];
                [tvReason setFont:LyFont(14)];
                [tvReason setTextColor:[UIColor grayColor]];
                [tvReason setTextAlignment:NSTextAlignmentLeft];
                
                [self.view addSubview:tvReason];
            }
            
            break;
        }
        case LyTeacherVerifyState_verifying: {
            self.title = @"正在认证";
            
            [ivProcess setBackgroundColor:LyBlueColor];
            [lbProcess setTextColor:LyBlackColor];
            [lbProcess setText:@"我们正在努力...请耐心等待"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
