//
//  LySubjectModeView.m
//  teacher
//
//  Created by Junes on 16/8/13.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LySubjectModeView.h"



CGFloat const LySubjectModeViewHeight = 40.0f;

int const LySubjectModeViewCvSubjectsRowNumber = 5;

CGFloat const LySubjectModeViewCvSubjectsCellWidth = 80.0f;



@interface LySubjectModeCvSubjectsCell : UICollectionViewCell
{
    UILabel                 *lbTitle;
    
    UIImageView             *ivFlag;
}

@property (retain, nonatomic)           NSString            *title;

@end

@implementation LySubjectModeCvSubjectsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        lbTitle = [[UILabel alloc] initWithFrame:self.bounds];
        [lbTitle setFont:LyFont(14)];
        [lbTitle setTextColor:LyBlackColor];
        [lbTitle setTextAlignment:NSTextAlignmentCenter];
        
        
        
        [self addSubview:lbTitle];
        [self addSubview:ivFlag];
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [ivFlag setHighlighted:selected];
}

@end


@interface LySubjectModeView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UICollectionView                *cvSubjects;
}
@end

@implementation LySubjectModeView

static NSString *lySubjectsCvSubjectsCellReuseIdentifier = @"lySubjectsCvSubjectsCellReuseIdentifier";

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, FULLSCREENWIDTH, LySubjectModeViewHeight)])
    {
        
        UICollectionViewFlowLayout *cvSubjcetsFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        [cvSubjcetsFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [cvSubjcetsFlowLayout setMinimumLineSpacing:0];
        [cvSubjcetsFlowLayout setMinimumInteritemSpacing:0];
        
        cvSubjects = [[UICollectionView alloc] initWithFrame:self.bounds
                                        collectionViewLayout:cvSubjcetsFlowLayout];
        [cvSubjects setDelegate:self];
        [cvSubjects setDataSource:self];
        [cvSubjects setBackgroundColor:[UIColor whiteColor]];
        [cvSubjects registerClass:[LySubjectModeCvSubjectsCell class] forCellWithReuseIdentifier:lySubjectsCvSubjectsCellReuseIdentifier];

        [self addSubview:cvSubjects];
    }
    
    return self;
}


- (void)setSubjectMode:(LySubjectMode)subjectMode
{
    [cvSubjects selectItemAtIndexPath:[NSIndexPath indexPathForRow:subjectMode inSection:0]
                             animated:NO
                       scrollPosition:UICollectionViewScrollPositionRight];
}




#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate subjectModeView:self didSelectSubject:indexPath.row];
}



#pragma mrak -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return LySubjectModeViewCvSubjectsRowNumber;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LySubjectModeCvSubjectsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lySubjectsCvSubjectsCellReuseIdentifier forIndexPath:indexPath];
    
    if (cell)
    {
        [cell setTitle:[[LyUtil arrSubjctMode] objectAtIndex:indexPath.row]];
    }
    
    return cell;
}


#pragma mark -UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(LySubjectModeViewCvSubjectsCellWidth, LySubjectModeViewHeight);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


@end
