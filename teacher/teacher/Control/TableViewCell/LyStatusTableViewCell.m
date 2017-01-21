//
//  LyStatusTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/16.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyStatusTableViewCell.h"
#import "LyStatusButton.h"
#import "LyStatus.h"

#import "SDPhotoBrowser.h"

#import "LyUser.h"
#import "LyCurrentUser.h"
#import "LyUserManager.h"
#import "LyUtil.h"


#import "UIImageView+WebCache.h"



@protocol LyStatusPicItemCollectionViewCellDelegate;


@interface LyStatusPicItemCollectionViewCell : UICollectionViewCell
{
    UIImageView         *ivPic;
}

@property ( weak, nonatomic)    id<LyStatusPicItemCollectionViewCellDelegate>       delegate;
@property ( retain, nonatomic)          NSString                *strUrl;
@property ( strong, nonatomic)          UIImage                 *pic;

@end

@protocol LyStatusPicItemCollectionViewCellDelegate <NSObject>

@optional
- (void)picFinishGot:(UIImage *)aImage andUrl:(NSString *)strUrl andCell:(LyStatusPicItemCollectionViewCell*)aCell;

@end

@implementation LyStatusPicItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        ivPic = [[UIImageView alloc] initWithFrame:self.bounds];
        [ivPic setClipsToBounds:YES];
        [ivPic setContentMode:UIViewContentModeScaleAspectFill];
        
        [self addSubview:ivPic];
    }
    
    return self;
}


- (void)setStrUrl:(NSString *)strUrl
{
    if ( !strUrl || [strUrl isKindOfClass:[NSNull class]] || ![NSURL URLWithString:strUrl])
    {
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

- (void)setPic:(UIImage *)pic
{
    if ( !pic)
    {
        return;
    }
    
    _pic = pic;
    [ivPic setImage:_pic];
}

@end




CGFloat const stcVerticalSpace = 10.0f;


#define stcTableViewCellWidth                       FULLSCREENWIDTH


//头像
CGFloat const stcAvatarWidth = 45.0f;
CGFloat const stcAvatarHeight = stcAvatarWidth;

//姓名
#define stcNameWidth
CGFloat const stcNameHeight = 25.0f;


CGFloat const stcBtnDeleteWidth = 75.0f;
CGFloat const stcBtnDeleteHeight = 25.0f;


//时间
#define stcTimeWidth
#define stcTimeHeight                               (stcAvatarHeight-stcNameHeight)


//内容
#define stcContentWidth                             (stcTableViewCellWidth-horizontalSpace*2)
#define stcContentHeight


//图片
CGFloat const stcPicHorizontalMargin = 2.0f;
CGFloat const stcPicVerticalMargin = 2.0f;
#define viewPicWidth                                (stcTableViewCellWidth-horizontalSpace*2.0f)
#define viewPickHeiht

#define picMaxWidth                                 (viewPicWidth/2.0f)
#define picMaxHeight                                picMaxWidth

#define picMultiWidth                               ((viewPicWidth-stcPicHorizontalMargin*3.0f)/2.0f)
#define picMultiHeight                              picMultiWidth


//#define stcBtnFuncWidth                             100
CGFloat const stcBtnFuncHeight = 25.0f;

#define stcBtnFuncWidth_transmit                   stcBtnFuncHeight


#define stcNameFont                                 [UIFont systemFontOfSize:14]
#define stcTimeFont                                 [UIFont systemFontOfSize:12]
#define stcContentFont                              [UIFont systemFontOfSize:14]


typedef NS_ENUM( NSInteger, LyStatusTableViewCellButtonItemMode)
{
    statusTableViewCellButtonItemMode_delete = 52,
    statusTableViewCellButtonItemMode_praise,
    statusTableViewCellButtonItemMode_evalute,
    statusTableViewCellButtonItemMode_transmit
};


@interface LyStatusTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SDPhotoBrowserDelegate, LyStatusPicItemCollectionViewCellDelegate>
{
    UIImageView                         *ivAvatar;
    UILabel                             *lbName;
    UIButton                            *btnDelete;
    UILabel                             *lbTime;
    UITextView                          *tvContent;
    
    UIView                              *viewPic;
    UIImageView                         *ivPic;
    UICollectionView                    *cvPics;
    
    LyStatusButton                      *btnPraise;
    LyStatusButton                      *btnEvalution;
    LyStatusButton                      *btnTransimit;
 
    UIView                              *horizontalLine;
}
@end


@implementation LyStatusTableViewCell



- (void)awakeFromNib {
    // Initialization code
}

static NSString *lyStatusPicItemCollctionViewCellReuseIdentifier = @"lyStatusPicItemCollctionViewCellReuseIdentifier";

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initAndAddSubview];
    }
    
    return self;
}


- (void)initAndAddSubview
{
    //头像
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake( horizontalSpace, stcVerticalSpace, stcAvatarWidth, stcAvatarHeight)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [[ivAvatar layer] setCornerRadius:stcAvatarWidth/2.0f];
    [ivAvatar setClipsToBounds:YES];
    [ivAvatar setUserInteractionEnabled:YES];
    [self addSubview:ivAvatar];
    
    //姓名
    lbName = [UILabel new];
    [lbName setTextColor:LyBlackColor];
    [lbName setFont:stcNameFont];
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
    
    
    
    btnDelete = [[UIButton alloc] initWithFrame:CGRectMake( FULLSCREENWIDTH-horizontalSpace-stcBtnDeleteWidth, verticalSpace, stcBtnDeleteWidth, stcBtnDeleteHeight)];
    [btnDelete setImage:[LyUtil imageForImageName:@"stc_delete" needCache:NO] forState:UIControlStateNormal];
    [btnDelete setTag:statusTableViewCellButtonItemMode_delete];
    [btnDelete addTarget:self action:@selector(stcTrageForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnDelete];
    [btnDelete setHidden:YES];
    
    //时间
    lbTime = [UILabel new];
    [lbTime setTextColor:LyBlackColor];
    [lbTime setFont:stcTimeFont];
    [lbTime setTextAlignment:NSTextAlignmentLeft];
//    [lbTime setUserInteractionEnabled:YES];
    [self addSubview:lbTime];
    
    
    //内容
    tvContent = [UITextView new];
    [tvContent setTextColor:LyBlackColor];
    [tvContent setFont:stcContentFont];
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
    [picCollectionViewFlowLayout setMinimumLineSpacing:stcPicVerticalMargin];
    [picCollectionViewFlowLayout setMinimumInteritemSpacing:stcPicHorizontalMargin];
    cvPics = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, viewPicWidth, viewPicWidth)
                                collectionViewLayout:picCollectionViewFlowLayout];
    [cvPics setDelegate:self];
    [cvPics setDataSource:self];
    [cvPics setScrollEnabled:NO];
    [cvPics setScrollsToTop:NO];
    [cvPics setShowsVerticalScrollIndicator:NO];
    [cvPics setShowsHorizontalScrollIndicator:NO];
    [cvPics setBackgroundColor:[UIColor whiteColor]];
    [cvPics registerClass:[LyStatusPicItemCollectionViewCell class] forCellWithReuseIdentifier:lyStatusPicItemCollctionViewCellReuseIdentifier];
    
    [viewPic addSubview:ivPic];
    [viewPic addSubview:cvPics];
    
    [ivPic setHidden:YES];
    [cvPics setHidden:YES];
    
    [self addSubview:viewPic];
    
    //赞
    btnPraise = [[LyStatusButton alloc] init];
    [btnPraise setTag:statusTableViewCellButtonItemMode_praise];
    [btnPraise setMode:statusButtonType_praise];
    [btnPraise setTitleColor:LyBlackColor forState:UIControlStateNormal];
    [btnPraise addTarget:self action:@selector(stcTrageForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnPraise];
    
    //评论
    btnEvalution = [[LyStatusButton alloc] init];
    [btnEvalution setTag:statusTableViewCellButtonItemMode_evalute];
    [btnEvalution setMode:statusButtonType_evalution];
    [btnEvalution setTitleColor:LyBlackColor forState:UIControlStateNormal];
    [btnEvalution addTarget:self action:@selector(stcTrageForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnEvalution];
    
    //转发
    btnTransimit = [[LyStatusButton alloc] init];
    [btnTransimit setTag:statusTableViewCellButtonItemMode_transmit];
    [btnTransimit setMode:statusButtonType_transmit];
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



//
//- (void)heightForStatus:(LyStatus *)status
//{
//    CGFloat height = 0;
//    height += stcVerticalSpace + stcAvatarHeight;
//    
//}



- (void)setStatus:(LyStatus *)status andMode:(LyStatusTableViewCellMode)mode
{
    _mode = mode;
    _status = status;

    
    if ( [[LyCurrentUser currentUser] isLogined] && [[_status staMasterId] isEqualToString:[[LyCurrentUser currentUser] userId]])
    {
        [btnDelete setHidden:NO];
    }
    else
    {
        [btnDelete setHidden:YES];
    }
    
    LyUser *master = [[LyUserManager sharedInstance] getUserWithUserId:[_status staMasterId]];
    
    //头像
    NSString *strUserAvatar;
    if ( LyUserType_normal == [master userType]) {
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
                                                          if (!image) {
                                                              image = [LyUtil imageForImageName:strUserAvatar needCache:NO];
                                                          }

                                                          [master setUserAvatar:image];
                                                      }];
                               }
                           }];

    } else {
        [ivAvatar setImage:[master userAvatar]];
    }

    
    
    
    //姓名
    NSString *strMasterName;
    if ( ![master userName] || [[master userName] isKindOfClass:[NSNull class]] || [[master userName] rangeOfString:@"null"].length > 0 || [[master userName] length] < 1)
    {
        strMasterName = @"匿名用户";
    }
    else
    {
        strMasterName = [master userName];
    }
    
    CGFloat fWidthLbName = [strMasterName sizeWithAttributes:@{NSFontAttributeName:stcNameFont}].width;
    [lbName setFrame:CGRectMake( ivAvatar.frame.origin.x+ivAvatar.frame.size.width+horizontalSpace, ivAvatar.frame.origin.y, fWidthLbName, stcNameHeight)];
    [lbName setText:[master userName]];

    
    //时间
//    NSString *strTime = [LyUtil cutTimeString:[_status staTime]];
    NSString *strTime = [LyUtil translateTime:[_status staTime]];
    CGFloat fWidthLbTime = [strTime sizeWithAttributes:@{NSFontAttributeName:stcTimeFont}].width;
    CGRect rectStcTime = CGRectMake( lbName.frame.origin.x, lbName.frame.origin.y+lbName.frame.size.height, fWidthLbTime, stcTimeHeight);
    [lbTime setFrame:rectStcTime];
    [lbTime setText:strTime];
    

    
    
    //内容
    if ( ![_status staContent] || [[_status staContent] isKindOfClass:[NSNull class]] || [[_status staContent] isEqualToString:@""])
    {
        [tvContent setText:@""];
        [tvContent setFrame:CGRectMake( horizontalSpace, ivAvatar.frame.origin.y+CGRectGetHeight(ivAvatar.frame), stcContentWidth, verticalSpace)];
    }
    else
    {
        [tvContent setText:[_status staContent]];
        
        CGFloat fHeightTvContent = [tvContent sizeThatFits:CGSizeMake(stcContentWidth, MAXFLOAT)].height;
        if (LyStatusTableViewCellMode_community == _mode)
        {
            [tvContent.textContainer setMaximumNumberOfLines:6];
            [tvContent.textContainer setLineBreakMode:NSLineBreakByTruncatingTail];
            
            CGFloat fHeight = [tvContent sizeThatFits:CGSizeMake(stcContentWidth, MAXFLOAT)].height;
            fHeightTvContent = (fHeightTvContent > fHeight) ? fHeight : fHeightTvContent;
        }
        
        [tvContent setFrame:CGRectMake( horizontalSpace, ivAvatar.frame.origin.y+CGRectGetHeight(ivAvatar.frame), stcContentWidth, fHeightTvContent)];
    }
    
    
    //图片
    [self stcSetPic];

    
    //转发
    NSString *strTransmitCount;
    if ( [_status staTransmitCount] > 9999)
    {
        strTransmitCount = [[NSString alloc] initWithFormat:@"%.1f万", [_status staTransmitCount] / 10000.0f];
    }
    else
    {
        strTransmitCount = [[NSString alloc] initWithFormat:@"%d", [_status staTransmitCount]];
    }
    CGFloat fWidthBtnTransmit = 15 + 2 + [strTransmitCount sizeWithAttributes:@{NSFontAttributeName:LyStatusButtonNumFont}].width;
    fWidthBtnTransmit = ( fWidthBtnTransmit < 45) ? 45 : fWidthBtnTransmit;
    [btnTransimit setFrame:CGRectMake( FULLSCREENWIDTH-horizontalSpace-fWidthBtnTransmit, viewPic.frame.origin.y+viewPic.frame.size.height+stcVerticalSpace, fWidthBtnTransmit, stcBtnFuncHeight)];
    [btnTransimit setNumber:[_status staTransmitCount]];
    
    //评论
    NSString *strEvalutionCount;
    if ( [_status staEvalutionCount] > 9999)
    {
        strEvalutionCount = [[NSString alloc] initWithFormat:@"%.1f万", [_status staEvalutionCount] / 10000.0f];
    }
    else
    {
        strEvalutionCount = [[NSString alloc] initWithFormat:@"%d", [_status staEvalutionCount]];
    }
    CGFloat fWidthBtnEvalution = 15 + 2 + [strEvalutionCount sizeWithAttributes:@{NSFontAttributeName:LyStatusButtonNumFont}].width;
    fWidthBtnEvalution = ( fWidthBtnEvalution < 45) ? 45 : fWidthBtnEvalution;
    [btnEvalution setFrame:CGRectMake( btnTransimit.frame.origin.x-horizontalSpace*2-fWidthBtnEvalution, btnTransimit.frame.origin.y, fWidthBtnEvalution, stcBtnFuncHeight)];
    [btnEvalution setNumber:[_status staEvalutionCount]];
    //赞
    NSString *strPraiseCount;
    if ( [_status staPraiseCount] > 9999)
    {
        strPraiseCount = [[NSString alloc] initWithFormat:@"%.1f万", [_status staPraiseCount] / 10000.0f];
    }
    else
    {
        strPraiseCount = [[NSString alloc] initWithFormat:@"%d", [_status staPraiseCount]];
    }
    CGFloat fWidthBtnPraise = 15 + 2 + [strPraiseCount sizeWithAttributes:@{NSFontAttributeName:LyStatusButtonNumFont}].width;
    fWidthBtnPraise = ( fWidthBtnPraise < 45) ? 45 : fWidthBtnPraise;
    [btnPraise setFrame:CGRectMake( btnEvalution.frame.origin.x-horizontalSpace*2-fWidthBtnPraise, btnEvalution.frame.origin.y, fWidthBtnPraise, stcBtnFuncHeight)];
    [btnPraise setNumber:[_status staPraiseCount]];
    
    [btnPraise praise:[_status isPraised]];
    
    [_status setCellHeight:btnPraise.frame.origin.y + btnPraise.frame.size.height + stcVerticalSpace];
    
    switch ( _mode) {
        case LyStatusTableViewCellMode_community: {
            
            _stcHeight = btnPraise.frame.origin.y + btnPraise.frame.size.height + stcVerticalSpace;
            [btnPraise setHidden:NO];
            [btnEvalution setHidden:NO];
            [btnTransimit setHidden:NO];
            break;
        }
        case LyStatusTableViewCellMode_statusDetail: {
            
            [self setSelectionStyle:UITableViewCellSelectionStyleNone];
            _stcHeight = viewPic.frame.origin.y + viewPic.frame.size.height + stcVerticalSpace;
            [btnPraise setHidden:YES];
            [btnEvalution setHidden:YES];
            [btnTransimit setHidden:YES];
            break;
        }
            
        default: {
            _stcHeight = btnPraise.frame.origin.y + btnPraise.frame.size.height + stcVerticalSpace;
            [btnPraise setHidden:NO];
            [btnEvalution setHidden:NO];
            [btnTransimit setHidden:NO];
            break;
        }
    }
    
    
    [horizontalLine setFrame:CGRectMake( 0, _stcHeight-verticalSpace, FULLSCREENWIDTH, verticalSpace)];
}




- (void)stcSetPic
{
    int iPicNum = (int)[[_status picUrls] count];
    
    if ( 0 == iPicNum)
    {
        [viewPic setFrame:CGRectMake( horizontalSpace, tvContent.frame.origin.y+CGRectGetHeight(tvContent.frame), viewPicWidth, 0)];
        [ivPic setHidden:YES];
        [cvPics setHidden:YES];
    }
    else if ( 1 == iPicNum)
    {
        NSArray *allKeys = [[_status picUrls] allKeys];
        UIImage *image = [[_status staPics] objectForKey:[allKeys objectAtIndex:0]];
        CGSize sizeImage;
        if ( !image)
        {
            image = [LyUtil getPicFromServerWithUrl:[[_status picUrls] objectForKey:[allKeys objectAtIndex:0]] isBig:NO];
        }
        sizeImage = image.size;
        
        if ( !image)
        {
            sizeImage = CGSizeMake( picMultiWidth, picMultiHeight);
        }
        
        
        if ( sizeImage.width > sizeImage.height)
        {
            CGFloat fIvHeight = picMaxHeight;
            CGFloat fIvWidthTmp = fIvHeight *sizeImage.width / sizeImage.height;
            CGFloat fIvWidth = ( fIvWidthTmp > viewPicWidth) ? viewPicWidth : fIvWidthTmp;
            [ivPic setFrame:CGRectMake( 0, 0, fIvWidth, fIvHeight)];

        }
        else
        {
            CGFloat fIvWidth = picMultiWidth;
            CGFloat fIvHeight = fIvWidth * sizeImage.height / sizeImage.width;
            [ivPic setFrame:CGRectMake( 0, 0, fIvWidth, fIvHeight)];
            
        }
        [viewPic setFrame:CGRectMake( horizontalSpace, tvContent.frame.origin.y+CGRectGetHeight(tvContent.frame)+verticalSpace, viewPicWidth, CGRectGetHeight(ivPic.frame))];
        [ivPic setHidden:NO];
        [cvPics setHidden:YES];
        
        if ( image)
        {
            [ivPic setImage:image];
        }
        else
        {
            dispatch_queue_t globalQueue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async( globalQueue, ^{
                UIImage *image = [LyUtil getPicFromServerWithUrl:[[_status picUrls] objectForKey:[allKeys objectAtIndex:0]] isBig:NO];
                [_status addPic:image andBigPicUrl:[[_status picUrls] objectForKey:[allKeys objectAtIndex:0]] withIndex:0];
                
                dispatch_async( dispatch_get_main_queue(), ^{
                    [ivPic setImage:image];
                });
            });
        }
    }
    else
    {
        CGFloat cvPicsHeight;
        if ( iPicNum < 3)
        {
            cvPicsHeight = picMultiHeight;
        }
        else
        {
            cvPicsHeight = picMultiHeight * 2.0f + stcPicVerticalMargin * 2.0f;
        }
        
        [cvPics setFrame:CGRectMake( 0, 0, picMultiHeight * 2.0f + stcPicVerticalMargin, cvPicsHeight)];
        
        [viewPic setFrame:CGRectMake( horizontalSpace, tvContent.frame.origin.y+CGRectGetHeight(tvContent.frame)+verticalSpace, viewPicWidth, cvPics.frame.origin.y+CGRectGetHeight(cvPics.frame))];
        
        [ivPic setHidden:YES];
        [cvPics setHidden:NO];
        [cvPics reloadData];
    }
}



- (void)loadImage
{
    int iPicNum = (int)[[_status picUrls] count];
    if ( iPicNum < 1)
    {
        
    }
    else if (iPicNum < 2)
    {
        
    }
    else
    {
        [cvPics reloadData];
    }
}




- (void)stcTrageForButtonItem:(UIButton *)button
{
    if ( statusTableViewCellButtonItemMode_delete == [button tag])
    {
        if ( [_delegate respondsToSelector:@selector(onClickedForBtnDelete:)])
        {
            [_delegate onClickedForBtnDelete:self];
        }
    }
    else if ( statusTableViewCellButtonItemMode_praise == [button tag])
    {
        if ( [_delegate respondsToSelector:@selector(onClickForBtnPraise:)])
        {
            [_delegate onClickForBtnPraise:self];
        }
    }
    else if ( statusTableViewCellButtonItemMode_evalute == [button tag])
    {
        if ( [_delegate respondsToSelector:@selector(onClickForBtnEvalution:)])
        {
            [_delegate onClickForBtnEvalution:self];
        }
    }
    else if ( statusTableViewCellButtonItemMode_transmit == [button tag])
    {
        if ( [_delegate respondsToSelector:@selector(onClickForBtnTransmit:)])
        {
            [_delegate onClickForBtnTransmit:self];
        }
    }

}



- (void)targetForTapGestureForUser:(UITapGestureRecognizer *)tapGesture
{
    if ( [_delegate respondsToSelector:@selector(onClickedForUserByStatusTableViewCell:)])
    {
        [_delegate onClickedForUserByStatusTableViewCell:self];
    }
}


- (void)targetForTapGestureForDetail:(UITapGestureRecognizer *)tag
{
    if ( [_delegate respondsToSelector:@selector(onClickedForDetailByStatusTableViewCell:)])
    {
        [_delegate onClickedForDetailByStatusTableViewCell:self];
    }
}


- (void)targetForTapGesture:(UITapGestureRecognizer *)tap
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = viewPic; // 原图的父控件
    browser.imageCount = [[_status picUrls] count];
    browser.currentImageIndex = 0;
    browser.delegate = self;
    [browser show];
}



#pragma mark -LyStatusPicItemCollectionViewCellDelegate
- (void)picFinishGot:(UIImage *)aImage andUrl:(NSString *)strUrl andCell:(LyStatusPicItemCollectionViewCell*)aCell
{
    NSIndexPath *indexPath = [cvPics indexPathForCell:aCell];
    
    [_status addPic:aImage andBigPicUrl:strUrl withIndex:(int)[indexPath row]];
}




#pragma mark --UICollectionViewDelegate
//UICollectionViewCell被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = cvPics; // 原图的父控件
    browser.imageCount = [[_status picUrls] count];
    browser.currentImageIndex = [indexPath row];
    browser.delegate = self;
    [browser show];
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
    return [[_status picUrls] count];
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LyStatusPicItemCollectionViewCell *tmpCell = [collectionView dequeueReusableCellWithReuseIdentifier:lyStatusPicItemCollctionViewCellReuseIdentifier forIndexPath:indexPath];
    
    if ( tmpCell)
    {
        UIImage *image = [[_status staPics] objectForKey:[[NSString alloc] initWithFormat:@"%d", (int)[indexPath row]]];
        if ( image)
        {
            [tmpCell setPic:image];
        }
        else
        {
            [tmpCell setStrUrl:[[_status picUrls] objectForKey:[[NSString alloc] initWithFormat:@"%d", (int)[indexPath row]]]];
            [tmpCell setDelegate:self];
        }
    }

    return tmpCell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( picMultiWidth, picMultiHeight);
}


//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake( 0, 0, 0, 0);
}

#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [[_status staPics] objectForKey:[[NSString alloc] initWithFormat:@"%d", (int)index]];
}


- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return [NSURL URLWithString:[LyUtil bigPicUrl:[[_status picUrls] objectForKey:[[NSString alloc] initWithFormat:@"%d", (int)index]]]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
