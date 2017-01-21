//
//  LyCoachTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/16.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyCoachTableViewCell.h"
#import "LyCoach.h"
#import "LyCurrentUser.h"
#import "LyUtil.h"

#import "UIImageView+WebCache.h"

CGFloat const COACHCELLHEIGHT = 110.0f;


//头像
CGFloat const ivAvatarSize = 50.0f;

CGFloat const ctcLbItemHeight = 20.0f;


#define LbNameFont                      LyFont(14)
#define lbPriceFont                     LyFont(24)
#define lbItemFont                      LyFont(12)
#define lbDistanceFont                  LyFont(10)

//星级
CGFloat const ctIvScoreWidth = 90.0f;
CGFloat const ctIvScoreHeight = 15.0f;

//姓别


//距离
CGFloat const ctcViewDistanceHeight = ctcLbItemHeight;
CGFloat const ctcIvDistanceSize = 15.0f;


//价格
CGFloat const COACHCELLPRICEWIDTH = 100;
CGFloat const COACHCELLPRICEHEIGHT = 33;
CGFloat const COACHCELLPRICENUMWIDTH = 60;
CGFloat const COACHCELLPRICENUMHEIGHT = COACHCELLPRICEHEIGHT;
CGFloat const COACHCELLPRICETXTWIDTH = 30;
CGFloat const COACHCELLPRICETXTHEIGHT = COACHCELLPRICEHEIGHT;


CGFloat const lbAllCountHeight = 40.0f;

CGFloat const lbCurLicenseWidth = 50.0f;

@interface LyCoachTableViewCell ()
{
    UIImageView         *ivAvatar;       //头像
    UILabel             *lbName;                //姓名
    UIImageView         *ivScore;        //星级
    UIView              *viewDistance;
    UIImageView         *ivDistance;
    UILabel             *lbDistance;            //距离
    
    UIImageView         *ivSex;          //姓别
    UILabel             *lbAge;                 //年龄
    UILabel             *lbTeachAge;            //教车年龄
//    UIView              *viewPrice;             //价格
    UILabel             *lbPrice;
    UILabel             *lbPerPass;
    UILabel             *lbPerPraise;
    UIView              *horizontalLine;    //横线
    UILabel             *lbTeachAllCount;     //可教学生数
    UILabel             *lbEvalutionCount;         //评价
    
    UILabel             *lbTeachAllPeriod;
    UILabel             *lbCurLicense;
}

@end


@implementation LyCoachTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initAndAddSubView];
    }
    
    return self;
}



- (void)initAndAddSubView {
    //头像
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake( verticalSpace, horizontalSpace, ivAvatarSize, ivAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [[ivAvatar layer] setCornerRadius:btnCornerRadius];
    [ivAvatar setClipsToBounds:YES];
    [self addSubview:ivAvatar];
    
    //姓名
    lbName = [UILabel new];
    [lbName setFont:LbNameFont];
    [lbName setTextColor:LyBlackColor];
    [self addSubview:lbName];
    
    //星级
    ivScore = [UIImageView new];
    [ivScore setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:ivScore];
    
    //距离
    viewDistance = [UIView new];
//    [viewDistance setBackgroundColor:[UIColor whiteColor]];
    ivDistance = [[UIImageView alloc] initWithFrame:CGRectMake( 0, ctcViewDistanceHeight/2.0f-ctcIvDistanceSize/2.0f, ctcIvDistanceSize, ctcIvDistanceSize)];
    [ivDistance setContentMode:UIViewContentModeScaleAspectFill];
    [ivDistance setImage:[LyUtil imageForImageName:@"ct_location" needCache:NO]];
    lbDistance = [UILabel new];
    [lbDistance setFont:lbDistanceFont];
    [lbDistance setTextColor:LyBlackColor];
    
    [viewDistance addSubview:ivDistance];
    [viewDistance addSubview:lbDistance];
    [self addSubview:viewDistance];
    
    
    //姓别
    ivSex = [UIImageView new];
    [ivSex setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:ivSex];
    
    
    //年龄
    lbAge = [UILabel new];
    [lbAge setFont:lbItemFont];
    [lbAge setTextColor:LyBlackColor];
    [self addSubview:lbAge];
    
    //教车年龄
    lbTeachAge = [UILabel new];
    [lbTeachAge setFont:lbItemFont];
    [lbTeachAge setTextColor:LyBlackColor];
    [self addSubview:lbTeachAge];
    

    //价格
//    viewPrice = [UIView new];
//    [self addSubview:viewPrice];
    lbPrice = [UILabel new];
    [lbPrice setFont:lbItemFont];
    [lbPrice setTextColor:Ly517ThemeColor];
    [lbPrice setNumberOfLines:0];
    [self addSubview:lbPrice];
    
    //通过率
    lbPerPass = [UILabel new];
    [lbPerPass setFont:lbItemFont];
    [lbPerPass setTextColor:LyBlackColor];
    [self addSubview:lbPerPass];
    
    //好评率
    lbPerPraise = [UILabel new];
    [lbPerPraise setFont:lbItemFont];
    [lbPerPraise setTextColor:LyBlackColor];
    [self addSubview:lbPerPraise];
    
//    //已教学生数
//    viewTeachedCount = [UIView new];
//    [self addSubview:viewTeachedCount];
    
    //横线
    horizontalLine = [UIView new];
    [horizontalLine setBackgroundColor:LyHorizontalLineColor];
    [self addSubview:horizontalLine];
    
    //累计学员数
    lbTeachAllCount = [UILabel new];
    [lbTeachAllCount setNumberOfLines:0];
    [lbTeachAllCount setTextAlignment:NSTextAlignmentCenter];
    [lbTeachAllCount setFont:lbItemFont];
    [self addSubview:lbTeachAllCount];
    
    
    //评价
    lbEvalutionCount = [UILabel new];
    [lbEvalutionCount setNumberOfLines:0];
    [lbEvalutionCount setTextAlignment:NSTextAlignmentCenter];
    [lbEvalutionCount setFont:lbItemFont];
    [self addSubview:lbEvalutionCount];
    
    
    //总课时数
    lbTeachAllPeriod = [UILabel new];
    [lbTeachAllPeriod setNumberOfLines:0];
    [lbTeachAllPeriod setTextAlignment:NSTextAlignmentCenter];
    [lbTeachAllPeriod setFont:lbItemFont];
    [self addSubview:lbTeachAllPeriod];
    
    
    lbCurLicense = [UILabel new];
    [lbCurLicense setTextAlignment:NSTextAlignmentCenter];
    [lbCurLicense setFont:lbItemFont];
    [lbCurLicense setTextColor:Ly517ThemeColor];
    [self addSubview:lbCurLicense];
}



- (void)setCoach:(LyCoach *)coach
{
    _coach = coach;
    
    if ( !_coach.userAvatar) {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:_coach.userId]
                    placeholderImage:[LyUtil defaultAvatarForTeacher]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if (image) {
                                   [_coach setUserAvatar:image];
                               }
                               else {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:[coach userId]]
                                                       placeholderImage:[LyUtil defaultAvatarForTeacher]
                                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                  if (image) {
                                                                      [_coach setUserAvatar:image];
                                                                  }
                                                              }];
                               }
                           }];
    } else {
        [ivAvatar setImage:_coach.userAvatar];
    }
    
    
    
    
    //绘制姓名
    CGFloat fWidthLbName = [_coach.userName sizeWithAttributes:@{NSFontAttributeName:lbName.font}].width;
    [lbName setFrame:CGRectMake( ivAvatar.frame.origin.x+CGRectGetWidth(ivAvatar.frame)+verticalSpace, ivAvatar.frame.origin.y, fWidthLbName, ctcLbItemHeight)];
    [lbName setText:[_coach userName]];
    
    
    //绘制星级
    [ivScore setFrame:CGRectMake(lbName.frame.origin.x+CGRectGetWidth(lbName.frame)+verticalSpace, lbName.frame.origin.y+CGRectGetHeight(lbName.frame)/2.0f-ctIvScoreHeight/2.0f, ctIvScoreWidth, ctIvScoreHeight)];
    [LyUtil setScoreImageView:ivScore withScore:_coach.score];
    
    
    //绘制距离
    NSString *strDistance;
    if ( [[LyCurrentUser curUser] location] && [[[LyCurrentUser curUser] location] isValid]) {
        if ( [_coach distance] > 0 && [_coach distance] < showDistanceMax) {
            double distance = fabs([_coach distance]);
            strDistance = [LyUtil getDistance:distance];
            [ivDistance setHidden:NO];
        } else {
            [ivDistance setHidden:YES];
            strDistance = @"暂无距离信息";
        }
    } else {
        [ivDistance setHidden:YES];
        strDistance = @"暂无距离信息";
    }

    CGFloat fWidthLbDistance = [strDistance sizeWithAttributes:@{NSFontAttributeName:lbDistance.font}].width;
    [lbDistance setFrame:CGRectMake( ivDistance.frame.origin.x+CGRectGetWidth(ivDistance.frame), 0, fWidthLbDistance, ctcLbItemHeight)];
    [lbDistance setText:strDistance];
    
    [viewDistance setFrame:CGRectMake( SCREEN_WIDTH-2-fWidthLbDistance-ctcIvDistanceSize, lbName.frame.origin.y, fWidthLbDistance+ctcIvDistanceSize, ctcViewDistanceHeight)];
    
    
    //绘制价格
    NSString *strPriceNum = [[NSString alloc] initWithFormat:@"%.0f", _coach.price];
    NSString *strPriceTmp = [[NSString alloc] initWithFormat:@"%@元起", strPriceNum];
    NSMutableAttributedString *strPrice = [[NSMutableAttributedString alloc] initWithString:strPriceTmp];
    [strPrice addAttribute:NSFontAttributeName value:lbPriceFont range:[strPriceTmp rangeOfString:strPriceNum]];
    CGSize sizePrice = [strPriceNum sizeWithAttributes:@{NSFontAttributeName:lbPriceFont}];
//    CGFloat fWidthPrice = sizePriceNum.width + [@"元起" sizeWithAttributes:@{NSFontAttributeName:lbItemFont}].width;
    sizePrice = CGSizeMake(sizePrice.width + [@"元起" sizeWithAttributes:@{NSFontAttributeName:lbItemFont}].width, sizePrice.height);
    [lbPrice setFrame:CGRectMake(SCREEN_WIDTH-verticalSpace-sizePrice.width, lbName.frame.origin.y+CGRectGetHeight(lbName.frame)+verticalSpace, sizePrice.width, sizePrice.height)];
    [lbPrice setAttributedText:strPrice];
    
    //绘制姓别
    [ivSex setFrame:CGRectMake(lbName.frame.origin.x, lbName.frame.origin.y+CGRectGetHeight(lbName.frame)+ctcLbItemHeight/2.0f-ivSexSize/2.0f, ivSexSize, ivSexSize)];
    [LyUtil setSexImageView:ivSex withUserSex:[_coach userSex]];
    
    
    //绘制年龄
    NSString *strAge = [[NSString alloc] initWithFormat:@"年龄：%d岁", _coach.userAge];
    CGFloat fWidthLbAge = [strAge sizeWithAttributes:@{NSFontAttributeName:lbItemFont}].width;
    [lbAge setFrame:CGRectMake(ivSex.frame.origin.x+CGRectGetWidth(ivSex.frame)+verticalSpace, lbName.frame.origin.y+CGRectGetHeight(lbName.frame), fWidthLbAge, ctcLbItemHeight)];
    [lbAge setText:strAge];
    
    
    //绘制教龄
    NSString *strTeachedAge = [[NSString alloc] initWithFormat:@"教龄:%d年", _coach.coaTeachedAge];
    CGFloat fWidthTeachedAge = [strTeachedAge sizeWithAttributes:@{NSFontAttributeName:lbItemFont}].width;
    [lbTeachAge setFrame:CGRectMake(lbAge.frame.origin.x+CGRectGetWidth(lbAge.frame)+verticalSpace, lbAge.frame.origin.y, fWidthTeachedAge, ctcLbItemHeight)];
    [lbTeachAge setText:strTeachedAge];
    
    
    //绘制通过率
    NSString *strPerPassTmp = [[NSString alloc] initWithFormat:@"通过率：%@", [_coach perPass]];
    CGFloat fWidthPerPass = [strPerPassTmp sizeWithAttributes:@{NSFontAttributeName:lbItemFont}].width;
    NSMutableAttributedString *strPerPass = [[NSMutableAttributedString alloc] initWithString:strPerPassTmp];
    [strPerPass addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[strPerPassTmp rangeOfString:[_coach perPass]]];
    [lbPerPass setFrame:CGRectMake(ivSex.frame.origin.x, ivSex.frame.origin.y+CGRectGetHeight(ivSex.frame), fWidthPerPass, ctcLbItemHeight)];
    [lbPerPass setAttributedText:strPerPass];
    
    
    //绘制好评率
    NSString *strPerPraiseTmp = [[NSString alloc] initWithFormat:@"好评率：%@", [_coach perPraise]];
    CGFloat fWidthPerPraise = [strPerPraiseTmp sizeWithAttributes:@{NSFontAttributeName:lbItemFont}].width;
    NSMutableAttributedString *strPerPraise = [[NSMutableAttributedString alloc] initWithString:strPerPraiseTmp];
    [strPerPraise addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[strPerPraiseTmp rangeOfString:[_coach perPraise]]];
    [lbPerPraise setFrame:CGRectMake(lbPerPass.frame.origin.x+CGRectGetWidth(lbPerPass.frame)+verticalSpace, lbPerPass.frame.origin.y, fWidthPerPraise, ctcLbItemHeight)];
    [lbPerPraise setAttributedText:strPerPraise];
    
    
    
    
    //绘制横线
    [horizontalLine setFrame:CGRectMake(ivAvatar.frame.origin.x+CGRectGetWidth(ivAvatar.frame)+horizontalSpace, lbPerPass.frame.origin.y+CGRectGetHeight(lbPerPass.frame), SCREEN_WIDTH, LyHorizontalLineHeight)];
    
    
    //绘制总学员
    [lbTeachAllCount setFrame:CGRectMake(0, horizontalLine.frame.origin.y+CGRectGetHeight(horizontalLine.frame), SCREEN_WIDTH/2.0f, lbAllCountHeight)];
    NSString *strLbTeachAllCountNum = [[NSString alloc] initWithFormat:@"%d人", [_coach coaTeachableCount]];
    NSString *strLbTeachAllCountTmp = [[NSString alloc] initWithFormat:@"%@\n累计学员", strLbTeachAllCountNum];
    NSRange rangeLbTeachAllCountNum = [strLbTeachAllCountTmp rangeOfString:strLbTeachAllCountNum];
    NSMutableAttributedString *strLbTeachAllCount = [[NSMutableAttributedString alloc] initWithString:strLbTeachAllCountTmp];
    [strLbTeachAllCount addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:rangeLbTeachAllCountNum];
    [lbTeachAllCount setAttributedText:strLbTeachAllCount];
    
    
    //绘制评价数
    CGRect rectCtLbEvalutionCount = CGRectMake( lbTeachAllCount.frame.origin.x+lbTeachAllCount.frame.size.width, lbTeachAllCount.frame.origin.y, SCREEN_WIDTH/2.0f, lbAllCountHeight);
    [lbEvalutionCount setFrame:rectCtLbEvalutionCount];
    NSString *strLbEvalutionCountNum = [[NSString alloc] initWithFormat:@"%d条", [_coach coaEvaluationCount]];
    NSString *strLbEvalutionCountTmp = [[NSString alloc] initWithFormat:@"%@\n评价", strLbEvalutionCountNum];
    NSRange rangeLbEvalutionCountNum = [strLbEvalutionCountTmp rangeOfString:strLbEvalutionCountNum];
    NSMutableAttributedString *strLbEvalutionCount = [[NSMutableAttributedString alloc] initWithString:strLbEvalutionCountTmp];
    [strLbEvalutionCount addAttribute:NSForegroundColorAttributeName value:LyGreenColor range:rangeLbEvalutionCountNum];
    
    [lbEvalutionCount setAttributedText:strLbEvalutionCount];
    
    
    
    [lbTeachAllPeriod setFrame:rectCtLbEvalutionCount];
    NSString *strLbTeachAllPeriodNum = [[NSString alloc] initWithFormat:@"%d时", [_coach coaTeachAllPeriod]];
    NSString *strLbTeachAllPeriodTmp = [[NSString alloc] initWithFormat:@"%@\n累计课时", strLbTeachAllPeriodNum];
    NSRange rangeLbTeachAllPeriodNum = [strLbTeachAllPeriodTmp rangeOfString:strLbTeachAllPeriodNum];
    NSMutableAttributedString *strLbTeachAllPeriod = [[NSMutableAttributedString alloc] initWithString:strLbTeachAllPeriodTmp];
    [strLbTeachAllPeriod addAttribute:NSForegroundColorAttributeName value:LyGreenColor range:rangeLbTeachAllPeriodNum];
    [lbTeachAllPeriod setAttributedText:strLbTeachAllPeriod];
    
    
    [lbCurLicense setFrame:CGRectMake( SCREEN_WIDTH-verticalSpace-lbCurLicenseWidth, lbAge.frame.origin.y, lbCurLicenseWidth, ctcLbItemHeight)];
    if ( [_coach timeFlag]) {
        [lbCurLicense setText:[[NSString alloc] initWithFormat:@"%@可约", [LyUtil driveLicenseStringFrom:_coach.userLicenseType]]];
        [lbCurLicense setTextColor:Ly517ThemeColor];
    } else {
        [lbCurLicense setText:@"不可约"];
        [lbCurLicense setTextColor:[UIColor grayColor]];
    }
}





- (void)setMode:(LyCoachTableViewCellMode)mode {
    _mode = mode;
    switch ( _mode) {
        case coachTableViewCellMode_home: {
            [viewDistance setHidden:NO];
            [lbPrice setHidden:NO];
            [lbEvalutionCount setHidden:NO];
            [lbTeachAllPeriod setHidden:YES];
            [lbCurLicense setHidden:YES];
            break;
        }
        case coachTableViewCellMode_mySchool: {
            [viewDistance setHidden:YES];
            [lbPrice setHidden:YES];
            [lbCurLicense setHidden:NO];
            
            if ( [_coach timeFlag]) {
                [lbEvalutionCount setHidden:YES];
                [lbTeachAllPeriod setHidden:NO];
            } else {
                [lbEvalutionCount setHidden:NO];
                [lbTeachAllPeriod setHidden:YES];
            }
            break;
        }
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
