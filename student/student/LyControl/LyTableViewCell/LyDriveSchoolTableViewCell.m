//
//  LyDriveSchoolTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/5.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyDriveSchoolTableViewCell.h"
#import "LyDriveSchool.h"
#import "LyCurrentUser.h"
#import "LyUtil.h"

#import "UIImageView+WebCache.h"

#define dschtcellWidth                                      SCREEN_WIDTH
CGFloat const dschtcellHeight = 100.0f;

CGFloat const dschtcellHorizontalSpace = 5;
CGFloat const dschtcellVerticalSpace = 7;



CGFloat const dschtcellIvAvatarWidth = 50;
CGFloat const dschtcellIvAvatarHeight = dschtcellIvAvatarWidth;



CGFloat const dschtcellLbNameHeight = 20.0f;

CGFloat const dschtcellIvScoreWidth = 90.0f;
CGFloat const dschtcellIvScoreHeight = 15.0f;



CGFloat const stcViewDistanceHeight = dschtcellLbNameHeight;
CGFloat const stcIvDistanceSize = 15.0f;

#define dschtcellLbStudentInfoWidth
CGFloat const dschtcellLbStudentInfoHeight = dschtcellLbNameHeight;


//报名信息
#define viewSignInfoWidth
CGFloat const viewSignInfoHeight = dschtcellLbNameHeight;

CGFloat const ivSignWidth = dschtcellLbNameHeight;
#define ivSignHeight                                        ivSignWidth

#define lbSignInfoWidth
CGFloat const lbSignInfoHeight = dschtcellLbNameHeight;
#define lbSignInfoFont                                      LyFont(12)



#define dschtcellLbPriceWidth
CGFloat const dschtcellLbPriceHeight = 50;


#define dschtcellNameFont                                   LyFont(14)
#define dschtcellDistanceFont                               LyFont(10)
#define dschStudentInfoFont                                 LyFont(12)
#define dschRangeInfoFont                                   LyFont(12)
#define dschNewsFont                                        LyFont(12)

#define dschPriceTxtFont                                    LyFont(12)
#define dschPriceNumFont                                    LyFont(24)


@interface LyDriveSchoolTableViewCell ()
{
    UIImageView                                 *ivAvatar;
    UILabel                                     *lbName;
    UIView                                      *viewDistance;
    UIImageView                                 *ivDistance;
    UILabel                                     *lbDistance;
    UIImageView                                 *ivScore;
    UILabel                                     *lbStudentInfo;
    UIView                                      *viewSignInfo;
    UIImageView                                 *ivSign;
    UILabel                                     *lbSignInfo;
    UILabel                                     *lbPriceInfo;
}
@end


@implementation LyDriveSchoolTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}




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
    ivAvatar = [UIImageView new];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [ivAvatar setClipsToBounds:YES];
    [[ivAvatar layer] setCornerRadius:btnCornerRadius];
    [self addSubview:ivAvatar];
    
    
    //名称
    lbName = [UILabel new];
    [lbName setFont:dschtcellNameFont];
    [lbName setTextColor:LyBlackColor];
    [self addSubview:lbName];
    
    
    //星级
    ivScore = [UIImageView new];
    [ivScore setContentMode:UIViewContentModeScaleAspectFill];
    [ivScore setClipsToBounds:YES];
    [self addSubview:ivScore];
    
    
    //距离
    viewDistance = [UIView new];
    [viewDistance setBackgroundColor:[UIColor clearColor]];
    
    ivDistance = [[UIImageView alloc] initWithFrame:CGRectMake( 0, stcViewDistanceHeight/2.0f-stcIvDistanceSize/2.0f, stcIvDistanceSize, stcIvDistanceSize)];
    [ivDistance setContentMode:UIViewContentModeScaleAspectFit];
    [ivDistance setImage:[LyUtil imageForImageName:@"ct_location" needCache:NO]];
    
    lbDistance = [UILabel new];
    [lbDistance setFont:dschtcellDistanceFont];
    [lbDistance setTextColor:LyBlackColor];
    [viewDistance addSubview:ivDistance];
    [viewDistance addSubview:lbDistance];
    
    [self addSubview:viewDistance];
    
    
    
    //学员信息
    lbStudentInfo = [UILabel new];
    [lbStudentInfo setFont:dschStudentInfoFont];
    [lbStudentInfo setTextColor:LyDarkgrayColor];
    [self addSubview:lbStudentInfo];
    
    
    viewSignInfo = [[UIView alloc] init];
    
    ivSign = [[UIImageView alloc] initWithFrame:CGRectMake( 0, viewSignInfoHeight/2.0f-ivSignHeight/2.0f, ivSignWidth, ivSignHeight)];
    [ivSign setContentMode:UIViewContentModeScaleAspectFit];
    [ivSign setImage:[LyUtil imageForImageName:@"dschtcell_sign" needCache:NO]];
    lbSignInfo = [UILabel new];
    [lbSignInfo setFont:lbSignInfoFont];
    [lbSignInfo setTextColor:LyDarkgrayColor];
    [lbSignInfo setTextAlignment:NSTextAlignmentLeft];
    
    [viewSignInfo addSubview:ivSign];
    [viewSignInfo addSubview:lbSignInfo];
    
    [self addSubview:viewSignInfo];
    [viewSignInfo setHidden:YES];
    
    
    lbPriceInfo = [UILabel new];
    [lbPriceInfo setTextColor:Ly517ThemeColor];
    [lbPriceInfo setFont:dschPriceTxtFont];
    [self addSubview:lbPriceInfo];
}





- (void)setDriveSchool:(LyDriveSchool *)driveSchool
{
    _driveSchool = driveSchool;
    
    //头像
    [ivAvatar setFrame:CGRectMake( dschtcellHorizontalSpace, dschtcellHeight/2- dschtcellIvAvatarHeight/2, dschtcellIvAvatarWidth, dschtcellIvAvatarHeight)];
    
    if ( ![_driveSchool userAvatar])
    {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:[_driveSchool userId]]
                    placeholderImage:[LyUtil defaultAvatarForTeacher]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if (image)
                               {
                                   [_driveSchool setUserAvatar:image];
                               }
                               else
                               {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:_driveSchool.userId]
                                                       placeholderImage:[LyUtil defaultAvatarForTeacher]
                                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                  if (image)
                                                                  {
                                                                      [_driveSchool setUserAvatar:image];
                                                                  }
                                                              }];
                               }
                           }];
    }
    else
    {
        [ivAvatar setImage:[_driveSchool userAvatar]];
    }

    
    
    //名称
    NSString *strUserName;
    if ( ![_driveSchool userName] || [[_driveSchool userName] isKindOfClass:[NSNull class]] || [[_driveSchool userName] rangeOfString:@"null"].length > 0 || [[_driveSchool userName] length] < 1)
    {
        strUserName = @"";
    }
    else
    {
        strUserName = [_driveSchool userName];
    }
    CGSize sizeLbName = [strUserName sizeWithAttributes:@{NSFontAttributeName:dschtcellNameFont}];
    [lbName setFrame:CGRectMake( ivAvatar.frame.origin.x+ivAvatar.frame.size.width+dschtcellHorizontalSpace, ivAvatar.frame.origin.y-((dschtcellLbNameHeight*3+dschtcellVerticalSpace*2)/2-dschtcellIvAvatarHeight/2), sizeLbName.width, dschtcellLbNameHeight)];
    [lbName setText:[_driveSchool userName]];
    
    
    //星级
    [ivScore setFrame:CGRectMake( lbName.frame.origin.x+CGRectGetWidth(lbName.frame)+dschtcellHorizontalSpace, lbName.frame.origin.y+CGRectGetHeight(lbName.frame)/2.0f-dschtcellIvScoreHeight/2.0f, dschtcellIvScoreWidth, dschtcellIvScoreHeight)];
    [LyUtil setScoreImageView:ivScore withScore:[_driveSchool score]];
    
    
    //距离
    NSString *strDistance;
    if ( [[LyCurrentUser curUser] location] && [[[LyCurrentUser curUser] location] isValid])
    {
        if ( [driveSchool distance] > 0 && [driveSchool distance] < showDistanceMax)
        {
            double distance = fabs([driveSchool distance]);
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
    CGFloat fWidthLbDistance = [strDistance sizeWithAttributes:@{NSFontAttributeName:dschtcellDistanceFont}].width;
    [lbDistance setFrame:CGRectMake( stcIvDistanceSize, 0, fWidthLbDistance, stcViewDistanceHeight)];
    [lbDistance setText:strDistance];
    
    [viewDistance setFrame:CGRectMake( dschtcellWidth-dschtcellHorizontalSpace-fWidthLbDistance-stcIvDistanceSize, ivScore.frame.origin.y, fWidthLbDistance+stcIvDistanceSize, stcViewDistanceHeight)];
    
    
    
    //价格
    NSString *strPriceNum = [[NSString alloc] initWithFormat:@"%.0f", [_driveSchool price]];
    NSString *strPriceTxt = [[NSString alloc] initWithFormat:@"元起"];
    NSString *strPriceInfoTmp = [[NSString alloc] initWithFormat:@"%@%@", strPriceNum, strPriceTxt];
    NSMutableAttributedString *strPriceInfo = [[NSMutableAttributedString alloc] initWithString:strPriceInfoTmp];
    NSRange rangeOfPirceNum = [strPriceInfoTmp rangeOfString:strPriceNum];
    NSRange rangeOfPirceTxt = [strPriceInfoTmp rangeOfString:strPriceTxt];
    [strPriceInfo addAttribute:NSFontAttributeName value:dschPriceNumFont range:rangeOfPirceNum];
    [strPriceInfo addAttribute:NSFontAttributeName value:dschPriceTxtFont range:rangeOfPirceTxt];
    CGSize sizeOfPriceInfoNum = [strPriceNum sizeWithAttributes:@{NSFontAttributeName:dschPriceNumFont}];
    CGSize sizeOfPriceInfoTxt = [strPriceTxt sizeWithAttributes:@{NSFontAttributeName:dschPriceTxtFont}];
    CGFloat lbPirceWidth = sizeOfPriceInfoNum.width + sizeOfPriceInfoTxt.width;
    [lbPriceInfo setFrame:({
        CGRectMake( dschtcellWidth-dschtcellHorizontalSpace-lbPirceWidth, dschtcellHeight/2.0f-sizeOfPriceInfoNum.height/2.0f, lbPirceWidth, sizeOfPriceInfoNum.height);
    })];
//    [lbPriceInfo setBackgroundColor:[UIColor blueColor]];
    [lbPriceInfo setAttributedText:strPriceInfo];
    
    //学员信息
    NSString *strStudentCount = [[NSString alloc] initWithFormat:@"%d", [_driveSchool stuAllCount]];
    NSString *strStudentInfoTmp = [[NSString alloc] initWithFormat:@"%@人已报名", strStudentCount];
    NSMutableAttributedString *strStudentInfo = [[NSMutableAttributedString alloc] initWithString:strStudentInfoTmp];
    NSRange rangeOfSutdentCount = [strStudentInfoTmp rangeOfString:strStudentCount];
    [strStudentInfo addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:rangeOfSutdentCount];
    CGSize sizeLbStudentInfo = [strStudentInfoTmp sizeWithAttributes:@{NSFontAttributeName:dschStudentInfoFont}];
    [lbStudentInfo setFrame:({
        CGRectMake( lbName.frame.origin.x, lbName.frame.origin.y+lbName.frame.size.height+dschtcellVerticalSpace, sizeLbStudentInfo.width, dschtcellLbStudentInfoHeight);
    })];
    [lbStudentInfo setAttributedText:strStudentInfo];
    
    
    if ( ![_driveSchool lastSignInfo] || [[_driveSchool lastSignInfo] isKindOfClass:[NSNull class]] || [[_driveSchool lastSignInfo] isEqualToString:@""])
    {
        [viewSignInfo setHidden:YES];
    }
    else
    {
        CGFloat fWidthLbSignInfo = [[_driveSchool lastSignInfo] sizeWithAttributes:@{NSFontAttributeName:lbSignInfoFont}].width;
        [lbSignInfo setFrame:CGRectMake( ivSign.frame.origin.x+CGRectGetWidth(ivSign.frame), 0, fWidthLbSignInfo, lbSignInfoHeight)];
        [lbSignInfo setText:[_driveSchool lastSignInfo]];
        
        [viewSignInfo setFrame:CGRectMake( lbStudentInfo.frame.origin.x, lbStudentInfo.frame.origin.y+lbStudentInfo.frame.size.height+dschtcellVerticalSpace, fWidthLbSignInfo+ivSignWidth, viewSignInfoHeight)];
        [viewSignInfo setHidden:NO];
    }
    
    
}



- (void)setIsSearching:(BOOL)isSearching {
    lbPriceInfo.hidden = isSearching;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
