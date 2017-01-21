//
//  LyOrderStateView.m
//  teacher
//
//  Created by Junes on 16/8/15.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyOrderStateView.h"
#import "LyFragmentCollectionViewCell.h"

#import "LyUtil.h"


CGFloat const LyOrderStateViewHeight = 40.0f;


int const cvStatesRowNumber = 5;
#define cvStatesCellWidth                       (SCREEN_WIDTH/cvStatesRowNumber)

@interface LyOrderStateView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UICollectionView            *cvStates;
}
@end


@implementation LyOrderStateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

static NSString *const lyOrderStateCvStatesCellReuseIdentifier = @"lyOrderStateCvStatesCellReuseIdentifier";
static NSArray *arrOrderStates = nil;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, SCREEN_WIDTH, LyOrderStateViewHeight)])
    {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            arrOrderStates = @[
                               @"全部",
                               @"待支付",
                               @"待确认",
                               @"待评价",
                               @"已完成"
                               ];
        });
        
        UICollectionViewFlowLayout *cvStatesFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        [cvStatesFlowLayout setMinimumLineSpacing:0];
        [cvStatesFlowLayout setMinimumInteritemSpacing:0];
        [cvStatesFlowLayout setItemSize:CGSizeMake(cvStatesCellWidth, LyOrderStateViewHeight)];
        [cvStatesFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        cvStates = [[UICollectionView alloc] initWithFrame:self.bounds
                                      collectionViewLayout:cvStatesFlowLayout];
        [cvStates setDelegate:self];
        [cvStates setDataSource:self];
        [cvStates setBackgroundColor:[UIColor whiteColor]];
        [cvStates setScrollsToTop:NO];
        [cvStates registerClass:[LyFragmentCollectionViewCell class] forCellWithReuseIdentifier:lyOrderStateCvStatesCellReuseIdentifier];
        [self addSubview:cvStates];
        
        [cvStates selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                               animated:NO
                         scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    return self;
}

- (void)setOrderState:(LyOrderState)orderState {
    
    _orderState = orderState;
    NSInteger index = 0;
    if (5 == _orderState) {
        index = 0;
    } else {
        index = _orderState + 1;
    }
    
    [cvStates selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                           animated:NO
                     scrollPosition:UICollectionViewScrollPositionNone];
}

#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        _orderState = 5;
    } else {
        _orderState = indexPath.row - 1;
    }
    
    [_delegate orderStateView:self didSelectItemAtIndex:_orderState];
}


#pragma mark -UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return cvStatesRowNumber;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LyFragmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lyOrderStateCvStatesCellReuseIdentifier forIndexPath:indexPath];
    
    if (cell)
    {
        [cell setTitle:[arrOrderStates objectAtIndex:indexPath.row]];
    }
    
    return cell;
}


#pragma mark -UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}



@end
