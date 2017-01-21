//
//  LyTrainClassTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/13.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyTrainClassTableViewCell.h"
#import "LyTrainClass.h"
#import "UIViewController+Utils.h"
//#import "LyTrainClassDetailViewController.h"
//#import "LyTrainClassDetailTableViewController.h"

#import "LyUserManager.h"
#import "LyUtil.h"



#define tcWidth                                         SCREEN_WIDTH
CGFloat const tcHeight = 70.0f;


#define tcUpperSpace                                    ((tcHeight-tcLbNameHeight*3-verticalSpace*3)/2)

//课程名
#define tcLbNameWidth
CGFloat const tcLbNameHeight = 15.0f;
#define tcLbNameFont                                    LyFont(14)

//当前优惠数额
#define tcLbFoldNumWidth
CGFloat const tcLbFoldNumHeight = tcLbNameHeight;
#define tcLbFoldNumFont                                 LyFont(12)

//车型
#define tcLbCarTypeWidth
CGFloat const tcLbCarTypeHeight = tcLbNameHeight;
#define tcLbCarTypeFont                                 LyFont(12)

//时间
#define tcLbTimeWidth
CGFloat const tcLbTimeHeight = tcLbNameHeight;
#define tcLbTimeFont                                    tcLbCarTypeFont

//官方价
#define tcLbOfficialPriceWidth
CGFloat const tcLbOfficialPriceHeight = tcLbNameHeight;
#define tcLbOfficialPriceFont                           tcLbCarTypeFont

//优惠价
#define tcLbPreferentialPriceWidth
CGFloat const tcLbPreferentialPriceHeight = tcLbNameHeight;
#define tcLbPreferentialPriceFont                       tcLbCarTypeFont

//“马上报名”按钮
CGFloat const tcBtnApplyWidth = 70.0f;
CGFloat const tcBtnApplyHeight = 30.0f;
#define tcBtnApplyFont                                  tcLbCarTypeFont




@interface LyTrainClassTableViewCell ()
{
    UILabel                                     *lbName;
    UILabel                                     *lbFoldNum;
    UILabel                                     *lbCarType;
    UILabel                                     *lbTime;
    UILabel                                     *lbOfficialPrice;
    UILabel                                     *lbPreferentialPrice;
    
    UIButton                                    *btnApply;
}
@end


@implementation LyTrainClassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initAndAddSubView];
    }
    
    return self;
}


- (void)initAndAddSubView
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundView:({
        UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [backgroudView setBackgroundColor:[UIColor clearColor]];
        backgroudView;
    })];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //课程名
    lbName = [UILabel new];
    [lbName setFont:tcLbNameFont];
    [lbName setTextColor:LyBlackColor];
    [lbName setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbName];
    
    
    //当前优惠数
    lbFoldNum = [UILabel new];
    [lbFoldNum setFont:tcLbFoldNumFont];
    [lbFoldNum setTextColor:Ly517ThemeColor];
    [lbFoldNum setTextAlignment:NSTextAlignmentCenter];
    [[lbFoldNum layer] setCornerRadius:3.0f];
    [[lbFoldNum layer] setBorderWidth:1.0f];
    [[lbFoldNum layer] setBorderColor:[Ly517ThemeColor CGColor]];
    [self addSubview:lbFoldNum];
    
    
    //车型
    lbCarType = [UILabel new];
    [lbCarType setFont:tcLbCarTypeFont];
    [lbCarType setTextColor:LyBlackColor];
    [lbCarType setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbCarType];
    
    
    //时间
    lbTime = [UILabel new];
    [lbTime setFont:tcLbTimeFont];
    [lbTime setTextColor:LyBlackColor];
    [lbTime setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbTime];
    
    
    //官方价
    lbOfficialPrice = [UILabel new];
    [lbOfficialPrice setFont:tcLbOfficialPriceFont];
    [lbOfficialPrice setTextColor:LyBlackColor];
    [lbOfficialPrice setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbOfficialPrice];
    
    
    //优惠价
    lbPreferentialPrice = [UILabel new];
    [lbPreferentialPrice setFont:tcLbPreferentialPriceFont];
    [lbPreferentialPrice setTextColor:LyBlackColor];
    [lbPreferentialPrice setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbPreferentialPrice];
    
    
    
    //“马上报名”按钮
    btnApply = [[UIButton alloc] initWithFrame:CGRectMake( tcWidth-horizontalSpace-tcBtnApplyWidth, tcHeight-tcBtnApplyHeight-horizontalSpace, tcBtnApplyWidth, tcBtnApplyHeight)];
    [btnApply setBackgroundColor:Ly517ThemeColor];
    [btnApply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[btnApply layer] setCornerRadius:5.0f];
    [[btnApply titleLabel] setFont:tcBtnApplyFont];
    [btnApply setTitle:@"马上报名" forState:UIControlStateNormal];
    [btnApply addTarget:self action:@selector(tcTargetForBtnApply) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:btnApply];
}

- (void)setTrainClass:(LyTrainClass *)trainClass
{
    if ( !trainClass)
    {
        return;
    }
    
    
    _trainClass = trainClass;
    
    //课程名
    CGSize sizeLbName = [[_trainClass tcName] sizeWithAttributes:@{NSFontAttributeName:tcLbNameFont}];
    [lbName setFrame:({
        CGRectMake( horizontalSpace, tcUpperSpace, sizeLbName.width, tcLbNameHeight);
    })];
    [lbName setText:[_trainClass tcName]];
    
    
    //当前优惠数额
    float fFoldNum = [_trainClass tcOfficialPrice]-[_trainClass tc517WholePrice];
    if ( fFoldNum - 0.0f > 1.0f)
    {
        NSString *strFoldNum = [[NSString alloc] initWithFormat:@"%.0f", fFoldNum];
        NSString *strLbFoldNumTmp = [[NSString alloc] initWithFormat:@"省%@元", strFoldNum];
        NSRange rangeLbFoldNum = [strLbFoldNumTmp rangeOfString:@"省"];
        NSMutableAttributedString *strLbFoldNum = [[NSMutableAttributedString alloc] initWithString:strLbFoldNumTmp];
        [strLbFoldNum addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeLbFoldNum];
        [strLbFoldNum addAttribute:NSBackgroundColorAttributeName value:Ly517ThemeColor range:rangeLbFoldNum];
        CGSize sizeLbFlodNum = [strLbFoldNumTmp sizeWithAttributes:@{NSFontAttributeName:tcLbFoldNumFont}];
        [lbFoldNum setFrame:CGRectMake( lbName.frame.origin.x+lbName.frame.size.width+horizontalSpace, lbName.frame.origin.y, sizeLbFlodNum.width, tcLbFoldNumHeight)];
        [lbFoldNum setAttributedText:strLbFoldNum];
    }
    
    
    
    //车型
    NSString *strLbCarType = [[NSString alloc] initWithFormat:@"车型：%@", [_trainClass tcCarName]];
    CGSize sizeLbCarType = [strLbCarType sizeWithAttributes:@{NSFontAttributeName:tcLbCarTypeFont}];
    [lbCarType setFrame:CGRectMake( lbName.frame.origin.x, lbName.frame.origin.y+lbName.frame.size.height+verticalSpace, sizeLbCarType.width, tcLbCarTypeHeight)];
    [lbCarType setText:strLbCarType];

    
    
    //时间
    LyUser *master = [[LyUserManager sharedInstance] getUserWithUserId:[_trainClass tcMasterId]];
    if ( LyUserType_guider == [master userType])
    {
        [lbTime setHidden:YES];
    }
    else
    {
        [lbTime setHidden:NO];
        NSString *strLbTime = [[NSString alloc] initWithFormat:@"班别：%@", [LyUtil cutTimeString:[_trainClass tcTrainTime]]];
        CGSize sizeLbTime = [strLbTime sizeWithAttributes:@{NSFontAttributeName:tcLbTimeFont}];
        [lbTime setFrame:CGRectMake( lbCarType.frame.origin.x+lbCarType.frame.size.width+horizontalSpace*2.0f, lbCarType.frame.origin.y, sizeLbTime.width, tcLbTimeHeight)];
        [lbTime setText:strLbTime];
    }
    
    
    
    
    //官方价
    NSString *strLbOfficialPrice = [[NSString alloc] initWithFormat:@"官方价：%.0f", [_trainClass tcOfficialPrice]];
    CGSize sizeLbOfficialPrice = [strLbOfficialPrice sizeWithAttributes:@{NSFontAttributeName:tcLbOfficialPriceFont}];
    [lbOfficialPrice setFrame:CGRectMake( lbCarType.frame.origin.x, lbCarType.frame.origin.y+lbCarType.frame.size.height+verticalSpace, sizeLbOfficialPrice.width, tcLbOfficialPriceHeight)];
    [lbOfficialPrice setText:strLbOfficialPrice];
    
    
    //优惠价
    NSString *strLbPreferentialPriceTmp = [[NSString alloc] initWithFormat:@"优惠价：%.0f", [_trainClass tc517WholePrice]];
    NSRange rangeLbPeerentialPriceNum = [strLbPreferentialPriceTmp rangeOfString:[[NSString alloc] initWithFormat:@"%.0f", [_trainClass tc517WholePrice]]];
    NSMutableAttributedString *strLbPreferentialPrice = [[NSMutableAttributedString alloc] initWithString:strLbPreferentialPriceTmp];
    [strLbPreferentialPrice addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:rangeLbPeerentialPriceNum];
    CGSize sizeLbPreferentialPrice = [strLbPreferentialPriceTmp sizeWithAttributes:@{NSFontAttributeName:tcLbPreferentialPriceFont}];
    [lbPreferentialPrice setFrame:CGRectMake( lbOfficialPrice.frame.origin.x+lbOfficialPrice.frame.size.width+horizontalSpace*2.0f, lbOfficialPrice.frame.origin.y, sizeLbPreferentialPrice.width, tcLbPreferentialPriceHeight)];
    [lbPreferentialPrice setAttributedText:strLbPreferentialPrice];
}



- (void)hideRedunantView:(BOOL)flag
{
    if ( flag)
    {
        [btnApply setHidden:YES];
        
        [lbFoldNum setHidden:YES];
        
        NSString *strLbPreferentialPrice = [[NSString alloc] initWithFormat:@"优惠价：%.0f", [_trainClass tc517WholePrice]];
        [lbPreferentialPrice setText:strLbPreferentialPrice];
    }
    else
    {
        [btnApply setHidden:NO];
        
        [lbFoldNum setHidden:NO];
        
        //优惠价
        NSString *strLbPreferentialPriceTmp = [[NSString alloc] initWithFormat:@"优惠价：%.0f", [_trainClass tc517WholePrice]];
        NSRange rangeLbPeerentialPriceNum = [strLbPreferentialPriceTmp rangeOfString:[[NSString alloc] initWithFormat:@"%.0f", [_trainClass tc517WholePrice]]];
        NSMutableAttributedString *strLbPreferentialPrice = [[NSMutableAttributedString alloc] initWithString:strLbPreferentialPriceTmp];
        [strLbPreferentialPrice addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:rangeLbPeerentialPriceNum];
        CGSize sizeLbPreferentialPrice = [strLbPreferentialPriceTmp sizeWithAttributes:@{NSFontAttributeName:tcLbPreferentialPriceFont}];
        [lbPreferentialPrice setFrame:CGRectMake( lbOfficialPrice.frame.origin.x+lbOfficialPrice.frame.size.width+horizontalSpace*2.0f, lbOfficialPrice.frame.origin.y, sizeLbPreferentialPrice.width, tcLbPreferentialPriceHeight)];
        [lbPreferentialPrice setAttributedText:strLbPreferentialPrice];
        
    }
}


- (void)tcTargetForBtnApply
{
    if ( _delegate && [_delegate respondsToSelector:@selector(onClickBtnApply:)])
    {
        [_delegate onClickBtnApply:self];
    }
}




- (void)setMode:(LyTrainClassTableViewCellMode)mode
{
    _mode = mode;
    switch ( _mode) {
        case trainClassTableViewCellMode_detail: {
            
            [btnApply setHidden:NO];
            [lbFoldNum setHidden:NO];
            
            break;
        }
        case trainClassTableViewCellMode_mySchool: {
            
            [self setSelectionStyle:UITableViewCellSelectionStyleNone];
            [btnApply setHidden:YES];
            [lbFoldNum setHidden:YES];
            [lbPreferentialPrice setTextColor:LyBlackColor];
            break;
        }
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    //     Configure the view for the selected state
    //    [self dstcTargetForBtnApply];
    
    
}

@end
