//
//  LyTeachViewController.m
//  teacher
//
//  Created by Junes on 16/7/30.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyTeachViewController.h"

@interface LyTeachViewController ()


@end

@implementation LyTeachViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)initAndLayoutSubviews
{
    self.title = @"教学";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.tabBarItem.title = @"教学";
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
