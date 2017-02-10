//
//  LyGuideViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/16.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyGuideViewController.h"
//#import "LyRootViewController.h"
#import "LyUtil.h"


int const GEGUIDEPAGECOUNT = 5;
CGFloat const GEBTNPUSHWIDTH = 120.0f;
#define GEBTNPUSHHEIGHT                 (GEBTNPUSHWIDTH/3.0f)

CGFloat const GEBTNPUSHHEIGHTSPACE = 60.0f;


CGFloat const geBtnSkipSize = 50;


@interface LyGuideViewController () <UIScrollViewDelegate>
{
    NSMutableDictionary     *geDicImage;
    NSInteger               geImageCount;
    
    UIButton        *btnSkip;
    
    UIButton                *geBtnPush;
    NSInteger               geCurrentIndex;
    
    
    UIScrollView            *geScrollView;
    UIPageControl           *gePageControl;
}

@end

@implementation LyGuideViewController




- (instancetype)init {
    if ( self = [super init]) {
        
    }
    
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self geLayoutUI];
}




- (void)viewWillDisAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}




- (void)geLayoutUI
{
    
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    geCurrentIndex = 0;
 
    
    
    for ( int i = 0; i < GEGUIDEPAGECOUNT; ++i)
    {
        UIImage *tmpImage = [LyUtil imageForImageName:[[NSString alloc] initWithFormat:@"a_welcome_%d", i] needCache:NO];
        
        if ( !tmpImage)
        {
            break;
        }
        
        if ( !geDicImage)
        {
            geDicImage = [[NSMutableDictionary alloc] initWithCapacity:1];
        }
        
        [geDicImage setObject:tmpImage forKey:[[NSString alloc] initWithFormat:@"%d", i]];
        
    }
    
    
    
    geImageCount = [geDicImage count];
    
    
    geScrollView = [[UIScrollView alloc] initWithFrame:SCREEN_BOUNDS];
    [self.view addSubview:geScrollView];
    [geScrollView setDelegate:self];
    [geScrollView setContentSize:CGSizeMake( SCREEN_WIDTH*geImageCount, SCREEN_HEIGHT)];
    [geScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [geScrollView setPagingEnabled:YES];
    [geScrollView setBounces:NO];
    [geScrollView setShowsVerticalScrollIndicator:NO];
    [geScrollView setShowsHorizontalScrollIndicator:NO];
    
    

    for ( int i = 0; i < geImageCount; ++i) {
        [geScrollView addSubview:[self imageViewWithIndex:i]];
    }
    
    
    
    geBtnPush = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH*(geImageCount-1)+SCREEN_WIDTH/2.0f-GEBTNPUSHWIDTH/2.0, SCREEN_HEIGHT-GEBTNPUSHHEIGHTSPACE-GEBTNPUSHHEIGHT, GEBTNPUSHWIDTH, GEBTNPUSHHEIGHT)];
    [geBtnPush setBackgroundImage:[LyUtil imageForImageName:@"guide_btn_start" needCache:NO] forState:UIControlStateNormal];
    [geBtnPush addTarget:self action:@selector(geTargetForBtnPush) forControlEvents:UIControlEventTouchUpInside];
//    [geBtnPush setHidden:YES];
    
    [geScrollView addSubview:geBtnPush];
    
    
    
    gePageControl = [[UIPageControl alloc] init];
    CGSize sizeGePageControl = [gePageControl sizeForNumberOfPages:GEGUIDEPAGECOUNT];
    [gePageControl setBounds:CGRectMake( 0, 0, sizeGePageControl.width, sizeGePageControl.height)];
    [gePageControl setCenter:CGPointMake( SCREEN_WIDTH/2, SCREEN_HEIGHT-30)];
    gePageControl.pageIndicatorTintColor=[UIColor colorWithRed:193/255.0 green:219/255.0 blue:249/255.0 alpha:1];
    // set color for cur page
    gePageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
    // set count for page
    gePageControl.numberOfPages = geImageCount;
    [self.view addSubview:gePageControl];
    
    
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

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    geCurrentIndex = [scrollView contentOffset].x / scrollView.bounds.size.width;
    
    if (geCurrentIndex >= geDicImage.count - 1) {
        [gePageControl setHidden:YES];
        btnSkip.hidden = YES;
    } else {
        [gePageControl setHidden:NO];
        btnSkip.hidden = NO;
        [gePageControl setCurrentPage:geCurrentIndex];
    }
}



- (void)geTargetForBtnPush {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    if (_delegate && [_delegate respondsToSelector:@selector(onClickButtonStart:)]) {
        [_delegate onClickButtonStart:self];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
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
