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


int const cvStatesRowNumber = 4;
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
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            arrOrderStates = @[
                               @"全部",
                               @"交易中",
                               @"交易成功",
                               @"交易关闭"
                               ];
        });
        
        [cvStates selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    return self;
}



- (void)setOrderPayStatus:(LyOrderPayStatus)orderPayStatus
{
    _orderPayStatus = orderPayStatus;
    
    NSInteger index = 0;
    switch (_orderPayStatus) {
        case LyOrderPayStatus_ing: {
            index = 1;
            break;
        }
        case LyOrderPayStatus_done: {
            index = 2;
            break;
        }
        case LyOrderPayStatus_close: {
            index = 3;
            break;
        }
        default: {
            index = 0;
            break;
        }
    }
    
    [cvStates selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}



#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            _orderPayStatus = 5;
            break;
        }
        case 1: {
            _orderPayStatus = LyOrderPayStatus_ing;
            break;
        }
        case 2: {
            _orderPayStatus = LyOrderPayStatus_done;
            break;
        }
        case 3: {
            _orderPayStatus = LyOrderPayStatus_close;
            break;
        }
        default: {
            _orderPayStatus = 5;
            break;
        }
    }
    
    [_delegate orderStateView:self didSelectLyOrderPayStatus:self.orderPayStatus];
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
