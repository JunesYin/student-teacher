    //
//  LyActivity.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/5.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyActivity.h"


#import "LyMacro.h"
#import "LyUtil.h"



const NSInteger goCountMax = 3;


int const activityImageDefualtCount = 3;
int const activityImageMaxCount = 10;


CGFloat const activityNextTimeInterval = 5.0f;


CGFloat const activityPicMaxWidth = 400;




#define svActivityPcVerticalSpace                       svActivityHeight/7




@interface LyActivity () < UIScrollViewDelegate, LyHttpRequestDelegate>
{
    UIScrollView                        *svActivity;
    UIPageControl                       *pcActivity;
    
    UIImageView                         *leftIvPic;
    UIImageView                         *currentIvPic;
    UIImageView                         *rightIvPic;
    
    
    NSTimer                             *timer;
    
    NSMutableDictionary                 *dicImages;
    NSInteger                           currentImageIndex;
    
    BOOL                                flagFirst;
    
    UIImageView                         *ivDefault;
    
    NSInteger                           goCount;

    
    
    BOOL                                loadDoneFlag;
}
@end


@implementation LyActivity




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


lySingle_implementation(LyActivity)

- (instancetype)init
{
    CGRect rect = CGRectMake( 0, 0, svActivityWidth, svActivityHeight);
    if ( self = [super initWithFrame:rect]) {
        [self initAndLyaoutSubviews];
    }
    
    return self;
}



- (void)initAndLyaoutSubviews
{
    goCount = 0;
    dicImages = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    
    leftIvPic = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, svActivityWidth, svActivityHeight)];
    [leftIvPic setContentMode:UIViewContentModeScaleAspectFit];
    
    currentIvPic = [[UIImageView alloc] initWithFrame:CGRectMake( svActivityWidth, 0, svActivityWidth, svActivityHeight)];
    [currentIvPic setContentMode:UIViewContentModeScaleAspectFit];
    
    rightIvPic = [[UIImageView alloc] initWithFrame:CGRectMake( svActivityWidth*2, 0, svActivityWidth, svActivityHeight)];
    [rightIvPic setContentMode:UIViewContentModeScaleAspectFit];
    
    
    svActivity = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 0, svActivityWidth, svActivityHeight)];
    [svActivity setContentSize:CGSizeMake( svActivityWidth*3, svActivityHeight)];
    [svActivity setPagingEnabled:YES];
    [svActivity setDelegate:self];
    [svActivity setScrollsToTop:NO];
    [svActivity setShowsHorizontalScrollIndicator:NO];
    [svActivity setShowsVerticalScrollIndicator:NO];
    [svActivity setTranslatesAutoresizingMaskIntoConstraints:YES];
    [svActivity setContentOffset:CGPointMake(svActivityWidth, 0) animated:NO];
    

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForTagGesture)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:tapGesture];
    
    
    
    [svActivity addSubview:leftIvPic];
    [svActivity addSubview:currentIvPic];
    [svActivity addSubview:rightIvPic];
    
    
    
    pcActivity = [[UIPageControl alloc] initWithFrame:CGRectMake( 0, svActivityHeight-svActivityPcVerticalSpace, SCREEN_WIDTH, svActivityPcVerticalSpace)];
    [pcActivity setPageIndicatorTintColor:[UIColor whiteColor]];
    [pcActivity setCurrentPageIndicatorTintColor:Ly517ThemeColor];
    
    [self addSubview:svActivity];
    [self addSubview:pcActivity];
    
    
    
    if ( [self respondsToSelector:@selector(targetForAppDidEnterBackground:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(targetForAppDidEnterBackground:) name:LyAppDidEnterBackground object:nil];
    }
    
    if ( [self respondsToSelector:@selector(targetForAppDidBecomeActive:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(targetForAppDidBecomeActive:) name:LyAppDidBecomeActive object:nil];
    }

}


- (void)go {
    
    if (goCount++ > goCountMax) {
        _count = activityImageDefualtCount;
        [self loadData:_count];
        return;
    }
    
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:activityCount_url
             body:nil
             type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
           if (error) {
               
           } else {
               NSDictionary *dic = [self analysisHttpResult:resStr];
               if (!dic) {
                   [self handleHttpFailed];
               }
               
               NSString *strCount = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:resultKey]];
               if (![LyUtil validateString:strCount]) {
                   [self handleHttpFailed];
               }
               
               _count = strCount.integerValue;
               [self loadData:_count];
           }
       }];
}


////使用http加载
//- (void)loadData {
//    
//    if (dicImages && dicImages.count > 0) {
//        return;
//    }
//    
//    ivDefault = [[UIImageView alloc] initWithFrame:self.bounds];
//    [ivDefault setContentMode:UIViewContentModeScaleAspectFit];
//    [ivDefault setImage:[LyUtil imageForImageName:@"activity_default" needCache:NO]];
//    
//    [self addSubview:ivDefault];
//    
//    if ( !dicImages)
//    {
//        dicImages = [[NSMutableDictionary alloc] initWithCapacity:1];
//    }
//    
//    NSString *imageName = nil;
//    NSString *strUrl = nil;
//    for ( int i = 0; i < activityImageMaxCount; ++i) {
//        imageName = [[NSString alloc] initWithFormat:@"activity_item_%d.png", i];
//
//        strUrl = activity_url(imageName);
//#ifdef __Ly__HTTPS__FLAG__
//        strUrl = [strUrl stringByReplacingOccurrencesOfString:@"https://" withString:@"http://"];
//#endif
//        
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]]];
//        if ( !image) {
//            break;
//        }
//        
//        if (image.size.width > activityPicMaxWidth) {
//            image = [image scaleToSize:CGSizeMake(activityPicMaxWidth, activityPicMaxWidth/2.0f)];
//        }
//        
//        [dicImages setObject:image forKey:[[NSString alloc] initWithFormat:@"%d", (int)i]];
//    }
//    
//
//    [self loadDone];
//}



//使用https加载
- (void)loadData:(NSInteger)count {
    
    _count = (count > activityImageMaxCount) ? activityImageMaxCount : count;
    
    if (dicImages && dicImages.count > 0) {
        return;
    }
    
    ivDefault = [[UIImageView alloc] initWithFrame:self.bounds];
    [ivDefault setContentMode:UIViewContentModeScaleAspectFit];
    [ivDefault setImage:[LyUtil imageForImageName:@"activity_default" needCache:NO]];
    
    [self addSubview:ivDefault];
    
    if ( !dicImages)
    {
        dicImages = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    NSString *imageName = nil;
    
    for ( int i = 0; i < _count; ++i) {
        imageName = [[NSString alloc] initWithFormat:@"activity_item_%d.png", i];
        
        [LyImageLoader loadImageWithUrl:[NSURL URLWithString:activity_url(imageName)]
                               complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable url) {
                                   if (image) {
                                       NSString *strUrl = [url description];
                                       NSRange range_item_ = [strUrl rangeOfString:@"item_"];
                                       NSRange range_point = [strUrl rangeOfString:@".png"];
//                                       if (range_point.length < 1) {
//                                           range_point = [strUrl rangeOfString:@".jpg"];
//                                       }
                                       
                                       NSRange range_index = NSMakeRange(range_item_.location + range_item_.length,
                                                                         range_point.location - range_item_.location - range_item_.length);
                                       NSString *strIdex = [strUrl substringWithRange:range_index];
                                       
                                       if (image.size.width > activityPicMaxWidth) {
                                           image = [image scaleToSize:CGSizeMake(activityPicMaxWidth, activityPicMaxWidth / 2.0f)];
                                       }
                                       
                                       [dicImages setObject:image forKey:strIdex];
                                   }
                                   
                                   if (dicImages.count == _count) {
                                       [self loadDone];
                                   }
                               }];
        
        
    }
    
}



- (void)loadDone {
    
    if (loadDoneFlag) {
        return;
    }
    
    loadDoneFlag = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ( _count < 2)
        {
            [pcActivity setHidden:YES];
        }
        else
        {
            [pcActivity setHidden:NO];
            [pcActivity setNumberOfPages:_count];
        }
        
        
        [self setDefaultImage];
    });
}




- (void)setDefaultImage
{
    currentImageIndex = 0;
    [pcActivity setCurrentPage:currentImageIndex];
    
    if ( _count > 0)
    {
        [ivDefault removeFromSuperview];
        
        [leftIvPic setImage:[dicImages objectForKey:[[NSString alloc] initWithFormat:@"%d", (int)((_count-1+_count)%_count)]]];
        [currentIvPic setImage:[dicImages objectForKey:@"0"]];
        [rightIvPic setImage:[dicImages objectForKey:[[NSString alloc] initWithFormat:@"%d", (int)((_count+1)%_count)]]];
        
        if ( [_delegate respondsToSelector:@selector(activitiViewHasReady:)]) {
            NSLog(@"activity is ready");
            if ( [self superview]) {
                [self removeFromSuperview];
            }
            [_delegate activitiViewHasReady:self];
        }
    }
    
    
    if ( _count > 1)
    {
        timer = [NSTimer timerWithTimeInterval:activityNextTimeInterval target:self selector:@selector(targetForTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [timer fire];
    }
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self reloadImage];
    
    [svActivity setContentOffset:CGPointMake( svActivityWidth, 0) animated:NO];
    
    [pcActivity setCurrentPage:currentImageIndex];
    
}




- (void)reloadImage
{
    NSInteger leftImageIndex, rightImageIndex;
    
    CGPoint offSet = [svActivity contentOffset];
    
    if ( _count < 1)
    {
        return;
    }
    
    if ( offSet.x > svActivityWidth)
    {
        currentImageIndex = (currentImageIndex + 1) % _count;
    }
    else if ( offSet.x < svActivityWidth)
    {
        currentImageIndex = (currentImageIndex - 1 + _count) % _count;
    }
    
    
    [currentIvPic setImage:[dicImages objectForKey:[[NSString alloc] initWithFormat:@"%d", (int)currentImageIndex]]];
    
    leftImageIndex = (currentImageIndex + _count - 1) % _count;
    rightImageIndex = (currentImageIndex + 1) % _count;
    
    
    [leftIvPic setImage:[dicImages objectForKey:[[NSString alloc] initWithFormat:@"%d", (int)leftImageIndex]]];
    [rightIvPic setImage:[dicImages objectForKey:[[NSString alloc] initWithFormat:@"%d", (int)rightImageIndex]]];
    
    
}



- (void)targetForTagGesture
{
    NSString *strUrl = [[NSString alloc] initWithFormat:@"%d", (int)currentImageIndex];
    
    NSLog(@"activity___tap___currentIndex = %@", strUrl);
    
    if ( [_delegate respondsToSelector:@selector(onClickedByActivity:withIndex:andUrl:)])
    {
        [_delegate onClickedByActivity:self withIndex:currentImageIndex andUrl:[NSURL URLWithString:@"http://m.517xueche.com"]];
    }
}



- (void)targetForTimer:(NSTimer *)ti
{
    [svActivity setContentOffset:CGPointMake( svActivityWidth*2, 0) animated:YES];
    
    [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:nil afterDelay:0.3f];
}



- (void)targetForAppDidBecomeActive:(NSNotification *)notification
{
//    if ( flagFirst)
//    {
        timer = [NSTimer timerWithTimeInterval:activityNextTimeInterval target:self selector:@selector(targetForTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [timer fire];
//    }
    
//    flagFirst = YES;
}


- (void)targetForAppDidEnterBackground:(NSNotification *)notification
{
    [timer invalidate];
}


- (void)handleHttpFailed {
    [self go];
}

- (NSDictionary *)analysisHttpResult:(NSString *)result {
    NSDictionary *dic = [LyUtil getObjFromJson:result];
    if (![LyUtil validateDictionary:dic]) {
        [self handleHttpFailed];
        return nil;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (![LyUtil validateString:strCode]) {
        [self handleHttpFailed];
        return nil;
    }
    
    if (codeMaintaining == strCode.integerValue) {
        [self handleHttpFailed];
        return nil;
    }
    
    return dic;
    
}


@end





