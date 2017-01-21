//
//  LyTeachByTimeDetailViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/20.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyTeachByTimeDetailViewController.h"

#import "LyIndicator.h"
#import "SDPhotoBrowser.h"

#import "LyUtil.h"


@interface LyTeachByTimeDetailViewController () < UIScrollViewDelegate, SDPhotoBrowserDelegate>
{
    UIScrollView                *svMain;
    UIView                      *viewError;
    
    
    UITextView                  *tvContentUpper;
    UIView                      *viewIv;
//    UIImageView                 *ivImage;
    UIImage                     *image;
    UITextView                  *tvContentLower;
    
    UIRefreshControl                *refresher;
    LyIndicator                     *indicator_load;
    
    BOOL                        flagLoadSuccess;
}
@end

@implementation LyTeachByTimeDetailViewController

//lySingle_implementation(LyTeachByTimeDetailViewController)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubviews];
}



- (void)viewWillAppear:(BOOL)animated
{
//    if ( !flagLoadSuccess)
//    {
        [self refreshData:refresher];
//    }
}


- (void)initSubviews
{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    
    self.title = @"计时培训";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    UIBarButtonItem *closeSelf = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(targetForBarButtonCloseSelf)];
    [self.navigationItem setLeftBarButtonItem:closeSelf];
    
    svMain = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-(STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT))];
    [svMain setBackgroundColor:[UIColor whiteColor]];
    [svMain setDelegate:self];
    [svMain setBounces:YES];
    [self.view addSubview:svMain];
    
    refresher = [[UIRefreshControl alloc] init];
    NSMutableAttributedString *strRefresherTitle = [[NSMutableAttributedString alloc] initWithString:@"正在加载"];
    [strRefresherTitle addAttribute:NSForegroundColorAttributeName value:LyRefresherColor range:NSMakeRange( 0, [@"正在加载" length])];
    [refresher setAttributedTitle:strRefresherTitle];
    [refresher addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [refresher setTintColor:LyRefresherColor];
    [svMain addSubview:refresher];
    
    
    tvContentUpper = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.0f)];
    [tvContentUpper setTextColor:LyBlackColor];
    [tvContentUpper setFont:LyFont(14)];
    [tvContentUpper setEditable:NO];
    [tvContentUpper setScrollsToTop:NO];
    [tvContentUpper setScrollEnabled:NO];
    [tvContentUpper setBackgroundColor:[UIColor clearColor]];
    [tvContentUpper setTextAlignment:NSTextAlignmentLeft];
    
    viewIv = [[UIView alloc] init];
    [viewIv setBackgroundColor:[UIColor whiteColor]];
//    ivImage = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, 10.0f)];
//    [ivImage setContentMode:UIViewContentModeScaleAspectFit];
//    
//    [viewIv addSubview:ivImage];
    
    
    tvContentLower = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.0f)];
    [tvContentLower setTextColor:LyBlackColor];
    [tvContentLower setFont:LyFont(14)];
    [tvContentLower setEditable:NO];
    [tvContentLower setScrollsToTop:NO];
    [tvContentLower setScrollEnabled:NO];
    [tvContentLower setBackgroundColor:[UIColor clearColor]];
    [tvContentLower setTextAlignment:NSTextAlignmentLeft];
    [tvContentLower setSelectable:NO];
    
    
    [svMain addSubview:tvContentUpper];
    [svMain addSubview:viewIv];
    [svMain addSubview:tvContentLower];

}



- (void)showViewError
{
    flagLoadSuccess = NO;
    if ( !viewError)
    {
        viewError = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.2f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        UILabel *lbError = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, LyLbErrorHeight)];
        [lbError setBackgroundColor:LyWhiteLightgrayColor];
        [lbError setFont:LyNullItemTitleFont];
        [lbError setTextColor:LyNullItemTextColor];
        [lbError setTextAlignment:NSTextAlignmentCenter];
        [lbError setText:@"加载失败，下拉再次加载"];
        
        [viewError addSubview:lbError];
    }
    
    [svMain setContentSize:CGSizeMake( SCREEN_WIDTH, SCREEN_HEIGHT*1.2f)];
    [svMain addSubview:viewError];
    [svMain bringSubviewToFront:viewError];
}


- (void)removeViewError
{
    flagLoadSuccess = YES;
    [viewError removeFromSuperview];
}



- (void)refreshData:(UIRefreshControl *)refreshControl
{
    [self simulateNetwork];
}



- (void)simulateNetwork
{
    if ( !indicator_load)
    {
        indicator_load = [[LyIndicator alloc] initWithTitle:@""];
    }
    [indicator_load startAnimation];
    
    float delayTime = (arc4random() % (16 - 1) + 1) / 10.0f;
    [self performSelector:@selector(refreshSelf) withObject:nil afterDelay:delayTime];
}



- (void)refreshSelf
{
    NSError *errorUpper;
    NSString *txtPathUpper = [LyUtil filePathForFileName:@"teachByTimeDetail_1.txt"];
    NSString *strContentUpper = [NSString stringWithContentsOfFile:txtPathUpper encoding:NSUTF8StringEncoding error:&errorUpper];


    if ( !errorUpper)
    {
        [tvContentUpper setTextAlignment:NSTextAlignmentLeft];
        [tvContentUpper setText:strContentUpper];
        
        CGFloat fHeight =  [tvContentUpper sizeThatFits:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)].height;
        [tvContentUpper setFrame:CGRectMake( 0, 0, SCREEN_WIDTH, fHeight)];
    }
    else
    {
        [indicator_load stopAnimation];
        [self showViewError];
        return;
    }
    
    image = [LyUtil imageForImageName:@"teachByTimeDetail" needCache:NO];
    if ( image)
    {
        UIImageView *ivImage = [[UIImageView alloc] init];
        [ivImage setImage:image];
        CGFloat fWidthIvImage = SCREEN_WIDTH-horizontalSpace*2;
        CGFloat fHeightIvImage = fWidthIvImage * image.size.height / image.size.width;
        
        [viewIv addSubview:ivImage];
        [viewIv setFrame:CGRectMake( horizontalSpace, tvContentUpper.frame.origin.y+CGRectGetHeight(tvContentUpper.frame), fWidthIvImage, fHeightIvImage)];
        [ivImage setFrame:viewIv.bounds];
        [ivImage setImage:image];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForImageTap)];
        [tapGesture setNumberOfTapsRequired:1];
        [tapGesture setNumberOfTouchesRequired:1];
        
        [viewIv setUserInteractionEnabled:YES];
        [viewIv addGestureRecognizer:tapGesture];
    }
    else
    {
        [indicator_load stopAnimation];
        [self showViewError];
        return;
    }
    
    
    
    NSError *errorLower;
    NSString *txtPathLower = [LyUtil filePathForFileName:@"teachByTimeDetail_2.txt"];
    NSString *strContentLower = [NSString stringWithContentsOfFile:txtPathLower encoding:NSUTF8StringEncoding error:&errorLower];
    
    if ( !errorLower)
    {
        [tvContentLower setTextAlignment:NSTextAlignmentLeft];
        [tvContentLower setText:strContentLower];
        
        CGFloat fHeight =  [tvContentLower sizeThatFits:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)].height;
        [tvContentLower setFrame:CGRectMake( 0, viewIv.frame.origin.y+CGRectGetHeight(viewIv.frame), SCREEN_WIDTH, fHeight)];
    }
    else
    {
        [indicator_load stopAnimation];
        [self showViewError];
        return;
    }
    
    
    CGFloat fHeightForSvSize = tvContentLower.frame.origin.y+CGRectGetHeight(tvContentLower.frame);
    fHeightForSvSize = ( fHeightForSvSize > SCREEN_HEIGHT) ? fHeightForSvSize : SCREEN_HEIGHT;
    [svMain setContentSize:CGSizeMake( SCREEN_WIDTH, fHeightForSvSize)];
    
    
    [indicator_load stopAnimation];
    [refresher endRefreshing];
    
}


- (void)targetForBarButtonCloseSelf
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}


- (void)targetForImageTap
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = viewIv; // 原图的父控件
    browser.imageCount = 1;
    browser.currentImageIndex = 0;
    browser.delegate = self;
    [browser show];
}



#pragma mark -SDPhotoBrowserDelegate
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return image;
}


- (BOOL)isAllowSaveImage:(SDPhotoBrowser *)brower
{
    return NO;
}

//- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;


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
