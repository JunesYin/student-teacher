//
//  LyRegisterFirstViewController.m
//  teacher
//
//  Created by Junes on 16/7/15.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyRegisterFirstViewController.h"

#import "LyUtil.h"


#import "LyRegisterSecondViewController.h"


CGFloat const btnUserTypeWidth = 80.0f;
CGFloat const btnUserTypeHeight = 80.0f;

CGFloat const rfBtnItemMargin = 30.0f;


typedef NS_ENUM(NSInteger, RegisterFirstBarButtonTag)
{
    registerFirstBarButtonTag_close = 1,
    registerFirstBarButtonTag_next
};



@interface LyRegisterFirstViewController () <RegisterSecondDelegate>
{
    UIBarButtonItem             *bbiClose;
    
    UIButton                    *btnCoach;
    UIButton                    *btnSchool;
    UIButton                    *btnGuider;
    
    LyUserType                  userType;
}
@end

@implementation LyRegisterFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}


- (void)viewWillAppear:(BOOL)animated
{
    if ([[self.navigationController viewControllers] count] > 1)
    {
        if (self.navigationItem.leftBarButtonItem)
        {
            [self.navigationItem setLeftBarButtonItem:nil];
        }
    }
    else
    {
        if (!bbiClose)
        {
            bbiClose = [[UIBarButtonItem alloc] initWithTitle:LyLocalize(@"取消")
                                                           style:UIBarButtonItemStyleDone
                                                          target:self
                                                          action:@selector(targetForBarButtonItem:)];
//            bbiClose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                                     target:self
//                                                                     action:@selector(targetForBarButtonItem:)];
            [bbiClose setTag:registerFirstBarButtonTag_close];
        }
        [self.navigationItem setLeftBarButtonItem:bbiClose];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}



- (void)initAndLayoutSubviews
{
    self.navigationItem.title = LyLocalize(@"注册");
    [self.view setBackgroundColor: [UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    UIBarButtonItem *bbiNext = [[UIBarButtonItem alloc] initWithTitle:LyLocalize(@"下一步")
                                                                style:UIBarButtonItemStyleDone
                                                               target:self
                                                               action:@selector(targetForBarButtonItem:)];
    [bbiNext setTag:registerFirstBarButtonTag_next];
    [self.navigationItem setRightBarButtonItem:bbiNext];
    
    
    
    UILabel *lbRemindInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT+30.0f, SCREEN_WIDTH, 30.0f)];
    [lbRemindInfo setFont:[UIFont systemFontOfSize:14]];
    [lbRemindInfo setTextColor:LyBlackColor];
    lbRemindInfo.text = LyLocalize(@"请选择用户类型");
    [lbRemindInfo setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:lbRemindInfo];
    
    
    btnCoach = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f-btnUserTypeWidth/2.0f, lbRemindInfo.ly_y+CGRectGetHeight(lbRemindInfo.frame)+rfBtnItemMargin, btnUserTypeWidth, btnUserTypeHeight)];
    [btnCoach setImage:[LyUtil imageForImageName:@"tfr_btn_coach_n" needCache:NO] forState:UIControlStateNormal];
    [btnCoach setImage:[LyUtil imageForImageName:@"tfr_btn_coach_h" needCache:NO] forState:UIControlStateSelected];
    [btnCoach addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    btnSchool = [[UIButton alloc] initWithFrame:CGRectMake(btnCoach.frame.origin.x, btnCoach.ly_y+CGRectGetHeight(btnCoach.frame)+rfBtnItemMargin, btnUserTypeWidth, btnUserTypeHeight)];
    [btnSchool setImage:[LyUtil imageForImageName:@"tfr_btn_school_n" needCache:NO] forState:UIControlStateNormal];
    [btnSchool setImage:[LyUtil imageForImageName:@"tfr_btn_school_h" needCache:NO] forState:UIControlStateSelected];
    [btnSchool addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];

    btnGuider = [[UIButton alloc] initWithFrame:CGRectMake(btnSchool.frame.origin.x, btnSchool.ly_y+CGRectGetHeight(btnSchool.frame)+rfBtnItemMargin, btnUserTypeWidth, btnUserTypeHeight)];
    [btnGuider setImage:[LyUtil imageForImageName:@"tfr_btn_guider_n" needCache:NO] forState:UIControlStateNormal];
    [btnGuider setImage:[LyUtil imageForImageName:@"tfr_btn_guider_h" needCache:NO] forState:UIControlStateSelected];
    [btnGuider addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:btnCoach];
    [self.view addSubview:btnSchool];
    [self.view addSubview:btnGuider];
    
    
    UILabel *lbRemindAdd = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-horizontalSpace-40.0f, SCREEN_WIDTH, 30.0f)];
    [lbRemindAdd setFont:[UIFont systemFontOfSize:14]];
    [lbRemindAdd setTextColor:LyBlackColor];
    lbRemindAdd.text = LyLocalize(@"*注：自学直考的随车指导员请选择“指导员”");
    [lbRemindAdd setTextAlignment:NSTextAlignmentCenter];
    lbRemindAdd.numberOfLines = 0;
    [self.view addSubview:lbRemindAdd];
    
    
    
    [self targetForButton:btnCoach];
}




- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi
{
    if (registerFirstBarButtonTag_close == bbi.tag)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (registerFirstBarButtonTag_next == bbi.tag)
    {
        LyRegisterSecondViewController *registerSecond = [[LyRegisterSecondViewController alloc] init];
        [registerSecond setDelegate:self];
        [self.navigationController pushViewController:registerSecond animated:YES];
    }
}


- (void)targetForButton:(UIButton *)button
{
    if (button == btnCoach) {
        btnCoach.selected = YES;
        btnSchool.selected = NO;
        btnGuider.selected = NO;
        
        userType = LyUserType_coach;
    }
    else if (button == btnSchool) {
        btnCoach.selected = NO;
        btnSchool.selected = YES;
        btnGuider.selected = NO;
        
        userType = LyUserType_school;
    }
    else if (button == btnGuider) {
        btnCoach.selected = NO;
        btnSchool.selected = NO;
        btnGuider.selected = YES;
        
        userType = LyUserType_guider;
    }
}



#pragma mark -RegisterSecondDelegate
- (LyUserType)obtainUsetType:(LyRegisterSecondViewController *)rsVc
{
    return userType;
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
