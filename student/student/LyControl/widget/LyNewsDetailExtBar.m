//
//  LyNewsDetailExtBar.m
//  teacher
//
//  Created by Junes on 2016/10/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyNewsDetailExtBar.h"

#import "LyUtil.h"

CGFloat const ndebHeight = 42.0f;




#define ndetbcellWidth                          CGRectGetWidth(self.frame)
#define ndetbcellHeight                         CGRectGetHeight(self.frame)

#define lbTitleWidth                            ndetbcellWidth
#define lbTitleHeight                           ndetbcellHeight
#define lbTitleFont                             LyFont(14)

#define viewHorizontalLineWidth                 ndetbcellWidth
CGFloat const viewHorizontalLineHeight = 2.0f;


typedef NS_ENUM( NSInteger, LyNewsDetailExtBarCvCellMode)
{
    LyNewsDetailExtBarCvCellMode_transmit,
    LyNewsDetailExtBarCvCellMode_evalute,
    LyNewsDetailExtBarCvCellMode_praise
};

@interface LyNewsDetailExtBarCollectionViewCell : UICollectionViewCell
{
    UILabel             *lbTitle;
    
    UIView              *viewHorizontalLine;
    
    NSString            *preTitle;
}

@property ( assign, nonatomic)      LyNewsDetailExtBarCvCellMode      mode;

@property ( assign, nonatomic)      NSInteger           num;

@end


@implementation LyNewsDetailExtBarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        lbTitle = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, lbTitleWidth, lbTitleHeight)];
        [lbTitle setFont:lbTitleFont];
        [lbTitle setTextColor:LyBlackColor];
        [lbTitle setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lbTitle];
        
        
        viewHorizontalLine = [[UIView alloc] initWithFrame:CGRectMake( 0, ndetbcellHeight-viewHorizontalLineHeight, viewHorizontalLineWidth, viewHorizontalLineHeight)];
        [viewHorizontalLine setBackgroundColor:Ly517ThemeColor];
        [self addSubview:viewHorizontalLine];
        
        [viewHorizontalLine setHidden:YES];
    }
    
    return self;
}


- (void)setMode:(LyNewsDetailExtBarCvCellMode)mode
{
    _mode = mode;
    
    switch ( _mode) {
        case LyNewsDetailExtBarCvCellMode_praise: {
            preTitle = @"赞";
            break;
        }
        case LyNewsDetailExtBarCvCellMode_evalute: {
            preTitle = @"评论";
            break;
        }
        case LyNewsDetailExtBarCvCellMode_transmit: {
            preTitle = @"转发";
            break;
        }
    }
    
    
    [lbTitle setText:[[NSString alloc] initWithFormat:@"%@ %@", preTitle, [LyUtil transmitNumWithWan:_num]]];
}


- (void)setNum:(NSInteger)num {
    _num = num;
    
    [lbTitle setText:[[NSString alloc] initWithFormat:@"%@ %@", preTitle, [LyUtil transmitNumWithWan:_num]]];
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        [viewHorizontalLine setHidden:NO];
        [lbTitle setTextColor:Ly517ThemeColor];
    } else {
        [viewHorizontalLine setHidden:YES];
        [lbTitle setTextColor:LyBlackColor];
    }
}


@end





#define cvItemWidth                 70.0f
#define cvItemHeight                ndebHeight


#define cvItemMargin                5.0f

#define sectionMargin               (SCREEN_WIDTH-cvItemWidth*3-cvItemMargin*3)


@interface LyNewsDetailExtBar () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UICollectionView            *cvBtns;
}
@end


@implementation LyNewsDetailExtBar


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

static NSString *LyNewsDetailExtBarCollectionViewCellReuseIdentifier = @"LyNewsDetailExtBarCollectionViewCellReuseIdentifier";


- (instancetype)initWithFrame:(CGRect)frame {
    if ( self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    
    return self;
}



- (void)initSubviews {
    [self setOpaque:YES];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    UICollectionViewFlowLayout *btnsCollectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [btnsCollectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    cvBtns = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ndebHeight-viewHorizontalLineHeight)
                                collectionViewLayout:btnsCollectionViewFlowLayout];
    [cvBtns setBackgroundColor:[UIColor whiteColor]];
    [cvBtns setDelegate:self];
    [cvBtns setDataSource:self];
    [cvBtns setScrollEnabled:NO];
    [cvBtns setScrollsToTop:NO];
    [cvBtns registerClass:[LyNewsDetailExtBarCollectionViewCell class] forCellWithReuseIdentifier:LyNewsDetailExtBarCollectionViewCellReuseIdentifier];
    
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake( 0, CGRectGetHeight(self.bounds)-viewHorizontalLineHeight, SCREEN_WIDTH, viewHorizontalLineHeight)];
    [horizontalLine setBackgroundColor:LyWhiteLightgrayColor];
    
    [self addSubview:cvBtns];
    [self addSubview:horizontalLine];
    
    [cvBtns selectItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}


- (void)setTransmitCount:(NSInteger)transmitCount {
    _transmitCount = transmitCount;
    
    LyNewsDetailExtBarCollectionViewCell *cell = (LyNewsDetailExtBarCollectionViewCell *)[cvBtns cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell setNum:_transmitCount];
}

- (void)setEvalutionCount:(NSInteger)evalutionCount {
    _evalutionCount = evalutionCount;
    
    LyNewsDetailExtBarCollectionViewCell *cell = (LyNewsDetailExtBarCollectionViewCell *)[cvBtns cellForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell setNum:_evalutionCount];
}

- (void)setPraiseCount:(NSInteger)praiseCount {
    _praiseCount = praiseCount;
    
    LyNewsDetailExtBarCollectionViewCell *cell = (LyNewsDetailExtBarCollectionViewCell *)[cvBtns cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell setNum:_praiseCount];
}



- (void)setSelectedItem:(NSIndexPath *)indexPath {
    [cvBtns selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}


#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( 0 == indexPath.section) {
        if ( 0 == indexPath.row) {
            if ( [_delegate respondsToSelector:@selector(onClickedTransmitByNewsDetailExtBar:)]) {
                [_delegate onClickedTransmitByNewsDetailExtBar:self];
            }
        } else {
            if ( [_delegate respondsToSelector:@selector(onClickedEvalutionByNewsDetailExtBar:)]) {
                [_delegate onClickedEvalutionByNewsDetailExtBar:self];
            }
        }
    } else {
        if ( [_delegate respondsToSelector:@selector(onClickedPraiseByNewsDetailExtBar:)]) {
            [_delegate onClickedPraiseByNewsDetailExtBar:self];
        }
    }
    
    
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ( 0 == section) {
        return 2;
    } else {
        return 1;
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LyNewsDetailExtBarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LyNewsDetailExtBarCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    if ( cell) {
        if ( 0 == [indexPath section]) {
            [cell setMode:LyNewsDetailExtBarCvCellMode_transmit + indexPath.row];
        } else {
            [cell setMode:LyNewsDetailExtBarCvCellMode_praise + indexPath.row];
        }
    }
    
    return cell;
}


#pragma mark -UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ( 0 == [indexPath section]) {
        return CGSizeMake( cvItemWidth, cvItemHeight);
    } else {
        return CGSizeMake( cvItemWidth, cvItemHeight);
    }
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if ( 0 == section) {
        return 0;
    } else {
        return 0;
    }
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if ( 0 == section) {
        return 0;
    } else {
        return 0;
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if ( 0 == section) {
        return UIEdgeInsetsMake( 0, cvItemMargin, 0, 0);
    } else {
        return UIEdgeInsetsMake( 0, sectionMargin, 0, cvItemMargin);
    }
}




@end



