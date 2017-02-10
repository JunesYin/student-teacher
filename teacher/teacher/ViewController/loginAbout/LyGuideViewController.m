//
//  LyGuideViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/16.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyGuideViewController.h"

#import "LyUtil.h"


int const guidePageCountMax = 5;

CGFloat const btnPushWidth = 120.0f;
CGFloat const btnPushHeight = 40.0f;

CGFloat const btnPushBottomSpace = 60.0f;

CGFloat const geBtnSkipSize = 50;


@interface LyGuideViewController () <UIScrollViewDelegate>
{
    NSMutableDictionary     *geDicImage;
    
    UIButton        *btnSkip;
    
    UIButton                *geBtnPush;
    NSInteger               geCurrentIndex;
}

@end

@implementation LyGuideViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self geLayoutUI];
}


- (instancetype)init {
    
    if ( self = [super init]) {
        
    }
    
    return self;
}



- (void)viewWillDisAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}




- (void)geLayoutUI {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    geCurrentIndex = 0;
    
    for ( int i = 0; i < guidePageCountMax; ++i) {
        
        UIImage *tmpImage = [LyUtil imageForImageName:[[NSString alloc] initWithFormat:@"a_guide_%d", i] needCache:NO];
        
        if ( !tmpImage) {
            break;
        }
        
        if ( !geDicImage) {
            geDicImage = [[NSMutableDictionary alloc] initWithCapacity:1];
        }
        
        [geDicImage setObject:tmpImage forKey:[[NSString alloc] initWithFormat:@"%d", i]];
        
    }
    
    
    _geScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_geScrollView];
    [_geScrollView setDelegate:self];
    [_geScrollView setContentSize:CGSizeMake( SCREEN_WIDTH*geDicImage.count, SCREEN_HEIGHT)];
    [_geScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [_geScrollView setPagingEnabled:YES];
    [_geScrollView setBounces:NO];
    [_geScrollView setShowsVerticalScrollIndicator:NO];
    [_geScrollView setShowsHorizontalScrollIndicator:NO];
    
    
    for ( int i = 0; i < geDicImage.count; ++i) {
        [_geScrollView addSubview:[self imageViewWithIndex:i]];
    }
    
    
    geBtnPush = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH*(geDicImage.count-1)+SCREEN_WIDTH/2.0f-btnPushWidth/2.0, SCREEN_HEIGHT-btnPushBottomSpace-btnPushHeight, btnPushWidth, btnPushHeight)];
//    [geBtnPush setBackgroundImage:[UIImage imageWithContentsOfFile:[bundlePath stringByAppendingString:@"/images/guide_btn_start"]] forState:UIControlStateNormal];
    [geBtnPush setBackgroundImage:[UIImage imageWithContentsOfFile:[LyUtil imagePathForImageName:@"a_guide_btn_start"]] forState:UIControlStateNormal];
    [geBtnPush addTarget:self action:@selector(geTargetForBtnPush) forControlEvents:UIControlEventTouchUpInside];
//    [geBtnPush setHidden:YES];
    
    [_geScrollView addSubview:geBtnPush];
    
    
    
    _gePageControl = [[UIPageControl alloc] init];
    CGSize sizeGePageControl = [_gePageControl sizeForNumberOfPages:geDicImage.count];
    [_gePageControl setBounds:CGRectMake( 0, 0, sizeGePageControl.width, sizeGePageControl.height)];
    [_gePageControl setCenter:CGPointMake( SCREEN_WIDTH/2, SCREEN_HEIGHT-30)];
    _gePageControl.pageIndicatorTintColor=[UIColor colorWithRed:193/255.0 green:219/255.0 blue:249/255.0 alpha:1];
    //设置当前页颜色
    _gePageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
    //设置总页数
    _gePageControl.numberOfPages = geDicImage.count;
    [self.view addSubview:_gePageControl];
    
    
    // Skip
    btnSkip = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - geBtnSkipSize - horizontalSpace, horizontalSpace, geBtnSkipSize, geBtnSkipSize)];
    btnSkip.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
    btnSkip.layer.cornerRadius = geBtnSkipSize / 2.0;
    btnSkip.clipsToBounds = YES;
    [btnSkip setTitle:@"跳过" forState:UIControlStateNormal];
    [btnSkip addTarget:self action:@selector(actionForBtnSkip) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnSkip];
    
}



- (UIImageView *)imageViewWithIndex:(int)index
{
    CGRect tmpRect = CGRectMake( SCREEN_WIDTH*index, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:tmpRect];
    [tmpImageView setImage:[geDicImage objectForKey:[[NSString alloc] initWithFormat:@"%d", index]]];
    [tmpImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    return tmpImageView;
}







- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    geCurrentIndex = [scrollView contentOffset].x / scrollView.bounds.size.width;
    
    if (geCurrentIndex >= geDicImage.count - 1) {
        [_gePageControl setHidden:YES];
        btnSkip.hidden = YES;
    } else {
        [_gePageControl setHidden:NO];
        btnSkip.hidden = NO;
        [_gePageControl setCurrentPage:geCurrentIndex];
    }
}



- (void)geTargetForBtnPush {
    
    if ( [_delegate respondsToSelector:@selector(onClickButtonStartByGuideViewController:)]) {
        [_delegate onClickButtonStartByGuideViewController:self];
    } else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}


- (void)actionForBtnSkip {
    [self geTargetForBtnPush];
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
