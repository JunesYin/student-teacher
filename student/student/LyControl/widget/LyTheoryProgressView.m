//
//  LyTheoryProgressView.m
//  student
//
//  Created by MacMini on 2016/12/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyTheoryProgressView.h"
#import "LyTheoryProgressCollectionViewCell.h"

#import "LyQuestion.h"

#import "LyUtil.h"

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



typedef NS_ENUM( NSInteger, LyTheoryProgressViewButtonTag)
{
    theoryProgressViewButtonTag_close,
};


@interface LyTheoryProgressView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
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


@implementation LyTheoryProgressView

static NSString *lyTheoryProgressCollectionViewCellReuseIdentifier = @"lyTheoryProgressCollectionViewCellReuseIdentifier";

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



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
    [btnMask setTag:theoryProgressViewButtonTag_close];
    [btnMask addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
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
    [btnClose setTag:theoryProgressViewButtonTag_close];
    [btnClose setImage:[LyUtil imageForImageName:@"progressView_btn_close" needCache:NO] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    
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
    [cvProgress registerClass:[LyTheoryProgressCollectionViewCell class] forCellWithReuseIdentifier:lyTheoryProgressCollectionViewCellReuseIdentifier];
    
    [viewUseful addSubview:viewInfo];
    [viewUseful addSubview:cvProgress];
    
    
    [self addSubview:viewUseful];
    
    
}


- (void)setArrQuestion:(NSArray *)arrQuestion
{
    _arrQuestion = arrQuestion;
    
    [lbProgress setText:[[NSString alloc] initWithFormat:@"%ld/%ld", _curIdx, _arrQuestion.count]];
}

- (void)setCurIdx:(NSInteger)curIdx
{
    _curIdx = curIdx;
    
    [lbProgress setText:[[NSString alloc] initWithFormat:@"%ld/%ld", _curIdx + 1, _arrQuestion.count]];
}


- (void)targetForButton:(UIButton *)button
{
    switch ( [button tag]) {
        case theoryProgressViewButtonTag_close: {
            
            if ( [_delegate respondsToSelector:@selector(onCloseByTheoryProgressView:)])
            {
                [_delegate onCloseByTheoryProgressView:self];
            }
            else
            {
                [self hide];
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
    [cvProgress reloadData];
    
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




#pragma mark --UICollectionViewDelegate
//UICollectionViewCell被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [_delegate respondsToSelector:@selector(theoryProgressView:didSelectItemAtIndex:)])
    {
        [_delegate theoryProgressView:self didSelectItemAtIndex:indexPath.row];
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
    return _arrQuestion.count;
}

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LyTheoryProgressCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lyTheoryProgressCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    if ( cell) {
        [cell setText:[indexPath row]+1];
        LyTheoryProgressCollectionViewCellMode cellMode = LyTheoryProgressCollectionViewCellMode_normal;
        
        if (indexPath.row == _curIdx) {
            cellMode = LyTheoryProgressCollectionViewCellMode_focus;
        } else {
            switch (_mode) {
                case LyTheoryProgressViewMode_execise: {
                    LyQuestion *question = _arrQuestion[indexPath.row];
                    if ([LyUtil validateString:question.myAnswer]) {
                        if ([question judge]) {
                            cellMode = LyTheoryProgressCollectionViewCellMode_right;
                        } else {
                            cellMode = LyTheoryProgressCollectionViewCellMode_wrong;
                        }
                    }
                    break;
                }
                case LyTheoryProgressViewMode_exam: {
                    if ([LyUtil validateString:[_arrQuestion[indexPath.row] myAnswer]]) {
                        cellMode = LyTheoryProgressCollectionViewCellMode_choosed;
                    }
                    break;
                }
            }
        }

        
        [cell setMode:cellMode];
    }
    
    return cell;
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
