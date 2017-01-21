//
//  Ly517ProtocolViewController.m
//  517Xueche_teacher
//
//  Created by Junes on 16/5/7.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyTxtViewController.h"

#import "LyIndicator.h"

#import "LyUtil.h"




@interface LyTxtViewController ()
{
    UIRefreshControl                *refresher;
    LyIndicator                     *indicator_load;
    
    UITextView                      *tvContent;
}
@end

@implementation LyTxtViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubview];
}


- (void)viewWillAppear:(BOOL)animated
{
    
}


- (void)initAndLayoutSubview
{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    UIBarButtonItem *closeSelf = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(targetForBarButtonCloseSelf)];
    [self.navigationItem setLeftBarButtonItem:closeSelf];
    
    
    
    tvContent = [[UITextView alloc] initWithFrame:CGRectMake( 0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-(STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT))];
    [tvContent setBackgroundColor:[UIColor whiteColor]];
    [tvContent setTextColor:LyBlackColor];
    [tvContent setFont:LyFont(14)];
    [tvContent setEditable:NO];
    [tvContent setSelectable:NO];
    [tvContent setBackgroundColor:[UIColor clearColor]];
    [tvContent setTextAlignment:NSTextAlignmentLeft];
    
    
    refresher = [LyUtil refreshControlWithTitle:nil
                                         target:self
                                         action:@selector(refresh:)];
    [tvContent addSubview:refresher];
    
    
    [self.view addSubview:tvContent];
    
}



- (void)refresh:(UIRefreshControl *)refreshControl
{
    [self simulateNetwork];
}


- (void)simulateNetwork
{
    if ( !indicator_load) {
        indicator_load = [[LyIndicator alloc] initWithTitle:@""];
    }
    [indicator_load startAnimation];
    
    NSString *strNavigationTitle;
    NSString *strFileName;
    switch ( _mode) {
        case LyTxtViewControllerMode_517UserProtocol: {
            strNavigationTitle = @"吾要去用户协议";
            strFileName = @"517UserProtocol.txt";
            break;
        }
        case LyTxtViewControllerMode_517InfoServiceProtocol: {
            strNavigationTitle = @"信息服务协议";
            strFileName = @"517InfoServiceProtocol.txt";
            break;
        }
        case LyTxtViewControllerMode_517CooperationProtocol: {
            strNavigationTitle = @"我要去学车合作协议";
            strFileName = @"517CooperationProtocol.txt";
            break;
        }
        case LyTxtViewControllerMode_FAQ: {
            strNavigationTitle = @"常见问题";
            strFileName = @"FAQ.txt";
            break;
        }
    }
    

    [self.navigationItem setTitle:strNavigationTitle];
    
    
    float delayTime = (arc4random() % (15 - 1) + 1) / 10.0f;
    

    [self performSelector:@selector(refreshSelf:) withObject:strFileName afterDelay:delayTime];
}



- (void)refreshSelf:(NSString *)strFileName
{
    NSError *error;
//    NSString *txtPath = [[NSBundle mainBundle] pathForResource:strFileName ofType:@"txt"];
    NSString *txtPath = [LyUtil filePathForFileName:strFileName];
    
    NSString *strContent = [NSString stringWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:&error];
    
    if ( error)
    {
        [tvContent setTextAlignment:NSTextAlignmentCenter];
        [tvContent setText:@"出错，下拉再次加载"];
        [tvContent setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.2f)];
    }
    else
    {
        [tvContent setTextAlignment:NSTextAlignmentLeft];
        [tvContent setText:strContent];
    }
    
    [indicator_load stopAnimation];
    [refresher endRefreshing];
}



- (void)setMode:(LyTxtViewControllerMode)mode
{
    _mode = mode;
    
    
    [self simulateNetwork];
}



- (void)targetForBarButtonCloseSelf
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
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
