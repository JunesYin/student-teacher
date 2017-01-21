//
//  LyGuiderTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/14.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyGuiderTableViewCell.h"
#import "LyUserManager.h"
#import "LyCurrentUser.h"

#import "UIImageView+WebCache.h"

#import "LyUtil.h"



#define guiderCellWidth                                 SCREEN_WIDTH
CGFloat const guiderCellHeight = 80.0f;


CGFloat const guiderCellHorizontalSpace = 7.0f;

//头像
CGFloat const gtcIvAvatarSize = 45.0f;
//姓名
CGFloat const gtcLbNameHeight = 20.0f;
#define lbNameFont                                      LyFont(16)

//星级
CGFloat const gtIvScoreHeight = 15.0f;
CGFloat const gtIvScoreWidth = 90.0f;


//距离
CGFloat const gtcViewDistanceHeight = gtcLbNameHeight;
CGFloat const gtcIvDistanceSize = 15.0f;


#define lbDistanceFont                                  LyFont(10)

//价格
#define lbPriceWidth
#define lbPriceHeight                                   (gtcLbNameHeight*2)
#define lbPriceFont                                     LyFont(20)

//姓别


//年龄
CGFloat const gtcLbAgeHeight = gtcLbNameHeight;
#define lbAgeFont                                       LyFont(12)

//教龄
CGFloat const gtcLbTeachedAgeHeight = gtcLbNameHeight;
#define lbTeachedAgeFont                                lbAgeFont

//通过率
CGFloat const gtcLbPerPassHeight = gtcLbNameHeight;
#define lbPerPassFont                                   lbAgeFont

//好评率
CGFloat const gtcLbPerPraiseHeight = gtcLbNameHeight;
#define lbPerPraiseFont                                 lbAgeFont


@interface LyGuiderTableViewCell ()
{
    UIImageView             *ivAvatar;       //头像
    UILabel                 *lbName;                //姓名
    UIImageView             *ivScore;        //星级
    UIView                  *viewDistance;
    UIImageView             *ivDistance;
    UILabel                 *lbDistance;            //距离
    UIImageView             *ivSex;          //姓别
    UILabel                 *lbAge;                 //年龄
    UILabel                 *lbTeachAge;            //教车年龄
    UILabel                 *lbPerPass;           //通过率
    UILabel                 *lbPerPraise;         //好评率
}
@end



@implementation LyGuiderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}




- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initAndLayoutSubview];
    }
    
    
    return self;
}



- (void)initAndLayoutSubview
{
    //头像
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake( guiderCellHorizontalSpace, verticalSpace, gtcIvAvatarSize, gtcIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [[ivAvatar layer] setCornerRadius:btnCornerRadius];
    [ivAvatar setClipsToBounds:YES];
    [self addSubview:ivAvatar];
    
    
    //姓名
    lbName = [[UILabel alloc] init];
    [lbName setFont:lbNameFont];
    [lbName setTextColor:LyBlackColor];
    [lbName setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbName];
    
    
    //星级
    ivScore = [[UIImageView alloc] init];
    [ivScore setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:ivScore];
    
    
    //距离
    viewDistance = [UIView new];
    [viewDistance setBackgroundColor:[UIColor clearColor]];
    
    ivDistance = [[UIImageView alloc] initWithFrame:CGRectMake( 0, gtcViewDistanceHeight/2.0f-gtcIvDistanceSize/2.0f, gtcIvDistanceSize, gtcIvDistanceSize)];
    [ivDistance setContentMode:UIViewContentModeScaleAspectFit];
    [ivDistance setImage:[LyUtil imageForImageName:@"ct_location" needCache:NO]];
    
    lbDistance = [[UILabel alloc] init];
    [lbDistance setFont:lbDistanceFont];
    [lbDistance setTextColor:LyBlackColor];
    [lbDistance setTextAlignment:NSTextAlignmentCenter];
    
    [viewDistance addSubview:ivDistance];
    [viewDistance addSubview:lbDistance];
    
    [self addSubview:viewDistance];
    
    
    //姓别
    ivSex = [[UIImageView alloc] init];
    [ivSex setContentMode:UIViewContentModeScaleAspectFit];
    [[ivSex layer] setCornerRadius:ivSexSize/2.0f];
    [ivSex setClipsToBounds:YES];
    [self addSubview:ivSex];
    
    
    //年龄
    lbAge = [[UILabel alloc] init];
    [lbAge setFont:lbAgeFont];
    [lbAge setTextColor:LyBlackColor];
    [lbAge setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbAge];
    
    
    //教车年龄
    lbTeachAge = [[UILabel alloc] init];
    [lbTeachAge setFont:lbTeachedAgeFont];
    [lbTeachAge setTextColor:LyBlackColor];
    [lbTeachAge setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbTeachAge];
    
    
    //通过率
    lbPerPass = [[UILabel alloc] init];
    [lbPerPass setFont:lbPerPassFont];
    [lbPerPass setTextColor:LyBlackColor];
    [lbPerPass setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbPerPass];
    
    
    //好评率
    lbPerPraise = [[UILabel alloc] init];
    [lbPerPraise setFont:lbPerPraiseFont];
    [lbPerPraise setTextColor:LyBlackColor];
    [lbPerPraise setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbPerPraise];
}




- (void)setGuider:(LyGuider *)guider
{
    _guider = guider;
    
    if ( !_guider) {
        return;
    }
    
    
    //头像
    if ( ![_guider userAvatar]) {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:[_guider userId]]
                    placeholderImage:[LyUtil defaultAvatarForTeacher]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

                               if (image) {
                                   [_guider setUserAvatar:image];
                               } else {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:_guider.userId]
                                                       placeholderImage:[LyUtil defaultAvatarForTeacher]
                                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                  if (image) {
                                                                      [_guider setUserAvatar:image];
                                                                  }
                                                              }];
                               }
                           }];
    }
    else
    {
        [ivAvatar setImage:[_guider userAvatar]];
    }
    
    
    //姓名
    NSString *strUserName;
    if ( ![_guider userName] || [[_guider userName] isKindOfClass:[NSNull class]] || [[_guider userName] rangeOfString:@"null"].length > 0 || [[_guider userName] length] < 1)
    {
        strUserName = @"";
    }
    else
    {
        strUserName = [_guider userName];
    }
    CGSize sizeLbName = [strUserName sizeWithAttributes:@{NSFontAttributeName:lbNameFont}];
    [lbName setFrame:CGRectMake( ivAvatar.frame.origin.x+ivAvatar.frame.size.width+guiderCellHorizontalSpace, verticalSpace, sizeLbName.width, gtcLbNameHeight)];
    [lbName setText:[_guider userName]];
    
    
    //星级
    [ivScore setFrame:({
        CGRectMake( lbName.frame.origin.x+lbName.frame.size.width+guiderCellHorizontalSpace, lbName.frame.origin.y+CGRectGetHeight(lbName.frame)/2.0f-gtIvScoreHeight/2.0f, gtIvScoreWidth, gtIvScoreHeight);
    })];
    [LyUtil setScoreImageView:ivScore withScore:[_guider score]];
    
    
    
    //距离
    NSString *strDistance;
    if ( [[LyCurrentUser curUser] location] && [[[LyCurrentUser curUser] location] isValid])
    {
        if ( [_guider distance] > 0 && [_guider distance] < showDistanceMax)
        {
            double distance = fabs([_guider distance]);
            strDistance = [LyUtil getDistance:distance];
            [ivDistance setHidden:NO];
        }
        else
        {
            [ivDistance setHidden:YES];
            strDistance = @"暂无距离信息";
        }
    }
    else
    {
        [ivDistance setHidden:YES];
        strDistance = @"暂无距离信息";
    }
    CGFloat fWidthLbDistance = [strDistance sizeWithAttributes:@{NSFontAttributeName:lbDistanceFont}].width;
    [lbDistance setFrame:({
        CGRectMake( ivDistance.frame.origin.x+CGRectGetWidth(ivDistance.frame), lbName.frame.origin.y, fWidthLbDistance, gtcViewDistanceHeight);
    })];
    [lbDistance setText:strDistance];
    
    [viewDistance setFrame:CGRectMake( guiderCellWidth-horizontalSpace/3.0f-fWidthLbDistance-gtcIvDistanceSize, ivScore.frame.origin.y, fWidthLbDistance+gtcIvDistanceSize, gtcViewDistanceHeight)];
    
    
    //姓别
    [ivSex setFrame:CGRectMake( lbName.frame.origin.x, lbName.frame.origin.y+lbName.frame.size.height+verticalSpace+gtcLbNameHeight/2.0f-ivSexSize/2.0f, ivSexSize, ivSexSize)];
    [LyUtil setSexImageView:ivSex withUserSex:[_guider userSex]];
    
    
    //年龄
    NSString *strLbAge = [[NSString alloc] initWithFormat:@"年龄：%d岁", [_guider userAge]];
    CGSize sizeLbAge = [strLbAge sizeWithAttributes:@{NSFontAttributeName:lbAgeFont}];
    [lbAge setFrame:CGRectMake( ivSex.frame.origin.x+ivSex.frame.size.width+guiderCellHorizontalSpace, lbName.frame.origin.y+lbName.frame.size.height+verticalSpace, sizeLbAge.width, gtcLbAgeHeight)];
    [lbAge setText:strLbAge];
    
    
    //教车年龄
    NSString *strLbTeachedAge = [[NSString alloc] initWithFormat:@"教龄：%d年", [_guider guiTeachedAge]];
    CGSize sizeLbTeachedAge = [strLbTeachedAge sizeWithAttributes:@{NSFontAttributeName:lbTeachedAgeFont}];
    [lbTeachAge setFrame:({
        CGRectMake( lbAge.frame.origin.x+lbAge.frame.size.width+guiderCellHorizontalSpace, lbAge.frame.origin.y, sizeLbTeachedAge.width, gtcLbTeachedAgeHeight);
    })];
    [lbTeachAge setText:strLbTeachedAge];
    
    
    //通过率
    NSString *strLbPerPassNum = [_guider perPass];
    NSString *strLbPerPassTmp = [[NSString alloc] initWithFormat:@"通过率：%@", strLbPerPassNum];
    NSRange rangePerPassNum = [strLbPerPassTmp rangeOfString:strLbPerPassNum];
    NSMutableAttributedString *strLbPerPass = [[NSMutableAttributedString alloc] initWithString:strLbPerPassTmp];
    [strLbPerPass addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:rangePerPassNum];
    CGSize sizeLbPerPass = [strLbPerPassTmp sizeWithAttributes:@{NSFontAttributeName:lbPerPassFont}];
    [lbPerPass setFrame:({
        CGRectMake( ivSex.frame.origin.x, ivSex.frame.origin.y+ivSex.frame.size.height+verticalSpace, sizeLbPerPass.width, gtcLbPerPassHeight);
    })];
    [lbPerPass setAttributedText:strLbPerPass];
    
    
    //好评率
    NSString *strLbPerPraiseNum = [_guider perPraise];
    NSString *strLbPerPraiseTmp = [[NSString alloc] initWithFormat:@"好评率：%@", strLbPerPraiseNum];
    NSRange rangePerPraiseNum = [strLbPerPraiseTmp rangeOfString:strLbPerPraiseNum];
    NSMutableAttributedString *strLbPerPraise = [[NSMutableAttributedString alloc] initWithString:strLbPerPraiseTmp];
    [strLbPerPraise addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:rangePerPraiseNum];
    CGSize sizeLbPerPraise = [strLbPerPraiseTmp sizeWithAttributes:@{NSFontAttributeName:lbPerPraiseFont}];
    [lbPerPraise setFrame:({
        CGRectMake( lbPerPass.frame.origin.x+lbPerPass.frame.size.width+guiderCellHorizontalSpace, lbPerPass.frame.origin.y, sizeLbPerPraise.width, gtcLbPerPraiseHeight);
    })];
    [lbPerPraise setAttributedText:strLbPerPraise];
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
