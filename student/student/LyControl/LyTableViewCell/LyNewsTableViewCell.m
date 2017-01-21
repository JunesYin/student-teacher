//
//  LyNewsTableViewCell.m
//  teacher
//
//  Created by Junes on 2016/10/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyNewsTableViewCell.h"
#import "LyNewsButton.h"
#import "LyNews.h"

#import "SDPhotoBrowser.h"

#import "LyCurrentUser.h"
#import "LyUserManager.h"
#import "LyUtil.h"


#import "UIImageView+WebCache.h"



@protocol LyNewsPicItemCollectionViewCellDelegate;


@interface LyNewsPicItemCollectionViewCell : UICollectionViewCell
{
    UIImageView         *ivPic;
}

@property ( weak, nonatomic)    id<LyNewsPicItemCollectionViewCellDelegate>       delegate;
@property ( retain, nonatomic)          NSString                *strUrl;
@property ( strong, nonatomic)          UIImage                 *pic;

@end

@protocol LyNewsPicItemCollectionViewCellDelegate <NSObject>

@optional
- (void)picFinishGot:(UIImage *)aImage andUrl:(NSString *)strUrl andCell:(LyNewsPicItemCollectionViewCell*)aCell;

@end

@implementation LyNewsPicItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if ( self = [super initWithFrame:frame]) {
        ivPic = [[UIImageView alloc] initWithFrame:self.bounds];
        [ivPic setClipsToBounds:YES];
        [ivPic setContentMode:UIViewContentModeScaleAspectFill];
        
        [self addSubview:ivPic];
    }
    
    return self;
}


- (void)setStrUrl:(NSString *)strUrl
{
    if (![LyUtil validateString:strUrl] || ![NSURL URLWithString:strUrl]) {
        [ivPic setImage:[LyUtil imageForImageName:@"status_pic_default" needCache:NO]];
        return;
    }
    
    [ivPic sd_setImageWithURL:[NSURL URLWithString:strUrl]
             placeholderImage:[LyUtil imageForImageName:@"status_pic_default" needCache:NO]
                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        [_delegate picFinishGot:image
                                         andUrl:strUrl
                                        andCell:self];
                    }];
}

- (void)setPic:(UIImage *)pic {
    if ( !pic) {
        return;
    }
    
    _pic = pic;
    [ivPic setImage:_pic];
}

@end




CGFloat const ntcVerticalSpace = 10.0f;


//头像
CGFloat const ntcAvatarSize = 45.0f;

//姓名
CGFloat const ntcNameHeight = 25.0f;


CGFloat const ntcBtnDeleteWidth = 75.0f;
CGFloat const ntcBtnDeleteHeight = 25.0f;


//时间
#define ntcTimeHeight                               (ntcAvatarSize-ntcNameHeight)


//内容
#define ntcContentWidth                             (SCREEN_WIDTH-horizontalSpace*2)


//图片
CGFloat const ntcPicHorizontalMargin = 2.0f;
CGFloat const ntcPicVerticalMargin = 2.0f;
#define viewPicWidth                                (SCREEN_WIDTH-horizontalSpace*2.0f)
#define viewPickHeiht

#define picMaxWidth                                 (viewPicWidth/2.0f)
#define picMaxHeight                                picMaxWidth

#define picMultiWidth                               ((viewPicWidth-ntcPicHorizontalMargin*3.0f)/2.0f)
#define picMultiHeight                              picMultiWidth


//#define stcBtnFuncWidth                             100
CGFloat const ntcBtnFuncHeight = 30.0f;

#define stcBtnFuncWidth_transmit                   ntcBtnFuncHeight


#define ntcNameFont                                 [UIFont systemFontOfSize:14]
#define ntcTimeFont                                 [UIFont systemFontOfSize:12]
#define ntcContentFont                              [UIFont systemFontOfSize:14]


typedef NS_ENUM( NSInteger, LyNewsTableViewCellButtonItemMode)
{
    newsTableViewCellButtonMode_delete = 50,
    newsTableViewCellButtonMode_praise,
    newsTableViewCellButtonMode_evaluate,
    newsTableViewCellButtonMode_transmit
};


@interface LyNewsTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SDPhotoBrowserDelegate, LyNewsPicItemCollectionViewCellDelegate>
{
    UIImageView                         *ivAvatar;
    UILabel                             *lbName;
    UIButton                            *btnDelete;
    UILabel                             *lbTime;
    UITextView                          *tvContent;
    
    UIView                              *viewPic;
    UIImageView                         *ivPic;
    UICollectionView                    *cvPics;
    
    LyNewsButton                        *btnPraise;
    LyNewsButton                        *btnEvalution;
    LyNewsButton                        *btnTransimit;
    
    UIView                              *horizontalLine;
}
@end


@implementation LyNewsTableViewCell

static NSString *lyNewsPicItemCollctionViewCellReuseIdentifier = @"lyNewsPicItemCollctionViewCellReuseIdentifier";

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initAndAddSubview];
    }
    
    return self;
}


- (void)initAndAddSubview {
    //头像
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake( horizontalSpace, ntcVerticalSpace, ntcAvatarSize, ntcAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [[ivAvatar layer] setCornerRadius:ntcAvatarSize/2.0f];
    [ivAvatar setClipsToBounds:YES];
    [ivAvatar setUserInteractionEnabled:YES];
    [self addSubview:ivAvatar];
    
    //姓名
    lbName = [UILabel new];
    [lbName setTextColor:LyBlackColor];
    [lbName setFont:ntcNameFont];
    [lbName setTextAlignment:NSTextAlignmentLeft];
    [lbName setUserInteractionEnabled:YES];
    [self addSubview:lbName];
    
    
    
    UITapGestureRecognizer *tapGesture_1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForTapGestureForUser:)];
    [tapGesture_1 setNumberOfTapsRequired:1];
    [tapGesture_1 setNumberOfTouchesRequired:1];
    
    [ivAvatar addGestureRecognizer:tapGesture_1];
    
    
    UITapGestureRecognizer *tapGesture_2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForTapGestureForUser:)];
    [tapGesture_2 setNumberOfTapsRequired:1];
    [tapGesture_2 setNumberOfTouchesRequired:1];
    
    [lbName addGestureRecognizer:tapGesture_2];
    
    
    
    btnDelete = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH-horizontalSpace-ntcBtnDeleteWidth, verticalSpace, ntcBtnDeleteWidth, ntcBtnDeleteHeight)];
    [btnDelete setImage:[LyUtil imageForImageName:@"stc_delete" needCache:NO] forState:UIControlStateNormal];
    [btnDelete setTag:newsTableViewCellButtonMode_delete];
    [btnDelete addTarget:self action:@selector(stcTrageForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnDelete];
    [btnDelete setHidden:YES];
    
    //时间
    lbTime = [UILabel new];
    [lbTime setTextColor:LyBlackColor];
    [lbTime setFont:ntcTimeFont];
    [lbTime setTextAlignment:NSTextAlignmentLeft];
    //    [lbTime setUserInteractionEnabled:YES];
    [self addSubview:lbTime];
    
    
    //内容
    tvContent = [UITextView new];
    [tvContent setTextColor:LyBlackColor];
    [tvContent setFont:ntcContentFont];
    [tvContent setTextAlignment:NSTextAlignmentLeft];
    [tvContent setEditable:NO];
    [tvContent setScrollEnabled:NO];
    [self addSubview:tvContent];
    
    UITapGestureRecognizer *tapTvContent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForTapGestureForDetail:)];
    [tapTvContent setNumberOfTapsRequired:1];
    [tapTvContent setNumberOfTouchesRequired:1];
    
    //    [tvContent setUserInteractionEnabled:YES];
    [tvContent addGestureRecognizer:tapTvContent];
    
    viewPic = [[UIView alloc] init];
    
    ivPic = [[UIImageView alloc] init];
    [ivPic setClipsToBounds:YES];
    [ivPic setContentMode:UIViewContentModeScaleAspectFill];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForTapGesture:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    
    [ivPic setUserInteractionEnabled:YES];
    [ivPic addGestureRecognizer:tapGesture];
    
    UICollectionViewFlowLayout *picCollectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [picCollectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [picCollectionViewFlowLayout setMinimumLineSpacing:ntcPicVerticalMargin];
    [picCollectionViewFlowLayout setMinimumInteritemSpacing:ntcPicHorizontalMargin];
    cvPics = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, viewPicWidth, viewPicWidth)
                                collectionViewLayout:picCollectionViewFlowLayout];
    [cvPics setDelegate:self];
    [cvPics setDataSource:self];
    [cvPics setScrollEnabled:NO];
    [cvPics setScrollsToTop:NO];
    [cvPics setShowsVerticalScrollIndicator:NO];
    [cvPics setShowsHorizontalScrollIndicator:NO];
    [cvPics setBackgroundColor:[UIColor whiteColor]];
    [cvPics registerClass:[LyNewsPicItemCollectionViewCell class] forCellWithReuseIdentifier:lyNewsPicItemCollctionViewCellReuseIdentifier];
    
    [viewPic addSubview:ivPic];
    [viewPic addSubview:cvPics];
    
    [ivPic setHidden:YES];
    [cvPics setHidden:YES];
    
    [self addSubview:viewPic];
    
    //赞
    btnPraise = [[LyNewsButton alloc] init];
    [btnPraise setTag:newsTableViewCellButtonMode_praise];
    [btnPraise setMode:LyNewsButtonMode_praise];
    [btnPraise setTitleColor:LyBlackColor forState:UIControlStateNormal];
    [btnPraise addTarget:self action:@selector(stcTrageForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnPraise];
    
    //评论
    btnEvalution = [[LyNewsButton alloc] init];
    [btnEvalution setTag:newsTableViewCellButtonMode_evaluate];
    [btnEvalution setMode:LyNewsButtonMode_evaluation];
    [btnEvalution setTitleColor:LyBlackColor forState:UIControlStateNormal];
    [btnEvalution addTarget:self action:@selector(stcTrageForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnEvalution];
    
    //转发
    btnTransimit = [[LyNewsButton alloc] init];
    [btnTransimit setTag:newsTableViewCellButtonMode_transmit];
    [btnTransimit setMode:LyNewsButtonMode_transmit];
    [btnTransimit setTitleColor:LyBlackColor forState:UIControlStateNormal];
    [btnTransimit addTarget:self action:@selector(stcTrageForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnTransimit];
    
    
    horizontalLine = [UIView new];
    [horizontalLine setBackgroundColor:LyWhiteLightgrayColor];
    [self addSubview:horizontalLine];
    
    
    [self setOpaque:YES];
    for (UIView *item in self.subviews) {
        [item setOpaque:YES];
    }
}



- (void)setNews:(LyNews *)news mode:(LyNewsTableViewCellMode)mode {
    _mode = mode;
    _news = news;
    
    
    if ( [[LyCurrentUser curUser] isLogined] && [news.newsMasterId isEqualToString:[LyCurrentUser curUser].userId]) {
        [btnDelete setHidden:NO];
    } else {
        [btnDelete setHidden:YES];
    }
    
    LyUser *master = [[LyUserManager sharedInstance] getUserWithUserId:news.newsMasterId];
    
    //头像
    NSString *strUserAvatar;
    if ( LyUserType_normal == master.userType) {
        strUserAvatar = @"ct_avatar";
    } else {
        strUserAvatar = @"ds_avatar";
    }
    
    
    if ( ![master userAvatar]) {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:master.userId]
                    placeholderImage:[LyUtil imageForImageName:strUserAvatar needCache:NO]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if (image) {
                                   [master setUserAvatar:image];
                               } else {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:master.userId]
                                               placeholderImage:[LyUtil imageForImageName:strUserAvatar needCache:NO]
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                          if (image) {
                                                              [master setUserAvatar:image];
                                                          }
                                                      }];
                               }
                           }];
        
    } else {
        [ivAvatar setImage:[master userAvatar]];
    }
    
    
    
    
    //姓名
    NSString *strMasterName;
    if (![LyUtil validateString:master.userName]) {
        strMasterName = @"匿名用户";
    } else {
        strMasterName = [master userName];
    }
    
    CGFloat fWidthLbName = [strMasterName sizeWithAttributes:@{NSFontAttributeName:ntcNameFont}].width;
    [lbName setFrame:CGRectMake( ivAvatar.frame.origin.x+ivAvatar.frame.size.width+horizontalSpace, ivAvatar.frame.origin.y, fWidthLbName, ntcNameHeight)];
    [lbName setText:[master userName]];
    
    
    //时间
    //    NSString *strTime = [LyUtil cutTimeString:[_status staTime]];
    NSString *strTime = [LyUtil translateTime:_news.newsTime];
    CGFloat fWidthLbTime = [strTime sizeWithAttributes:@{NSFontAttributeName:ntcTimeFont}].width;
    CGRect rectStcTime = CGRectMake( lbName.frame.origin.x, lbName.frame.origin.y+lbName.frame.size.height, fWidthLbTime, ntcTimeHeight);
    [lbTime setFrame:rectStcTime];
    [lbTime setText:strTime];
    
    
    
    
    //内容
    if (![LyUtil validateString:_news.newsContent] ){
        [tvContent setText:@""];
        [tvContent setFrame:CGRectMake( horizontalSpace, ivAvatar.frame.origin.y+CGRectGetHeight(ivAvatar.frame), ntcContentWidth, verticalSpace)];
    } else {
        [tvContent setText:_news.newsContent];
        
        CGFloat fHeightTvContent = [tvContent sizeThatFits:CGSizeMake(ntcContentWidth, MAXFLOAT)].height;
        if (LyNewsTableViewCellMode_community == _mode) {
            [tvContent.textContainer setMaximumNumberOfLines:6];
            [tvContent.textContainer setLineBreakMode:NSLineBreakByTruncatingTail];
            
            CGFloat fHeight = [tvContent sizeThatFits:CGSizeMake(ntcContentWidth, MAXFLOAT)].height;
            fHeightTvContent = (fHeightTvContent > fHeight) ? fHeight : fHeightTvContent;
        }
        
        [tvContent setFrame:CGRectMake( horizontalSpace, ivAvatar.frame.origin.y+CGRectGetHeight(ivAvatar.frame), ntcContentWidth, fHeightTvContent)];
    }
    
    
    //图片
    [self stcSetPic];
    
    
    //转发
    NSString *strTransmitCount = [LyUtil transmitNumWithWan:_news.newsTransmitCount];
    CGFloat fWidthBtnTransmit = 15 + 2 + [strTransmitCount sizeWithAttributes:@{NSFontAttributeName:LyNewsButtonNumFont}].width;
    fWidthBtnTransmit = ( fWidthBtnTransmit < 50) ? 50 : fWidthBtnTransmit;
    [btnTransimit setFrame:CGRectMake( SCREEN_WIDTH-horizontalSpace-fWidthBtnTransmit, viewPic.frame.origin.y+viewPic.frame.size.height+ntcVerticalSpace, fWidthBtnTransmit, ntcBtnFuncHeight)];
    [btnTransimit setNumber:_news.newsTransmitCount];
    
    //评论
    NSString *strEvaluationCount = [LyUtil transmitNumWithWan:_news.newsEvaluationCount];
    CGFloat fWidthBtnEvaluation = 15 + 2 + [strEvaluationCount sizeWithAttributes:@{NSFontAttributeName:LyNewsButtonNumFont}].width;
    fWidthBtnEvaluation = ( fWidthBtnEvaluation < 50) ? 50 : fWidthBtnEvaluation;
    [btnEvalution setFrame:CGRectMake( btnTransimit.frame.origin.x-horizontalSpace*2-fWidthBtnEvaluation, btnTransimit.frame.origin.y, fWidthBtnEvaluation, ntcBtnFuncHeight)];
    [btnEvalution setNumber:_news.newsEvaluationCount];
    //赞
    NSString *strPraiseCount = [LyUtil transmitNumWithWan:_news.newsPraiseCount];
    CGFloat fWidthBtnPraise = 15 + 2 + [strPraiseCount sizeWithAttributes:@{NSFontAttributeName:LyNewsButtonNumFont}].width;
    fWidthBtnPraise = ( fWidthBtnPraise < 50) ? 50 : fWidthBtnPraise;
    [btnPraise setFrame:CGRectMake( btnEvalution.frame.origin.x-horizontalSpace*2-fWidthBtnPraise, btnEvalution.frame.origin.y, fWidthBtnPraise, ntcBtnFuncHeight)];
    [btnPraise setNumber:_news.newsPraiseCount];
    
    [btnPraise praise:_news.isPraised];
    
    [_news setCellHeight:btnPraise.frame.origin.y + btnPraise.frame.size.height + ntcVerticalSpace];
    
    switch ( _mode) {
        case LyNewsTableViewCellMode_community: {
            
            _cellHeight = btnPraise.frame.origin.y + btnPraise.frame.size.height + ntcVerticalSpace;
            [btnPraise setHidden:NO];
            [btnEvalution setHidden:NO];
            [btnTransimit setHidden:NO];
            break;
        }
        case LyNewsTableViewCellMode_detail: {
            
            [self setSelectionStyle:UITableViewCellSelectionStyleNone];
            _cellHeight = viewPic.frame.origin.y + viewPic.frame.size.height + ntcVerticalSpace;
            [btnPraise setHidden:YES];
            [btnEvalution setHidden:YES];
            [btnTransimit setHidden:YES];
            break;
        }
            
        default: {
            _cellHeight = btnPraise.frame.origin.y + btnPraise.frame.size.height + ntcVerticalSpace;
            [btnPraise setHidden:NO];
            [btnEvalution setHidden:NO];
            [btnTransimit setHidden:NO];
            break;
        }
    }
    
    
    [horizontalLine setFrame:CGRectMake( 0, _cellHeight-verticalSpace, SCREEN_WIDTH, verticalSpace)];
}




- (void)stcSetPic {
    int iPicNum = (int)_news.newsPicUrls.count;
    
    if ( 0 == iPicNum) {
        [viewPic setFrame:CGRectMake( horizontalSpace, tvContent.frame.origin.y+CGRectGetHeight(tvContent.frame), viewPicWidth, 0)];
        [ivPic setHidden:YES];
        [cvPics setHidden:YES];
    } else if ( 1 == iPicNum) {
        NSArray *allKeys = [_news.newsPicUrls allKeys];
        UIImage *image = [_news.newsPics objectForKey:[allKeys objectAtIndex:0]];
        CGSize sizeImage;
        if ( !image) {
            sizeImage = CGSizeMake( picMultiWidth, picMultiHeight);
        } else {
            sizeImage = image.size;
        }
        
        if ( sizeImage.width > sizeImage.height) {
            CGFloat fIvHeight = picMaxHeight;
            CGFloat fIvWidthTmp = fIvHeight *sizeImage.width / sizeImage.height;
            CGFloat fIvWidth = ( fIvWidthTmp > viewPicWidth) ? viewPicWidth : fIvWidthTmp;
            [ivPic setFrame:CGRectMake( 0, 0, fIvWidth, fIvHeight)];
            
        } else {
            CGFloat fIvWidth = picMultiWidth;
            CGFloat fIvHeight = fIvWidth * sizeImage.height / sizeImage.width;
            [ivPic setFrame:CGRectMake( 0, 0, fIvWidth, fIvHeight)];
            
        }
        [viewPic setFrame:CGRectMake( horizontalSpace, tvContent.frame.origin.y+CGRectGetHeight(tvContent.frame)+verticalSpace, viewPicWidth, CGRectGetHeight(ivPic.frame))];
        [ivPic setHidden:NO];
        [cvPics setHidden:YES];
        
        if ( image) {
            [ivPic setImage:image];
        } else {
        
            [ivPic sd_setImageWithURL:[NSURL URLWithString:[[_news.newsPicUrls allValues] objectAtIndex:0]]
                     placeholderImage:[LyUtil imageForImageName:@"status_pic_default" needCache:NO]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                if (image) {
                                    [_news addPic:image
                                           picUrl:[[_news.newsPicUrls allValues] objectAtIndex:0]
                                            index:0];
                                    
                                    if (_delegate && [_delegate respondsToSelector:@selector(needRefresh:)]) {
                                        [_delegate needRefresh:self];
                                    } else {
                                        [self stcSetPic];
                                    }
                                }
                            }];
        }
    } else {
        CGFloat cvPicsHeight;
        if ( iPicNum < 3) {
            cvPicsHeight = picMultiHeight;
        } else {
            cvPicsHeight = picMultiHeight * 2.0f + ntcPicVerticalMargin * 2.0f;
        }
        
        [cvPics setFrame:CGRectMake( 0, 0, picMultiHeight * 2.0f + ntcPicVerticalMargin, cvPicsHeight)];
        
        [viewPic setFrame:CGRectMake( horizontalSpace, tvContent.frame.origin.y+CGRectGetHeight(tvContent.frame)+verticalSpace, viewPicWidth, cvPics.frame.origin.y+CGRectGetHeight(cvPics.frame))];
        
        [ivPic setHidden:YES];
        [cvPics setHidden:NO];
        [cvPics reloadData];
    }
}



- (void)stcTrageForButtonItem:(UIButton *)button
{
    if ( newsTableViewCellButtonMode_delete == [button tag]) {
        if ( [_delegate respondsToSelector:@selector(onClickedForDeleteByNewsTVC:)]) {
            [_delegate onClickedForDeleteByNewsTVC:self];
        }
        
    } else if ( newsTableViewCellButtonMode_praise == [button tag]) {
        if ( [_delegate respondsToSelector:@selector(onClickedForPraiseByNewsTVC:)]) {
            [_delegate onClickedForPraiseByNewsTVC:self];
        }
        
    } else if ( newsTableViewCellButtonMode_evaluate == [button tag]) {
        if ( [_delegate respondsToSelector:@selector(onClickedForEvaluateByNewsTVC:)]) {
            [_delegate onClickedForEvaluateByNewsTVC:self];
        }
        
    } else if ( newsTableViewCellButtonMode_transmit == [button tag]) {
        if ( [_delegate respondsToSelector:@selector(onCLickedForTransmitByNewsTVC:)]) {
            [_delegate onCLickedForTransmitByNewsTVC:self];
        }
    }
    
}



- (void)targetForTapGestureForUser:(UITapGestureRecognizer *)tapGesture {
    
    if ( [_delegate respondsToSelector:@selector(onClickedForUserByNewsTVC:)]) {
        [_delegate onClickedForUserByNewsTVC:self];
    }
}


- (void)targetForTapGestureForDetail:(UITapGestureRecognizer *)tag {
    
    if ( [_delegate respondsToSelector:@selector(onClickedForDetailByNewsTVC:)]) {
        [_delegate onClickedForDetailByNewsTVC:self];
    }
}


- (void)targetForTapGesture:(UITapGestureRecognizer *)tap
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = viewPic; // 原图的父控件
    browser.imageCount = _news.newsPicUrls.count;
    browser.currentImageIndex = 0;
    browser.delegate = self;
    [browser show];
}



#pragma mark -LyNewsPicItemCollectionViewCellDelegate
- (void)picFinishGot:(UIImage *)aImage andUrl:(NSString *)strUrl andCell:(LyNewsPicItemCollectionViewCell*)aCell {
    NSIndexPath *indexPath = [cvPics indexPathForCell:aCell];
    
    [_news addPic:aImage picUrl:strUrl index:(int)indexPath.row];
}




#pragma mark --UICollectionViewDelegate
//UICollectionViewCell被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = cvPics; // 原图的父控件
    browser.imageCount = _news.newsPicUrls.count;
    browser.currentImageIndex = indexPath.row;
    browser.delegate = self;
    [browser show];
}

//返回这个UICollectionViewCell是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _news.newsPicUrls.count;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LyNewsPicItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lyNewsPicItemCollctionViewCellReuseIdentifier forIndexPath:indexPath];
    
    if ( cell) {
        UIImage *image = [_news.newsPics objectForKey:@(indexPath.row)];
        if ( image) {
            [cell setPic:image];
        } else {
            [cell setStrUrl:[_news.newsPicUrls objectForKey:@(indexPath.row)]];
            [cell setDelegate:self];
        }
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake( picMultiWidth, picMultiHeight);
}


//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake( 0, 0, 0, 0);
}

#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return [_news.newsPics objectForKey:@(index)];
}


- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    return [NSURL URLWithString:[LyUtil bigPicUrl:[_news.newsPicUrls objectForKey:@(index)]]];
}



@end






