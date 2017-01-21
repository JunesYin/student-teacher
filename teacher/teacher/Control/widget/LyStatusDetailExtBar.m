//
//  LyStatusDetailExtToolBar.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/3.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyStatusDetailExtBar.h"

#import "LyUtil.h"



CGFloat const sdebHeight = 40.0f;

#define sdetbcellWidth                          CGRectGetWidth(self.frame)
#define sdetbcellHeight                         CGRectGetHeight(self.frame)

#define lbTitleWidth                            sdetbcellWidth
#define lbTitleHeight                           sdetbcellHeight
#define lbTitleFont                             LyFont(14)

#define viewHorizontalLineWidth                 sdetbcellWidth
CGFloat const viewHorizontalLineHeight = 3.0f;


typedef NS_ENUM( NSInteger, LyStatusDetailExtBarCollectionViewCellMode)
{
    LyStatusDetailExtBarCollectionViewCellMode_transmit,
    LyStatusDetailExtBarCollectionViewCellMode_evalute,
    LyStatusDetailExtBarCollectionViewCellMode_praise
};

@interface LyStatusDetailExtBarCollectionViewCell : UICollectionViewCell
{
    UILabel             *lbTitle;
    
    UIView              *viewHorizontalLine;
    
    NSString            *preTitle;
}

@property ( assign, nonatomic)      LyStatusDetailExtBarCollectionViewCellMode      mode;

@property ( assign, nonatomic)      NSInteger           num;

@end


@implementation LyStatusDetailExtBarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        lbTitle = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, lbTitleWidth, lbTitleHeight)];
        [lbTitle setFont:lbTitleFont];
        [lbTitle setTextColor:LyBlackColor];
        [lbTitle setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lbTitle];
        
        
        viewHorizontalLine = [[UIView alloc] initWithFrame:CGRectMake( 0, sdetbcellHeight-viewHorizontalLineHeight, viewHorizontalLineWidth, viewHorizontalLineHeight)];
        [viewHorizontalLine setBackgroundColor:Ly517ThemeColor];
        [self addSubview:viewHorizontalLine];
        
        [viewHorizontalLine setHidden:YES];
    }
    
    return self;
}


- (void)setMode:(LyStatusDetailExtBarCollectionViewCellMode)mode
{
    _mode = mode;
    
    switch ( _mode) {
        case LyStatusDetailExtBarCollectionViewCellMode_praise: {
            preTitle = @"赞";
            break;
        }
        case LyStatusDetailExtBarCollectionViewCellMode_evalute: {
            preTitle = @"评论";
            break;
        }
        case LyStatusDetailExtBarCollectionViewCellMode_transmit: {
            preTitle = @"转发";
            break;
        }
    }
    
    
    [lbTitle setText:[[NSString alloc] initWithFormat:@"%@ %@", preTitle, [LyUtil transmitNumWithWan:_num]]];
}


- (void)setNum:(NSInteger)num
{
    _num = num;
    
    [lbTitle setText:[[NSString alloc] initWithFormat:@"%@ %@", preTitle, [LyUtil transmitNumWithWan:_num]]];
}


- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if ( selected)
    {
        [viewHorizontalLine setHidden:NO];
        [lbTitle setTextColor:Ly517ThemeColor];
    }
    else
    {
        [viewHorizontalLine setHidden:YES];
        [lbTitle setTextColor:LyBlackColor];
    }
}


@end








#define cvItemWidth                 70.0f
#define cvItemHeight                sdebHeight


#define cvItemMargin                5.0f

#define sectionMargin               (sdebWidth-cvItemWidth*3-cvItemMargin*3)




@interface LyStatusDetailExtBar () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UICollectionView            *cvBtns;
}
@end


@implementation LyStatusDetailExtBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
static NSString *lyStatusDetailExtBarCollectionViewCellReuseIdentifier = @"lyStatusDetailExtBarCollectionViewCellReuseIdentifier";


- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        [self initAndLayoutSubviews];
    }
    
    return self;
}



- (void)initAndLayoutSubviews
{
    [self setOpaque:YES];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    UICollectionViewFlowLayout *btnsCollectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [btnsCollectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    cvBtns = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:btnsCollectionViewFlowLayout];
    [cvBtns setBackgroundColor:[UIColor whiteColor]];
    [cvBtns setDelegate:self];
    [cvBtns setDataSource:self];
    [cvBtns setScrollEnabled:NO];
    [cvBtns setScrollsToTop:NO];
    [cvBtns registerClass:[LyStatusDetailExtBarCollectionViewCell class] forCellWithReuseIdentifier:lyStatusDetailExtBarCollectionViewCellReuseIdentifier];
    
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake( 0, CGRectGetHeight(self.frame)-LyHorizontalLineHeight, CGRectGetWidth(self.frame), LyHorizontalLineHeight)];
    [horizontalLine setBackgroundColor:LyHorizontalLineColor];
    
    [self addSubview:cvBtns];
    [self addSubview:horizontalLine];
    
    [cvBtns selectItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}


- (void)setTransmitCount:(NSInteger)transmitCount
{
    _transmitCount = transmitCount;
    
    LyStatusDetailExtBarCollectionViewCell *cell = (LyStatusDetailExtBarCollectionViewCell *)[cvBtns cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell setNum:_transmitCount];
}

- (void)setEvalutionCount:(NSInteger)evalutionCount
{
    _evalutionCount = evalutionCount;
    
    LyStatusDetailExtBarCollectionViewCell *cell = (LyStatusDetailExtBarCollectionViewCell *)[cvBtns cellForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell setNum:_evalutionCount];
}

- (void)setPraiseCount:(NSInteger)praiseCount
{
    _praiseCount = praiseCount;
    
    LyStatusDetailExtBarCollectionViewCell *cell = (LyStatusDetailExtBarCollectionViewCell *)[cvBtns cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell setNum:_praiseCount];
}



- (void)setSelectedItem:(NSIndexPath *)indexPath
{
    [cvBtns selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}


#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ( 0 == [indexPath section])
    {
        if ( 0 == [indexPath row])
        {
            if ( [_delegate respondsToSelector:@selector(onClickedTransmitByStatusDetailExtBar:)])
            {
                [_delegate onClickedTransmitByStatusDetailExtBar:self];
            }
        }
        else
        {
            if ( [_delegate respondsToSelector:@selector(onClickedEvalutionByStatusDetailExtBar:)])
            {
                [_delegate onClickedEvalutionByStatusDetailExtBar:self];
            }
        }
    }
    else
    {
        if ( [_delegate respondsToSelector:@selector(onClickedPraiseByStatusDetailExtBar:)])
        {
            [_delegate onClickedPraiseByStatusDetailExtBar:self];
        }
    }
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ( 0 == section)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LyStatusDetailExtBarCollectionViewCell *tmpCell = [collectionView dequeueReusableCellWithReuseIdentifier:lyStatusDetailExtBarCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    if ( tmpCell)
    {
        if ( 0 == [indexPath section])
        {
            [tmpCell setMode:LyStatusDetailExtBarCollectionViewCellMode_transmit+[indexPath row]];
        }
        else
        {
            [tmpCell setMode:LyStatusDetailExtBarCollectionViewCellMode_praise+[indexPath row]];
        }
    }
    
    
    return tmpCell;
}


#pragma mark -UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( 0 == [indexPath section])
    {
        return CGSizeMake( cvItemWidth, cvItemHeight);
    }
    else
    {
        return CGSizeMake( cvItemWidth, cvItemHeight);
    }
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if ( 0 == section)
    {
        return 0;
    }
    else
    {
        return 0;
    }
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if ( 0 == section)
    {
        return 0;
    }
    else
    {
        return 0;
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if ( 0 == section)
    {
        return UIEdgeInsetsMake( 0, cvItemMargin, 0, 0);
    }
    else
    {
        return UIEdgeInsetsMake( 0, sectionMargin, 0, cvItemMargin);
    }
}


@end
