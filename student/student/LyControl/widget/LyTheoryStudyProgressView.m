//
//  LyTheoryStudyProgressView.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/24.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyTheoryStudyProgressView.h"

#import "LyUtil.h"


#define lbTextWidth             (CGRectGetWidth(self.frame)*3/4.0f)
#define lbTextHeight            lbTextWidth
#define lbTextFont              LyFont(10)

typedef NS_ENUM( NSInteger, LyTheoryStudyProgressViewCollectionViewCellMode)
{
    theoryStudyProgressViewCollectionViewCellMode_normal,
    theoryStudyProgressViewCollectionViewCellMode_right,
    theoryStudyProgressViewCollectionViewCellMode_wrong
};

@interface LyTheoryStudyProgressViewCollectionViewCell : UICollectionViewCell
{
    UILabel             *lbText;
}


@property ( assign, nonatomic)      LyTheoryStudyProgressViewCollectionViewCellMode     mode;
@property ( assign, nonatomic)      NSInteger               text;

@end

@implementation LyTheoryStudyProgressViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        lbText = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetWidth(self.frame)/2.0f-lbTextWidth/2.0f, CGRectGetHeight(self.frame)/2.0f-lbTextHeight/2.0f, lbTextWidth, lbTextHeight)];
        [lbText setBackgroundColor:[UIColor whiteColor]];
        [lbText setFont:lbTextFont];
        [lbText setTextAlignment:NSTextAlignmentCenter];
        [[lbText layer] setCornerRadius:lbTextWidth/2.0f];
        [[lbText layer] setBorderWidth:1.0f];
        [lbText setClipsToBounds:YES];
        
        [self addSubview:lbText];
    }
    
    return self;
}


- (void)setMode:(LyTheoryStudyProgressViewCollectionViewCellMode)mode
{
    _mode = mode;
    
    switch ( _mode) {
        case theoryStudyProgressViewCollectionViewCellMode_normal: {
            
            [[lbText layer] setBorderColor:[LyLightgrayColor CGColor]];
            [lbText setTextColor:LyBlackColor];
            
            break;
        }
        case theoryStudyProgressViewCollectionViewCellMode_right: {
            
            [[lbText layer] setBorderColor:[LyRightColor CGColor]];
            [lbText setTextColor:LyRightColor];
            
            break;
        }
        case theoryStudyProgressViewCollectionViewCellMode_wrong: {
            
            [[lbText layer] setBorderColor:[LyWrongColor CGColor]];
            [lbText setTextColor:LyWrongColor];
            
            break;
        }
    }
}


- (void)setText:(NSInteger)text
{
    _text = text;
    
    [lbText setText:[[NSString alloc] initWithFormat:@"%d", (int)_text]];
}


@end



#define tspvWidth                   SCREEN_WIDTH
#define tspvHeight                  SCREEN_HEIGHT



#define btnMaskWidth                tspvWidth
#define btnMaskHeight               tspvHeight

#define viewUsefulWidth             tspvWidth
#define viewUsefulHeight            (tspvHeight*2.0/3.0f)

#define viewInfoWidth               viewUsefulWidth
#define viewInfoHeight              40.0f

#define lbProgressWidth             (viewInfoWidth/3.0f)
#define lbProgressHeight            viewInfoHeight
#define lbProgressFont              LyFont(12)

#define btnCloseWidth               20.0f
#define btnCloseHeight              btnCloseWidth

#define lbAnswerDetailWidth         (viewInfoWidth/3.0f)
#define lbAnswerDetailHeight        viewInfoHeight
#define lbAnswerDetailFont          lbProgressFont

#define cvProgressWidth             viewUsefulWidth
#define cvProgressHeight            (viewUsefulHeight-viewInfoHeight-verticalSpace)

#define cvProgressItemWidth         (cvProgressWidth/5.0f)
#define cvProgressItemHeight        cvProgressItemWidth


typedef NS_ENUM( NSInteger, LyTheoryStudyProgressViewButtonItemMode)
{
    theoryStudyProgressViewButtonItemMode_close,
};


@interface LyTheoryStudyProgressView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UIButton                *btnMask;
    
    UIView                  *viewUseful;
    UIView                  *viewInfo;
    UILabel                 *lbProgress;
    UIButton                *btnClose;
    UILabel                 *lbAnswerDetail;
    
    UICollectionView        *cvProgress;
    
    
    CGPoint                 centerViewUseful;
}
@end


@implementation LyTheoryStudyProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

static NSString *lyTheoryStudyProgressViewProgressCollectionViewCellResuseIdentifier = @"lyTheoryStudyProgressViewProgressCollectionViewCellResuseIdentifier";


- (instancetype)init
{
    if ( self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        [self initSubviews];
    }
    
    return self;
}



- (void)initSubviews
{
    btnMask = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [btnMask setBackgroundColor:LyMaskColor];
    [btnMask setTag:theoryStudyProgressViewButtonItemMode_close];
    [btnMask addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnMask];
    
    viewUseful = [[UIView alloc] initWithFrame:CGRectMake( 0, SCREEN_HEIGHT-viewUsefulHeight, viewUsefulWidth, viewUsefulHeight)];
    centerViewUseful = [viewUseful center];
    
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, viewInfoWidth, viewInfoHeight)];
    [viewInfo setBackgroundColor:LyWhiteLightgrayColor];
    
    lbProgress = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, 0, lbProgressWidth, lbProgressHeight)];
    [lbProgress setFont:lbProgressFont];
    [lbProgress setTextColor:LyDarkgrayColor];
    [lbProgress setTextAlignment:NSTextAlignmentLeft];
    [lbProgress setText:@"0/0"];
    
    btnClose = [[UIButton alloc] initWithFrame:CGRectMake( viewInfoWidth/2.0f-btnCloseWidth/2.0f, viewInfoHeight/2.0f-btnCloseHeight/2.0f, btnCloseWidth, btnCloseHeight)];
    [btnClose setTag:theoryStudyProgressViewButtonItemMode_close];
    [btnClose setImage:[LyUtil imageForImageName:@"progressView_btn_close" needCache:NO] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    lbAnswerDetail = [[UILabel alloc] initWithFrame:CGRectMake( viewInfoWidth-horizontalSpace-lbAnswerDetailWidth, 0, lbAnswerDetailWidth, lbAnswerDetailHeight)];
    [lbAnswerDetail setFont:lbAnswerDetailFont];
    [lbAnswerDetail setTextAlignment:NSTextAlignmentRight];
    
    [viewInfo addSubview:lbProgress];
    [viewInfo addSubview:btnClose];
    [viewInfo addSubview:lbAnswerDetail];
    
    
    UICollectionViewFlowLayout *progressCollectionVIewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [progressCollectionVIewFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [progressCollectionVIewFlowLayout setMinimumLineSpacing:0];
    [progressCollectionVIewFlowLayout setMinimumInteritemSpacing:0];
    cvProgress = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, viewInfo.frame.origin.y+CGRectGetHeight(viewInfo.frame), cvProgressWidth, cvProgressHeight)
                                    collectionViewLayout:progressCollectionVIewFlowLayout];
    [cvProgress setDelegate:self];
    [cvProgress setDataSource:self];
    [cvProgress setBackgroundColor:[UIColor whiteColor]];
    [cvProgress setShowsVerticalScrollIndicator:NO];
    [cvProgress setShowsHorizontalScrollIndicator:NO];
    [cvProgress registerClass:[LyTheoryStudyProgressViewCollectionViewCell class] forCellWithReuseIdentifier:lyTheoryStudyProgressViewProgressCollectionViewCellResuseIdentifier];
    
    [viewUseful addSubview:viewInfo];
    [viewUseful addSubview:cvProgress];
    
    
    [self addSubview:viewUseful];
    
    
}


- (void)setAllCount:(NSInteger)allCount
{
    _allCount = allCount;
    
    [lbProgress setText:[[NSString alloc] initWithFormat:@"%ld/%ld", _currentIndex, _allCount]];
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    
    [lbProgress setText:[[NSString alloc] initWithFormat:@"%ld/%ld", _currentIndex, _allCount]];
}


- (void)targetForButtonItem:(UIButton *)button
{
    switch ( [button tag]) {
        case theoryStudyProgressViewButtonItemMode_close: {
            
            if ( [_delegate respondsToSelector:@selector(onCloseByTheoryStudyProgressView:)])
            {
                [_delegate onCloseByTheoryStudyProgressView:self];
            }
            break;
        }
    }
}



- (void)show
{
    
    [btnMask setHidden:YES];
    [viewUseful setHidden:YES];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [LyUtil startAnimationWithView:btnMask
                 animationDuration:0.3f
                         initAlpha:0.0f
                 destinationAplhas:1.0f
                         completion:^(BOOL finished) {
                             [btnMask setHidden:NO];
                         }];
    
    
    [LyUtil startAnimationWithView:viewUseful
                 animationDuration:0.3f
                      initialPoint:CGPointMake( centerViewUseful.x, centerViewUseful.y+CGRectGetHeight(viewUseful.frame))
                  destinationPoint:centerViewUseful
                        completion:^(BOOL finished) {
                            [viewUseful setHidden:NO];
                        }];
}


- (void)hide
{
    [LyUtil startAnimationWithView:viewUseful
                 animationDuration:0.3f
                      initialPoint:centerViewUseful
                  destinationPoint:CGPointMake( centerViewUseful.x, centerViewUseful.y+CGRectGetHeight(viewUseful.frame))
                        completion:^(BOOL finished) {
                            [viewUseful setCenter:centerViewUseful];
                        }];
    
    [LyUtil startAnimationWithView:btnMask
                 animationDuration:0.3f
                         initAlpha:1.0f
                 destinationAplhas:0.0f
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                             [btnMask setAlpha:1.0f];
                         }];
}



- (void)setAnswerInfo:(NSDictionary *)answerInfo
{
    _answerInfo = answerInfo;
    
    [cvProgress reloadData];
}



#pragma mark --UICollectionViewDelegate
//UICollectionViewCell被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [_delegate respondsToSelector:@selector(onClickedItemByTheoryStudyProgressView:andItemIndex:)])
    {
        [_delegate onClickedItemByTheoryStudyProgressView:self andItemIndex:[indexPath row]+1];
    }
    else
    {
        [self hide];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//返回这个UICollectionViewCell是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _allCount;
}

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LyTheoryStudyProgressViewCollectionViewCell *tmpCell = [collectionView dequeueReusableCellWithReuseIdentifier:lyTheoryStudyProgressViewProgressCollectionViewCellResuseIdentifier forIndexPath:indexPath];
    
    if ( tmpCell)
    {
        [tmpCell setText:[indexPath row]+1];
        
        if ( [_answerInfo objectForKey:[[NSString alloc] initWithFormat:@"%d", (int)[indexPath row]+1]])
        {
            [tmpCell setMode:theoryStudyProgressViewCollectionViewCellMode_right];
        }
        else
        {
            [tmpCell setMode:theoryStudyProgressViewCollectionViewCellMode_normal];
        }
    }
    
    return tmpCell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( cvProgressItemWidth, cvProgressItemHeight);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake( 0, 0, 0, 0);
}




@end
