//
//  LyStudentProgressView.m
//  teacher
//
//  Created by Junes on 16/8/17.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyStudentProgressView.h"
#import "LyFragmentCollectionViewCell.h"
#import "LyUtil.h"


CGFloat const LyStudentProgressViewHeight = 50.0f;

int const cvProgressItemNumber = 5;

#define cvProgressItemWidth             (SCREEN_WIDTH/cvProgressItemNumber)

@interface LyStudentProgressView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UICollectionView            *cvProgress;
}
@end


@implementation LyStudentProgressView

static NSString *const lyStudentProgressViewCvProgressCellReuseIdentifier = @"lyStudentProgressViewCvProgressCellReuseIdentifier";
static NSArray *arrProgresses = nil;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        arrProgresses = [LyUtil arrSubjectMode];
        
        UICollectionViewFlowLayout *cvProgressFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        [cvProgressFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [cvProgressFlowLayout setMinimumLineSpacing:0];
        [cvProgressFlowLayout setMinimumInteritemSpacing:0];
        [cvProgressFlowLayout setItemSize:CGSizeMake(cvProgressItemWidth, CGRectGetHeight(self.bounds))];
        cvProgress = [[UICollectionView alloc] initWithFrame:self.bounds
                                        collectionViewLayout:cvProgressFlowLayout];
        [cvProgress setDelegate:self];
        [cvProgress setDataSource:self];
        [cvProgress setBackgroundColor:[UIColor whiteColor]];
        [cvProgress setScrollsToTop:NO];
        [cvProgress registerClass:[LyFragmentCollectionViewCell class] forCellWithReuseIdentifier:lyStudentProgressViewCvProgressCellReuseIdentifier];
        [self addSubview:cvProgress];
        
        [cvProgress selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                 animated:NO
                           scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    return self;
}


#pragma mark -UICollectionViewdelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate studentProgressView:self didSelectedItemAtIndex:indexPath.row+1];
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return cvProgressItemNumber;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LyFragmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lyStudentProgressViewCvProgressCellReuseIdentifier forIndexPath:indexPath];
    
    if (cell)
    {
        [cell setTitle:[arrProgresses objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

#pragma mark -UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
